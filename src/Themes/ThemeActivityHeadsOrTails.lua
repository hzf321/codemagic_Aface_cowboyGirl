
--ThemeActivityHeadsOrTails.lua
--Author:wangyi
--2019年06月07日
--Using:activity game  

local parentClass = Theme
ThemeActivityHeadsOrTails = class("ThemeActivityHeadsOrTails", parentClass)

local customizedTheme = ThemeActivityHeadsOrTails

customizedTheme.plistAnimate = 
{
	"images/plist/symbols",
}

customizedTheme.csbList = 
{
	"csb/base.csb",
}


function customizedTheme:ctor(themeid)
  	self.spinActionConfig = {
		["start_index"] = 10,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	}
	self.ThemeConfig = {
	["theme_symbol_coinfig"]    = {
		["symbol_zorder_list"]  = {
             
		},
		["normal_symbol_list"]  = {
		   3
		},
		["special_symbol_list"] = {
			--specialSymbol["fg_trigger"]
		},
		["special_symbol_config"] = {
		},
	},
	["theme_type"] = "payLine",
	["theme_type_config"] = {
		["pay_lines"] = {
			{0,0,0,0,0},{0,1,1,1,0},{0,1,1,1,2},{0,1,2,1,0},{0,1,0,1,0},{0,0,1,0,0},{0,0,1,2,2},{0,0,0,1,2},
			{0,1,2,2,2},{1,1,1,1,1},{1,0,0,0,1},{1,0,1,0,1},{1,1,0,1,1},{1,1,2,1,1},{1,2,1,2,1},{1,2,2,2,1},
			{1,2,3,2,1},{1,1,2,3,3},{1,2,1,0,1},{1,2,2,2,3},{1,0,1,2,1},{1,2,3,3,3},{1,1,1,2,3},{1,0,1,2,3},
			{1,0,0,1,1},{2,2,2,2,2},{2,3,3,3,2},{2,3,2,3,2},{2,2,3,2,2},{2,2,1,2,2},{2,1,2,1,2},{2,1,1,1,2},
			{2,1,0,1,2},{2,2,1,0,0},{2,1,2,3,2},{2,1,1,1,0},{2,3,2,1,2},{2,1,0,0,0},{2,2,2,1,0},{2,2,2,1,0},
			{2,3,3,2,2},{3,3,3,3,3},{3,2,2,2,3},{3,2,2,2,1},{3,2,1,2,3},{3,2,3,2,3},{3,3,2,3,3},{3,3,2,1,1},
			{3,3,3,2,1},{3,2,1,1,1},
			
		},
		["line_cnt"] = 50,
	},
	["theme_round_light_index"] = 1,
	["boardConfig"] = {
		{
			["allow_over_range"] = true, --index1
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(161,105),
					["cellWidth"] = 151,
					["cellHeight"] = 102.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(317,105),
					["cellWidth"] = 151,
					["cellHeight"] = 102.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(471,105),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 151,
					["cellHeight"] = 102.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(625.5,105),
					["cellWidth"] = 151,
					["cellHeight"] = 102.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(782.5,105),
					["cellWidth"] = 151,
					["cellHeight"] = 102.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(978,98),
					["cellWidth"] = 158,
					["cellHeight"] = 150,
					["symbolCount"] = 3,
					["countHeight"] = 168,
					["countSymbolCount"] = 3,
					["count_base_pos"] = cc.p(978,98),
				},
			}
		}
	}
    }

	self.baseBet = 10000
	self.DelayStopTime = 0
	self.UnderPressure = 1
    local use_portrait_screen = false
	local ret = parentClass.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 104
local delay = 0
local upBounce = 0 --G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -40*60
local normalSpeed = -30*60
local fastSpeed = -40*60 - 300
local stopDelay = 30/60
local speedDownTime = 40/60
local downBounce = G_cellHeight*2/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 21/60
local specialAniTime = 60/60 
local extraReelTime = 120/60
local spinMinCD = 0.5

function customizedTheme:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	self.boardConfigList = self.ThemeConfig["boardConfig"]
	return self.boardConfigList
end

function customizedTheme:getSpinColStartAction( pCol, reelCol)
	if self.isTurbo then
		maxSpeed = fastSpeed
	else 
		maxSpeed = normalSpeed
	end
	local spinAction = {}
	spinAction.delay = delay*(pCol-1)
	spinAction.upBounce = upBounce
	spinAction.upBounceMaxSpeed = upBounceMaxSpeed
	spinAction.upBounceTime = upBounceTime
	spinAction.speedUpTime = speedUpTime
	spinAction.maxSpeed = maxSpeed
	
	return spinAction
end

-- 配置场景
function customizedTheme:initScene(spinNode)
    self.csb = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(self.csb)
	bole.adaptScale(self.mainThemeScene,false)
	self.reelRoot = self.mainThemeScene:getChildByName("Node_root_node")
	
	self.base_bgRoot = self.mainThemeScene:getChildByName("background_base")
	self.boardRoot = self.reelRoot:getChildByName("board_root")

	self.animateNode = self.reelRoot:getChildByName("Node_animated")
	self.shakyNode:addChild(self.mainThemeScene)

    ---BonusGame相关
    self.bonusNode = self.mainThemeScene:getChildByName("bonus_node")

end

--------------------------spin board 功能相关-------------------------------

function customizedTheme:initSpinLayer( )
	self.spinLayerList = {}
	for index,cofig in ipairs(self.boardNodeList) do
		self.initBoardIndex = index
		local boardNode = self.boardNodeList[index]
		local layer = SpinLayer.new(self, self.ctl,boardNode.reelConfig,boardNode)
		layer:DeActive()
		self.shakyNode:addChild(layer,-1)
		table.insert(self.spinLayerList,layer)
	end
	self.initBoardIndex = nil
	self.spinLayer = self.spinLayerList[1]
	self.spinLayer:Active()
	self.ctl.footer:changeNormalLayout()
end


--------------------------Bonus Game 功能相关-------------------------------

ActivityHeadsOrTailsBonusGame = class("ActivityHeadsOrTailsBonusGame", CCSNode)
local BSGame = ActivityHeadsOrTailsBonusGame

local coinPosList = 
{
	cc.p(-313.34,52.03), cc.p(-238.77,-35.75), cc.p(-163.72,53.05), cc.p(-86.21,-32.8), cc.p(80.35,-32.07), 
	cc.p(162.27,51.86), cc.p(249.25,-33.25), cc.p(162.38,-120.57), cc.p(-158.32,-120.6), cc.p(-5.49,51.85), 
	cc.p(74.48,139.18), cc.p(-235.83,140.36), cc.p(2.04,-120.12), cc.p(-87.83,135.36), cc.p(245.17,140.36), 
}

local mulList = {1,2,3,4,5,6,7,8,88,888}

local flyToMulPosList = {cc.p(-567,-229), cc.p(-567,-178),cc.p(-567,-125),cc.p(-567,-74),cc.p(-567,-24),cc.p(-567,28),cc.p(-567,80),cc.p(-567,133),cc.p(-567,185),cc.p(-567,245),}

local coinStateType = {
    TailToTail = 1,
    TailToHead = 2,
    HeadToHead = 3,
    HeadToTail = 4,
    HeadRemove = 5,
    TailRemove = 6,
	HeadIdle   = 7,
	TailIdle   = 8,
	HeadStatic = 9,
	TailStatic = 10
}

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.csb            = csbPath.."bonus.csb"
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl
	self.bonusType = 0

	CCSNode.ctor(self, self.csb)
	
	self.processList = tool.tableClone(self.data.core_data["respin_list"])
	self.curBet = self.data.core_data["bet"]
	self.triggerCount = self.data.core_data["respin_count"]
	self.bonusWin = self.data.core_data["win_resp"]

	--print("wy_bonusData","processList= ",tool.lua_to_json(self.processList),"curBet= ",self.curBet,"triggerCount= ",self.triggerCount,"bonusWin= ",self.bonusWin)
	self.processCounts = #self.processList - 1

	self.jpWinList = self.data.core_data["jp_win"]

	self.data.orientationList = self.data.orientationList or {}
	self.data.executeList = self.data.executeList or {}


	self.data.initSideList = self.data.initSideList or {}
	self.data.finishExecuteIndexList = self.data.finishExecuteIndexList or {}
	
	if #self.data.executeList == 0 then
		self.data.executeList = self:craeteUseList(self.triggerCount)
		self.data.executeList = self:disorganizeList(self.data.executeList)
	end
		
	self.data.chooseIndex = self.data.chooseIndex or 0
	self.data.mulWinCountList = self.data.mulWinCountList or {}
	self.data.resultList = self.data.resultList or {}

	self.data.finishCounts = self.data.finishCounts or 0
	self.data.isStartBoard = self.data.isStartBoard or false

	self:saveBonus()

    self.coinsNodeList = {}
    self.allMul = 0

    -- print save Data
    -- print("wy_chooseIndex",tool.lua_to_json(self.data.chooseIndex))
    -- print("wy_executeList",tool.lua_to_json(self.data.executeList))
    -- print("wy_orientationList",tool.lua_to_json(self.data.orientationList))
    -- print("wy_mulWinCountList",tool.lua_to_json(self.data.mulWinCountList))
    -- print("wy_finishExecuteIndexList",tool.lua_to_json(self.data.finishExecuteIndexList))
    -- print("wy_finishCounts",self.data.finishCounts)

    self:initLayout()

end

function BSGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:initLayout()
	self.node:setVisible(false)
	local mulFrameNode = self.node:getChildByName("mul_frame_node")
	local dimNode = mulFrameNode:getChildByName("gray_node")
	self.dimImageList = {}
	self.mulFramePosList = {}

	local mulLabelNode = mulFrameNode:getChildByName("mul_label_node")
	self.mulLabelList = {}

	local countLabelNode = mulFrameNode:getChildByName("counts_label_node")
	self.countLabelList = {}

	self.mulFrameAniNode = mulFrameNode:getChildByName("frame_ani_node")
	self.mulFrameAniNode:removeAllChildren()
	self.mulFrameAniNodeList = {}

	for i = 1,10 do
		self.dimImageList[i] = dimNode:getChildByName(i)
		self.dimImageList[i]:setVisible(false)
		self.mulFramePosList[i] = cc.p(self.dimImageList[i]:getPosition())
		self.mulLabelList[i] = mulLabelNode:getChildByName(i)
		local mul = mulList[i]
		self.mulLabelList[i]:setString("X"..mul)
		self.countLabelList[i] = countLabelNode:getChildByName(i)
		self.countLabelList[i]:setString("")
		self.mulFrameAniNodeList[i] = cc.Node:create()
		self.mulFrameAniNodeList[i]:setPosition(cc.p(0,0))
		self.mulFrameAniNode:addChild(self.mulFrameAniNodeList[i])
	end

	self.crownLevel1 = mulFrameNode:getChildByName("crown_node1")
	self.crownLevel1:removeAllChildren()
	self.crownLevel2 = mulFrameNode:getChildByName("crown_node2")
	self.crownLevel2:removeAllChildren()
	self.curLevelMulAniNode = mulFrameNode:getChildByName("cur_mul_ani_node")
	self.curLevelMulAniNode:removeAllChildren()

	self.winFrameNode = self.node:getChildByName("win_frame_node")
	self.winFrameNode:setScale(0.7)
	self.winFrameNode:setPosition(cc.p(-2.5, 275))
	self.labelWin = self.winFrameNode:getChildByName("label_win")
	inherit(self.labelWin, LabelNumRoll)
	local function fontFormat(num)
		return FONTS.formatByCount2(num, 14, true)
	end
	self.labelWin:nrInit(0, 25, fontFormat)
	self.labelWin:setString(FONTS.formatByCount2(self.curBet, 14, true))
	self.textStart = self.winFrameNode:getChildByName("text1")
	self.textTotalWin = self.winFrameNode:getChildByName("text2")
	self.textTotalWin:setVisible(false)
	self.textAniNode = self.winFrameNode:getChildByName("text_ani_node")
	self.labelMul = self.winFrameNode:getChildByName("label_mul")
	self.labelMul:setVisible(false)
	self.winFrameBoardAniNode = self.winFrameNode:getChildByName("ani_node")

	self.coinNode = self.node:getChildByName("coins_node")
	self.coinNode:removeAllChildren()

	self.coinFlyNode = self.node:getChildByName("coin_fly_node")
	self.coinFlyNode:removeAllChildren()

	self.btnNode = self.node:getChildByName("btn_node")
	self.btnHeads = self.btnNode:getChildByName("btn_head")
	self.btnTails = self.btnNode:getChildByName("btn_tail")
	self.headBtnAniNode = self.btnNode:getChildByName("head_ani_node")
	self.tailBtnAniNode = self.btnNode:getChildByName("tail_ani_node")

    self.characterNode = self.node:getChildByName("character_node")

    self.fullScreenAniNode = self.node:getChildByName("full_screen_ani_node")
    self.fullScreenAniNode:removeAllChildren()

    self.dimmerNode = self.node:getChildByName("dimmer_node")
    self.dimmerNode:setVisible(false)

    self.triggerNode = self.node:getChildByName("trigger_node")
    self.triggerBoardAniNode = self.triggerNode:getChildByName("ani_node")
    self.triggerNode:setVisible(false)
    self.btnStart = self.triggerNode:getChildByName("btn_start")
    
    self.collectNode = self.node:getChildByName("collect_node")
    self.collectNode:setVisible(false)
    self.collectBoardAniNode1 = self.collectNode:getChildByName("ani_node1")
    self.collectBoardAniNode2 = self.collectNode:getChildByName("ani_node2")
    self.label_bonusCollectWin = self.collectNode:getChildByName("label_win")
    self.btnCollect = self.collectNode:getChildByName("btn_collect")

    self.goddnessBg = self.node:getChildByName("goddness_bg")
    self.goddnessBg:setOpacity(0)
    self.goddnessBg:setVisible(false)

    self.isClick = false


end

function BSGame:enterBonusGame(tryResume)
	self.theme.bonusNode:addChild(self)
	-- 禁掉spin按钮
	self.theme.ctl.footer:setSpinButtonState(true)
	self.theme.ctl.footer:isShowTotalBetLayout(false)

	if tryResume then
		--self.theme.ctl.isProcessing = true
		self.callback = function ( ... )
	
			if (self.theme.ctl.enterThemeDealList and bole.getTableCount(self.theme.ctl.enterThemeDealList) > 0) then 
   				self.theme.ctl.footer:setSpinButtonState(true)
   			end
			self.endCallBack()
			self.theme.ctl.isProcessing = false 
        end

	end

	local function playIntro()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				-- 隐藏B级活动栏
				EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION)			
				self.node:setVisible(true)
				self:showCrownsIdleAnimation()
				self:showStartBoard()
				self:showCharacterIdleAnimation("static")
				self:createCoins()
				self.theme:dealMusic_PlayBonusLoopMusic()
			end)
		))
	end


	local function snapIntro()
		self.node:setVisible(true)
		self:showCrownsIdleAnimation()
		-- 隐藏B级活动栏
		EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION)

		local function recoverFinishChoose()
			self:createCoins()
			self:setMulFrameResultCounts()
			self:setMulFrameState()
			self:finishChoosed()
			self:showCharacterIdleAnimation("static")
		end

		local function recoverChooseProcess()
			self.theme:dealMusic_PlayBonusLoopMusic()
			self:createCoins()
			self:setMulFrameResultCounts()
			self:setMulFrameState()
			self:makeBtnsEnable(true)
			--print("wy_recoverChooseProcess",self.data.chooseIndex)
			self:showFrameMulCurrentStateAnimation(self.data.chooseIndex+1)
			self:showCharacterIdleAnimation("animation")
		end
		if self.data.chooseIndex == self.processCounts then
			recoverFinishChoose()
		else
			recoverChooseProcess()
		end
	end

	if self.data.isStartBoard then
	    snapIntro()
	else
		-- LoginControl:getInstance():saveBonus(self.theme.themeid, nil)
		-- self:initStorageData()
		playIntro()
	end
end

function BSGame:craeteUseList(count)
	local list = {}
	self.data.finishExecuteIndexList = {}
	for i = 1, count do
		list[i] = i
		self.data.finishExecuteIndexList[i] = false
		self.data.initSideList[i] = false
	end

	return list
end

function BSGame:disorganizeList(list)
	if not list or #list == 0 then return end
	local len = #list

	for i = 1,len do
		local random = math.random(1,len)
		local cur = list[i]
		list[i] = list[random]
		list[random] = cur
	end

	return list
end

function BSGame:initStorageData()
	self.data.orientationList = self.data.orientationList or {}
	self.data.executeList = self.data.executeList or {}


	self.data.initSideList = self.data.initSideList or {}
	self.data.finishExecuteIndexList = self.data.finishExecuteIndexList or {}
	
	if #self.data.executeList == 0 then
		self.data.executeList = self:craeteUseList(self.triggerCount)
		self.data.executeList = self:disorganizeList(self.data.executeList)
	end
		
	self.data.chooseIndex = self.data.chooseIndex or 0
	self.data.mulWinCountList = self.data.mulWinCountList or {}
	self.data.resultList = self.data.resultList or {}

	self.data.finishCounts = self.data.finishCounts or 0
	self.data.isStartBoard = self.data.isStartBoard or false

	self:saveBonus()
end

function BSGame:showStartBoard()
	self.triggerNode:setScale(1)
	self.triggerNode:setVisible(true)
	self.dimmerNode:setOpacity(255)
	self.dimmerNode:setVisible(true)
	self:showBoardAnimation(self.triggerBoardAniNode,nil,1)
	self:showBoardBtnAnimation(self.btnStart)
	self.btnStart:setTouchEnabled(true)
	self.btnStart:setBright(true)
	self.data.isStartBoard = true
	self:saveBonus()
	self:initStartEvent()
end

function BSGame:initStartEvent()
	self.isStartClick = false
	-- 点击按钮
	local clickFunc = function(obj)
    	-- 播放点击音乐
    	self.isStartClick = true
    	self.theme:playMusic(self.theme.audio_list.btn_click)
    	self.btnStart:removeAllChildren()
    	self.btnStart:setBright(false)

    	self:runAction(cc.Sequence:create(
    		cc.CallFunc:create(function( ... )
    			self.triggerNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1,1.5,1.5),
					cc.ScaleTo:create(0.2,0,0)	
				))
				self.theme:playMusic(self.theme.audio_list.popup_out)
		        self.dimmerNode:runAction(cc.FadeOut:create(0.3))
		        self:showCharacterIdleAnimation("animation")
    		end),
    		cc.DelayTime:create(0.35),
    		cc.CallFunc:create(function()
    			self:stopBoardAnimation(self.triggerBoardAniNode)
    			self:makeBtnsEnable(true)
    			self:showFrameMulCurrentStateAnimation(1)
    			self.dimmerNode:setVisible(false)
    		end)
    	))
        

        
	end

	local function onTouch(obj, eventType)
		if self.isStartClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end

	-- 设置按钮
	self.btnStart:addTouchEventListener(onTouch)
end

function BSGame:showBoardAnimation(node1,node2,aniCounts)
	if not node1 then return end
	local file1 = self.theme:getPic("spine/popup/board/spine")
	local file2 = self.theme:getPic("spine/popup/frame/spine")

	if aniCounts > 1 and node2 then
		self.theme:addSpineAnimation(node2,5,file2,cc.p(0,-56.63),"animation",nil,nil,nil,true,true,nil)
	end
	self.theme:addSpineAnimation(node1,5,file1,cc.p(0,0),"animation2",nil,nil,nil,true,true,nil)
end

function BSGame:makeBtnsEnable(enable)
	
	self.btnHeads:setBright(enable)
	self.btnHeads:setTouchEnabled(enable)
	self.btnTails:setBright(enable)
	self.btnTails:setTouchEnabled(enable)
	if enable then
		self.isClick = false
		self:initBtnHeadEvent()
		self:initBtnTailEvent()
		self:showBtnsIdleAnimation()
	else
		self:removeBtnsAnimation()
	end
end

function BSGame:createCoins()
	for i = 1, self.triggerCount do
		local index = self.data.executeList[i]
		if not self.data.finishExecuteIndexList[index] then
			local result = nil
			if self.data.orientationList[index] then
				result = self.data.orientationList[index]
			else
				result = math.random(1,2)
			end
			
			self.coinsNodeList[index] = cc.Node:create()			
			local pos = coinPosList[index]
			self.coinsNodeList[index]:setPosition(pos)
			self.coinNode:addChild(self.coinsNodeList[index])

			if result == 1 then
				self:createCoinAnimation(self.coinsNodeList[index],coinStateType.HeadIdle,true)
			else
				self:createCoinAnimation(self.coinsNodeList[index],coinStateType.TailIdle,true)
			end

			self.data.orientationList[index] = result
		else
			self.data.orientationList[index] = math.random(1,2)
		end
	end
	self:saveBonus()
end

function BSGame:showCrownsIdleAnimation()
	self.crownLevel1:removeAllChildren()
	self.crownLevel2:removeAllChildren()

	local file = self.theme:getPic("spine/bonus/crown/spine")
	self.theme:addSpineAnimation(self.crownLevel1,nil,file,cc.p(0,0),"animation2",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.crownLevel2,nil,file,cc.p(0,0),"animation1",nil,nil,nil,true,true,nil)
end

function BSGame:showBtnsIdleAnimation()
	local file = self.theme:getPic("spine/bonus/btn/spine")
	self.theme:addSpineAnimation(self.headBtnAniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.tailBtnAniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
end

function BSGame:removeBtnsAnimation()
	self.headBtnAniNode:removeAllChildren()
	self.tailBtnAniNode:removeAllChildren()
end

function BSGame:showFrameMulWinState(index)
	local file = self.theme:getPic("spine/bonus/frame_win/spine")
	if self.mulFrameAniNodeList[index] then
		self.mulFrameAniNodeList[index]:removeAllChildren()
		local aniName = "animation"..index
		self.theme:addSpineAnimation(self.mulFrameAniNodeList[index],nil,file,cc.p(0,0),aniName,nil,nil,nil,true,true,nil)
	end
end

function BSGame:showFrameMulWinTriggerAnimation(index)
	local file = self.theme:getPic("spine/bonus/frame_win_trigger/spine")
	if self.mulFrameAniNodeList[index] then
		local aniName = "animation"..index
		self.theme:addSpineAnimation(self.mulFrameAniNodeList[index],nil,file,cc.p(0,0),aniName,nil,nil,nil,false,false,nil)
	end
end

function BSGame:showFrameMulCurrentStateAnimation(index)
	local file = self.theme:getPic("spine/bonus/frame_current/spine")
	--print("wy_showFrameMulCurrentStateAnimation1",index)
	if self.mulFrameAniNodeList[index] then
		self.mulFrameAniNodeList[index]:removeAllChildren()
		local aniName = "animation"..index
		--print("wy_showFrameMulCurrentStateAnimation2",aniName)
		self.theme:addSpineAnimation(self.mulFrameAniNodeList[index],nil,file,cc.p(0,0),aniName,nil,nil,nil,true,true,nil)
		self.theme:playMusic(self.theme.audio_list.mul_active)
	end
end

function BSGame:removeFrameMulSingleNodeAnimation(index)
	if self.mulFrameAniNodeList[index] then
		self.mulFrameAniNodeList[index]:removeAllChildren()
	end
end

function BSGame:showCharacterIdleAnimation(state)
	local cState = state or "animation"
	local file = self.theme:getPic("spine/bonus/character/spine")
	local aniName = nil
	if state == "animation" then
		aniName = "animation1"
	else
		aniName = "animation2"
	end

	self.characterNode:removeAllChildren()
	
	self.theme:addSpineAnimation(self.characterNode,nil,file,cc.p(0,0),aniName,nil,nil,nil,true,true,nil)
end

function BSGame:setMulFrameResultCounts()
	for i = 1, self.processCounts do
		if self.data.mulWinCountList[i] and self.data.mulWinCountList[i] > 0 then
			self.countLabelList[i]:setString(self.data.mulWinCountList[i])
		else
			self.countLabelList[i]:setString("")
		end
	end
end

function BSGame:setMulFrameState()
	local len = #self.data.mulWinCountList
	if len == 0 then return end
	for i = 1, len do
		if self.data.mulWinCountList[i] then
		    if self.data.mulWinCountList[i] > 0 then
               self:showFrameMulWinState(i)
		    else
		   	   self.dimImageList[i]:setVisible(true)
		   	end
		end
	end
end

function BSGame:createParticle(parent,pFile,pPos)
	if not pFile or not parent then return end
	pPos = pPos or cc.p(0,0)
	local lizi = cc.ParticleSystemQuad:create(pFile)
	lizi:setPosition(pPos)
	parent:addChild(lizi)
end

function BSGame:createCoinAnimation(node, coinStateType, isLoop)
	if not node then return end
	node:removeAllChildren()
	local file = self.theme:getPic("spine/bonus/coin_turn/spine")
	local aniName = "animation"..coinStateType or "animation7"
	self.theme:addSpineAnimation(node,nil,file,cc.p(0,0),aniName,nil,nil,nil,isLoop,isLoop,nil)
end

function BSGame:showCoinsRemoveAnimation(index,coinType)
	coinType = coinType or 1
	--print("wy_showCoinsRemoveAnimation_index",index, coinType)
	local function showRemoveCoinAnimation(node)
		if coinType == 1 then
		    self:createCoinAnimation(node, coinStateType.HeadRemove,false)
		else
			self:createCoinAnimation(node, coinStateType.TailRemove,false)
		end
	end
    
    local function showMoveEffectAnimation(index)
    	--print("wy_showMoveEffectAnimation_index",index)
 
    	local node = cc.Node:create()
    	local pos = coinPosList[index]
    	node:setPosition(pos)
    	self.coinFlyNode:addChild(node)
 
    	local pFile = self.theme:getPic("particles/shoujituowei_1.plist")
    	self:createParticle(node,pFile)
    	local endPos = flyToMulPosList[self.data.chooseIndex]
    	node:runAction(cc.Sequence:create(
    		cc.MoveTo:create(0.5,endPos),
    		cc.CallFunc:create(function()
    			local count = self.data.mulWinCountList[self.data.chooseIndex]
    			self.countLabelList[self.data.chooseIndex]:setString(count)  			
    		end)
    	))
    end

	if self.coinsNodeList[index] then
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				showRemoveCoinAnimation(self.coinsNodeList[index])
				self.theme:playMusic(self.theme.audio_list.coins_out)
			end),
			cc.DelayTime:create(0.667),
			cc.CallFunc:create(function()
				showMoveEffectAnimation(index)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self.coinFlyNode:removeAllChildren()
			end)
		))
	end      
end

function BSGame:initBtnHeadEvent()
	-- 点击按钮
	local clickFunc = function(obj)
		self.isClick = true
    	-- 播放点击音乐
    	self.theme:playMusic(self.theme.audio_list.btn_click)
        self:makeBtnsEnable(false)

        self.data.chooseIndex = self.data.chooseIndex + 1
        self.data.resultList[self.data.chooseIndex] = 1

        local resultCounts  = self.processList[self.data.chooseIndex] - self.processList[self.data.chooseIndex + 1]
        --print("wy_initBtnHeadEvent_resultCounts",resultCounts,"chooseIndex= ",self.data.chooseIndex)
        
        self:showCoinsTurnOverAnimation(1, resultCounts, self.data.chooseIndex)
	end

	local function onTouch(obj, eventType)
		if self.isClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end

	-- 设置按钮
	self.btnHeads:addTouchEventListener(onTouch)
end

function BSGame:initBtnTailEvent()
	-- 点击按钮
	local clickFunc = function(obj)
		self.isClick = true

    	-- 播放点击音乐
    	self.theme:playMusic(self.theme.audio_list.btn_click)
        self:makeBtnsEnable(false)

        self.data.chooseIndex = self.data.chooseIndex + 1
        self.data.resultList[self.data.chooseIndex] = 2

        local resultCounts  = self.processList[self.data.chooseIndex] - self.processList[self.data.chooseIndex + 1]

       -- print("wy_initBtnTailEvent_resultCounts",resultCounts,"chooseIndex= ",self.data.chooseIndex)
        
        self:showCoinsTurnOverAnimation(2, resultCounts, self.data.chooseIndex)
	end

	local function onTouch(obj, eventType)
		if self.isClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end

	-- 设置按钮
	self.btnTails:addTouchEventListener(onTouch)
end

function BSGame:showCoinStayEffect(node)
	local file = self.theme:getPic("spine/bonus/coin_light/spine")
	self.theme:addSpineAnimation(node,10,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
end


function BSGame:showCoinsTurnOverAnimation(chooseType, resultCounts, chooseIndex)

	self.data.mulWinCountList[self.data.chooseIndex] = resultCounts

	if resultCounts > 0 then
		local oppsiteType = chooseType == 1 and 2 or 1
		local sideList = tool.tableClone(self.data.initSideList)
		local oldFinishCounts = self.data.finishCounts + 1
    	local newFinishCounts = self.data.finishCounts + resultCounts
    	self.data.finishCounts = self.data.finishCounts + resultCounts
		for i = oldFinishCounts, newFinishCounts do
			local index = self.data.executeList[i]
			sideList[index] = true
		end

		--print("wy_sideList",tool.lua_to_json(sideList))

		self.theme:playMusic(self.theme.audio_list.coins_turn)
		for i = 1, self.triggerCount do
            local realIndex = self.data.executeList[i]
			if not self.data.finishExecuteIndexList[realIndex] then
				if sideList[realIndex] then
					self.data.finishExecuteIndexList[realIndex] = true
				end
				local startSide = self.data.orientationList[realIndex]
			    local endSide = sideList[realIndex] and oppsiteType or chooseType
			    self.data.orientationList[realIndex] = endSide
			    self:playSingleCoinTurnOverAnimation(realIndex, startSide, endSide, sideList[realIndex])
			end
		end

		local delay = 1.8
		if self.data.chooseIndex == self.processCounts then
			delay = 1.2
		end

		self.theme:laterCallBack(delay,function()
			self:saveBonus()
			self:showChoosedResult(oldFinishCounts, newFinishCounts, chooseIndex )
		end)
	else
		self.theme:playMusic(self.theme.audio_list.coins_turn)
		for i = 1, self.triggerCount do
			if not self.data.finishExecuteIndexList[i] then
				local startSide = self.data.orientationList[i]
			    local endSide = chooseType
			    self.data.orientationList[i] = endSide
			    self:playSingleCoinTurnOverAnimation(i, startSide, endSide, false)
			end
		end

		if self.data.chooseIndex == self.processCounts then
			local oldFinishCounts = self.data.finishCounts + 1
			local lastCounts = self.triggerCount - self.data.finishCounts
	    	local newFinishCounts = self.data.finishCounts + lastCounts
	    	self.data.finishCounts = self.data.finishCounts + lastCounts
	    	self.data.mulWinCountList[self.data.chooseIndex] = lastCounts

			self.theme:laterCallBack(1.8,function()
				self:saveBonus()
				self:showChoosedResult(oldFinishCounts, newFinishCounts, chooseIndex )
			end)

		else		

			self.theme:laterCallBack(2,function()
				self:saveBonus()
				self.dimImageList[self.data.chooseIndex]:setVisible(true)
				self:removeFrameMulSingleNodeAnimation(self.data.chooseIndex)
				self:makeBtnsEnable(true)
				self:showFrameMulCurrentStateAnimation(self.data.chooseIndex+1)
			end)
		end
	end

end

function BSGame:playSingleCoinTurnOverAnimation(nodeIndex, startSide, endSide, isRemove)
    --print("wy_playSingleCoinTurnOverAnimation","nodeIndex= ",nodeIndex,"startSide= ",startSide,"endSide= ",endSide)
	if not self.coinsNodeList[nodeIndex] then return end	
	
	self:runAction(cc.Sequence:create(
	     cc.CallFunc:create(function()
	     	 self.coinsNodeList[nodeIndex]:removeAllChildren()
             if startSide == 1 then
				if endSide == 1 then
				    self:createCoinAnimation(self.coinsNodeList[nodeIndex], coinStateType.HeadToHead, false)
				else
					self:createCoinAnimation(self.coinsNodeList[nodeIndex], coinStateType.HeadToTail, false)
				end
			else
				if endSide == 1 then
				    self:createCoinAnimation(self.coinsNodeList[nodeIndex], coinStateType.TailToHead, false)
				else
					self:createCoinAnimation(self.coinsNodeList[nodeIndex], coinStateType.TailToTail, false)
				end
			end 
	     end),
	     cc.DelayTime:create(1),
	     cc.CallFunc:create(function()
	     	local coinAniType = nil
	     	if isRemove then
	     		coinAniType = (endSide == 1) and coinStateType.HeadStatic or coinStateType.TailStatic
	     	else
	     		coinAniType = (endSide == 1) and coinStateType.HeadIdle or coinStateType.TailIdle
	     	end

	     	self:createCoinAnimation(self.coinsNodeList[nodeIndex], coinAniType, true)
	     	
	     	if not isRemove then
	     		self:showCoinStayEffect(self.coinsNodeList[nodeIndex])
	     	end

	     end)
	))

end

function BSGame:showChoosedResult(startFinishCount, endFinishCount, chooseIndex)

    --print("wy_showChoosedResult_startFinishCount=",startFinishCount,"endFinishCount= ",endFinishCount)

    for i = startFinishCount, endFinishCount do
    	local index = self.data.executeList[i]
    	local sideIndex = self.data.orientationList[index]
    	--print("wy_showChoosedResult_index",index,"sideIndex= ",sideIndex)
    	self:showCoinsRemoveAnimation(index, sideIndex)
    end	 

    self.theme:laterCallBack(1.5,function()
    	self:showFrameMulWinState(self.data.chooseIndex)
    	self:showFrameMulWinTriggerAnimation(self.data.chooseIndex)		
    	if self.data.chooseIndex == self.processCounts then
    		self:finishChoosed()
    	else
    	    self:makeBtnsEnable(true)
    	    self:showFrameMulCurrentStateAnimation(self.data.chooseIndex+1)
    	end
    end) 
 
end


function BSGame:finishChoosed()
	self:makeBtnsEnable(false)
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function( ... )
			self.theme:playMusic(self.theme.audio_list.bonus_complete)
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()
			self:showWinFrameGetAllWin()
		end)
	))	
end

function BSGame:showWinFrameGetAllWin()
	local function showMulLabelAnimation( ... )
		self.labelMul:setScale(0)
		self.labelMul:setVisible(true)
		self.labelMul:setPosition(cc.p(-4, -146))
		self.labelMul:setString("")
        self.labelMul:runAction(cc.Sequence:create(
        	cc.ScaleTo:create(0.2,1.5,1.5),
        	cc.ScaleTo:create(0.1,1,1)
        ))
	end

	local function showLastAllWin()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.labelMul:runAction(cc.Spawn:create(
					cc.ScaleTo:create(0.3,1.5,1.5),
					cc.MoveTo:create(0.5,cc.p(-4, -56))
				))
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				self:showWinFrameBoardAcceptAnimation()
				self.labelMul:setVisible(false)
				local rollupDuration = 3
				
				self.labelWin:nrStartRoll(self.curBet, self.bonusWin, rollupDuration)
				self.theme:stopMusic(self.theme.audio_list.win_rollUp)
				self.theme:playMusic(self.theme.audio_list.win_rollUp,true)
			end),
			cc.DelayTime:create(3.5),
			cc.CallFunc:create(function()
			    self.winFrameBoardAniNode:removeAllChildren()
			    self:showCharacterIdleAnimation("static")				
				if self.data.chooseIndex >= 9 then
					self:showCharacterCelebrationAnimation()
				else
					self:showCollectBoard()
				end
			end)
		))
	end

	local function collectAllMulAnimation()
		local winMulCount = 0
		local delay = 0
		for i = 1, self.processCounts do
			if self.data.mulWinCountList[i] and self.data.mulWinCountList[i] > 0 then 
				winMulCount = winMulCount + 1
			end
		end
		delay = winMulCount * 1.3
		local processIndex = 0
		local addMul = 0
		local endPos = cc.p(-24,-88)
		self:runAction(cc.Repeat:create(cc.Sequence:create(
			cc.CallFunc:create(function()
				processIndex = processIndex + 1

				while(self.data.mulWinCountList[processIndex] and self.data.mulWinCountList[processIndex] == 0) do
					processIndex = processIndex + 1
				end

				if self.data.mulWinCountList[processIndex] and mulList[processIndex] then
					addMul = self.data.mulWinCountList[processIndex] * mulList[processIndex]
				end

				self.allMul = self.allMul + addMul

				self:showFrameMulWinTriggerAnimation(processIndex)
				self.countLabelList[processIndex]:setString("")				
			end),
			cc.DelayTime:create(0.25),
			cc.CallFunc:create(function()
				local node = cc.Node:create()
				local pos = flyToMulPosList[processIndex]
				node:setPosition(pos)
				self.coinFlyNode:addChild(node)

				local pFile = self.theme:getPic("particles/shoujituowei_1.plist")
    	        self:createParticle(node,pFile)
				node:runAction(cc.MoveTo:create(0.5,endPos))
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				self.theme:playMusic(self.theme.audio_list.mul_collect)
				self.labelMul:setString("X"..self.allMul)
				self.labelMul:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.2,1.3,1.3),
					cc.ScaleTo:create(0.1,1,1)
				))
			end),
			cc.DelayTime:create(0.5)
		),winMulCount))

		self.theme:laterCallBack(delay,function()
			showLastAllWin()
		end)
			

	end

	local function showTextChangeEffect()
		local file = self.theme:getPic("spine/bonus/text_change/spine")
		self.theme:addSpineAnimation(self.textAniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
	end

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self:showWinFrameBoardAnimation()
			self.winFrameNode:runAction(cc.Spawn:create(
				cc.ScaleTo:create(0.5,1,1),
				cc.MoveTo:create(0.5,cc.p(-15.5,75))
			))
			self.theme:playMusic(self.theme.audio_list.frame_fly)
		end),
		cc.DelayTime:create(0.8),
		cc.CallFunc:create(function()
			showTextChangeEffect()
			self.textTotalWin:setVisible(true)
			self.textStart:setVisible(false)
			showMulLabelAnimation()
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			collectAllMulAnimation()
		end)
	))
	
end

function BSGame:showWinFrameBoardAnimation()
	local file = self.theme:getPic("spine/bonus/win_frame/spine")
	self.theme:addSpineAnimation(self.winFrameBoardAniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
end

function BSGame:showWinFrameBoardAcceptAnimation()
	local file = self.theme:getPic("spine/bonus/win_frame_accept/spine")
	self.theme:addSpineAnimation(self.winFrameBoardAniNode,5,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
	self.theme:playMusic(self.theme.audio_list.mul_to_frame)
end

function BSGame:showCharacterCelebrationAnimation()
	local function showGoddnessBg()
		self.goddnessBg:setOpacity(0)
		self.goddnessBg:setVisible(true)
		self.goddnessBg:runAction(cc.Sequence:create(
			cc.FadeTo:create(0.4,255),
			cc.DelayTime:create(2),
			cc.FadeTo:create(0.4,0)
		))
	end
	local file = self.theme:getPic("spine/bonus/celebration/spine")
	local aniName = nil
	if self.data.chooseIndex < 9 or self.data.chooseIndex > 10 then return end
	if self.data.chooseIndex == 9 then
		aniName = "animation1"
	else
		aniName = "animation2"
	end
	local aniTime = 2.8
	self.theme:playMusic(self.theme.audio_list.goddness_celebration)
	self.theme:addSpineAnimation(self.fullScreenAniNode,nil,file,cc.p(0,0),aniName,nil,nil,nil,false,false,nil)
	showGoddnessBg()
	self.theme:laterCallBack(aniTime, function()
		self:showCollectBoard()
	end)

end

function BSGame:showBoardBtnAnimation(btnNode)
	local file = self.theme:getPic("spine/bonus/btn/spine")
	self.theme:addSpineAnimation(btnNode,nil,file,cc.p(136,54),"animation",nil,nil,nil,true,true,nil)
end

function BSGame:stopBoardAnimation(node)
	node:removeAllChildren()
end


function BSGame:showCollectBoard()
	-- 在此之后断电重连就不用恢复了
	self.data["end_game"] = true
	self:saveBonus()

	-- 收钱
	self.theme.ctl:collectCoins(1)

	RubTheLampController:getInstance():finishGenieThemeBonus()
	
	-- 禁掉spin按钮
	self.theme.ctl.footer:setSpinButtonState(true)
	AudioControl:stopAudio("music")

	self.dimmerNode:setOpacity(0)
	self.dimmerNode:setVisible(true)
	self.collectNode:setScale(0)
	self.collectNode:setVisible(true)
	self:showBoardAnimation(self.collectBoardAniNode1,self.collectBoardAniNode2,2)
	self:showBoardBtnAnimation(self.btnCollect)

	self.label_bonusCollectWin:setString(FONTS.formatByCount2(self.bonusWin,15,true))

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function( ... )
			self.collectNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.5,1.5),
				cc.ScaleTo:create(0.1,1,1)
			))
			self.dimmerNode:runAction(cc.FadeIn:create(0.3))
			self.theme:stopMusic(self.theme.audio_list.popup_collect)
			self.theme:playMusic(self.theme.audio_list.popup_collect,true)
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			self.btnCollect:setTouchEnabled(true)
			self:initBonusCollectEvent()
		end)
	))

end

function BSGame:initBonusCollectEvent()
	self.isCollectClick = false
	-- 点击按钮
	local clickFunc = function(obj)
    	-- 播放点击音乐
    	self.isCollectClick = true
    	self.theme:playMusic(self.theme.audio_list.btn_click)
    	self.btnCollect:setBright(false)
    	self.btnCollect:removeAllChildren()
        
        self.theme:stopMusic(self.theme.audio_list.popup_collect)
        self.theme:playMusic(self.theme.audio_list.popup_out)
        self.collectNode:runAction(cc.Sequence:create(
			cc.ScaleTo:create(0.1,1.5,1.5),
			cc.ScaleTo:create(0.2,0,0),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function()
				self:stopBoardAnimation(self.collectBoardAniNode1)
				self:stopBoardAnimation(self.collectBoardAniNode2)				
			end)		
		))

		self.theme:laterCallBack(0.3,function()
			self:exitBonus()
		end)
	end

	local function onTouch(obj, eventType)
		if self.isCollectClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end

	-- 设置按钮
	self.btnCollect:addTouchEventListener(onTouch)
end

function BSGame:exitBonus( ... )

	-- 退出
	local header = User:getInstance().header
	if header and header.themeCtl then
		LobbyThemeControl:getInstance():backToLobby(header, true, 10011, nil)
	end
end


---------------------------------断线重连相关-----------------------------------------

function customizedTheme:adjustEnterThemeRet(data)
	return data
end


--断线重连
function customizedTheme:enterThemeByBonus(theBonusGameData, endCallFunc)
    LoginControl:getInstance():saveBonus(self.themeid, nil)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
	--print("wy_recoverBonusData",tool.lua_to_json(theBonusGameData))
end


---------------------------声音相关----------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	--bonus
	self.audio_list.popup_collect   = "audio/bonus/popup_collect.mp3"
	self.audio_list.popup_out          = "audio/bonus/popup_out.mp3"
	self.audio_list.win_rollUp = "audio/bonus/win_rollup.mp3"
	self.audio_list.bonus_background        = "audio/bonus/bonus_bgm.mp3"
	self.audio_list.coins_turn = "audio/bonus/coins_turn.mp3"
	self.audio_list.coins_out = "audio/bonus/coins_out.mp3"
	self.audio_list.mul_collect = "audio/bonus/mul_collect.mp3"
	self.audio_list.mul_to_frame = "audio/bonus/mul_to_frame.mp3"
	self.audio_list.goddness_celebration = "audio/bonus/goddness_celebration.mp3"
	self.audio_list.mul_active = "audio/bonus/mul_active.mp3"
	self.audio_list.frame_fly = "audio/bonus/bonus_frame_fly.mp3"
	self.audio_list.bonus_complete = "audio/bonus/bonus_complete.mp3"
	self.audio_list.btn_click        = "audio/base/btn_click.mp3"
	
end

function customizedTheme:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.win_rollUp,
		self.audio_list.popup_collect,
		self.audio_list.popup_out,
		self.audio_list.coins_turn,
		self.audio_list.coins_out,	
		self.audio_list.mul_collect,
		self.audio_list.mul_to_frame,
		self.audio_list.goddness_celebration,
		self.audio_list.mul_active,
		self.audio_list.bonus_complete,
		self.audio_list.frame_fly,

	}
	return loadMuscList
end

function customizedTheme:dealMusic_PlayBonusLoopMusic()
	self:stopAllLoopMusic()
	-- 播放背景音乐
	self:playLoopMusic(self.audio_list.bonus_background)
end


return ThemeActivityHeadsOrTails

