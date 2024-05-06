------------------------------------------------------
-- nsm
-- 1, -- 主题内经验相关处理
	-- spin时前端经验先涨，然后后端数据过来后经验再同步
------------------------------------------------------
local THEME_CONTROL_LOCK_LIST   = {
	ENTER_CMD   = "enter_cmd",
	LOAD_RES    = "load_res",
}

local theme_stage_List = {
	base_game	= "BaseGame",
	free_game	= "FreeGame",
	bonus_game  = "BonusGame",
	pick_game   = "PickGame",
	wheel_game  = "WheelGame"
}

local spinIndex = 0

local tag_link_break = 906
local tag_deal_handle = 907

local spineData = require (string.format("Desktop/Theme%d/Theme/SpinConfig", THEME_DESKTOP_ID))

ThemeControl = class("ThemeControl")
function ThemeControl:ctor(theme, curScene)
	-- self.game_store_version = 1
	self.theme 	     = theme
	self.curScene  	 = curScene
	self.curStatus   = nil
	self.header 	 = nil
	self.footer  	 = nil
	self.betControl  = nil
	self.spinCount = nil
	self.lockTagList = {}	
	self.unlockQueue = BoleQueueStack.new()

	for _,theLockName in pairs(THEME_CONTROL_LOCK_LIST) do
		self.lockTagList[theLockName] = true
	end

	-- 初始化theme配置
	self.theme:onInitConfig()
	-- 初始化Control配置
	self:initControlConfig()
end

function ThemeControl:reset( )
	self.isBegCheckEnterTheme = false
	self.spinning = false
	self.spin_processing = false
end

function ThemeControl:getHighRoom()
	local hightId = 1
	if self.theme.themeid then 
		local highLimit = THEME_LIST[self.theme.themeid]['highLimit']
		if highLimit and highLimit == hightId then 
			return true
		end
		return false
	end
	return false
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- loading过程
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:onLoading( CallFunc )
	self:changeScreenAwakeState(true)
	-- bole.enterThemeTime = os.time()
	-- 初始化前后端消息通信
	self:initPotpCmd() 	-- 初始化相关server命令
	-- 显示loadding界面
	self:showLoadingView()
	
	local preLoadResAsyncCall = function ()
		if not self:getThemeId() then -- self.loadingThemeID ~= self:getThemeId() then 
			-- self.loadingThemeID = nil
			return 
		end

		-- 对主题内的资源进行加载
		local loadrestime = os.time()
		local resLoadEndCallFunc = function( )
			local duration = os.time() - loadrestime		
			self.lockTagList[THEME_CONTROL_LOCK_LIST.LOAD_RES] = false
		end
		self.theme:preLoadResAsync(resLoadEndCallFunc)

		-- 对主题内的相关资源进行判断处理
		-- local resCheckEndCallFunc = function( )
		-- 	self.lockTagList[THEME_CONTROL_LOCK_LIST.CHECK_RES] = false
		-- end	
		-- self.theme:checkResAndDeal(resCheckEndCallFunc)
		CallFunc()
	end

	-- 对主题资源进行下载
	self.theme:downloadThemeRes(preLoadResAsyncCall,true)
end

function ThemeControl:showLoadingView( )
	PopupController:getInstance():setPopupState(false)

	local themeId = self:getThemeId()
	local loading = self.theme:getThemeLoaddinView()
	loading:setPercent(0)
	self.curScene:addToLoadding(loading, 100)
	self.loadingView = loading

	-- 如果游戏是竖屏，切换屏幕到竖屏
	if self.theme.isPortrait then 
		local screenCtl = ScreenControl:getInstance()
    	screenCtl:setScreenOrientation(true)
    else
    	local screenCtl = ScreenControl:getInstance()
    	screenCtl:setScreenOrientation(false)
	end
end


function ThemeControl:setBackLobbyBtnState( state, isHide )
	if self.loadingView and self.loadingView.setBackLobbyBtnState then 
		self.loadingView:setBackLobbyBtnState(state, isHide)
	end
end

function ThemeControl:hideLoadingView( )
	local delay = 0
	if self.loadingView then
		delay = self.loadingView:getEndTime()
		self.loadingView:hideOnTime(delay)
		self.loadingView = nil
	end
	PopupController:getInstance():setPopupState(true)
	return delay
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- exit_theme
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:onExit( )	
	self.theme.themeid = nil

	if TimerCallFunc:getInstance().unscheduleGroup then
		TimerCallFunc:getInstance():unscheduleGroup()
	end
	self:changeScreenAwakeState(false)
	-- 卸载相关主题资源
	self.theme:onExit()
	AudioControl:stopAllEffects()
	EventCenter:pushEvent(EVENTNAMES.THEME.STOP_ALL_EFFECTS)
	-- 销毁相关初始配置
	self:unregisterPotpCmds()
	self:removeControlConfig()
	PopupController:getInstance():clearPopupList(true)
	-- LobbyControl:getInstance():sendEnterLobby()
	-- if self.stopControlSchedule then
	-- 	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.stopControlSchedule)
	-- 	self.stopControlSchedule = nil
	-- end
	-- JackpotControl:getInstance():stopJackpotRequest()
	--------------------------------------------------------------------------------
	-- temp_import_1
	-- LevelUpControl:getInstance():onExitTheme()
	--------------------------------------------------------------------------------	
end
function ThemeControl:removeControlConfig( )
    self.spinCounter 	= 0
    self.allrevenue 	= 0
    self.allcost 		= 0
end
function ThemeControl:onEnter( data )
	self:setRequestStatus(true)
	self:setBackLobbyBtnState(false, true)
	self.lockTagList[THEME_CONTROL_LOCK_LIST.ENTER_CMD] = false
	-- 缓存相关数据
	self.enterThemeData = data

	-- 处理jackpot相关
	JackpotControl:getInstance():setJackpot(data["jp_data"])
	JackpotControl:getInstance():resetPreJackpotData()
	PopupController:getInstance():clearPopupList(true)

	-- 循环判断load进度
	self:begCheckEnterTheme(data)
	--------------------------------------------------------------------------------
	-- temp_import_1
	-- LevelUpControl:getInstance():onEnterTheme(self)
	--------------------------------------------------------------------------------
	self.theme.addLoadResCnt()
	self.SpinCount = 0
	-- self.theme:stopActionByTag(tag_link_break)	
end
function ThemeControl:initControlConfig( ... )
	-- 之前多次spin接管缓存逻辑相关
	-- self.require_index 		= nil
	-- self.cacheSpins 	= {}
	----------------------------------------------------------------
	self.cacheSpinRet 	 = nil 		-- spin结果缓冲表，以前每次请求都会请求三次结果，现在只请求一次，用途：多次结果缓冲	
	self.spinCounter 	 = 0 		-- 进入主题后spin的次数
	self.totalWin 		 = 0        -- 玩家花钱拍一次后赢的总金钱数，包括free spin和bonus
	self.allrevenue 	 = 0 		-- 进入主题后所赢的coins数
	self.allcost 		 = 0 		-- 进入主题后所花费的coins数
	self.caches 		 = {} 		-- spin过程中各列临时生产的假reel序列缓冲在此表中，用途：用来做reel滚动显示标准
	self.theCaches 		 = {}       -- 指定key，与棋盘滚轴配合使用
	self.stageName = theme_stage_List.base_game -- 记录当前stage
	self.spinning 		 = false 	-- 当前状态，表示是否正在spin中，用途：判断是否滚轴在滚动中	
	self.spin_processing = false 	-- 用于判断当前spin是否已经全部处理完
	self.specialSpeed    = false 	-- 当前滚轴是否需要特殊加速	
	self.haveSpeedSmybol = false    -- 滚轴结果中是否存在特殊的 加速smybol
	----------------------------------------------------------------
	self.autoSpin	 		= nil 	-- auto状态，默认不开启，用途：autospin状态
	self.autoSpinCacheCnt 	= nil	
	----------------------------------------------------------------
	self.freewin 				= nil  		-- freespin期间所win金币数，存在且大于0，表示在freespin中，用途：判断是否在freesping中，表示freespin所赢coins
	self.freespin 				= nil		-- freespin剩余次数，默认值为0
	self.freeSpinsCacheCnt 		= nil   	-- freespin期间已累计spin次数
	self.freeItem 				= nil 		-- 进入freespin时的item_list，用途：freespin结束后的现场还原	
	self.freeWinPos             = nil       -- 进入freespin时的win_pos，用途：freespin结束后的现场还原中奖连线
	self.freeSpeical            = nil       -- 进入freespin时的speical_pos，用途：freespin结束后的现场还原free item 动画
	self.bonusItem  			= nil 		-- 进入freespin时的item_list，用途：freespin结束后的现场还原
	self.bonusRet  				= nil 		-- 进入freespin时的item_list，用途：freespin结束后的现场还原
	----------------------------------------------------------------
	self.spinCD 		= self.theme.spinTimeConfig["base"] -- 72/60 --106-24    -- 从spin开始计时，自动stop最短时间间隔	-- 通过方法获得 每个主题特定的时间
	self.specialAccelerationCD = 0 -- 向匀速运动中添加的时间，用来进行特殊的加速控制
	self.spinMinCD 		= self.theme.spinTimeConfig["spinMinCD"]--50/60      	 -- 从spin开始计时，stop按钮可点击最短时间间隔	
	----------------------------------------------------------------
	-- 初始化进入主题时的棋盘布局列表
	self:initKeyListWithEnterTheme()

	-- self.levelup 				= {} 		-- 缓冲的升级信息，通过此表来判断是否要弹相应的升级弹窗 	-- temp_nsm
	-- self.dialogCallbackStack 	= {} 														-- temp_nsm		
end
function ThemeControl:initKeyListWithEnterTheme( )
	-- self.theCaches = {
	-- 	{[-1]=0,[0]=1,[1]=2,[2]=3,[3]=4,[4]=5,[5]=1},
	-- 	{[-1]=0,[0]=1,[1]=2,[2]=3,[3]=4,[4]=5,[5]=1},
	-- 	{[-1]=0,[0]=1,[1]=2,[2]=3,[3]=4,[4]=5,[5]=1},
	-- 	{[-1]=0,[0]=1,[1]=2,[2]=3,[3]=4,[4]=5,[5]=1},
	-- 	{[-1]=0,[0]=1,[1]=2,[2]=3,[3]=4,[4]=5,[5]=1},
	-- 	{[-1]=0,[0]=1,[1]=2,[2]=3,[3]=4,[4]=5,[5]=1},
	-- }
	local tb = self.theme:fixEnterBoard()
	if tb then self.theCaches = tb end
end
-- 循环遍历loading进度
function ThemeControl:begCheckEnterTheme( data )
	if self.isBegCheckEnterTheme and not self.isEnteredInboxFs then return end
	self.isEnteredInboxFs = false
	self.isBegCheckEnterTheme = true
	local scheduleInterval 	  = 0.2
	local waitTime = 0
	local logCount = 0
	local function schedulerFunc( )
		local canEnter = true
		for theLockName,theTag in pairs(self.lockTagList) do
			if theTag then
				canEnter = false
				break
			end
		end
		if not canEnter then
			waitTime = waitTime + scheduleInterval
			if not self.lockTagList[THEME_CONTROL_LOCK_LIST.LOAD_RES] then
				local needlog = false
				if waitTime > 4 and logCount == 0 then
					logCount = 1
					self.theme:tryLoadPlistImages()
					needlog = true
				elseif waitTime > 8 and logCount == 1 then
					logCount = 2
					self.theme:tryLoadPlistImages()
					needlog = true
				elseif waitTime > 10 then
					logCount = 3
					canEnter = true
					needlog = true
				end
				if needlog then
					local tid = 000
					if self.theme and self.theme.themeid then
						tid = self.theme.themeid
					end
				end
			end
		end
		if canEnter then
			local tid = 000
			if self.theme and self.theme.themeid then
				tid = self.theme.themeid
			end
			self:onEnterTheme(data)

		else
			self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(scheduleInterval),cc.CallFunc:create(schedulerFunc)))
		end		
	end
	schedulerFunc()
end
function ThemeControl:onEnterTheme( data )

	data = self.theme:adjustEnterThemeRet(data)
	self.needRecord = true
	self.errorCount = 0
	if data["inbox_fs_count"] and self.theme.themeid == data["inbox_fs_theme"] then 
		if data["bonus_game_id"] then data["bonus_game_id"] = nil end
		if data["free_normal_spins"] then data["free_normal_spins"] = nil end
		if data["free_spins"] then data["free_spins"] = nil end

		data["free_spins"] = data["inbox_fs_count"]
		data["free_spin_bet"] = data["inbox_fs_bet"]
		data["free_spin_total"] = data["inbox_fs_total"]
		self.isEnteredInboxFs = true
	else
		self.isEnteredInboxFs = false
	end

	-- default_bet：初始化的total bet
	-- bet_per_line：当前游戏可选的total bet表
	local saveBet = cc.UserDefault:getInstance():getDoubleForKey("default_bet", 0)
	self.defaultBet = saveBet > 0 and saveBet or data["default_bet"]
	self.nowBetList = data["bet_per_line"]
	self.saveBet = saveBet

	-- max_lines：游戏支持的最大payline数量
	self.maxLine 	= data["max_lines"]
	self.payline    = self.maxLine

	self.featureMul = data["feature_bet_mul"] or 0
	-- 对curBet 和 betList 进行了初始化
	self.betControl = BetControl.new(self) 
	self.betControl:initBetControl()
	-- 假滚轴相关	
	if data["theme_reels"] then
		self.theme_reels = data["theme_reels"]
		self:resetCurrentReels(false)
	end

	---------------------- 初始化-------------------------------
	-- local delay1 = self.theme:getStartAniTime()

	-- 初始化主题内部布局
	self.theme:onEnter()
	EventCenter:pushEvent(EVENTNAMES.THEME.INIT_THEME_OVER, {})
	
	-- 根据数据进行相关调整（bonus,jackpot,feature等界面相关调整，通过该函数进行初始化）
	self.theme:adjustTheme(data)

	-- 进行模块化处理
	self.enterThemeDealList = {}

	local featureType = 0
	-- 断电重连后，bonus数据存放在该字段
	if data["bonus_game"] then
		featureType = 2
		self.enterThemeDealList["bonus_game"] = data["bonus_game"]
	
		-- {
		-- 	["theme_respin"]		= data["bonus_game"]["theme_respin"],
		-- 	["respin_bet"] 			= data["bonus_game"]["bet"] -- == 0 and data["default_bet"] or data["respin_bet"],
		-- 	["theme_respin_count"] 	= data["bonus_game"]["theme_respin_count"],
		-- 	["item_list"]			= data["bonus_game"]["item_list"],
		-- 	["total_win"]			= data["bonus_game"]["total_win"],
		-- 	-- ["respin_win"]   = data["free_spin_win"] -- 原来赢过的金钱
		-- }
		-- if data["bonus_muti"] then
		-- 	self.enterThemeDealList["respin_data"]["bonus_muti"] = data["bonus_muti"]
		-- end
		-- if data["base_win"] then
		-- 	self.enterThemeDealList["respin_data"]["base_win"] = data["base_win"]
		-- end
	end

    -- 断电重连后，如果不需要恢复free Pick spin场景，数据处理后放在该字段
	if data["free_pick_game"] and data["free_game"] then
	    self.enterThemeDealList["free_pick_game"] = data["free_pick_game"]
	    self.enterThemeDealList["free_game_for_pick"] = data["free_game"]
	end


	-- 断电重连后，如果不需要恢复free spin场景，而是正常进入free spin，数据处理后放在该字段
	if data["first_free_game"] then
		self.enterThemeDealList["first_free_game"] = data["first_free_game"]
	end

	-- 断电重连后，如果需要恢复free spin场景，free game的数据存在该字段
	if data["free_game"] then 
		self.enterThemeDealList["free_game"] = data["free_game"]
		if data["free_game"]["free_spins"] then
			if data["free_game"]["free_spins"] > 0 then
			   self.enterThemeDealList["spin_free_game"] = true
			elseif data["free_game"]["free_spins"] == 0 then
				-- 添加一个finish_ad的字段
				self.collectAdFinish = data["free_game"]["finish_ad"]
				self.enterThemeDealList["collet_free_game"] = true
			end
		end
	end
	--进入游戏后，先恢复base game或者 free spin场景，然后再恢复bonus
	local delay = self:hideLoadingView()
	local enterCallFunc = function()
		self:dealEnterProcessAndEnterTheme()
	end
	self.curScene:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function()
			if self.theme.runStartAni then
				self.theme:runStartAni()
			end

			self.betControl:refreshCurBet()
			self.theme:onEnterTheme(enterCallFunc)

			if libUI.isValidNode(self.combatMatchView) then
				local isMove = not next(self.enterThemeDealList)
				if next(self.enterThemeDealList) then
					if self.enterThemeDealList["collet_free_game"] then
						isMove = false
					elseif self.enterThemeDealList["spin_free_game"] then
						isMove = true
					end
				end
				self.combatMatchView:openBgSpineOnTheme(isMove)
			end
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			EventCenter:pushEvent(EVENTNAMES.THEME.ON_ENTER_THEME, {
				themeCtl = self,
				themeId = self.theme.themeid,
			})
		end)
	))

	self:setGoldSpinHideGameRuleList()
end

function ThemeControl:canShowStartAni()
	if SingleCombatController:getInstance():isPlayMatchOnTheme() then
		return false
	end

	local ani_tag = "ani_tag" .. self.theme.themeid
	if User:getInstance()[ani_tag] then
		return false
	end

    return true
end

function ThemeControl:setStartAniTag()
	local ani_tag = "ani_tag" .. self.theme.themeid
	User:getInstance()[ani_tag] = true
end

function ThemeControl:showMoveNode()
    EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_SHOW_QUIET)
    -- self.footer:showFooter()
    -- self.header:showHeader()
    -- self.footer:setSpinButtonState(false)
    -- self.footer:enableOtherBtns(true)
end

function ThemeControl:hideMoveNode()
    EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_QUIET)
    -- self.footer:hideFooter()
    -- self.header:hideHeader()
    -- self.footer:setSpinButtonNormal(true)
    -- self.footer:enableOtherBtns(false)
end

function ThemeControl:lockThemeFooter( )
	self.footer:enableOtherBtns(false)
end
function ThemeControl:unlockThemeFooter( )
	self.footer:enableOtherBtns(true)
end
function ThemeControl:dealEnterProcessAndEnterTheme( )
	local theDealList = self.enterThemeDealList

	self:changeSpinOrFeatureState(true)

	if theDealList["free_game"] then
		-- 恢复free spin的场景（但不spin）
		self:dealFreeGameData(theDealList["free_game"])
	elseif theDealList["bonus_game"] then
		-- 恢复bonus场景
		self:dealBonusGameData(theDealList["bonus_game"])
	elseif theDealList["free_pick_game"] then
		-- 恢复Pick Game 场景
		self:dealFreePickGameData(theDealList["free_pick_game"],theDealList["free_game_for_pick"])
	elseif theDealList["first_free_game"] then 
		-- 正常进入free spin（通常是恢复bonus和free同时触发的场景）
		self:dealFirstFreeSpinData(theDealList["first_free_game"])
	elseif theDealList["spin_free_game"] then
		self:dealFreeSpinData(theDealList["spin_free_game"])
	elseif theDealList["collet_free_game"] then
		-- 恢复Free game Collect弹板
		self:dealFreeCollectData(theDealList)
	else
		self:changeSpinOrFeatureState(false)
	end
end

function ThemeControl:dealFreePickGameData(theFreePickData,theFreeSpinData)	
    self:lockThemeFooter()
	-- 恢复Free Pick数据
	local rets = {}
	rets["free_random_pick"] = theFreePickData

    -- 做特殊行为，如设置Footer 上 Retrigger之前的个数
	if self.theme.enterThemeByFreePickGame then self.theme:enterThemeByFreePickGame(theFreePickData,theFreeSpinData) end

	self.enterThemeDealList["free_pick_game"] = nil
	self.enterThemeDealList["free_game_for_pick"] = nil

	local endCallFunc = function()
		self.rets = nil
		self:dealEnterProcessAndEnterTheme()
	end

	self:free_random_pick(rets,endCallFunc)
end

function ThemeControl:dealBonusGameData(theBonusGameData)
	-- 记录stage name
	self.stageName = theme_stage_List.bonus_game

	-- 恢复total bet
	local bonusSpinBet = theBonusGameData["bet"]
	if bonusSpinBet then 
		self:setPointBet(bonusSpinBet)
	end

	-- 恢复total win
	self.totalWin = self.totalWin or 0
    theBonusGameData["base_win"] = theBonusGameData["base_win"] or 0
	self.totalWin = self.totalWin + theBonusGameData["base_win"]
	self:updateFooterCoin()
	if self.freewin then self.freewin = self.totalWin end
	self.rets = theBonusGameData
	-- 禁掉footer上的按钮
	self:lockThemeFooter()

	local endCallFunc = function()
		if self:noFeatureLeft() then self:enterBaseGameStage() end
		-- self:handleResult()
		self.rets = nil
		self.isRespin = false
		self:dealEnterProcessAndEnterTheme()
	end
	self.enterThemeDealList["bonus_game"] = nil
	if self.theme.enterThemeByBonus then self.theme:enterThemeByBonus(theBonusGameData, endCallFunc) end
end

function ThemeControl:dealFirstFreeSpinData(theFreeSpinData)

	-- 恢复total bet
	local freeSpinBet = theFreeSpinData["bet"]
	if freeSpinBet then self:setPointBet(freeSpinBet) end

	-- 恢复total win
	self.totalWin = self.totalWin or 0
	if self.totalWin == 0 then self.totalWin = theFreeSpinData["total_win"] end
	self:updateFooterCoin()

	self.freeItem 		= theFreeSpinData.item_list

	-- 禁掉footer上的按钮
	self:lockThemeFooter()

	local endCallFunc = function()
		self:dealEnterProcessAndEnterTheme()
	end

	self.enterThemeDealList["first_free_game"] = nil

	if self.rets == nil then self.rets = {} end
	if self.theme.enterThemeByFirstFreeSpin then self.theme:enterThemeByFirstFreeSpin(self.rets, theFreeSpinData, endCallFunc) end

end


-- function ThemeControl:dealFreeGameData( theFreeGameData ) -- 进入
-- 	-- print("whj: theFreeGameData: ",tool.lua_to_json(theFreeGameData))
-- 	-- 恢复total bet


-- 	-- 恢复total win
-- 	self.totalWin = self.totalWin or 0
-- 	if self.totalWin == 0 then self.totalWin = theFreeGameData["total_win"] end
-- 	self:updateFooterCoin()

--     -- 传给Theme Recover标志位 -- 更新部分 需要特殊计数的设置值
--     self.theme:setFreeGameRecoverState(theFreeGameData)

-- 	-- 恢复X of Y
-- 	local freeSpinCnt = theFreeGameData["free_spins"] or 0
-- 	if freeSpinCnt <= 0 then 
-- 		local freeSpinBet = theFreeGameData["bet"]
-- 		if freeSpinBet then
-- 			self:setPointBet(freeSpinBet)
-- 		end

-- 		if self.theme.showFreeCollectBoardOnRecover then
-- 			self.theme:showFreeCollectBoardOnRecover(theFreeGameData)
-- 		else
-- 			-- 收钱协议 后端
-- 			self:collectCoins(0)
-- 			-- rollup结束后把钱加到header上
-- 			self:updateFooterCoin()
-- 			self:addCoinsToHeader()

-- 			self:removePointBet() -- 解除bet 锁定
-- 			self.enterThemeDealList["free_game"] = nil
-- 			self:dealEnterProcessAndEnterTheme()
-- 		end
		
-- 	else
-- 		self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
-- 		self.freespin   	= freeSpinCnt
-- 		self.freewin 		= self.totalWin or 0 -- 0
-- 		self.freeItem 		= theFreeGameData.item_list

-- 		-- 恢复free spin场景
-- 		self.theme:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
-- 		self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
-- 		self:runFreeSpinStage()
-- 		self:adjustWithFreeSpin()

-- 		local freeSpinBet = theFreeGameData["bet"]
-- 		if freeSpinBet then
-- 			self:setPointBet(freeSpinBet)
-- 		end

-- 		if self.theme.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
-- 			self.theme:resetPointBet()
-- 		end
-- 		self.enterThemeDealList["free_game"] = nil
-- 		self:dealEnterProcessAndEnterTheme()
-- 	end
-- 	-- local freeSpinBet = theFreeGameData["bet"]
-- 	-- if freeSpinBet then
-- 	-- 	self:setPointBet(freeSpinBet)
-- 	-- end
-- end

function ThemeControl:dealFreeGameData( theFreeGameData ) -- 进入
	-- print("whj: theFreeGameData: ",tool.lua_to_json(theFreeGameData))
	-- 恢复total bet

	-- 恢复total win
	self.totalWin = self.totalWin or 0
	 
	if self.totalWin == 0 then self.totalWin = theFreeGameData["total_win"] end
	self:updateFooterCoin()

    -- 传给Theme Recover标志位 -- 更新部分 需要特殊计数的设置值
    self.theme:setFreeGameRecoverState(theFreeGameData)

	-- 恢复X of Y
	local freeSpinCnt = theFreeGameData["free_spins"] or 0
	if freeSpinCnt < 0 then
		local freeSpinBet = theFreeGameData["bet"]
		if freeSpinBet then
			self:setPointBet(freeSpinBet)
		end

		-- 收钱协议 后端
		self:collectCoins(0)
		-- rollup结束后把钱加到header上
		self:updateFooterCoin()
		self:addCoinsToHeader()

		self:removePointBet() -- 解除bet 锁定
		self.enterThemeDealList["free_game"] = nil
		self:dealEnterProcessAndEnterTheme()

	elseif freeSpinCnt == 0 then -- 恢复FreeCollect 弹板
       
		self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
		self.freespin   	= freeSpinCnt
		self.freewin 		= self.totalWin or 0 -- 0
		self.freeItem 		= theFreeGameData.item_list

		-- 恢复free spin场景
		self.theme:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
		self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
		self:runFreeCollectSpinStage()
		 -- 禁掉footer上的按钮
	    self:lockThemeFooter()
		self:adjustWithFreeSpin()

		local freeSpinBet = theFreeGameData["bet"]
		if freeSpinBet then
			self:setPointBet(freeSpinBet)
		end

		if self.theme.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
			self.theme:resetPointBet()
		end
		self.enterThemeDealList["free_game"] = nil
		self:dealEnterProcessAndEnterTheme()		
	else
		self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
		self.freespin   	= freeSpinCnt
		self.freewin 		= self.totalWin or 0 -- 0
		self.freeItem 		= theFreeGameData.item_list

		-- 恢复free spin场景
		self.theme:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
		self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
		self:runFreeSpinStage()
		self:adjustWithFreeSpin()

		local freeSpinBet = theFreeGameData["bet"]
		if freeSpinBet then
			self:setPointBet(freeSpinBet)
		end

		if self.theme.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
			self.theme:resetPointBet()
		end
		self.enterThemeDealList["free_game"] = nil
		self:dealEnterProcessAndEnterTheme()
	end
	-- local freeSpinBet = theFreeGameData["bet"]
	-- if freeSpinBet then
	-- 	self:setPointBet(freeSpinBet)
	-- end
end

function ThemeControl:dealFreeSpinData( theFreeSpinData )
	-- 记录stage name
	self.stageName = theme_stage_List.free_game
	EventCenter:pushEvent(EVENTNAMES.THEME.IS_IN_FREE)

	local delay = self.theme.themeid == 101 and 1.6 or 1.7
	self.theme:laterCallBack(delay, function ()
		self:toSpin()
		self:dealEnterProcessAndEnterTheme()
	end)
	self.enterThemeDealList["spin_free_game"] = nil
end

function ThemeControl:dealFreeCollectData(rets)
	self.stageName = theme_stage_List.free_game
	EventCenter:pushEvent(EVENTNAMES.THEME.IS_IN_FREE)

	-- 禁掉footer上的按钮
	self:lockThemeFooter()

	if self.rets then return end
	local ret = {}

	if self.theme.setDealFreeCollectState then 
		self.theme:setDealFreeCollectState()
	end

	self.footer:setSpinStateOnFinishSpin(true)
	self:finshSpin(ret)
	self.enterThemeDealList["collet_free_game"] = nil
end


function ThemeControl:dealJackpotData( theJackpotData )
	local endCallFunc = function()
		self.enterThemeDealList["jackpot_data"] = nil
		self:dealEnterProcessAndEnterTheme()
	end
	self:showJackpotBetDialog(data.jackpot_bet, endCallFunc)
end

function ThemeControl:dealThemeData( theThemeData )
	-- todo
	self.enterThemeDealList["theme_data"] = nil
	self:dealEnterProcessAndEnterTheme()
end
function ThemeControl:dealFreeNormalSpinData( theFreeNormalSpinData )
	-- todo
	self.enterThemeDealList["free_normal_spin_data"] = nil	
	self:dealEnterProcessAndEnterTheme()
end
function ThemeControl:dealFreeSpinGame(theFreeSpinGameData)
	local free_spins_game_data = theFreeSpinGameData
	local endCallFunc = function()
		self.enterThemeDealList["theFreeSpinGameData"] = nil
		self:dealEnterProcessAndEnterTheme()
	end
	self:free_spins_game( free_spins_game_data ,endThemeCallfunc )
	
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- footer相关逻辑
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- auto_spin相关
function ThemeControl:enableAuto( enable )
	self.autoSpin = enable
	self:changeScreenAwakeState(enable)
	self.footer:enableAuto(enable)
	if enable then
		self:toSpin()
	else
		self.autoSpinFast = false
	end
end

function ThemeControl:isAutoSpinFast()
	return self.autoSpinFast
end

function ThemeControl:setAutoSpinFast(bool)
	self.autoSpinFast = bool
end

function ThemeControl:setAutoSpinCount( count )
	if count and type(count) ~= "number" then
		self.autoSpinFast = true
		self.autoSpinCount = nil
		return 
	end

	self.autoSpinCount = count
	self.footer:setAutoplayRemaining(self.autoSpinCount)
end

-- footer_spin_按钮逻辑相关
function ThemeControl:touchSpinCheckDealAutoSpin( )
	local retBreakTouch = false
	self.touchSpinTag   = false
	self.autoSpinAction = nil
	self.autoSpinCache  = self.autoSpinCache or 0
	self.autoSpinCache  = self.autoSpinCache + 1
	if self.autoSpin then
		retBreakTouch = true	
		self:enableAuto(false)	
	end
	return retBreakTouch
end
function ThemeControl:touchSpinBtnBegan( spinBtn )
	if tolua.isnull(self.theme) or tolua.isnull(self.theme.spinLayer) then return end
	if not self.isRespin and self.isProcessing then return end
	self.outOfCoinsShowing = false
	self.touchSpinTag   = true
	local tempCache 	= self.autoSpinCache
	if not self.isRespin then

		self.autoSpinAction = cc.Sequence:create(
			cc.DelayTime:create(0.15), 
			cc.CallFunc:create(function()
				if self.footer and libUI.isValidNode(self.footer) then
					self.footer:playSpinChargeSpine()
				end
			end),
			cc.DelayTime:create(1 - 0.15), 
			cc.CallFunc:create(function()
				if self.autoSpinAction and tempCache==self.autoSpinCache then
					if not (self.theme.checkInFeature and self.theme:checkInFeature()) then 
						--self:enableAuto(true)
						if not self:getGoldSpinStatus() then
							self.footer:displayAutoplayInterface(true)
						else
							self.footer:setAutoplayCount(self:getGoldSpinToken())
						end
						bole.playMusic("12_Autospin", nil, nil, "sounds/")

						self.footer:hideSpinChargeSpine()
					end
					self.autoSpinAction = nil
				end
			end)
		)
		self.theme.spinLayer:runAction(self.autoSpinAction)
	end
end
function ThemeControl:touchSpinBtnEnded( spinBtn )
	if tolua.isnull(self.theme) or tolua.isnull(self.theme.spinLayer) then return end
	self.touchSpinTag = true
	if not self.touchSpinTag then return end
	if self.autoSpinAction then
		self.theme.spinLayer:stopAction(self.autoSpinAction)
    	self.autoSpinAction = nil
	end
    if self.isRespin then
    	if self.spinning then
			self:fastStopRespin()
		end
    elseif not self.autoSpin then
    	if self.spinning then
    		if not self.isProcessing then
        		self:fastStop()
        	end
    	else
			if self.outOfCoinsShowing then
				return false
			end
			-- print("zhf tospin touchSpinBtnEnded")
            self:toSpin()
			self.theme:dealMusic_TouchBtnSpinMusic()
    	end
    end
end
function ThemeControl:touchSpinBtnCanceled( spinBtn )
	self.autoSpinAction = nil
	self.touchSpinTag   = false
end

function ThemeControl:adjustActivity()
	if self.theme.down_node and SHRINKSCALE_H == 1 then
		local scale = THEME_LIST[self.theme.themeid]["questScale"]
		if scale then
			self.theme.down_node:setScale(scale)
			if self.theme.setDownNodeScale then
				self.theme:setDownNodeScale(scale)
			end
		end
	end
	if self.theme.middle_node and SHRINKSCALE_H == 1 then
		local scale = THEME_LIST[self.theme.themeid]["questScale"]
		if scale then
			self.theme.middle_node:setScale(scale)
		end
	end
end

function ThemeControl:resetReelScale( ... )
	if self.theme.down_node and SHRINKSCALE_H == 1 then
		self.theme.down_node:setScale(1)
	end

	if self.theme.middle_node and SHRINKSCALE_H == 1 then
		self.theme.middle_node:setScale(1)
	end
end

function ThemeControl:setFooterStopBtn( )
	if self.cacheSpinRet and self.theme:checkCanSetStopBtn(self.cacheSpinRet) then
		self.footer:setStopBtn()
	end
end

-- total win 相关
function ThemeControl:updateFooterCoin()
	local coins = self.totalWin or 0
	if coins > 0 then 
		self.footer:setWinCoins(coins, 0, 0)
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------
-- spin相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:toSpin( statusStr )
	-- 处理AutoPlay计数，计数为0时停止auto spin
	if self.autoSpin and not self.freewin then
		if not self:isAutoSpinFast() and self.autoSpinCount then
			self:setAutoSpinCount(self.autoSpinCount - 1)
			if self.autoSpinCount <= 0 then
				self:enableAuto(false)
			end
		end
	end

	if self.spinning then return end
	if self.spin_processing then return end
	self.spin_processing = true

	self:changeSpinOrFeatureState(true)
	-- bole.potp:send("disconnect", {})

	local function callback( )
		self.spinCounter = self.spinCounter + 1
		self:spin()
	end
	self.theme:spinControl( callback, statusStr )
end

function ThemeControl:spin( )
	-- User:getInstance().is_Spining = true
	if self.freewin then
		self.free_spins_cache_cnt = self.free_spins_cache_cnt or 0
		self.free_spins_cache_cnt = self.free_spins_cache_cnt + 1
	else
		self.free_spins_cache_cnt = 0
	end
	if not self.freespin or self.freespin < 1 then
		EventCenter:pushEvent(EVENTNAMES.THEME.START_SPIN, {
			themeId = self.theme.themeid,
		})
		-- self:removeBetCoins()
		local tBet = self:getCurTotalBet()
		--判断当前筹码是否足够
		local user = User:getInstance()
		if not user:addCoins(tBet*-1) then
			self:out_of_coins()
			self.spin_processing = false
			self:changeSpinOrFeatureState(false)
			return
		end
		user:refreshHeaderCoins()

	else
		self.freespin = self.freespin - 1
		self:adjustWithFreeSpin()
	end
	self.isRespin = false
	self.spinning = true
	self.needShowRateUs = false
	self:cleanStatusWithSpin()
	-- 处理header金币滚动相关

	
	-- self.header:checkCleanCoinsAdd()

	-- 缩回钱袋
	if not self.autoSpin and not self.freewin then
		EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.C_SHOW_TIP, {show = false, quiet = false})
	end
	
	-- 锁住大厅按钮
	self.theme:lockLobbyBtn()
	-- spin扩展点
	self.theme:onSpinStart()
	
	self.footer:onSpinStart()
	-- 向后端请求spin数据
	self:requestSpin()
	-- 让棋盘roll起来
	self.theme:spinBoard()
	-- 在新的一次bet中清零totalWin
	if self.stageName == theme_stage_List.base_game then self.totalWin = 0 end
end
function ThemeControl:spinExpLimit( tBet )
	local user = User:getInstance()
	local level = user.level
	local df = user.getDiamondLevel
	local r = math.min(math.floor(tBet), math.floor((df(pkg, level+1) - df(pkg, level)) / 
		(math.pow(level,0.7) - math.pow(level,0.4) + SPIN_EXP_LIMIT_PARAM)))
	return r
end
function ThemeControl:adjustWithFreeSpin()
	-- self.theme:showFreeSpinNode(self.freespin, self.sumFreeSpinCnt, not self.freeItem)
	self.theme:updatedFreeSpinCount(self.freespin, self.sumFreeSpinCnt)
end
function ThemeControl:cleanStatusWithSpin( ) -- 进行 特殊加速的状态清除
	self.cacheSpinRet 	= nil
	self.rets 			= nil
	self.specials 		= nil
	self.winRet 		= nil
	self.lockTime 		= nil

	self.specialSpeed = false
	self.haveSpeedSmybol = false

	self.curScene:stopActionByTag(tag_deal_handle)
	self:clearAnimate()
	-- 不可删除，此次数据非滚动状态归0（此处不针对非滚动状态）
	-- if not self.freewin then 
	-- end
	self.theme:cleanStatus()
end

function ThemeControl:removeBetCoins( ) --User和Header减去Bet的Coin
	local tBet = self:getCurTotalBet()
	local user = User:getInstance()
	if not user:addCoins(-tBet, 1) then
		self:out_of_coins()
		if self.theme and  self.theme.refreshNotEnoughMoney then
			self.theme:refreshNotEnoughMoney()   -- added by rwb,钱不够时，释放收集条等的锁住状态

		end
		self.spin_processing = false
		self:changeSpinOrFeatureState(false)
		return
	end
	-- user:refreshHeaderCoins()
end


function ThemeControl:requestSpin(...)

	self.spinCount = self.spinCount or 0
    self.spinCount = self.spinCount + 1
	--单机，自定义数据
    local spinDadaIndex = 0
	-- if THEME_DESKTOP_ID == 164 then
		local key = "spinIndex" .. THEME_DESKTOP_ID
		--单机，自定义数据
		--local randomNum = math.random(1, #spineData)
		local storeSpin = cc.UserDefault:getInstance():getIntegerForKey(key)
		if storeSpin then
			spinIndex = storeSpin
		end
		spinIndex = spinIndex + 1
		if spinIndex >= #spineData then
			spinIndex = 1
		end
		spinDadaIndex = spinIndex
		cc.UserDefault:getInstance():setIntegerForKey(key, spinIndex)
	-- else
	-- 	local randomNum = math.random(1, #spineData)
	-- 	spinDadaIndex = randomNum
	-- end

	local data = {list = {spineData[spinDadaIndex]}}
	self:dealRequestSpinResult(data)

	local curBet = self:getCurBet()
	local autoSpinStatus = self.autoSpin and 1 or 0
	
		self.spinRequestTime = os.time()

	if not self.freewin then
		if self.saveBet ~= curBet  then
			self.saveBet = curBet
			cc.UserDefault:getInstance():setDoubleForKey("default_bet", curBet)
		end
	end
	self.theme:startCalculateRequestTime(true) -- whj 添加用来计算开始spin到来结果的时间不超过25s
end	
-----------------------------------------------------------------------------------------------------------------------------------------------
-- spin结果处理相关
-----------------------------------------------------------------------------------------------------------------------------------------------
local freecount =0
local Fcount = 0

function ThemeControl:AddFakeData(data)
	if data and data["list"] and data["list"][1] and data["list"][1]["item_list"] then 
		local dataList = data["list"][1]
		local item_list_down = dataList["item_list_down"] or {{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1}}
		local item_list_up = dataList["item_list_up"] or {{1},{1},{1},{1},{1}}

		self.resultCache = {}
		self.resultCoinsCache = {}
	
		for k,v in pairs (dataList["item_list"]) do

			local reelList = tool.tableClone(v)
			
			table.insert(reelList,1,item_list_up[k][1]) -- 插入 第一条数据
			
			if self.theme.isTurbo then
				for i=1,(#item_list_down[k])/2 do -- 插入后面几条数据
					reelList[#reelList+1] = item_list_down[k][i]
				end
			else
				for i=1,#item_list_down[k] do -- 插入后面几条数据
					reelList[#reelList+1] = item_list_down[k][i]
				end
			end

			
			table.insert(self.resultCache,reelList)
		end
	end
	-- dump(self.resultCache, "self.resultCache=")
	return data
end 

function ThemeControl:dealRequestSpinResult( data )
	local result = data['list'] and data['list'][1] or nil

	data = self:AddFakeData(data)
	if data['list'] and not self.cacheSpinRet and not self.rets then
		self.cacheSpinRet = data['list'][1]
		
		local stopCalls = function()
			-- local timeInterval = (os.time() - self.spinRequestTime)
			-- local interval1 = self.spinCD - timeInterval
			-- interval1 = interval1 > 0 and interval1 or 0
			TimerCallFunc:getInstance():addCallFunc(function()
				self.spinRequestTime = self.spinRequestTime or 0
				local timeInterval = (os.time() - self.spinRequestTime)
				local autoFlag = self.autoSpin and 1 or 0
				local maxBetFlag = self:checkIsMaxBet() and 1 or 0
				local height = self:getHighRoom() and 1 or 0
				local game_type = 0
				local flag = "bet" .. self.theme.themeid
				local lastBet = cc.UserDefault:getInstance():getIntegerForKey(flag, 0)
				local curBet = self:getCurBet()

				self:normalStop(timeInterval)
				local interval = self.theme.ExtraStopCD
				if self:isAutoSpinFast() and self.theme.canFastStop then
					self.curScene:runAction(
						cc.Sequence:create(
							cc.DelayTime:create(interval),
							cc.CallFunc:create(function()
								self:fastStop()
							end)))
				else
					if not self.autoSpin and self.theme.canFastStop then
						-- local function delayShowStop( )
						-- 	self:setFooterStopBtn()
						-- end
						-- self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(interval),cc.CallFunc:create(function()
						-- 	delayShowStop()
						-- end)))
					end
				end
			end, 0)

		end

		if PopupController:getInstance():isPopupProcessing() then
			if self.stopControlSchedule then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.stopControlSchedule)
				self.stopControlSchedule = nil
			end

			self.stopControlSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
	    		if not PopupController:getInstance():isPopupProcessing() then
	    			self.theme:stopControl( self.cacheSpinRet, stopCalls )

	    			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.stopControlSchedule)
					self.stopControlSchedule = nil
	    		end
	    	end, 1, false)
		else
			self.theme:stopControl( self.cacheSpinRet, stopCalls )
		end
		
	end	
end

function ThemeControl:onSpinResult( ret )
	-- freespin 无
	if not self.freewin then
		self.header:showPigSavingPotAnimation()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- stop相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:normalStop(interval)
	if not self.cacheSpinRet then return end
	self:stop(self.cacheSpinRet,interval)
end

function ThemeControl:fastStop( ) -- qiucksstop
	if not self.cacheSpinRet then return end
	self.footer:onFastStop()
	-- self:stop(self.cacheSpinRet)
	self.theme:fastStopBoard()
end

function ThemeControl:stop( ret,interval )
	if self.rets then return end
	self.rets = ret
	if self.rets["total_win"] > 0 then
		self.rets["setWinCoins"] = 1
	end

	if self.rets["theme_info"] then
		self.rets["theme_data"] = 1
		-- self.rets["theme_info"]["big_win_type"] = ret["big_win_type"]
	end

	-- control_add_delay必须存在
	self.rets["control_add_delay"] 	= 0
	self.rets["finish_actions"] = 1

	-- self.rets["rate_us"] = 1

	if self.rets["6ofakind"] and not self.rets["win_type"] then
		self.rets["n_of_a_kind"] = 6
		self.rets["6ofakind"] = nil
	end
	if self.rets["5ofakind"] and not self.rets["win_type"] then
		self.rets["n_of_a_kind"] = 5
		self.rets["5ofakind"] = nil
	end
	
	local winCoins = self.rets["total_win"] or 0
	local totalBet = self:getCurTotalBet()
	if (winCoins/totalBet) > 15 then
		self.rets["special_effect"] = true
	end	
	self:onStop_at_firstTime(self.rets) -- 显示是否升级，经验变化 DailyBonus经验变化和 特殊连线
	self.theme:onSpinStop(self.rets) -- 执行 长条symbol 进行分析 和每个主题的特殊 需求 比如 disk
	self:onStop_at_afterTheme(self.rets) -- 是否中jackpot 和 bonus 
	self.theme:adjustThemeReels(self.rets) -- 调整滚轴 看是否有需求
	self:adjustRecData(self.rets) -- 中奖连线配置
	self.theme:adjustRecData(self.rets) -- 没有东西了
	self:stopReels(self.rets,interval) -- 停止滚轴

	
	return true
end

function ThemeControl:onStop_at_firstTime( ret )

	-- 更新unlock列表
	if ret["unlock"] then
		self:handleUnlockData(ret["unlock"])
		ret["theme_unlock"] = true
	end
	-- -- free spin里不需要播放
	-- if not self.freewin then
	-- 	self.header:showPigSavingPotAnimation()
	-- end
end

function ThemeControl:onStop_at_afterTheme( ret )
	if ret["jackpot_game"] or ret["bonus_game"] then
		self.theme.playGame = true
	end
end

function ThemeControl:adjustRecData( ret )
	local themeType = self.theme:getThemeType()
	self.winCRPosGroupList = {}
	self.winWays  = nil
	self.winLines = nil
	if themeType and themeType=="ways" and ret["win_ways"] then
		ret["win_pos_list"] = {}
		local tagCRList = {}
		for _, winWayData in ipairs(ret["win_ways"]) do
			local posList = winWayData["win_pos"]
			for _, crPos in ipairs(posList) do
				tagCRList[crPos[1]] = tagCRList[crPos[1]] or {}
				tagCRList[crPos[1]][crPos[2]] = true
			end
		end
		for col, colList in pairs(tagCRList) do
			for row, _ in pairs(colList) do
				table.insert(ret["win_pos_list"], {col, row})
			end
		end
		self.winWays = ret["win_ways"]
	elseif themeType and themeType=="payLine" and ret["win_lines"] then
		local winls    = ret["win_lines"]
		local winLines = {}
		for i=1, #ret["win_lines"] do
			table.insert(winLines, {winls[i]['line'], winls[i]['count'], winls[i]['symbol'], winls[i]['reverse'],
					 	 col_ck = winls[i]['col_ck'] or 0, play_idx = winls[i]['play_idx']})
		end
		self.winLines = winLines
	end
end
function ThemeControl:setStopEndFunc( theEndFunc ) -- 目前 可以用来做延迟使用（滚轴停止之后 延迟 调用结算self:handleResult()方法）
	self.stopEndFunc = theEndFunc
end
function ThemeControl:stopReels( ret ,interval)
	-- 对结果进行分析	
	self:genSpecials()
	self:genSpecialSymbolState(ret)
	local endCallFunc = function()
		local nextCallFunc = function()
			self.spinning = false
			-- self.isRespin = false
			self.theme:onAllReelStop()
			self:handleResult()
		end
		if self.stopEndFunc then
			self.stopEndFunc(nextCallFunc)
			self.stopEndFunc = nil
		else
			nextCallFunc()
		end
	end
	-- 根据结果，播放stop过程
	self.theme:stopBoard(ret, endCallFunc, interval)
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- respin相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:respin( canStopDelay, respinStopCallFunc )
	if self.spinning then return end
	if not self.rets then return end
	self.spinning 			= true
	self.isRespin 			= true
	self.respinStopTag 		= true
	self.respinStopEndFunc 	= respinStopCallFunc
	self.theme:onRespinStart()
	self.footer:onRespinStart()
	self.theme:spinBoard("respin")
	------------------------------------------------
	self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(canStopDelay or 1),cc.CallFunc:create(function()
		if self:isAutoSpinFast() then
			self:fastStopRespin()
		elseif not self.autoSpin then 
			self:setFooterStopBtn()
		end
		self:normalStopRespin()
	end)))
end
function ThemeControl:normalStopRespin( )
	self:stopRespin()
end
function ThemeControl:fastStopRespin( )
	self:stopRespin()
	self.footer:onRespinFastStop()
	self.theme:fastStopBoard()
end
function ThemeControl:stopRespin( )
	if not self.respinStopTag then return end
	self.respinStopTag = false
	self.rets["control_add_delay"] 	= 0
	self.theme:onRespinStop(self.rets)
	self:genSpecials()
	self:genSpecialSymbolState(self.rets)
	-- local itemList  = self.rets["reelItem_list"] or self.rets["item_list"] -- 修改逻辑 拿假 拼接之后的list 来进行停止滚轴的操作
	local endCallFunc = function()
		local nextCallFunc = function()
			self.spinning = false
			-- self.isRespin = false
			self.theme:onAllReelStop()
			self.footer:onAllReelStop()
			self:handleResult()
		end
		if self.respinStopEndFunc then
			self.respinStopEndFunc(nextCallFunc)
			self.respinStopEndFunc = nil
		else
			nextCallFunc()
		end
	end
	self.theme:stopBoard(self.rets, endCallFunc,1)
	return true
end

function ThemeControl:onRespinOver() -- whj 添加
	if self:noFeatureLeft() then 
		self.footer:onRespinOver()-- 激活spin按钮，控制成可以点击状态
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- 结果统计分析
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:genSpecials( ... )
	self.theme:genSpecials( ... )
end
function ThemeControl:genSpecialSymbolState( ... )
	self.theme:genSpecialSymbolState( ... )	
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- 棋盘落定后相关逻辑
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:getHandleProcess( ... )
	return {
			{"jackpot_sync_data", 	self.jackpot_sync_data}, -- 应该作用是分析jackpot 数据吧 --  灭有看到具体的实现样子
			{"control_add_delay",	self.control_add_delay}, -- 延迟 是一定存在的
			--代金券
			{"spin_win_voucher",	self.handle_win_voucher},
			{"theme_deal_data", 	self.theme.theme_deal_data, self.theme}, -- 直接清空状态了
			{"theme_deal_show", 	self.theme.theme_deal_show, self.theme}, -- 控制播放动画的 应该是合图动画
			{"theme_respin", 		self.theme.theme_respin, self.theme},    -- respin逻辑
			{"level_up",			self.save_level_up},
			{"vip_level_up",		self.vip_level_up},
			{"theme_unlock",        self.theme_unlock},
			------------------------------------------------------------------------------------
			{"theme_data",			self.handle_themeinfo},
			{"n_of_a_kind",			self.play_n_of_a_kind},
			{"win_type",			self.play_win_effect}, -- bigwin 或者 其他大奖赢钱之后 被调用的 动画
			{"jackpot_win", 		self.jackpot_win},
			------------------------------------------------------------------------------------
			{"before_win_show", 	self.before_win_show}, -- 赢钱之前的操作，进行类似的 显示wild倍数
			{"setWinCoins", 		self.setWinCoins}, 
			{"setFeatureWinCoins", 	self.setFeatureWinCoins}, 
			------------------------------------------------------------------------------------
			{"after_win_show", 		self.theme.after_win_show, self.theme}, -- 赢钱完成之后的操作，进行类似的 wild增加 jackpot 的操作
			{"jackpot_game", 		self.jackpot_game},			
			{"spin_wheel", 			self.spin_wheel}, -- 不知道是个啥
			{"bonus_game", 			self.bonus_game},
			{"free_random_pick", 	self.free_random_pick},	-- pick free	
			{"free_spins",			self.free_spins},			
			{"booster_tips",		self.booster_tips},
			{"finish_actions",	    self.finish_actions}, -- 所有行为结束的时候，需要干的事情，比如解锁地图
		} 
end

function ThemeControl:noFeatureLeft()
	local no_feature_left = true

	-- 判断正常状态下是否有未处理的feature
	if self.rets and (self.rets["bonus_game"] or self.rets["free_random_pick"] or self.rets["free_spins"]) then no_feature_left = false end

	-- 判断退出重连状态下是否有未处理的feature
	if self.enterThemeDealList and (self.enterThemeDealList["bonus_game"] or self.enterThemeDealList["first_free_game"] or self.enterThemeDealList["spin_free_game"] or self.enterThemeDealList["free_pick_game"]) then no_feature_left = false end

	-- 如果主题有特殊feature
	if no_feature_left then
	   if self.theme.noFeatureLeft then no_feature_left = self.theme:noFeatureLeft() end
	end

	-- 判断是否在free stage
	if self.freewin then no_feature_left = false end


	return no_feature_left
end

function ThemeControl:inSpinOrFeature( )
	local spin_or_feature = false
	if self.spin_processing or (not self:noFeatureLeft()) then 
		spin_or_feature = true
	end
	return spin_or_feature
end

function ThemeControl:changeSpinOrFeatureState( state )
	local data = { ["spin_or_feature"] = state }
	EventCenter:pushEvent(EVENTNAMES.THEME.SPIN_OR_FEATURE, data)
end

function ThemeControl:handleResult()
	if not self.rets then return end
	local process = self:getHandleProcess()
	self.isProcessing  = true	
	for i=1,#process do
		local aa = process[i]
		if self.rets[aa[1]] and aa[2] then
			aa[2](aa[3] or self, self.rets)
			return
		end
	end
	self:finshSpin(self.rets)
end

function ThemeControl:dealStateWithFinishSpin( isCollectFreeSpin )
	self.footer:onFinishSpin()

	self.theme:finshSpin()
	self.isProcessing 	= false
	if self.autoSpin or (self.freespin and self.freespin > 0) then 
		-- print("zhf dealStateWithFinishSpin start spin")
		local delay = 0.8
		if isCollectFreeSpin then
			delay = 0.3
		elseif self.rets and self.rets["total_win"] and self.rets["total_win"]>0 then
			delay = 1
		end

		if self.theme.dealDelayBeforeFreeSpin then
			local d = self.theme:dealDelayBeforeFreeSpin()
			if delay < d then
				delay = d
			end
		end
		local cacheSpinCounter = self.spinCounter
		if self.isFirstFreeGame then
			self.isFirstFreeGame = false
			if self.theme.FirstFreeGameDelay == 0 then
				self:toSpin()
			else
				delay = self.theme.FirstFreeGameDelay;
				self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function( ... )
					self:toSpin()
				end)))
			end			
		else
			TimerCallFunc:getInstance():addCallFunc(function()
				if cacheSpinCounter == self.spinCounter then
					self:toSpin()
				end
			end, delay)
		end

	end

end
function ThemeControl:finshSpin( rets, endSpinCallFunc )
	self:playRateUs(rets["rate_us"])
	self.isRespin = false
	if not self.freespin or self.freespin < 1  then
		if self.freewin then
			local endCallFunc = function( )
				self:spin_end()
				self.theme:unlockLobbyBtn()
				self.theme:setDelayToFadeOutLoopMusic() -- 新增，静音音效

				self:changeScreenAwakeState(false)
				-- User:getInstance():addCoins(self.freewin)
				-- User:getInstance():setFreeWin(self.freewin)				
				self.freewin = nil
				self:dealStateWithFinishSpin(true)		
			end			
			local delay = 0
			if self.theme.dealDelayBeforeFreeSpin then
				local d = self.theme:dealDelayBeforeFreeSpin()
				if delay < d then
					delay = d
				end
			end
			
			self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function( ... )
				self.theme:stopDrawAnimate()
				self:collectFreeSpin(endCallFunc)
			end)))
		else
			self:spin_end()
			self.theme:unlockLobbyBtn()
			self.theme:setDelayToFadeOutLoopMusic() -- 新增，静音音效
	    end
	else
		self:spin_end()
	end
	if not self.freewin then
		-- 升级后需要从服务器取jackpot数据
		if self.isLevelUp then
			self.isLevelUp = false
			JackpotControl:getInstance():updateJackpot()
		end
		self.betControl:refreshBetList()
	end

	EventCenter:pushEvent(EVENTNAMES.THEME.FINISH_SPIN, {
		themeId = self.theme.themeid,
		data = self.rets,
	})

	self:dealStateWithFinishSpin(false)
end

function ThemeControl:changeScreenAwakeState(keepOn)
	if keepOn or self.autoSpin or self.freewin then
		bole.keepScreenAwake(true)
	else
		bole.keepScreenAwake(false)
	end
	
end

function ThemeControl:drawAnimate( ret )
	local delay = 0
	if ret["win_pos_list"] and #ret["win_pos_list"]>0 then
		if self.winWays then
			delay = self.theme:drawWaysThemeAnimate(self.winWays, self.theme.spinLayer, ret, self.specials)
		elseif self.winLines then
			delay = self.theme:drawLinesThemeAnimate(self.winLines, self.theme.spinLayer, ret, self.specials)
		end
	end
	return delay
end	
-- 延时相关
function ThemeControl:control_add_delay( ret )
	local delay = ret["control_add_delay"] or 0
	ret["control_add_delay"] = nil
	local curTime = os.time()
	local objTime = curTime+delay
	if self.lockTime and self.lockTime>objTime then
		delay = self.lockTime-curTime
	end
	local act = cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
		-- 初始化footer win上数据为0
		if not self.freewin then
			-- 此处不知道为什么要清一次数据
			-- self.footer:checkCleanCoinsAdd()
		end
		self:handleResult()			
	end))
	act:setTag(tag_deal_handle)
	self.curScene:runAction(act)
end

function ThemeControl:addTimeLockWithDelay( addDelay )
	local theLockTime = os.time() + addDelay
	if self.lockTime and self.lockTime>theLockTime then
		-- todo
	else
		self.lockTime = theLockTime
	end	
end

-- 
function ThemeControl:handle_themeinfo(ret)
	ret["theme_data"] = nil
	
	local onEnd = function( )
		self:handleResult()
	end
	self.theme:onThemeInfo(ret,onEnd)
	
end

function ThemeControl:handle_win_voucher(ret)
	-- local tbl = {
	-- 	_baseCtl = self,
	-- 	_baseView = self.theme,
	-- 	_spinLayer = self.theme.spinLayer,
	-- 	_curScene = self.curScene,
	-- }
	-- VoucherController:getInstance():handle_win_voucher(ret, tbl)
end

function ThemeControl:showCellsVoucherLogoFast(colid, cell, nIndex, bHide)
	-- VoucherController:getInstance():showCellsVoucherLogoFast(colid, cell, nIndex, bHide)
end

function ThemeControl:handle_SpecialWin(ret)
	local wintype = ret["hasSpecialWin"]
	ret["hasSpecialWin"] = nil;
	local delay = self.theme:onSpecialWin(wintype)
	self.theme:dealMusic_SetLoopMusic(0.3)
	TimerCallFunc:getInstance():addCallFunc(function()
		self.theme:dealMusic_SetLoopMusic(1)
	 	self:handleResult()
	end, delay) -- 时间可调控
end

function ThemeControl:play_n_of_a_kind( ret )	
	local theNCnt = ret['n_of_a_kind']
	ret['n_of_a_kind'] = nil
	-- FiveOfKindEffect.new(theNCnt):show(self.theme)
	self:handleResult()
end
function ThemeControl:play_win_effect( ret ) -- big win 之类的大奖中间操作 可以添加相关操作 不同等级的赢钱
	ret["win_type"] = nil
end
-- jackpot相关
function ThemeControl:jackpot_sync_data( ret )
	-- 后续参照forever实现
	local theSyncData = ret["jackpot_sync_data"]
	ret["jackpot_sync_data"] = nil
	if self.theme.syncJackpotData then
		local endCallfunc = function( )
			self:handleResult()
		end
		self.theme:syncJackpotData(theSyncData,endCallfunc)
	else 
		self:handleResult()
	end		
end

function ThemeControl:jackpot_game( ret )	
	local theGameData = ret["jackpot_game"]
	ret["jackpot_game"] = nil
	local endCallfunc = function( )
		self:handleResult()
	end
	self:playJackpotGame(theGameData, endCallfunc)
end

function ThemeControl:jackpot_win( ret )
	--local winCoins = ret["jackpot_win"]
	ret["jackpot_win"] = nil

	local onEnd = function( )
		self:handleResult()
	end
	if self.theme.onJackpotWin then
	   self.theme:onJackpotWin(ret,onEnd)
	else
		onEnd()
	end
end

function ThemeControl:before_win_show( ret )
	--local winCoins = ret["jackpot_win"]
	ret["before_win_show"] = nil

	local onEnd = function( )
		self:handleResult()
	end
	if self.theme.beforeWinShow then
	   self.theme:beforeWinShow(ret,onEnd)
	else
		onEnd()
	end
end

-- 转盘相关
function ThemeControl:spin_wheel( ret ,endThemeCallfunc)

	-- 记录当前stage
	self.stageName 		= theme_stage_List.wheel_game

	self.theme:dealMusic_MuteLoopMusic()
	local theGameData      = ret["spin_wheel"]
	ret["spin_wheel"] = nil
	local theSpecials 	= self.specials
	local endCallfunc   = endThemeCallfunc or function()
		self:handleResult()
	end

	if self.theme.enterSpinWheel then 
		self.theme:enterSpinWheel(ret, theGameData, endCallfunc) 
	else
		endCallfunc()
	end

	-- 原来的 逻辑
	-- local index = ret["spin_wheel"]
	-- ret["spin_wheel"] = nil
	-- ret["free_spins_game"] = {index = index}
	-- self:handleResult()
end

-- bonus_game相关
function ThemeControl:bonus_game( ret )
	-- 记录当前stage
	self.stageName 		= theme_stage_List.bonus_game

	local theGameData 	= ret["bonus_game"]
	ret["bonus_game"] 	= nil
	-- whj 添加逻辑 special_type 状态重置
	ret["special_type"]	= nil
	local endCallfunc 	= function( )
	    if self.theme:canShowJackpotNotification() then
		   JackpotControl:getInstance():showSelfJackpotNotification()
		end

		-- ret["item_list"] = ret["oldItemList"]
		if self:noFeatureLeft() then self:enterBaseGameStage() end
		self:handleResult()
	end
	ret["oldItemList"] = tool.tableClone(ret["item_list"])
	self:playBonusGame(theGameData, endCallfunc)
end
-- level_up
function ThemeControl:save_level_up( ret )
	local levelUpData  = ret["level_up"]
	self.isLevelUp     = true
	ret["level_up"]    = nil
	-- self.levelupDialog = ret["levelup_dialog"] --{first_levelup = 1, fifty_levelup = 33}
	if ret["levelup_dialog"] then
		self.levelupDialog = ret["levelup_dialog"]
	end

	if ret["lounge_min_bet"] then
		LobbyControl:getInstance():updateLoungeSpinBet(ret["lounge_min_bet"])
	end

	-- local len = #levelUpData
	-- if levelUpData and levelUpData[len] and levelUpData[len].level and levelUpData[len].level > 10 then
	-- 	self:playSpecialDialog()
	-- end
	local endCallFunc  = function()

		-- 升级弹窗完后，弹升级相关弹窗
		if self.levelupDialog then
			if self.levelupDialog.first_levelup and self.levelupDialog.first_levelup == 1 then
				ActivityCenterControl:getInstance():showHotTodayDialog(false)
			end

			if self.levelupDialog.store_increment and self.levelupDialog.store_increment > 0 and bole.canDisturbTheme() then
				PromotionControl:getInstance():showDealDialog({type = "close_store", delay = 0.5, from = "level_up"})
				bole.send_codeInfo(Splunk_Type.RECORD, {pid = PID.deal, level = User:getInstance().level, place = 4}, false)
			end

			self.levelupDialog = nil
		end
	end
	self:handleResult()	
	self:playLevelUp(levelUpData, endCallFunc)	

	LobbyThemeControl:getInstance():updateThemeData() -- 主题会随着升级解锁，刷新LobbyThemeControl中的数据
	
end

-- vip_level_up
function ThemeControl:vip_level_up( ret )
	local vipLevelUpData = ret["vip_level_up"]
	ret["vip_level_up"]   = nil
	local endCallFunc = function()
		self:handleResult()	-- 这个函数是用来往下顺序执行的
	end
	self:playVipLevelUp(vipLevelUpData, endCallFunc)	
end

-- unlock
function ThemeControl:theme_unlock( ret )
	local theme_unlock_data = ret["theme_unlock"]
	ret["theme_unlock"]   = nil
	local endCallFunc = function()
		self:handleResult()	-- 这个函数是用来往下顺序执行的
	end

	endCallFunc()

	-- if User:getInstance().level > 10 then
	-- 	self:showUnlockThemeTips()
	-- end

	local duration = 7
	local function showUnlockTips ()
		if self.unlockQueue and not self.unlockQueue:isEmpty() then
			local theme_id
			local theme_list_tip = {}
			if self.unlockQueue:getSize() == 4 then
				for i = 1, 4 do
					theme_id = self.unlockQueue:deQueue()
					table.insert(theme_list_tip, theme_id)
				end
			else
				theme_id = self.unlockQueue:deQueue()
				table.insert(theme_list_tip, theme_id)
			end

			self.header:showUnlockTips(theme_list_tip, duration - 1)

			self.header:runAction(cc.Sequence:create(
				cc.DelayTime:create(duration),
				cc.CallFunc:create(function ( ... )
					showUnlockTips()
				end)))
		end
	end
	-- local popDelay = 0
	-- if User:getInstance().level == 5 then
	-- 	popDelay = 10
	-- end
	-- if  User:getInstance().level == 10 then
	-- 	popDelay = 5
	-- end
	-- self.header:runAction(cc.Sequence:create(
	-- 	cc.DelayTime:create(popDelay),
	-- 	cc.CallFunc:create(function ( ... )
	-- 		showUnlockTips()
	-- 	end)))
	-- showUnlockTips()
	
	EventCenter:registerEvent("THEMECONTROL.THEMECONTROL_LEVELUP_ENDED", "theme_control", function ()
		if not self or not libUI.isValidNode(self.header) then return end
		self.header:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )
			if showUnlockTips then
				showUnlockTips()
			end
		end)))
	end)
end

function ThemeControl:handleUnlockData(unlock_data)
	unlock_data = unlock_data or {}
	local download_ctl = DownloadController:getInstance()
	for _, themeid in pairs(unlock_data) do
		if themeid == 600 or not download_ctl:needDownload(1, tostring(THEME_LIST[tonumber(themeid)]['resourceId'])) then
			self.unlockQueue:enQueue(themeid)
	    else
	        local function onSuccess( ... )
	        	if self.unlockQueue then
					self.unlockQueue:enQueue(themeid)
	        	end
	        end
	        download_ctl:downloadRes({
				resType = 1,
				resKey = tostring(THEME_LIST[themeid]['resourceId']),
				onSuccess = onSuccess,
				cbKey = "ThemeControl",
			})
	    end
	end
	LobbyThemeControl:getInstance():updateThemeUnlockData(unlock_data)
end

-- handle_refreshExp
function ThemeControl:refreshExp( ret )
	-- 主题内经验相关处理
	local expData = nil 
	if ret["experience"] then
		expData = tonumber(ret["experience"])
	end
	ret["experience"] = nil

	local user = User:getInstance()
	if expData ~= user.exp then

		if ret["levelup"] then
			local maxIdx = #ret["levelup"]
			local data = ret["levelup"][maxIdx]
			if data["default_bet"] then
				self.defaultBet = data["default_bet"]
			end

			-- 更新bet
			if data["bet_per_line"] then -- 更新中间连线
				local curBet  = self:getCurBet()
				local betList = data["bet_per_line"]
				for i=1, #betList do
					if betList[i] >= curBet then
						self.defaultBet = betList[i]
						break
					end
				end

				self.nowBetList = betList
				-- user.unlockBets = betList
			end
			self.theme:lockThemeVoices(5)

			ret["vip_level_up"] = ret["levelup"]
			ret["level_up"] = ret["levelup"]

			self.header:setLevelUpData(ret["level_up"])
			local length = #ret["level_up"]
			if length > 50 then
				length = 50
			end
			-- 添加adjust
			for i = 1, length do
				local level = ret["level_up"][i].level
				if bole.isIOS() then
			        Adjust:getInstance():trackCallback("tpx437",{event_name = "levelup", level = level})
			    elseif bole.isAndroid() then
			        Adjust:getInstance():trackCallback("tpx437",{event_name = "levelup", level = level})
			    end
			end

			local last_vip_level = user.vip_level
			local cur_vip_level = data["vip_level"]
			if last_vip_level ~= cur_vip_level then -- 升级了就设为可以出现 祝贺 弹窗
				cc.UserDefault:getInstance():setBoolForKey("NewVipLevel_"..cur_vip_level, true)
			end
		end
		-- 升级后，商店数据会更新
		if ret["store_info"] then
			StoreControl:getInstance():updatePurchaseItems(ret["store_info"])
		end
		
		local exp = user.exp
		user:addExp(expData - user.exp, true , self.theme.isPortrait)

	end	
end

function ThemeControl:playLevelUp(levelUpData, endCallFunc)
	-- todo
	local callFunc = function ()
		if not self.header.level_ing then
			local data = self.header:getLevelUpData()
			self.header:playLevelUp(data,endCallFunc)
		end
		self:checkDownNextThemeRes(levelUpData)
	end
	local delay = 0
	if self.header and self.header.processBar and self.header.processBar.ratio and self.header.processBar.ratio ~= 100 then
		delay = 1.5
	end
	performWithDelay(self.theme, callFunc, delay)

	local function hideBoosterTips( ... )
		if not User:getInstance():displayBooster(2) then
			self.footer:showBoosterTips(false)
		end
		if not User:getInstance():displayBooster(1) then
			self.header:showBoosterTips(false)
		end
	end
	TimerCallFunc:getInstance():addCallFunc(hideBoosterTips, delay + 0.5)
	
end

function ThemeControl:playVipLevelUp(levelUpData, endCallFunc)
 	
	VipDetailControl:getInstance():playVipLevelUp(levelUpData, endCallFunc, true)	

end

function ThemeControl:checkDownNextThemeRes( levelUpData )
	-- todo
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- 小游戏相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:playJackpotGame( theGameData, endCallfunc )
	-- -- 主题内部扩展方式
	if self.theme.playJackpotGame then
		self.theme:playJackpotGame(theGameData, endCallfunc)
		return nil
	end
	-- 后续参照forever实现
	if endCallFunc then
		endCallFunc()
	end
end
function ThemeControl:playBonusGame( theGameData, endCallfunc )
	-- -- 主题内部扩展方式
	local delay = 0
	if self.theme.playBonusAnimate then
		delay = self.theme:playBonusAnimate(theGameData)
	end
	
	local function delayAction()
		local function bonusCallback(winCoins)
			if endCallfunc then
				endCallfunc()
			end
		end
		local b = BonusNewControl.new(self, bonusCallback)
		b:enterBonusGame(theGameData)
	end	
	self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(delayAction)))
end

function ThemeControl:stopControlDelay( ... )
	self.curScene:stopActionByTag(tag_deal_handle)
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- win_coins相关
--------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:setWinCoins( rets )
	rets["setWinCoins"] = nil

	-- 循环播放win cycle动画（中奖symbol和边框）
	local delay = self:drawAnimate(rets) or 0
	-- 开始meter rollup
	local winCoins = rets["total_win"] == rets["base_win"] and rets["total_win"] or rets["base_win"]
	local endCallFunc = function( ) self:handleResult() end
	

	-- 如果在RollUp前需要进行特别的行为，在主题里定义actionBeforeRollUp
	if self.theme.actionBeforeRollUp then
		delay = delay + self.theme:actionBeforeRollUp(rets)
	end
	local tb = nil
	if self.theme.getRollUpBet then -- rollup之前进行 bet 控制
		tb = self.theme:getRollUpBet(rets)
	end
	self.curScene:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ()
			self:startRollup(winCoins, endCallFunc,tb)
		end)))
end

function ThemeControl:setFeatureWinCoins(rets)
	-- 开始meter rollup
	local winCoins = rets["setFeatureWinCoins"] or (rets["total_win"] - rets["base_win"])
	rets["setFeatureWinCoins"] = nil
	local endCallFunc = function( ) self:handleResult() end

	local delay = 0
	-- 如果在RollUp前需要进行特别的行为，在主题里定义actionBeforeRollUp
	if self.theme.actionBeforeRollUp then
		delay = delay + self.theme:actionBeforeRollUp(rets)
	end
	local tb = nil
	if self.theme.getRollUpBet then -- rollup之前进行 bet 控制
		tb = self.theme:getRollUpBet(rets)
	end
	self.curScene:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ()
			self:startRollup(winCoins, endCallFunc,tb)
		end)))
end

-- total win 金币的收集
function ThemeControl:startRollup(winCoins,callback,tb)
	local getCoins = winCoins
	local bet = self.saveBet or 10000
	local multiple = bet / 10000
	getCoins =  math.floor(winCoins * multiple)  

	local start = self.totalWin or 0
	local totalBet = tb or self:getCurTotalBet()
	self:setWinCoins_noHandle( getCoins )

	self.theme:dealMusic_FadeLoopMusic(0.5, 1, 0.3)
	local endCallFunc = function( )
		self.theme:dealMusic_FadeLoopMusic(1, 0.3, 1)

		-- rollup结束后把钱加到header上
		self:addCoinsToHeader()
		if self.theme.rollOverFunc then 
			self.theme:rollOverFunc(self.totalWin) -- rollUp之后 进行的 每个类特殊的操作
		end
		-- 如果需要在rollup结束后添加其他操作，在此扩展
		if callback then callback() end
	end
 

	self.footer:setWinCoinsEffect(getCoins, start ,totalBet, endCallFunc)

end

function ThemeControl:addCoinsToHeader()
	if self:noFeatureLeft() then 
		local winCoin = self.totalWin
		if THEME_DESKTOP_ID == 164 then
			local bet = self.saveBet or 10000
			local multiple = bet / 10000
			winCoin =  math.floor(winCoin * multiple)  
		end
		User:getInstance():addCoins(winCoin) 
	end
	
	-- bole.updateTotalCoin(self.totalWin)
end


function ThemeControl:singleAddWinCoins( winCoins ,onlyAdd)
	-- zhf 暂时注释掉,加钱逻辑
	--local payCoins = self:getCurTotalBet()	
	if self.freewin then
		self.freewin = self.freewin + winCoins
	elseif self:isFreeSpinTriggered() then
		-- 中free spin的那一把，前端钱先不加给用户
		self.scatter_spin_winCoins = self.scatter_spin_winCoins or 0
		self.scatter_spin_winCoins = self.scatter_spin_winCoins + winCoins
	else
		if not self.theme.saveWin then
			
		end
	end	
	-- if onlyAdd then 
	-- 	self.footer:onlyAddCoins(winCoins, payCoins)
	-- end

end

function ThemeControl:isFreeSpinTriggered()
	if self.rets and (self.rets["free_spins"] or self.rets[self.custom_handle_name]) then return true end
	return false
end

function ThemeControl:setWinCoins_noHandle( theWinCoins )
	local winCoins 	= theWinCoins
	local payCoins 	= self:getCurTotalBet()
	self.totalWin   = self.totalWin or 0
	self.totalWin   = self.totalWin + winCoins
	self.allrevenue = self.allrevenue + winCoins
	self.allcost 	= self.allcost + payCoins
	self:singleAddWinCoins(winCoins)
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- free_spin相关
--------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:enterFreeSpinStage(isResume )
	self:changeFreeBack(true)
	self.theme:enterFreeSpin(isResume)	
	if not self.freeItem then
		self.freeItem    = self.theme:getItemListForFreeSpin()
		self.freeRet  = self.theme:getFreeRetForFreeSpin()
		self.freeSpeical = self.specials
	end
end
function ThemeControl:runFreeSpinStage( )
	self.footer:enterFreeSpin()
end
function ThemeControl:runFreeCollectSpinStage( )
	self.footer:enterCollectFreeSpin()
end
function ThemeControl:outFreeSpinStage( )
	self.theme:hideFreeSpinNode() -- 隐藏 freespin 的 相关节点显示
	self.footer:exitFreeSpin() -- 对 footer 的 按钮进行控制
	self:changeFreeBack(false) -- 更新使用的假滚轴
	if self.freeItem then
		self:refreshWithTheItemList(self.freeItem) -- 刷新牌面 + 动画播放
	end
	self:enterBaseGameStage()

	self.freeItem    = nil	
	self.freeRet     = nil
	self.freeSpeical = nil
end

function ThemeControl:enterBaseGameStage( )
	-- 恢复牌面和footer都可以移到此处处理
	self.stageName = theme_stage_List.base_game
end

function ThemeControl:changeFreeBack( isFree )
	-- self.theme:updateFreeBack(isFree) -- 返回 nil 不知道 干嘛用的 
	self:resetCurrentReels(isFree)
end
function ThemeControl:free_random_pick( ret, endThemeCallfunc, tryResume )
	-- 记录当前stage
	self.stageName = theme_stage_List.pick_game

	--commonMusic: 背景音乐静音
	self.theme:dealMusic_MuteLoopMusic()
	local theGameData      = ret["free_random_pick"]
	ret["free_random_pick"] = nil
	local theSpecials 	= self.specials
	local endCallfunc   = endThemeCallfunc or function()
		self:handleResult()
	end

	if self.theme.enterPickGame then 
		self.theme:enterPickGame(ret, theGameData, endCallfunc, tryResume) 
	else
		endCallfunc()
	end
end

function ThemeControl:updateFreeSpinCount(retrigger, count)
	if not retrigger then
		self.freespin = 0
		self.freespin = self.freespin + count -- 剩余free spin的次数
		self.sumFreeSpinCnt = 0
		self.sumFreeSpinCnt = self.sumFreeSpinCnt + count -- 总共 freespin 的次数
		self.freewin  = self.scatter_spin_winCoins or 0
		self.scatter_spin_winCoins = nil
	else
		self.freespin = (self.freespin or 0) + count -- 剩余free spin的次数
		self.sumFreeSpinCnt = (self.sumFreeSpinCnt or 0) + count -- 总共 freespin 的次数
	end
end

function ThemeControl:free_spins( ret )
	-- self.spinning 		= false
	-- 记录当前stage
	self.stageName = theme_stage_List.free_game
	EventCenter:pushEvent(EVENTNAMES.THEME.IS_IN_FREE)
	
	self.theme:dealMusic_MuteLoopMusic()
	local theSpecials 	= self.specials
	local enterType     = "free_spin"
	if self.freewin then
		enterType = "more_free_spin"
	end
	local enterDelay 	= self.theme:playFreeSpinItemAnimation(theSpecials, enterType) or 0 -- 进入freespin 的延迟时间
	------------------------------------------------------------------------------------	
	local spins 		= ret["free_spins"] -- freespin 次数 当前结果中
	ret["free_spins"] 	= nil
	------------------------------------------------------------------------------------
	self.freespin = self.freespin or 0
	self.freespin = self.freespin + spins -- freespin 剩余次数
	local more = nil
	if not self.freewin then
		self.sumFreeSpinCnt = 0
		self.sumFreeSpinCnt = self.sumFreeSpinCnt + spins -- 总共 freespin 的次数
		self.freewin  = self.totalWin or 0
		self:changeScreenAwakeState(true)
	else
		self.sumFreeSpinCnt = self.sumFreeSpinCnt + spins
		more = true
	end
	------------------------------------------
	local function delayAction()
		self.isDealFSBegClick = false
		self.isDealFSBegEnd   = false		
		local function startClickCallFunc( ) -- 点击按钮的时候 或者 倒计时结束的时候被调用
			if self.isDealFSBegClick then return end
			self.isDealFSBegClick = true
			-- 场景切换
			if not more then
				self:setPointBet(self:getCurBet())

				--commonMusic: 关闭弹出startFreeSpin音效
				self.theme:dealMusic_StopFSEnterMusic()
				self.theme:dealMusic_PlayFSEnterClickMusic()
			else
				--commonMusic: 关闭弹出moreFreeSpin音效
				self.theme:dealMusic_StopFSMoreMusic()
				self.theme:dealMusic_PlayFSMoreClickMusic()
			end
		end
		local function changeLayer()
			
		end
		local function endCallFunc( ) -- 弹窗结束的时候被调用
			if self.isDealFSBegEnd then return end
			self.isDealFSBegEnd = true	
			local function startSpin()
				self:handleResult()
			end	
			if more then
				self.theme:freeStartClicked(startSpin,true)
			else
				
				self.theme:showFreeSpinNode(self.freespin, self.sumFreeSpinCnt, not self.freeItem)
				self:runFreeSpinStage()
				self.theme:freeStartClicked(startSpin,false)
			end

		end
		if more then
			local function enterCallFunc( ) -- 显示弹窗的时候被调用
				self.footer:onEnterFreeSpinDialog()
				self.footer:setSpinButtonState(true) -- 禁用spin 按钮
				self.theme:dealMusic_PlayFSMoreMusic()
			end
			 -- enter_event 显示弹窗的时候的回调方法 click_event 点击弹窗之后的 回调方法 end_event 关闭弹窗之后的回调方法
			local theData = {["count"]=spins, ["enter_event"]=enterCallFunc, ["click_event"]=startClickCallFunc, ["end_event"]=endCallFunc, ["theme_info"] = ret["theme_info"],["free_game"] =ret["free_game"] }
			self.theme:adjustFreeSpinMoreData(theData) -- 目前没有操作
			self.theme:playMoreFreeSpinDialog(theData) -- 显示 获得 更多 freespin 弹窗
		else
			local function enterCallFunc( ) -- 显示弹窗的时候被调用
				self.footer:onEnterFreeSpinDialog() -- footer 显示 freespin 按钮
				self.footer:setSpinButtonState(true) -- 禁用spin 按钮
				--commonMusic: 弹出startFreeSpin
				self.theme:dealMusic_PlayFSEnterMusic()
				self:enterFreeSpinStage()
			end
			local theData = {["count"]=spins, ["enter_event"]=enterCallFunc, ["click_event"]=startClickCallFunc,["changeLayer_event"]=changeLayer, ["end_event"]=endCallFunc}
			self.isFirstFreeGame = true
			self.theme:playStartFreeSpinDialog(theData) -- 显示 获得 freespin 弹窗
		end
	end
	self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(enterDelay),cc.CallFunc:create(function()
		delayAction()
	end)))
end

function ThemeControl:playRateUs(rateUsData, endCallFunc)	
	if (rateUsData == 1 or self.needShowRateUs) and bole.canDisturbTheme() then
		self.needShowRateUs = false
		PopupController:getInstance():addDialogToPopupFront("rate_us_new", {is_portrait = self.theme.isPortrait}, endCallFunc)
   	end
end

function ThemeControl:finish_actions(ret)
	ret["finish_actions"] = nil
	if self.theme.showFinishActions then
		self.theme:showFinishActions()
	end
	self:handleResult()
end

function ThemeControl:booster_tips( ret )
	local boosterTipsData = ret["booster_tips"]
	ret["booster_tips"]   = nil
	local endCallFunc = function()
		self:handleResult()	-- 这个函数是用来往下顺序执行的
	end

	if boosterTipsData == 1 then
		self.header:showBoosterTips(true, true, endCallFunc)
	elseif boosterTipsData == 2 then
		self.footer:showBoosterTips(true, true, endCallFunc)
	else
		endCallFunc()
	end
end

function ThemeControl:spin_end( ret )
	self.spin_processing = false
	self:changeSpinOrFeatureState(false)
	
	-- local tBet = self:getCurTotalBet()
	-- local user = User:getInstance()
	-- if user.coins < tBet then
	-- 	if not self.freewin and math.mod(user.user_id, 2) == 0 then
	-- 		DialogControl:getInstance():outofcoins(self.theme.isPortrait, tBet, false, {
	-- 			isMinBet = self:checkIsMinBet(),
	-- 			minBet = self:getMinBet(),
	-- 			isHigh = self:getHighRoom(),
	-- 		})
	-- 	end 
	-- end
end

function ThemeControl:collectFreeSpin( pEndCallfunc )
	local collectDelay = 1 -- 0.1
	local function delayAction()
		self.isDealFSCollectClick = false
		self.isDealFSCollectEnd   = false
		--显示FreeEnd弹窗时候的回掉
		local function enterCallFunc()
			self.footer:onEnterFreeSpinDialog() -- 控制 footer 的 按钮不可点击
			self.footer:setSpinButtonState(true) -- 禁用spin 按钮
			--commonMusic	
			self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0.1)
			self.theme:dealMusic_PlayFSCollectMusic()			
		end
		--点击FreeEnd弹窗时候回掉
		local function collectClick() -- 可以添加音效
			-- 点击收集的时候向服务器发送收钱的请求,服务器 给用户加钱
			-- bole.potp:send(COLLECT_COINS,{type=0},true)--data

			if self.isDealFSCollectClick then return end 
			-- self.footer:setSpinButtonState(false) -- 解除禁用 spin 按钮
			self.isDealFSCollectClick = true
			--commonMusic
			self.theme:dealMusic_StopFSCollectMusic()
			self.theme:dealMusic_PlayFSCollectClickMusic()
			
			-- self.theme:dealMusic_FadeLoopMusic(0.3, 0.1, 1)
		end
		local function changeLayer()
			self.theme:dealMusic_PlayFSCollectEndMusic()
			if self.isDealFSCollectEnd then return end
			self.isDealFSCollectEnd = true
			self.freespin = nil
			self:removePointBet()
			self:outFreeSpinStage()
		end
		--FreeEnd弹窗消失的回掉
		local function endCallFunc()
			local freeWin = self.freewin
			local function onRollEnd( ... )

				EventCenter:pushEvent(EVENTNAMES.THEME.IS_OUT_FREE)
				self.theme:dealMusic_FadeLoopMusic(0.3, 0.1, 1)

				self:playRateUs()
				
				if pEndCallfunc then
					pEndCallfunc()
				end
				-- 处理freeSpin collect收钱庆祝完成之后，需要有特殊feature的情况
				-- 例如: 为了给RoyalPuppies 主题的 商店中奖Free情况下 Free庆祝完成之后，重新打开商店
				if self.theme.collectFreeRollEnd then 
					self.theme:collectFreeRollEnd() 
				end
			end
			self.theme:dealMusic_PlayNormalLoopMusic()
			self.theme:dealMusic_SetLoopMusic(0.1)
			self.theme:laterCallBack(0.5, function ()
				self.footer:setWinCoinsEffect(freeWin, 0 ,self:getCurBet(), onRollEnd)
				self.freewin = nil
			end)
		end
		local freeSpinSumCount = self.sumFreeSpinCnt or self.free_spins_cache_cnt
		local theData = {["coins"] = self.freewin, ["sum_count"]=freeSpinSumCount, ["enter_event"]=enterCallFunc, ["click_event"]=collectClick, ["changeLayer_event"]=changeLayer, ["end_event"]=endCallFunc}
		-- self.theme:adjustFreeSpinCollectData(theData) -- 目前 没啥用
		self.theme:playCollectFreeSpinDialog(theData) -- 显示 collect freespin的 弹窗
	end
	self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(collectDelay),cc.CallFunc:create(function()
		delayAction()
	end)))
end
------------------------------------------------------------------------------------------------------------------------------
-- to_self
------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:getThemeId( )
	return self.theme.themeid
end
function ThemeControl:getCurTheme( )
	return self.theme
end
function ThemeControl:getRetMatrix( )
	if self.rets then
		return self.rets["item_list"]
	else
		return nil
	end
end
function ThemeControl:getWinPosList( )
	return self.rets["win_pos_list"] or {}
end

function ThemeControl:updateCellOtherAssets(cell,colid) -- 更新Symbol上除Sprite以外的Sprite
	if self.theme.isThemeStoreOpen and #self.resultCoinsCache > 0 then
		local theCoinKey = table.remove(self.resultCoinsCache[colid],#self.resultCoinsCache[colid])
		self.theme:updateCellOtherAssets(cell,theCoinKey,colid)
	end
end

function ThemeControl:createCellSprite( colid, rowIndex )
	local theCellKey = self:getNextSprite(colid, rowIndex)
	local ret 	 	 = self.theme:createCellSprite(theCellKey, colid, rowIndex)
	return ret
end

function ThemeControl:resetAllCellSpite() -- basegame 进入freegame以后symbol面板更新为free game的假轴
	for colId,reel in pairs(self.theme.spinLayer.spins) do
	-- for colId=1, #self.spinLayer.spins do -- 遍历每一列

		-- local col = self.theme.spinLayer.spins[colId]
		for k ,v in pairs(reel.cells) do 
			self:updateCellSprite(v,colId,false,nil)
		end		
	end	
end

function ThemeControl:updateCellSprite( sprite, colid, isGetResult,cellKey,isReset) -- index_in_spin 是控制滚轴中会显示几个symbol的 stop时 isReset 是强制刷新的标识
	
	if cellKey then
		self.theme:updateCellSprite(sprite, cellKey, colid,isGetResult,isReset)
		return nil
	end
	local theCellKey = nil
	if isGetResult and self.resultCache[colid] and #self.resultCache[colid]>0 then
		local nMaxIndex = #self.resultCache[colid]
		theCellKey = table.remove(self.resultCache[colid], #self.resultCache[colid])
	end
	
	if not theCellKey then
		theCellKey = self:getNextSprite(colid, cellKey)
		theCellKey = self.theme:getUpdateKeyWithIndex(colid,cellKey,theCellKey) or theCellKey
	end
	self.theme:updateCellSprite(sprite, theCellKey, colid,isGetResult,isReset)

	if isGetResult then
		self:updateCellOtherAssets(sprite,colid)
	end
	
end
function ThemeControl:resetBoardCellsSprite( resetItemList )
	resetItemList = resetItemList or {}	
	for col,colItemList in pairs(resetItemList) do
		local theSpinCol = self.theme.spinLayer.spins[col]
		if theSpinCol then
			for row,theKey in pairs(colItemList) do
				self.theme:updateCellSprite(theSpinCol:getRetCell(row), theKey, col, 1,true) -- 第四个 参数 判断 是否 是恢复牌面的
			end
			if self.freeRet and self.freeRet["item_list_up"] and self.freeRet["item_list_up"][col] then
				local key1 = self.freeRet["item_list_up"][col][1]
				local key2 = self.freeRet["item_list_down"][col][1]
				self.theme:updateCellSprite(theSpinCol:getRetCell(0), key1, col, nil,true)
				self.theme:updateCellSprite(theSpinCol:getRetCell(#colItemList+1), key2, col, nil,true)
			end
			self.theme:refreshColCellsZOrder(col)
		end
	end
	-- whj 添加 从freegame 返回 basegame 中奖动画 和 speical 动画重新播放
	if self.freeRet and self.freeRet["win_pos_list"] and #self.freeRet["win_pos_list"]>0 then
		if self.theme.getDrawThemeAnimateSpecialData then -- 需要计算的 特殊配置 例如 合图数据
			self.theme:getDrawThemeAnimateSpecialData(self.freeRet,resetItemList)
		end
		if self.freeRet["win_ways"] then
			self.freeRet["win_pos_list"] = {}
			local tagCRList = {}
			for _, winWayData in ipairs(self.freeRet["win_ways"]) do
				local posList = winWayData["win_pos"]
				for _, crPos in ipairs(posList) do
					tagCRList[crPos[1]] = tagCRList[crPos[1]] or {}
					tagCRList[crPos[1]][crPos[2]] = true
				end
			end
			for col, colList in pairs(tagCRList) do
				for row, _ in pairs(colList) do
					table.insert(self.freeRet["win_pos_list"], {col, row})
				end
			end
			self.winWays = self.freeRet["win_ways"]
			self.theme:drawWaysThemeAnimate(self.winWays, self.theme.spinLayer, self.freeRet, self.freeSpeical)
		elseif self.freeRet["win_lines"] then
			local winls    = self.freeRet["win_lines"]
			local winLines = {}
			for i=1, #self.freeRet["win_lines"] do
				table.insert(winLines, {winls[i]['line'], winls[i]['count'], winls[i]['symbol'], winls[i]['reverse'],
						 	 col_ck = winls[i]['col_ck'] or 0, play_idx = winls[i]['play_idx']})
			end
			self.winLines = winLines
			self.theme:drawLinesThemeAnimate(self.winLines, self.theme.spinLayer, self.freeRet, self.freeSpeical)
		end
	end
	if self.freeSpeical then
		self.theme:playBackBaseGameSpecialAnimation(self.freeSpeical)
	end
	self:cleanTheReelKeyCache()

	-- 开启按钮可点击状态
	self.footer:setSpinButtonState(false)
end

function ThemeControl:resetBoardCellsSpriteOverBonus( resetItemList )
	resetItemList = resetItemList or {}	
	for col,colItemList in pairs(resetItemList) do
		local theSpinCol = self.theme.spinLayer.spins[col]
		for row,theKey in pairs(colItemList) do
			self.theme:updateCellSprite(theSpinCol:getRetCell(row), theKey, col, 1,true) -- 第五个 参数 判断 是否 是恢复牌面的
		end
		if self.bonusRet and self.bonusRet["item_list_up"] and self.bonusRet["item_list_up"][col] then
			local key1 = self.bonusRet["item_list_up"][col][1]
			local key2 = self.bonusRet["item_list_down"][col][1]
			self.theme:updateCellSprite(theSpinCol:getRetCell(0), key1, col, nil,true)
			self.theme:updateCellSprite(theSpinCol:getRetCell(#colItemList+1), key2, col, nil,true)
		end
		self.theme:refreshColCellsZOrder(col)
	end
	local winType = self:resetWinListFromRespin(self.bonusRet,resetItemList)
	if winType then 
		if winType == "line" then 
			self.theme:drawLinesThemeAnimate(self.winLines, self.theme.spinLayer, self.bonusRet)
		else 
			self.theme:drawWaysThemeAnimate(self.winWays, self.theme.spinLayer, self.bonusRet)
		end
	end
	if self.theme.playBonusItemAnimate then 
		self.theme:playBonusItemAnimate(resetItemList)
	end
	self:cleanTheReelKeyCache()
end

function ThemeControl:resetWinListFromRespin(ret,resetItemList)
	if ret and ret["win_pos_list"] and #ret["win_pos_list"]>0 then
		if self.theme.getDrawThemeAnimateSpecialData then -- 需要计算的 特殊配置 例如 合图数据
			self.theme:getDrawThemeAnimateSpecialData(ret,resetItemList)
		end
		if ret["win_ways"] then
			ret["win_pos_list"] = {}
			local tagCRList = {}
			for _, winWayData in ipairs(ret["win_ways"]) do
				local posList = winWayData["win_pos"]
				for _, crPos in ipairs(posList) do
					tagCRList[crPos[1]] = tagCRList[crPos[1]] or {}
					tagCRList[crPos[1]][crPos[2]] = true
				end
			end
			for col, colList in pairs(tagCRList) do
				for row, _ in pairs(colList) do
					table.insert(ret["win_pos_list"], {col, row})
				end
			end
			self.winWays = ret["win_ways"]
			return "way"
		elseif ret["win_lines"] then
			local winls    = ret["win_lines"]
			local winLines = {}
			for i=1, #ret["win_lines"] do
				table.insert(winLines, {winls[i]['line'], winls[i]['count'], winls[i]['symbol'], winls[i]['reverse'],
						 	 col_ck = winls[i]['col_ck'] or 0, play_idx = winls[i]['play_idx']})
			end
			self.winLines = winLines
			return "line"
		end
	end
end

function ThemeControl:refreshWithTheItemList( refreshItemList )
	self.winRet = nil
	self.specialSpeed = false
	self.haveSpeedSmybol = false
	self:clearAnimate()
	self.theme:cleanStatus(true)
	if self.theme.refreshSpecialItemList then
		self.theme:refreshSpecialItemList(refreshItemList)
	end
	self:resetBoardCellsSprite(refreshItemList)
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- 滚轴相关
	-- 关于特殊情况进行屏蔽，后续添加相关逻辑
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:cleanTheReelKeyCache( )
	self.caches 	= {}	
	self.theCaches 	= {}
end
function ThemeControl:getNextSprite(colid, rowIndex)
	self.caches[colid] 		= self.caches[colid] or {}
	self.theCaches[colid] 	= self.theCaches[colid] or {}

	-- 初始化棋盘 指定样式
	if rowIndex and self.theCaches[colid][rowIndex] then		
		local theKey = self.theCaches[colid][rowIndex]
		self.theCaches[colid][rowIndex] = nil
		return theKey
	end
	
	-- 有假滚轴数据时的处理方案
	if self.currentReels and self.currentReels[colid] then
		local a = self.currentReels[colid]
		local c = self:addCurrentReelIndex(colid)
		local retKey = a[c]
		return retKey
	end
	-- 从所有symbol(当前主题的所有symbol)中随机一个值
	if #self.caches[colid] == 0 then
		self.caches[colid] = self.theme:getFrames(colid)
	end
	local retKey = table.remove(self.caches[colid], 1)
	return retKey
end
function ThemeControl:resetCurrentReels( isFree ,isBouns) -- 重置freespin 的滚轴
	if not self.theme_reels then
		return
	end
	if (not self.freespin or self.freespin < 1) and not isFree then
		self.currentReels = self.theme:getMainReel() or self.theme_reels["main_reel"]
	else
		self.currentReels = self.theme:getFreeReel() or self.theme_reels["free_reel"]
	end
	if isBouns then 
		self.currentReels = self.theme:getBonusReel() or self.theme_reels["bonus_reel"]
	end

	if not self.currentReels then return end
	self.currentReelsIndex = {}
	for col,reelDataList in pairs(self.currentReels) do
		local isSingleReel = false
		self.currentReelsIndex[col] = self.theme:getReelRandomIndex(col, reelDataList, isSingleReel)
	end
end
function ThemeControl:resetTheCurReelIndex( col )
	if self.theme_reels then
		if self.currentReels and self.currentReels[col] then
			self.currentReelsIndex 		= self.currentReelsIndex or {}
			local reelDataList = self.currentReels[col]
			local isSingleReel = true
			self.currentReelsIndex[col] = self.theme:getReelRandomIndex(col, reelDataList, isSingleReel)
		end
	else
		if self.caches and self.caches[col] then
			self.caches[col] = {}
		end
	end	
end
function ThemeControl:addCurrentReelIndex( colid )
	if not self.theme_reels then
		return
	end
	local symbols = self.currentReels[colid]
	local nextIndex = self.currentReelsIndex[colid]%#symbols + 1
	self.currentReelsIndex[colid] = nextIndex
	return nextIndex
end
function ThemeControl:setCurrentReelIndex( colid, target_position )
	if not self.theme_reels then
		return
	end
	local a = self.currentReels[colid]
	self.currentReelsIndex[colid] = (target_position - 1)%#a + 1
end
function ThemeControl:getCurrentReel( colid )
	return self.currentReels[colid]
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- header,footer
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:setHeader( theHeader )
	if self.header ~= theHeader then
		self.header = theHeader
	end
end
function ThemeControl:getHeader( )
	return self.header
end
function ThemeControl:setFooter(f)
	if self.footer ~= f then
		self.footer = f
	end
end
function ThemeControl:getFooter( )
	return self.footer
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- jackpot相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:showJackpotBetDialog( data, endCallFunc )
	local dialog = JackpotBetDialog.new(self, data, self.jackpot_target)
	if dialog then dialog:show() end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- bonus_game相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:open_old_bonus_game(bonus_data, endCallFunc )
	local function callback()
		if endCallFunc then
			endCallFunc()
		end
	end

	local b = BonusNewControl.new(self, callback)
	b:tryResumeBonusGame(bonus_data)
end

------------------------gold spin ------------------------------------------------
function ThemeControl:getGoldSpinStatus()
	-- local isIphonex = cc.UserDefault:getInstance():getStringForKey("is_iphonex")
	-- if appDebugMode and isIphonex and isIphonex == "1" then
	-- 	return true
    -- end
	return false
end
function ThemeControl:setGoldSpinHideGameRuleList()
	if not self:getGoldSpinStatus() then
		self.hideGameRuleList = nil
	end
end

-----------------------------后端收钱-----------------------
function ThemeControl:collectCoins(collect_type,special_data)
	special_data = special_data or {}
	special_data.type = collect_type
	bole.potp:send(COLLECT_COINS,special_data,true)
end

function ThemeControl:themeBuySpecial(special_data)
	-- special_data = special_data or {}
	-- bole.potp:send(THEME_MAP,special_data,true)
end

--添加选择界面协议，譬如200进主题选择
function ThemeControl:themeSelectSpecial(special_data)
	special_data = special_data or {}
	bole.potp:send(THEME_PICK,special_data,true)
end

function ThemeControl:themeStorePurchase(special_data)
	special_data = special_data or {}
	bole.potp:send(THEME_STORE,special_data,true)
end

function ThemeControl:themeStoreCollect(collect_type,special_data)
	special_data = special_data or {}
	special_data.type = collect_type
	bole.potp:send(COLLECT_THEME_STORE,special_data,true)
end
--function ThemeControl:themeTourRanking(special_data)
--    special_data = special_data or {}
--    bole.potp:send(GET_TOUR_RANKING_INFO, special_data, true)
--end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- bet相关
-----------------------------------------------------------------------------------------------------------------------------------------------
BetControl = class("BetControl")
function BetControl:ctor( theThemeControl )
	self.saveLv 		= 0
	self.betIndex 		= 1
	self.betList 		= nil
	self.curBet  		= nil
	self.pointBet 		= nil
	self.themeCtr 		= theThemeControl
	self.theme 			= theThemeControl.theme
end
function BetControl:refreshBetList()
	if self.saveLv == self.themeCtr:getUserLevel() then return end
	
	self.saveLv  = self.themeCtr:getUserLevel()
	self.curBet  = self.themeCtr.defaultBet 
	self.betList = self.themeCtr.nowBetList
	local tmpIndx = table.find(self.betList, self.curBet)
	if tmpIndx < 0 then --nofind
		-- self.curBet = self.betList[self.betIndex]
		local fix = {v = self.betList[#self.betList], i=#self.betList}
		for i,v in ipairs(self.betList) do
			if math.abs(v-self.curBet) < fix.v then
				fix.v = math.abs(v-self.curBet)
				fix.i = i
			end
		end
		self.betIndex = fix.i
		self.curBet = self.betList[self.betIndex]
	else
		self.betIndex = tmpIndx
	end
	
	-- if User:getInstance():getExp() == 0 then
	-- 	local userId = SettingControl:getInstance():parseUserID() or 0
	-- 	-- if userId %2 == 0 then
	-- 	local number = userId % 10
	-- 	if number >= 0 and number <= 2 then
	-- 		self.betIndex = #self.betList
	-- 		self.curBet = self.betList[self.betIndex]
	-- 	elseif number >=3 and number <= 5 then
	-- 		self.betIndex = #self.betList - 1
	-- 		self.curBet = self.betList[self.betIndex]
	-- 	else
	-- 		-- 对照组
	-- 	end
	-- end
	self:refreshCurBet()
end
function BetControl:adjustWithUserLevelUp()
	-- 废弃
	-- self:refreshBetList()
end
function BetControl:initBetControl()
	self:refreshBetList()
end
function BetControl:getBetList( )
	return self.betList
end
function BetControl:refreshCurBet( )
	if self.pointBet then
		self.themeCtr:adjustThemeBet(self.pointBet,true)
	elseif self.curBet then
		self.themeCtr:adjustThemeBet(self.curBet,false)		
	end
end
function BetControl:setPointBet( thePointBet )
	self.pointBet = thePointBet
	self:refreshCurBet()
end
function BetControl:removePointBet( )
	self.pointBet = nil
	self:refreshBetList()
	self:refreshCurBet()
end
function BetControl:setCurBet( theBet )
	if self.curBet ~= theBet then
		self.curBet = theBet
		self.betIndex = table.find(self.betList, self.curBet)
		if self.betIndex < 0 then
			self.betIndex = 1
		end
		self:setCurBetSound()
		self:refreshCurBet()
	end
end
function BetControl:getCurBet( )
	local bet = self.pointBet or self.curBet
	-- if self.theme.betFixMul and not self.pointBet then
	-- 	bet = bet * self.theme.betFixMul
	-- end
	return bet
end

function BetControl:getMaxBet( ... )
	local maxBet = self.betList[#self.betList]
	return maxBet
end

function BetControl:setCurBetSound()
	local index = 1
	for i,v in ipairs(self.betList) do
		if self.curBet == v then 
			index = i
			break
		end
		if self.betList[i+1] and self.curBet > v and self.curBet < self.betList[i+1] then
			index = i
			break
		end
	end
	if index == #self.betList then
		bole.playMusic("bet/global_max_bet", nil, nil, "sounds/")
	end
	index = index > 25 and 25 or index
	bole.playMusic("bet" .. index, nil, nil, "sounds/bet/")
end
---------------------------------------------------------------
function BetControl:changeToUpBet( )
	local theIndex = table.find(self.betList, self.curBet)
	local theBet   = nil
	if theIndex >= 1 then
		if theIndex < #self.betList then
			theBet = self.betList[theIndex+1]
		else
			theBet = self.betList[1]
		end
	else
		for index=1,#self.betList do
			if self.curBet < self.betList[index] then
				theBet = self.betList[index]
				break
			end
		end
	end
	if theBet then
		self:setCurBet(theBet)
		self.theme:changeBet(theBet)
	end
end
function BetControl:changeToDownBet( )
	local theIndex = table.find(self.betList, self.curBet)
	local theBet   = nil
	if theIndex >= 1 then
		if theIndex ~= 1 then
			theBet = self.betList[theIndex-1]
		else
			theBet = self.betList[#self.betList]
		end
	else
		for index=#self.betList,1,-1 do
			if self.curBet > self.betList[index] then
				theBet = self.betList[index]
				break
			end
		end
	end
	if theBet then
		self:setCurBet(theBet)
		self.theme:changeBet(theBet)
	end
end
function BetControl:setMaxBet( )
	local maxBet = self.betList[#self.betList]
	if self.curBet ~= maxBet then
		self:setCurBet(maxBet)	
		self.theme:changeBet(maxBet)
	end
end
function BetControl:setMinBet( )
	local minBet = self.betList[1]
	if self.curBet ~= minBet then
		self:setCurBet(minBet)
	end	
end
function BetControl:getMinBet( )
	return self.betList[1]
end
function BetControl:checkIsMaxBet( theBetList )
	local betList = theBetList or self.betList
	local maxBet  = betList[#betList]
	local retTag  = false
	if self.curBet >= maxBet then
		retTag = true
	end
	return retTag
end
function BetControl:checkIsMinBet( theBetList )
	local betList = theBetList or self.betList
	local minBet  = betList[1]
	local retTag  = false
	if self.curBet <= minBet then
		retTag = true
	end
	return retTag
end
function BetControl:checkIsSingleBet( theBetList )
	local betList = theBetList or self.betList

	local retTag  = #betList <= 1

	return retTag
end
--------------------------------------------------------------------------------------------------------
function ThemeControl:onHeaderLevelUp( upLevel )
	self.betControl:adjustWithUserLevelUp(upLevel)
end
function ThemeControl:getUserLevel( )
	if true then return 50 end
	-- local user = User:getInstance()
	-- return user.level or 0
end
function ThemeControl:getCurTotalBetMul( )
	return self.payline+self.featureMul
end
function ThemeControl:getBaseBet( )
	return self.theme.baseBet
end
function ThemeControl:getCurBet( )
	return self.betControl:getCurBet()
end
function ThemeControl:getCurTotalBet( )
	return self:getCurBet()
end
function ThemeControl:getMaxBet()
	return self.betControl:getMaxBet()
end
function ThemeControl:setCurBet( theBet )
	return self.betControl:setCurBet( theBet )
end
function ThemeControl:getMinBet()
	return self.betControl:getMinBet()
end
function ThemeControl:getBetList()
	return self.betControl:getBetList()
end
function ThemeControl:checkIsMaxBet( )
	return self.betControl:checkIsMaxBet()
end
function ThemeControl:checkIsMinBet( )
	return self.betControl:checkIsMinBet()
end
function ThemeControl:checkIsSingleBet( )
	return self.betControl:checkIsSingleBet()
end
function ThemeControl:changeToUpBet( )
	if self.betControl then
		return self.betControl:changeToUpBet()
	else
		bole.send_codeInfo(Splunk_Type.Error,{error = "empty", msg="changeToUpBet betControl is nil"})
	end
end
function ThemeControl:changeToDownBet( )
	if self.betControl then
		return self.betControl:changeToDownBet()
	else
		bole.send_codeInfo(Splunk_Type.Error,{error = "empty", msg="changeToDownBet betControl is nil"})
	end
end
function ThemeControl:changeToMaxBet( )
	if self.betControl then
		return self.betControl:setMaxBet()
	else
		bole.send_codeInfo(Splunk_Type.Error,{error = "empty", msg="setMaxBet betControl is nil"})
	end
end
function ThemeControl:setPointBet( thePointBet )
	return self.betControl:setPointBet(thePointBet)
end
function ThemeControl:removePointBet( )
	return self.betControl:removePointBet()
end
function ThemeControl:changeCurBet( theBet )
	return self.betControl:setCurBet(theBet)
end
function ThemeControl:adjustThemeBet( theBet, isPointBet )
	-- footer相关
	if not isPointBet then
		if self:checkIsMaxBet() then
			self.footer:setMaxBetState(true)
			self.footer:setMaxBetBtnEnable(false)

			-- PD: 等待添加max bet动画
			--if self.footer.tipBet:getString() ~= "MAX BET" then
			--	self.footer.tipBet:setString("MAX BET")
			--	self.footer:addMaxBetFlash()
			--end
		else
			self.footer:setMaxBetState(false)
			self.footer:setMaxBetBtnEnable(true)
		end
		
		-- if self:checkIsMinBet() then
		-- 	self.footer:setMinBetBtnEnable(false)
		-- else
		-- 	self.footer:setMinBetBtnEnable(true)
		-- end		
		-- min bet始终有效
		-- self.footer:setMinBetBtnEnable(true)
		-- subBet 和 AddBet 始终有效
		self.footer:setSubAndAddBetBtnEnable(true)
	end

	-- if self.theme.betFixMul and self.freespin < 1 then
	-- 	theBet = theBet * self.theme.betFixMul
	-- end

	-- 更新jackpot
	if self.theme.updateJackpotByBet then self.theme:updateJackpotByBet(theBet) end

	-- 更新footer bet值
	self.footer:setBetInfo(theBet, self:getCurTotalBetMul(),theBet,(self.freespin and self.freespin>=0))

	-- 同步调整bet关联内容
	self:adjustWithBetChange(theBet, isPointBet)
end
function ThemeControl:adjustWithBetChange( theBet, isPointBet )
	------------------------------------------------
	-- temp_jackpot
	------------------------------------------------
	-- self:showJackpotTip()
	self.theme:dealAboutBetChange(theBet, isPointBet)
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- 相关说明：server交互相关
	-- 	函数_ConnectLost：
	-- 	函数_registerCmd：
	-- 	函数_getCmds：
	-- 	函数_initPotpCmd：
	-- 	函数_oncmd：server数据处理接口
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:ConnectLost( )
	-- todo
end
function ThemeControl:registerCmd( cmd ) -- 注册相关事件回调
	bole.potp:registerCmd(cmd, self.oncmd, self)
end
function ThemeControl:getCmds( )
	return {BATCH_SPIN,COLLECT_COINS,THEME_MAP, THEME_STORE, THEME_PICK, COLLECT_THEME_STORE,GET_TOUR_INFO}
end
function ThemeControl:initPotpCmd() -- 服务器命令初始化 进行实践注册
	local cmds = self:getCmds()
	for _,c in pairs(cmds) do
		self:registerCmd(c)
	end
end
function ThemeControl:unregisterPotpCmds()
	local cmds = self:getCmds()
	for _,c in pairs(cmds) do
		bole.potp:unregisterCmd(c)
	end
end

function ThemeControl:setBatchSpinTime()
	self.batchSpinTime = os.time()
end

function ThemeControl:getBatchSpinTime()
	return self.batchSpinTime or -1
end

function ThemeControl:setRequestStatus(status)
	self.canRequestStatus = status
end

function ThemeControl:getRequestStatus()
	return self.canRequestStatus
end

function ThemeControl:oncmd(cmd, data) -- 回调方法
	if not self:getRequestStatus() then 
		return
	end
	if cmd == BATCH_SPIN then
		-- 生成随机的代金券数据
		-- data['list'][1].spin_win_voucher = 0.2
		-- data['list'][1].spin_win_times = 10
		-- data['list'][1].spin_vou_left = 3
		VoucherController:getInstance():generateRandVoucherInfo(data['list'] and data['list'][1] or {})
		self:setBatchSpinTime()
		self:dealRequestSpinResult(data) -- 分析spin 返回的 数据
	elseif cmd == COLLECT_COINS then -- 收钱的协议 所有游戏collect统一协议包括bonus game, jp, free game 
		if data["rate_us"] == 1 then
			self.needShowRateUs = true
		end

		-- 处理系统展示
		SystemController:getInstance():oncmd (cmd, data)

		if data["coins"] then
			User:getInstance().serverCoins = data["coins"]
		end

		-- choose bonus
		if data["receive_choice"] == 1 then
			if self.theme.clearChooseBouns then
				self.theme:clearChooseBouns()
			end
		end

		-- get server call for receiving bonus collect coins
		if data["receive_value"] == 1 then
			if self.theme.clearNeedCollectCoinsBonus then
				self.theme:clearNeedCollectCoinsBonus()
			end
		end

		-- use for need bonus data from server to play game
		if data["receive_data"] then
			if self.theme.continueNextBouns then
				self.theme:continueNextBouns(data["receive_data"])
			end
		end

		if data["collect_back_info"] then
			if self.theme.onGetCollectCoinsReceiveData then
				self.theme:onGetCollectCoinsReceiveData(data["collect_back_info"])
			end
		end

		-- self:playRateUs(data["rate_us"])
		if data.type == 1 or data.type == 2 then  -- 1 代表 bonus
			LoginControl:getInstance():saveBonus(self.theme.themeid, nil)
			if self.theme.clearPickData then -- whj 主题 用来删除收集jackpot的Free 时候清除掉 pick本地保存的数据
				self.theme:clearPickData()
			end
		elseif data.type ==0 then  -- 0 代表 freespin
			if self.theme.clearFreeData then
				self.theme:clearFreeData()
			end
		elseif data.type ==3 then -- 游戏中特殊的收集 例如：RoyalPuppies 主题里面收集 pickgame
			if self.theme.collectSpeicalGame then
				self.theme:collectSpeicalGame()
			end
		end
	elseif cmd == THEME_MAP then
		if self.theme.overBuySpecialItem then self.theme:overBuySpecialItem(data) end
	elseif cmd == THEME_PICK then
		if self.theme.getThemeSelectSpecial then self.theme:getThemeSelectSpecial(data) end
	elseif cmd == THEME_STORE then
		self:showStoreBuyDialog(data)
	elseif cmd == GET_TOUR_INFO then
		if self.theme.showThemeTourInfo then self.theme:showThemeTourInfo(data) end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- other
-----------------------------------------------------------------------------------------------------------------------------------------------
function ThemeControl:out_of_coins(  )
    self:enableAuto(false)
	self.footer:enableOtherBtns(true)
    local showType 	= "_outOfCoins"
    local user 		= User:getInstance()		
	local total_bet = self:getCurTotalBet()
	-- DialogControl:getInstance():outofcoins(self.theme.isPortrait,total_bet, false, {
	-- 	isMinBet = self:checkIsMinBet(),
	-- 	minBet = self:getMinBet(),
	-- 	isHigh = self:getHighRoom(),
	-- })

	PopupController:getInstance():popupDialogDirectly("freecoins")
    local c = cc.UserDefault:getInstance():getIntegerForKey("out_of_coins_count", 0)
    cc.UserDefault:getInstance():setIntegerForKey("out_of_coins_count", c + 1)
	self.outOfCoinsShowing = true

end
function ThemeControl:clearAnimate()
	self.theme:clearAnimate()
end
function ThemeControl:saveThemeInfo(themeid ,coins)
	cc.UserDefault:getInstance():setFloatForKey("themeid", themeid)
	-- cc.UserDefault:getInstance():setFloatForKey("coins", coins)
	-- log.d("------saveInfo-------","themeid:".. themeid , "coins:" .. coins)
end

function ThemeControl:showStoreBuyDialog(data)
	local dialog
	local _gameStoreVersion = self.theme.game_store_version and self.theme.game_store_version or 1
	if _gameStoreVersion == 2 then
		dialog = PopupController:getInstance():getDialog("theme_store_game2")
	elseif _gameStoreVersion == 1 then
		dialog = PopupController:getInstance():getDialog("theme_store_game")
	elseif _gameStoreVersion == 3 then
		dialog = PopupController:getInstance():getDialog("theme_store_game2horizon")	
	end
	if dialog then
		dialog:showBuyResult(data)
	end
end



function ThemeControl:getActivesNodeBasePos()
	if self.theme.getActivesNodeBasePos then 
		return self.theme:getActivesNodeBasePos()
	end
end

-- 活动相关
function ThemeControl:isMasterTheme(themeid)
	if true then return false end
	if self:getGoldSpinStatus() then
		return false
	end
	return ActivityCenterControl:getInstance():isMasterTheme(themeid)
end

function ThemeControl:setFooterEnable( enable, pushData )
    if enable then
        EventCenter:pushEvent(EVENTNAMES.THEME.FOOTER_SHOW, pushData)
    else 
        EventCenter:pushEvent(EVENTNAMES.THEME.FOOTER_HIDE, pushData)
    end
end
function ThemeControl:setHeaderEnable( enable, pushData )
    if enable then
        EventCenter:pushEvent(EVENTNAMES.THEME.HEADER_SHOW, pushData)
    else 
        EventCenter:pushEvent(EVENTNAMES.THEME.HEADER_HIDE, pushData)
    end
end

function ThemeControl:setHeaderEnableByPart(enable)
    if enable then
        EventCenter:pushEvent(EVENTNAMES.THEME.HEADER_SHOW_PART)
    else
        EventCenter:pushEvent(EVENTNAMES.THEME.HEADER_HIDE_PART)
    end
end
