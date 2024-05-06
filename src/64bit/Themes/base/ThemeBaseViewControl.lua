-- whj 2010.8.3. 主题的base类


local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"
local spineData = require (string.format("Desktop/Theme%d/Theme/SpinConfig", THEME_DESKTOP_ID))

ThemeBaseViewControl = class("ThemeBaseViewControl")
local _baseViewCtl = ThemeBaseViewControl
local GameStoreType = {
	PUZZLE_I_V     = 1,
	PUZZLE_II_V    = 2,
	PUZZLE_II_H    = 3,
	SLOT_MACHINE_V = 4,
	SLOT_MACHINE_H = 5,
	SLOT_MACHINE_I_V = 6,
	TOURN_CASH = 8,
}


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

local d_show_type = {
	start = 1, 
	more = 2, 
	collect = 3, 
}

local tag_link_break = 906
local tag_deal_handle = 907

local spinIndex = 0

local CNT_IN_THEMECNT = 0
function _baseViewCtl:ctor( id, portrait, theScene) -- , count, maxlines, pay 
	self.curScene = theScene or bole.scene
	self:oldThemeCtor()

	self.game_store_version = self.game_store_version or GameStoreType.PUZZLE_I_V
	self.themeid 	= id or 0
	self.themeResourceId = THEME_LIST[self.themeid]['resourceId']
	self.isPortrait = portrait or false -- true 是竖屏
	CNT_IN_THEMECNT = CNT_IN_THEMECNT + 1
	self.FirstFreeGameDelay = 0.5
	-- 声音配置表
	self:configAudioList()

	-- self.rollup_list 暂定第二个参数，目前还没有用到
	self.audioCtl = ThemeBaseAudioControl.new(self, nil, self.audio_win_list) 

	self:initGameControlAndMainView()
	self.theme = self
	self.ctl = self
	self.node = cc.Node:create()
	self.curScene:addToContent(self.node)

	self:initSlotConfig()
	self:listenBaseEvent()
end
function _baseViewCtl:listenBaseEvent()
	EventCenter:registerEvent(EVENTNAMES.THEME.PLAY_BACKGROUND, self.__cname, self.dealRecoverBgm, self)
end
function _baseViewCtl:removeListenBaseEvent()
	EventCenter:removeEvent(EVENTNAMES.THEME.PLAY_BACKGROUND, self.__cname)
end

function _baseViewCtl:initSlotConfig( ... )
	if self.gameConfig.init_config then 
	    for key, value in pairs(self.gameConfig.init_config) do
	        self[key] = value
	    end
	end
    self.specialPicFileList = self.gameConfig.all_img_path
	if self.game_store_version then
		if self.game_store_version == GameStoreType.TOURN_CASH then
			self.storePicFileList = self:getTcCommonImgPath()
		end
	end
end

function _baseViewCtl:initGameControlAndMainView()
	if not self.mainView then 
		self.mainView = ThemeBaseView.new(self)
	end
	if not self.freeCtl then 
		self.freeCtl = ThemeBaseFreeControl.new(self)
	end
	self.curScene:addToContent(self.mainView)
end

-- 之后删除
function _baseViewCtl:setControl( ... )
	-- body
end

function _baseViewCtl:getCurScene()
	return self.curScene
end

function _baseViewCtl:curSceneAddToContent( node )
	if bole.isValidNode(node) and self.curScene then
		self.curScene:addToContent(node)
	end
end

function _baseViewCtl:curSceneAddToTop( node )
	if bole.isValidNode(node) and self.curScene then
		self.curScene:addToTop(node)
	end
end

function _baseViewCtl:getAudioCtl()
	return self.audioCtl
end
function _baseViewCtl:getFreeCtl()
	return self.freeCtl
end

function _baseViewCtl:getAudioFile(name)
    return self.audio_list[name] -- 更改 bonus 的棋盘
end

function _baseViewCtl:playMusicByName( name, singleton, loop )
	self.audioCtl:playMusic(self:getAudioFile(name), singleton, loop) 
end

function _baseViewCtl:stopMusicByName(name, isCleanSingle)
	self.audioCtl:stopMusic(self:getAudioFile(name), isCleanSingle)
end

function _baseViewCtl:getThemeId( )
	return self.themeid
end

function _baseViewCtl:getThemeResourceId( )
	return self.themeResourceId
end

function _baseViewCtl:getIsTrubo( ... )
	return self.isTurbo
end

function _baseViewCtl:changeSpinLayer( spinLayer )
	self.spinLayer = spinLayer
end

function _baseViewCtl:onEnterInitScene( ... )
	self.mainView:init()
	
	EventCenter:pushEvent(EVENTNAMES.THEME.INIT_THEME_OVER, {})

	self.playNormalLoopMusic = true
    self.isFreeGameRecoverState = false
	self:unlockLobbyBtn()

end

------------------------------------------------------------------------------------------
--@中奖动画
function _baseViewCtl:drawWaysThemeAnimate( lines, layer, rets, specials)
	local timeList = {2, 2}
	self.mainView:drawWaysThemeAnimate(lines, layer, rets, specials,timeList)
end

function _baseViewCtl:drawLinesThemeAnimate( lines, layer, rets, specials)
	local timeList = {2, 2}
	self.mainView:drawLinesThemeAnimate(lines, layer, rets, specials,timeList)
end

function _baseViewCtl:stopDrawAnimate() -- 可能存在 手动调用的可能
	-- EventCenter:pushEvent(EVENTNAMES.THEME.STOP_ANIM)
	self.mainView:stopDrawAnimate()
	if self.storeVCtl then 
		self.storeVCtl:clearStoreCoinData()
	end

end

function _baseViewCtl:getPayLines( )
	return self.lines or {}
end
----------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:adjustEnterThemeRet(data)
	data.theme_reels = tool.tableClone(self.gameConfig.theme_reels) 

	self:dealSpecialFeatureRet(data)
	self:dealBonusGameResumeRet(data)
	self:dealFreeGameResumeRet(data)

	return data
end

function _baseViewCtl:dealSpecialFeatureRet( data )
	-- body
end
function _baseViewCtl:dealBonusGameResumeRet( data )
	-- body
end
function _baseViewCtl:dealFreeGameResumeRet( data )
	if self.freeCtl then
		self.freeCtl:dealFreeGameResumeRet(data)
	end
end
function _baseViewCtl:adjustTheme( data )
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--@ 棋盘假轴
function _baseViewCtl:showBonusNode()
    self:resetCurrentReels(false, true) -- 更改 bonus 的棋盘
end
function _baseViewCtl:hideBonusNode(free, bonus)
    self:resetCurrentReels(free, bonus) -- 更改 bonus 的棋盘
end

function _baseViewCtl:getMainReel( )
	return nil
end
function _baseViewCtl:getFreeReel( )
	return nil
end
function _baseViewCtl:getBonusReel( )
	return nil
end

function _baseViewCtl:resetCurrentReels( isFree ,isBouns) -- 重置freespin 的滚轴
	if not self.theme_reels then
		return
	end
	if (self.freeCtl and self.freeCtl:isFGEnd()) and not isFree then
		self.currentReels = self:getMainReel() or self.theme_reels["main_reel"]
	else
		self.currentReels = self:getFreeReel() or self.theme_reels["free_reel"]
	end
	if isBouns then 
		self.currentReels = self:getBonusReel() or self.theme_reels["bonus_reel"]
	end

	if not self.currentReels then return end
	self.currentReelsIndex = {}
	for col,reelDataList in pairs(self.currentReels) do
		local isSingleReel = false
		self.currentReelsIndex[col] = self:getReelRandomIndex(col, reelDataList, isSingleReel)
	end
end

function _baseViewCtl:getReelRandomIndex(col, reelDataList, isSingleReel)
	local retIndex = math.random(1, #reelDataList)
	if isSingleReel then
		local proIndex = retIndex
		local theIndex = proIndex+1
		local function checkTheIndex()
			local proKey = reelDataList[proIndex]
			local theKey = reelDataList[theIndex]
			if not theKey or not proKey then
				return false
			end
			if proKey == theKey then
				return true
			end
			local theSet = {111, 101}--"b", "d"
			if type(theKey) == "string" and not theSet[theKey] then
				local tbData  = bole.splitStr(theKey, "_")
				local theNum  = tonumber(tbData[2])
				if theNum and theNum==1 then
					return false
				else
					return true
				end
			end
			return false
		end
		while checkTheIndex() do			
			proIndex = retIndex+1
			theIndex = proIndex+1
			retIndex = proIndex
		end
	end
	return retIndex
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- @ reel action
function _baseViewCtl:onSpinStart( )
	-- self:stopActionByTag(777)
	-- self:stopActionByTag(987)
	self.playGame = false
	self.canFastStop = true
	self.ExtraStopCD = 0
	self.hintMusicCnt = 0
	-- if bole.isMusicMute() then
		if self.playNormalLoopMusic then
			self:dealMusic_PlayNormalLoopMusic()
			self.playNormalLoopMusic = false
		end
	-- end
 
	if self.jackpotTips then
		for k,v in pairs(self.jackpotTips) do
			v:hide()
		end
	end

	EventCenter:pushEvent(EVENTNAMES.THEME.SPIN_START)
end

function _baseViewCtl:onSpinStop( rets )
	
end

-- 说明：stop开始控制函数
-- 作用：在通用框架下，控制开始stop的时机
-- 注意：必须要与Theme:checkCanSetStopBtn( rets )共同进行控制
function _baseViewCtl:stopControl( stopRet, stopCallFun )

	if self.freeCtl then 
		self.freeCtl:freeStopCtl(stopRet)
	end
	
	stopCallFun()
end

function _baseViewCtl:onAllReelStop( )
	local delayTime = 0;
	 
	for k,theCell in pairs(self.spinLayer.spins) do
		delayTime = delayTime + 0.01
		self.spinLayer:runAction(	
			cc.Sequence:create(
				cc.DelayTime:create(delayTime),
				cc.CallFunc:create(function ()
					theCell:diamondFly()
				end))
			)
	end
	-- body
end
function _baseViewCtl:finshSpin( )
	-- todo
end
----------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:spinBoard( spinTag )
	self.fastStopMusicTag     = nil
	self.reelStopMusicTagList = {}
	self.spinCacheTag = spinTag
	self:onSpinBoard(self.spinCacheTag) -- 播放音效
	if G_THEME_FAST_TAG then
		self.isTurbo = true
	else 
		self.isTurbo = false
	end
	self.mainView:getCurSpinLayer():spin(self:getSpinConfig(self.spinCacheTag))
end

function _baseViewCtl:stopBoard(ret, endCallFunc,interval)
	self:onStopBoard(self.spinCacheTag)
	local theItemList = ret["item_list"] -- ret["reelItem_list"] or 
	self.mainView:getCurSpinLayer():stop(self:getStopConfig(ret,self.spinCacheTag,interval), theItemList,ret["item_list_up"],ret["item_list_down"],endCallFunc)
end

function _baseViewCtl:onSpinBoard( spinTag )
	if self.playDelayFadeOutLoopMusic then
		self:stopDelayToFadeOutAction()
		self.playDelayFadeOutLoopMusic = false
	end
	
	self.audioCtl:dealMusic_OutMuteLoopMusic()--commonMusic: 恢复背景音乐
end

function _baseViewCtl:onStopBoard( spinTag )
end

function _baseViewCtl:getSpinConfig( spinTag )
	local spinConfig = {}

	for col,_ in pairs(self.mainView:getCurSpinLayer().spins) do
		
		local theStartAction = self:getSpinColStartAction(col)-- 上弹数据获取 
		local theReelConfig = {-- 上弹之后加速运动数据获取
			["col"]     = col,
			["action"]  = theStartAction,
			["delay"] 	= 0,
		}
		table.insert(spinConfig, theReelConfig)
	end	
	return spinConfig
end

function _baseViewCtl:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}

	for col, _ in pairs(self.mainView:getCurSpinLayer().spins) do
		local theAction = self:getSpinColStopAction(ret["theme_info"], col,interval)
		table.insert(stopConfig, {col, theAction})
	end 
	return stopConfig
end

function _baseViewCtl:getSpinColStartAction( pCol, reelCol)
	local _reelSpinConfig = self.gameConfig.reel_spin_config

    local spinAction = {}
    spinAction.delay = _reelSpinConfig.delay*(pCol-1)
    spinAction.upBounce = _reelSpinConfig.upBounce
    spinAction.upBounceMaxSpeed = _reelSpinConfig.upBounceMaxSpeed
    spinAction.upBounceTime = _reelSpinConfig.upBounceTime
    spinAction.speedUpTime = _reelSpinConfig.speedUpTime
    spinAction.maxSpeed = _reelSpinConfig.maxSpeed

    self:getSpinColStartActionSpecial(spinAction, pCol, reelCol)
    local nextDelay = nil

    return spinAction, nextDelay
end

function _baseViewCtl:getSpinColStopAction(themeInfoData, pCol, interval)

	local _reelSpinConfig = self.gameConfig.reel_spin_config

	if pCol == 1 then -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end

	local checkNotifyTag   = self:checkNeedNotify(pCol)
	if checkNotifyTag then
		self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
	end

	local spinAction = {}
	spinAction.actions = {}

    local temp = interval - _reelSpinConfig.speedUpTime - _reelSpinConfig.upBounceTime
    local timeleft = _reelSpinConfig.rotateTime - temp > 0 and _reelSpinConfig.rotateTime - temp or 0
	
    local _stopDelay = _reelSpinConfig.stopDelay
	local _downBonusT = _reelSpinConfig.downBounceTime

    spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
    self.ExtraStopCD = _reelSpinConfig.spinMinCD - temp > 0 and _reelSpinConfig.spinMinCD - temp or 0

	spinAction.maxSpeed = _reelSpinConfig.maxSpeed
	spinAction.speedDownTime = _reelSpinConfig.speedDownTime
	if self.isTurbo and not self:overAutoSpeed() then
		spinAction.speedDownTime = spinAction.speedDownTime - 20/60 --  * 3/4
	end
	spinAction.downBounce = _reelSpinConfig.downBounce
	spinAction.downBounceMaxSpeed = _reelSpinConfig.downBounceMaxSpeed
	spinAction.downBounceTime = _downBonusT
	spinAction.stopType = 1
	return spinAction
end
function _baseViewCtl:overAutoSpeed()
	return false
end

function _baseViewCtl:getSpinColStartActionSpecial( spinAction, pCol, reelCol )

end

function _baseViewCtl:onReelFallBottom( pCol )
	-- 标志位
	self.reelStopMusicTagList[pCol] = true	
	-- 列停音效，提示动画相关
	self:onReelFallBottomJiLi(pCol)

	if not self:checkPlaySymbolNotifyEffect(pCol) then
		self:dealMusic_PlayReelStopMusic(pCol)
	end

	if self:checkSpeedUp(pCol + 1) then
		self:onReelNotifyStopBeg(pCol +1)
	end
	self:stopReelNotifyEffect(pCol)
end

function _baseViewCtl:onReelFastFallBottom( pCol )
	self.reelStopMusicTagList[pCol] = true
	-- 列停音效，提示动画相关
	if not self.fastStopMusicTag then
		local hasNotify = false
		for col=pCol,#self.mainView:getCurSpinLayer().spins do
			local reelSymbolState = self.notifyState[col]
			if reelSymbolState and bole.getTableCount(reelSymbolState)>0 then
				hasNotify = true
				break
			end
		end
		if not hasNotify then
			self:dealMusic_PlayReelStopMusic(pCol)
		end	
	end

	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	self:checkPlaySymbolNotifyEffect(pCol)
	self:stopReelNotifyEffect(pCol)
	
	self:onReelFallBottomJiLi(pCol, true)

	self:updateCellFastOtherAssets(pCol)
end

function _baseViewCtl:checkSpeedUp(checkCol) -- 控制出现特殊的龙 虎 预示好事发生的动画的时候 取消单个轴的 加速操作
	local isNeedSpeedUp = false
	if not self.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol])>0 then
		isNeedSpeedUp = true
	end
	return isNeedSpeedUp
end

function _baseViewCtl:onReelFallBottomJiLi( pCol, isFastFall )
	
end


----------------------------------------------------------------------------------------------------------------------------------
--@ 滚轴结果解析
function _baseViewCtl:genSpecials( pWinPosList, realItemList )
	local specials 	 = {}
	local _symbol_config = self.gameConfig.symbol_config
	local scatterKeySet = Set(_symbol_config.scatter_key_list) 
	for _, key in pairs(_symbol_config.scatter_key_list) do 
		specials[key] = {}
	end

	local itemList   = realItemList or self:getRetMatrix()
	if itemList then
		local endCol = self.gameConfig.theme_config and self.gameConfig.theme_config.base_col_cnt or 5
		for col = 1, endCol  do
			local colItemList = itemList[col]
			if colItemList then 
				for row,theKey in pairs(colItemList) do
					if scatterKeySet[theKey] then
						specials[theKey][col] 	   	= specials[theKey][col] or {}
						specials[theKey][col][row] 	= true
					end
				end
			end
		end
	end
	self.specials = specials	
	return specials
end

function _baseViewCtl:genSpecialSymbolState( rets )
	rets = rets or self.rets -- 复制 通用逻辑
	if not self.checkItemsState then
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置

		self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter
		self:genSpecialOtherSymbolState(rets)
	end
end

function _baseViewCtl:genSpecialSymbolStateInNormal(rets)
	local cItemList   = rets.item_list
	local checkConfig = self.specialItemConfig
	for itemKey,theItemConfig in pairs(checkConfig) do
		local itemType     = theItemConfig["type"]
		local itemCnt  	   = 0
		local isBreak 	   = false
		local baseColCnt = self.gameConfig.theme_config.base_col_cnt or 5
		if itemType then
			for col=1, #self.mainView:getCurSpinLayer().spins do
				itemCnt = col % baseColCnt == 1 and 0 or itemCnt
				local checkDataCol = (col - 1) % baseColCnt + 1

				local colItemList  = cItemList[col]
				local colRowCnt    = self.mainView:getCurSpinLayer().spins[col].row -- self.colRowList[col]
				local curColMaxCnt = theItemConfig["col_set"][checkDataCol] or colRowCnt
				-- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
				local isGetFeature = false
				if itemCnt >= theItemConfig["min_cnt"] then
					isGetFeature = true
				end
				-- 判断是否可能中feature或者更大的feature   一般用于滚轴加速
				local willGetFeatureInCol = false
				if curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
					willGetFeatureInCol = true
					self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
					self.speedUpState[col][itemKey] = true
				end
				-- 判断当前列加上之后所有列是否有可能中feature
				local willGetFeatureInAfterCols = false
				
				local sumCnt = 0
				for tempCol=(col-1)%baseColCnt + 1, baseColCnt do
					local tmpColMaxCnt = theItemConfig["col_set"][tempCol] or colRowCnt
					sumCnt = sumCnt + tmpColMaxCnt
				end
				if sumCnt>0 and (itemCnt+sumCnt)>=theItemConfig["min_cnt"] then
					willGetFeatureInAfterCols = true				
				end
				
				self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
				if curColMaxCnt>0 and willGetFeatureInAfterCols then
					for row, theItem in pairs(colItemList) do
						if theItem == itemKey then
							self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
							table.insert(self.notifyState[col][itemKey], {col, row})
						end
					end
				end
				for row, theItem in pairs(colItemList) do
					if theItem == itemKey then
						itemCnt = itemCnt + 1
					end
				end
			end
		end
	end	
end

function _baseViewCtl:genSpecialOtherSymbolState( )
	-- body
end
----------------------------------------------------------------------------------------------------------------------------------
-- @落地音效和动画解析
function _baseViewCtl:checkIsFastStop( ... )
	return self.fastStopMusicTag
end

function _baseViewCtl:checkPlaySymbolNotifyEffect( pCol ) 
	local isPlaySymbolNotify = false
	self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音

	if not self.fastStopMusicTag then -- 判断是否播放特殊symbol的动画
		isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画

		self:playSymbolStopLoopEffect(pCol) -- check 一下当前列 播放循环动画的symbol
	else
		local endCol = #self.mainView:getCurSpinLayer().spins
		if pCol == endCol then
			local _reel_stop_config = self.gameConfig.reel_stop_config

			local haveSymbolLevel = _reel_stop_config.max_stop_level -- 普通下落音的等级
			for col, colData in pairs(self.notifyState) do -- 判断在剩下停止的滚轴中是否有特殊symbol
			 	if bole.getTableCount(colData) > 0 then
					for checkKey, stopLevel in pairs( _reel_stop_config.symbol_stop_level ) do
						if colData[checkKey] then
							if haveSymbolLevel > stopLevel then
								haveSymbolLevel = stopLevel
							end
						end
					end

					self:playSymbolNotifyEffect(col) -- 播放特殊symbol 下落特效

					self.notifyState[col] = {}
				end
			end
			if haveSymbolLevel< _reel_stop_config.max_stop_level then
				self.audioCtl:playEffectWithInterval(self.audio_list["special_stop" .. haveSymbolLevel])
				isPlaySymbolNotify = true
			end

			for _col = 1 , endCol do 
				self:playSymbolStopLoopEffect(_col) -- check 一下当前列 播放循环动画的symbol
			end
		end
	end

	return isPlaySymbolNotify
end


function _baseViewCtl:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.notifyState = self.notifyState or {}
	
	if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then 
		return false
	end
	local colNotifyState = self.notifyState[pCol]

	local _reel_stop_config = self.gameConfig.reel_stop_config
	local haveSymbolLevel = _reel_stop_config.max_stop_level -- 普通下落音的等级

	for checkKey, stopLevel in pairs( _reel_stop_config.symbol_stop_level ) do
		if colNotifyState[checkKey] then
			if haveSymbolLevel > stopLevel then
				haveSymbolLevel = stopLevel
			end
		end
	end

	if haveSymbolLevel < _reel_stop_config.max_stop_level then 
		self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效

		self.audioCtl:playEffectWithInterval(self.audio_list["special_stop" .. haveSymbolLevel])
		self.notifyState[pCol] = {}
		return true
	end
end

function _baseViewCtl:playSymbolNotifyEffect( pCol, reelSymbolState ) 
	self.mainView:playSymbolNotifyEffect(pCol, reelSymbolState)
end

function _baseViewCtl:playSymbolStopLoopEffect(pCol)
	self.mainView:playSymbolStopLoopEffect(pCol)
end

function _baseViewCtl:playReelNotifyEffect( pCol )
	-- todo
end
function _baseViewCtl:stopReelNotifyEffect( pCol )
	-- todo
end
----------------------------------------------------------------------------------------------------------------------------------
--@主题 handle 相关
function _baseViewCtl:onThemeInfo(specialData,callFunc)
 	if callFunc then
 		callFunc()
 	end
end

-- TODO 修改实现
function _baseViewCtl:onSpecialWin( endCallfunc )
	if endCallfunc then
		endCallfunc()
	end

end


----------------------------------------------------------------------------------------------------------------------------------
-- @ free 相关
function _baseViewCtl:playStartFreeSpinDialog( theData )
	if theData.enter_event then 
		theData.enter_event()
	end
	if theData.click_event then 
		theData.click_event()
	end
	if theData.changeLayer_event then 
		theData.changeLayer_event()
	end
	if theData.end_event then 
		theData.end_event()
	end
end
function _baseViewCtl:playMoreFreeSpinDialog( theData )
	if theData.enter_event then 
		theData.enter_event()
	end
	if theData.click_event then 
		theData.click_event()
	end
	if theData.end_event then 
		theData.end_event()
	end
end
function _baseViewCtl:playCollectFreeSpinDialog( theData )
	if theData.enter_event then 
		theData.enter_event()
	end
	if theData.click_event then 
		theData.click_event()
	end
	if theData.changeLayer_event then 
		theData.changeLayer_event()
	end
	if theData.end_event then 
		theData.end_event()
	end
end

function _baseViewCtl:playBackBaseGameSpecialAnimation( theSpecials ,enterType)
	return self:playFreeSpinItemAnimation(theSpecials ,enterType)
end
----------------------------------------------------------------------------------------------------------------------------------
--@断线重连
-- free
function _baseViewCtl:setFreeGameRecoverState(data)
	if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
		self.isFreeGameRecoverState = true
	end
end

function _baseViewCtl:setDealFreeCollectState()
    self.spin_processing = true
    self.isProcessing  = true
end


-- function _baseViewCtl:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
-- 	if self.freeCtl then 
-- 		self.freeCtl:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
-- 	-- else

-- 	-- 	ret["free_spins"]		= theFreeSpinData.free_spins

-- 	-- 	self.isProcessing  = true
-- 	-- 	self.footer:setSpinButtonState(true) 
-- 	-- 	self.footer:enableOtherBtns(false) 

-- 	-- 	if theFreeSpinData.item_list then
-- 	-- 		local realItemList = theFreeSpinData.item_list

-- 	-- 		self.mainView:resetBoardCellsByItemList(realItemList)

-- 	-- 		self.freeItem = tool.tableClone(realItemList)
-- 	-- 		self.specials = self:getSpecialTryResume(realItemList)
-- 	-- 		self.freeSpeical = self:getSpecialTryResume(realItemList)
-- 	-- 	end
-- 	-- 	self:free_spins(ret)
-- 	end
-- end

function _baseViewCtl:getSpecialTryResume(realItemList)
	return self:genSpecials(nil, realItemList)
end

function _baseViewCtl:resetPointBet() -- 仅仅在断线的时候 被调用了
end
-- bonus
function _baseViewCtl:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.isProcessing  = true
	self:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function _baseViewCtl:overBonusByEndGame(data) -- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面
	if data.total_win then 
		self.totalWin = data.total_win
	end
	if data.jp_win then
		for k,v in pairs(data.jp_win) do 
			if v.jp_win then 
				self.totalWin = self.totalWin +  v.jp_win
			end
		end
	end
	self.isProcessing  = false

	if self:isInFG() then
		local _free_win = self:isInFG()
		self.totalWin = _free_win + self.totalWin

		if self.freeCtl then 
			self.freeCtl:updateFreeWin(self.totalWin)
		end
		
		self:updateFooterCoin()
	else
		self:unlockLobbyBtn()
		self:removePointBet()
		self:updateFooterCoin()
		self:addCoinsToHeader()
	end
end

function _baseViewCtl:saveBonusData(bonusData)
	if self.rets then
		self.bonusItem 	= tool.tableClone(self.rets.item_list)
		self.bonusRet 	= self.rets
		self.bonusSpeical = self.specials
	end	
end

function _baseViewCtl:outBonusStage()
	if self.bonusSpeical then 
		self.specials = self.bonusSpeical
	end

	if self.bonusItem then
		self.rets.item_list = self.bonusItem
		self:resetBoardCellsSpriteOverBonus(self.bonusItem) -- 刷新牌面 + 动画播放
	end
	self.bonusItem    = nil	
	self.bonusRet     = nil
end

function _baseViewCtl:saveBonusCheckData( bonusData ) -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
	local data = {}
	data["bonus_id"] = bonusData.bonus_id
	LoginControl:getInstance():saveBonus(self.themeid, data)
end

function _baseViewCtl:cleanBonusSaveData( data ) -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
	LoginControl:getInstance():saveBonus(self.themeid, nil)
end

----------------------------------------------------------------------------------------------------------------------------------
--@bet
function _baseViewCtl:setBet(unlockBet)
    local set_Bet = unlockBet
    local maxBet = self:getMaxBet()
    if maxBet >= set_Bet then
        self:setCurBet(set_Bet)
    end
end

------------------------gold spin ------------------------------------------------
function _baseViewCtl:getGoldSpinStatus()
	-- local isIphonex = cc.UserDefault:getInstance():getStringForKey("is_iphonex")
	-- if appDebugMode and isIphonex and isIphonex == "1" then
	-- 	return true
    -- end
	return false
end
function _baseViewCtl:setGoldSpinHideGameRuleList()
	if not self:getGoldSpinStatus() then
		self.hideGameRuleList = nil
	end
end

----------------------------------------------------------------------------------------------------------------------------------
-- @音效控制
local tag_n3_playing = 33333
function _baseViewCtl:lockThemeVoices(time)
	self.n3_playing = true
	self.node:stopActionByTag(tag_n3_playing)
	local action = cc.Sequence:create(cc.DelayTime:create(time or 3), cc.CallFunc:create(function()
		self.n3_playing = false
	end))
	action:setTag(tag_n3_playing)
	self.node:runAction(action)
end


local delay_fade_out_loop = 123111
function _baseViewCtl:setDelayToFadeOutLoopMusic( ... ) -- 新增，静音音效
	if self:noFeatureLeft() and not self.autoSpin and not self.playDelayFadeOutLoopMusic then 
		self.playDelayFadeOutLoopMusic = true
		self.node:stopActionByTag(delay_fade_out_loop)

		local action = cc.Sequence:create(
			cc.DelayTime:create(5), 
			cc.CallFunc:create(function()
				self:dealMusic_FadeLoopMusic(2,1,0)
			end))
		action:setTag(delay_fade_out_loop)

		self.node:runAction(action)
	end

end

function _baseViewCtl:stopDelayToFadeOutAction( ... )
	self.node:stopActionByTag(delay_fade_out_loop)
	-- self.audioCtl:dealMusic_OutMuteLoopMusic()
end


function _baseViewCtl:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效
	self:playMusicByName("reel_notify", true, false)
	self.playR1Col = pCol
end
function _baseViewCtl:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end

	self.playR1Col = nil
	self.audioCtl:stopMusic(self.audio_list.reel_notify,true)
end

-- 转轮停止声音
function _baseViewCtl:dealMusic_PlayReelStopMusic( pCol )
	self.audioCtl:playEffectWithInterval(self.audio_list["reel_stop"],0.1,false)
end

-- 播放free games的背景音乐
function _baseViewCtl:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
	self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.free_background)
end

-- -- freespin音效相关
-- function _baseViewCtl:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
-- 	self:playMusicByName("free_dialog_start_show")
-- end
-- function _baseViewCtl:dealMusic_StopFSEnterMusic( )
-- 	self:stopMusicByName("free_dialog_start_show")
-- end
-- function _baseViewCtl:dealMusic_PlayFSEnterClickMusic( )
-- 	self:playMusicByName("free_dialog_start_close")
-- end

-- -- retrigger
-- function _baseViewCtl:dealMusic_PlayFSMoreMusic( )
-- 	self:playMusicByName("free_dialog_more_show")
-- end

-- function _baseViewCtl:dealMusic_StopFSMoreMusic( )
-- end

-- function _baseViewCtl:dealMusic_PlayFSMoreClickMusic( )
-- 	self:playMusicByName("free_dialog_more_close")
-- end

-- --Free Game 收集音乐
-- function _baseViewCtl:dealMusic_PlayFSCollectMusic( )
-- 	self:playMusicByName("free_dialog_collect_show")
-- end
-- function _baseViewCtl:dealMusic_StopFSCollectMusic( )
-- 	self:stopMusicByName("free_dialog_collect_show")
-- end
-- function _baseViewCtl:dealMusic_PlayFSCollectClickMusic()
-- 	self:playMusicByName("free_dialog_collect_click")
-- end
-- function _baseViewCtl:dealMusic_PlayFSCollectEndMusic( )
-- 	self:playMusicByName("free_dialog_collect_close")
-- end



function _baseViewCtl:configAudioList( )
	self.audio_list =
	{
		-- base
		base_background  		= "audio/base/base_bgm.mp3",
		reel_stop        		= "audio/base/reel_stop.mp3",
		anticipation 	 		= "audio/base/anticipation.mp3", -- 特殊下砸声音
		trigger_bell	 		= "audio/base/bell.mp3",
		symbol_scatter   		= "audio/base/symbol_scatter.mp3",
		reel_notify		 		= "audio/base/reel_notify.mp3",

		transition_free 		= "audio/base/transition_free.mp3", 	-- base 切屏
		transition_bonus 		= "audio/base/transition_bonus.mp3",	-- bonus 切屏
		transition_free_pick 	= "audio/base/transition_free.mp3", 	-- 进入Free之前的 freeRandomPick 游戏 first 游戏

		-- free
		free_background  		= "audio/free/free_bgm.mp3",
		retrigger_bell	 		= "audio/base/bell_fg.mp3",
		theme_store_coin_fly     = "store/audio/theme_store_coins_fly.mp3",
		theme_store_tip          = "store/audio/dialog_in.mp3",

		-- bonus
		bonus_background 		= "audio/bonus/bonus_bgm.mp3",
		wheel_background 		= "audio/wheel/wheel_bgm.mp3",
		-- rollup
		rollup01		 		= "audio/base/win1.mp3",
		rollup01_end	 		= "audio/base/win1end.mp3",
		rollup02		 		= "audio/base/win2.mp3",
		rollup02_end	 		= "audio/base/win2end.mp3",
		rollup03		 		= "audio/base/win3.mp3",
		rollup03_end	 		= "audio/base/win3end.mp3",
		rollup04		 		= "audio/base/win4.mp3",
		rollup04_end	 		= "audio/base/win4end.mp3",

		-- 弹窗
		free_dialog_start_show 	= "audio/free/free_dialog_start_show.mp3",
		free_dialog_start_close = "audio/free/free_dialog_start_close.mp3",
		free_dialog_more_show 	= "audio/free/free_dialog_more_show.mp3",
		free_dialog_more_close  = "audio/free/free_dialog_more_close.mp3",
		free_dialog_collect_show  = "audio/free/free_dialog_collect_show.mp3",
		free_dialog_collect_click = "audio/free/free_dialog_collect_click.mp3",
		free_dialog_collect_close = "audio/free/free_dialog_collect_close.mp3",

		bonus_start_show		= "audio/bonus/bonus_start_show.mp3",
		bonus_end_show			= "audio/bonus/bonus_end_show.mp3",
		pick_start_show			= "audio/pick/pick_start_show.mp3",
		pick_end_show			= "audio/pick/pick_end_show.mp3",
		wheel_start_show		= "audio/wheel/wheel_start_show.mp3",
		wheel_end_show			= "audio/wheel/wheel_end_show.mp3",
		win_jp_show				= "audio/base/win_jp_show.mp3",	  -- win jp 弹窗显示音效
		win_jp_click			= "audio/base/win_jp_click.mp3",  -- win jp 弹窗点击音效
		win_rapidpay_show		= "audio/base/win_rapidpay_show.mp3",  -- win rapidpay 弹窗点击音效	
		win_rapidpay_click		= "audio/base/win_rapidpay_click.mp3",  -- win rapidpay 弹窗点击音效
		common_click 			= "audio/base/click.mp3", -- 通用点击音效
	}

	-- whj 新加 rollup 伴随的人声
	self.audio_win_list = {
		commonrollup03			= "sounds/bigwin/common_win3.mp3",
		commonrollup03_end		= "sounds/bigwin/common_win3end.mp3",
		commonrollup04			= "sounds/bigwin/common_win4.mp3",
		commonrollup04_end		= "sounds/bigwin/common_win4end.mp3",

		peopelrollup01			= "sounds/bigwin/win_bigwin.mp3",
		peopelrollup02			= "sounds/bigwin/win_hugewin.mp3",
		peopelrollup03			= "sounds/bigwin/win_massivewin.mp3",
		peopelrollup04			= "sounds/bigwin/win_apocalypticwin.mp3",
	}
	if self.game_store_version == GameStoreType.SLOT_MACHINE_H 
	or self.game_store_version == GameStoreType.SLOT_MACHINE_V 
	or self.game_store_version == GameStoreType.SLOT_MACHINE_I_V then
		self:initSlotMachineMusic()
	end
end
function _baseViewCtl:initSlotMachineMusic()
	--slot
	self.slot_audio_list = {}
	self.slot_audio_list.slot_popup = "audio/slot_popup.mp3"
	self.slot_audio_list.slot_spin = "audio/slot_spin.mp3"
	self.slot_audio_list.slot_win = "audio/slot_win.mp3"
end

----------------------------------------------------------------------------------------------------------------------------------
-- @ 部分通用 
function _baseViewCtl:getReelCellPos( value ) -- 横向排序
    if value then 
    	local baseColCnt = self.gameConfig.theme_config.base_col_cnt or 5
		local col = (value - 1) % baseColCnt + 1
		local row = math.floor((value - 1) / baseColCnt) + 1
		return {col, row}
    end
end

function _baseViewCtl:getPic( name )
	return string.format("theme_resource/theme%d/%s", self.themeResourceId, name)
end
function _baseViewCtl:getSlotPath(name)
    local slotID = self:getThemeSmallSlot()
    return string.format("theme_resource/theme%d/%s", slotID, name)

end
function _baseViewCtl:getThemeSmallSlot()

    if self.game_store_version == GameStoreType.SLOT_MACHINE_V then
        return 2008
    end
    if self.game_store_version == GameStoreType.SLOT_MACHINE_H then
        return 2009
    end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_I_V then 
		return 2011
	end
end


---------------------BaseAudioControl--------------------
-- 播放背景音乐
function _baseViewCtl:playLoopMusic( name)
	-- if self:isExistFile(name) and bole.isMusicMute() then
		if self:isExistFile(name) then
			local singleton = true
			local loop = true
			local audioFile = self:getPic(name)
			AudioControl:playMusic("music", audioFile, singleton, loop)
		end
	-- end
end

-- 结束所有背景音乐
function _baseViewCtl:stopAllLoopMusic( )
	AudioControl:stopGroupAudio("music")
end

function _baseViewCtl:refreshAllAudioVolume( )
	AudioControl:refreshAllAudioVolume()
end
-- 结束背景音乐
function _baseViewCtl:stopLoopMusicForStage( stageType)
end
function _baseViewCtl:dealRecoverBgm()
    if self and self.audio_list and self.audio_list.base_background then
        self:dealMusic_PlayNormalLoopMusic()
    end
end
-- 播放base game的背景音乐
function _baseViewCtl:dealMusic_PlayNormalLoopMusic()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self.audioCtl:playLoopMusic(self.audio_list.base_background)
end

-- 播放bonus game的背景音乐
function _baseViewCtl:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.bonus_background)
end
function _baseViewCtl:playBgmByName(file_name)
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list[file_name])
end
-- 结束bonus game的背景音乐
function _baseViewCtl:dealMusic_ExitBonusGame()
	local name = self.audio_list.base_background
	local stageType = 1
	if self:isInFG() then
		name = self.audio_list.free_background
		stageType = 2
	end

	-- 播放背景音乐
	self:playLoopMusic(name)
end

function _baseViewCtl:dealMusic_ExitPickGame()
	local name = self.audio_list.free_background
	-- 播放背景音乐
	self:playLoopMusic(name)
end


function _baseViewCtl:playRollupSound( mul )
	self.audioCtl:playRollupSound(mul)
end


-- 结束rollup声音
function _baseViewCtl:stopRollupSound( mul )
	self.audioCtl:stopRollupSound(mul)
end
-- 结束rollup行为，默认调用stopRollupSound
function _baseViewCtl:stopRollUpFunction(mul)
	self:stopRollupSound(mul)
end

function _baseViewCtl:dealMusic_PlayWinMusic( rets, totalBet )
end

-- 进入主题
function _baseViewCtl:dealMusic_PlayEnterMusic( )
	
end

-- symbol音效相关
function _baseViewCtl:dealMusic_PlayThemeItemMusic( name, isSingle )
	self:playMusicByName(name, isSingle)
end

-- 打铃音效相关
function _baseViewCtl:dealMusic_PlayTriggerBellMusic()
	self:playMusicByName("trigger_bell", false)
end


-- 声音从最大声音渐变到静音
function _baseViewCtl:dealMusic_FadeOutLoopMusic()
	self.audioCtl:dealMusic_FadeOutLoopMusic()
end


function _baseViewCtl:playEffect( name, volume)
	local audioFile = "audio/"..name
	if self:isExistFile(audioFile..".mp3") then
		audioFile = self:getPic(audioFile..".mp3")
	elseif self:isExistFile(audioFile..".ogg") then
		audioFile = self:getPic(audioFile..".ogg")
	elseif self:isExistFile(audioFile..".wav") then
		audioFile = self:getPic(audioFile..".wav")
	else
		return
	end
	AudioControl:playEffect(audioFile,false )
end

function _baseViewCtl:dealMusic_NoWinMusic()
	if not self._music_no_Cnt then
		self._music_no_Cnt = 0
		--确定 v.mp3 个数，上限20
		for i=1,20 do
			if self:isExistFile("audio/no win "..i..".mp3") then
				self._music_no_Cnt = self._music_no_Cnt + 1
			else
				break
			end
		end
	end
	if self.NoWinCnt >= 4 and not self.n3_playing and math.random(0,99) < 3 and self._music_no_Cnt>=1 then
		-- AudioControl:playSpecialEffect(string.format(self:getPic("audio/no win %d.mp3"), math.random(1,self._music_no_Cnt)))
		self:lockThemeVoices()
	end
end

function _baseViewCtl:dealMusic_PlaySpecialSpeedMusic() -- 突然加速的音效(打鼓)
	bole.playMusic("special_speed", nil, nil, self:getPic("audio/"))
end

-- 滚轮音效相关
function _baseViewCtl:dealMusic_TouchBtnSpinMusic( )
	bole.playMusic("14_reel_click", nil, nil, "sounds/")
end

-- 停止音乐渐变动作
function _baseViewCtl:dealMusic_OutLoopMusicFade( )
	if self.fadeMusicActionNode then
		self.fadeMusicTag = false
		bole.cleanAction(self.fadeMusicActionNode)
	end
end
----------------BaseAudioControl End------------------------

--@ Theme 整个迁移进来------------------------------------------------------------------------------------------------------------------------------
-- nsm
------------------------------------------------------------------------------------------------------------------------------
G_THEME_SYMBOL_TYPE = {
	NUMBER  	= 2,
	ONLINE  	= 3,
	SERIES  	= 4,
	COLCOUNT 	= 5,

}

function _baseViewCtl:getWinEffectPath()
	return "commonEffect/winCoinsEffects/default/"
end

function _baseViewCtl:updateJackpotScale(ui)
	local maxWidth = ui.maxWidth
	if maxWidth then
		local tempWidth = ui:getContentSize().width
		local scale = maxWidth/tempWidth
		local endScale = (scale > ui.baseScale) and ui.baseScale or scale
		ui:setScale(endScale)
	end
-- body
end

--------------------------------------------------------------------------------------------------------------------------------
-- loading
-- 其中preLoadResAsync,checkResAndDeal,loadAllMusics都已经提到ThemeControl
--------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:onLoading_0( ... )
	bole.playMusic("09_game_loading", nil, nil, "sounds/")
end

function _baseViewCtl:onLoading_100( ... )
	-- local duration = 0
	-- if bole.codeEnterThemeTime and type(bole.codeEnterThemeTime) == "number" then
	-- 	duration =  os.time() - bole.codeEnterThemeTime
	-- end
	-- Splunk:getInstance():send_codeInfo("inslotsuc", { t = duration})
end




function _baseViewCtl:getThemeLoaddinView( ... )
	-- whj 修改逻辑 不再 去每个 主题下面去判断是否有资源
	local loadCsbFile = "theme_loading/theme" .. THEME_LIST[self.themeid]['resourceId'] .. "/loading2/theme" .. THEME_LIST[self.themeid]['loadingId'] .. "_loading.csb"
	if cc.FileUtils:getInstance():isFileExist(loadCsbFile) then
		if G_LOADING_VIEWS[self.themeid] then
			return G_LOADING_VIEWS[self.themeid].new(self)
		else
			if self.themeid == 3128 or self.themeid == 3139 or self.themeid == 3142 or self.themeid == 3137 then
				local csb = "stamps/loading/themeloading_h.csb"
				if THEME_LIST[self.themeid]['portrait'] == 1 then
					csb = "stamps/loading/themeloading_v.csb"
				end
				return G_LOADING_VIEWS["base"].new(self,csb)
			else
				return G_LOADING_VIEWS["base"].new(self)
			end
			
		end
	else
		if self.themeid == 3128 or self.themeid == 3139 or self.themeid == 3142 or self.themeid == 3137 then
			local csb = "stamps/loading/themeloading_h.csb"
			if THEME_LIST[self.themeid]['portrait'] == 1 then
				csb = "stamps/loading/themeloading_v.csb"
			end
			return G_LOADING_VIEWS["base"].new(self,csb)
		else
			return G_LOADING_VIEWS["public"].new(self)	
		end	
	end
end

function _baseViewCtl:onInitConfig( data )
	------------------------------------------------------------
	-- 棋盘的初始化
	------------------------------------------------------------
	local boardConfig  		= self:getBoardConfig()
	self:initBoardAndReelConfig(boardConfig)
	-- self.normalKeyList, self.specialKeyList, self.pics, self.keys
	local normalSymbolList  	= self.ThemeConfig["theme_symbol_coinfig"]["normal_symbol_list"] or {}
	local specialSymbolList 	= self.ThemeConfig["theme_symbol_coinfig"]["special_symbol_list"] or {}
	local noRollSymbolList 		= self.ThemeConfig["theme_symbol_coinfig"]["no_roll_symbol_list"] or {}
	local specialSymbolConfig 	= self.ThemeConfig["theme_symbol_coinfig"]["special_symbol_config"] or {}
    local slotMachineKeyList    = self.ThemeConfig["theme_symbol_coinfig"]["slot_machine_symbol_list"] or {}
    self.RollSymbolInFreeList 	= self.ThemeConfig["theme_symbol_coinfig"]["roll_symbol_inFree_list"] or {}
    self.symbolZOrderList 		= self.ThemeConfig["theme_symbol_coinfig"]["symbol_zorder_list"] or {}
    self.symbolPosAdjustList    = self.ThemeConfig["theme_symbol_coinfig"]["symbol_pos_adjust_list"] or {}
	self:initPicsAndKeys(normalSymbolList, specialSymbolList, noRollSymbolList, specialSymbolConfig)
    self:initSlotMachineKeys(slotMachineKeyList)
	-- self.themeType, self.ThemeTypeConfig, self.lines, self.maxLine
	local themeType  		= self.ThemeConfig["theme_type"]
	local themeTypeConfig 	= self.ThemeConfig["theme_type_config"]
	self:initThemeType(themeType, themeTypeConfig)
	
end
function _baseViewCtl:initPicsAndKeys( normalSymbolList, specialSymbolList, noRollSymbolList, specialSymbolConfig )
	self.pics = {}
	self.keys = {}
	for _,theSymbol in pairs(normalSymbolList) do
		self.pics[theSymbol]  = "#theme"..self.themeResourceId.."_s_"..theSymbol..".png"
		table.insert(self.keys, theSymbol)
	end
	for _,theSymbol in pairs(specialSymbolList) do
		self.pics[theSymbol]  = "#theme"..self.themeResourceId.."_s_"..theSymbol..".png"
		if theSymbol ~= "nil" then
			table.insert(self.keys, theSymbol)
		end
	end	
	for _,theSymbol in pairs(noRollSymbolList) do

		self.pics[theSymbol]  = "#theme"..self.themeResourceId.."_s_"..theSymbol..".png"
	end		
	self.normalKeyList  	= normalSymbolList
	self.specialKeyList 	= specialSymbolList
	self.specialItemConfig  = specialSymbolConfig

end
function _baseViewCtl:initSlotMachineKeys( slotMachineKeyList )
    if slotMachineKeyList and #slotMachineKeyList > 0 then
        local slotID = self:getThemeSmallSlot()
        for _,theSymbol in pairs(slotMachineKeyList) do
            self.pics[theSymbol]  = "#theme"..slotID.."_s_"..theSymbol..".png"
            table.insert(self.keys, theSymbol)
        end
    end
end


function _baseViewCtl:initThemeType( themeType, themeTypeConfig )
	if themeType == "payLine" then
		self.lines   = self.ThemeConfig["theme_type_config"]["pay_lines"]
		self.maxLine = #self.lines
	elseif themeType == "ways" then
		self.ways = themeTypeConfig["ways_cnt"]
	end
	self.themeType 		 = themeType
	self.themeTypeConfig = themeTypeConfig		
end
function _baseViewCtl:getThemeType( )
	return self.themeType or "payLine"
end
function _baseViewCtl:initBoardAndReelConfig( boardConfig )
	-- self.col 				= 0
	-- self.colRowList  		= {}
	if not self.boardConfigList then return end
	for boardIndex,theConfig in pairs(self.boardConfigList) do
		if theConfig["reel_list_config"] then
			for boardReelIndx,theReelConfig in ipairs(theConfig["reelConfig"]) do
				theReelConfig["board_Index"] 		= boardIndex
				theReelConfig["board_reel_Index"] 	= boardReelIndx
			end 
		end
	end
end

function _baseViewCtl:getBoardConfig( )
	return self.boardConfigList or {}
end

------------------------------------------------------------------------------------------------------------------------------------
-- enter_game
------------------------------------------------------------------------------------------------------------------------------------

function _baseViewCtl:onEnterThemeByFinshLoading( endCallFunc )
	if endCallFunc then
		endCallFunc()
	end
end

-- 控制ackpotNotification显示时机
function _baseViewCtl:canShowJackpotNotification()
	return true
end
------------------------------------------------------------------------------------------------------------------------------------
-- cell相关
------------------------------------------------------------------------------------------------------------------------------------

function _baseViewCtl:_createCellSprite( key, col, rowIndex)
	return self.mainView:createCellSprite(key, col, rowIndex)
end

function _baseViewCtl:_updateCellSprite( theCellNode, key, col,isGetResult,isReset ) -- 控制 显示 cell 的 sprite 上面
	return self.mainView:updateCellSprite(theCellNode, key, col,isGetResult,isReset)
end

function _baseViewCtl:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	-- todo
end

function _baseViewCtl:refreshColCellsZOrder( pCol )
	self.mainView:refreshColCellsZOrder(pCol)
end


function _baseViewCtl:addSpineAnimation(parent, zOrder, file, pos, animateName, completeCallback, callbackDelay, returnDelay, isRetain, isLoop, timeScale)
	local delay = returnDelay or 0
	callbackDelay = callbackDelay or 0
	zOrder = zOrder or 0
	if cc.FileUtils:getInstance():isFileExist(file..".json") then
		local skeleton = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
		skeleton:setPosition(pos)
		skeleton:setAnimation(0, animateName, isLoop) 
		skeleton:setTimeScale(timeScale or 1)
		parent:addChild(skeleton, zOrder)
		skeleton:registerSpineEventHandler(function (event)
				if not isRetain then
					-- 延迟释放，否则会报错
					skeleton:runAction(cc.Sequence:create(
							cc.DelayTime:create(0),
							cc.RemoveSelf:create()
						))
				end
				if completeCallback then
					if callbackDelay == 0 then
						completeCallback()
					else
						self:runAction(cc.Sequence:create(
						cc.DelayTime:create(callbackDelay),
						cc.CallFunc:create(function()
							completeCallback()
						end)))
					end
				end
	        end, sp.EventType.ANIMATION_COMPLETE)
		return delay, skeleton
	else
		if appDebugMode then
			print("Spine not exist ",file)
			print(a.b)
		else
			bole.send_codeInfo(Splunk_Type.Error, {error = "Spine_not_exist", msg = file}, false)
		end
		return 0, nil
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- spin相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 说明：spin开始控制函数
-- 作用：在通用框架下，控制开始spin的时机
function _baseViewCtl:spinControl( spinCallFun )
	spinCallFun()
end
function _baseViewCtl:dealSpinSendData( data )
	-- todo
end

function _baseViewCtl:adjustRecOtherData( rets )
	-- if self.isShowWinNotify then
	-- 	rets["play_win_notify"] = true
	-- end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- respin相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:onRespinStart( )
	-- body
end
function _baseViewCtl:onRespinStop( rets )
	-- body
end
function _baseViewCtl:theme_respin(rets)
    self.node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
        local respinList = rets["theme_respin"]
        if respinList and #respinList > 0 then
            rets["item_list"] = table.remove(respinList, 1)

            local respinStopDelay = 1
            local endCallFunc = self:getTheRespinEndDealFunc(rets)
            self:stopDrawAnimate()
            self:respin(respinStopDelay, endCallFunc)
        else
            rets["theme_respin"] = nil
        end
    end)))
end
function _baseViewCtl:getTheRespinEndDealFunc( rets )
	local retDealFunc = function(outDealFunc)
		if outDealFunc then
			outDealFunc()
		end
	end
	return retDealFunc
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 其他关键时刻
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:dealAboutBetChange(theBet, isPointBet)
	
end

function _baseViewCtl:theme_deal_data( rets )
	rets["theme_deal_data"] = nil
	self:handleResult()
end
function _baseViewCtl:theme_deal_show( rets )
	rets["theme_deal_show"] = nil
	self:handleResult()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- freespin相关：
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:getItemListForFreeSpin()
	if self.rets then
		return self.rets.item_list
	else
		return nil
	end	
end
function _baseViewCtl:getFreeRetForFreeSpin()
	if self.rets then
		return self.rets
	else
		return nil
	end	
end

function _baseViewCtl:getFreeSpecialData(  )
	return self.specials
end

function _baseViewCtl:setSpecialData( value )
	self.specials = value
end

-- function _baseViewCtl:adjustFreeSpinMoreData( theData )
-- 	-- todo
-- end

function _baseViewCtl:freeStartClicked( callFunc, isMore )
	callFunc()
	return
end
function _baseViewCtl:onCollectFreeClick(fsData )
end
function _baseViewCtl:free_spins_game( ret, theGameData, endCallfunc )
	endCallfunc()
end

function _baseViewCtl:enterFreeSpin(isResume)
	self.playNormalLoopMusic = false
	self:laterCallBack(1,function(  )
		self:dealMusic_PlayFreeSpinLoopMusic()
	end)
end

function _baseViewCtl:hideFreeSpinNode(...)	
	if self.footer and 
		self.footer.freeSpinNode and self.footer.normalFooter then

		self:setFreeSpinLabel("")
		self.footer.normalFooter:setVisible(true)
		self.footer.normalFooter:setOpacity(0)
		self.footer.normalFooter:runAction(cc.FadeIn:create(0.5))
		self.footer.freeSpinNode:runAction( 
			cc.Sequence:create(cc.FadeOut:create(0.5),
			cc.CallFunc:create(function() self.footer.freeSpinNode:setVisible(false) end)
			))
	end

	-- self:unlockLobbyBtn()
end

function _baseViewCtl:showFreeSpinNode( count, sumCount, first)
	if self.footer then
		self:setFreeSpinLabel(count, sumCount)
		self.footer:changeFreeSpinLayout()
	end

	self:lockLobbyBtn()
end

-- function _baseViewCtl:getFreeSpinPlayCnt( )
-- 	return self.free_spins_cache_cnt or 0
-- end
-- function _baseViewCtl:enterFreeSpinStage(isResume )
-- 	self:changeFreeBack(true)
-- 	self:enterFreeSpin(isResume)	
-- 	if not self.freeItem then
-- 		self.freeItem    = self:getItemListForFreeSpin()
-- 		self.freeRet  = self:getFreeRetForFreeSpin()
-- 		self.freeSpeical = self.specials
-- 	end
-- end
function _baseViewCtl:runFreeSpinStage( )
	self.footer:enterFreeSpin()
end
function _baseViewCtl:runFreeCollectSpinStage( )
	self.footer:enterCollectFreeSpin()
end
function _baseViewCtl:runOutFreeSpinState( ... )
	self.footer:exitFreeSpin() -- 对 footer 的 按钮进行控制
end
-- function _baseViewCtl:outFreeSpinStage( )
-- 	self:hideFreeSpinNode() -- 隐藏 freespin 的 相关节点显示
-- 	self:runOutFreeSpinState()
-- 	self:changeFreeBack(false) -- 更新使用的假滚轴
-- 	if self.freeItem then
-- 		self:refreshWithTheItemList(self.freeItem) -- 刷新牌面 + 动画播放
-- 	end
-- 	self:enterBaseGameStage()

-- 	self.freeItem    = nil	
-- 	self.freeRet     = nil
-- 	self.freeSpeical = nil
-- end

function _baseViewCtl:enterBaseGameStage( )
	-- 恢复牌面和footer都可以移到此处处理
	self.stageName = theme_stage_List.base_game
end

-- function _baseViewCtl:changeFreeBack( isFree )
-- 	self:resetCurrentReels(isFree)
-- end
function _baseViewCtl:free_random_pick( ret, endThemeCallfunc, tryResume )
	-- 记录当前stage
	self.stageName = theme_stage_List.pick_game

	--commonMusic: 背景音乐静音
	self.audioCtl:dealMusic_MuteLoopMusic()
	local theGameData      = ret["free_random_pick"]
	ret["free_random_pick"] = nil
	local theSpecials 	= self.specials
	local endCallfunc   = endThemeCallfunc or function()
		self:handleResult()
	end

	if self.freeCtl and self.freeCtl.enterPickGame then 
		self.freeCtl:enterPickGame(ret, theGameData, endCallfunc, tryResume) 
	else
		endCallfunc()
	end
end

-- 整理到 freeCtl 中
-- function _baseViewCtl:updateFreeSpinCount(retrigger, count)
-- 	if not retrigger then
-- 		self.freespin = 0
-- 		self.freespin = self.freespin + count -- 剩余free spin的次数
-- 		self.sumFreeSpinCnt = 0
-- 		self.sumFreeSpinCnt = self.sumFreeSpinCnt + count -- 总共 freespin 的次数
-- 		self.freewin  = self.scatter_spin_winCoins or 0
-- 		self.scatter_spin_winCoins = nil
-- 	else
-- 		self.freespin = (self.freespin or 0) + count -- 剩余free spin的次数
-- 		self.sumFreeSpinCnt = (self.sumFreeSpinCnt or 0) + count -- 总共 freespin 的次数
-- 	end
-- end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 资源加载相关：
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:loadAllMusics( )
	self:loadResMusic() --加载通用音效
	self:loadThemeMusics() --加载主题音效
end

function _baseViewCtl:getBaseMusicList()
	local loadMuscList = 
	{
		self.audio_list.reel_stop,
		self.audio_list.reel_notify,
		self.audio_list.rollup01,
		self.audio_list.rollup02,
		self.audio_list.rollup03,
		self.audio_list.rollup04,
		self.audio_list.rollup01_end,
		self.audio_list.rollup02_end,
		self.audio_list.rollup03_end,
		self.audio_list.rollup04_end,

		self.audio_list.trigger_bell,
		self.audio_list.free_dialog_start_show,
		self.audio_list.free_dialog_start_click,
		self.audio_list.free_dialog_start_close,
		self.audio_list.free_dialog_more_show,
		self.audio_list.free_dialog_more_close,
		self.audio_list.free_dialog_collect_click,
		self.audio_list.free_dialog_collect_close,
		self.audio_list.free_dialog_collect_show,
		self.audio_list.transition_free, 
		self.audio_list.transition_bonus, 
		self.audio_list.transition_free_pick, 
		
		self.audio_list.bonus_start_show,	
		self.audio_list.bonus_end_show,		
		self.audio_list.pick_start_show,		
		self.audio_list.pick_end_show,		
		self.audio_list.wheel_start_show,	
		self.audio_list.wheel_end_show,		
		self.audio_list.win_jp_show,			
		self.audio_list.win_jp_click,
		self.audio_list.win_rapidpay_show,			
		self.audio_list.win_rapidpay_click,		
		self.audio_list.common_click, 		
	}
	return loadMuscList
end

function _baseViewCtl:getLoadMusicList()
	return self:getBaseMusicList()
end

function _baseViewCtl:loadThemeMusics( )
	local allMusicList = {}
	local tempMusicList = {}
	local basemusicList = self:getBaseMusicList() -- 加载主题定义音效
	local musicList = self:getLoadMusicList() -- 加载主题定义音效
	for _,baseAudioName in pairs(basemusicList) do
		if not tempMusicList[baseAudioName] then
			table.insert(allMusicList, baseAudioName)
			tempMusicList[baseAudioName] = 1
		end
	end
	for _,audioName in pairs(musicList) do
		if not tempMusicList[audioName] then
			table.insert(allMusicList, audioName)
			tempMusicList[audioName] = 1
		end
	end
	self:realLoadThemeMusics(allMusicList)
end

function _baseViewCtl:realLoadThemeMusics(musicList)
	if musicList and #musicList>0 then	
		self.loadedMusicList = self.loadedMusicList or {}
		local fileUtiles 	   = cc.FileUtils:getInstance()
		local needLoadMusicList = {}	
		for _,audioName in pairs(musicList) do
			if fileUtiles:isFileExist(self:getPic(audioName)) then
				if not self.loadedMusicList[audioName] then
					table.insert(needLoadMusicList, self:getPic(audioName))
					self.loadedMusicList[audioName] = 1
				end
			end
		end

		--- whj 添加预加载主题通用音效
		local commonMusicList = self:getCommonLoadMusicList()
		if commonMusicList and #commonMusicList >0 then 
			for _,audioFile in pairs(commonMusicList) do
				if fileUtiles:isFileExist(audioFile) then
					if not self.loadedMusicList[audioFile] then
						table.insert(needLoadMusicList, audioFile)
						self.loadedMusicList[audioFile] = 1
					end
				end
			end
		end

		local loadFunc = function()
			-- if self.addLoadResCnt then
			-- 	self.addLoadResCnt("music")
			-- end
			
		end
		local tempMusics = AudioControl:preloadAudio(nil, needLoadMusicList, {}, loadFunc)
		self.loadMusicList = self.loadMusicList or {}
		for _,mmusic in pairs(tempMusics) do
			table.insert(self.loadMusicList, mmusic)
		end
		-- self.objLoadCnt = self.objLoadCnt + #self.loadMusicList - 2
	end
end

-- whj 添加获得需要加载通用音效的方法
function _baseViewCtl:getCommonLoadMusicList()
	local commonMusicList = {}

	if self.audio_win_list then 
		for _,v in pairs(self.audio_win_list) do 
			table.insert(commonMusicList, v)
		end
	end
	if self.slot_audio_list then
		for _,v in pairs(self.slot_audio_list) do
			table.insert(commonMusicList, self:getSlotPath(v))
		end
	end
	return commonMusicList
end

function _baseViewCtl:unloadThemeMusics()
	AudioControl:stopGroupAudio("music")
	self.loadMusicList = self.loadMusicList or {}
	if self.loadMusicList and #self.loadMusicList>0 then		
		for k,v in pairs(self.loadMusicList) do
			 AudioControl:unloadEffect(v)
		end
	end
	self.loadMusicList = {}
	self.loadedMusicList = {}
end

function _baseViewCtl:loadResMusic( )

end

function _baseViewCtl:checkResAndDeal( endCallFunc )
	if endCallFunc then
		endCallFunc()
	end
end

function _baseViewCtl:checkStoreRes(download_controller)
	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		if download_controller:needDownload(2, "theme_store_game2") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_I_V then
		if download_controller:needDownload(2, "theme_store_game") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
	if self.game_store_version ==  GameStoreType.PUZZLE_II_H then
		if download_controller:needDownload(2, "theme_store_game2horizon") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
    if self.game_store_version == GameStoreType.SLOT_MACHINE_V then
        if download_controller:needDownload(3, "2008") then
            self.downloadingRatio = self.downloadingRatio + 2
        end
    end
    if self.game_store_version == GameStoreType.SLOT_MACHINE_H then
        if download_controller:needDownload(3, "2009") then
            self.downloadingRatio = self.downloadingRatio + 2
        end
    end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_I_V then 
		if download_controller:needDownload(3, "2011") then
            self.downloadingRatio = self.downloadingRatio + 2
        end
	end
	if self.game_store_version == GameStoreType.TOURN_CASH then
		if download_controller:needDownload(2, "theme_tourn_cash") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
end

function _baseViewCtl:downloadPuzzleStoreRes(download_controller, onSuccess_store, onProgress_store, onError_store, force)
	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		if download_controller:needDownload(2, "theme_store_game2")then
			download_controller:download(2, "theme_store_game2", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_I_V then
		if download_controller:needDownload(2, "theme_store_game")then
			download_controller:download(2, "theme_store_game", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_II_H then
		if download_controller:needDownload(2, "theme_store_game2horizon")then
			download_controller:download(2, "theme_store_game2horizon", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
    if self.game_store_version == GameStoreType.SLOT_MACHINE_V then
        if download_controller:needDownload(3, "2008")then
            download_controller:download(3, "2008", onSuccess_store, onProgress_store, onError_store, force)
        end
    end
    if self.game_store_version == GameStoreType.SLOT_MACHINE_H then
        if download_controller:needDownload(3, "2009")then
            download_controller:download(3, "2009", onSuccess_store, onProgress_store, onError_store, force)
        end
    end

	if self.game_store_version == GameStoreType.SLOT_MACHINE_I_V then
        if download_controller:needDownload(3, "2011")then
            download_controller:download(3, "2011", onSuccess_store, onProgress_store, onError_store, force)
        end
    end

	if self.game_store_version == GameStoreType.TOURN_CASH then
		if download_controller:needDownload(2, "theme_tourn_cash")then
			download_controller:download(2, "theme_tourn_cash", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
end

function _baseViewCtl:downloadPuzzleThemeLoading(download_controller)
	if self.game_store_version == GameStoreType.PUZZLE_I_V then
		if download_controller:needDownload(1, "2002") then
			download_controller:download(1, "2002")
		end
	end

	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		if download_controller:needDownload(1, "2005") then
			download_controller:download(1, "2005")
		end
	end

	if self.game_store_version == GameStoreType.PUZZLE_II_H then
		if download_controller:needDownload(1, "2007") then
			download_controller:download(1, "2007")
		end
	end
end

-- whj 添加 下载主题资源
function _baseViewCtl:downloadThemeRes( endCallFunc,force )

	--目前是单机不需要下载，自动加载
	if self.ctl and self.ctl.loadingView and self.ctl.loadingView.autoLoading then 
		self.ctl.loadingView:autoLoading(endCallFunc)
		return 
	end

	if self.downloadingThemePercents then
		return
	end
	self.downloadingThemePercents = 0
	self.downloadingRatio        = 0

	local download_controller = DownloadController:getInstance()
	local need_store          = (ThemeStoreRes and ThemeStoreRes[self.themeResourceId] ~= nil)

	if not need_store and self.game_store_version > 1 then
		need_store= true
	end
	if download_controller:needDownload(3, tostring(self.themeResourceId)) then
		self.downloadingRatio = self.downloadingRatio + 2
	end
	if need_store then
		self:checkStoreRes(download_controller)
		self:downloadPuzzleThemeLoading(download_controller)
	end
	if self.downloadingRatio > 0 then
		local dir = string.format("theme_resource/theme%d/", self.themeResourceId)
		local isSucceed       = false
		local theme_percent   = 0
		local store_percent   = 0
		local downloadingThemePercent = 0
		local downloadingStorePercent = 0
		local callback_called = false

		local function remove()
			if not self.loadingView or not self.downloadingThemePercents then return end
			self.downloadingThemePercents = 0
		end

		local function onSuccess_theme ()
			if not self.downloadingRatio then 
				return 
			end
			theme_percent = 100
			self.downloadingThemePercents = (theme_percent + store_percent) / self.downloadingRatio

			-- if self.downloadingThemePercents == 80 then
			if self.downloadingThemePercents == 50 then
				isSucceed = true
			end

		    if not self.loadingView or not self.downloadingThemePercents then return end

		    -- if self.downloadingThemePercents == 80 then
		    if self.downloadingThemePercents == 50 then
				endCallFunc()
				callback_called = true
			end
			
		end

		local function onSuccess_store ()
			if not self.downloadingRatio then return end
			store_percent = 100
			self.downloadingThemePercents = (theme_percent + store_percent) / self.downloadingRatio

			-- if self.downloadingThemePercents == 80 then
			if self.downloadingThemePercents == 50 then
				isSucceed = true
			end

		    if not self.loadingView or not self.downloadingThemePercents then return end

		    -- if self.downloadingThemePercents == 80 then
		    if self.downloadingThemePercents == 50 then
				endCallFunc()
				callback_called = true
			end
			
		end

		local function onError_theme (errorCode)
			isSucceed = false
			Splunk:getInstance():send_codeInfo(Splunk_Type.Error,{error = "onError_theme", msg = "onError_theme", tid = self.themeResourceId})

		    if not self.loadingView or not self.downloadingThemePercents then return end

			remove()

		end

		local function onError_store(errorCode)
			isSucceed = false
			Splunk:getInstance():send_codeInfo(Splunk_Type.Error,{error = "onError_store", msg = "onError_store", tid = self.themeResourceId})
			-- if errorCode == 3 then
			-- 	local zipfile = cc.UserDefault:getInstance():getStringForKey(bole.resourceServer.."theme_store_game.zip", "")
			-- 	cc.FileUtils:getInstance():removeFile(zipfile)
			-- end

		    if not self.loadingView or not self.downloadingThemePercents then return end

			remove()

		end

		local _load_start_theme = 0
		local _load_start_store = 0
		local function onProgress_theme (percent,curByte,totalByte)
			if self.loadingView and self.downloadingRatio and self.downloadingThemePercents and percent > downloadingThemePercent then
				downloadingThemePercent = percent
				self.downloadingThemePercents = (downloadingThemePercent + downloadingStorePercent) / self.downloadingRatio
				
				if _load_start_theme == 0 then 
					_load_start_theme = 1
					if self.loadingView.addTotalByte then 
						self.loadingView:addTotalByte(totalByte)
					end
				end

				if self.loadingView.setPercent then
					self.loadingView:setPercent(self.downloadingThemePercents)
				end
		    end
		end

		local function onProgress_store (percent,curByte,totalByte)
			if self.loadingView and self.downloadingRatio and self.downloadingThemePercents and percent > downloadingStorePercent then
				downloadingStorePercent = percent
				self.downloadingThemePercents = (downloadingThemePercent + downloadingStorePercent) / self.downloadingRatio

				if _load_start_store == 0 then 
					_load_start_store = 1
					if self.loadingView.addTotalByte then 
						self.loadingView:addTotalByte(totalByte)
					end
				end

				if self.loadingView.setPercent then
					self.loadingView:setPercent(self.downloadingThemePercents)
				end
		    end
		end

		if self.loadingView and self.loadingView.setPercent then
			self.downloadingThemePercents = 0
			if self.loadingView.setPercent then
				self.loadingView:setPercent(0)
			end
		end

		if download_controller:needDownload(3, tostring(self.themeResourceId)) then
			download_controller:download(3, tostring(self.themeResourceId), onSuccess_theme, onProgress_theme, onError_theme, force)
		end

		if need_store then
			self:downloadPuzzleStoreRes(download_controller, onSuccess_store, onProgress_store, onError_store, force)
		end
	else
		if not self.loadingView or not self.downloadingThemePercents then return end
		endCallFunc()
	end

	
end

function _baseViewCtl:preLoadResAsync( endCallFunc )
	self.themeLoadResStart = os.time()

	self.csbList = self.csbList or {}

	self.loadResEndCallFunc = endCallFunc
	self.curLoadCnt = 0
	self.objLoadCnt = 0
	self.loadedCnt = {}
	local function addLoadResCnt( key )
		if not self.loadingView then return end
		if not self.loadedCnt[key] then
			self.loadedCnt[key] = 0
		end
		self.loadedCnt[key] = self.loadedCnt[key] + 1
		self.curLoadCnt = self.curLoadCnt + 1
		local percent = self.curLoadCnt / self.objLoadCnt * 100
		-- print("zhf preLoadResAsync ",self.curLoadCnt,self.objLoadCnt,percent)

		if bole.isValidNode(self.loadingView) and self.loadingView.setPercent then 
			if not self.downloadingThemePercents or self.downloadingThemePercents==0 then
				self.loadingView:setPercent(percent)
			else
				self.loadingView:setPercent(50+percent/2)
			end
		end

		if self.curLoadCnt>self.objLoadCnt then
			if self.loadResEndCallFunc then
				self.loadResEndCallFunc()
				self.loadResEndCallFunc = nil
				self:onLoading_100()
				self:preLoadOtherResources()
			end
		end
	end
	self.addLoadResCnt = addLoadResCnt
	self:onLoading_0()
	
	local textureCache = cc.Director:getInstance():getTextureCache()
    if self.plistAnimate then
        self:preLoadCacheImgs(addLoadResCnt, self.plistAnimate,"plist", 1)
    end
    if self.preSlotPngs then
        self:preLoadCacheImgs(addLoadResCnt, self.preSlotPngs,"slot_machine", 2)
    end
	if self.activityPngs then
		self:preLoadCacheImgs(addLoadResCnt, self.activityPngs,"activity_pngs", 3)
	end
end

function _baseViewCtl:tryLoadPlistImages()
	if self.plistAnimate then
		self:preLoadCacheImgs(nil, self.plistAnimate,"plist", 1)
	end
	if self.preSlotPngs then
		self:preLoadCacheImgs(nil, self.preSlotPngs,"slot_machine", 2)
	end
	if self.activityPngs then
		self:preLoadCacheImgs(nil, self.activityPngs,"activity_pngs", 3)
	end
end

function _baseViewCtl:preLoadCacheImgs(callFun, imageList, key, load_type)
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    local textureCache = cc.Director:getInstance():getTextureCache()

    for index, objName in ipairs(imageList) do

        local thePicFile
        local thePlistFile
		if load_type == 1 then
			thePicFile = self:getPic(objName .. ".png")
			thePlistFile = self:getPic(objName .. ".plist")
			if self:isExistFile(objName .. ".png") then
				thePicFile = self:getPic(objName .. ".png")
			elseif self:isExistFile(objName .. ".pvr.ccz") then
				thePicFile = self:getPic(objName .. ".pvr.ccz")
			else
				thePicFile = nil
			end
		elseif load_type == 2 then
			thePicFile = self:getSlotPath(objName .. ".png")
			thePlistFile = self:getSlotPath(objName .. ".plist")
		elseif load_type == 3 then
			thePicFile = objName.. ".png"
			thePlistFile = objName.. ".plist"
		else
			thePicFile = nil
		end
        if thePicFile then
            self.objLoadCnt = self.objLoadCnt + 1
            textureCache:addImageAsync(thePicFile, function(...)
                spriteFrameCache:addSpriteFrames(thePlistFile)
                if callFun then
	                callFun(key)
	            end
            end)
        end
    end
end
function _baseViewCtl:removePreLoadCacheImgs(imageList,load_type)
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	local textureCache = cc.Director:getInstance():getTextureCache()
	local thePicFile
	local thePlistFile
	for index, objName in ipairs(imageList) do
		if load_type == 1 then
			thePicFile = self:getPic(objName .. ".png")
			thePlistFile = self:getPic(objName .. ".plist")
		elseif load_type == 2 then
			thePicFile = self:getSlotPath(objName .. ".png")
			thePlistFile = self:getSlotPath(objName .. ".plist")
		elseif load_type == 3 then
			thePicFile = objName .. ".png"
			thePlistFile = objName .. ".plist"
		end
			if thePicFile then
				if spriteFrameCache:isSpriteFramesWithFileLoaded(thePlistFile) then
					spriteFrameCache:removeSpriteFramesFromFile(thePlistFile)
					textureCache:removeTextureForKey(thePicFile)
				end
			end
		end
end

function _baseViewCtl:preLoadOtherResources( ... )
	self:loadAllMusics()
	local textureCache = cc.Director:getInstance():getTextureCache()
	self.specialPicFileList = self.specialPicFileList or ThemePngs[self.themeResourceId]
	
	if self.specialPicFileList and #self.specialPicFileList>0 then
		for _,thePicConfig in ipairs(self.specialPicFileList) do
			local thePicFile = nil
			if thePicConfig[1] == 1 then
				thePicFile = self:getPic(thePicConfig[2])
			else
				thePicFile = thePicConfig[2]
			end
			if thePicFile then
				if not string.find(thePicFile, "paytable/") and cc.FileUtils:getInstance():isFileExist(thePicFile) then	
					-- self.objLoadCnt = self.objLoadCnt + 1
					textureCache:addImageAsync(thePicFile, function(...)
						-- addLoadResCnt("special_plist")
					end)
				end	
			end
		end			
	end

	self.commonFileList = CommnonThemeRes
    self:preLoadImgs(nil,self.commonFileList,"common_file_list")
	self.storePicFileList = ThemeStoreRes[self.themeResourceId]
    self:preLoadImgs(nil,self.storePicFileList,"store_file_list")
end

function _baseViewCtl:preLoadImgs(callFun,imageList,key)
    local textureCache = cc.Director:getInstance():getTextureCache()
    if imageList and #imageList>0 then
        for _, thePicConfig in ipairs(imageList) do
            local thePicFile = nil
            if thePicConfig[1] == 1 then
                -- 主题内
                thePicFile = self:getPic(thePicConfig[2])
            elseif thePicConfig[1] == 2 then
                -- 包内
                thePicFile = thePicConfig[2]
            elseif thePicConfig[1] == 3 then
                -- winEffect  通用的路径
                thePicFile = self:getWinEffectPath() .. thePicConfig[2]
            elseif thePicConfig[1] == 4 then
                --other theme
                thePicFile = self:getSlotPath(thePicConfig[2])
            end
            if thePicFile then
                -- self.objLoadCnt = self.objLoadCnt + 1
                textureCache:addImageAsync(thePicFile, function(...)
                	if callFun then
                		callFun(key)
                	end
                end)
            end
        end
    end
end
function _baseViewCtl:removeLoadImgs(imageList)
	local textureCache = cc.Director:getInstance():getTextureCache()
	if imageList and #imageList>0 then
		for _, thePicConfig in ipairs(imageList) do
			local thePicFile = nil
			if thePicConfig[1] == 1 then
				-- 主题内
				thePicFile = self:getPic(thePicConfig[2])
			elseif thePicConfig[1] == 2 then
				-- 包内
				thePicFile = thePicConfig[2]
			elseif thePicConfig[1] == 3 then
				-- winEffect  通用的路径
				thePicFile = self:getWinEffectPath() .. thePicConfig[2]
			elseif thePicConfig[1] == 4 then
				--other theme
				thePicFile = self:getSlotPath(thePicConfig[2])
			end
			textureCache:removeTextureForKey(thePicFile)
		end
	end
end

function _baseViewCtl:unloadRes( )
	local textureCache = cc.Director:getInstance():getTextureCache()
    if self.plistAnimate then
		self:removePreLoadCacheImgs(self.plistAnimate,1)
	end
	if self.preSlotPngs then
		self:removePreLoadCacheImgs(self.preSlotPngs,2)
	end
	if self.activityPngs then
		self:removePreLoadCacheImgs(self.activityPngs,3)
	end
	if self.frameAnimate then
		for index,objData in ipairs(self.frameAnimate) do
			for i=1,objData[2] do
				local fileName = string.format(self:getPic(objData[1]), i)
				textureCache:removeTextureForKey(fileName)
			end
		end
	end
	if self.specialPicFileList then
		self:removeLoadImgs(self.specialPicFileList)

	end
	if self.commonFileList then
		self:removeLoadImgs(self.commonFileList)
	end

	if self.storePicFileList then
		self:removeLoadImgs(self.storePicFileList)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- spin reel action
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function _baseViewCtl:startCalculateRequestTime( isStartSpin )
	if self.mainView:hasSpinLayer() then 
		self.mainView:getCurSpinLayer():startCalculateRequestTime(isStartSpin)
	end
end

function _baseViewCtl:adjustThemeReels( ret )
	-- todo
end



function _baseViewCtl:fastStopBoard( )
	self:onFastStopBoard(self.spinCacheTag)
	self.mainView:getCurSpinLayer():fastStop()
end

function _baseViewCtl:onFastStopBoard( )
	self:dealMusic_StopReelNotifyMusic()
end

function _baseViewCtl:getFastStopConfig( spinTag )
	local fastStopConfig = {}
	local cacheDelay 	 = 0
	for col,_ in pairs(self.mainView:getCurSpinLayer().spins) do
		local theAction,addDelay = self:getSpinColFastSpinAction(col)
		local theReelConfig = {
			["col"]     = col,
			["action"]  = theAction,
			["delay"] 	= cacheDelay,
		}
		table.insert(fastStopConfig, theReelConfig)
		cacheDelay = cacheDelay + (addDelay or 0)		
	end
	return fastStopConfig
end

function _baseViewCtl:checkNeedNotify( pCol )
	return self:checkSpeedUp(pCol)
end


function _baseViewCtl:getSpinColFastSpinAction( pCol, speedScale )
	local spinAction = nil -- G_SELF_FUNC:getSpinColFastStopAction(spinActionConfig)
	local nextDelay  = nil -- spinActionConfig["next_delay"]
	
	return spinAction,nextDelay
end

-- whj 添加 通用计算主题 延迟时间
function _baseViewCtl:getCurSpinLayerSpinActionTime(stopDelayList, downBounceT, checkStopColCnt, autoSDMult, autoDBTMult )
    local _stopDelay = stopDelayList[1]
    local _downBounceTime = downBounceT
    local _spinLayer = self.mainView:getCurSpinLayer()
    if _spinLayer.spins and #_spinLayer.spins>0 then
        local tColCnt = #_spinLayer.spins
        local checkBoardCnt = math.floor(tColCnt/(checkStopColCnt or 5))
        if checkBoardCnt == 1 then 
            _stopDelay = stopDelayList[1]
        elseif checkBoardCnt == 2 then 
            _stopDelay = stopDelayList[2]
        elseif checkBoardCnt >= 3 then 
            _stopDelay = stopDelayList[3]
        end
    end

    if self.isTurbo then 
        _stopDelay = _stopDelay * ( autoSDMult or 1 )
        _downBounceTime = _stopDelay * ( autoDBTMult or 1 )
    end

    return _stopDelay, _downBounceTime
end
-- end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- spin layer相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:onReelStart( pCol )
	-- todo	
end
function _baseViewCtl:onReelStop( pCol )

	self:stopReelNotifyEffect(pCol)
end

function _baseViewCtl:getUpdateKeyWithIndex( col, index, key )
	local retKey = nil

	return retKey
end

function _baseViewCtl:onReelNotifyStopBeg( pCol )
	self:playReelNotifyEffect(pCol)	
	self:dealMusic_PlayReelNotifyMusic(pCol)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 其他
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function _baseViewCtl:isInFG()
	return self.freeCtl:isInFG()
end
---------------------------------------------------------
function _baseViewCtl:cleanStatus( stillEffect )
	self:cleanSpecialSymbolState()
	self:cleanSpecialTagState()
	self:stopDrawAnimate()
end

function _baseViewCtl:cleanSpecialTagState( )
	-- todo
end

-- 说明：收到spin数据时，是否允许此次spin快速停止
-- 参数：rets, 此次spin的相关结果数据
function _baseViewCtl:checkCanSetStopBtn( rets )
	return true
end
---------------------------------------------------------
function _baseViewCtl:getNormalKey( col )
	if self:isInFG() and #self.RollSymbolInFreeList>0 then
		local theKey 	= self.RollSymbolInFreeList[math.random(1, #self.RollSymbolInFreeList)]
		return theKey		
	else
		local theKey 	= self.normalKeyList[math.random(1, #self.normalKeyList)]
		return theKey
	end
end

function _baseViewCtl:getCellItem( col, row )
	return self.mainView:getCellItem( col, row)
end

function _baseViewCtl:getCellPos( col, row ) -- 从上向下 一次 是 123  横向 从做到右 是 123
	local retPos = self.mainView:getCurSpinLayer():getCellPos( col, row )
	return retPos
end
function _baseViewCtl:getCellScenePos( col, row )
	local basePos = cc.p(self.mainView:getCurSpinLayer():getPosition())
	local cellPos = self.mainView:getCurSpinLayer():getCellPos(col,row)
	local retPos  = cc.pAdd(basePos, cellPos)
	return retPos
end

function _baseViewCtl:getPic( name )
	return string.format("theme_resource/theme%d/%s", self.themeResourceId, name)
end


function _baseViewCtl:showAllItem(showState) -- 没啥作用
end

------------------------------------------------------------------
-- 滚轴相关
------------------------------------------------------------------
function _baseViewCtl:getFrames(col)
	local n = math.random(10, 20)
	local ret = {}
	for i = 1, n do
		local t = math.random(1,#self.keys)
		ret[i] = self.keys[t]
	end
	return ret
end

function _baseViewCtl:cleanSpecialSymbolState()
	self.checkItemsState = nil
	self.speedUpState 	 = nil
	self.notifyState	 = nil	
end

function _baseViewCtl:isExistFile(path)
	return cc.FileUtils:getInstance():isFileExist(self:getPic(path))
end

function _baseViewCtl:isExistCommonFile(path)
	return cc.FileUtils:getInstance():isFileExist(path)
end

function _baseViewCtl:laterCallBack(time, func)
	self.node:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(func)))
end

function _baseViewCtl:fixEnterBoard()
	return nil
end

----------------jackpot相关-----------------------
function _baseViewCtl:updateJackpotByBet(bet) -- todo  改成event
	if self.jpViewCtl then 
		self.jpViewCtl:updateJackpotByBet(bet)
	end
end

function _baseViewCtl:getJackpotValue(incrementList,mul)
	if self.jpViewCtl then 
		self.jpViewCtl:getJackpotValue(incrementList,mul)
	end
	
end

function _baseViewCtl:getResetValue(jp_level,mul)
	if self.jpViewCtl then 
		self.jpViewCtl:getResetValue(jp_level,mul)
	end

end

function _baseViewCtl:lockJackpotMeters(lock,index)
	if self.jpViewCtl then 
		self.jpViewCtl:lockJackpotMeters(lock,index)
	end

end

function _baseViewCtl:formatJackpotMeter(n)
	if self.jpViewCtl then 
		self.jpViewCtl:formatJackpotMeter(n)
	end

end

function _baseViewCtl:getThemeJackpotConfig()
	local jackpot_config_list
	
	if self.gameConfig.jp_config and self.gameConfig.jp_config.jp_config_list then 
		jackpot_config_list = self.gameConfig.jp_config.jp_config_list
	end

	return jackpot_config_list
end

function _baseViewCtl:getBtnFlashInfo()
	return {
		flashFile  		= COMMON_PICS_PATH.."flash.png",
		-- btnStartFile    = self:getPic("xxxxxxxx.png"),
		-- btnCollectFile  = self:getPic("xxxxxxxx.png"),
	}
end

function _baseViewCtl:lockLobbyBtn()
	-- if self.header then
	-- 	self.header:LobbyBtnState(false)
	-- end
end

function _baseViewCtl:unlockLobbyBtn()
	if self.header then
		self.header:LobbyBtnState(true)
	end
end

function _baseViewCtl:unloadPngs(tPngs)
	local textureCache = cc.Director:getInstance():getTextureCache()
	for k,v in pairs(tPngs) do
		local path = ""
		if v[1] == 1 then
			path = self:getPic(v[2])
		else
			path = v[2]
		end
		if path ~= "" then
			textureCache:removeTextureForKey(path)
		end
	end
end

function _baseViewCtl:preloadPngs(tPngs)
	local textureCache = cc.Director:getInstance():getTextureCache()
	for k,v in pairs(tPngs) do
		local path = ""
		if v[1] == 1 then
			path = self:getPic(v[2])
		else
			path = v[2]
		end
		if path ~= "" then
			cc.Director:getInstance():getTextureCache():addImageAsync(path, function ()
			end)
		end
	end
end

-----------------------------------------------------------------------------------
-- 长屏显示logo 相关
-----------------------------------------------------------------------------------
function _baseViewCtl:adaptationLongScreen( pro )
	pro = pro or 1.14  -- 1460/1280
	if HEADER_FOOTER_RATE_H >= pro then
		return true
	end
	return false
end

-----------------------------------------------------------------------------------
-- 修改bet 相关
-----------------------------------------------------------------------------------
function _baseViewCtl:changeBet(theBet)
	
end	

function _baseViewCtl:getRollUpBet(ret) -- 进行 bet 设置
	return nil
end

function _baseViewCtl:_onExit( )
	self:unloadRes()
	self:removeListenBaseEvent()
	EventCenter:pushEvent(EVENTNAMES.THEME.EXIT_THEME)
end

function _baseViewCtl:updatedFreeSpinCount( remainingCount,totalCount)
	self:setFreeSpinLabel(remainingCount, totalCount)
	self.footer:changeFreeSpinLayout()
end
function _baseViewCtl:setFreeSpinLabel(remainingCount, totalCount)
	self.footer:setFreeSpinLabel(remainingCount, totalCount)
end

-----------------------------------------------------------------------------------
-- 多主题商店 相关
-----------------------------------------------------------------------------------
function _baseViewCtl:initThemeStoreNodeLayout()
	if not self.isThemeStoreOpen then return end
	local digitals = self.storeLabelDigitals or 7
	local store = self.store_node:getChildByName("store")
	self.storeLayoutList = {}
	local store_logo_node = store:getChildByName("logo_node")
	self.storeLayoutList.logoAniNode = store_logo_node:getChildByName("ani_node")
    local label_node = store:getChildByName("label_node")
	self.storeLayoutList.label = label_node:getChildByName("label_coin")
	inherit(self.storeLayoutList.label, LabelNumRoll)
	local function fontFormat(num)
	    return FONTS.formatByCount2(num, digitals, true)
	end
	self.storeLayoutList.label:nrInit(0, 25, fontFormat)
	self.storeCredits = self.store_data.map_credits or 0
	self.storeLayoutList.label:setString(FONTS.formatByCount2(self.storeCredits,digitals,true))
	self:showOrHideStoreNode(true)
end

function _baseViewCtl:showStoreNodeLogoLoopAnimation()
	if not self.storeLayoutList.logoAniNode then return end
	local file = self:getPic("store/spine/store_logo/spine")
	self:addSpineAnimation(self.storeLayoutList.logoAniNode,nil,file,cc.p(0,0),"animation1",nil,nil,nil,true,true,nil)
end

function _baseViewCtl:enableStoreBtn(enable,isFirst)
	if not self.btn_storeOpen or not self.btn_storeInfo or not self.isThemeStoreOpen then return end
	local isShow = enable and not self.autoSpin
	self.btn_storeOpen:setVisible(isShow)
	self.btn_storeOpen:setTouchEnabled(isShow)
	self.btn_storeInfo:setVisible(isShow)
	self.btn_storeInfo:setTouchEnabled(isShow)
	
	if enable and isFirst then
		self:initStoreOpenBtnEvent(self.btn_storeOpen)
		self:initStoreInfoBtnEvent(self.btn_storeInfo)
	end
end

function _baseViewCtl:initStoreOpenBtnEvent(btn)
	-- 点击按钮
	local pressFunc = function(obj)
	    -- btn:setTouchEnabled(false)
        self:openStore(btn)
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	btn:addTouchEventListener(onTouch)
end

function _baseViewCtl:openStore(btn)
	if not self.store_data then return end
	local digitals = self.storeLabelDigitals or 7
	local data = self.store_data
	--local data = {}
	data.themeCtl = self
	data.theme = self
	data.delay = 0
	local endCallFunc = function()
		self:enableStoreBtn(true)
		self.storeCredits = self.store_data.map_credits or 0
		self.storeLayoutList.label:setString(FONTS.formatByCount2(self.storeCredits,digitals,true))
	end

	-- PopupController:getInstance():popupDialogDirectly("theme_store_game", data,endCallFunc)
	self:showStoreDialog(data, endCallFunc)
end

function _baseViewCtl:showStoreDialog(data, callback)
	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		PopupController:getInstance():popupDialogDirectly("theme_store_game2", data, callback)
	elseif self.game_store_version ==  GameStoreType.PUZZLE_I_V then
		PopupController:getInstance():popupDialogDirectly("theme_store_game", data, callback)
	elseif self.game_store_version == GameStoreType.PUZZLE_II_H then
		PopupController:getInstance():popupDialogDirectly("theme_store_game2horizon", data, callback)
	end
end

function _baseViewCtl:initStoreInfoBtnEvent(btn)
	-- 点击按钮
	local pressFunc = function(obj)
	    -- btn:setTouchEnabled(false)
        self:showThemeStoreTipDialog(1)
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end
	-- 设置按钮
	btn:addTouchEventListener(onTouch)
end

function _baseViewCtl:showOrHideStoreNode(isShow)
	if not self.isThemeStoreOpen then return end
	if isShow then
	    self.store_node:setVisible(isShow)
	    self.storeLayoutList.logoAniNode:removeAllChildren()
		self:showStoreNodeLogoLoopAnimation()
	else
		self.store_node:setVisible(false)
		self.storeLayoutList.logoAniNode:removeAllChildren()
	end
end

function _baseViewCtl:updateDataOutOfStore(data)
	self.store_data = self.store_data  or {}
	self.store_data.card_status = data.card_status
	self.store_data.map_credits = data.map_credits
	self.store_data.puzzle_page = data.puzzle_page
	self.store_data.duplicate_list = data.duplicate_list
	self.store_data.progress_list = data.progress_list
	self.store_data.disconnection = data.disconnection
	self.store_data.first_time_guide = data.first_time_guide
end

function _baseViewCtl:getThemeStoreData(data,store_type)
	local store_data = {}
	store_data.avg_bet          = data[store_type].avg_bet
	store_data.card_status      = data[store_type].card_status
	store_data.map_credits      = data[store_type].map_credits
	store_data.puzzle_page      = data[store_type].puzzle_page
	store_data.duplicate_list   = data[store_type].duplicate_list
	store_data.progress_list    = data[store_type].progress_list
    store_data.disconnection    = data[store_type].disconnection
    store_data.fg_disconnection = data[store_type].fg_disconnection
    store_data.first_time_guide = data[store_type].first_time_guide

	return store_data
end


function _baseViewCtl:playStoreCoinsFlyAnimation(data,end_pos,coin_pos,move_time,scale)
	if not data then return end

	local function clearPreviousAnimation()
		if self.storeFlyNodeList then
			for k,v in pairs(self.storeFlyNodeList) do
				v:stopAllActions()
				v:removeAllChildren()
			end
		end
		self.storeCoinsFlyNode:removeAllChildren()
		self.storeFlyNodeList = nil		
	end
	clearPreviousAnimation()
	self.storeFlyNodeList = {}
	
	local file = self:getPic("store/spine/store_coins/spine")
	coin_pos = coin_pos or self.coin_pos or cc.p(40,-35)
	end_pos = end_pos or cc.pAdd(cc.p(self.store_node:getPosition()),cc.p(390,640))
	end_pos = cc.pSub(end_pos,coin_pos)
	move_time = move_time or 0.5
    for i = 1,bole.getTableCount(data) do
    	for j = 1,bole.getTableCount(data[i]) do
    		if data[i][j] > 0 then
    			local key = data[i][j]/5
    			local aniName1 = "animation"..key
    			local aniName2 = "animation"..key.."_1"

    			self.storeFlyNodeList[i.."_"..j] = cc.Node:create()
    			self.storeCoinsFlyNode:addChild(self.storeFlyNodeList[i.."_"..j])
    			local cell = self.mainView:getCurSpinLayer().spins[i]:getRetCell(j)
    			local pos = self:getCellPos(i,j)
    			--print("wy_playStoreCoinsFlyAnimation",pos,pos.x,pos.y)
    			self.storeFlyNodeList[i.."_"..j]:setPosition(pos)
    			self.storeFlyNodeList[i.."_"..j]:runAction(cc.Sequence:create(
    				cc.CallFunc:create(function()
    					local _, s = self:addSpineAnimation(self.storeFlyNodeList[i.."_"..j],nil,file,coin_pos,aniName1,nil,nil,nil,false,false,nil)
    					s:setScale(scale or 1)
    					self:stopMusicByName("theme_store_coin_fly")
    					self:playMusicByName("theme_store_coin_fly",true)
    					if cell.coinSprite then
    						cell.coinSprite:removeAllChildren()
    						cell.coinSprite:setVisible(false)
    					end
    				end),
    				cc.DelayTime:create(0.3),
    				cc.CallFunc:create(function()
    					local _, s = self:addSpineAnimation(self.storeFlyNodeList[i.."_"..j],nil,file,coin_pos,aniName2,nil,nil,nil,false,false,nil)
						s:setScale(scale or 1)
    				end),
    				cc.MoveTo:create(move_time,end_pos),		
    				cc.CallFunc:create(function()					
    					self.storeFlyNodeList[i.."_"..j]:removeAllChildren()    					
    				end)
    			))
    		end
    	end
    end
    self:laterCallBack(0.8,function()
		self:showStoreNodeReceiveCoinsAnimation()
	end)
end

function _baseViewCtl:showStoreNodeReceiveCoinsAnimation()
	if self.storeLayoutList.label then
		local rollupDuration = 0.5
		local new_value = self.store_data.map_credits or 0
		--print("wy_showStoreNodeReceiveCoinsAnimation_label","old_value= ",self.storeCredits,"new_value= ",new_value)
		self.storeLayoutList.label:nrStartRoll(self.storeCredits,new_value,rollupDuration)
		self.storeCredits = new_value
		-- local oriScaleX = self.storeLayoutList.label:getScaleX()
		-- local oriScaleY = self.storeLayoutList.label:getScaleY()
		-- self.storeLayoutList.label:runAction(cc.Sequence:create(
		-- 	cc.CallFunc:create(function()
		-- 		local value = self.store_data.map_credits or 0
		-- 		print("wy_showStoreNodeReceiveCoinsAnimation_value",value)
		-- 		self.storeLayoutList.label:setString(FONTS.formatByCount2(value,7,true))
		-- 	end),
		-- 	cc.ScaleTo:create(0.2,oriScaleX*1.5,oriScaleY*1.5),			
		-- 	cc.ScaleTo:create(0.1,oriScaleX,oriScaleY)
		-- ))
	end
	if self.storeLayoutList.logoAniNode then 
		local file = self:getPic("store/spine/store_logo/spine")
		local function callback()
			self.storeLayoutList.logoAniNode:removeAllChildren()
			self:showStoreNodeLogoLoopAnimation()
		end
		--self.storeLayoutList.logoAniNode:removeAllChildren()
		self:addSpineAnimation(self.storeLayoutList.logoAniNode,5,file,cc.p(0,0),"animation2",nil,nil,nil,false,false,nil)
	end
	
end


-- function _baseViewCtl:fixStoreCoinsRet(item_list) -- 用于正常停止时的Coin数据重构
-- 	--print("wy_fixStoreCoinsRet",tool.lua_to_json(item_list))
-- 	self.resultCoinsCache = {}
-- 	for k,v in pairs (item_list) do
-- 		local reelList = tool.tableClone(v)
-- 		table.insert(reelList,1,0) -- 插入 第一条数据
-- 		if self.isTurbo then
-- 			for i=1,3 do -- 插入后面几条数据
-- 				reelList[#reelList+1] = 0
-- 			end
-- 		else
-- 			for i=1,6 do -- 插入后面几条数据
-- 				reelList[#reelList+1] = 0
-- 			end
-- 		end

-- 		table.insert(self.resultCoinsCache,reelList)
-- 	end
-- end

function _baseViewCtl:clearStoreCoinData()
	-- self.resultCoinsCache = {}
end

-- function _baseViewCtl:_updateCellOtherAssets(theCellNode, key, col) -- 更新Cell Sprite上其他图片，如商店角标Coins
-- 	if not self.storeCoinsComeList then return end
-- 	if not self.showReSpinBoard then
-- 		local coin_pos = self.coin_pos or cc.p(40,-35)
-- 		if self.storeCoinsComeList and theCellNode and key and key > 0 then
-- 			local theSpriteFile = "#theme_store_coin"..key..".png"
-- 			if not theCellNode.coinSprite then
-- 				theCellNode.coinSprite = cc.Node:create()
-- 				theCellNode:addChild(theCellNode.coinSprite,100)
-- 			end
-- 			local sprite = bole.createSpriteWithFile(theSpriteFile)
-- 			sprite:setPosition(coin_pos)
-- 			sprite:setVisible(true)
-- 			theCellNode.coinSprite:addChild(sprite)
-- 			theCellNode.coinSprite:setVisible(true)
-- 		end		
-- 	end
-- end

function _baseViewCtl:updateCellFastOtherAssets(pCol) --暂时不用
	if self.storeVCtl then 
		self.storeVCtl:updateCellFastStoreAssets(pCol)
	end

	-- if self.storeCoinsComeList and bole.getTableCount(self.storeCoinsComeList) > 0 then
	-- 	local coin_pos = self.coin_pos or cc.p(40,-35)
	-- 	for i = 1,bole.getTableCount(self.storeCoinsComeList[pCol]) do
	-- 		local key = self.storeCoinsComeList[pCol][i]
	-- 		if key > 0 then
	-- 			local theSpriteFile = "#theme_store_coin"..key..".png"
	-- 			local cell = self.mainView:getCurSpinLayer().spins[pCol]:getRetCell(i)
	-- 			if not cell.coinSprite then
	-- 				cell.coinSprite = cc.Node:create()
	-- 				cell:addChild(cell.coinSprite)
	-- 			end
	-- 			local sprite = bole.createSpriteWithFile(theSpriteFile)
	-- 			sprite:setPosition(coin_pos)
	-- 			cell.coinSprite:addChild(sprite)
	-- 		end
	-- 	end
	-- end
end

-- function _baseViewCtl:getCoinInfoKey(col)
-- 	if not self.storeCoinsComeList then return end
-- 	col = col or 1
-- 	local key = self.storeCoinsComeList[col][1]
-- 	return key
-- end

-- function _baseViewCtl:getFlyCoinsData(data)
-- 	self.storeCoinsComeList = nil
-- 	if data["theme_info"] and data["theme_info"]["map_credit_list"] then
-- 		self.storeCoinsComeList = data["theme_info"]["map_credit_list"]
-- 		self:fixStoreCoinsRet(self.storeCoinsComeList)
-- 	end
-- end

-- store Tip
function _baseViewCtl:showThemeStoreTipDialog(tip_type,callback)
	tip_type = tip_type or 1
	local data = {}
	data.type = tip_type
	local endCallFunc = function()

		self.themeStoreTipDialog = nil
	end
	self.themeStoreTipDialog = ThemeBaseStoreGameTipsDialog.new(data, self, endCallFunc)
	self.themeStoreTipDialog:show()
end

function _baseViewCtl:hideThemeStoreTipDialog()
	if not self.themeStoreTipDialog then return end 
	self.themeStoreTipDialog:hide()
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--@ themeControl 整个迁移进来
function _baseViewCtl:oldThemeCtor()
	self.header 	 = nil
	self.footer  	 = nil
	self.betControl  = nil
	self.spinCount = nil
	self.lockTagList = {}	
	self.unlockQueue = BoleQueueStack.new()

	for _,theLockName in pairs(THEME_CONTROL_LOCK_LIST) do
		self.lockTagList[theLockName] = true
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:getHighRoom()
	local hightId = 1
	local themeId = self:getThemeId()
	if themeId then 
		local highLimit = THEME_LIST[themeId]['highLimit']
		if highLimit and highLimit == hightId then 
			return true
		end
		return false
	end
	return false
end
-- loading过程
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:onLoading( CallFunc )
	self:changeScreenAwakeState(true)
	bole.enterThemeTime = os.time()
	-- 初始化前后端消息通信
	self:initPotpCmd() 	-- 初始化相关server命令
	-- 显示loadding界面
	self:showLoadingView()

	self.loadingThemeID = self:getThemeId()

	local preLoadResAsyncCall = function ()

		if not self:getThemeId() then -- self.loadingThemeID ~= self:getThemeId() then 
			-- self.loadingThemeID = nil
			return 
		end
		-- 对主题内的资源进行加载
		local loadrestime = os.time()
		local resLoadEndCallFunc = function( )
			-- local duration = os.time() - loadrestime		
			self.lockTagList[THEME_CONTROL_LOCK_LIST.LOAD_RES] = false
		end
		self:preLoadResAsync(resLoadEndCallFunc)

		-- 对主题内的相关资源进行判断处理
		-- local resCheckEndCallFunc = function( )
		-- 	self.lockTagList[THEME_CONTROL_LOCK_LIST.CHECK_RES] = false
		-- end	
		-- self:checkResAndDeal(resCheckEndCallFunc)

		CallFunc()
	end

	-- 对主题资源进行下载
	self:downloadThemeRes(preLoadResAsyncCall,true)
end

function _baseViewCtl:showLoadingView( )
	PopupController:getInstance():setPopupState(false)

	local themeId = self:getThemeId()
	local loading = self:getThemeLoaddinView()
	loading:setPercent(0)
	self.curScene:addToLoadding(loading, 100)
	self.loadingView = loading

	-- 如果游戏是竖屏，切换屏幕到竖屏
	if self.isPortrait then 
		local screenCtl = ScreenControl:getInstance()
    	screenCtl:setScreenOrientation(true)
    else
    	local screenCtl = ScreenControl:getInstance()
    	screenCtl:setScreenOrientation(false)
	end
end

function _baseViewCtl:setBackLobbyBtnState( state, isHide )
	if self.loadingView and self.loadingView.setBackLobbyBtnState then 
		self.loadingView:setBackLobbyBtnState(state, isHide)
	end
end

function _baseViewCtl:hideLoadingView( )
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
function _baseViewCtl:onExit( )	
	self.themeid = nil

	if TimerCallFunc:getInstance().unscheduleGroup then
		TimerCallFunc:getInstance():unscheduleGroup()
	end
	self:changeScreenAwakeState(false)
	bole.enterThemeTime = nil
	-- 卸载相关主题资源
	self:_onExit()
	AudioControl:stopAllEffects()
	EventCenter:pushEvent(EVENTNAMES.THEME.STOP_ALL_EFFECTS)
	self.footer:onExit()
	-- 销毁相关初始配置
	self:unregisterPotpCmds()
	self:removeControlConfig()
	PopupController:getInstance():clearPopupList(true)
	-- LobbyThemeControl:getInstance().currentThemeId = -1
	-- bole.potp:send({OUT_OF_THEME, {}})
	-- LobbyControl:getInstance():sendEnterLobby()
	if self.stopControlSchedule then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.stopControlSchedule)
		self.stopControlSchedule = nil
	end
	JackpotControl:getInstance():stopJackpotRequest()	
end

function _baseViewCtl:removeControlConfig( )
    self.spinCounter 	= 0
    self.allrevenue 	= 0
    self.allcost 		= 0
end

function _baseViewCtl:onEnter( data )
	self:setRequestStatus(true)
	self:setBackLobbyBtnState(false, true)
	
	self.lockTagList[THEME_CONTROL_LOCK_LIST.ENTER_CMD] = false
	-- 缓存相关数据
	self.enterThemeData = data

	-- 处理jackpot相关
	-- LobbyThemeControl:getInstance().currentThemeId = self:getThemeId()
	JackpotControl:getInstance():setJackpot(data["jp_data"])
	JackpotControl:getInstance():resetPreJackpotData()
	PopupController:getInstance():clearPopupList(true)

	-- 初始化theme配置
	self:onInitConfig(data)
	-- 初始化Control配置
	self:initControlConfig(data)	
	-- 循环判断load进度
	self:begCheckEnterTheme(data)
	self.addLoadResCnt("onEnter")
	self.SpinCount = 0
	local user = User:getInstance()
	user.serverCoins = data["coins"]
end

function _baseViewCtl:initControlConfig( ... )
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
	----------------------------------------------------------------
	-- self.freewin 				= nil  		-- freespin期间所win金币数，存在且大于0，表示在freespin中，用途：判断是否在freesping中，表示freespin所赢coins
	-- self.freespin 				= nil		-- freespin剩余次数，默认值为0
	-- self.freeItem 				= nil 		-- 进入freespin时的item_list，用途：freespin结束后的现场还原	
	-- self.freeWinPos             = nil       -- 进入freespin时的win_pos，用途：freespin结束后的现场还原中奖连线
	-- self.freeSpeical            = nil       -- 进入freespin时的speical_pos，用途：freespin结束后的现场还原free item 动画
	self.bonusItem  			= nil 		-- 进入freespin时的item_list，用途：freespin结束后的现场还原
	self.bonusRet  				= nil 		-- 进入freespin时的item_list，用途：freespin结束后的现场还原
	----------------------------------------------------------------
	-- self.spinCD 		= self.spinTimeConfig["base"] -- 72/60 --106-24    -- 从spin开始计时，自动stop最短时间间隔	-- 通过方法获得 每个主题特定的时间
	self.specialAccelerationCD = 0 -- 向匀速运动中添加的时间，用来进行特殊的加速控制
	-- self.spinMinCD 		= self.spinTimeConfig["spinMinCD"]--50/60      	 -- 从spin开始计时，stop按钮可点击最短时间间隔	
end

-- 循环遍历loading进度
function _baseViewCtl:begCheckEnterTheme( data )
	if self.isBegCheckEnterTheme then return end
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
				if waitTime > 3 and logCount == 0 then
					logCount = 1
					self.theme:tryLoadPlistImages()
					needlog = true
				elseif waitTime > 6 and logCount == 1 then
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
					local info = {current = "entering_theme", ENTER_CMD = self.lockTagList[THEME_CONTROL_LOCK_LIST.ENTER_CMD] and 1 or 0,logCount = logCount,tid = tid}
					bole.send_codeInfo(Splunk_Type.ACTION, info, false)
				end
			end
		end
		if canEnter then
			bole.send_codeInfo(Splunk_Type.ACTION, {current = "on_enter_theme",tid=self.themeid},false)
			self:onEnterTheme(data)
		else
			self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(scheduleInterval),cc.CallFunc:create(schedulerFunc)))
		end		
	end
	schedulerFunc()
end
function _baseViewCtl:onEnterTheme( data )
	data = self:adjustEnterThemeRet(data)
	self.needRecord = true
	self.errorCount = 0 --用于统计差钱

	-- coins：用户总钱数
	if data["coins"] then
		-- User:getInstance():setCoins(data["coins"])
		self:saveThemeInfo(self.themeid, data["coins"])
	end

	-- cashback: 用户booster金额
	if data["cashback"] then
		StoreControl:getInstance():setCashbackData( data["cashback"] )
	end

	-- 更新活动相关数据
	if SystemController then
		SystemController:getInstance():oncmd (ENTER_THEME, data)
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
	self.betControl = ThemeBaseBetControl.new(self) 
	self.betControl:initBetControl()
	-- 假滚轴相关	
	if data["theme_reels"] then
		self.theme_reels = data["theme_reels"]
		self:resetCurrentReels(false)
	end

	---------------------- 初始化-------------------------------
	-- 初始化主题内部布局
	self:onEnterInitScene()
	-- 根据数据进行相关调整（bonus,jackpot,feature等界面相关调整，通过该函数进行初始化）
	self:adjustTheme(data)	

	-- 根据系统活动调整主题转轮比例
	if SystemController then
		SystemController:getInstance():adjustScreen(self, self.themeid)
	end
 

	-- 主题footer加锁
	self:lockThemeFooter()
	--主题footer描述信息初始化
	self.footer:changeLabelDescription("notFS_notWin") 
	-- 进行模块化处理
	self.enterThemeDealList = {}

	-- 断电重连后，bonus数据存放在该字段
	if data["bonus_game"] then
		self.enterThemeDealList["bonus_game"] = data["bonus_game"]
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
			self.betControl:refreshCurBet()
			self:onEnterThemeByFinshLoading(enterCallFunc)
			if UserGuideControl then
				UserGuideControl:getInstance():showUserGuide("gamerule_theme")
				UserGuideControl:getInstance():showUserGuide("daily_mul_theme")
				UserGuideControl:getInstance():showUserGuide("dashboard_theme")
			end
		 
			-- User:getInstance().header:lockHeaderButtons(true) -- can not touch header
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			-- User:getInstance().header:lockHeaderButtons(false) -- allow touch header
			-- 处理进入主题后，系统活动相关表现
			if SystemController then
				SystemController:getInstance():actionOnEnterTheme(self, self.themeid)
			end
			EventCenter:pushEvent(EVENTNAMES.THEME.ON_ENTER_THEME, {
				themeCtl = self,
				themeId = self.themeid,
			})
		end)
	))

	if self.themeid then
		local current_time = math.floor(bole.getServerTime() / 1000)
		libMM.setIntegerForKey("playing_theme_time_" .. self.themeid, current_time)
	end
	self:setGoldSpinHideGameRuleList()
end


function _baseViewCtl:lockThemeFooter( )
	self.footer:enableOtherBtns(false)
end
function _baseViewCtl:unlockThemeFooter( )
	self.footer:enableOtherBtns(true)
end
function _baseViewCtl:dealEnterProcessAndEnterTheme( )
	self:changeSpinOrFeatureState(true)

	local theDealList = self.enterThemeDealList
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

		self:unlockThemeFooter()
	end
end

function _baseViewCtl:updateEnterThemeDealList( key, value )
	if self.enterThemeDealList and key then 
		self.enterThemeDealList[key] = value
	end
end

function _baseViewCtl:dealFreePickGameData(theFreePickData,theFreeSpinData)	
    self:lockThemeFooter()
	-- 恢复Free Pick数据
	local rets = {}
	rets["free_random_pick"] = theFreePickData

    -- 做特殊行为，如设置Footer 上 Retrigger之前的个数
	if self.enterThemeByFreePickGame then self:enterThemeByFreePickGame(theFreePickData,theFreeSpinData) end

	self.enterThemeDealList["free_pick_game"] = nil
	self.enterThemeDealList["free_game_for_pick"] = nil

	local endCallFunc = function()
		self.rets = nil
		self:dealEnterProcessAndEnterTheme()
	end

	self:free_random_pick(rets,endCallFunc)
end

function _baseViewCtl:dealBonusGameData(theBonusGameData)
	-- 记录stage name
	self.stageName = theme_stage_List.bonus_game

	-- 恢复total bet
	local bonusSpinBet = theBonusGameData["bet"]
	if bonusSpinBet then 
		self:setPointBet(bonusSpinBet)
	end

	-- 恢复total win
	self.totalWin = self.totalWin or 0
	self.totalWin = self.totalWin + theBonusGameData["base_win"]
	self:updateFooterCoin()
	if self.freeCtl then self.freeCtl:updateFreeWin(self.totalWin) end  -- if self.freewin then self.freewin = self.totalWin end
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
	if self.enterThemeByBonus then self:enterThemeByBonus(theBonusGameData, endCallFunc) end
end

function _baseViewCtl:dealFirstFreeSpinData(theFreeSpinData)
	self.enterThemeDealList["first_free_game"] = nil
	if self.rets == nil then self.rets = {} end

	if self.freeCtl then 
		self.freeCtl:dealFirstFreeSpinData(theFreeSpinData)
	end


	-- -- 恢复total bet
	-- local freeSpinBet = theFreeSpinData["bet"]
	-- if freeSpinBet then self:setPointBet(freeSpinBet) end

	-- -- 恢复total win
	-- self.totalWin = self.totalWin or 0
	-- if self.totalWin == 0 then self.totalWin = theFreeSpinData["total_win"] end
	-- self:updateFooterCoin()

	-- self.freeItem 		= theFreeSpinData.item_list

	-- -- 禁掉footer上的按钮
	-- self:lockThemeFooter()

	-- local endCallFunc = function()
	-- 	self:dealEnterProcessAndEnterTheme()
	-- end

	-- self.enterThemeDealList["first_free_game"] = nil

	-- if self.rets == nil then self.rets = {} end
	-- if self.enterThemeByFirstFreeSpin then self:enterThemeByFirstFreeSpin(self.rets, theFreeSpinData, endCallFunc) end
end

function _baseViewCtl:dealFreeGameData( theFreeGameData ) -- 进入
	-- 恢复total bet
	-- 恢复total win
	local _totalWin = self:getTotalWin()
	if (not _totalWin) or _totalWin == 0 then 
		self:setTotalWin(theFreeGameData["total_win"])
	end
	self:updateFooterCoin()

	-- 传给Theme Recover标志位 -- 更新部分 需要特殊计数的设置值
	self:setFreeGameRecoverState(theFreeGameData)

	if self.freeCtl then 
		self.freeCtl:dealFreeGameData(theFreeGameData)
	end


	-- -- 恢复total bet
	-- -- 恢复total win
	-- self.totalWin = self.totalWin or 0
	-- if self.totalWin == 0 then self.totalWin = theFreeGameData["total_win"] end
	-- self:updateFooterCoin()

 --    -- 传给Theme Recover标志位 -- 更新部分 需要特殊计数的设置值
 --    self:setFreeGameRecoverState(theFreeGameData)

	-- -- 恢复X of Y
	-- local freeSpinCnt = theFreeGameData["free_spins"] or 0
	-- if freeSpinCnt < 0 then
	-- 	local freeSpinBet = theFreeGameData["bet"]
	-- 	if freeSpinBet then
	-- 		self:setPointBet(freeSpinBet)
	-- 	end

	-- 	-- 收钱协议 后端
	-- 	self:collectCoins(0)
	-- 	-- rollup结束后把钱加到header上
	-- 	self:updateFooterCoin()
	-- 	self:addCoinsToHeader()

	-- 	self:removePointBet() -- 解除bet 锁定
	-- 	self.enterThemeDealList["free_game"] = nil
	-- 	self:dealEnterProcessAndEnterTheme()

	-- elseif freeSpinCnt == 0 then -- 恢复FreeCollect 弹板
       
	-- 	self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
	-- 	self.freespin   	= freeSpinCnt
	-- 	self.freewin 		= self.totalWin or 0 -- 0
	-- 	self.freeItem 		= theFreeGameData.item_list

	-- 	-- 恢复free spin场景
	-- 	self:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
	-- 	self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
	-- 	self:runFreeCollectSpinStage()
	-- 	 -- 禁掉footer上的按钮
	--     self:lockThemeFooter()
	-- 	self:adjustWithFreeSpin()

	-- 	local freeSpinBet = theFreeGameData["bet"]
	-- 	if freeSpinBet then
	-- 		self:setPointBet(freeSpinBet)
	-- 	end

	-- 	if self.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
	-- 		self:resetPointBet()
	-- 	end
	-- 	self.enterThemeDealList["free_game"] = nil
	-- 	self:dealEnterProcessAndEnterTheme()		
	-- else
	-- 	self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
	-- 	self.freespin   	= freeSpinCnt
	-- 	self.freewin 		= self.totalWin or 0 -- 0
	-- 	self.freeItem 		= theFreeGameData.item_list

	-- 	-- 恢复free spin场景
	-- 	self:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
	-- 	self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
	-- 	self:runFreeSpinStage()
	-- 	self:adjustWithFreeSpin()

	-- 	local freeSpinBet = theFreeGameData["bet"]
	-- 	if freeSpinBet then
	-- 		self:setPointBet(freeSpinBet)
	-- 	end

	-- 	if self.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
	-- 		self:resetPointBet()
	-- 	end
	-- 	self.enterThemeDealList["free_game"] = nil
	-- 	self:dealEnterProcessAndEnterTheme()
	-- end
	-- -- local freeSpinBet = theFreeGameData["bet"]
	-- -- if freeSpinBet then
	-- -- 	self:setPointBet(freeSpinBet)
	-- -- end
end

function _baseViewCtl:dealFreeSpinData( theFreeSpinData )
	self.enterThemeDealList["spin_free_game"] = nil

	-- 记录stage name
	self.stageName = theme_stage_List.free_game
	EventCenter:pushEvent(EVENTNAMES.THEME.IS_IN_FREE)

	if self.freeCtl then 
		self.freeCtl:dealFreeSpinData(theFreeSpinData)
	end

	

	-- -- 记录stage name
	-- self.stageName = theme_stage_List.free_game

	-- local delay = self.themeid == 101 and 1.6 or 1.7
	-- self:laterCallBack(delay, function ()
	-- 	self:toSpin()
	-- 	self:dealEnterProcessAndEnterTheme()
	-- end)
	-- self.enterThemeDealList["spin_free_game"] = nil
end

function _baseViewCtl:dealFreeCollectData(rets)
	self.enterThemeDealList["collet_free_game"] = nil
	-- 记录stage name
	self.stageName = theme_stage_List.free_game
	EventCenter:pushEvent(EVENTNAMES.THEME.IS_IN_FREE)

	if self.rets then return end

	self:lockThemeFooter()
	if self.setDealFreeCollectState then 
		self:setDealFreeCollectState()
	end

	if self.freeCtl then 
		self.freeCtl:dealFreeCollectData(rets)
	end

	-- self.stageName = theme_stage_List.free_game
	-- -- 禁掉footer上的按钮
	-- self:lockThemeFooter()

	-- if self.rets then return end
	-- local ret = {}

	-- if self.setDealFreeCollectState then 
	-- 	self:setDealFreeCollectState()
	-- end

	-- self.footer:setSpinStateOnFinishSpin(true)
	-- self:finshSpinByHandle(ret)
	-- self.enterThemeDealList["collet_free_game"] = nil
end

-- auto_spin相关
function _baseViewCtl:enableAuto( enable )
	self.autoSpin = enable
	self:changeScreenAwakeState(enable)
	self.footer:enableAuto(enable)
	if enable then
		self:toSpin()
	else
		self.autoSpinFast = false
	end
end

function _baseViewCtl:setAutoSpinFast(bool)
	self.autoSpinFast = bool
end

function _baseViewCtl:setAutoSpinCount( count )
	if count and type(count) ~= "number" then
		self.autoSpinFast = true
		self.autoSpinCount = nil
		return 
	end

	self.autoSpinCount = count
	self.footer:setAutoplayRemaining(self.autoSpinCount)
end

-- footer_spin_按钮逻辑相关
function _baseViewCtl:touchSpinCheckDealAutoSpin( )
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

function _baseViewCtl:touchSpinBtnBegan( spinBtn )
	if not self.mainView or not self.mainView:hasSpinLayer() then return end
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
function _baseViewCtl:touchSpinBtnEnded( spinBtn )
	if not self.mainView or not self.mainView:hasSpinLayer() then return end
	if not self.touchSpinTag then return end
	if self.autoSpinAction then
		self.node:stopAction(self.autoSpinAction)
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
            self:toSpin()
			self:dealMusic_TouchBtnSpinMusic()
    	end
    end
end

function _baseViewCtl:touchSpinBtnCanceled( spinBtn )
	self.autoSpinAction = nil
	self.touchSpinTag   = false
end

function _baseViewCtl:adjustActivity()
	local scale = THEME_LIST[self.themeid]["questScale"]
	self.mainView:adjustActivityScale(scale)
end

function _baseViewCtl:resetReelScale( )
	self.mainView:resetReelScale()
end

function _baseViewCtl:setDownNodeScale(scale)
    self.downNodeScale = scale
end

function _baseViewCtl:getDownNodeScale( ... )
	return self.downNodeScale
end

function _baseViewCtl:setFooterStopBtn( )
	if self.cacheSpinRet and self:checkCanSetStopBtn(self.cacheSpinRet) then
		self.footer:setStopBtn()
	end
end

-- total win 相关
function _baseViewCtl:setTotalWin(coin)
	coin = coin or 0
	self.totalWin = coin
end

function _baseViewCtl:getTotalWin()
	return self.totalWin
end

-- 更新Footer赢钱
function _baseViewCtl:updateFooterCoin()
	local coins = self.totalWin or 0
	if coins > 0 then 
		self.footer:setWinCoins(coins, 0, 0)
	end
end

-- spin相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:toSpin( statusStr )
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

	local function callback( )
		self.spinCounter = self.spinCounter + 1
		self:spin()
	end
	self:spinControl( callback, statusStr )
end
function _baseViewCtl:spin( )
	User:getInstance().is_Spining = true
	local tBet = self:getCurTotalBet()

	if self.freeCtl then 
		self.freeCtl:updateFreeCntCacheBySpin()
	end


	if self.freeCtl and self.freeCtl:isFGEnd() then
		local user = User:getInstance()
		if appDebugMode then
			-- if user.serverCoins and (user.serverCoins-user.coins > 100000 or user.serverCoins-user.coins<-100000) and not RecordControl:getInstance().isLevelUp then
			-- 	ErrorMessage.new():showCoin(user.serverCoins,user.coins)
			-- end
		elseif self.needRecord and user.serverCoins and (user.serverCoins-user.coins > 100000 or user.serverCoins-user.coins<-100000) then
			self.errorCount = self.errorCount or 0
			self.errorCount = self.errorCount + 1
			if self.errorCount > 2 then
				self.needRecord = false
				bole.send_codeInfo(Splunk_Type.CoinError,{serverC = user.serverCoins,localC = user.coins,themeid = self.themeid,event_type=3},false)
			end
		else
			self.errorCount = 0
		end
		-- 在spin时处理系统相关活动
		-- local break_spin = SystemController:getInstance():actionOnSpin(self.curScene, self.themeid)
		-- if break_spin then
		-- 	return
		-- end
		
		if not user:addCoins(tBet*-1) then
			self:out_of_coins()
			if self.refreshNotEnoughMoney then
				self:refreshNotEnoughMoney()   -- added by rwb,钱不够时，释放收集条等的锁住状态

			end
			self:setDelayToFadeOutLoopMusic()

			self.spin_processing = false
			self:changeSpinOrFeatureState(false)
			return
		end
		user:refreshHeaderCoins()
	else
		self.freeCtl:updateFreeSpinCntBySpin()
		self.freeCtl:adjustWithFreeSpin()
	end
	self.isRespin = false
	self.spinning = true
	self.needShowRateUs = false
	self:cleanStatusWithSpin()

	-- 缩回钱袋
	if not self.autoSpin and not self.freewin then
		EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.C_SHOW_TIP, {show = false, quiet = false})
	end
	-- 锁住大厅按钮
	self:lockLobbyBtn()
	-- 向后端请求spin数据
	self:requestSpin()
	-- spin扩展点
	self:onSpinStart()
	-- shz_nsm
	self.footer:onSpinStart()	
	-- 让棋盘roll起来
	self:spinBoard()
	-- 在新的一次bet中清零totalWin
	if self.stageName == theme_stage_List.base_game then self.totalWin = 0 end
end

-- function _baseViewCtl:adjustWithFreeSpin()
-- 	self:updatedFreeSpinCount(self.freespin, self.sumFreeSpinCnt)
-- end

function _baseViewCtl:cleanStatusWithSpin( ) -- 进行 特殊加速的状态清除
	self.cacheSpinRet 	= nil
	self.rets 			= nil
	self.specials 		= nil
	self.winRet 		= nil
	self.lockTime 		= nil

	self.specialSpeed = false
	self.haveSpeedSmybol = false

	self.curScene:stopActionByTag(tag_deal_handle)
	self:clearAnimate()
	self:cleanStatus()
end


function _baseViewCtl:requestSpin(...)

	self.spinCount = self.spinCount or 0
    self.spinCount = self.spinCount + 1
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
	cc.UserDefault:getInstance():setIntegerForKey(key, spinIndex)
	local data = {list = {spineData[spinIndex]}}
	self:dealRequestSpinResult(data)

	local curBet = self:getCurBet()
	local autoSpinStatus = self.autoSpin and 1 or 0
	self.spinRequestTime = os.time()
	if not self.freewin then
		if self.saveBet ~= curBet  then
			self.saveBet = curBet
		end
	end
	self:startCalculateRequestTime(true) -- whj 添加用来计算开始spin到来结果的时间不超过25s
end	
-----------------------------------------------------------------------------------------------------------------------------------------------
-- spin结果处理相关
-----------------------------------------------------------------------------------------------------------------------------------------------
local freecount =0
local Fcount = 0

function _baseViewCtl:AddFakeData(data)
	if data and data["list"] and data["list"][1] and data["list"][1]["item_list"] then 
		local dataList = data["list"][1]
		local item_list_down = dataList["item_list_down"] or {{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1}}
		local item_list_up = dataList["item_list_up"] or {{1},{1},{1},{1},{1}}

		self.resultCache = {}
		self.resultCoinsCache = {}
	
		for k,v in pairs (dataList["item_list"]) do

			local reelList = tool.tableClone(v)
			
			table.insert(reelList,1,item_list_up[k][1]) -- 插入 第一条数据
			
			if self.isTurbo then
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

	return data
end 

function _baseViewCtl:dealRequestSpinResult( data )
	local result = data['list'] and data['list'][1] or nil
	data = self:AddFakeData(data)
	if not self.cacheSpinRet and not self.rets then
		self.cacheSpinRet = data['list'][1]
		local stopCalls = function()

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

				cc.UserDefault:getInstance():setIntegerForKey(flag, curBet)

				self:normalStop(timeInterval)
				local interval = self.theme.ExtraStopCD
				if self:isAutoSpinFast() and self.canFastStop then
                    self.curScene:runAction(
                        cc.Sequence:create(
                            cc.DelayTime:create(interval),
                            cc.CallFunc:create(function()
                                self:fastStop()
                            end)))
                elseif not self.autoSpin and self.canFastStop then
                    local function delayShowStop()
                        -- self:setFooterStopBtn()
                    end
                    self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(interval),
                                                               cc.CallFunc:create(function()
                        delayShowStop()
                    end)))
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
	    			self:stopControl( self.cacheSpinRet, stopCalls )

	    			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.stopControlSchedule)
					self.stopControlSchedule = nil
	    		end
	    	end, 1, false)
		else
			self:stopControl( self.cacheSpinRet, stopCalls )
		end
		
	end	
end

function _baseViewCtl:isAutoSpinFast(...)
    return self.autoSpinFast
end

function _baseViewCtl:showCellsVoucherLogoFast(colid, cell, nIndex, bHide)
	-- VoucherController:getInstance():showCellsVoucherLogoFast(colid, cell, nIndex, bHide)
end

function _baseViewCtl:batchSpinAdjust(  )
	local theme_name = string.gsub(THEME_LIST[self.themeid]['name'], " ", "_")
	local highLimit = THEME_LIST[self.themeid]['highLimit']
	if highLimit == 0 then -- 普通房
		if bole.isIOS() then
			Adjust:getInstance():trackCallback("yk56sn",{event_name="Slot_" .. theme_name})
		elseif bole.isAndroid() then
			Adjust:getInstance():trackCallback("qm8n70",{event_name="Slot_" .. theme_name})
		end
	elseif highLimit == 1 then -- 高级房
		if bole.isIOS() then
			Adjust:getInstance():trackCallback("yk56sn",{event_name = "highlimit", theme = "Slot_" .. theme_name})
		elseif bole.isAndroid() then
			Adjust:getInstance():trackCallback("qm8n70",{event_name = "highlimit", theme = "Slot_" .. theme_name})
		end
	end
end
function _baseViewCtl:onSpinResult( ret )
	-- freespin 无
	if not self:isInFG() then
		self.header:showPigSavingPotAnimation()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- stop相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:normalStop(interval)
	if not self.cacheSpinRet then return end
	self:stop(self.cacheSpinRet,interval)
end

function _baseViewCtl:fastStop( ) -- qiucksstop
	if not self.cacheSpinRet then return end
	self.footer:onFastStop()
	-- self:stop(self.cacheSpinRet)
	self:fastStopBoard()
end

function _baseViewCtl:stop( ret,interval )
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
	
	local winCoins = self.rets["total_win"] or 0
	local totalBet = self:getCurTotalBet()
	if (winCoins/totalBet) > 15 then
		self.rets["special_effect"] = true
	end	
	self:onStop_at_firstTime(self.rets) -- 显示是否升级，经验变化 DailyBonus经验变化和 特殊连线
	self:onSpinStop(self.rets) -- 执行 长条symbol 进行分析 和每个主题的特殊 需求 比如 disk
	self:onStop_at_afterTheme(self.rets) -- 是否中jackpot 和 bonus 
	self:adjustThemeReels(self.rets) -- 调整滚轴 看是否有需求
	self:adjustRecData(self.rets) -- 中奖连线配置
	self:adjustRecOtherData(self.rets) -- 没有东西了
	self:stopReels(self.rets,interval) -- 停止滚轴

	return true
end

function _baseViewCtl:onStop_at_firstTime( ret )
	if ret["experience"] then
		self:refreshExp(ret)
	end

	-- cashback: 用户booster金额
	if ret["cashback"] then
		StoreControl:getInstance():setCashbackData( ret["cashback"] )
	end

	if ret["piggy_bag_info"] then
		StoreControl:getInstance():setPiggyBagInfoData(ret["piggy_bag_info"])
	end

	-- 更新piggy金钱
	if ret["piggy_bank"] then
		StoreControl:getInstance():setPiggyData(ret["piggy_bank"])
	end

	if ret["sp_piggy_bank"] then
		StoreControl:getInstance():refreshSpPiggyBankData(ret["sp_piggy_bank"], "sp_piggy")
	end

	-- 更新unlock列表
	if ret["unlock"] then
		if not TournCashController:getInstance():isInTournCashTheme() then
			self:handleUnlockData(ret["unlock"])
			ret["theme_unlock"] = true
		end
	end

	-- -- free spin里不需要播放
	-- if not self.freewin then
	-- 	self.header:showPigSavingPotAnimation()
	-- end
end

function _baseViewCtl:onStop_at_afterTheme( ret )
	if ret["jackpot_game"] or ret["bonus_game"] then
		self.playGame = true
	end
end

function _baseViewCtl:adjustRecData( ret )
	local themeType = self:getThemeType()
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
function _baseViewCtl:setStopEndFunc( theEndFunc ) -- 目前 可以用来做延迟使用（滚轴停止之后 延迟 调用结算self:handleResult()方法）
	self.stopEndFunc = theEndFunc
end
function _baseViewCtl:stopReels( ret ,interval)
	-- 对结果进行分析	
	self:genSpecials()
	self:genSpecialSymbolState(ret)
	local endCallFunc = function()
		local nextCallFunc = function()
			self.spinning = false
			-- self.isRespin = false
			self:onAllReelStop()
			-- self.footer:onAllReelStop()
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
	self:stopBoard(ret, endCallFunc, interval)
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- respin相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:respin( canStopDelay, respinStopCallFunc )
	if self.spinning then return end
	if not self.rets then return end
	self.spinning 			= true
	self.isRespin 			= true
	self.respinStopTag 		= true
	self.respinStopEndFunc 	= respinStopCallFunc
	self:onRespinStart()
	self.footer:onRespinStart()
	self:spinBoard("respin")
	------------------------------------------------
	self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(canStopDelay or 1),cc.CallFunc:create(function()
		if not self.autoSpin then 
			self:setFooterStopBtn()
		end
		self:normalStopRespin()
	end)))
end
function _baseViewCtl:normalStopRespin( )
	self:stopRespin()
end
function _baseViewCtl:fastStopRespin( )
	self:stopRespin()
	self.footer:onRespinFastStop()
	self:fastStopBoard()
end
function _baseViewCtl:stopRespin( )
	if not self.respinStopTag then return end
	self.respinStopTag = false
	self.rets["control_add_delay"] 	= 0
	self:onRespinStop(self.rets)
	self:genSpecials()
	self:genSpecialSymbolState(self.rets)
	-- local itemList  = self.rets["reelItem_list"] or self.rets["item_list"] -- 修改逻辑 拿假 拼接之后的list 来进行停止滚轴的操作
	local endCallFunc = function()
		local nextCallFunc = function()
			self.spinning = false
			-- self.isRespin = false
			self:onAllReelStop()
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
	self:stopBoard(self.rets, endCallFunc,1)
	return true
end

function _baseViewCtl:onRespinOver() -- whj 添加
	if self:noFeatureLeft() then 
		self.footer:onRespinOver()-- 激活spin按钮，控制成可以点击状态
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- 棋盘落定后相关逻辑
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:getHandleProcess( ... )
	return {
			{"jackpot_sync_data", 	self.jackpot_sync_data}, -- 应该作用是分析jackpot 数据吧 --  灭有看到具体的实现样子
			{"control_add_delay",	self.control_add_delay}, -- 延迟 是一定存在的
			{"theme_deal_data", 	self.theme_deal_data}, -- 直接清空状态了
			{"theme_deal_show", 	self.theme_deal_show}, -- 控制播放动画的 应该是合图动画
			{"theme_respin", 		self.theme_respin},    -- respin逻辑
			{"level_up",			self.save_level_up},
			{"vip_level_up",		self.vip_level_up},
			{"theme_unlock",        self.theme_unlock},
			------------------------------------------------------------------------------------
			{"theme_data",			self.handle_themeinfo},
			{"win_type",			self.play_win_effect}, -- bigwin 或者 其他大奖赢钱之后 被调用的 动画
			{"jackpot_win", 		self.jackpot_win},
			------------------------------------------------------------------------------------
			{"before_win_show", 	self.before_win_show}, -- 赢钱之前的操作，进行类似的 显示wild倍数
			{"setWinCoins", 		self.setWinCoins}, 
			{"setFeatureWinCoins", 	self.setFeatureWinCoins}, 
			------------------------------------------------------------------------------------
			{"after_win_show", 		self.after_win_show}, -- 赢钱完成之后的操作，进行类似的 wild增加 jackpot 的操作
			{"jackpot_game", 		self.jackpot_game},			
			{"spin_wheel", 			self.spin_wheel}, -- 不知道是个啥
			{"bonus_game", 			self.bonus_game},
			{"free_random_pick", 	self.free_random_pick},	-- pick free	
			{"free_spins",			self.free_spins},			
			{"booster_tips",		self.booster_tips},
			{"finish_actions",	    self.finish_actions}, -- 所有行为结束的时候，需要干的事情，比如解锁地图
		} 
end

function _baseViewCtl:noFeatureLeft()
	local no_feature_left = true

	-- 判断正常状态下是否有未处理的feature
	if self.rets and (self.rets["bonus_game"] or self.rets["free_random_pick"] or self.rets["free_spins"]) then no_feature_left = false end

	-- 判断退出重连状态下是否有未处理的feature
	if self.enterThemeDealList and (self.enterThemeDealList["bonus_game"] or self.enterThemeDealList["first_free_game"] or self.enterThemeDealList["spin_free_game"] or self.enterThemeDealList["free_pick_game"]) then no_feature_left = false end

	-- 如果主题有特殊feature
	if no_feature_left then
	   if self.noFeatureLeftSpecial then no_feature_left = self:noFeatureLeftSpecial() end
	end

	-- 判断是否在free stage
	if self:isInFG() then no_feature_left = false end


	return no_feature_left
end

function _baseViewCtl:inSpinOrFeature( )
	local spin_or_feature = false
	if self.spin_processing or (not self:noFeatureLeft()) then 
		spin_or_feature = true
	end
	return spin_or_feature
end


function _baseViewCtl:changeSpinOrFeatureState( state )
	local data = { ["spin_or_feature"] = state }
	EventCenter:pushEvent(EVENTNAMES.THEME.SPIN_OR_FEATURE, data)
end

function _baseViewCtl:handleResult()
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
	self:finshSpinByHandle(self.rets)
end

function _baseViewCtl:dealStateWithFinishSpin( isCollectFreeSpin )
	self.footer:onFinishSpin()
	self:finshSpin()
	self.isProcessing 	= false
	
	if self.autoSpin or (self.freeCtl:hasFGCnt()) then 
		-- print("zhf dealStateWithFinishSpin start spin")
		local delay = 0.8
		if isCollectFreeSpin then
			delay = 0.3
		elseif self.rets and self.rets["total_win"] and self.rets["total_win"]>0 then
			delay = 1
		end

		if self.dealDelayBeforeFreeSpin then
			local d = self:dealDelayBeforeFreeSpin()
			if delay < d then
				delay = d
			end
		end
		local cacheSpinCounter = self.spinCounter
		if self.isFirstFreeGame then
			self.isFirstFreeGame = false
			if self.FirstFreeGameDelay == 0 then
				self:toSpin()
			else
				delay = self.FirstFreeGameDelay
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
function _baseViewCtl:finshSpinByHandle( rets, endSpinCallFunc )
	self:playRateUs(rets["rate_us"])
	self.isRespin = false
	if self.freeCtl:isFGEnd()  then
		if self:isInFG() then
			local endCallFunc = function( )
				self:spin_end()
				self:unlockLobbyBtn()
				self:setDelayToFadeOutLoopMusic() -- 新增，静音音效

				self:changeScreenAwakeState(false)
				-- User:getInstance():addCoins(self.freewin)
				local _free_win = self:isInFG()
				User:getInstance():setFreeWin(_free_win)				
				self.freeCtl:updateFreeWin(nil) -- self.freewin = nil
				self:dealStateWithFinishSpin(true)		
			end			
			local delay = 0
			if self.dealDelayBeforeFreeSpin then
				local d = self:dealDelayBeforeFreeSpin()
				if delay < d then
					delay = d
				end
			end
			
			self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function( ... )
				self:stopDrawAnimate()
				self:collectFreeSpin(endCallFunc)
			end)))
		else
			self:spin_end()
			self:unlockLobbyBtn()
			self:setDelayToFadeOutLoopMusic() -- 新增，静音音效
	    end
	else
		self:spin_end()
	end
	if not self:isInFG() then
		-- 升级后需要从服务器取jackpot数据
		if self.isLevelUp then
			self.isLevelUp = false
			JackpotControl:getInstance():updateJackpot()
		end
		self.betControl:refreshBetList()
	end

	-- SystemController:getInstance():actionOnFinishSpin(self.themeid, self.rets)

	-- SystemController:getInstance():showCollectCoinsStamp() -- 展示collect_coins协议收到的邮票

	self:dealStateWithFinishSpin(false)
end

function _baseViewCtl:changeScreenAwakeState(keepOn)
	if keepOn or self.autoSpin or self:isInFG() then
		bole.keepScreenAwake(true)
	else
		bole.keepScreenAwake(false)
	end
	
end

function _baseViewCtl:drawAnimate( ret )
	local delay = 0
	if ret["win_pos_list"] and #ret["win_pos_list"]>0 then
		if self.winWays then
			delay = self:drawWaysThemeAnimate(self.winWays, self.mainView:getCurSpinLayer(), ret, self.specials)
		elseif self.winLines then
			delay = self:drawLinesThemeAnimate(self.winLines, self.mainView:getCurSpinLayer(), ret, self.specials)
		end
	end
	return delay
end	
-- 延时相关
function _baseViewCtl:control_add_delay( ret )
	local delay = ret["control_add_delay"] or 0
	ret["control_add_delay"] = nil
	local curTime = os.time()
	local objTime = curTime+delay
	if self.lockTime and self.lockTime>objTime then
		delay = self.lockTime-curTime
	end
	local act = cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
		-- 初始化footer win上数据为0
		if not self:isInFG() then
			-- 此处不知道为什么要清一次数据
			-- self.footer:checkCleanCoinsAdd()
		end
		self:handleResult()			
	end))
	act:setTag(tag_deal_handle)
	self.curScene:runAction(act)
end

function _baseViewCtl:handle_themeinfo(ret)
	ret["theme_data"] = nil
	
	local onEnd = function( )
		self:handleResult()
	end
	self:onThemeInfo(ret,onEnd)
	
end

function _baseViewCtl:handle_SpecialWin(ret)
	local wintype = ret["hasSpecialWin"]
	ret["hasSpecialWin"] = nil;
	
	local endCallfunc = function ( ... )
		self.audioCtl:dealMusic_SetLoopMusic(1)
	 	self:handleResult()
	end
	self.audioCtl:dealMusic_SetLoopMusic(0.3)
	self:onSpecialWin(wintype, endCallfunc)
end

function _baseViewCtl:play_win_effect( ret ) -- big win 之类的大奖中间操作 可以添加相关操作 不同等级的赢钱
	ret["win_type"] = nil
end
-- jackpot相关
function _baseViewCtl:jackpot_sync_data( ret )
	-- 后续参照forever实现
	local theSyncData = ret["jackpot_sync_data"]
	ret["jackpot_sync_data"] = nil
	if self.syncJackpotData then
		local endCallfunc = function( )
			self:handleResult()
		end
		self:syncJackpotData(theSyncData,endCallfunc)
	else 
		self:handleResult()
	end		
end

function _baseViewCtl:jackpot_game( ret )	
	local theGameData = ret["jackpot_game"]
	ret["jackpot_game"] = nil
	local endCallfunc = function( )
		self:handleResult()
	end
	self:playWinJackpotGame(theGameData, endCallfunc)
end

function _baseViewCtl:jackpot_win( ret )
	--local winCoins = ret["jackpot_win"]
	ret["jackpot_win"] = nil

	local onEnd = function( )
		self:handleResult()
	end
	if self.onJackpotWin then
	   self:onJackpotWin(ret,onEnd)
	else
		onEnd()
	end
end

function _baseViewCtl:before_win_show( ret )
	--local winCoins = ret["jackpot_win"]
	ret["before_win_show"] = nil

	local onEnd = function( )
		self:handleResult()
	end
	if self.beforeWinShow then
	   self:beforeWinShow(ret,onEnd)
	else
		onEnd()
	end
end

-- 转盘相关
function _baseViewCtl:spin_wheel( ret ,endThemeCallfunc)

	-- 记录当前stage
	self.stageName 		= theme_stage_List.wheel_game

	self.audioCtl:dealMusic_MuteLoopMusic()
	local theGameData      = ret["spin_wheel"]
	ret["spin_wheel"] = nil
	local theSpecials 	= self.specials
	local endCallfunc   = endThemeCallfunc or function()
		self:handleResult()
	end

	if self.enterSpinWheel then 
		self:enterSpinWheel(ret, theGameData, endCallfunc) 
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
function _baseViewCtl:bonus_game( ret )
	-- 记录当前stage
	self.stageName 		= theme_stage_List.bonus_game

	local theGameData 	= ret["bonus_game"]
	ret["bonus_game"] 	= nil
	-- whj 添加逻辑 special_type 状态重置
	ret["special_type"]	= nil
	local endCallfunc 	= function( )
	    if self:canShowJackpotNotification() then
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
function _baseViewCtl:save_level_up( ret )
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
	
end

-- vip_level_up
function _baseViewCtl:vip_level_up( ret )
	local vipLevelUpData = ret["vip_level_up"]
	ret["vip_level_up"]   = nil
	local endCallFunc = function()
		self:handleResult()	-- 这个函数是用来往下顺序执行的
	end
	self:playVipLevelUp(vipLevelUpData, endCallFunc)	
end

-- unlock
function _baseViewCtl:theme_unlock( ret )
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
			-- local theme_id = self.unlockQueue:deQueue()
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

function _baseViewCtl:handleUnlockData(unlock_data)

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
				cbKey = "ThemeBaseViewControl",
			})
	    end
	end

end

-- handle_refreshExp
function _baseViewCtl:refreshExp( ret )
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
			self:lockThemeVoices(5)

			ret["vip_level_up"] = ret["levelup"]
			ret["level_up"] = ret["levelup"]

			self.header:setLevelUpData(ret["level_up"])

			-- 添加adjust
			local length = #ret["level_up"]
			if length > 50 then
				length = 50
			end
			for i = 1, length do
				local level = ret["level_up"][i].level
				if bole.isIOS() then
			        Adjust:getInstance():trackCallback("yk56sn",{event_name = "levelup", level = level})
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
		user:addExp(expData - user.exp, true , self.isPortrait)

	end	
end

function _baseViewCtl:playLevelUp(levelUpData, endCallFunc)
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
	performWithDelay(self.node, callFunc, delay)

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

function _baseViewCtl:playVipLevelUp(levelUpData, endCallFunc)
 	
	VipDetailControl:getInstance():playVipLevelUp(levelUpData, endCallFunc, true)	

end

function _baseViewCtl:checkDownNextThemeRes( levelUpData )
	-- todo
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- 小游戏相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:playWinJackpotGame( theGameData, endCallfunc )
	-- -- 主题内部扩展方式
	if self.playJackpotGame then
		self:playJackpotGame(theGameData, endCallfunc)
		return nil
	end
	-- 后续参照forever实现
	if endCallFunc then
		endCallFunc()
	end
end
function _baseViewCtl:playBonusGame( theGameData, endCallfunc )
	-- -- 主题内部扩展方式
	local delay = 0
	if self.playBonusAnimate then
		delay = self:playBonusAnimate(theGameData) or 0 
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

function _baseViewCtl:stopControlDelay( ... )
	self.curScene:stopActionByTag(tag_deal_handle)
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- win_coins相关
--------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:setWinCoins( rets )
	rets["setWinCoins"] = nil

	-- 循环播放win cycle动画（中奖symbol和边框）
	local delay = self:drawAnimate(rets) or 0
	-- 开始meter rollup
	local winCoins = rets["total_win"] == rets["base_win"] and rets["total_win"] or rets["base_win"]
	local endCallFunc = function( ) self:handleResult() end
	

	-- 如果在RollUp前需要进行特别的行为，在主题里定义actionBeforeRollUp
	if self.actionBeforeRollUp then
		delay = delay + self:actionBeforeRollUp(rets)
	end
	local tb = nil
	if self.getRollUpBet then -- rollup之前进行 bet 控制
		tb = self:getRollUpBet(rets)
	end
	self.curScene:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ()
			self:startRollup(winCoins, endCallFunc,tb)
		end)))
end

function _baseViewCtl:setFeatureWinCoins(rets)
	-- 开始meter rollup
	local winCoins = rets["setFeatureWinCoins"] or (rets["total_win"] - rets["base_win"])
	rets["setFeatureWinCoins"] = nil
	local endCallFunc = function( ) self:handleResult() end

	local delay = 0
	-- 如果在RollUp前需要进行特别的行为，在主题里定义actionBeforeRollUp
	if self.actionBeforeRollUp then
		delay = delay + self:actionBeforeRollUp(rets)
	end
	local tb = nil
	if self.getRollUpBet then -- rollup之前进行 bet 控制
		tb = self:getRollUpBet(rets)
	end
	self.curScene:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ()
			self:startRollup(winCoins, endCallFunc,tb)
		end)))
end

-- total win 金币的收集
function _baseViewCtl:startRollup(winCoins,callback,tb)

	local getCoins = winCoins
	local bet = self.saveBet or 10000
	local multiple = bet / 10000
	getCoins =  math.floor(winCoins * multiple)  



	local start = self.totalWin or 0
	local totalBet = tb or self:getCurTotalBet()
	self:setWinCoins_noHandle( getCoins )

	self:dealMusic_FadeLoopMusic(0.5, 1, 0.3)
	local endCallFunc = function( )
		self:dealMusic_FadeLoopMusic(1, 0.3, 1)

		-- rollup结束后把钱加到header上
		self:addCoinsToHeader()
		if self.rollOverFunc then 
			self:rollOverFunc(self.totalWin) -- rollUp之后 进行的 每个类特殊的操作
		end
		-- 如果需要在rollup结束后添加其他操作，在此扩展
		if callback then callback() end
	end
	self.footer:setWinCoinsEffect(getCoins, start ,totalBet, endCallFunc)

end

function _baseViewCtl:setFooterWinCoinsEffect( winCoins, start ,totalBet, endCallFunc )
	self.footer:setWinCoinsEffect(winCoins, start ,totalBet, endCallFunc)
end

function _baseViewCtl:setFooterWinCoinsEffectByMulti( coins, start, endCallFunc, muti )
	self.footer:setWinCoinsEffectByMuti(coins, start, endCallFunc, muti)
end

function _baseViewCtl:setFooterWinCoins( coins , start, tb )
	self.footer:setWinCoins(coins , start, tb)
end

function _baseViewCtl:resetFooterWinCoins( coins )
	self.footer:reSetWinCoinsString(coins)
end

function _baseViewCtl:addCoinsToHeader()
	if self:noFeatureLeft() then 
		local winCoin = self.totalWin
		local bet = self.saveBet or 10000
		local multiple = bet / 10000
		winCoin =  math.floor(winCoin * multiple)  
		User:getInstance():addCoins(winCoin) 
	end
end

function _baseViewCtl:singleAddWinCoins( winCoins ,onlyAdd)
	-- zhf 暂时注释掉,加钱逻辑
	--local payCoins = self:getCurTotalBet()	
	if self:isInFG() then
		 self.freeCtl:updateFreeWin(winCoins, true)
	-- if self.freewin then
	-- 	self.freewin = self.freewin + winCoins
	elseif self:isFreeSpinTriggered() then
		-- 中free spin的那一把，前端钱先不加给用户
		self.freeCtl:updateScatterWin(winCoins)
		-- self.scatter_spin_winCoins = self.scatter_spin_winCoins or 0
		-- self.scatter_spin_winCoins = self.scatter_spin_winCoins + winCoins
	else
		if not self.saveWin then
			
		end
	end	
end

function _baseViewCtl:isFreeSpinTriggered()
	if self.rets and (self.rets["free_spins"] or self.rets[self.custom_handle_name]) then return true end
	return false
end

function _baseViewCtl:setWinCoins_noHandle( theWinCoins )
	local winCoins 	= theWinCoins
	local payCoins 	= self:getCurTotalBet()
	self.totalWin   = self.totalWin or 0
	self.totalWin   = self.totalWin + winCoins
	self.allrevenue = self.allrevenue + winCoins
	self.allcost 	= self.allcost + payCoins
	self:singleAddWinCoins(winCoins)
end

function _baseViewCtl:free_spins( ret )
	-- self.spinning 		= false
	-- 记录当前stage
	self.stageName = theme_stage_List.free_game
	EventCenter:pushEvent(EVENTNAMES.THEME.IS_IN_FREE)
	
	self.audioCtl:dealMusic_MuteLoopMusic()

	if self.freeCtl then 
		self.freeCtl:free_spins(ret)
	end

	-- self.audioCtl:dealMusic_MuteLoopMusic()
	-- local theSpecials 	= self.specials
	-- local enterType     = "free_spin"
	-- if self.freewin then
	-- 	enterType = "more_free_spin"
	-- end
	-- local enterDelay 	= self:playFreeSpinItemAnimation(theSpecials, enterType) or 0 -- 进入freespin 的延迟时间
	-- ------------------------------------------------------------------------------------	
	-- local spins 		= ret["free_spins"] -- freespin 次数 当前结果中
	-- ret["free_spins"] 	= nil
	-- ------------------------------------------------------------------------------------
	-- self.freespin = self.freespin or 0
	-- self.freespin = self.freespin + spins -- freespin 剩余次数
	-- local more = nil
	-- if not self.freewin then
	-- 	self.sumFreeSpinCnt = 0
	-- 	self.sumFreeSpinCnt = self.sumFreeSpinCnt + spins -- 总共 freespin 的次数
	-- 	self.freewin  = self.totalWin or 0
	-- 	self:changeScreenAwakeState(true)
	-- else
	-- 	self.sumFreeSpinCnt = self.sumFreeSpinCnt + spins
	-- 	more = true
	-- end
	-- ------------------------------------------
	-- local function delayAction()
	-- 	self.isDealFSBegClick = false
	-- 	self.isDealFSBegEnd   = false		
	-- 	local function startClickCallFunc( ) -- 点击按钮的时候 或者 倒计时结束的时候被调用
	-- 		if self.isDealFSBegClick then return end
	-- 		self.isDealFSBegClick = true
	-- 		-- 场景切换
	-- 		if not more then
	-- 			self:setPointBet(self:getCurBet())

	-- 			--commonMusic: 关闭弹出startFreeSpin音效
	-- 			self:dealMusic_StopFSEnterMusic()
	-- 			self:dealMusic_PlayFSEnterClickMusic()
	-- 		else
	-- 			--commonMusic: 关闭弹出moreFreeSpin音效
	-- 			self:dealMusic_StopFSMoreMusic()
	-- 			self:dealMusic_PlayFSMoreClickMusic()
	-- 		end
	-- 	end
	-- 	local function changeLayer()
			
	-- 	end
	-- 	local function endCallFunc( ) -- 弹窗结束的时候被调用
	-- 		if self.isDealFSBegEnd then return end
	-- 		self.isDealFSBegEnd = true	
	-- 		local function startSpin()
	-- 			self:handleResult()
	-- 		end	
	-- 		if more then
	-- 			self:freeStartClicked(startSpin,true)
	-- 		else
				
	-- 			self:showFreeSpinNode(self.freespin, self.sumFreeSpinCnt, not self.freeItem)
	-- 			self:runFreeSpinStage()
	-- 			self:freeStartClicked(startSpin,false)
	-- 		end

	-- 	end
	-- 	if more then
	-- 		local function enterCallFunc( ) -- 显示弹窗的时候被调用
	-- 			self.footer:onEnterFreeSpinDialog()
	-- 			self.footer:setSpinButtonState(true) -- 禁用spin 按钮
	-- 			self:dealMusic_PlayFSMoreMusic()
	-- 		end
	-- 		 -- enter_event 显示弹窗的时候的回调方法 click_event 点击弹窗之后的 回调方法 end_event 关闭弹窗之后的回调方法
	-- 		local theData = {["count"]=spins, ["enter_event"]=enterCallFunc, ["click_event"]=startClickCallFunc, ["end_event"]=endCallFunc, ["theme_info"] = ret["theme_info"],["free_game"] =ret["free_game"] }
	-- 		self:adjustFreeSpinMoreData(theData) -- 目前没有操作
	-- 		self:playMoreFreeSpinDialog(theData) -- 显示 获得 更多 freespin 弹窗
	-- 	else
	-- 		local function enterCallFunc( ) -- 显示弹窗的时候被调用
	-- 			self.footer:onEnterFreeSpinDialog() -- footer 显示 freespin 按钮
	-- 			self.footer:setSpinButtonState(true) -- 禁用spin 按钮
	-- 			--commonMusic: 弹出startFreeSpin
	-- 			self:dealMusic_PlayFSEnterMusic()
	-- 			self:enterFreeSpinStage()
	-- 		end
	-- 		local theData = {["count"]=spins, ["enter_event"]=enterCallFunc, ["click_event"]=startClickCallFunc,["changeLayer_event"]=changeLayer, ["end_event"]=endCallFunc}
	-- 		self.isFirstFreeGame = true
	-- 		self:playStartFreeSpinDialog(theData) -- 显示 获得 freespin 弹窗
	-- 	end
	-- end
	-- self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(enterDelay),cc.CallFunc:create(function()
	-- 	delayAction()
	-- end)))
end

function _baseViewCtl:playRateUs(rateUsData, endCallFunc)	
	if (rateUsData == 1 or self.needShowRateUs) and bole.canDisturbTheme() then
		self.needShowRateUs = false
		PopupController:getInstance():addDialogToPopupFront("rate_us_new", {is_portrait = self.isPortrait}, endCallFunc)
   	end
end

function _baseViewCtl:finish_actions(ret)
	ret["finish_actions"] = nil
	if self.showFinishActions then
		self:showFinishActions()
	end
	self:handleResult()
end

function _baseViewCtl:booster_tips( ret )
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

function _baseViewCtl:spin_end( ret )
	self.spin_processing = false
	self:changeSpinOrFeatureState(false)

	-- self.spin_processing = false
	-- User:getInstance().is_Spining = false
	-- self:changeSpinOrFeatureState(false)

	-- local tBet = self:getCurTotalBet()
	-- local user = User:getInstance()
	-- if user.coins < tBet then
	-- 	if not self:isInFG() and math.mod(user.user_id, 2) == 0 then
	-- 		DialogControl:getInstance():outofcoins(self.isPortrait, tBet, false, {
	-- 			isMinBet = self:checkIsMinBet(),
	-- 			minBet = self:getMinBet(),
	-- 			isHigh = self:getHighRoom(),
	-- 		})
	-- 	end 
	-- end
end

function _baseViewCtl:collectFreeSpin( pEndCallfunc )
	if self.freeCtl then 
		self.freeCtl:collectFreeSpin(pEndCallfunc)
	end

	-- local collectDelay = 1 -- 0.1
	-- local function delayAction()
	-- 	self.isDealFSCollectClick = false
	-- 	self.isDealFSCollectEnd   = false
	-- 	--显示FreeEnd弹窗时候的回掉
	-- 	local function enterCallFunc()
	-- 		self.footer:onEnterFreeSpinDialog() -- 控制 footer 的 按钮不可点击
	-- 		self.footer:setSpinButtonState(true) -- 禁用spin 按钮
	-- 		--commonMusic	
	-- 		self.audioCtl:dealMusic_FadeLoopMusic(0.3, 1, 0.1)
	-- 		self:dealMusic_PlayFSCollectMusic()			
	-- 	end
	-- 	--点击FreeEnd弹窗时候回掉
	-- 	local function collectClick() -- 可以添加音效
	-- 		-- 点击收集的时候向服务器发送收钱的请求,服务器 给用户加钱
	-- 		bole.potp:send(COLLECT_COINS,{type=0},true)--data

	-- 		if self.isDealFSCollectClick then return end 
	-- 		-- self.footer:setSpinButtonState(false) -- 解除禁用 spin 按钮
	-- 		self.isDealFSCollectClick = true
	-- 		--commonMusic
	-- 		self:dealMusic_StopFSCollectMusic()
	-- 		self:dealMusic_PlayFSCollectClickMusic()
	-- 	end
	-- 	local function changeLayer()
	-- 		self:dealMusic_PlayFSCollectEndMusic()
	-- 		if self.isDealFSCollectEnd then return end
	-- 		self.isDealFSCollectEnd = true
	-- 		self.freespin = nil
	-- 		self:removePointBet()
	-- 		self:outFreeSpinStage()
	-- 	end
	-- 	--FreeEnd弹窗消失的回掉
	-- 	local function endCallFunc()
	-- 		local freeWin = self.freewin
	-- 		local function onRollEnd( ... )
	-- 			self.audioCtl:dealMusic_FadeLoopMusic(0.3, 0.1, 1)
	-- 			local user = User:getInstance() 
	-- 			user:addCoins(freeWin)
	-- 			self:playRateUs()
				
	-- 			if pEndCallfunc then
	-- 				pEndCallfunc()
	-- 			end
	-- 			-- 处理freeSpin collect收钱庆祝完成之后，需要有特殊feature的情况
	-- 			-- 例如: 为了给RoyalPuppies 主题的 商店中奖Free情况下 Free庆祝完成之后，重新打开商店
	-- 			if self.collectFreeRollEnd then 
	-- 				self:collectFreeRollEnd() 
	-- 			end
	-- 		end
	-- 		self:dealMusic_PlayNormalLoopMusic()
	-- 		self.audioCtl:dealMusic_SetLoopMusic(0.1)
	-- 		self:laterCallBack(0.5, function ()
	-- 			self.footer:setWinCoinsEffect(freeWin, 0 ,self:getCurBet(), onRollEnd)
	-- 			self.freewin = nil
	-- 		end)
	-- 	end
	-- 	local freeSpinSumCount = self.sumFreeSpinCnt or self.free_spins_cache_cnt
	-- 	local theData = {["coins"] = self.freewin, ["sum_count"]=freeSpinSumCount, ["enter_event"]=enterCallFunc, ["click_event"]=collectClick, ["changeLayer_event"]=changeLayer, ["end_event"]=endCallFunc}
	-- 	self:playCollectFreeSpinDialog(theData) -- 显示 collect freespin的 弹窗
	-- end
	-- self.curScene:runAction(cc.Sequence:create(cc.DelayTime:create(collectDelay),cc.CallFunc:create(function()
	-- 	delayAction()
	-- end)))
end
------------------------------------------------------------------------------------------------------------------------------
-- to_self
------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:getRetMatrix( )
	if self.rets then
		return self.rets["item_list"]
	else
		return nil
	end
end
function _baseViewCtl:getWinPosList( )
	return self.rets["win_pos_list"] or {}
end

function _baseViewCtl:updateCellOtherAssets(cell,colid) -- 更新Symbol上除Sprite以外的Sprite
	if self.storeVCtl then 
		self.storeVCtl:updateCellStoreAssets(cell,colid)
	end
	-- if self.isThemeStoreOpen and #self.resultCoinsCache > 0 then
	-- 	local theCoinKey = table.remove(self.resultCoinsCache[colid],#self.resultCoinsCache[colid])
	-- 	self:_updateCellOtherAssets(cell,theCoinKey,colid)
	-- end
end

function _baseViewCtl:createCellSprite( colid, rowIndex )
	local theCellKey = self:getNextSprite(colid, rowIndex)
	local ret 	 	 = self:_createCellSprite(theCellKey, colid, rowIndex)
	return ret
end

function _baseViewCtl:resetAllCellSpite() -- basegame 进入freegame以后symbol面板更新为free game的假轴
	for colId,reel in pairs(self.mainView:getCurSpinLayer().spins) do

		for k ,v in pairs(reel.cells) do 
			self:updateCellSprite(v,colId,false,nil)
		end		
	end	
end

function _baseViewCtl:updateCellSprite( sprite, colid, isGetResult,cellKey,isReset) -- index_in_spin 是控制滚轴中会显示几个symbol的 stop时 isReset 是强制刷新的标识
	
	if cellKey then
		self:_updateCellSprite(sprite, cellKey, colid,isGetResult,isReset)
		return nil
	end
	local theCellKey = nil
	if isGetResult and self.resultCache[colid] and #self.resultCache[colid]>0 then
		theCellKey = table.remove(self.resultCache[colid], #self.resultCache[colid])
	end
	
	if not theCellKey then
		theCellKey = self:getNextSprite(colid, cellKey)
		theCellKey = self:getUpdateKeyWithIndex(colid,cellKey,theCellKey) or theCellKey
	end
	self:_updateCellSprite(sprite, theCellKey, colid,isGetResult,isReset)

	if isGetResult then
		self:updateCellOtherAssets(sprite,colid)
	end
	
end
function _baseViewCtl:resetBoardCellsSprite( resetItemList )
	resetItemList = resetItemList or {}	
	local _free_ret, _free_special = self.freeCtl:getResumeData()
	-- local _free_special = self.freeCtl:getFreeSpeicalData()

	for col,colItemList in pairs(resetItemList) do
		local theSpinCol = self.mainView:getCurSpinLayer().spins[col]
		if theSpinCol then
			for row,theKey in pairs(colItemList) do
				self:_updateCellSprite(theSpinCol:getRetCell(row), theKey, col, 1,true) -- 第四个 参数 判断 是否 是恢复牌面的
			end
			if _free_ret and _free_ret["item_list_up"] and _free_ret["item_list_up"][col] then
				local key1 = _free_ret["item_list_up"][col][1]
				local key2 = _free_ret["item_list_down"][col][1]
				self:_updateCellSprite(theSpinCol:getRetCell(0), key1, col, nil,true)
				self:_updateCellSprite(theSpinCol:getRetCell(#colItemList+1), key2, col, nil,true)
			end
			self:refreshColCellsZOrder(col)
		end
	end
	-- whj 添加 从freegame 返回 basegame 中奖动画 和 speical 动画重新播放
	if _free_ret and _free_ret["win_pos_list"] and #_free_ret["win_pos_list"]>0 then
		if self.getDrawThemeAnimateSpecialData then -- 需要计算的 特殊配置 例如 合图数据
			self:getDrawThemeAnimateSpecialData(_free_ret,resetItemList)
		end
		if _free_ret["win_ways"] then
			_free_ret["win_pos_list"] = {}
			local tagCRList = {}
			for _, winWayData in ipairs(_free_ret["win_ways"]) do
				local posList = winWayData["win_pos"]
				for _, crPos in ipairs(posList) do
					tagCRList[crPos[1]] = tagCRList[crPos[1]] or {}
					tagCRList[crPos[1]][crPos[2]] = true
				end
			end
			for col, colList in pairs(tagCRList) do
				for row, _ in pairs(colList) do
					table.insert(_free_ret["win_pos_list"], {col, row})
				end
			end
			self.winWays = _free_ret["win_ways"]
			self:drawWaysThemeAnimate(self.winWays, self.mainView:getCurSpinLayer(), _free_ret, _free_special)
		elseif _free_ret["win_lines"] then
			local winls    = _free_ret["win_lines"]
			local winLines = {}
			for i=1, #_free_ret["win_lines"] do
				table.insert(winLines, {winls[i]['line'], winls[i]['count'], winls[i]['symbol'], winls[i]['reverse'],
						 	 col_ck = winls[i]['col_ck'] or 0, play_idx = winls[i]['play_idx']})
			end
			self.winLines = winLines
			self:drawLinesThemeAnimate(self.winLines, self.mainView:getCurSpinLayer(), _free_ret, _free_special)
		end
	end
	if _free_special then
		self:playBackBaseGameSpecialAnimation(_free_special)
	end
	self:cleanTheReelKeyCache()

	-- 开启按钮可点击状态
	self.footer:setSpinButtonState(false)
end

function _baseViewCtl:resetBoardCellsSpriteOverBonus( resetItemList )
	resetItemList = resetItemList or {}	
	for col,colItemList in pairs(resetItemList) do
		local theSpinCol = self.mainView:getCurSpinLayer().spins[col]
		for row,theKey in pairs(colItemList) do
			self:_updateCellSprite(theSpinCol:getRetCell(row), theKey, col, 1,true) -- 第五个 参数 判断 是否 是恢复牌面的
		end
		if self.bonusRet and self.bonusRet["item_list_up"] and self.bonusRet["item_list_up"][col] then
			local key1 = self.bonusRet["item_list_up"][col][1]
			local key2 = self.bonusRet["item_list_down"][col][1]
			self:_updateCellSprite(theSpinCol:getRetCell(0), key1, col, nil,true)
			self:_updateCellSprite(theSpinCol:getRetCell(#colItemList+1), key2, col, nil,true)
		end
		self:refreshColCellsZOrder(col)
	end
	local winType = self:resetWinListFromRespin(self.bonusRet,resetItemList)
	if winType then 
		if winType == "line" then 
			self:drawLinesThemeAnimate(self.winLines, self.mainView:getCurSpinLayer(), self.bonusRet)
		else 
			self:drawWaysThemeAnimate(self.winWays, self.mainView:getCurSpinLayer(), self.bonusRet)
		end
	end
	if self.playBonusItemAnimate then 
		self:playBonusItemAnimate(resetItemList)
	end
	self:cleanTheReelKeyCache()
end

function _baseViewCtl:resetWinListFromRespin(ret,resetItemList)
	if ret and ret["win_pos_list"] and #ret["win_pos_list"]>0 then
		if self.getDrawThemeAnimateSpecialData then -- 需要计算的 特殊配置 例如 合图数据
			self:getDrawThemeAnimateSpecialData(ret,resetItemList)
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

function _baseViewCtl:refreshWithTheItemList( refreshItemList )
	self.winRet = nil
	self.specialSpeed = false
	self.haveSpeedSmybol = false
	self:clearAnimate()
	self:cleanStatus(true)
	if self.refreshSpecialItemList then
		self:refreshSpecialItemList(refreshItemList)
	end
	self:resetBoardCellsSprite(refreshItemList)
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- 滚轴相关
	-- 关于特殊情况进行屏蔽，后续添加相关逻辑
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:cleanTheReelKeyCache( )
	self.caches 	= {}	
	self.theCaches 	= {}
end
function _baseViewCtl:getNextSprite(colid, rowIndex)
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
		self.caches[colid] = self:getFrames(colid)
	end
	local retKey = table.remove(self.caches[colid], 1)
	return retKey
end

function _baseViewCtl:addCurrentReelIndex( colid )
	if not self.theme_reels then
		return
	end
	local symbols = self.currentReels[colid]
	local nextIndex = self.currentReelsIndex[colid]%#symbols + 1
	self.currentReelsIndex[colid] = nextIndex
	return nextIndex
end
function _baseViewCtl:setCurrentReelIndex( colid, target_position )
	if not self.theme_reels then
		return
	end
	local a = self.currentReels[colid]
	self.currentReelsIndex[colid] = (target_position - 1)%#a + 1
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- header,footer
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:setHeader( theHeader )
	if self.header ~= theHeader then
		self.header = theHeader
	end
end
function _baseViewCtl:getHeader( )
	return self.header
end
function _baseViewCtl:setFooter(f)
	if self.footer ~= f then
		self.footer = f
	end
end
function _baseViewCtl:getFooter( )
	return self.footer
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- jackpot相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:showJackpotBetDialog( data, endCallFunc )
	local dialog = JackpotBetDialog.new(self, data, self.jackpot_target)
	if dialog then dialog:show() end
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-- bonus_game相关
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:open_old_bonus_game(bonus_data, endCallFunc )
	local function callback()
		if endCallFunc then
			endCallFunc()
		end
	end

	local b = BonusNewControl.new(self, callback)
	b:tryResumeBonusGame(bonus_data)
end

-----------------------------后端收钱-----------------------
function _baseViewCtl:collectCoins(collect_type,special_data)
	special_data = special_data or {}
	special_data.type = collect_type
	bole.potp:send(COLLECT_COINS,special_data,true)
end

-- function _baseViewCtl:themeBuySpecial(special_data)
-- 	special_data = special_data or {}
-- 	bole.potp:send({THEME_MAP,special_data})
-- end

--添加选择界面协议，譬如200进主题选择
function _baseViewCtl:themeSelectSpecial(special_data)
	special_data = special_data or {}
	bole.potp:send({THEME_PICK,special_data})
end

function _baseViewCtl:themeStorePurchase(special_data)
	special_data = special_data or {}
	bole.potp:send({THEME_STORE,special_data})
end

function _baseViewCtl:themeStoreCollect(collect_type,special_data)
	special_data = special_data or {}
	special_data.type = collect_type
	bole.potp:send({COLLECT_THEME_STORE,special_data})
end
function _baseViewCtl:themeTourRanking(special_data)
    special_data = special_data or {}
    bole.potp:send({ GET_TOUR_RANKING_INFO, special_data })
end

-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:onHeaderLevelUp( upLevel )
	self.betControl:adjustWithUserLevelUp(upLevel)
end
function _baseViewCtl:getUserLevel( )
	local user = User:getInstance()
	return user.level or 0
end
function _baseViewCtl:getCurTotalBetMul( )
	return self.payline+self.featureMul
end
function _baseViewCtl:getBaseBet( )
	return self.baseBet
end
function _baseViewCtl:getCurBet( )
	return self.betControl:getCurBet()
end
function _baseViewCtl:getCurTotalBet( )
	return self:getCurBet()
end
function _baseViewCtl:getMaxBet()
	return self.betControl:getMaxBet()
end
function _baseViewCtl:setCurBet( theBet )
	return self.betControl:setCurBet( theBet )
end
function _baseViewCtl:getMinBet()
	return self.betControl:getMinBet()
end
function _baseViewCtl:getBetList()
	return self.betControl:getBetList()
end
function _baseViewCtl:checkIsMaxBet( )
	return self.betControl:checkIsMaxBet()
end
function _baseViewCtl:checkIsMinBet( )
	return self.betControl:checkIsMinBet()
end
function _baseViewCtl:checkIsSingleBet( )
	return self.betControl:checkIsSingleBet()
end
function _baseViewCtl:changeToUpBet( )
	if self.betControl then
		return self.betControl:changeToUpBet()
	else
		bole.send_codeInfo(Splunk_Type.Error,{error = "empty", msg="changeToUpBet betControl is nil"})
	end
end
function _baseViewCtl:changeToDownBet( )
	if self.betControl then
		return self.betControl:changeToDownBet()
	else
		bole.send_codeInfo(Splunk_Type.Error,{error = "empty", msg="changeToDownBet betControl is nil"})
	end
end
function _baseViewCtl:changeToMaxBet( )
	return self.betControl:setMaxBet()
end
function _baseViewCtl:setPointBet( thePointBet )
	return self.betControl:setPointBet(thePointBet)
end
function _baseViewCtl:removePointBet( )
	return self.betControl:removePointBet()
end
function _baseViewCtl:changeCurBet( theBet )
	return self.betControl:setCurBet(theBet)
end
function _baseViewCtl:adjustThemeBet( theBet, isPointBet )
	-- footer相关
	if not isPointBet then
		if self:checkIsMaxBet() then
			self.footer:setMaxBetState(true)
			self.footer:setMaxBetBtnEnable(false)
		else
			self.footer:setMaxBetState(false)
			self.footer:setMaxBetBtnEnable(true)
		end
		self.footer:setSubAndAddBetBtnEnable(true)
	end

	-- 更新jackpot
	if self.updateJackpotByBet then self:updateJackpotByBet(theBet) end

	-- 更新footer bet值
	local free_spin_cnt = self.freeCtl and self.freeCtl:getFGCnt()
	self.footer:setBetInfo(theBet, self:getCurTotalBetMul(),theBet,(free_spin_cnt and free_spin_cnt>=0)) --theBet, self:getCurTotalBetMul()

	-- 更新系统活动
	if SystemController then
		SystemController:getInstance():updateBet(theBet, self:getBaseBet())
	end
	 

	-- header上的coins出现红色警报
	-- self.header:loseCoinsReminder(theBet)

	-- 同步调整bet关联内容
	self:adjustWithBetChange(theBet, isPointBet)
end

function _baseViewCtl:adjustWithBetChange( theBet, isPointBet )
	self:dealAboutBetChange(theBet, isPointBet)

	local data = { ["bet"] = theBet, ["isPointBet"] = isPointBet}
	EventCenter:pushEvent(EVENTNAMES.THEME.CHANGE_BET, data)
end

function _baseViewCtl:registerCmd( cmd ) -- 注册相关事件回调
	bole.potp:registerCmd(cmd, self.oncmd, self)
end

function _baseViewCtl:getCmds( ) -- THEME_MAP, 
	return {BATCH_SPIN, COLLECT_COINS,THEME_STORE, THEME_PICK, COLLECT_THEME_STORE}
end

function _baseViewCtl:initPotpCmd() -- 服务器命令初始化 进行实践注册
	local cmds = self:getCmds()
	for _,c in pairs(cmds) do
		self:registerCmd(c)
	end
end

function _baseViewCtl:unregisterPotpCmds()
	local cmds = self:getCmds()
	for _,c in pairs(cmds) do
		bole.potp:unregisterCmd(c)
	end
end

function _baseViewCtl:setBatchSpinTime()
	self.batchSpinTime = os.time()
end

function _baseViewCtl:getBatchSpinTime()
	return self.batchSpinTime or -1
end

function _baseViewCtl:setRequestStatus(status)
	self.canRequestStatus = status
end

function _baseViewCtl:getRequestStatus()
	return self.canRequestStatus
end

function _baseViewCtl:oncmd(cmd, data) -- 回调方法
	if not self:getRequestStatus() then 
		return
	end
	if cmd == BATCH_SPIN then
		if not self.spinRequestTime then
			return
		end
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
			if self.clearChooseBouns then
				self:clearChooseBouns()
			end
		end

		-- get server call for receiving bonus collect coins
		if data["receive_value"] == 1 then
			if self.clearNeedCollectCoinsBonus then
				self:clearNeedCollectCoinsBonus()
			end
		end

		-- use for need bonus data from server to play game
		if data["receive_data"] then
			if self.continueNextBouns then
				self:continueNextBouns(data["receive_data"])
			end
		end

		if data["collect_back_info"] then
			if self.onGetCollectCoinsReceiveData then
			   self:onGetCollectCoinsReceiveData(data["collect_back_info"])
			end
		end
		
		-- self:playRateUs(data["rate_us"])
		if data.type == 1 or data.type == 2 then  -- 1 代表 bonus
			LoginControl:getInstance():saveBonus(self.themeid, nil)
			if self.freeCtl and self.freeCtl.clearPickData then -- whj 主题 用来删除收集jackpot的Free 时候清除掉 pick本地保存的数据
				self.freeCtl:clearPickData()
			end
		elseif data.type ==0 then  -- 0 代表 freespin
			if self.freeCtl and self.freeCtl.clearFreeData then 
				self.freeCtl:clearFreeData()
			end
		elseif data.type ==3 then -- 游戏中特殊的收集 例如：RoyalPuppies 主题里面收集 pickgame
			if self.collectSpeicalGame then 
				self:collectSpeicalGame()
			end
		end
	-- elseif cmd == THEME_MAP then 
	-- 	if self.overBuySpecialItem then self:overBuySpecialItem(data) end
	elseif cmd == THEME_PICK then 
		if self.getThemeSelectSpecial then self:getThemeSelectSpecial(data) end
	elseif cmd == THEME_STORE then
		self:showStoreBuyDialog(data)
    elseif cmd == GET_TOUR_INFO then
		if self.showThemeTourInfo then self:showThemeTourInfo(data) end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------
-- other
-----------------------------------------------------------------------------------------------------------------------------------------------
function _baseViewCtl:out_of_coins(  )
    self:enableAuto(false)
	self.footer:enableOtherBtns(true)
    local showType 	= "_outOfCoins"
    local user 		= User:getInstance()
    local temp_hasBeenOutOfCoins = self.hasBeenOutOfCoins
    -- local callfunc 		= function()		
	local total_bet = self:getCurTotalBet()
	-- DialogControl:getInstance():outofcoins(self.isPortrait,total_bet, temp_hasBeenOutOfCoins, {
	-- 	isMinBet = self:checkIsMinBet(),
	-- 	minBet = self:getMinBet(),
	-- 	isHigh = self:getHighRoom(),
	-- })
    -- end
    -- OutofcoinsView.new():show(callfunc)

	PopupController:getInstance():popupDialogDirectly("freecoins")
    local c = cc.UserDefault:getInstance():getIntegerForKey("out_of_coins_count", 0)
    cc.UserDefault:getInstance():setIntegerForKey("out_of_coins_count", c + 1)
    self.hasBeenOutOfCoins = true
	self.outOfCoinsShowing = true
end

function _baseViewCtl:clearAnimate()
	self.mainView:clearAnimate()
end

function _baseViewCtl:saveThemeInfo(themeid ,coins)
	cc.UserDefault:getInstance():setFloatForKey("themeid", themeid)
end

function _baseViewCtl:showStoreBuyDialog(data)
	local dialog
	local _gameStoreVersion = self.game_store_version and self.game_store_version or 1
	if _gameStoreVersion == GameStoreType.PUZZLE_II_V then
		dialog = PopupController:getInstance():getDialog("theme_store_game2")
	elseif _gameStoreVersion == GameStoreType.PUZZLE_I_V then
		dialog = PopupController:getInstance():getDialog("theme_store_game")
	elseif _gameStoreVersion == GameStoreType.PUZZLE_II_H then
		dialog = PopupController:getInstance():getDialog("theme_store_game2horizon")	
	end
	if dialog then
		dialog:showBuyResult(data)
	end
end

function _baseViewCtl:cleanAnimateList( )
	self.animatesList = self.animatesList or {}
	for k,node in pairs(self.animatesList) do
		if not node.isRetain then
			node:removeFromParent()
		end
	end
	-- isRetain的节点必须自行删除，因为此表不进行缓冲
	self.animatesList = {}
end

function _baseViewCtl:closeblackFloor()
end

function _baseViewCtl:adjustThemeConfig( data )
	return data
end

function _baseViewCtl:getThemeConfig()
end

function _baseViewCtl:enterThemeByFreespin( callFunc, data )
	self.freeSpinInFunc = callFunc
end

function _baseViewCtl:updateFreeBack( ... )
	return nil
end

function _baseViewCtl:asHintTime( pCol )
end

function _baseViewCtl:addAnimateNode( ... )
	self.animatesList = self.animatesList or {}
	local retNode = cc.Node:create()
	table.insert(self.animatesList, retNode)
	return retNode
end

---@param enable /true:可点击/false:不可点击
function _baseViewCtl:setFooterBtnsEnable(enable)
    self.footer:setSpinButtonState(not enable) -- 禁用spin 按钮
    self.footer:enableOtherBtns(enable) -- 禁用spin 按钮
end

function _baseViewCtl:getActivesNodeBasePos()
	
end

function _baseViewCtl:hideActivitysNode()
	EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION)
end

function _baseViewCtl:showActivitysNode()
	EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_SHOW_ACTION)
end

function _baseViewCtl:setFooterShowTotalBetLayout(isShow, notShowLoungeTip)
	self.footer:isShowTotalBetLayout(isShow, notShowLoungeTip)
end

function _baseViewCtl:hideBoosterDimmer()
    if self.footer then
        self.footer:hideBoosterDimmer()
    end
end

function _baseViewCtl:dialogPlayLineAnim(state, dimmer, root, animData)
    if self.mainView then
        self.mainView:dialogPlayLineAnim(state, dimmer, root, animData)
    end
end

function _baseViewCtl:playNodeShowAction(node, actionData)
    if self.mainView then
        self.mainView:playNodeShowAction(node, actionData)
    end
end

--------------- 重置牌面相关 --------
function _baseViewCtl:resetBoardCellsByItemList(_itemList)
	self.mainView:resetBoardCellsByItemList(_itemList)
end

function _baseViewCtl:resetBoardCellsByCreateList(_itemList)
	self.mainView:resetBoardCellsByCreateList(_itemList)
end

function _baseViewCtl:resetBoardCellsByNormal(notItemListSet)
	self.mainView:resetBoardCellsByNormal(notItemListSet)
end

function _baseViewCtl:updateCellShowByKey( col, row, key, hideCell)
	self.mainView:updateCellShowByKey( col, row, key, hideCell)
	
end

----------------------------------------- for old data ------------------------------------------------------------------

function _baseViewCtl:dealMusic_FadeLoopMusic( duration, beginVolume, endVolume, delay )
	self.audioCtl:dealMusic_FadeLoopMusic(duration, beginVolume, endVolume)
end
function _baseViewCtl:dealMusic_SetLoopMusic( volume )
	self.audioCtl:dealMusic_SetLoopMusic(volume)
end

-- add new 2020.12.1
---@param theData /info
---@param sType /1:start 2:more 3:collect
---@param dialogType /1:free 2:jp 3:map/wheel,pick
---@param parent
function _baseViewCtl:showThemeDialog(theData, sType, dialogType, parent)
    local click_event = theData.click_event
    theData.click_event = function()
        if click_event then
            click_event()
        end
        
        if sType == d_show_type.start or sType == d_show_type.collect then
            self:playMusicByName("common_click")
        end

        self:setDialogDimmerState(dialogType, sType, false)
    end

    local config = {}
    config["csb_file"] = self:getCsbPath(dialogType)
    local _frame_config = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 3, nil, 2 },
        ["collect"] = { nil, 1, nil, 2 },
    }
    config["frame_config"] = self.gameConfig.dialog_config[dialogType]["frame_config"] or _frame_config
    config.dialog_config = self.gameConfig.dialog_config[dialogType][sType]
    local theDialog = ThemeBaseDialog.new(self.ctl, config)
    if sType == d_show_type.start then
        theDialog:showStart(theData, nil, parent)
    elseif sType == d_show_type.more then
        theDialog:showMore(theData, nil, parent)
    elseif sType == d_show_type.collect then
        theDialog:showCollect(theData, nil, parent)
    end

    self:setDialogDimmerState(dialogType, sType, true)
    return theDialog
end

function _baseViewCtl:setDialogDimmerState( dialogType, sType, isShow )
	
end

function _baseViewCtl:getSpineFile(file_name, notPathSpine)
    local path2 = self.gameConfig.spine_path[file_name]
    local path
    if path2 then
    	if notPathSpine then 
        	path = string.format("theme_resource/theme%d/%s", self.themeResourceId, path2)
    	else
    		path = string.format("theme_resource/theme%d/spine/%s", self.themeResourceId, path2)
    	end
    end

    return path
end
function _baseViewCtl:playMusicByOnce(file_name)
    local path2 = self.audio_list[file_name]
    self.audioCtl:playEffectWithInterval(path2)
end
function _baseViewCtl:getFntFilePath(file_name)
	local path2 = file_name
	local path
	if self.gameConfig.fnt_list and self.gameConfig.fnt_list[file_name] then 
		path2 = self.gameConfig.fnt_list[file_name]
		string.format("theme_resource/theme%d/%s", self.themeResourceId, path2)
	else
		path = string.format("theme_resource/theme%d/font/%s", self.themeResourceId, path2)
	end

    return path
end
function _baseViewCtl:getParticleFile(file_name)
    local path2 = self.gameConfig.particle_path[file_name]
    local path = string.format("theme_resource/theme%d/particle/%s", self.themeResourceId, path2)
    return path
end
function _baseViewCtl:getCsbPath(file_name)
    local path2 = self.gameConfig.csb_list[file_name]
    local path = string.format("theme_resource/theme%d/%s", self.themeResourceId, path2)
    return path
end

-- footer
function _baseViewCtl:getFooterWinWordPos()
    return self.footer:getWinWordPos()
end

function _baseViewCtl:getFooterNodesPos(nType)
	if nType == "win" then 
		return self.footer:getWinWordPos()
	elseif nType == "free_count" then 
		return self.footer:getFSCntWordPos()
	end
    
end

function _baseViewCtl:footerCopySpinBtnEvent( ... )
	if not G_THEME_FAST_TAG then 
		self.footer:copySpinBtnEvent()
	end
end

function _baseViewCtl:changeRespinLayerState(state)
	self.footer:changeRespinLayerState(state)
end

-----
function _baseViewCtl:resetSpinProcess()
	if self.freeCtl then 
		local _free_spin_cnt = self.freeCtl:getFGCnt()
		if _free_spin_cnt and _free_spin_cnt < 1 then
	        self.spin_processing = true
	    end
	end
end

function _baseViewCtl:getPayMulti()
	return self.gameConfig.pay_muti
end

-- function _baseViewCtl:getFooterFreeCntPos()
--     return self.footer:getrFreeCntPos()
-- end

-- 活动相关
function _baseViewCtl:isMasterTheme(themeid)
	if self:getGoldSpinStatus() then
		return false
	end
	if ActivityCenterControl then
		return ActivityCenterControl:getInstance():isMasterTheme(themeid)
	end
 
end