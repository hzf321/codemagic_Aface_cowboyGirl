
--ThemeActivityBalloonBonus.lua
--Author:wangyi
--2019年06月07日
--Using:activity game  

local parentClass = Theme
ThemeActivityBalloonBonus = class("ThemeActivityBalloonBonus", parentClass)

local customizedTheme = ThemeActivityBalloonBonus

customizedTheme.plistAnimate = 
{
	"images/plist/symbols",
}

customizedTheme.csbList = 
{
	"csb/base.csb",
}

local balloonBonusPosList =
{
	{cc.p(-152.5,396),cc.p(-152.5,290),cc.p(-152.5,184),cc.p(-152.5,78),cc.p(-152.5,-28),cc.p(-152.5,-134),cc.p(-152.5,-240)},
	{cc.p(0,396),cc.p(0,290),cc.p(0,184),cc.p(0,78),cc.p(0,-28),cc.p(0,-134),cc.p(0,-240)},
	{cc.p(153,396),cc.p(153,290),cc.p(153,184),cc.p(153,78),cc.p(153,-28),cc.p(153,-134),cc.p(153,-240)},
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
			1
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
			{1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{0,1,2,1,0},{2,1,0,1,2},{1,0,1,0,1},{1,2,1,2,1},{0,1,0,1,0},
			{2,1,2,1,2},{1,0,0,0,1},{1,2,2,2,1},{2,2,1,2,2},{0,0,1,0,0},{2,1,1,1,2},{0,1,1,1,0},{0,2,0,2,0},
			{2,0,2,0,2},{1,1,0,1,1},{1,1,2,1,1},{2,2,0,2,2},{0,0,2,0,0},{0,0,1,2,2},{2,2,1,0,0},{1,0,2,0,1},
			{1,2,0,2,1},{1,2,1,0,0},{1,0,1,2,2},{0,1,2,2,2},{2,1,0,0,0},{0,0,0,1,2},{2,2,2,1,0},{1,0,1,2,1},
			{1,2,1,0,1},{0,1,1,1,1},{2,1,1,1,1},{0,0,1,1,1},{2,2,1,1,1},{2,1,2,1,0},{0,1,0,1,2},{1,0,0,0,0},
			{1,2,2,2,2},{0,0,0,1,0},{2,2,2,1,2},{0,1,0,0,0},{2,1,2,2,2},{1,0,1,1,1},{1,2,1,1,1},{0,0,0,0,2},
			{2,2,2,2,0},{1,1,1,0,1},
			
		},
		["line_cnt"] = 50,
	},
	["theme_round_light_index"] = 1,
	["boardConfig"] = {
		{
			["allow_over_range"] = true, --index1
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(39,174),
					["cellWidth"] = 126,
					["cellHeight"] = 110,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(168,174),
					["cellWidth"] = 126,
					["cellHeight"] = 110,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(297,174),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 126,
					["cellHeight"] = 110,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(426,174),
					["cellWidth"] = 126,
					["cellHeight"] = 110,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(555,174),
					["cellWidth"] = 126,
					["cellHeight"] = 110,
					["symbolCount"] = 3
				},
			}
		}
	}
    }

	self.baseBet = 5000
	self.DelayStopTime = 0
	self.UnderPressure = 1
    local use_portrait_screen = true
	local ret = parentClass.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 110
local delay = 0
local upBounce = 0 --G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 20/60
local rotateTime = 5/60
local maxSpeed = -40*60
local normalSpeed = -40*60
local fastSpeed = -40*60 - 300

local stopDelay = 20/60
local speedDownTime = 40/60
local downBounce = G_cellHeight*1/5
local downBounceMaxSpeed = 6*60
local downBounceTime = 10/60
local specialAniTime = 120/60 
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
	bole.adaptScale(self.mainThemeScene,true)
	self.down_node = self.mainThemeScene:getChildByName("down_node")
	bole.adaptReelBoard(self.down_node)
	self.down_child = self.down_node:getChildByName("down_node")
    
    self.middle_node = self.mainThemeScene:getChildByName("middle_node")
    self.middleAniNode = self.middle_node:getChildByName("ani_node")

    self.reelRoot = self.down_child:getChildByName("Node_root_node")
    self.base_bgRoot = self.mainThemeScene:getChildByName("background_base")
    self.boardRoot = self.reelRoot:getChildByName("board_root")
	self.boardRoot:removeAllChildren()
	self.animateNode = self.reelRoot:getChildByName("Node_animated")

	self.shakyNode:addChild(self.mainThemeScene)
	self.dimmerNode = self.mainThemeScene:getChildByName("dimmer_node")
	self.dimmerNode:setVisible(false)
	self.dimmerNodeBoard = self.mainThemeScene:getChildByName("dimmer_node2")
	self.dimmerNodeBoard:setVisible(false)


--- balloonBonus相关
    self.lastBalloonBonusNode = self.middle_node:getChildByName("balloon_bonus_node")
    self.lastBalloonBonusNode:setVisible(false)
    self.lastBBTitleNode = self.lastBalloonBonusNode:getChildByName("title_node")
    self.lastBBBalloonNode = self.lastBalloonBonusNode:getChildByName("balloon_node")
    self.btn_lastBBBack = self.lastBalloonBonusNode:getChildByName("btn_back")

    local rollFrameNode = self.lastBalloonBonusNode:getChildByName("choose_frame_node")
    self.lastBBRollFrame = {}
    local rollArrowNode = self.lastBalloonBonusNode:getChildByName("choose_arrow_node")
    self.lastBBRollArrow = {}
    for i = 1,2 do
    	self.lastBBRollFrame[i] = rollFrameNode:getChildByName("frame"..i)
    	self.lastBBRollFrame[i]:setVisible(false)
    	self.lastBBRollArrow[i] = {}
    	self.lastBBRollArrow[i].node = rollArrowNode:getChildByName("arrow"..i)
    	self.lastBBRollArrow[i].node:setVisible(false)
    	self.lastBBRollArrow[i].aniNode = self.lastBBRollArrow[i].node:getChildByName("ani_node")
    	self.lastBBRollArrow[i].label = self.lastBBRollArrow[i].node:getChildByName("label")
    end
    self.lastBBUserResultNode = self.lastBalloonBonusNode:getChildByName("user_choose_result")
    self.lastBBUserResultNode:setVisible(false)
    self.lastBBUserChooseBalloon = self.lastBBUserResultNode:getChildByName("choose")
    self.lastBBMulNode = self.lastBalloonBonusNode:getChildByName("mul_node")
    self.lastBBMulList = {}
    for i = 1,12 do
    	self.lastBBMulList[i] = {}
    	self.lastBBMulList[i].node = self.lastBBMulNode:getChildByName("mul"..i)
    	self.lastBBMulList[i].node:setVisible(false)
    	self.lastBBMulList[i].label = self.lastBBMulList[i].node:getChildByName("label")
    	self.lastBBMulList[i].aniNode = self.lastBBMulList[i].node:getChildByName("ani_node")
    	self.lastBBMulList[i].light = self.lastBBMulList[i].node:getChildByName("bg_light")
    	self.lastBBMulList[i].light:setVisible(false)
    	self.lastBBMulList[i].dim = self.lastBBMulList[i].node:getChildByName("bg_dim")
    	self.lastBBMulList[i].dim:setVisible(false)
    end
    self.lastBBWinNode = self.lastBalloonBonusNode:getChildByName("win_node")
    self.lastBBWinNode:setVisible(false)
    self.label_lastBBWin = self.lastBBWinNode:getChildByName("label_win")
    self.lastBBCounterNode = self.lastBalloonBonusNode:getChildByName("counter_node")
    self.lastBBCountLabelNode = self.lastBBCounterNode:getChildByName("count_label_node")
    self.label_lastBBCount = self.lastBBCountLabelNode:getChildByName("label_count")


    self.lastBBRoundTipNode = self.lastBalloonBonusNode:getChildByName("round_tip_node")
    self.lastBBRoundTipNode:setVisible(false)
    self.lastBBRoundTipList = {}
    for i = 1,5 do
        self.lastBBRoundTipList[i] = self.lastBBRoundTipNode:getChildByName("round"..i)
        self.lastBBRoundTipList[i]:setVisible(false)
    end
    self.lastBBTriggerNode = self.middle_node:getChildByName("lastBonus_trigger_node")
    self.lastBBTriggerNode:setVisible(false)
    self.btn_lastBBStart = self.lastBBTriggerNode:getChildByName("btn_start")
    self.lastBBUserChooseNode = self.middle_node:getChildByName("lastBonus_choose_node")
    self.lastBBUserChooseNode:setVisible(false)
    self.lastBBUserChooseBalloonList = {}
    self.lastBBUserChooseBtnList = {}
    for i = 1,3 do
    	self.lastBBUserChooseBalloonList[i] = self.lastBBUserChooseNode:getChildByName("choose"..i)
    	self.lastBBUserChooseBtnList[i] = self.lastBBUserChooseNode:getChildByName("btn_"..i)
    end
    self.lastBBCollectNode = self.mainThemeScene:getChildByName("lastBonus_collect_node")
    self.lastBBCollectNode:setVisible(false)
    self.label_lastBBCollectWin = self.lastBBCollectNode:getChildByName("label_win")
    inherit(self.label_lastBBCollectWin, LabelNumRoll)
	local function fontFormat2(num)
	    return FONTS.formatByCount2(num, 11, true)
	end
	self.label_lastBBCollectWin:nrInit(0, 25, fontFormat2)
    self.btn_lastBBCollect = self.lastBBCollectNode:getChildByName("btn_collect")
    self.lastBBIsRightNode = self.lastBBCollectNode:getChildByName("choose_right_node")
    self.lastBBRightBalloon = self.lastBBIsRightNode:getChildByName("balloon")

    self.isMapOpen = false

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

-----------------------------Map相关-------------------------------

-- 添加Font
function customizedTheme:addMapBalloonLabel()
	local file = self:getPic("fonts/theme137_font_bz4.fnt")
	--local file = self:getPic("fonts/theme137_font_bz3.fnt")
	local fntLabel = ccui.TextBMFont:create()
    fntLabel:setFntFile(file)
	
	return fntLabel
end

function customizedTheme:showMapScene(prizeData,colorData)
	self.dimmerNode:setOpacity(0)
	self.dimmerNode:setVisible(true)
	self.lastBalloonBonusNode:setScale(0)
	self.lastBalloonBonusNode:setVisible(true)
	self.lastBBTitleNode:setVisible(true)
	self.btn_lastBBBack:setVisible(true)
	self.lastBBWinNode:setVisible(false)

	self:setMapSceneData(prizeData,colorData)
	if self.mapLevel then
		self.lastBBCounterNode:setVisible(true)
		self.label_lastBBCount:setString(self.mapLevel)
	end

	self.dimmerNode:runAction(cc.FadeIn:create(0.3))
	
	self.lastBalloonBonusNode:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.2,1.5,1.5),
		cc.ScaleTo:create(0.1,1,1),
		cc.CallFunc:create(function()
			 self.btn_lastBBBack:setTouchEnabled(true)
             self:initLastBBBtnEvent()
		end)		
	))
	self:playMusic(self.audio_list.map_open)
    
    self.isMapOpen = true

end

function customizedTheme:hideMapScene()
	self.dimmerNode:runAction(cc.FadeOut:create(0.3))
	self.lastBalloonBonusNode:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.1,1.5,1.5),
		cc.ScaleTo:create(0.2,0,0),
		cc.CallFunc:create(function()
			self.lastBBBalloonNode:removeAllChildren()
			self.isMapOpen = false
			self.lastBalloonBonusNode:setVisible(false)
			self:showFinishActions()
			self.dimmerNode:setVisible(false)
		end)		
	))
	self:playMusic(self.audio_list.map_close)
end

function customizedTheme:initLastBBBtnEvent()
	self.isBBBackClick = false

	-- 点击按钮
	local pressFunc = function(obj)
		self.isBBBackClick = true
		self.btn_lastBBBack:setTouchEnabled(false)		
        self.playMusic(self.audio_list.btn_click)
        self:hideMapScene()
        				
	end

	local function onTouch(obj, eventType)
		if self.isBBBackClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.btn_lastBBBack:addTouchEventListener(onTouch)
end

function customizedTheme:setMapSceneData(prizeData,colorData)
	if not prizeData or not colorData then return end

	for i = 1,3 do
		for j = 1,7 do
			if colorData[i][j] > 0 and prizeData[i][j] > 0 then
				local node = cc.Node:create()
				local pos = balloonBonusPosList[i][j]
				node:setPosition(pos)
				self.lastBBBalloonNode:addChild(node)
				local file = "#theme3137_bonus_balloon"..colorData[i][j]..".png"
				local bg = bole.createSpriteWithFile(file)
				node:addChild(bg)
				
				local font = self:addMapBalloonLabel()
				node:addChild(font)
				local val = prizeData[i][j]
				font:setString(FONTS.formatByCount2(val,5,true))
			end
		end
	end
end

function customizedTheme:playMapElementPopAnimation(posData,colorIndex,val)
	local node = cc.Node:create()
	local pos = balloonBonusPosList[posData[1]+1][posData[2]+1]
	node:setPosition(pos)
    self.lastBBBalloonNode:addChild(node)
    local file = "#theme3137_bonus_balloon"..colorIndex..".png"
	local bg = bole.createSpriteWithFile(file)
	node:addChild(bg)
	
	local font = self:addMapBalloonLabel()
	node:addChild(font)
	font:setString(FONTS.formatByCount2(val,5,true))
 
end


--------------------------Bonus Game相关----------------------------

function customizedTheme:getBonusTriggerItemList()
	--print("wy_bonusRets",tool.lua_to_json(self.ctl.rets))
	local item_list = self.item_list or self.ctl:getRetMatrix()
	return item_list
end

function customizedTheme:continueNextBouns(data)
	if self.bonus then
		print("wy_continueNextBouns",tool.lua_to_json(data))
		self.bonus:submitLastBonusData(data)
	end
end

ActivityBalloonBonusGame = class("ActivityBalloonBonusGame")
local BSGame = ActivityBalloonBonusGame

local boosterTimesList = {[1] = 1,[2] = 2,[3] = 4,[4] = 4,[5] = 5,[6] = 6,[8] = 7,[10] = 8}
local boosterTimeToMulList = {[1] = 1,[2] = 2,[3] = 3,[4] = 4,[5] = 5,[6] = 6,[7] = 8,[8] = 10}


local wheelConfig = {2,3,1,2,3,1}

local chooseArrowPos = 
{
    [1] = cc.p(-240,329),[2] = cc.p(-240,223),[3] = cc.p(-240,117),[4] = cc.p(-240,11),[5] = cc.p(-240,-95),[6] = cc.p(-240,-201),[7] = cc.p(-240,-307),
    [8] = cc.p(-152.5,-386),[9] = cc.p(0,-386),[10] = cc.p(152.5,-386),
    [11] = cc.p(240,-307),[12] = cc.p(240,-201),[13] = cc.p(240,-95),[14] = cc.p(240,11),[15] = cc.p(240,117),[16] = cc.p(240,223),[17] = cc.p(240,329),
    [18] = cc.p(152.5,402),[19] = cc.p(0,402),[20] = cc.p(-152.5,402)
}

local chooseArrowRotation = {90,90,90,90,90,90,90,0,0,0,270,270,270,270,270,270,270,180,180,180}

local arrowEndPosList =
{
	[1] = cc.p(250,399),[2] = cc.p(250,293),[3] = cc.p(250,187),[4] = cc.p(250,81),[5] = cc.p(250,-25),[6] = cc.p(250,-131),[7] = cc.p(250,-237),
    [8] = cc.p(-152.5,500),[9] = cc.p(0,500),[10] = cc.p(152.5,500),
    [11] = cc.p(-250,-237),[12] = cc.p(-250,-131),[13] = cc.p(-250,-25),[14] = cc.p(-250,81),[15] = cc.p(-250,187),[16] = cc.p(-250,293),[17] = cc.p(-250,399),
    [18] = cc.p(152.5,-300),[19] = cc.p(0,-300),[20] = cc.p(-152.5,-300)
}

local chooseFramePos =
{
	[1] = cc.p(0,329),[2] = cc.p(0,223),[3] = cc.p(0,117),[4] = cc.p(0,11),[5] = cc.p(0,-95),[6] = cc.p(0,-201),[7] = cc.p(0,-307),
    [8] = cc.p(-152.5,8),[9] = cc.p(0,8),[10] = cc.p(152.5,8),
    [11] = cc.p(0,-307),[12] = cc.p(0,-201),[13] = cc.p(0,-95),[14] = cc.p(0,11),[15] = cc.p(0,117),[16] = cc.p(0,223),[17] = cc.p(0,329),
    [18] = cc.p(152.5,8),[19] = cc.p(0,8),[20] = cc.p(-152.5,8)
}

local chooseLabelPos = 
{
	[1] = cc.p(0,0),[2] = cc.p(0,0),[3] = cc.p(0,0),[4] = cc.p(0,0),[5] = cc.p(0,0),[6] = cc.p(0,0),[7] = cc.p(0,0),
    [8] = cc.p(0,0),[9] = cc.p(0,0),[10] = cc.p(0,0),
    [11] = cc.p(3,0),[12] = cc.p(3,0),[13] = cc.p(3,0),[14] = cc.p(3,0),[15] = cc.p(3,0),[16] = cc.p(3,0),[17] = cc.p(3,0),
    [18] = cc.p(0,0),[19] = cc.p(0,0),[20] = cc.p(0,0)
}

local chooseType = {1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1,2,2,2}

local roundChooseBoardCounts = {2,2,2,1,1,1}
local roundChooseBoardIndex = {[1] = {1,2},[2] = {3,4},[3] = {5,6},[4] = 7,[5] = 8,[6] = 9}
local choosedStopWinPosList = 
{
	[1] = {{1,1},{2,1},{3,1}},[2] = {{1,2},{2,2},{3,2}},[3] = {{1,3},{2,3},{3,3}},[4] = {{1,4},{2,4},{3,4}},[5] = {{1,5},{2,5},{3,5}},[6] = {{1,6},{2,6},{3,6}},[7] = {{1,7},{2,7},{3,7}},
	[8] = {{1,7},{1,6},{1,5},{1,4},{1,3},{1,2},{1,1}},[9] = {{2,7},{2,6},{2,5},{2,4},{2,3},{2,2},{2,1}},[10] = {{3,7},{3,6},{3,5},{3,4},{3,3},{3,2},{3,1}},
	[11] = {{3,7},{2,7},{1,7}},[12] = {{3,6},{2,6},{1,6}},[13] = {{3,5},{2,5},{1,5}},[14] = {{3,4},{2,4},{1,4}},[15] = {{3,3},{2,3},{1,3}},[16] = {{3,2},{2,2},{1,2}},[17] = {{3,1},{2,1},{1,1}},
	[18] = {{3,1},{3,2},{3,3},{3,4},{3,5},{3,6},{3,7}},[19] = {{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7}},[20] = {{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7}}
}

local mulToRoundNodeList = {[1] = {1,2},[2] = {3,4},[3] = {5,6},[4] = {7,8},[5] = {9,10},[6] = {11,12}}
local roundMulList = {[1] = 1,[2] = 2,[3] = 3,[4] = 4,[5] = 10,[6] = 25}

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl
	self.bonusType = 0

	if self.data.core_data["wheel"] then
		self.data.isWheelDone = self.data.isWheelDone or false
		self.data.userChoice = self.data.userChoice or 0
		self:saveBonus()

	    self.oriPrizeList = self.data.core_data["wheel"]["prize_list"]
	    self.oriColorList = self.data.core_data["wheel"]["color_list"]
	    self.winPos = self.data.core_data["wheel"]["pos"]
	    self.winColorIndex = self.data.core_data["wheel"]["color_index"]
        self.bonusType = 2

    elseif self.data.core_data["final_bonus"] then
    	
    	self.data.userChoice = self.data.userChoice or self.data.core_data["final_bonus"]["choice"] or 1
    	self.data.roundIndex = self.data.roundIndex or 0
    	self.data.collectList = self.data.collectList or {{0,0,0,0,0,0,0},{0,0,0,0,0,0,0},{0,0,0,0,0,0,0}}
    	self:saveBonus()
    	self.lastBBWinList = self.data.core_data["final_bonus"]["win_list"]
    	self.isChooseRight = self.data.core_data["final_bonus"]["right_choice"] == 1 and true or false
    	self.pathList = self.data.core_data["final_bonus"]["trail"]
    	self.roundStopPosList = self.data.core_data["final_bonus"]["final_list"]
    	self.recordPrizeList = self.data.core_data["final_bonus"]["prize_list"]
    	self.recordColorList = self.data.core_data["final_bonus"]["color_list"]
    	--print("wy_recordPrizeList",tool.lua_to_json(self.recordPrizeList))
    	--print("wy_recordColorList",tool.lua_to_json(self.recordColorList))
    	self.lastBBTotalWin = self.data.core_data["final_bonus"]["total_win"]
    	self.lastBBWin = 0

    	self.bonusType = 3

	end
end

function BSGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:enterBonusGame(tryResume)
	-- 隐藏B级活动栏
	EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION)

	-- 禁掉spin按钮
	self.theme.ctl.footer:setSpinButtonState(true)
	self.theme.boardRoot:setVisible(false)
	self.theme.ctl.footer:isShowTotalBetLayout(false)

	--self.ctl.footer.isRespinLayer = true

	if self.bonusType == 2 then
		self:enterWheelBonus(tryResume)
	elseif self.bonusType == 3 then
		self:enterFinalBalloonBonus(tryResume)
	end
end

function BSGame:submitLastBonusData(data)
	--print("wy_submitLastBonusData",tool.lua_to_json(data))
	LoginControl:getInstance():saveBonus(self.theme.themeid, nil)
	if self.theme.isLastBBChooseRecover then
		self.ctl.enterThemeDealList["bonus_game"] = {}
		self.ctl.enterThemeDealList["bonus_game"] = data
		self.ctl.enterThemeDealList["bonus_game"]["base_win"] = 0
		self.callback()
		print("wy_submitLastBonusData_isLastBBChooseRecover")
	else
		self.ctl.rets["bonus_game"] = {}
		self.ctl.rets["bonus_game"] = data
		self.callback()
		print("wy_submitLastBonusDataer")
	end
end


-- final balloon bonus
function BSGame:enterFinalBalloonBonus(tryResume)
    self.previousWin = self.ctl.totalWin or 0 
    self.ctl.footer:enableOtherBtns(false)

    if tryResume then

    	self.callback = function ( ... )
  
        	local endCallFunc2 = function ( ... )
        	
				if self.theme.showFreeSpinBoard then
					if self.theme.freeCountLeft and self.theme.freeCountLeft == 0 then
	   				   self.theme.ctl.footer:setSpinButtonState(true)
	   				end
	   			end
        		if self.endCallBack then 
        			self.endCallBack()
        		end
				self.theme.ctl.isProcessing = false
        	end
        	
	        endCallFunc2()
        end
    else
    	if self.theme.showFreeSpinBoard then
    		if self.theme.freeCountLeft and self.theme.freeCountLeft == 0 then
    			local old_callback = self.callback
    			self.callback = function ( ... )
    			    old_callback()
                    self.theme.ctl.footer:setSpinButtonState(true)
		        end
		    end
		end
    end


    local function playIntro()
    	LoginControl:getInstance():saveBonus(self.theme.themeid, nil)
    	self.theme:runAction(cc.Sequence:create(
    		cc.CallFunc:create(function()
    			self.theme.btn_lastBBBack:setVisible(false)
    			self:refreshBalloonItemList()
                self:hideUserChooseBoard()
                self:setLastBBWinLabel()
                self:showWinNode()
                self.theme.lastBBCounterNode:setVisible(false)
                self.theme.lastBBTitleNode:setVisible(false)

    		end),
    		cc.DelayTime:create(1.5),
    		cc.CallFunc:create(function()
    			self:showUserChooseResultTip(true)
    		end),
    		cc.DelayTime:create(2),
    		cc.CallFunc:create(function()
    			self:showRoundTip()
    		end)
    	))
    end

    local function snapIntro()
    	self.theme.lastBBTitleNode:setVisible(false)
    	self.theme.btn_lastBBBack:setVisible(false)
    	self:refreshBalloonItemList()
    	self:showLastBBMulNode()
    	self:showUserChooseResultTip()
    	self:setLastBBWinLabel()
    	self:showWinNode()
    	self:setMulNodeState()
    	self.theme.lastBBCounterNode:setVisible(false)

    	local function recoverRoundProcess( ... )
    		self.theme:dealMusic_PlayBonusLoopMusic()
    		self.theme:runAction(cc.Sequence:create(
	    		cc.DelayTime:create(2),
	    		cc.CallFunc:create(function()
	    			self:showRoundTip()
	    		end)
	    	))
    	end

    	local function recoverCollectProcess( ... )
    		self:showLastBonusCollectBoard()
    		if self.isChooseRight then
    			self.theme.lastBBMulList[11].label:setString("50X")
    			self.theme.lastBBMulList[12].label:setString("50X")
    		end
    	end

    	
    	if self.data.roundIndex < 5 then
    		recoverRoundProcess()
    	else
    		recoverCollectProcess()
    	end
    end


	if tryResume then
		if self.theme.isLastBBChooseRecover then
			self.theme.isLastBBChooseRecover = nil
			playIntro()
		else		
		    snapIntro()
		end
	end
end


function BSGame:hideUserChooseBoard()
	self.theme.lastBBUserChooseNode:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.ScaleTo:create(0.1,1.5,1.5),
		cc.ScaleTo:create(0.2,0,0),
		cc.CallFunc:create(function()
			self.theme.lastBBUserChooseNode:setVisible(false)
			for i = 1,3 do
				self.theme.lastBBUserChooseBalloonList[i]:removeAllChildren()
			end
		end)		
	))

	self.theme:playMusic(self.theme.audio_list.popup_out)
end

function BSGame:showUserChooseResultTip(isAnimation)
	local file = "#theme3137_bonus_balloon"..self.data.userChoice..".png"
	bole.updateSpriteWithFile(self.theme.lastBBUserChooseBalloon, file)
	if isAnimation then
	   self.theme.lastBBUserResultNode:setScale(0)
	   self.theme.lastBBUserResultNode:setVisible(true)
	   self.theme.lastBBUserResultNode:runAction(cc.Sequence:create(
	   	  cc.ScaleTo:create(0.2,1.5,1.5),
	   	  cc.ScaleTo:create(0.1,1,1)
	   ))
	else
		self.theme.lastBBUserResultNode:setScale(1)
	    self.theme.lastBBUserResultNode:setVisible(true)
	end

	self.theme:playMusic(self.theme.audio_list.lastBB_popup_choose)
end

function BSGame:refreshBalloonItemList()
	self.theme.lastBBBalloonNode:removeAllChildren()
	self.theme.dimmerNode:setOpacity(255)
	self.theme.dimmerNode:setVisible(true)
	self.balloonBgNodeList = {}
	self.balloonFontList = {}
	self.theme.lastBalloonBonusNode:setScale(1)
	self.theme.lastBalloonBonusNode:setVisible(true)
	for i = 1,3 do
		for j = 1,7 do
			--if self.recordColorList[i][j] > 0 and self.recordPrizeList[i][j] > 0 then
				if self.data.collectList[i][j] > 0 then
                   self.balloonFontList[i.."_"..j] = self.theme:addMapBalloonLabel()
                   self.theme.lastBBBalloonNode:addChild(self.balloonFontList[i.."_"..j])
                   self.balloonFontList[i.."_"..j]:setColor(cc.c3b(83,83,83))
                   local pos = balloonBonusPosList[i][j]
                   self.balloonFontList[i.."_"..j]:setPosition(pos)
                   local val = self.recordPrizeList[i][j]
                   self.balloonFontList[i.."_"..j]:setString(FONTS.formatByCount2(val,5,true))
                   --print("wy_refreshBalloonItemList_onlyFont",i,j)
                else
					self.balloonBgNodeList[i.."_"..j] = cc.Node:create()
					local pos = balloonBonusPosList[i][j]
					self.balloonBgNodeList[i.."_"..j]:setPosition(pos)
					self.theme.lastBBBalloonNode:addChild(self.balloonBgNodeList[i.."_"..j])
					local file = "#theme3137_bonus_balloon"..self.recordColorList[i][j]..".png"
					local bg = bole.createSpriteWithFile(file)
					self.balloonBgNodeList[i.."_"..j]:addChild(bg)

					self.balloonFontList[i.."_"..j] = self.theme:addMapBalloonLabel()
                    self.theme.lastBBBalloonNode:addChild(self.balloonFontList[i.."_"..j],5)
                    self.balloonFontList[i.."_"..j]:setColor(cc.c3b(255,255,255))
                    local pos = balloonBonusPosList[i][j]
                    self.balloonFontList[i.."_"..j]:setPosition(pos)
                    local val = self.recordPrizeList[i][j]
                    self.balloonFontList[i.."_"..j]:setString(FONTS.formatByCount2(val,5,true))

                    --print("wy_refreshBalloonItemList_all",i,j)
				end
			--end
		end
	end
end

function BSGame:setLastBBWinLabel()
	if self.data.roundIndex == 0 then
		self.theme.label_lastBBWin:setString("")
	else
		local addIndex = 0
		local allWin = 0
		for i = 1,self.data.roundIndex do
			for j = 1,roundChooseBoardCounts[i] do
				addIndex = addIndex + 1
				allWin = allWin + self.lastBBWinList[addIndex]
			end
		end
		self.lastBBWin = allWin
		self.theme.label_lastBBWin:setString(FONTS.formatByCount2(self.lastBBWin,7,true))
	end
end

function BSGame:setMulNodeState()
	if self.data.roundIndex == 0 then return end
	if self.data.roundIndex == 6 then
		for i = 1,self.data.roundIndex do
			local index1 = mulToRoundNodeList[i][1]
			local index2 = mulToRoundNodeList[i][2]
			if i < 6 then				
				self.theme.lastBBMulList[index1].dim:setVisible(true)
	            self.theme.lastBBMulList[index2].dim:setVisible(true)
	        else
	        	self.theme.lastBBMulList[index1].light:setVisible(true)
	            self.theme.lastBBMulList[index2].light:setVisible(true)

	            local file = self.theme:getPic("spine/lastBB/cur_mul_tip/spine")

	            self.theme:addSpineAnimation(self.theme.lastBBMulList[index1].aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	            self.theme:addSpineAnimation(self.theme.lastBBMulList[index2].aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	        end
		end
	else

		for i = 1,self.data.roundIndex do
			local index1 = mulToRoundNodeList[i][1]
			local index2 = mulToRoundNodeList[i][2]

			self.theme.lastBBMulList[index1].dim:setVisible(true)
	        self.theme.lastBBMulList[index2].dim:setVisible(true)
		end
	end
end

function BSGame:showWinNode(isAnimation)
	if isAnimation then
		self.theme.lastBBWinNode:setScale(0)
		self.theme.lastBBWinNode:setVisible(true)
		self.theme.label_lastBBWin:setString("")
		self.theme.lastBBWinNode:runAction(cc.Sequence:create(
			cc.ScaleTo:create(0.2,1.3,1.3),
			cc.ScaleTo:create(0.1,1,1)
		))
	else
		self.theme.lastBBWinNode:setVisible(true)
	end
end

function BSGame:showCurrentMulTipAnimation()
	local file = self.theme:getPic("spine/lastBB/cur_mul_tip/spine")
	local roundIndex = self.data.roundIndex + 1
	--print("wy_showCurrentMulTipAnimation_roundIndex",roundIndex)
	local index1 = mulToRoundNodeList[roundIndex][1]
	local index2 = mulToRoundNodeList[roundIndex][2]

	self.theme.lastBBMulList[index1].light:setVisible(true)
	self.theme.lastBBMulList[index2].light:setVisible(true)

	self.theme.lastBBMulList[index1].aniNode:removeAllChildren()
	self.theme.lastBBMulList[index2].aniNode:removeAllChildren()
	self.theme:addSpineAnimation(self.theme.lastBBMulList[index1].aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.theme.lastBBMulList[index2].aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)

	self.theme:playMusic(self.theme.audio_list.lastBB_mul_active)
end

function BSGame:showFinishMulTipAnimation()
	local roundIndex = self.data.roundIndex
	local index1 = mulToRoundNodeList[roundIndex][1]
	local index2 = mulToRoundNodeList[roundIndex][2]

	--print("wy_showFinishMulTipAnimation",roundIndex,index1,index2)

	self.theme.lastBBMulList[index1].light:setVisible(false)
	self.theme.lastBBMulList[index2].light:setVisible(false)
	self.theme.lastBBMulList[index1].dim:setVisible(true)
	self.theme.lastBBMulList[index2].dim:setVisible(true)

	self.theme.lastBBMulList[index1].aniNode:removeAllChildren()
	self.theme.lastBBMulList[index2].aniNode:removeAllChildren()
end

function BSGame:showRoundTip()
	local roundIndex = self.data.roundIndex + 1
	self.theme.lastBBRoundTipList[roundIndex]:setVisible(true)
	self.theme.lastBBRoundTipNode:setScale(0)
	self.theme.lastBBRoundTipNode:setVisible(true)

	
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.lastBBRoundTipNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.5,1.5),
				cc.ScaleTo:create(0.1,1,1)
			))
			self.theme:playMusic(self.theme.audio_list.lastBB_popup)
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()
			self.theme.lastBBRoundTipNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.1,1.5,1.5),
				cc.ScaleTo:create(0.2,0,0)
			))
			self.theme:playMusic(self.theme.audio_list.popup_out)
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			for i = 1,5 do
			   self.theme.lastBBRoundTipList[i]:setVisible(false)
			end
			self.theme.lastBBRoundTipNode:setVisible(false)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self:showCurrentMulTipAnimation()
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self:showChooseProcess()
		end)
	))
end

function BSGame:showChooseProcess()
	local roundIndex = self.data.roundIndex + 1
	local roundCount = roundChooseBoardCounts[roundIndex]
	local roundBoardIndex = roundChooseBoardIndex[roundIndex]

	local collectDelay = 0

	if roundCount > 1 then
		local index1 = roundBoardIndex[1]
		local index2 = roundBoardIndex[2]
		local chooseList1 = self.pathList[index1]
		local chooseList2 = self.pathList[index2]

		collectDelay = self:playEachChooseProcessAnimation(self.theme.lastBBRollFrame[1],self.theme.lastBBRollArrow[1],chooseList1,roundIndex)
		self:playEachChooseProcessAnimation(self.theme.lastBBRollFrame[2],self.theme.lastBBRollArrow[2],chooseList2,roundIndex)

	else
		local chooseList = self.pathList[roundBoardIndex]
		collectDelay = self:playEachChooseProcessAnimation(self.theme.lastBBRollFrame[1],self.theme.lastBBRollArrow[1],chooseList,roundIndex)
	end


    self.theme:runAction(cc.Sequence:create(
    	cc.DelayTime:create(collectDelay+0.3),
        cc.CallFunc:create(function()
        	for i = 1,2 do
        		self.theme.lastBBRollArrow[i].aniNode:removeAllChildren()
        		self.theme.lastBBRollArrow[i].node:setVisible(false)
        		self.theme.lastBBRollArrow[i].label:setVisible(false)
        	end
        	if roundCount > 1 then
				local index1 = roundBoardIndex[1]
			    local index2 = roundBoardIndex[2]
				local stopListIndex1 = self.roundStopPosList[index1]+1
				local stopListIndex2 = self.roundStopPosList[index2]+1
			    self:showRoundCollectAnimaton(stopListIndex1)
			    self:showRoundCollectAnimaton(stopListIndex2)
			else
				stopIndex = self.roundStopPosList[roundBoardIndex]+1
				self:showRoundCollectAnimaton(stopIndex)
			end
        end),
        cc.DelayTime:create(2),
        cc.CallFunc:create(function()

        	
        	self.data.roundIndex = self.data.roundIndex + 1        	
        	self:saveBonus()
        	self:setLastBBWinLabel()
        	self:showFinishMulTipAnimation()

        	if self.data.roundIndex < 5 then
        		self:showRoundTip()
        	else
        		self:showLastResultRoundProcess()
        	end
        	

        end)
    ))

end

function BSGame:playEachChooseProcessAnimation(frame,arrow,chooseList,roundIndex)
	--print("wy_playEachChooseProcessAnimation","roundIndex= ",roundIndex,"chooseList= ",tool.lua_to_json(chooseList))
	local index = 0
	local delay = 0
	local allTime = 0
	for i = 1, #chooseList do
		local eachDelay = 0.5 + i/20
		allTime = allTime + eachDelay
	end

	local file = self.theme:getPic("spine/lastBB/firecracker/spine")
	arrow.aniNode:removeAllChildren()
	self.theme:addSpineAnimation(arrow.aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	local function showProcess()
		index = index + 1
		delay = 0.5 + index/20
		local posData = chooseList[index]+1
		local framePos = chooseFramePos[posData]
		local frameType = chooseType[posData]
		local typeFile = "#theme3137_bonusBig_chooseFrame"..frameType..".png"
		bole.updateSpriteWithFile(frame,typeFile)
		frame:setVisible(true)
		frame:setPosition(framePos)

		local arrowPos = chooseArrowPos[posData]
		local arrowRotation = chooseArrowRotation[posData]
		local arrowMul = roundMulList[roundIndex]
		--local labelPos = cc.p(0,0)
		local labelPos = chooseLabelPos[posData]
		arrow.node:setPosition(arrowPos)
		arrow.node:setVisible(true)
		arrow.aniNode:setRotation(arrowRotation)

		arrow.label:setString(arrowMul.."X")
		arrow.label:setVisible(true)
		arrow.label:setPosition(labelPos)

		if index < #chooseList then
           self.theme:laterCallBack(delay,function()
           	   showProcess()
           	   self.theme:playMusic(self.theme.audio_list.lastBB_frame_move)
           end)
        else
        	self.theme:playMusic(self.theme.audio_list.lastBB_frame_stop)
        end

	end

	showProcess()

	return allTime
end

function BSGame:showRoundCollectAnimaton(stopListIndex)
	local stopIndex = stopListIndex
	local collectList = choosedStopWinPosList[stopIndex]
	local allTime = 0.8
	local allCounts = #collectList
	local frame = allTime / allCounts
	local node = cc.Node:create()
	local posStart = chooseArrowPos[stopIndex]
	node:setPosition(cc.p(posStart.x,posStart.y+70))
	self.theme.lastBBBalloonNode:addChild(node,100)
	local arrowFile = self.theme:getPic("spine/lastBB/firecracker/spine")

	self.theme:addSpineAnimation(node,nil,arrowFile,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)

	local rotation = chooseArrowRotation[stopIndex]
	node:setRotation(rotation)

    local endPos = arrowEndPosList[stopIndex]
	node:runAction(cc.MoveTo:create(allTime,endPos))

	self.theme:playMusic(self.theme.audio_list.lastBB_firecracker_move)

	local balloonIndex = 0
	self.theme:runAction(cc.Repeat:create(cc.Sequence:create(
		cc.DelayTime:create(frame),
		cc.CallFunc:create(function()
			balloonIndex = balloonIndex + 1
			local col = collectList[balloonIndex][1]
			local row = collectList[balloonIndex][2]
			self.data.collectList[col][row] = 1

			if self.balloonBgNodeList and self.balloonBgNodeList[col.."_"..row] then
				self.balloonBgNodeList[col.."_"..row]:removeAllChildren()
				self:showBalloonBurstAnimation(self.balloonBgNodeList[col.."_"..row])
				-- self.balloonBgNodeList[col.."_"..row]:removeFromParent()
				self.balloonBgNodeList[col.."_"..row] = nil
			end
			if self.balloonFontList and self.balloonFontList[col.."_"..row] then
				self.balloonFontList[col.."_"..row]:setColor(cc.c3b(83,83,83))
			end

			if balloonIndex == allCounts then
				node:stopAllActions()
				node:removeAllChildren()
				node:removeFromParent()
				for i = 1,2 do
					self.theme.lastBBRollFrame[i]:setVisible(false)
				end				
			end
		end)

	),allCounts))
	
end

function BSGame:showBalloonBurstAnimation(node)

	local file = self.theme:getPic("spine/balloon/burst/spine")
	self.theme:addSpineAnimation(node,1,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
	self.theme:playMusic(self.theme.audio_list.balloon_break)
end

function BSGame:showLastResultRoundProcess()
	self:showCurrentMulTipAnimation()
	self.data.roundIndex = self.data.roundIndex + 1
	self:saveBonus()
    
    local rightDelay  = 0
    if self.isChooseRight then
    	rightDelay = 2
    end

	local lastCol = 1
	local lastRow = 1

	local function chooseRightEffect(node)
		local file = self.theme:getPic("spine/lastBB/mul_change/spine")
		self.theme:addSpineAnimation(node,nil,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
	end

	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
			if self.isChooseRight then
				local labelIndexs = mulToRoundNodeList[6]
				local label1 = self.theme.lastBBMulList[labelIndexs[1]].label
				local label2 = self.theme.lastBBMulList[labelIndexs[2]].label

				label1:runAction(cc.Sequence:create(
					cc.CallFunc:create(function()
						label1:setString("50X")
						chooseRightEffect(self.theme.lastBBMulList[labelIndexs[1]].aniNode)
					end),
					cc.ScaleTo:create(0.2,1.5,1.5),
					cc.ScaleTo:create(0.1,1,1)
				))
				label2:runAction(cc.Sequence:create(
					cc.CallFunc:create(function()
						label2:setString("50X")
						chooseRightEffect(self.theme.lastBBMulList[labelIndexs[2]].aniNode)
					end),
					cc.ScaleTo:create(0.2,1.5,1.5),
					cc.ScaleTo:create(0.1,1,1)
				))

				self.theme:playMusic(self.theme.audio_list.lastBB_mul_added)
	        end
		end),
		cc.DelayTime:create(rightDelay),
		cc.CallFunc:create(function()
			for i = 1,3 do
				for j = 1,7 do
					if self.data.collectList[i][j] == 0 then
						lastCol = i
						lastRow = j
					end
				end
			end

			if self.balloonBgNodeList and self.balloonBgNodeList[lastCol.."_"..lastRow] then
				self.balloonBgNodeList[lastCol.."_"..lastRow]:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.3,1.5,1.5),
					cc.ScaleTo:create(0.2,1,1),
					cc.ScaleTo:create(0.3,1.5,1.5),
					cc.ScaleTo:create(0.2,1,1)
				))
			end
			self:setLastBBWinLabel()

			self.theme:playMusic(self.theme.audio_list.lastBB_complete)
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()
			self:showLastBonusCollectBoard()
		end)

	))
end


function BSGame:showLastBonusCollectBoard()
	self.theme.lastBBCollectNode:setScale(0)
	self.theme.lastBBCollectNode:setVisible(true)
	self.theme.btn_lastBBCollect:setBright(true)
	self.theme.dimmerNodeBoard:setOpacity(0)
	self.theme.dimmerNodeBoard:setVisible(true)

	AudioControl:stopAudio("music")

	local allBBWin = self.lastBBTotalWin or self.lastBBWin or 0
	local rollupDuration = 3
	self.theme.label_lastBBCollectWin:nrStartRoll(0,allBBWin,rollupDuration)
	if self.isChooseRight then
		self.theme.lastBBIsRightNode:setVisible(true)
		self.theme.lastBBIsRightNode:removeAllChildren()
		--print("wy_userChoice",self.data.userChoice)

		local file = self.theme:getPic("spine/lastBB/right_balloon/spine")
		local aniName = "animation"..self.data.userChoice
		self.theme:addSpineAnimation(self.theme.lastBBIsRightNode,nil,file,cc.p(0,0),aniName,nil,nil,nil,true,true,nil)
		-- local file = "theme137_bonus_balloon"..self.data.userChoice..".png"
		-- bole.updateSpriteWithFile(self.theme.lastBBRightBalloon,file)
	else
		self.theme.lastBBIsRightNode:setVisible(false)
	end

	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.lastBBCollectNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.5,1.5),
				cc.ScaleTo:create(0.1,1,1)
			))
			self.theme.dimmerNodeBoard:runAction(cc.FadeIn:create(0.3))
			self.theme:playMusic(self.theme.audio_list.lastBB_popup_collect)
		end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function( ... )
			self.theme.btn_lastBBCollect:setTouchEnabled(true)
			self:initLastBBCollectEvent()
		end)
	))

end

function BSGame:initLastBBCollectEvent()
	self.isLastBBCollectClick = false

	-- 点击按钮
	local pressFunc = function(obj)
		self.isLastBBCollectClick = true
		self.theme.btn_lastBBCollect:setTouchEnabled(false)
        self.theme.btn_lastBBCollect:setBright(false)
        self.theme:playMusic(self.theme.audio_list.btn_click)

		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()

				local allBBWin = self.lastBBTotalWin or self.lastBBWin or 0
				self.theme.label_lastBBCollectWin:nrStopRoll()
		        self.theme.label_lastBBCollectWin:setString(FONTS.formatByCount2(allBBWin, 11, true))
				self.theme.lastBBCollectNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1,1.5,1.5),
					cc.ScaleTo:create(0.2,0,0),
					cc.CallFunc:create(function()
						self.theme.lastBBIsRightNode:removeAllChildren()
						self.theme.dimmerNodeBoard:setVisible(false)
					end)
				))
				self.theme.dimmerNodeBoard:runAction(cc.FadeOut:create(0.3))
				self.theme:playMusic(self.theme.audio_list.popup_out)
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				self:exitLastBBBonus()
			end)
		))			        
        self.theme:playMusic(self.theme.audio_list.wheel_press)
        				
	end

	local function onTouch(obj, eventType)
		if self.isLastBBCollectClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.theme.btn_lastBBCollect:addTouchEventListener(onTouch)
end

function BSGame:exitLastBBBonus()

	-- 在此之后断电重连就不用恢复了
	self.data["end_game"] = true
	self:saveBonus()

	-- 收钱
	self.theme.ctl:collectCoins(2)
	RubTheLampController:getInstance():finishGenieThemeBonus()
	self:exitBonus()
end

function BSGame:exitBonus( ... )
	
	-- self.callback()
	LoginControl:getInstance():saveBonus(self.theme.themeid, nil)
	-- 禁掉spin按钮
	self.theme.ctl.footer:setSpinButtonState(true)

	-- 退出
	local header = User:getInstance().header
	if header and header.themeCtl then
		LobbyThemeControl:getInstance():backToLobby(header, true, 10011, nil)
	end
end

function BSGame:changeToBalloonCollectScene()
	self.theme.lastBalloonBonusNode:setScale(1)
	self.theme.lastBalloonBonusNode:setVisible(true)
	self.theme.btn_lastBBBack:setVisible(false)
	self.theme.lastBBWinNode:setVisible(false)
	self.theme.lastBBTitleNode:setVisible(true)
	self.theme.lastBBUserResultNode:setVisible(false)
	self.theme.lastBBTitleNode:setVisible(false)
end

function BSGame:showLastBalloonBonusTrigger()
	AudioControl:stopAudio("music")
	self.theme.lastBBTriggerNode:setScale(0)
	self.theme.lastBBTriggerNode:setVisible(true)
	self.theme.btn_lastBBStart:setBright(true)
	self.theme.lastBBCounterNode:setVisible(false)

	self.theme.lastBBTriggerNode:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.2,1.5,1.5),
		cc.ScaleTo:create(0.1,1,1),
		cc.CallFunc:create(function()
			self.theme.btn_lastBBStart:setTouchEnabled(true)
			self:initLastBBStartEvent()
		end)
		
	))
	self.theme:playMusic(self.theme.audio_list.lastBB_trigger)
	self:showLastBBTriggerEffect()
	self:showWinNode(true)
end

function BSGame:showLastBBTriggerEffect()
	local file = self.theme:getPic("spine/lastBB/wheel_in/spine")
	self.theme:addSpineAnimation(self.theme.middleAniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
end

function BSGame:changeToLastBBScene()
	--self.theme.lastBBTitleNode:setVisible(false)
	self.theme.btn_lastBBBack:setVisible(false)
	self.theme.label_lastBBWin:setString("")
end

function BSGame:initLastBBStartEvent()
	self.isLastBBStartClick = false

	-- 点击按钮
	local pressFunc = function(obj)
		self.isLastBBStartClick = true
		self.theme.btn_lastBBStart:setTouchEnabled(false)
        self.theme.btn_lastBBStart:setBright(false)
        self.theme:playMusic(self.theme.audio_list.btn_click)

		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.theme.lastBBTriggerNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1,1.5,1.5),
					cc.ScaleTo:create(0.2,0,0)				
	            ))
	            self.theme:playMusic(self.theme.audio_list.popup_out)
	            self:changeToLastBBScene()
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				self.theme:dealMusic_PlayBonusLoopMusic()
				self:showLastBBMulNode(true)
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				self:showchoosedColorBoard()
			end)
		))			        
        self.theme:playMusic(self.theme.audio_list.wheel_press)
        				
	end

	local function onTouch(obj, eventType)
		if self.isLastBBStartClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.theme.btn_lastBBStart:addTouchEventListener(onTouch)
end

function BSGame:showUserChooseBoard()
	for i = 1,3 do
		self.theme.lastBBUserChooseBalloonList[i]:setColor(cc.c3b(255,255,255))
	end
	self.theme.lastBBUserChooseNode:setScale(0)
	self.theme.lastBBUserChooseNode:setVisible(true)

	self.theme.lastBBUserChooseNode:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.2,1.5,1.5),
		cc.ScaleTo:create(0.1,1,1),
		cc.CallFunc:create(function()
			for i = 1,3 do
				self.theme.lastBBUserChooseBtnList[i]:setTouchEnabled(true)
				self:initLastBBUserBtnEvent(i)
			end
		end)	
	))
	self.theme:playMusic(self.theme.audio_list.lastBB_popup)
end


function BSGame:initLastBBUserBtnEvent(index)
	local pressFunc = function(obj)
	    for i = 1,3 do
	    	self.theme.lastBBUserChooseBtnList[i]:setTouchEnabled(false)
	    	if i ~= index then
	    		self.theme.lastBBUserChooseBalloonList[i]:setColor(cc.c3b(67,67,67))
	    	else
	    		self:showBalloonChoosedEfffect(self.theme.lastBBUserChooseBalloonList[i])
	    	end
	    end
	    self.theme:playMusic(self.theme.audio_list.lastBB_choose_click)

	    self.data.userChoice = index
	    self:saveBonus()
	    local c_type = self.data.userChoice
        local special_data = {}
    	special_data.choice = c_type
    	self.ctl:collectCoins(2,special_data)
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
		    pressFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.lastBBUserChooseBtnList[index]:addTouchEventListener(onTouch)
end

function BSGame:showBalloonChoosedEfffect(node)
	local file = self.theme:getPic("spine/lastBB/choose_effect/spine")
	self.theme:addSpineAnimation(node,nil,file,cc.p(66.5,63.5),"animation",nil,nil,nil,true,true,nil)
end

function BSGame:showchoosedColorBoard()
	if self.data.userChoice > 0 then
		for i = 1,3 do
	    	if i ~= self.data.userChoice then
	    		self.theme.lastBBUserChooseBalloonList[i]:setColor(cc.c3b(67,67,67))
	    	else
	    		self:showBalloonChoosedEfffect(self.theme.lastBBUserChooseBalloonList[i])
	    	end
	    	self.theme.lastBBUserChooseBalloonList[i]:setVisible(true)
		end
		local c_type = self.data.userChoice
        local special_data = {}
    	special_data.choice = c_type
    	self.ctl:collectCoins(2,special_data)
	else
		self:showUserChooseBoard()
	end
end

function BSGame:showLastBBMulNode(isAnimation)
	local mulList = {1,1,2,2,3,3,4,4,10,10,25,25}

	if isAnimation then
		for i = 1,12 do
			local mul = mulList[i]
			self.theme.lastBBMulList[i].label:setString(mul.."X")
			self.theme.lastBBMulList[i].node:setScale(0)
			self.theme.lastBBMulList[i].node:setVisible(true)
			self.theme.lastBBMulList[i].node:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.5,1.5),
				cc.ScaleTo:create(0.1,1,1)
			))
		end
	else
		for i = 1,12 do
			local mul = mulList[i]
			self.theme.lastBBMulList[i].label:setString(mul.."X")
			self.theme.lastBBMulList[i].node:setScale(1)
			self.theme.lastBBMulList[i].node:setVisible(true)
		end
	end
end

function BSGame:enterWheelBonus(tryResume)

	if tryResume then
		self.callback = function ( ... )
   
        	local endCallFunc2 = function ( ... )
 
        		--self.ctl.rets.setWinCoins = nil  

        		if (self.ctl.enterThemeDealList and bole.getTableCount(self.ctl.enterThemeDealList) > 0) then -- whj 1.2 添加控制之后还有feature的时候控制 按钮不可以点击
	   				self.ctl.footer:setSpinButtonState(true)
	   			else
	   				self.ctl.footer:setSpinButtonState(false)
	   			end 

        		if self.endCallBack then 
        			self.endCallBack()
        		end
      
        		self.ctl.isProcessing = false     
       		
        	end
        	
	        endCallFunc2()
        end
		self.ctl.isProcessing = true
	end

	local function snapIntro()
		self.theme.isMapOpen = true

		self.theme.dimmerNode:setOpacity(255)
		self.theme.dimmerNode:setVisible(true)

		
		if self.data.userChoice > 0 then
			self.theme:setMapSceneData(self.oriPrizeList,self.oriColorList)
			self:changeToBalloonCollectScene()
			self:changeToLastBBScene()
			self:showLastBBMulNode()
			--self.theme:playMapElementPopAnimation(self.winPos,self.winColorIndex,self.winValue)
			self:showchoosedColorBoard()
		else 
		    self.theme:setMapSceneData(self.oriPrizeList,self.oriColorList)
			self:changeToBalloonCollectScene()
			--self.theme:playMapElementPopAnimation(self.winPos,self.winColorIndex,self.winValue)
			self:showLastBalloonBonusTrigger()
		end
		

	end

	snapIntro()
end

---------------------------------断线重连相关-----------------------------------------
function customizedTheme:adjustEnterThemeRet(data)

	if data["bonus_game"] and data["bonus_game"]["wheel"] then
		self.isLastBBChooseRecover = true
	end

	return data
end

--断线重连
function customizedTheme:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

---------------------------声音相关----------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	self.audio_list.btn_click        = "audio/bonus/btn_click.mp3"
	
	self.audio_list.popup_out          = "audio/bonus/popup_out.mp3"

	-- lastBB bonus
	self.audio_list.bonus_background        = "audio/bonus/bonus_bgm.mp3"
	self.audio_list.map_open = "audio/bonus/map_open.mp3"
	self.audio_list.map_close = "audio/bonus/map_close.mp3"
	self.audio_list.balloon_pop_up = "audio/bonus/balloon_pop_up.mp3"
	self.audio_list.lastBB_trigger = "audio/bonus/lastBB_trigger.mp3"
	self.audio_list.lastBB_popup = "audio/bonus/lastBB_popup.mp3"
	self.audio_list.lastBB_mul_active = "audio/bonus/lastBB_mul_active.mp3"
	self.audio_list.lastBB_mul_added = "audio/bonus/lastBB_mul_added.mp3"
	self.audio_list.lastBB_frame_move = "audio/bonus/lastBB_frame_move.mp3"
	self.audio_list.lastBB_frame_stop = "audio/bonus/lastBB_frame_stop.mp3"
	self.audio_list.lastBB_firecracker_move = "audio/bonus/lastBB_firecracker_move.mp3"
	self.audio_list.lastBB_complete = "audio/bonus/lastBB_complete.mp3"
	self.audio_list.lastBB_popup_collect = "audio/bonus/lastBB_popup_collect.mp3"
	self.audio_list.lastBB_popup_choose = "audio/bonus/lastBB_popup_choose.mp3"
	self.audio_list.lastBB_choose_click = "audio/bonus/lastBB_choose_click.mp3"
end

function customizedTheme:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.popup_out,
		self.audio_list.lastBB_popup,
		self.audio_list.lastBB_trigger,
		self.audio_list.lastBB_mul_active,
		self.audio_list.lastBB_mul_added,
		self.audio_list.lastBB_frame_move,
		self.audio_list.lastBB_frame_stop,
		self.audio_list.lastBB_firecracker_move,
		self.audio_list.lastBB_complete,
		self.audio_list.lastBB_popup_collect,
		self.audio_list.lastBB_popup_choose,
		self.audio_list.lastBB_choose_click

	}
	return loadMuscList
end

function customizedTheme:dealMusic_PlayBonusLoopMusic()
	self:stopAllLoopMusic()
	-- 播放背景音乐
	self:playLoopMusic(self.audio_list.bonus_background)
end




return ThemeActivityBalloonBonus
