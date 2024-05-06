--ThemeLevelUpGame.lua
--Author:xiongmeng
--Using:game  
--ThemeId:2006

local parentClass = Theme
ThemeLevelUpGame = class("ThemeLevelUpGame", parentClass)

local customizedTheme = ThemeLevelUpGame

customizedTheme.plistAnimate = 
{
	"images/plist/symbols",
	"images/plist/base",
	"images/plist/popup",
}

customizedTheme.csbList = 
{
	"csb/base.csb",
}

local SpinBoardType = {
	Normal = 1,
	ReSpin = 2,
}

-- local Jsize = {
-- 	["width"] = 180,
-- 	["height"] = 170
-- }
local allCsbListTimeList = {
	["respinDialog"] = {
		["startTime"] = {0, 35},
		["hideTime"]  = {60, 75}
	}
}

local ReSpinStep = {
	OFF = 1,
	Start = 2,
	Reset = 3,
	Over = 4,
	Playing = 5,	
}

local epicLinkMul = 
{
	[21] = 1,[22] = 2,[23] = 3,[24] = 4,[25] = 5,[26] = 6,[27] = 7,[28] = 8,[29] = 9,[30] = 10,[31] = 15,[32] = 20,[33] = 30,
	[34] = 40,[35] = 50,[36] = 200
}

local keyValueSet = Set({21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36})
local jpValueSet = Set({30, 35, 36})
local jpImageConfig = {
	[30] = "#theme2006_base8.png",
	[35] = "#theme2006_base7.png",
	[36] = "#theme2006_base6.png",
}

function customizedTheme:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	self.boardConfigList = self.ThemeConfig["boardConfig"]
	return self.boardConfigList
end

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

            [21] = 500,[22] = 500,[23] = 500,[24] = 500,[25] = 500,[26] = 500,[27] = 500,[28] = 500,[29] = 500,[30] = 500,
            [31] = 500,[32] = 500,[33] = 500,[34] = 500,[35] = 500,[36] = 500
            
		},
		["special_symbol_list"] = {
			--specialSymbol["fg_trigger"]
		},
		["normal_symbol_list"]  = {
			0,1 
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
			["allow_over_range"] = true,
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(148,110),
					["cellWidth"] = 192,
					["cellHeight"] = 157,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(340,110),
					["cellWidth"] = 192,
					["cellHeight"] = 157,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(532,110),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 192,
					["cellHeight"] = 157,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(724,110),
					["cellWidth"] = 192,
					["cellHeight"] = 157,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(916,110),
					["cellWidth"] = 192,
					["cellHeight"] = 157,
					["symbolCount"] = 3
				},
			}
		},
	}
    }

	self.baseBet = 10000
	self.DelayStopTime = 0
	self.UnderPressure = 1
    
	 
    local use_portrait_screen = false
	local ret = parentClass.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 157
local G_cellWidth = 192
local delay = 0
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -30*60
local normalSpeed = -30*60
local fastSpeed = -30*60 - 200

local stopDelay = 20/60
local speedDownTime = 60/60
local downBounce = G_cellHeight*2/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 21/60
local specialAniTime = 160/60 
local extraReelTime = 2 + 96/30 + 0.6
local extraReelTimeInFreeGame = 240/60
local spinMinCD = 0.5

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

function customizedTheme:getSpinColStopAction(themeInfoData, pCol, interval)   
	-- 需要多滚一段时间
	if self.respinAddTime then
		self.DelayStopTime = self.DelayStopTime + extraReelTime 
		self.respinAddTime = nil
	end

	local function onSpecialBegain( pcol)
	end

	local function onSpecialEnd( )
	end

	local spinAction = {}
	spinAction.actions = {}
	
	local temp = interval - speedUpTime - upBounceTime
	self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0

	spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime
	
	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = spinAction.speedDownTime - 20/60
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = downBounceTime
	spinAction.stopType = 1
		
	return spinAction
end


-- 配置场景
function customizedTheme:initScene(spinNode)
	self.csb = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(self.csb)

	bole.adaptScale(self.mainThemeScene,false)

	self.reelRoot = self.mainThemeScene:getChildByName("Node_root_node")

	self.boardRoot = self.reelRoot:getChildByName("board_root")
	self.animateNode = self.reelRoot:getChildByName("Node_animated")

	self.shakyNode:addChild(self.mainThemeScene)

 ---JackPot相关
    -- 初始化jackpot
	self.progressive_node = self.mainThemeScene:getChildByName("progressive_node")
	local jpNode = self.progressive_node:getChildByName("jackpot_labels")
	self.jackpotLabels = {}
	for i=1,3 do
		self.jackpotLabels[i] = jpNode:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	end
	self:initialJackpotNode()

-- 激励相关
	self.coverStonNode = self.reelRoot:getChildByName("cover_ston")
	self.coverBlackNode = self.reelRoot:getChildByName("cover_black")
	self.jiliParent = self.reelRoot:getChildByName("jili_node")
	self.boomNode = self.mainThemeScene:getChildByName("boom_node")

-- 获取对应的条数
	self.commonBlack = 	self.mainThemeScene:getChildByName("common_black")
	self.roundNode = self.mainThemeScene:getChildByName("round_node")
	self.commonBlack:setVisible(false)
	self.roundNode:setVisible(false)


	self.coverStonList = {}
	self.coverBlackList = {}
	self.roundItemList = {}

	for key = 1, 5 do
		local stonNode = self.coverStonNode:getChildByName("ston"..key)
		local blackNode = self.coverBlackNode:getChildByName("cover"..key)
		local roundItem = self.roundNode:getChildByName("round"..key)
		-- local roundBox = roundItem:getChildByName("box")
		-- local roundTip = roundItem:getChildByName("tip")
		local ani_node = roundItem:getChildByName("ani_node")
		local chooseTimes = roundItem:getChildByName("times")
		local chooseLebel = chooseTimes:getChildByName("label")
		chooseLebel:setPositionX(10)

		-- roundBox:setVisible(false)
		-- roundTip:setVisible(false)
		chooseTimes:setVisible(false)

		self.coverStonList[key] = stonNode
		self.coverBlackList[key] = blackNode
		self.roundItemList[key] = roundItem
		roundItem.ani_node = ani_node
		roundItem.chooseTimes = chooseTimes
		roundItem.chooseLebel = chooseLebel
	end

	self.flyParentNode = cc.Node:create()
	bole.scene:addToTop(self.flyParentNode)

   self.ctl.footer:isShowTotalBetLayout(false)
end


-------------------------切换活动 相关----------------------------
function customizedTheme:showActivitysNode( bonusData ) -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
	if self.ctl.footer then
        self.ctl.footer:showActivitysNode()
    end
end

function customizedTheme:hideActivitysNode( bonusData ) -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
	if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
end

function customizedTheme:enableAllFooterBtns( flag )
	self.ctl.footer:setSpinButtonState(flag) -- 开启 footer按钮
    self.ctl.footer:enableOtherBtns(not flag)
end


--------------------------JackPot功能相关----------------------------------	

function customizedTheme:getJPLabelMaxWidth(index)
	local jackpotLabelMaxWidth = {206,189,166}
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function customizedTheme:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"grand", "major","minor"},
		allowK = {[2006] = false},
	}
	return jackpot_config_list
end

------------------------------轮带功能相关----------------------------------

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

function customizedTheme:changeSpinBoard(pType) -- 更改背景控制 已修改
	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		self.showReSpinBoard = false
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end
	elseif pType == SpinBoardType.ReSpin then
		self.showReSpinBoard = true
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end
	end
end

function customizedTheme:onReelStop(col)

	if self.showReSpinBoard and self.bonus then
		self.bonus:playItemColAnimetion(col)
	end

	Theme.onReelStop(self, col)
end

function customizedTheme:onReelFallBottom( pCol )

end

function customizedTheme:onReelFastFallBottom(pCol)

end

function customizedTheme:spinControl( spinCallFun )
	spinCallFun()
end

function customizedTheme:onSpinStart()
	self.DelayStopTime = 0
	Theme.onSpinStart(self)
end
function customizedTheme:lockLobbyBtn()
	if self.ctl and self.ctl.header then
		self.ctl.header:LobbyBtnState(false)
	end
end
function customizedTheme:onRespinStart()
	self.DelayStopTime = 0
	if self.showReSpinBoard then
		self.respinStep = ReSpinStep.Playing 
		self.canFastStop = false
	end
	
	Theme.onRespinStart(self)
end

function customizedTheme:onRespinStop(ret)
	if #ret["theme_respin"] == 0 then
		self.respinStep = ReSpinStep.Over
		ret.theme_deal_show = true
	end
	self:fixRet(ret)
	Theme.onRespinStop(self, ret)
end

function customizedTheme:onAllReelStop()

    Theme.onAllReelStop(self)
end

function customizedTheme:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果

	self.ctl.resultCache = {}
	-- 处理cacheSpinRet
	if not ret then return end
	self.delateRespinData = self.delateRespinData or {}
	local itemsList = table.copy(ret.item_list)
	local item_list_up = self.delateRespinData["item_list_up"] or {}
	local item_list_down = self.delateRespinData["item_list_down"] or {}
	if (#item_list_up == 0) or (#item_list_down == 0) then
		for i = 1,6 do
			item_list_up[i] = {math.random(21,30)}
			item_list_down[i] = {}
			for j = 1,6 do					
				item_list_down[i][j] = math.random(21,30)
			end
		end
	end
	
	for k,v in pairs (itemsList) do
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
		table.insert(self.ctl.resultCache,reelList)
	end
	-- if self.ctl.cacheSpinRet then 
	-- 	self.ctl.cacheSpinRet["item_list_up"] = item_list_up
	-- 	self.ctl.cacheSpinRet["item_list_down"] = item_list_down
	-- end
	self.recvItemList = ret.item_list
end

function customizedTheme:theme_respin( rets )
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
		local respinList = rets["theme_respin"]
		if respinList and #respinList>0 then
			rets["item_list"] = table.remove(self.bonus.hadRespinData, 1)
			self.delateRespinData = table.copy(rets["item_list"])
			local respinStopDelay = 1
			rets["theme_respin"]  = {}
			local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
			self:stopDrawAnimate()
			self.respinAddTime = true
			self.bonus.data.hadUsedTimes = self.bonus.data.hadUsedTimes + 1
			extraReelTime = self.bonus:getBoomTime()
			self.bonus:playRunStepByStep()
			self.ctl:respin(respinStopDelay, endCallFunc)
		else
			rets["theme_respin"] = nil
		end	
	end)))
end

function customizedTheme:getTheRespinEndDealFunc( rets )
	local retDealFunc = function(outDealFunc)
		if outDealFunc then
			outDealFunc()
		end
	end
	return retDealFunc
end

function customizedTheme:theme_deal_show(ret)
	ret.theme_deal_show = nil
	if self.respinStep == ReSpinStep.Over then
		self.bonus:onRespinFinish(ret)
	end
end

function customizedTheme:getCoinSymbolValue(key) 
	if keyValueSet[key] then
		-- local bet = self.ctl:getCurTotalBet()
		local bet = self.currentBet
		local value = bet * epicLinkMul[key]
		return value
	else
		return ""
	end
end

function customizedTheme:createCellSprite(key, col, rowIndex)
	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key
	self.initialPics = self.initialPics or {}
	
	------------------------------------------------------------
	key = 1
	theCellFile   = self.pics[key]

	self.recvItemList[col][rowIndex] = key
	theCellFile = self.pics[key]
	local theCellNode   = cc.Node:create()
	
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	---------------- 用来添加 落地 动画 --------------------
	local landAnimate = cc.Node:create()
	theCellNode.landAnimate = landAnimate
	theCellNode:addChild(landAnimate, 50)

	---------------- 用来添加symbol上的字体 --------------------
	local fontMulti = cc.Node:create()
	theCellNode.fontMulti = fontMulti
	theCellNode:addChild(fontMulti, 100)

	---------------- 用来添加jp上的图片 --------------------
	local jpImage = cc.Node:create()
	theCellNode.jpImage = jpImage
	theCellNode:addChild(jpImage, 100)

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	end
	theCellNode:setScale(0.9)

	return theCellNode
end

function customizedTheme:updateCellSprite(theCellNode, key, col)
    local theCellFile 	= self.pics[key]

	local theCellSprite = theCellNode.sprite
	local landAnimate = theCellNode.landAnimate
	local jpImage = theCellNode.jpImage
	local fontMulti = theCellNode.fontMulti

	if landAnimate then
		landAnimate:stopAllActions()
		landAnimate:removeAllChildren()
	end

	if jpImage then
		jpImage:removeAllChildren()
	end

	if fontMulti then
		fontMulti:removeAllChildren()
	end

	local sprite = nil
	local label = nil

	if jpValueSet[key] then
		sprite = bole.createSpriteWithFile(jpImageConfig[key])
		if col ~= 5 then
			sprite = nil
			key = math.random(21, 28)
			local labelCoin = self:getCoinSymbolValue(key)
			local str = FONTS.formatByCount4(labelCoin,4,true)
			label = cc.Label:createWithBMFont(self:getPic("fonts/jinzhuanziti_0.fnt"), str)
		end
		key = 1
	elseif keyValueSet[key] then
		local labelCoin = self:getCoinSymbolValue(key)
		local str = FONTS.formatByCount4(labelCoin,4,true)
		label = cc.Label:createWithBMFont(self:getPic("fonts/jinzhuanziti_0.fnt"), str)
		if col == 5 then
			label = nil
			key = 30
			sprite = bole.createSpriteWithFile(jpImageConfig[key])
		end
		key = 1
	end

	if sprite and jpImage then
		jpImage:addChild(sprite)
	end

	if label and fontMulti then
		fontMulti:addChild(label)
	end

	theCellFile = self.pics[key]

	if not theCellFile then
    	key = 0
		theCellFile = self.pics[key]
	end

	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0

	-------------------------------------------

	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end	

	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
 
end

function customizedTheme:noFeatureLeft( ... )
	local isNoFeatrueLeft = true
	if self.ctl.rets then
		 if self.ctl.rets["theme_respin"] or self.ctl.rets["bonus_game"] then
		    isNoFeatrueLeft = false
		end
	end
	return isNoFeatrueLeft	
end

--------------------------Bonus Game相关----------------------------
function customizedTheme:saveBonusCheckData(bonusData)
    local data = {}
    data["bonus_id"] = bonusData.bonus_id
    LoginControl:getInstance():saveBonus(self.themeid, data)
end

function customizedTheme:cleanBonusSaveData(data)
    LoginControl:getInstance():saveBonus(self.themeid, nil)
end

function customizedTheme:getBonusTriggerItemList()
	local item_list = {{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}}
	return item_list
end

function customizedTheme:setBet(bet)
	local set_Bet = bet
	self.ctl:setCurBet(set_Bet)
end

LevelUpRespinBonusGame = class("LevelUpRespinBonusGame")
local BSGame = LevelUpRespinBonusGame

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.theme.bonus 	= self 
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.ctl 			= bonusControl.themeCtl
end

function BSGame:saveBonus()
	if not self.data["bonus_id"] and (self.data.core_data and self.data.core_data.bonus_id) then
		self.data["bonus_id"] = self.data.core_data.bonus_id
	end
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:setJackotValue(bet)
	local mulList = {200,50,10}
	local jpLabels = self.theme.jackpotLabels
	for i = 1,3 do
		local mul = mulList[i]
		local value = bet * mul
		jpLabels[i]:setString(self.theme:formatJackpotMeter(value))
		bole.shrinkLabel(jpLabels[i], self.theme:getJPLabelMaxWidth(i), jpLabels[i]:getScale())
	end
end

function BSGame:enterBonusGame( tryResume )
	self.data["bonus_id"] = self.data.core_data.bonus_id
	self.progressive_list = self.data.core_data.progressive_list or {}
	self.theme.old_item_list = self.data.core_data.item_list or self.theme.item_list
	self.currentBet = self.data.core_data["bet"] or 10000
	self.theme.currentBet = self.currentBet
	self:enterBonusGameStepI()

 	if tryResume then
 		self.callback = function ( ... )
 			local endCallFunc2 = function ( ... )
 				if self.endCallBack then
 					self.endCallBack()
 				end
 				if self.ctl:noFeatureLeft() then 
	        		self.theme:enableAllFooterBtns(false)
	        	end
	        	self.ctl.isProcessing = false
 			end
 			endCallFunc2()
 		end
 		self.ctl.isProcessing = true
 	end
 	-- 处理成list的模式，前端来控制，进行之前需要处理钱
 	self:enterDiffcultBonus(tryResume)
end

function BSGame:enterBonusGameStepI( ... )
	self.theme:enableAllFooterBtns(true)
    self.theme:hideActivitysNode()
    self.theme:lockJackpotMeters(true)
    self:setJackotValue(self.currentBet)
end

function BSGame:enterDiffcultBonus( tryResume )
	self:dealWithRespinData()	
	self:enterRespinBonus()
end

function BSGame:dealWithRespinData( ... )
	self.winList = self.data.core_data.win_list or {}  -- 每一轮赢钱
	self.goldReelList = self.data.core_data.gold_reel_list or {} -- 每一次奖励的条数
	self.hadRespinData = self.data.core_data.theme_repsin 
	self.respinTotalWin = 0

	self.hasRespinTimes = #self.hadRespinData
	-- self.data.hadUsedTimes = 0
	self.data.hadUsedTimes = self.data.hadUsedTimes or 0

	self.ctl.totalWin = self.ctl.totalWin or 0
	self.lastRespinShow = self.theme:getBonusTriggerItemList()

	for key, val in ipairs(self.winList) do
		self.respinTotalWin = self.respinTotalWin + val
	end

	-- self.data.hadUsedTimes = self.data.hadUsedTimes >
	if self.data.hadUsedTimes > 5 then
		self.data.hadUsedTimes = 5
	end

	if self.data.hadUsedTimes > 0 then
		for key = 1, self.data.hadUsedTimes do
			self.ctl.totalWin = self.ctl.totalWin + self.winList[key]
			local removeData = table.remove(self.hadRespinData, 1)
			self.lastRespinShow = table.copy(removeData)
		end
	end
	self.ctl:updateFooterCoin()
	self.ctl.rets.item_list = table.copy(self.lastRespinShow)
	self.ctl.rets["theme_respin"] = tool.tableClone(self.hadRespinData)
	self.theme:fixRet(self.ctl.rets)
end

function BSGame:enterRespinBonus( ... )
	local snapIntro = function ( ... )
		self.theme:changeSpinBoard(SpinBoardType.ReSpin)
		self.ctl.footer.isRespinLayer = true
		self.ctl.isProcessing = true
		self.ctl.cacheSpinRet = nil --控制spin按钮不可以点击

		self.ctl:touchSpinCheckDealAutoSpin()
		self.ctl.footer.spinNode:changeBtnState("ingore", false, true)
		self:showAllBlackCover()
		self.theme:showBonusNode() -- 更换假轴数据
		self:recoverRespinLastShow()
	end

	snapIntro()

	self.theme:dealMusic_PlayBonusLoopMusic()

	if #self.hadRespinData > 0 then
		self:finishSpinStep( )
	else
		self.ctl.rets["theme_respin"] = nil
		self:playRespinCollectDialog()
	end
end

function BSGame:recoverRespinLastShow( ... )
	self:recoverSymbolAni()
	if not self.lastRespinShow then return end
	local item_list = self.lastRespinShow
	for col, item in ipairs(item_list) do
		for row, list in ipairs(item) do
			local cell =  self.theme.spinLayer.spins[col]:getRetCell(row)
			if list and cell then
				self.theme:updateCellSprite(cell, list, col, nil, true)
			end

			if self.canCollectList[col] and list > 0 then
				self:playItemAnimetion(list, col, row, 0)
			end
		end
	end
end

function BSGame:recoverSymbolAni( ... )
	if self.data.hadUsedTimes > 0 then
		self:changeAllBlackCover(0)
	end
end

function BSGame:playItemColAnimetion( col )
	if not col then return end
	if self.canCollectList[col] and self.theme.delateRespinData then
		local item = self.theme.delateRespinData[col]
		for row, list in ipairs(item) do
			if list > 0 then
				local cell = self.theme.spinLayer.spins[col]:getRetCell(row)
				self:playItemAnimetion(list, col, row, 17/30)
			end
		end
	end
end

function BSGame:playItemAnimetion( item, col, row, delay )
	delay = delay or 0
	local animateName = "animation_chuxian"
	local animateName1 = "animation_xunhuan"
	local cell = self.theme.spinLayer.spins[col]:getRetCell(row)
	local pos		= self.theme:getCellPos(col,row)
	local spineFile = self.theme:getPic("spine/symbol/spine")

	local _, s1	= self.theme:addSpineAnimation(cell.landAnimate, nil, spineFile, cc.p(0, 0), animateName, nil, nil, nil, true)
	-- s1:setScale(0.9)
	-- bonus_symbol_bonus
	self.theme:playEffectWithInterval(self.theme.audio_list.bonus_symbol_bonus,0.1,false)

	cell.landAnimate:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ( ... )
			if s1 and bole.isValidNode(s1) then
				bole.spChangeAnimation(s1, animateName1, true)
			end
		end)
		))
	cell.sprite:setVisible(false)
end

-- @spin结束之后每次的步骤
function BSGame:finishSpinStep( )
	if #self.hadRespinData > 0 then
		self:playNextSpin()
	else
		self:playRespinCollectDialog()
	end
end

-- @进行下一步的操作
function BSGame:playNextSpin( ... )
	self.ctl.rets["theme_respin"] = tool.tableClone(self.hadRespinData)
	self.ctl:handleResult() --开始执行的操作
end

function BSGame:playRunStepByStep( ... )
	local delay1 = 0.5
	local delay2 = 21/30 + 1
	local delay3 = 2
	local delay4 = 75/30  --爆炸的时间

	self.theme:runAction(
		cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				self:showAllBlackCover()
			end),
			cc.DelayTime:create(delay1),
			cc.CallFunc:create(function ( ... )
				self:showRoundCover(true)
			end),
			cc.DelayTime:create(delay2),
			cc.CallFunc:create(function ( ... )
				self:boomItemNode()
			end),
			cc.DelayTime:create(delay3),
			cc.CallFunc:create(function ( ... )
				self:hideRoundNode()
			end),
			cc.DelayTime:create(delay1),
			cc.CallFunc:create(function ( ... )
				self:changeAllBlackCover()
			end)
			)
		)
end

function BSGame:initRoundNode( ... )
	-- body
	local index = self.data.hadUsedTimes
	local file = self.theme:getPic("spine/base/muxiang_01")

	if self.theme.roundItemList then
		for key, node in ipairs(self.theme.roundItemList) do
			local chooseLebel = node.chooseLebel
			local chooseTimes = node.chooseTimes
			local len = #self.goldReelList[key] or 0
			local roundSpine = node.roundSpine 
			local ani_node = node.ani_node
			local aniName = "animation"..key.."_1"

			if not roundSpine then
				_, roundSpine = bole.addSpineAnimation(ani_node, nil, file, cc.p(0, 0), aniName, nil, nil, nil, true)
				node.roundSpine = roundSpine
				bole.setEnableRecursiveCascading(node, true)
			end

			chooseLebel:setString(len)
			if key < index then
				node:setColor(cc.c3b(95,95,95))
				aniName = "animation_zhadan"
				chooseTimes:setVisible(true)
			elseif key == index then
				aniName = "animation"..key
				chooseTimes:setVisible(false)
			elseif key > index then
				-- aniName = "animation"..key.."_1"
				aniName = "animation"..key
				chooseTimes:setVisible(false)
			end

			bole.spChangeAnimation(roundSpine, aniName, true)

		end
	end
end

function BSGame:showAllBlackCover( ... )
	if self.theme.coverStonList then
		for key, node in ipairs(self.theme.coverStonList) do
			node:setVisible(true)
		end
	end

	if self.theme.coverBlackList then
		for key, node in ipairs(self.theme.coverBlackList) do
			node:setVisible(true)
		end
	end

	if self.theme.jiliParent then
		self.theme.jiliParent:removeAllChildren()
	end

	self.canCollectList = {false, false, false, false, false}
end

-- function BSGame:getRandomList( startNum, endNum, len, maxNum )
-- 	if (not startNum) or (not endNum) or (not len) then
-- 		return nil
-- 	end
-- 	local map = {}
-- 	local list = {}
-- 	maxNum = maxNum or 5

-- 	if len ~= maxNum then
-- 		for key = 1, len do
-- 			local randomNum = math.random(startNum, endNum)
-- 			while map[randomNum] do
-- 				randomNum = math.random(startNum, endNum)
-- 			end
-- 			map[randomNum] = 1
-- 			table.insert(list, randomNum)
-- 		end
-- 	else
-- 		for key = startNum, endNum do
-- 			local randomNum = key
-- 			table.insert(list, randomNum)
-- 		end
-- 	end
-- 	return list
-- end

function BSGame:changeAllBlackCover( delay )
	delay = delay or 105/30

	local file = self.theme:getPic("spine/base/zhadan_01")
	local fileJili = self.theme:getPic("spine/base/kuang_01")
	local pngBefore = "#theme2006_base11.png"
	local pngAfter = "#theme2006_base9.png"
	local bottomAni = "animation1"
	local topAni = "animation2"
	local waitBoomTime = 12/30
	local downTime = 12/30
	local nextDownTime = 15/30


	local resultCol = self.goldReelList[self.data.hadUsedTimes]
	if resultCol and #resultCol > 0 then
		for key, col in ipairs(resultCol) do
			self.canCollectList[col] = true
		end
	end

	local downNode = {}

	local fileBoom = self.theme:getPic("spine/base/zhadan_01")
	local pFile = self.theme:getPic("particles/lizi_02.plist")
	local boomStatic = "animation1"
	local boomLoop = "animation2"
	local boomZha = "animation3"

	for key = 1, 5 do
		local node = cc.Node:create()
		local pos = self.theme:getCellPos(key, 2)
		local _startPos = self.theme:getCellPos(key, 1)
		local startPos = table.copy(_startPos)
		startPos.y = startPos.y + G_cellHeight
		local _endPos = self.theme:getCellPos(key, 3)
		local endPos = table.copy(_endPos)
		local dis = startPos.y - endPos.y

		if self.canCollectList[key] then
			node.downTime = downTime
			node.endPos = endPos
		else
			node.downTime = downTime * 2
			endPos.y = endPos.y - dis
			node.endPos = endPos
		end
		downNode[key] = node
		local _, spineB = bole.addSpineAnimation(node, 2, fileBoom, cc.p(0, 0),boomStatic, nil, nil, nil, true)
		node.spineB = spineB
		node.centerPos = pos
		node:setVisible(false)
		node:setPosition(startPos)
		self.theme.jiliParent:addChild(node, 3)
	end

	local changeSingleCover = function ( col, row , addSpine)
		local lastCol = 5
		local pos = self.theme:getCellPos(col,row)
		local pngName = pngBefore
		if col == lastCol then
			pngName = pngAfter
		end
		local sprite = bole.createSpriteWithFile(pngName)
		sprite:setPosition(pos)
		sprite:setScale(0.9)
		self.theme.jiliParent:addChild(sprite)
		if addSpine then
			local _, s2 = bole.addSpineAnimation(self.theme.jiliParent, 1, fileJili, pos, topAni)
			s2:setScale(0.9)
		end
		if self.theme.coverStonList and self.theme.coverStonList[col] then
			self.theme.coverStonList[col]:setVisible(false)
		end

		if self.theme.coverBlackList and self.theme.coverBlackList[col] then
			self.theme.coverBlackList[col]:setVisible(false)
		end
	end

	local downBoomFun = function ( ... )
		local allDownTime = 0
		local allWaitBoomTime = nextDownTime * 4
		for key, nodeB in ipairs(downNode) do
			local lizi = nil
			local choose = nil
			nodeB:runAction(cc.Sequence:create(
				cc.DelayTime:create(allDownTime),
				cc.CallFunc:create(function ( ... )
					nodeB:setVisible(true)
					lizi = cc.ParticleSystemQuad:create(pFile)
					nodeB:addChild(lizi)
				end),
				cc.MoveTo:create(nodeB.downTime, nodeB.endPos),
				cc.CallFunc:create(function ( ... )
					if lizi and bole.isValidNode(lizi) then
						lizi:removeFromParent()
						lizi = nil
					end

					if self.canCollectList[key] and nodeB.spineB then
						local pos = nodeB.centerPos or self.theme:getCellPos(key, 2)
						_, choose = bole.addSpineAnimation(self.theme.jiliParent, nil, fileJili, pos, bottomAni, nil, nil, nil, true, true)
						choose:setScale(0.9)
						bole.spChangeAnimation(nodeB.spineB, boomLoop, true)
					else
						nodeB:setVisible(false)	
					end

				end),
				cc.DelayTime:create(allWaitBoomTime),
				cc.CallFunc:create(function ( ... )
					if self.canCollectList[key] and nodeB.spineB then
						bole.spChangeAnimation(nodeB.spineB, boomZha)
					end
				end),
				cc.DelayTime:create(27/30),
				cc.CallFunc:create(function ( ... )
					if self.canCollectList[key] then
						changeSingleCover(key, 2, true)
					end
					if choose and bole.isValidNode(choose) then
						choose:removeFromParent()
						choose = nil
					end
				end),
				cc.DelayTime:create(16/30),
				cc.RemoveSelf:create()
				))

			allDownTime = allDownTime + nextDownTime
			if self.canCollectList[key] then
				allWaitBoomTime = allWaitBoomTime + waitBoomTime
			end
			
		end
	end

	local changeCover = function ( ... )
		self.theme.jiliParent:removeAllChildren()
		self.theme.jiliParent:stopAllActions()
		local row = 2
		if self.canCollectList then
			for col = 1, 5 do
				if self.canCollectList[col] then
					changeSingleCover(col, row)
				end
			end
		end
	end

	if delay > 0 then
		downBoomFun()
	else
		changeCover()	
	end

end

function BSGame:getBoomTime( ... )
	local delay = 2 + 21/30 + 2 + 15/30 * 4
	local resultCol = self.goldReelList[self.data.hadUsedTimes]
	if resultCol and #resultCol > 0 then
		local len = #resultCol
		delay = delay + 12/30 * len + 42/30
	end
	return delay
end

function BSGame:showRoundCover( isShow )
	if isShow then
		self:initRoundNode()
	end

	local beginPos = cc.p(-14, -500)
	local endPos = cc.p(-14, 0)
	local beginTime = 0.3
	local beginOp = 130
	local endOp = 0

	if isShow then
		self.theme.commonBlack:setVisible(true)
		self.theme.commonBlack:setOpacity(0)
		self.theme.roundNode:setVisible(true)
		self.theme.roundNode:setPosition(beginPos)
		self.theme.commonBlack:runAction(cc.FadeTo:create(beginTime, beginOp))
		self.theme.roundNode:runAction(cc.MoveTo:create(beginTime, endPos))
	else
		self.theme.commonBlack:setVisible(true)
		self.theme.commonBlack:setOpacity(beginOp)
		self.theme.roundNode:setVisible(true)
		self.theme.roundNode:setPosition(endPos)
		self.theme.commonBlack:runAction(cc.FadeTo:create(beginTime, endOp))
		self.theme.roundNode:runAction(cc.Sequence:create(
			cc.MoveTo:create(beginTime, beginPos),
			cc.CallFunc:create(function ( ... )
				self.theme.roundNode:setVisible(false)
			end)
			))
	end
	
end

function BSGame:boomItemNode( ... )
	local file = self.theme:getPic("spine/base/muxiang_baokai_01")
	if self.theme.roundItemList then
		for key, node in ipairs(self.theme.roundItemList) do
			if key == self.data.hadUsedTimes then
				local roundSpine = node.roundSpine
				local chooseTimes = node.chooseTimes

				if roundSpine then
					self.theme:playMusic(self.theme.audio_list.bonus_box)
					bole.spChangeAnimation(roundSpine, "animation_baokai")
				end
				
				if chooseTimes then
					chooseTimes:setScale(0.1)
					chooseTimes:runAction(cc.Sequence:create(
						cc.DelayTime:create(22/30),
						cc.CallFunc:create(function ( ... )
							bole.addSpineAnimation(node, 1, file, cc.p(0, 0), "animation")
							chooseTimes:setVisible(true)
						end),
						cc.ScaleTo:create(4/30, 1.2),
						cc.ScaleTo:create(4/30, 1)
						))
				end
			end
		end
	end
end

function BSGame:hideRoundNode( ... )
	self:showRoundCover()
end

function BSGame:onRespinFinish(ret)
	self:saveBonus()
	local itemList = self.theme.delateRespinData or {}
	local pFile = self.theme:getPic("particles/lizi_01_1.plist")
	local _targetPos = bole.getWorldPos(self.ctl.footer.winNode)
	local targetPos = bole.getNodePos(self.theme.flyParentNode, _targetPos)
	local delayTime = 0.3
	local waitDelay = 1.8
	local nextTime = 0 
	local nextDelay = 0.8
	local addCoin = false
	local coinResult = self.winList[self.data.hadUsedTimes]

	for col, item in ipairs(itemList) do
		for row, list in ipairs(item) do
			if list > 0 and self.canCollectList[col] then
				-- 添加飞的粒子 
				-- local _pos = self.theme:getCellPos(col, row)
				local cell = self.theme.spinLayer.spins[col]:getRetCell(row)
				local _pos = bole.getWorldPos(cell)
				local pos = bole.getNodePos(self.theme.flyParentNode, _pos)
				local node = cc.Node:create()
				node:setPosition(pos)
				self.theme.flyParentNode:addChild(node) 

				node:runAction(cc.Sequence:create(
					cc.DelayTime:create(nextTime),
					cc.CallFunc:create(function ( ... )
						local lizi = cc.ParticleSystemQuad:create(pFile)
						node:addChild(lizi)
						self.theme:playMusic(self.theme.audio_list.bonus_fly)
					end),
					cc.MoveTo:create(delayTime, targetPos),
					cc.CallFunc:create(function ( ... )
						local addSingleCoin = self.theme:getCoinSymbolValue(list)
						self.ctl.totalWin = self.ctl.totalWin + addSingleCoin
						if not addCoin then
							self.theme:playMusic(self.theme.audio_list.bonus_win)
						end
						addCoin = true
						if self.ctl.footer.labelWin then
							self.ctl.footer.labelWin:nrStopRoll()
						end
						
						self.ctl.footer:setWinCoinsString(self.ctl.totalWin)
 						self.ctl.footer:setWinCoins(addSingleCoin, self.ctl.totalWin - addSingleCoin, 0.3)--footer 加钱
						-- end
					end),
					cc.DelayTime:create(delayTime),
					cc.RemoveSelf:create()
					))

				nextTime = nextTime + nextDelay
			end
		end
	end
	-- finishSpinStep

	-- if addCoin then
		waitDelay = nextTime + waitDelay	
	-- end

	-- if coinResult and coinResult > 0 then
	-- 	self.theme:laterCallBack(delayTime, function ( ... )
	-- 		self.ctl.totalWin = self.ctl.totalWin + coinResult
	-- 		self.ctl.footer:setWinCoinsString(self.ctl.totalWin)
	-- 		self.ctl.footer:setWinCoins(coinResult, self.ctl.totalWin - coinResult, nextTime)
	-- 	end)
	-- end

	self.theme:laterCallBack(waitDelay, function ( ... )
		self:finishSpinStep()
	end)
end

function BSGame:onRespinStop(ret)

end

function BSGame:playRespinCollectDialog( )
	local dialogPath = self.theme:getPic("csb/collect_dialog.csb")
	self.respinDialogPath = dialogPath
	self.respinDialog = cc.CSLoader:createNode(dialogPath)
	self.theme.curScene:addToContentFooter(self.respinDialog)
	local root = self.respinDialog:getChildByName("root")

	self.btnCollect = root:getChildByName("btn_collect")
	self.coinLabel = root:getChildByName("center_node"):getChildByName("coin_label")

	local aniBottom = root:getChildByName("top_node"):getChildByName("ani_bottom")
	local aniTop = root:getChildByName("top_node"):getChildByName("ani_top")
	local file = self.theme:getPic("spine/popupDialog/jiesuan_tanchuang_01")
	local fileAnniu = self.theme:getPic("spine/popupDialog/anniu_saoguang_01")
	bole.addSpineAnimation(aniBottom, nil, file, cc.p(0, 30), "animation_guang", nil, nil, nil, true, true)
	bole.addSpineAnimation(aniTop, nil, file, cc.p(0, 30), "animation_xing", nil, nil, nil, true, true)
	local _, btnSpine = bole.addSpineAnimation(self.btnCollect, nil, fileAnniu, cc.p(180, 54), "animation", nil, nil, nil, true, true)
	btnSpine:setScale(0.8)

	self.theme:playMusic(self.theme.audio_list.bonus_dialog_collect)
	self.theme:dealMusic_FadeLoopMusic(0.2, 1, 0.2)

	self:showCoinLabelNode(self.coinLabel, self.respinTotalWin, 521 ,1)
	self:playWheelLine(self.respinDialogPath, self.respinDialog, allCsbListTimeList["respinDialog"]["startTime"][1], allCsbListTimeList["respinDialog"]["startTime"][2])
	
	local clickFunc = function ( obj )
		obj:setTouchEnabled(false)
		self.btnCollect:removeAllChildren()
		if self.coinLabel then
			self.coinLabel:nrStopRoll()
			self.respinTotalWin = self.respinTotalWin
			self.coinLabel:setString(FONTS.format(self.respinTotalWin, true))
		end
		self:eixtRespinBonus()
		self.respinDialog:runAction(cc.Sequence:create(
			-- cc.DelayTime:create(0.5),
			cc.CallFunc:create(function ( ... )
				self:playWheelLine(self.respinDialogPath, self.respinDialog, allCsbListTimeList["respinDialog"]["hideTime"][1], allCsbListTimeList["respinDialog"]["hideTime"][2])
			end),
			cc.DelayTime:create((allCsbListTimeList["respinDialog"]["hideTime"][2] - allCsbListTimeList["respinDialog"]["hideTime"][1])/60),
			cc.CallFunc:create(function ( ... )
				self:exitBonus()
			end),
			cc.RemoveSelf:create()
			))
	end

	local function onTouch( obj, eventType )
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end

	self.btnCollect:addTouchEventListener(onTouch)
end

function BSGame:showCoinLabelNode( labelCoin, coin, maxWidth, scale )
	if (not labelCoin) or (not coin) then return end
	local rollupDuration = 2
	scale = scale or 1
	inherit(labelCoin, LabelNumRoll)
	local function fontFormat2(num)
	    return FONTS.format(num, true)
	end
	labelCoin:nrInit(0, 25, fontFormat2)
	labelCoin:setString(FONTS.format(coin, true))
	bole.shrinkLabel(labelCoin, maxWidth, scale) 
	labelCoin:setString(0)
	labelCoin:nrStartRoll(0,coin,rollupDuration)
end

function BSGame:playWheelLine( path, dialog, startFrame, endFrame )
	local action = cc.CSLoader:createTimeline(path)
	dialog:runAction(action)
	action:gotoFrameAndPlay(startFrame, endFrame, false)
end

function BSGame:eixtRespinBonus( ... )
	self.data["end_game"] = true
	self:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, nil)

	self.ctl:collectCoins(1)
	self.ctl:onRespinOver()
	self.ctl.rets["theme_respin"] = nil

	local user = User:getInstance()
	user:addCoins(self.respinTotalWin)
	-- self:exitBonus()
end

function BSGame:exitBonus( ... )
	if self.callback then
		self.callback()
	end
	self.theme:enableAllFooterBtns(true)
	-- -- 退出levelup mini game
	LevelUpPartyController:getInstance():exitBonusGame()
end

function customizedTheme:onExit()
	self:unloadRes()
end

---------------------------声音相关----------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	-- bonus
	self.audio_list.base_background      = "audio/bonus/bonus_bgm.mp3"
	self.audio_list.bonus_bomb            = "audio/bonus/bomb.mp3"
	self.audio_list.bonus_box 			  = "audio/bonus/box.mp3"
	self.audio_list.bonus_dialog_collect  = "audio/bonus/dialog_collect.mp3"
	self.audio_list.bonus_symbol_bonus    = "audio/bonus/symbol_bonus.mp3"
	self.audio_list.bonus_unlock1         = "audio/bonus/unlock1.mp3"
	self.audio_list.bonus_fly             = "audio/bonus/fly.mp3"
	self.audio_list.bonus_win             = "audio/bonus/win.mp3"
	
end

function customizedTheme:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.base_background     ,
		self.audio_list.bonus_bomb           ,
		self.audio_list.bonus_box 			 ,
		self.audio_list.bonus_dialog_collect ,
		self.audio_list.bonus_symbol_bonus   ,
		self.audio_list.bonus_unlock1        ,
		self.audio_list.bonus_fly        ,
		self.audio_list.bonus_win            ,
	}
	return loadMuscList
end

-- 播放啤酒的背景音效
function customizedTheme:dealMusic_PlayBonusLoopMusic()
	self:dealMusic_PlayNormalLoopMusic()
end
---------------------------------断线重连相关-----------------------------------------

function customizedTheme:showBonusNode( )
	self.ctl:resetCurrentReels(false,true) -- 更改 bonus 的棋盘
end

function customizedTheme:hideBonusNode(free,bonus)
	self.ctl:resetCurrentReels(free,bonus) -- 更改 bonus 的棋盘
end

function customizedTheme:adjustEnterThemeRet(data)

	data.theme_reels = {
		["main_reel"] = {
			[1] = {0, 21, 0, 0, 24, 0, 22, 24, 23, 0, 24, 25, 0, 0, 0, 23, 0, 24, 28, 24, 22, 24, 22, 23, 0, 0, 0, 21, 24, 0, 0, 0, 0, 0, 22, 0, 0, 0, 31, 0, 0, 0, 33, 21, 0, 23, 0, 0, 0, 34, 22, 23, 0, 0, 22, 24, 0, 26, 0, 21, 22, 0, 0, 0, 0, 0, 21, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 22, 26, 26, 21, 22, 0, 22, 0, 29, 0, 29, 0, 0, 0, 0, 23, 0, 0, 0, 23, 24, 0, 24, 0, 27, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 22, 0, 0},
			[2] = {0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 25, 0, 0, 25, 23, 21, 24, 25, 33, 0, 24, 0, 28, 0, 28, 24, 28, 24, 29, 0, 34, 0, 23, 0, 23, 0, 0, 21, 0, 0, 25, 0, 0, 0, 0, 0, 0, 0, 24, 21, 0, 21, 0, 0, 0, 0, 0, 0, 0, 22, 0, 24, 23, 27, 0, 27, 0, 0, 26, 24, 22, 26, 26, 0, 25, 0, 25, 21, 25, 21, 23, 21, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 0, 24, 24, 0, 0, 0, 26, 0, 0, 0, 0, 31, 0, 0, 0, 0, 21},
			[3] = {24, 0, 0, 0, 26, 25, 26, 21, 21, 0, 33, 0, 33, 0, 33, 31, 21, 0, 21, 33, 0, 0, 0, 33, 0, 0, 21, 24, 24, 24, 24, 0, 0, 28, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 27, 21, 0, 28, 21, 0, 0, 26, 0, 0, 0, 0, 0, 0, 0, 0, 26, 0, 32, 0, 0, 0, 0, 0, 23, 23, 0, 0, 0, 0, 0, 0, 24, 26, 23, 0, 23, 24, 23, 21, 22, 0, 24, 26, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 34},
			[4] = {21, 21, 23, 21, 23, 31, 23, 0, 0, 27, 22, 23, 22, 0, 0, 0, 0, 0, 0, 22, 23, 0, 0, 0, 0, 22, 0, 28, 0, 22, 0, 28, 0, 29, 25, 29, 23, 0, 23, 0, 23, 0, 22, 0, 0, 0, 22, 33, 27, 0, 0, 0, 27, 0, 0, 23, 25, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 28, 24, 0, 24, 24, 22, 0, 0, 0, 0, 0, 22, 0, 0, 24, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 25, 25, 34, 25, 25, 26, 0, 26, 0, 23, 0, 0, 0, 28, 22, 28, 22, 0, 21, 29, 0, 0, 23, 24, 0, 0, 0},
			[5] = {0, 0, 30, 30, 0, 0, 30, 30, 0, 0, 0, 36, 0, 36, 0, 0, 30, 0, 0, 0, 0, 30, 0, 0, 30, 35, 30, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 30, 0, 35, 0, 35, 0, 35, 0, 0, 0, 0, 0, 0, 0, 30, 0, 30, 0, 0, 0, 30, 30, 0, 0, 0, 0, 0, 0, 0, 0, 30, 30, 0, 30, 0, 0, 30, 30, 30, 0, 0, 0, 0, 0, 0, 30, 0, 0, 0, 30, 0, 30, 30, 30, 30, 35, 0, 0, 0, 30, 30, 30, 30, 30, 0, 30, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0}
		},
		["bonus_reel"] = {
			[1] = {0, 21, 0, 0, 24, 0, 22, 24, 23, 0, 24, 25, 0, 0, 0, 23, 0, 24, 28, 24, 22, 24, 22, 23, 0, 0, 0, 21, 24, 0, 0, 0, 0, 0, 22, 0, 0, 0, 31, 0, 0, 0, 33, 21, 0, 23, 0, 0, 0, 34, 22, 23, 0, 0, 22, 24, 0, 26, 0, 21, 22, 0, 0, 0, 0, 0, 21, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 22, 26, 26, 21, 22, 0, 22, 0, 29, 0, 29, 0, 0, 0, 0, 23, 0, 0, 0, 23, 24, 0, 24, 0, 27, 0, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 22, 0, 0},
			[2] = {0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 25, 0, 0, 25, 23, 21, 24, 25, 33, 0, 24, 0, 28, 0, 28, 24, 28, 24, 29, 0, 34, 0, 23, 0, 23, 0, 0, 21, 0, 0, 25, 0, 0, 0, 0, 0, 0, 0, 24, 21, 0, 21, 0, 0, 0, 0, 0, 0, 0, 22, 0, 24, 23, 27, 0, 27, 0, 0, 26, 24, 22, 26, 26, 0, 25, 0, 25, 21, 25, 21, 23, 21, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 0, 24, 24, 0, 0, 0, 26, 0, 0, 0, 0, 31, 0, 0, 0, 0, 21},
			[3] = {24, 0, 0, 0, 26, 25, 26, 21, 21, 0, 33, 0, 33, 0, 33, 31, 21, 0, 21, 33, 0, 0, 0, 33, 0, 0, 21, 24, 24, 24, 24, 0, 0, 28, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 27, 21, 0, 28, 21, 0, 0, 26, 0, 0, 0, 0, 0, 0, 0, 0, 26, 0, 32, 0, 0, 0, 0, 0, 23, 23, 0, 0, 0, 0, 0, 0, 24, 26, 23, 0, 23, 24, 23, 21, 22, 0, 24, 26, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 34},
			[4] = {21, 21, 23, 21, 23, 31, 23, 0, 0, 27, 22, 23, 22, 0, 0, 0, 0, 0, 0, 22, 23, 0, 0, 0, 0, 22, 0, 28, 0, 22, 0, 28, 0, 29, 25, 29, 23, 0, 23, 0, 23, 0, 22, 0, 0, 0, 22, 33, 27, 0, 0, 0, 27, 0, 0, 23, 25, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 28, 24, 0, 24, 24, 22, 0, 0, 0, 0, 0, 22, 0, 0, 24, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 25, 25, 34, 25, 25, 26, 0, 26, 0, 23, 0, 0, 0, 28, 22, 28, 22, 0, 21, 29, 0, 0, 23, 24, 0, 0, 0},
			[5] = {0, 0, 30, 30, 0, 0, 30, 30, 0, 0, 0, 36, 0, 36, 0, 0, 30, 0, 0, 0, 0, 30, 0, 0, 30, 35, 30, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 30, 0, 35, 0, 35, 0, 35, 0, 0, 0, 0, 0, 0, 0, 30, 0, 30, 0, 0, 0, 30, 30, 0, 0, 0, 0, 0, 0, 0, 0, 30, 30, 0, 30, 0, 0, 30, 30, 30, 0, 0, 0, 0, 0, 0, 30, 0, 0, 0, 30, 0, 30, 30, 30, 30, 35, 0, 0, 0, 30, 30, 30, 30, 30, 0, 30, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0}
		},		
	}

	self.currentBet = 10000
	if data.bonus_game and data.bonus_game.bet then
		self.currentBet = data.bonus_game.bet
	end

	return data
end

----- 断线重连
function customizedTheme:adjustTheme(data)	
    self:changeSpinBoard(SpinBoardType.Normal) 
end

--断线重连
function customizedTheme:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

return ThemeLevelUpGame