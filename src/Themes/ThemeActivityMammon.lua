--Author:wanghongjie
--Email:wanghongjie@bolegames.com
--2019年6月4日 17:00
--Using:主题 3142       

ThemeActivityMammon = class("ThemeActivityMammon", Theme)
local cls = ThemeActivityMammon

-- 资源异步加载相关
cls.plistAnimate = {
	-- "image/plist/symbol",
	"image/plist/bonus",
}

cls.csbList = {
	"csb/map.csb",
}

-- local transitionDelay = {
-- 	["free"] 	= {["onCover"] = 48/30,["onEnd"] = 72/30},
-- }

local SpinBoardType = {
	Normal 		= 1,
	FreeSpin 	= 2,
	-- Bonus 		= 3,
}

local BonusGameType = { -- type1对应repsin type2对应 deal game type3对应 level
	["deal"] 	= 2,
}

local moveWildTime = 1
local changeToWildTime = 24/30
local changeToBaseTime = 21/30
local moveStartDelay = 6/30

local specialSymbol = {["triger"] = 14, ["blank"] = 15, ["kong"] = 0}
local longSymbol = {["l1"] = 21, ["l2"] = 22, ["l3"] = 23, ["l4"] = 24}
local longSymbolID = Set{21, 22, 23, 24}
local longSymbolCnt = 4
-------------- movewild 相关
local wildPosConfig = {
    [1] = {1,1}, [2] = {1,2}, [3] = {1,3}, [4] = {1,4}, [5] = {2,1}, [6] = {2,2}, [7] = {2,3}, [8] = {2,4}, [9] = {3,1}, [10] = {3,2}, 
    [11] = {3,3}, [12] = {3,4}, [13] = {4,1}, [14] = {4,2}, [15] = {4,3}, [16] = {4,4}, [17] = {5,1}, [18] = {5,2}, [19] = {5,3}, [20] = {5,4}
}
local freeColCnt = 5
local freeRowCnt = 4

------------  map 相关参数  -------------
local maxMapPoints 	= 120
local maxMapLevel 	= 20
local maxCollectProgress = 730
local progressStartPosX = 0
local progressPosY = 18
local movePerUnit = maxCollectProgress/maxMapPoints
local tipType = {
	["normal"] = 1, -- 正常点击
	["isOver"] = 2, -- 完成一遍地图
}
local collectFlyEndPos = cc.p(235,579)
local flyToUpTime = 15/30
local showFullAnimTime = 1.5
local showAddToBonusTime = 3.5
local multiData = {2,3,5,7,10,15,20,25,30,40,50,70,100,150,200,300,400,500,750,1000}
local multiValueIndexConfig = {[2] = 1,[3] = 2, [5] = 3,[7] = 4,[10] = 5,[15] = 6,[20] = 7,[25] = 8,[30] = 9,[40] = 10,[50] = 11,[70] = 12,[100] = 13,[150] = 14,[200] = 15,[300] = 16,[400] = 17,[500] = 18,[750] = 19,[1000] = 20}
local multState = {["disable"] = 1,["normal"] = 2, ["dim"] = 3}
local roundPickCnt = {1,5,4,4,3,2,1}
local tipOfferDialogHeight = 420
local yourGiftEndPos = cc.p(-403.5,-230)


cls.spinTimeConfig = { -- spin 时间控制
		["base"] = 20/60, -- 数据返回前 进行滚动的时间
		["spinMinCD"] = 50/60,  -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	self.boardConfigList = self.ThemeConfig["boardConfig"]
	return self.boardConfigList
end

function cls:ctor(themeid)
	math.randomseed(os.time())
  	self.spinActionConfig = {
		["start_index"] = 1,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	}
	self.ThemeConfig = {
		["theme_symbol_coinfig"]    = {
			["symbol_zorder_list"]  = {
	            [specialSymbol.triger] 	= 300,
	            [specialSymbol.blank] 	= 200,
			},
			["normal_symbol_list"]  = {
				3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
			},
			["special_symbol_list"] = {
				specialSymbol.triger
			},
			["no_roll_symbol_list"] = {
				specialSymbol.blank,longSymbol.l1,longSymbol.l2,longSymbol.l3,longSymbol.l4,specialSymbol.kong
			},
			["roll_symbol_inFree_list"] = {
			},
			["special_symbol_config"] = {
			},
		},
		["theme_round_light_index"] = 1,
		["theme_type"] = "payLine",
		["theme_type_config"] = {
			["pay_lines"] = {
		    	{0, 0, 0, 0, 0},{3, 3, 3, 3, 3},{1, 1, 1, 1, 1},{2, 2, 2, 2, 2},{0, 1, 2, 1, 0},{3, 2, 1, 2, 3},{2, 1, 0, 1, 2},{1, 2, 3, 2, 1},{0, 1, 0, 1, 0},{3, 2, 3, 2, 3},
				{1, 0, 1, 0, 1},{2, 3, 2, 3, 2},{1, 2, 1, 2, 1},{2, 1, 2, 1, 2},{0, 1, 1, 1, 0},{3, 2, 2, 2, 3},{1, 0, 0, 0, 1},{2, 3, 3, 3, 2},{1, 2, 2, 2, 1},{2, 1, 1, 1, 2},
				{0, 0, 1, 0, 0},{3, 3, 2, 3, 3},{1, 1, 0, 1, 1},{2, 2, 3, 2, 2},{1, 1, 2, 1, 1},{2, 2, 1, 2, 2},{0, 0, 2, 0, 0},{3, 3, 1, 3, 3},{2, 2, 0, 2, 2},{1, 1, 3, 1, 1},
				{0, 2, 2, 2, 0},{3, 1, 1, 1, 3},{2, 0, 0, 0, 2},{1, 3, 3, 3, 1},{1, 0, 2, 0, 1},{2, 3, 1, 3, 2},{1, 2, 0, 2, 1},{2, 1, 3, 1, 2},{0, 2, 0, 2, 0},{3, 1, 3, 1, 3},
				{2, 0, 2, 0, 2},{1, 3, 1, 3, 1},{0, 2, 1, 2, 0},{3, 1, 2, 1, 3},{2, 0, 1, 0, 2},{1, 3, 2, 3, 1},{0, 3, 0, 3, 0},{3, 0, 3, 0, 3},{0, 0, 3, 0, 0},{3, 3, 0, 3, 3},
				{3, 0, 0, 0, 3},{0, 3, 3, 3, 0},{0, 1, 3, 1, 0},{3, 2, 0, 2, 3},{3, 1, 0, 1, 3},{0, 2, 3, 2, 0},{1, 0, 3, 0, 1},{2, 3, 0, 3, 2},{0, 3, 2, 3, 0},{3, 0, 1, 0, 3},
				{0, 3, 1, 3, 0},{3, 0, 2, 0, 3},{2, 0, 3, 0, 2},{1, 3, 0, 3, 1},{0, 0, 0, 1, 2},{1, 1, 1, 2, 3},{2, 2, 2, 1, 0},{3, 3, 3, 2, 1},{0, 0, 1, 2, 2},{3, 3, 2, 1, 1},
				{1, 1, 2, 3, 3},{2, 2, 1, 0, 0},{0, 1, 1, 1, 2},{3, 2, 2, 2, 1},{1, 0, 1, 2, 3},
			},
			["line_cnt"] = 75,
		},
		["boardConfig"] = {
			{ -- 3x5
				["allow_over_range"] = true,
				["reelConfig"] = {
					{
						["base_pos"] 	= cc.p(230,124),
						["cellWidth"] 	= 160,
						["cellHeight"] 	= 104,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(395,124),
						["cellWidth"] 	= 160,
						["cellHeight"] 	= 104,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(560,124),
						["cellWidth"] 	= 160,
						["cellHeight"] 	= 104,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(725,124),
						["cellWidth"] 	= 160,
						["cellHeight"] 	= 104,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(890,124),
						["cellWidth"] 	= 160,
						["cellHeight"] 	= 104,
						["symbolCount"] = 4
					},
				}
			}
		}
	}
	self.baseBet = 7500
	self.DelayStopTime = 0
	self.UnderPressure = 1 -- 下压上 控制
	local use_portrait_screen = false
	local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 104
local delay = 0
local upBounce = 0
local upBounceMaxSpeed = 0
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -30*60
local normalSpeed = -30*60
local fastSpeed = -30*60 - 300

local stopDelay = 20/60
local speedDownTime = 60/60
local downBounce = G_cellHeight*2/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 21/60
local specialAniTime = 160/60 
local extraReelTime = 120/60
local spinMinCD = 0.5

-- function cls:getSpinColStartAction( pCol )
-- 	if self.isTurbo then
-- 		maxSpeed = fastSpeed
-- 	else 
-- 		maxSpeed = normalSpeed
-- 	end
-- 	local spinAction = {}
-- 	spinAction.delay = delay*(pCol-1)
-- 	spinAction.upBounce = upBounce
-- 	spinAction.upBounceMaxSpeed = upBounceMaxSpeed
-- 	spinAction.upBounceTime = upBounceTime
-- 	spinAction.speedUpTime = speedUpTime
-- 	spinAction.maxSpeed = maxSpeed

-- 	return spinAction
-- end
 
-- function cls:getSpinColStopAction(themeInfo, pCol, interval)
-- 	local checkNotifyTag   = self:checkNeedNotify(pCol)
-- 	if checkNotifyTag then
-- 		self.DelayStopTime = self.DelayStopTime + extraReelTime
-- 	end

-- 	local spinAction = {}
-- 	spinAction.actions = {}

-- 	local temp = interval - speedUpTime - upBounceTime
-- 	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
-- 	spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime
-- 	self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
	
-- 	spinAction.maxSpeed = maxSpeed
-- 	spinAction.speedDownTime = speedDownTime
-- 	if self.isTurbo then
-- 		spinAction.speedDownTime = spinAction.speedDownTime - 20/60
-- 	end
-- 	spinAction.downBounce = downBounce
-- 	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
-- 	spinAction.downBounceTime = downBounceTime
-- 	spinAction.stopType = 1
-- 	return spinAction
-- end

function cls:initScene(spinNode)
	-- local path = self:getPic("csb/base.csb")
	-- self.mainThemeScene = cc.CSLoader:createNode(path)
	-- self.down_node 		= self.mainThemeScene:getChildByName("down_child")
	-- bole.adaptScale(self.mainThemeScene,false)
	-- -- bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
	-- self.down_child 	= self.down_node:getChildByName("down_child")

	-- self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	-- self.baseBg 		= self.bgRoot:getChildByName("bg_base")
	-- self.freeBg 		= self.bgRoot:getChildByName("bg_free")
	-- self.baseBg:setVisible(true)
	-- self.curBg = self.baseBg
	-- self.freeBg:setVisible(false)
	
	-- self.reelRoot 		= self.down_child:getChildByName("reel_root_node")
	-- self.boardRoot 		= self.down_child:getChildByName("board_root")
	-- self.animateNode 	= self.down_child:getChildByName("anim_panel"):getChildByName("animate_node")	
	-- self.scatterAnimNode = self.down_child:getChildByName("scatter_anim_node")
	-- self.moveWildNode 	= self.down_child:getChildByName("move_node")
	-- self.wildMaskNode 	= self.down_child:getChildByName("wild_mask_node")
	-- self.wildMaskNode:setOpacity(0)

	-- -- freeNode
	-- self.freeNode 	= self.down_child:getChildByName("free_node")
	-- self.bonusWheelNode = self.mainThemeScene:getChildByName("bonus_wheel_node")

	-- -- 初始化jackpot
	-- self.progressiveRoot = self.mainThemeScene:getChildByName("progressive")
	-- local progressive_nodes = self.progressiveRoot:getChildByName("jackpots_labels")-- 初始化jackpot
	-- self.jackpotLabels = {}
	-- for i=1,4 do	
	-- 	self.jackpotLabels[i] = progressive_nodes:getChildByName("label_jp" .. i)
	-- 	self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
	-- 	self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	-- end
	-- self:initialJackpotNode()
	-- -- base 背景 动画
	-- self:addSpineAnimation(self.progressiveRoot, nil, self:getPic("spine/base/jixiangjie_01"), cc.p(0,260), "animation", nil, nil, nil, true, true)

	-- -- map 相关
	-- self.collectFeatureNode = self.down_child:getChildByName("collect_feature_node")

	-- self.lockSuperNode 	= self.collectFeatureNode:getChildByName("lock_map")
	-- local _, s = self:addSpineAnimation(self.lockSuperNode, nil, self:getPic("spine/collect_progress/collect_jiesuotiao"), cc.p(-3,207), "animation3", nil, nil, nil, true)
	-- self.lockSuperSpine = s
	-- self.isLockFeature 	= true
	-- self.bonusflyNode 		= self.down_child:getChildByName("bonus_fly_node")
	-- self.collectPanel 		= self.collectFeatureNode:getChildByName("collect_panel")
	-- self.collectProgress 	= self.collectPanel:getChildByName("progress")
	-- self.collectProgressAni = self.collectFeatureNode:getChildByName("anim_node")
	-- self.baseProgressAniPosX = self.collectProgressAni:getPositionX()
	-- self:addSpineAnimation(self.collectProgress, nil, self:getPic("spine/collect_progress/collect_tiaoef"), cc.p(0,2), "animation", nil, nil, nil, true, true)
	
	-- self.baseMapLoadNode 	= self.mainThemeScene:getChildByName("map_node")
	-- self.showMapBtn 		= self.collectFeatureNode:getChildByName("show_map_btn")
	-- self.collectBtnSpine 	= self.collectFeatureNode:getChildByName("collect_btn_spine")
	
	-- -- spin 计数
	-- self.spinCntRoot = self.down_child:getChildByName("spin_cnt_node")
	-- self.spinCntLb = self.spinCntRoot:getChildByName("spin_cnt")

	self:initDealBonusNode()
	-- self.shakyNode:addChild(self.mainThemeScene)

end

function cls:getJPLabelMaxWidth(index)
	local jackpotLabelMaxWidth = {170,146,132,114}
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end


function cls:refreshColCellsZOrder( pCol )
end

function cls:initBoardNodes(pBoardConfigList)
end

function cls:initDealBonusNode()
	self.dealBonusNode = cc.CSLoader:createNode(self:getPic("csb/map.csb"))
	self.shakyNode:addChild(self.dealBonusNode) -- self.baseMapLoadNode:addChild()
 	self.dealBonusNode:setVisible(false)
	self.theDealNodeRoot 	= self.dealBonusNode:getChildByName("root")
	self.blackBG    	= self.theDealNodeRoot:getChildByName("common_black")
	self.pickItemsNode 	= self.theDealNodeRoot:getChildByName("pick_items")
	self.multItemsNode 	= self.theDealNodeRoot:getChildByName("mult_items")
	self.bonusChooseNode = self.theDealNodeRoot:getChildByName("choose_node")
	self.bonusChooseNode = self.theDealNodeRoot:getChildByName("choose_node")

	self.dealBonusGiftList = {}
	self.dealBonusMultList = {}
	self.dealBonusGiftAniNodeList = {}
	self.dealBonusGiftBtnList = {}
	local pickItems = self.pickItemsNode:getChildren()
	local multItems = self.multItemsNode:getChildren()
	local file = "commonpics/kong.png"
	for i = 1, maxMapLevel do
		local pickTemp = pickItems[i]
		self.dealBonusGiftList[i] = {}
    	local pickTempChilds = pickTemp:getChildren()
    	self.dealBonusGiftList[i].image = pickTempChilds[1]
    	self.dealBonusGiftList[i].label = pickTempChilds[2]:getChildren()[1]
    	self.dealBonusGiftList[i].node 	= pickTemp
    	self.dealBonusGiftList[i].index = i
    	self.dealBonusGiftAniNodeList[i] = pickTempChilds[3]

    	self.dealBonusGiftBtnList[i] = Widget.newButton( nil, file, file, file)
    	pickTemp:addChild(self.dealBonusGiftBtnList[i]) 
    	self.dealBonusGiftBtnList[i]:setScale(13,9.5)

    	local multTemp = multItems[i]
		self.dealBonusMultList[i] = {}
    	local multTempChilds = multTemp:getChildren()
    	self.dealBonusMultList[i].sp = multTempChilds[1]
    	self.dealBonusMultList[i].label = multTempChilds[2]
    	multTempChilds[2]:setString(multiData[i].."X")
    	self.dealBonusMultList[i].node = multTemp
	end

    -- topNode 
    self.dealBonusTopNode = self.theDealNodeRoot:getChildByName("deal_node")
    self.dealBonusGiftTextList = {}
    self.dealBonusGiftTextList["start"] = self.dealBonusTopNode:getChildByName("tip_label3")
    self.dealBonusGiftTextList["start"]:setVisible(false)
    self.dealBonusGiftTextList["choose"] = self.dealBonusTopNode:getChildByName("tip_label1")
    self.dealBonusGiftTextList["choose"].lb =  self.dealBonusGiftTextList["choose"]:getChildByName("tip_label1")
    self.dealBonusGiftTextList["choose"]:setVisible(false)
    self.dealBonusGiftTextList["last"] = self.dealBonusTopNode:getChildByName("tip_label1")
    self.dealBonusGiftTextList["last"]:setVisible(false)
    self.dealBonusGiftTextList["tip"] = self.dealBonusTopNode:getChildByName("tip_label2")
    self.dealBonusTopPrizeLable = self.dealBonusTopNode:getChildByName("prize_lable")
    self.dealBonusYourBoxNode = self.dealBonusTopNode:getChildByName("your_box_node")
    self.dealBonusYourBoxNode:setVisible(false)
    self.dealBonusYourBoxLabel = self.dealBonusYourBoxNode:getChildByName("cnt_label")

    self.dealBonusBaseExplain = self.theDealNodeRoot:getChildByName("explain_node")

    self.dealBonusRoundTipNode = self.theDealNodeRoot:getChildByName("tip_board")
    self.dealBonusRoundTipNode:setVisible(false)
    self.dealBonusRoundTipList = {}
    for i = 1,2 do
    	self.dealBonusRoundTipList[i] = {}
    	self.dealBonusRoundTipList[i].node = self.dealBonusRoundTipNode:getChildByName("type"..i)
    	self.dealBonusRoundTipList[i].node:setVisible(false)
    	if i == 1 then
    		self.dealBonusRoundTipList[i].labelRoundCount = self.dealBonusRoundTipList[i].node:getChildByName("round_num")
    		self.dealBonusRoundTipList[i].labelPickCount = self.dealBonusRoundTipList[i].node:getChildByName("gitf_cnt")
    	end
    end

    self.dealBonusOpenGiftNode = self.theDealNodeRoot:getChildByName("open_gift_node")
    self.dealBonusOpenGiftNode:setVisible(false)
    self.dealBonusOpenGiftBoxNode = self.dealBonusOpenGiftNode:getChildByName("box_node")
    self.dealBonusOpenGiftBoxNode:setCascadeOpacityEnabled(true)
    self.dealBonusOpenGiftBoxBgAniNode = self.dealBonusOpenGiftNode:getChildByName("box_bg_node")
    self.dealBonusOpenGiftBoxBgAniNode:setCascadeOpacityEnabled(true)
    self.dealBonusOpenGiftBoxImage = self.dealBonusOpenGiftBoxNode:getChildByName("box")
    self.label_dealBonusOpenGiftNum = self.dealBonusOpenGiftBoxNode:getChildByName("label_cnt")
    self.label_dealBonusOpenMulti = self.dealBonusOpenGiftBoxNode:getChildByName("label_mul")
    self.label_dealBonusOpenMulti:setScale(0)
    self.label_dealBonusOpenMulti:setVisible(false)

	self.btn_dealBonusClose = self.theDealNodeRoot:getChildByName("close_btn")

    self.isDealBoardOpen = false

    self.dealBonusDimmer = self.theDealNodeRoot:getChildByName("dimmer")
    self.dealBonusDimmer:setVisible(false)

    -- offerNode
    self.dealbonusOfferNode = self.theDealNodeRoot:getChildByName("choose_node")
    self.dealbonusOfferNode:setVisible(false)
    self.label_offerMul = self.dealbonusOfferNode:getChildByName("label_mul")
    self.label_offerWin = self.dealbonusOfferNode:getChildByName("label_win")
    self.btn_offerTakeIt = self.dealbonusOfferNode:getChildByName("btn1")
    self.btn_offerLeaveIt = self.dealbonusOfferNode:getChildByName("btn2")
    self.dealbonusOfferDealLabels = self.dealbonusOfferNode:getChildByName("deal_labels"):getChildren()
    self.dealBonusOfferCharacterNode = self.dealbonusOfferNode:getChildByName("logo_sp")

    -- lastOfferNode 
    self.dealBonusLastOfferNode = self.theDealNodeRoot:getChildByName("last_choose_node")
    self.dealBonusLastOfferNode:setVisible(false)
    self.dealBonusLastOfferBoxLeft = self.dealBonusLastOfferNode:getChildByName("box_left")
    self.label_lastOfferNumLeft = self.dealBonusLastOfferBoxLeft:getChildByName("label_num1")
    self.dealBonusLastOfferBoxRight = self.dealBonusLastOfferNode:getChildByName("box_right")
    self.label_lastOfferNumRight = self.dealBonusLastOfferBoxRight:getChildByName("label_num2")
    self.btn_lastOfferKeepIt = self.dealBonusLastOfferNode:getChildByName("btn1")
    self.btn_lastOfferTradeIt = self.dealBonusLastOfferNode:getChildByName("btn2")
    self.dealBonusLastOfferDealLabel = self.dealBonusLastOfferNode:getChildByName("deal_label")
    self.label_dealBonusLastOfferMul = self.dealBonusLastOfferNode:getChildByName("label_mul")
    self.label_dealBonusLastOfferMul:setVisible(false)
    self.dealBonusLastBoxAniNode = self.dealBonusLastOfferNode:getChildByName("box_ani_node")
    self.dealBonusLastDimmer = self.dealBonusLastOfferNode:getChildByName("dimmer_last")
	self.dealBonusLastDimmer:setVisible(false)
	self.dealBonusLastOfferCharacterNode = self.dealBonusLastOfferNode:getChildByName("logo_sp")

    -- 显示 offer 之前的 提示 弹板
    self.showOfferDialogRoot 	= self.theDealNodeRoot:getChildByName("show_offer_dialog_root")
    self.showOfferDialog 		= self.showOfferDialogRoot:getChildByName("show_offer_dialog")
    self.showOfferBtn 			= self.showOfferDialog:getChildByName("btn_open_offer")
    self.offerTipJumpNode 		= self.showOfferDialog:getChildByName("jump_node")
    self.showOfferDialogRoot:setVisible(false)
end

function cls:initSpinLayer( )
	-- self.spinLayerList = {}
	-- for index,cofig in ipairs(self.boardNodeList) do
	-- 	self.initBoardIndex = index
	-- 	local boardNode = self.boardNodeList[index]
	-- 	local layer = SpinLayer.new(self, self.ctl,boardNode.reelConfig,boardNode)
	-- 	layer:DeActive()
	-- 	self.shakyNode:addChild(layer,-1)
	-- 	table.insert(self.spinLayerList,layer)
	-- end
	-- self.initBoardIndex = nil
	-- self.spinLayer = self.spinLayerList[1]
	-- self.spinLayer:Active()
end

function cls:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {}, -- "grand", "major", "minor", "mini"
		allowK = {[3142] = false}
	}
	return jackpot_config_list
end

-- function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
-- 	if theCellNode.symbolTipAnim then 
-- 		if (not tolua.isnull(theCellNode.symbolTipAnim)) then 
-- 			theCellNode.symbolTipAnim:removeFromParent()
-- 		end
-- 		theCellNode.symbolTipAnim = nil 
-- 	end
-- end

-- function cls:createCellSprite(key, col, rowIndex)
-- 	self.initialPics = self.initialPics or {}
-- 	if self.specialItemConfig[key] then
-- 		local colSet = self.specialItemConfig[key]["col_set"] or {}
-- 		if colSet[col] then
-- 			if colSet[col] == 0 then
-- 				key = self:getNormalKey(col)
-- 			elseif colSet[col] == 1 then
-- 				if self.initialPics[col] then
-- 					key = self:getNormalKey(col)
-- 				else
-- 					self.initialPics[col] = true
-- 				end
-- 			end
-- 		end
-- 	end
-- 	------------------------------------------------------------
-- 	if key == specialSymbol.blank then 
-- 		key = self.normalKeyList[math.random(1,#self.normalKeyList)]
-- 	end
-- 	theCellFile = self.pics[key]
-- 	local theCellNode   = cc.Node:create()
	
-- 	local theCellSprite = bole.createSpriteWithFile(theCellFile)
-- 	theCellNode:addChild(theCellSprite)
-- 	theCellNode.key 	  = key
-- 	theCellNode.sprite 	  = theCellSprite
-- 	theCellNode.curZOrder = 0
-- 	------------------------------------------------------------
-- 	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
-- 	local theKey = theCellNode.key
-- 	if self.symbolZOrderList[theKey] then
-- 		theCellNode.curZOrder = self.symbolZOrderList[theKey]
-- 	end
-- 	if self.symbolPosAdjustList[theKey] then
-- 		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
-- 	end
-- 	return theCellNode
-- end

-- function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
-- 	if not isReset then 
-- 		local previousCell = self.spinLayer.spins[col]:getPreviousCellByIndex(theCellNode.cell_index) -- 下面的一个 symbol
-- 		if longSymbol.l1 == key or longSymbol.l2 == key or longSymbol.l3 == key then 
-- 			if previousCell.key ~= key+1 then
-- 				key = self:getNormalKey()
-- 			end
-- 		elseif longSymbol.l2 == previousCell.key or longSymbol.l3 == previousCell.key or longSymbol.l4 == previousCell.key then
-- 			if previousCell.key-1 ~= key then 
-- 				key = previousCell.key-1
-- 			end
-- 		end
-- 	end

-- 	local theCellFile = self.pics[key]
-- 	if not theCellFile then 
-- 		print("whj: key, theCellFile", key, theCellFile)
-- 	end
-- 	local theCellSprite = theCellNode.sprite
-- 	bole.updateSpriteWithFile(theCellSprite, theCellFile)
-- 	theCellNode.key 	  = key
-- 	theCellNode.curZOrder = 0

-- 	------------------------------------------------------------
-- 	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
-- 	local theKey = theCellNode.key
-- 	if self.symbolZOrderList[theKey] then
-- 		theCellNode.curZOrder = self.symbolZOrderList[theKey]
-- 	end	
-- 	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
-- 	if self.symbolPosAdjustList[theKey] then
-- 		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
-- 	else
-- 		theCellSprite:setPosition(cc.p(0,0))
-- 	end	
-- end

function cls:adjustEnterThemeRet(data)
	data.theme_reels = {
		["main_reel"] = {
			[1] = {3,3,8,9,4,4,10,11,5,5,12,13,6,6,8,9,7,7,10,14,11,12,24,23,22,21,13,8,15,15,9,3,4,10,11,3,5,12,13,3,6,8,9,3,7,10,15,15,11,4,5,14,12,13,4,6,8,9,4,7,10,11,5,6,12,13,5,7,15,15,8,9,6,7,10,11,12,24,23,22,21,13,14,8,9,3,10,4,15,11,3,12,5,13,3,8,6,9,3,10,7,15,11,4,12,5,13,4,8,6,9,4,10,7,11,5,12,6,13,5,8,7,15,9,6,10,7,11,12,13},
			[2] = {3,3,13,12,4,4,11,10,5,5,9,8,6,6,13,12,7,7,11,14,10,9,24,23,22,21,8,13,15,15,12,3,4,11,10,3,5,9,8,3,6,13,12,3,7,11,15,15,10,4,5,14,9,8,4,6,13,12,4,7,11,10,5,6,9,8,5,7,15,15,13,12,6,7,11,10,9,24,23,22,21,8,14,13,12,3,11,4,15,10,3,9,5,8,3,13,6,12,3,11,7,15,10,4,9,5,8,4,13,6,12,4,11,7,10,5,9,6,8,5,13,7,15,12,6,11,7,10,9,8},
			[3] = {3,3,8,9,4,4,10,11,5,5,12,13,6,6,8,9,7,7,10,14,11,12,24,23,22,21,13,8,15,15,9,3,4,10,11,3,5,12,13,3,6,8,9,3,7,10,15,15,11,4,5,14,12,13,4,6,8,9,4,7,10,11,5,6,12,13,5,7,15,15,8,9,6,7,10,11,12,24,23,22,21,13,14,8,9,3,10,4,15,11,3,12,5,13,3,8,6,9,3,10,7,15,11,4,12,5,13,4,8,6,9,4,10,7,11,5,12,6,13,5,8,7,15,9,6,10,7,11,12,13},
			[4] = {3,3,13,12,4,4,11,10,5,5,9,8,6,6,13,12,7,7,11,14,10,9,24,23,22,21,8,13,15,15,12,3,4,11,10,3,5,9,8,3,6,13,12,3,7,11,15,15,10,4,5,14,9,8,4,6,13,12,4,7,11,10,5,6,9,8,5,7,15,15,13,12,6,7,11,10,9,24,23,22,21,8,14,13,12,3,11,4,15,10,3,9,5,8,3,13,6,12,3,11,7,15,10,4,9,5,8,4,13,6,12,4,11,7,10,5,9,6,8,5,13,7,15,12,6,11,7,10,9,8},
			[5] = {3,3,8,9,4,4,10,11,5,5,12,13,6,6,8,9,7,7,10,14,11,12,24,23,22,21,13,8,15,15,9,3,4,10,11,3,5,12,13,3,6,8,9,3,7,10,15,15,11,4,5,14,12,13,4,6,8,9,4,7,10,11,5,6,12,13,5,7,15,15,8,9,6,7,10,11,12,24,23,22,21,13,14,8,9,3,10,4,15,11,3,12,5,13,3,8,6,9,3,10,7,15,11,4,12,5,13,4,8,6,9,4,10,7,11,5,12,6,13,5,8,7,15,9,6,10,7,11,12,13},
		},
		["free_reel"] = {
			[1] = {3,3,8,9,4,4,10,11,5,5,12,13,6,6,8,9,7,7,10,14,11,12,24,23,22,21,13,8,9,3,4,10,11,3,5,12,13,3,6,8,9,3,7,10,11,4,5,14,12,13,4,6,8,9,4,7,10,11,5,6,12,13,5,7,8,9,6,7,10,11,12,24,23,22,21,13,14,8,9,3,10,4,11,3,12,5,13,3,8,6,9,3,10,7,11,4,12,5,13,4,8,6,9,4,10,7,11,5,12,6,13,5,8,7,9,6,10,7,11,12,13},
			[2] = {3,3,13,12,4,4,11,10,5,5,9,8,6,6,13,12,7,7,11,14,10,9,24,23,22,21,8,13,12,3,4,11,10,3,5,9,8,3,6,13,12,3,7,11,10,4,5,14,9,8,4,6,13,12,4,7,11,10,5,6,9,8,5,7,13,12,6,7,11,10,9,24,23,22,21,8,14,13,12,3,11,4,10,3,9,5,8,3,13,6,12,3,11,7,10,4,9,5,8,4,13,6,12,4,11,7,10,5,9,6,8,5,13,7,12,6,11,7,10,9,8},
			[3] = {3,3,8,9,4,4,10,11,5,5,12,13,6,6,8,9,7,7,10,14,11,12,24,23,22,21,13,8,9,3,4,10,11,3,5,12,13,3,6,8,9,3,7,10,11,4,5,14,12,13,4,6,8,9,4,7,10,11,5,6,12,13,5,7,8,9,6,7,10,11,12,24,23,22,21,13,14,8,9,3,10,4,11,3,12,5,13,3,8,6,9,3,10,7,11,4,12,5,13,4,8,6,9,4,10,7,11,5,12,6,13,5,8,7,9,6,10,7,11,12,13},
			[4] = {3,3,13,12,4,4,11,10,5,5,9,8,6,6,13,12,7,7,11,14,10,9,24,23,22,21,8,13,12,3,4,11,10,3,5,9,8,3,6,13,12,3,7,11,10,4,5,14,9,8,4,6,13,12,4,7,11,10,5,6,9,8,5,7,13,12,6,7,11,10,9,24,23,22,21,8,14,13,12,3,11,4,10,3,9,5,8,3,13,6,12,3,11,7,10,4,9,5,8,4,13,6,12,4,11,7,10,5,9,6,8,5,13,7,12,6,11,7,10,9,8},
			[5] = {3,3,8,9,4,4,10,11,5,5,12,13,6,6,8,9,7,7,10,14,11,12,24,23,22,21,13,8,9,3,4,10,11,3,5,12,13,3,6,8,9,3,7,10,11,4,5,14,12,13,4,6,8,9,4,7,10,11,5,6,12,13,5,7,8,9,6,7,10,11,12,24,23,22,21,13,14,8,9,3,10,4,11,3,12,5,13,3,8,6,9,3,10,7,11,4,12,5,13,4,8,6,9,4,10,7,11,5,12,6,13,5,8,7,9,6,10,7,11,12,13},
		},
	}

	return data
end

--------------------------------------------------------------------------------
-- function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
-- 	self:clearAnimate()

-- 	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
-- 		self.showFreeSpinBoard = false
-- 		self.showBaseSpinBoard = true
-- 		if self.spinLayer ~= self.spinLayerList[1] then
-- 			self.spinLayer:DeActive()
-- 			self.spinLayer = self.spinLayerList[1]
-- 			self.spinLayer:Active()
-- 		end
-- 		self.collectFeatureNode:setVisible(true)
-- 		self.freeNode:setVisible(false)
-- 		self.spinCntRoot:setVisible(true)

-- 		if self.curBg ~= self.baseBg then 
-- 			self.curBg:setVisible(false)
-- 			self.baseBg:setVisible(true)
-- 			self.curBg = self.baseBg
-- 		end
-- 	elseif pType == SpinBoardType.FreeSpin then
-- 		self.showFreeSpinBoard = true
-- 		self.showBaseSpinBoard = false
-- 		if self.spinLayer ~= self.spinLayerList[1] then
-- 			self.spinLayer:DeActive()
-- 			self.spinLayer = self.spinLayerList[1]
-- 			self.spinLayer:Active()
-- 		end
-- 		self.collectFeatureNode:setVisible(false)
-- 		self.freeNode:setVisible(true)
-- 		self.spinCntRoot:setVisible(false)
-- 		if self.curBg ~= self.freeBg then 
-- 			self.curBg:setVisible(false)
-- 			self.freeBg:setVisible(true)
-- 			self.curBg = self.freeBg
-- 		end
-- 	end
-- end

------------ map 相关 ------------------------ 
-- function cls:enableMapInfoBtn(enable)
-- 	self.showMapBtn:setVisible(true)
-- 	self.showMapBtn:setTouchEnabled(enable)
-- 	self.showMapBtn:setBright(enable)
-- end

function cls:setDealBonusGiftData(mapLevel,isLevelUp)
	local level = mapLevel 
	if not level then
		if isLevelUp then 
			level = self.mapLevel and (self.mapLevel - 1) or 0
		else
			level = self.mapLevel and self.mapLevel or 0
		end
	end

	self:resetGiftList()
	if level > 0 then
        for i = 1,level do
        	self.dealBonusGiftList[i].node:setVisible(true)
	    	self.dealBonusGiftList[i].label:setString(i)
	    end
	end	
end

function cls:setDisplayStarState(index,state)
	if multState.disable == state then -- 显示 为不可用(不在bonus 里面)
		self.dealBonusMultList[index].node:setOpacity(150)
		self.dealBonusMultList[index].sp:setColor(cc.c3b(255,255,255))
    	self.dealBonusMultList[index].label:setColor(cc.c3b(255,255,255))
    elseif multState.normal == state then -- 显示 可用(在bonus 里面)
    	self.dealBonusMultList[index].node:setOpacity(255)
    	self.dealBonusMultList[index].sp:setColor(cc.c3b(255,255,255))
    	self.dealBonusMultList[index].label:setColor(cc.c3b(255,255,255))
    elseif multState.dim == state then -- 显示 不可用(在bonus 里面)
    	self.dealBonusMultList[index].node:setOpacity(255)
    	self.dealBonusMultList[index].sp:setColor(cc.c3b(84,84,84))
    	self.dealBonusMultList[index].label:setColor(cc.c3b(100,100,100))
    end
end

function cls:resetGiftList()
	for i = 1,maxMapLevel do
		self.dealBonusGiftList[i].node:setVisible(false)
		self.dealBonusGiftList[i].image:setColor(cc.c3b(255,255,255))
    	self.dealBonusGiftList[i].label:setString(i)
    end
end

function cls:resetAllStarState()
	for i = 1,maxMapLevel do
    	self.dealBonusMultList[i].label:setString(multiData[i].."X")
    end
end

function cls:showGiftCollectedAnimation(mapLevel)
	mapLevel = mapLevel or 1
	if mapLevel == 0 then mapLevel = 1 end
	local file = self:getPic("spine/deal_bonus/bouns_bx_01")
	local parent = self.dealBonusGiftAniNodeList[mapLevel]
	self:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation1")
	self.dealBonusGiftList[mapLevel].node:setScale(0)
	self.dealBonusGiftList[mapLevel].node:setVisible(true)
	self.dealBonusGiftList[mapLevel].label:setString(mapLevel)
	self.dealBonusGiftList[mapLevel].node:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.3,1.5),
		cc.ScaleTo:create(0.15,1)
	))
	self:playMusic(self.audio_list.treasure_out)
	
	return 0.45
end

function cls:setDealBonusScene(mapLevel,isLevelUp,isDeal)
	local level = mapLevel or self.mapLevel
	if isLevelUp and level > 0 then
		level = level - 1
	end
	self:setDealBonusGiftData(level,isLevelUp)
	self:resetAllStarState()
	
	if isDeal then 
		for i = 1,maxMapLevel do
			self:setDisplayStarState(i,multState.normal)
		end
	else
		for i = 1,maxMapLevel do
			self:setDisplayStarState(i,multState.disable)
		end
		if isLevelUp then
			self.dealBonusOpenGiftNode:setVisible(false)
		end
	end
end

function cls:showDealBonusSceneAnimation(mapLevel, isLevelUp, isDeal)
	self:enableMapInfoBtn(false)
	self:setDealBonusScene(mapLevel,isLevelUp,isDeal)
	self.dealBonusNode:setOpacity(0)
	self.dealBonusNode:setVisible(true)
	-- self:playMusic(self.audio_list.bonus_open)
	self.dealbonusOfferNode:setVisible(false)
	self.dealBonusLastOfferNode:setVisible(false)
	if isDeal then
		self.dealBonusTopNode:setVisible(true)
		self.dealBonusTopNode:setOpacity(255)
		self.dealBonusBaseExplain:setVisible(false)
		self.dealBonusYourBoxNode:setVisible(false)
	  	self.dealBonusNode:runAction(cc.FadeIn:create(0.3))
	else
		self.dealBonusTopNode:setVisible(false)
		self.dealBonusBaseExplain:setVisible(true)
		self.dealBonusNode:runAction(cc.Sequence:create(
			cc.FadeIn:create(0.3),
			cc.CallFunc:create(function( ... )
				self.btn_dealBonusClose:setBright(true)
				self.btn_dealBonusClose:setTouchEnabled(true)
				self:initDealBonusCloseEvent()
			end)
		))
	end
	self.isDealBoardOpen = true
end

function cls:initDealBonusCloseEvent(isLevelUpBonus)
	self.isDealBonusClosePress = false
	-- 点击按钮
	local pressFunc = function(obj)
		self.isDealBonusClosePress = true
        self.btn_dealBonusClose:setTouchEnabled(false)
        self.btn_dealBonusClose:setBright(false)
        self:playMusic(self.audio_list.common_click)
        self:hideDealBonusSceneAnimation(isLevelUpBonus)
	end

	local function onTouch(obj, eventType)
		if self.isDealBonusClosePress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end
	-- 设置按钮
	self.btn_dealBonusClose:addTouchEventListener(onTouch)
end

function cls:hideDealBonusSceneAnimation(isLevelUpBonus)
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.dealBonusNode:runAction(cc.FadeOut:create(0.3))
			self.btn_dealBonusClose:setBright(false)
			self.btn_dealBonusClose:setTouchEnabled(false)
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function( ... )
			self.dealBonusNode:setVisible(false)
			self:enableMapInfoBtn(true)
			if isLevelUpBonus then
				self.ctl:handleResult()
			end
		end)
	))
	self.isDealBoardOpen = false
end

function cls:clearNeedCollectCoinsBonus( ... )
	if self.bonus and self.bonus.bonusType == BonusGameType.deal then
		self.bonus:exitDealBonus()
	end
end

-------------------------- 断线重连 ----------------------------

function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl.isProcessing  = true

	self:checkIsNewBonusAndChangeData(theBonusGameData)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:checkIsNewBonusAndChangeData( theBonusGameData )
	local localBonusData = LoginControl:getInstance():getBonus(self.themeid) -- 
	-- if localBonusData then
	-- 	print("whj: localBonusData.local_deal_list ", tool.lua_to_json(localBonusData.local_deal_list))
	-- 	print("whj: theBonusGameData.deal_list ", tool.lua_to_json(theBonusGameData.deal_list))
	-- end
	if not localBonusData or not tool.isEqTwoTable(localBonusData.local_deal_list, theBonusGameData.deal_list)  then 
		-- print("whj: 需要 置空")
		LoginControl:getInstance():saveBonus(self.themeid, nil)
	-- else
	-- 	print("whj: 不需要 置空")
	end
end

function cls:overBonusByEndGame(data) -- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面
	if data.total_win then 
		self.ctl.totalWin = data.total_win
	end
	if data.jp_win then
		for k,v in pairs(data.jp_win) do 
			if v.jp_win then 
				self.ctl.totalWin = self.ctl.totalWin +  v.jp_win
			end
		end
	end
	self.ctl.isProcessing  = false
	if self.showFreeSpinBoard or self.ctl.freewin then
		self.ctl.totalWin = self.ctl.freewin + self.ctl.totalWin
		self.ctl.freewin = self.ctl.totalWin
		self.ctl:updateFooterCoin()

	else
		self:unlockLobbyBtn()
		self.ctl:removePointBet()
		self.ctl:updateFooterCoin()
		self.ctl:addCoinsToHeader()
	end
end
------------------------------- 声音相关 ---------------------------------------------

function cls:configAudioList( )
	Theme.configAudioList(self)

	self.audio_list = self.audio_list or {}
	-- bonus
	self.audio_list.common_click 	= "audio/bonus/common_click.mp3" 	-- 通用点击
	
	self.audio_list.bonus_fake 		= "audio/bonus/bonus_fake.mp3"		-- 破碎+出现新的倍数
	self.audio_list.mystery_guest 	= "audio/bonus/mystery_guest.mp3"	-- 神秘嘉宾，财神切换成财神小孙
	self.audio_list.offer_off 		= "audio/bonus/offer_off.mp3" 		-- offer消失，配合动画
	self.audio_list.offer_open 		= "audio/bonus/offer_open.mp3"		-- offer打开，配合动画
	self.audio_list.treasure_click 	= "audio/bonus/treasure_click.mp3"	-- 选中宝箱
	self.audio_list.treasure_dialog_round 	= "audio/bonus/treasure_dialog_round.mp3"	-- 小弹板出现音效
	self.audio_list.treasure_final 	= "audio/bonus/treasure_final.mp3"	-- 最后礼物盒移动到中间，打开，配合动画
	self.audio_list.treasure_fly 	= "audio/bonus/treasure_fly.mp3"	-- 小宝箱向左下飞+停住
	self.audio_list.treasure_open 	= "audio/bonus/treasure_open.mp3"	-- 礼物盒打开+出现倍数
	self.audio_list.treasure_out 	= "audio/bonus/treasure_out.mp3"	-- 小宝箱出现，强烈
end

function cls:getLoadMusicList()
	local loadMuscList = {
		self.audio_list.common_click,

		self.audio_list.bonus_fake,
		self.audio_list.mystery_guest,
		self.audio_list.offer_off,
		self.audio_list.offer_open,
		self.audio_list.treasure_click,
		self.audio_list.treasure_dialog_round,
		self.audio_list.treasure_final,
		self.audio_list.treasure_fly,
		self.audio_list.treasure_open,
		self.audio_list.treasure_out,

	}
	return loadMuscList
end

-- 播放bonus game的背景音乐
function cls:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.bonus_background)
	AudioControl:volumeGroupAudio(1)
end

function cls:onExit( )
	if self.shaker then
		self.shaker:stop()
	end
	Theme.onExit(self)
end

--------------------------------- LockRespin && Bonus ---------------------------------

ThemeActivityMammonBonusGame = class("ThemeActivityMammonBonusGame")
local bonusGame = ThemeActivityMammonBonusGame

function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.oldCallBack 	= callback
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl

	self:saveBonus()
end

function bonusGame:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function bonusGame:enterBonusGame( tryResume )
	self.theme.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮

	self.bonusType 		= self.data.core_data.type -- type1对应repsin type2对应 deal game type3对应 level
	
	if tryResume then
		self.callback = function ( ... )
        	-- 断线重连回调方法
        	local endCallFunc2 = function ( ... )
	        	-- if self.ctl:noFeatureLeft() then 
	        	-- 	self.theme.ctl.footer:setSpinButtonState(false)
	        	-- end
        		if self.oldCallBack then 
        			self.oldCallBack()
        		end
        		self.theme.ctl.footer:setSpinButtonState(true)
        		self.theme:lockLobbyBtn()
        		self.theme.ctl:lockThemeFooter()
        		self.ctl.isProcessing = false
        	end
	        endCallFunc2()
        end
		self.ctl.isProcessing = true
	end

	if self.bonusType == BonusGameType.deal then	
		self:enterPlayDealBonusGame(tryResume)
	end
end
---------------------------- bonus -> deal  相关逻辑 start --------------------------------------
local roundBonusStateList =
{
	waiting = 1,
	choosing = 2,
	show_result = 3,
	get_result = 4,
	finish = 5
}

-- deal bonus game 
function bonusGame:enterPlayDealBonusGame(tryResume)
	self:initDealBonusData()
	local function snapIntro()
		self.theme.dealBonusTopPrizeLable:setString(FONTS.formatByCount4(self.avg_bet,4,true))
		self:showPlayDealBonusGameScene()
		local function recoverDealBonusCollectState()
			self:setPickedGiftState(self.data.playRound)
			self:showYourGiftMessage(false,false)
			self.dealBonusWin = self.dealBonusWinList[self.data.playRound-1]
			self:showDealBonusCollectBoard(true)
		end
	
		if self.data.gameEnd then
			recoverDealBonusCollectState()
			self:showTipTitleState("tip")
		else
			self.theme:dealMusic_EnterBonusGame()
			if self.data.playRound == 7 then
				self:setPickedGiftState(self.data.playRound-1)
				self:showYourGiftMessage(false,false,true)
				self:showLastOfferBoard(false)
			elseif self.data.playRound == 1 then
				if self.data.roundState[self.data.playRound] == roundBonusStateList.waiting then
					self:activeGiftsBtn()
					self:showYourGiftMessage(true,false)
					self:showTipTitleState("start")
				else
					self:showYourGiftMessage(false,false,true)
					self.data.playRound = self.data.playRound + 1
					self:saveBonus()					
					self:playNextRound()
				end
			else
				self:setPickedGiftState(self.data.playRound-1)
				self:showYourGiftMessage(false,false,true)
				if self.data.roundState[self.data.playRound] == roundBonusStateList.waiting then
					self:playNextRound()
					self:showTipTitleState("choose")
				elseif self.data.roundState[self.data.playRound] == roundBonusStateList.choosing then
					self:recoverChoosedGiftState()
					self:activeGiftsBtn()
					self:showTipTitleState("choose")
				elseif self.data.roundState[self.data.playRound] == roundBonusStateList.show_result then
					self:recoverChoosedGiftState()
					self:displayThisRoundPickResult(true)
					self:showTipTitleState("tip")
				elseif self.data.roundState[self.data.playRound] == roundBonusStateList.get_result then
					self:setPickedGiftState(self.data.playRound)
					self:showNormalOfferAnimaton()
					self:showTipTitleState("tip")
				end
			end		
		end
	end

	snapIntro()
end

function bonusGame:initDealBonusData( ... )
	self.mapLevel = self.data.core_data["map_level"]
	self.data.mulStarList = self.data.mulstar or {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
	self.data.giftList = self.data.giftList or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} -- 0:unfold other:choosed (according to self.data.playRound)
	self.data.pickedCount = self.data.pickedCount or 0
	self.data.playRound = self.data.playRound or 1
	self.data.eachRoundRemainingCount = self.data.eachRoundRemainingCount or tool.tableClone(roundPickCnt)
	self.data.eachRoundPickedCount = self.data.eachRoundPickedCount or {0,0,0,0,0,0,0}
	self.data.recordList = self.data.recordList or {0,0,0,0,0}
	self.data.choosedGiftIndex = self.data.choosedGiftIndex or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	self.data.roundState = self.data.roundState or {1,1,1,1,1,1}
	self.data.gameEnd = self.data.gameEnd or false
	self.data.local_deal_list = tool.tableClone(self.data.core_data["deal_list"])
	self:saveBonus()

	self.avg_bet = self.data.core_data["avg_bet"]
	self.roundPickCountList = {1,5,4,4,3,2,1}
	self.pickFromToList = {[1] = {maxMapLevel,maxMapLevel},[2] = {1,5},[3] = {6,9},[4] = {10,13},[5] = {14,16},[6] = {17,18},[7] = {19,19}}
	self.multiList = self.data.core_data["multi_list"]
	self.bestDeal = self.data.core_data["best_deal"]
	self.dealList = self.data.core_data["deal_list"]
	self.fakeList = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	self.previousWin = self.ctl.totalWin or 0
	local fake_list = self.data.core_data["fake_list"]

	for i, index in pairs(fake_list) do 
		if i < 3 then
			self.fakeList[index] = 1000
		else
			self.fakeList[index] = 750
		end
	end
	self.dealBonusWinList = self.data.core_data["win_list"]
end

function bonusGame:stopDealBoardAnimation( node )
	node:removeAllChildren()
end

function bonusGame:recoverChoosedGiftState()
	local file = self.theme:getPic("spine/deal_bonus/bouns_bx_02")
	local pickIndexBegin = self.pickFromToList[self.data.playRound][1]
	local pickIndexEnd = self.pickFromToList[self.data.playRound][2]
	for i = pickIndexBegin,pickIndexEnd do
		local index = self.data.choosedGiftIndex[i]
		if index > 0 then
		   self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[index],nil,file,cc.p(0,0),"animation2",nil,nil,nil,true,true,false)
		   self.theme.dealBonusGiftList[index].image:setColor(cc.c3b(175,175,175))
		end
	end	
end

function bonusGame:setPickedGiftState(playRound)
	if playRound >= 2 then
		for i = 1, maxMapLevel do
			if self.data.giftList[i] > 1 then
				if self.data.giftList[i] <= playRound then
					self.theme.dealBonusGiftList[i].node:setVisible(false)
					self.theme.dealBonusGiftList[i].label:setString(i)				
				end
			end
		end

		local mulEndIndex = self.pickFromToList[playRound][2]
		for i = 1,mulEndIndex do -- 设置选择完成的是 灰色的状态
			local mul = self.multiList[i]
			local labelIndex = multiValueIndexConfig[mul]
			local temp = self.theme.dealBonusMultList[labelIndex]

			temp.node:setOpacity(255)
	    	temp.sp:setColor(cc.c3b(84,84,84))
	    	temp.label:setColor(cc.c3b(100,100,100))
			temp.label:setString(mul.."X")
		end
	end
end

function bonusGame:showStartDealBonusGame()
	local csbPath = self.theme:getPic("csb/deal_dialog.csb")
	local dialog 		= cc.CSLoader:createNode(csbPath)
	local rootNode 		= dialog:getChildByName("root")
	local showNode 		= rootNode:getChildByName("node_start")
	rootNode:getChildByName("node_collect"):setVisible(false)
	local startBtn 		= showNode:getChildByName("start_btn")

	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(csbPath)
		dialog:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end

	self.theme.curScene:addToContentFooter(dialog)
	self.theme:playMusic(self.theme.audio_list.bonus_start_show)
	playLine(0, 30)

	-- -- 播放spine 动画
	local size = startBtn:getContentSize()
	self.theme:addSpineAnimation(startBtn, nil, self.theme:getPic("spine/dialog/anniuliuguang_01"), cc.p(size.width/2,size.height/2), "animation1", nil, nil, nil, true, true)-- 添加特效
	
	self.theme:addSpineAnimation(showNode, nil, self.theme:getPic("spine/dialog/guajian_b"), cc.p(0,0), "animation", nil, nil, nil, true,true)
	self.theme:addSpineAnimation(showNode, nil, self.theme:getPic("spine/dialog/yingwenzi"), cc.p(-1,116), "animation", nil, nil, nil, true,true)
	
	local clickEndFunction = function ( ... )
		startBtn:setTouchEnabled(false)
		startBtn:setBright(false)

		playLine(60, 90)
		self.theme:playMusic(self.theme.audio_list.common_click)
		dialog:runAction(cc.Sequence:create(
			cc.DelayTime:create(1), 
			cc.CallFunc:create(function ( ... )
				self:showTipTitleState("start")	    
				self:activeGiftsBtn()
				self.theme:dealMusic_EnterBonusGame()
			end), 
			cc.RemoveSelf:create()))
	end

	dialog:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5), 
		cc.CallFunc:create(function ()
			startBtn:addTouchEventListener(clickEndFunction)
		end)))
end

function bonusGame:showPlayDealBonusGameScene()
	for i = 1,maxMapLevel do
		local mul = multiData[i]
		self.theme.dealBonusMultList[i].label:setString(mul.."X")
		if self.data.mulStarList[i] then -- 设置 还没有获取的 mul 为正常颜色
    		local temp = self.theme.dealBonusMultList[i]
    		temp.node:setOpacity(255)
	    	temp.sp:setColor(cc.c3b(255,255,255))
	    	temp.label:setColor(cc.c3b(255,255,255))
		else
			local temp = self.theme.dealBonusMultList[i]
			temp.node:setOpacity(255)
	    	temp.sp:setColor(cc.c3b(84,84,84))
	    	temp.label:setColor(cc.c3b(100,100,100))
		end

		if self.data.giftList[i] == 0 or self.data.giftList[i] > 1 then
			self.theme.dealBonusGiftList[i].node:setVisible(true)
			self.theme.dealBonusGiftList[i].label:setString(i)
			self.theme.dealBonusGiftList[i].image:setColor(cc.c3b(255,255,255))
		else
			self.theme.dealBonusGiftList[i].node:setVisible(false)
		end
	end

	self.theme.dealBonusNode:setOpacity(255)
	self.theme.dealBonusNode:setVisible(true)
	self.theme.dealBonusTopNode:setVisible(true)
	self.theme.dealBonusTopNode:setOpacity(255)
	self.theme.dealBonusBaseExplain:setVisible(false)
	self.theme.dealBonusYourBoxNode:setVisible(false)
	self.theme.dealbonusOfferNode:setVisible(false)
	self.theme.dealBonusLastOfferNode:setVisible(false)
end

function bonusGame:activeGiftsBtn()
	for i = 1,maxMapLevel do
		if self.data.giftList[i] == 0 then
			self.theme.dealBonusGiftBtnList[i]:setVisible(true)
			self.theme.dealBonusGiftBtnList[i]:setTouchEnabled(true)
			self:initDealBonusGiftBtnEvent(i)
		end
	end
end

function bonusGame:showYourGiftMessage(isEmpty,isAnimate,isRecover) -- 显示选择的 礼物盒子
	if isEmpty then
	else
		local index = self.data.choosedGiftIndex[maxMapLevel]
		self.theme.dealBonusGiftList[index].node:setVisible(false)

		self.theme.dealBonusYourBoxNode:setVisible(true)
		self.theme.dealBonusYourBoxNode:setScale(0.7)
		self.theme.dealBonusYourBoxNode:setPosition(yourGiftEndPos)
		self.theme.dealBonusYourBoxLabel:setString(index)

		if isRecover then
			local _,s = self.theme:addSpineAnimation(self.theme.dealBonusYourBoxNode,-1,self.theme:getPic("spine/deal_bonus/bouns_bx_03"),cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
			self.yourBoxBgSpine = s
		end
	end
end

function bonusGame:initDealBonusGiftBtnEvent(index)
	local clickFunc = function(obj)-- 点击按钮
	    local file = self.theme:getPic("spine/deal_bonus/bouns_bx_02")
		self.data.roundState[self.data.playRound] = roundBonusStateList["choosing"]
		self:saveBonus()
		self.theme.dealBonusGiftBtnList[index]:setTouchEnabled(false)
		self.theme.dealBonusGiftBtnList[index]:setVisible(false)

		self.theme:playMusic(self.theme.audio_list.treasure_click)

        self.data.pickedCount = self.data.pickedCount + 1
        if self.data.pickedCount == 1 then
        	self.data.choosedGiftIndex[maxMapLevel] = index
        elseif self.data.pickedCount > 1 then
        	self.data.choosedGiftIndex[self.data.pickedCount - 1] = index
        	self.theme:runAction(cc.Sequence:create(
        		cc.CallFunc:create(function()
        			self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[index],2,file,cc.p(0,0),"animation1",nil,nil,nil,true)
        		end),
        		cc.DelayTime:create(10/30),
        		cc.CallFunc:create(function( ... )
        			self.theme.dealBonusGiftList[index].image:setColor(cc.c3b(175,175,175))
        		end)
        	))
        	
        end

		self.data.giftList[index] = self.data.playRound
		self.data.eachRoundRemainingCount[self.data.playRound] = self.data.eachRoundRemainingCount[self.data.playRound] - 1
		self:showTipTitleState("choose")
		self.data.eachRoundPickedCount[self.data.playRound] = self.data.eachRoundPickedCount[self.data.playRound] + 1
		self:saveBonus()

		if self.data.eachRoundPickedCount[self.data.playRound] >= self.roundPickCountList[self.data.playRound] then
			self:showTipTitleState("tip")
			for i = 1,maxMapLevel do
				self.theme.dealBonusGiftBtnList[i]:setTouchEnabled(false)
				self.theme.dealBonusGiftBtnList[i]:setVisible(false)
			end
			if self.data.playRound == 1 then
				self:saveYourGift(index)
				self.data.playRound = self.data.playRound + 1
				self:saveBonus()
			elseif self.data.playRound > 1 then
				self.data.roundState[self.data.playRound] = roundBonusStateList["show_result"]
				self:saveBonus()
				self.theme:laterCallBack(1,function()
					self:displayThisRoundPickResult(true)
				end)			    
			end
		end
		
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	self.theme.dealBonusGiftBtnList[index]:addTouchEventListener(onTouch)
end

function bonusGame:saveYourGift(index) -- 需要修改
	self.data.roundState[self.data.playRound] = roundBonusStateList.get_result
	local giftPos = cc.p(self.theme.dealBonusGiftList[index].node:getPosition())
	self.theme.dealBonusGiftList[index].node:setVisible(false)
	self.theme.dealBonusYourBoxNode:setPosition(giftPos)
	self.theme.dealBonusYourBoxNode:setScale(1)
	self.theme.dealBonusYourBoxNode:setVisible(true)
	self.theme.dealBonusYourBoxLabel:setString(index)

	local pFile = self.theme:getPic("particles/baoxianglizi_01_1.plist")
	local pPos = cc.p(0,0)
	local lizi1 = cc.ParticleSystemQuad:create(pFile)
	lizi1:setPosition(pPos)
	self.theme.dealBonusYourBoxNode:addChild(lizi1,-1)

	self.theme:playMusic(self.theme.audio_list.treasure_fly)
	self.theme.dealBonusYourBoxNode:runAction(cc.Sequence:create(
		cc.Spawn:create(cc.ScaleTo:create(1,0.7,0.7),cc.MoveTo:create(1,yourGiftEndPos)),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function ( ... )
			if bole.isValidNode(lizi1) then 
				lizi1:removeFromParent()
			end
			local _,s = self.theme:addSpineAnimation(self.theme.dealBonusYourBoxNode,-1,self.theme:getPic("spine/deal_bonus/bouns_bx_03"),cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
			self.yourBoxBgSpine = s
			self:playNextRound()
		end)))
end

function bonusGame:displayThisRoundPickResult(isFirst,all_count,record_list,showIndex)
	self.data.roundState[self.data.playRound] = roundBonusStateList["show_result"]
	self:saveBonus()
	self.theme.dealBonusOpenGiftNode:setVisible(true)
	self.theme.dealBonusDimmer:setOpacity(0)
	self.theme.dealBonusDimmer:setVisible(true)
	self.theme.dealBonusDimmer:runAction(cc.FadeTo:create(0.3,200))
	local allCounts = all_count or 0
	local recordList = record_list or {}

	beginIndex = self.pickFromToList[self.data.playRound][1]
	showIndex = showIndex or 0
	if isFirst then 
		allCounts = self.roundPickCountList[self.data.playRound]
        recordList = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
        self.theme.dealBonusOpenGiftBoxBgAniNode:setOpacity(0)
        local file = self.theme:getPic("spine/deal_bonus/zhuanguang")
        self.theme:addSpineAnimation(self.theme.dealBonusOpenGiftBoxBgAniNode,10,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
    end
    local isWait = false

	if allCounts > 0 then
		for i = 1,maxMapLevel do
			if not isWait then
			   if self.data.giftList[i] == self.data.playRound and recordList[i] then
			   	  isWait = true
			   	  allCounts = allCounts - 1
			   	  recordList[i] = false
			   	  mulIndex = beginIndex + showIndex
			   	  showIndex = showIndex + 1
			   	  self:displaySinglePickResult(i,allCounts,recordList,mulIndex,showIndex)
			   	end
			end
		end
	else
		if not isWait then
		   isWait = true
           self:showNormalOfferAnimaton()
           self.theme.dealBonusOpenGiftBoxBgAniNode:removeAllChildren()
        end
	end
end

function bonusGame:displaySinglePickResult(index,all_count,record_list,mulIndex,showIndex)
	local mul = self.multiList[mulIndex]
	local isFake = self.fakeList[mulIndex] > 0 and true or false
	local temp_mul = 0
	local fake_delay0 = 0
	local fake_delay1 = 0
	local fake_delay2 = 0
	if isFake then
		fake_delay0 = 1
		fake_delay1 = 15/30
		fake_delay2 = (37-15)/30
		temp_mul = self.fakeList[mulIndex]
	end

	self.theme.dealBonusOpenGiftBoxNode:setScale(0)
	self.theme.dealBonusOpenGiftBoxNode:setVisible(true)
	self.theme.label_dealBonusOpenGiftNum:setString(index)
	self.theme.dealBonusOpenGiftBoxNode:setOpacity(255)
	self.theme.label_dealBonusOpenMulti:setScale(0)
	self.theme.label_dealBonusOpenMulti:setVisible(true)
	bole.updateSpriteWithFile(self.theme.dealBonusOpenGiftBoxImage,"#theme3142_bonus_11.png")

	if isFake then
	   self.theme.label_dealBonusOpenMulti:setString(temp_mul.."X")
	else
	   self.theme.label_dealBonusOpenMulti:setString(mul.."X")
	end

	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.dealBonusOpenGiftBoxNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.3,1.5,1.5),
				cc.ScaleTo:create(0.2,1,1)
			))
			self.theme:playMusic(self.theme.audio_list.treasure_open)

			self.theme.dealBonusGiftAniNodeList[index]:removeAllChildren()
			self.theme.dealBonusGiftList[index].node:setVisible(false)
			self.theme.dealBonusOpenGiftBoxBgAniNode:runAction(cc.FadeIn:create(0.2))
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			local file = self.theme:getPic("spine/deal_bonus/bouns_bx_01")
			self.theme:addSpineAnimation(self.theme.dealBonusOpenGiftBoxNode,nil,file,cc.p(0,0),"animation2")
		end),
		cc.DelayTime:create(3/30),
		cc.CallFunc:create(function ( ... )
			bole.updateSpriteWithFile(self.theme.dealBonusOpenGiftBoxImage,"#theme3142_bonus_12.png")
			self.theme.label_dealBonusOpenGiftNum:setVisible(false)
		end),
		cc.DelayTime:create(12/30),
		cc.CallFunc:create(function()
			self.theme.label_dealBonusOpenMulti:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.4,1.35),
				cc.ScaleTo:create(0.2,1.25)
			))			
			
		end),
		cc.DelayTime:create(0.6 + fake_delay0),
		cc.CallFunc:create(function()
			if isFake then				
				local file = nil 
				if temp_mul == 1000 then
					file = self.theme:getPic("spine/deal_bonus/trick_01")
				elseif temp_mul == 750 then
					file = self.theme:getPic("spine/deal_bonus/trick_02")
				end
				local _,s = self.theme:addSpineAnimation(self.theme.dealBonusOpenGiftBoxNode,nil,file,cc.p(self.theme.label_dealBonusOpenMulti:getPosition()),"animation")
				self.theme:playMusic(self.theme.audio_list.bonus_fake)
			end
		end),
		cc.DelayTime:create(fake_delay1),
		cc.CallFunc:create(function()
			if isFake then
				self.theme.label_dealBonusOpenMulti:setString(mul.."X")
			end 
		end),
		cc.DelayTime:create(fake_delay2),
		cc.CallFunc:create(function()
			local starIndex = multiValueIndexConfig[mul]
			self.data.mulStarList[starIndex] = false
			local file = self.theme:getPic("spine/deal_bonus/xzlz_01")
			self.theme:addSpineAnimation(self.theme.dealBonusMultList[starIndex].node,10,file,cc.p(0,0),"animation")

			local temp = self.theme.dealBonusMultList[starIndex] -- 设置 结果显示之后控制 倍数置灰
			temp.node:setOpacity(255)
	    	temp.sp:setColor(cc.c3b(84,84,84))
	    	temp.label:setColor(cc.c3b(100,100,100))
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.theme.dealBonusOpenGiftBoxNode:runAction(cc.FadeOut:create(0.6))
			self.theme.dealBonusOpenGiftBoxBgAniNode:runAction(cc.FadeOut:create(0.4))
		end),
		cc.DelayTime:create(0.8),
		cc.CallFunc:create(function()
			bole.updateSpriteWithFile(self.theme.dealBonusOpenGiftBoxImage,"#theme3142_bonus_11.png")
			self.theme.label_dealBonusOpenGiftNum:setVisible(true)
			self:displayThisRoundPickResult(false,all_count,record_list,showIndex)
		end)
	))
end

function bonusGame:showNormalOfferAnimaton()
	self.theme.dealBonusOpenGiftBoxNode:setScale(0)
	self.theme.dealBonusOpenGiftNode:setVisible(true)
	self.theme.dealBonusTopNode:stopAllActions()
	self.theme.dealBonusTopNode:runAction(cc.FadeTo:create(0.3,0))

	self.data.roundState[self.data.playRound] = roundBonusStateList["get_result"]
	self:saveBonus()

	self:showTipTitleState("tip")
	local mul = self.dealList[self.data.playRound - 1]
	local win = mul*self.avg_bet
	self.dealBonusWin = win
	self.theme.label_offerMul:setString(mul.."X")
	self.theme.label_offerWin:setString(mul.." X "..FONTS.formatByCount4(self.avg_bet,4,true).." = "..FONTS.formatByCount4(win,4,true)) 
	for i = 1,4 do
		if self.data.recordList[i] > 0 then
			local mul = self.dealList[i]
			self.theme.dealbonusOfferDealLabels[i]:setString(mul.."X")
		else
			self.theme.dealbonusOfferDealLabels[i]:setString("")
		end
	end
	self.theme.dealbonusOfferNode:setVisible(false)
	self.theme.dealBonusOfferCharacterNode:removeAllChildren()
    local file_character = self.theme:getPic("spine/deal_bonus/caishen_01")
    self.theme:addSpineAnimation(self.theme.dealBonusOfferCharacterNode,nil,file_character,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)

	self.data.recordList[self.data.playRound-1] = mul

	local btn_size = self.theme.showOfferBtn:getContentSize()
	self.theme:addSpineAnimation(self.theme.showOfferBtn,nil,self.theme:getPic("spine/dialog/anniuliuguang_01"),cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)

   	self.theme:playMusic(self.theme.audio_list.offer_open)
   	self.theme.showOfferDialog:setPositionY(tipOfferDialogHeight)
   	local baseX = self.theme.showOfferDialog:getPositionX()
   	self.theme.showOfferDialogRoot:setVisible(true)
   	self.theme.offerTipJumpNode:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.1),cc.ScaleTo:create(0.5,0.9))))
	self.theme.showOfferDialog:runAction(cc.Sequence:create(
		cc.MoveTo:create(15/60, cc.p(baseX, -30)),
		cc.MoveTo:create(10/60, cc.p(baseX, 10)),
		cc.MoveTo:create(8/60, cc.p(baseX, 0))
	))
	
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function( ... )
			self.theme.dealBonusOpenGiftNode:setVisible(false)
			self.theme.dealBonusDimmer:setVisible(false)

			self.theme.showOfferBtn:setBright(true)
			self.theme.showOfferBtn:setTouchEnabled(true)
            self:initDealBonusEnvelopeEvent()
		end)
	))
	
end

function bonusGame:initDealBonusEnvelopeEvent( ... )
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.showOfferBtn:setTouchEnabled(false)
	    self.theme.showOfferBtn:setBright(false)
	    self.theme:playMusic(self.theme.audio_list.common_click)
	    
	    -- 关闭showOfferTipDialog 
	    self.theme.offerTipJumpNode:stopAllActions()
	    local baseX = self.theme.showOfferDialog:getPositionX()
    	self.theme.showOfferDialog:runAction(cc.Sequence:create(
			cc.MoveTo:create(10/60,cc.p(baseX,-14)),
			cc.MoveTo:create(8/60,cc.p(baseX,tipOfferDialogHeight)),
			cc.CallFunc:create(function ( ... )
				self.theme.showOfferDialogRoot:setVisible(false)
			end)))

	    self:showEnvelopOpenAnimation()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	self.theme.showOfferBtn:addTouchEventListener(onTouch)-- 设置按钮
end

function bonusGame:showEnvelopOpenAnimation()
	self.theme.dealbonusOfferNode:setVisible(true)
	self.theme.dealbonusOfferNode:setOpacity(255)

	local file_btn = self.theme:getPic("spine/dialog/anniuliuguang_01")
	local btn_size = self.theme.btn_offerTakeIt:getContentSize()
	self.theme:addSpineAnimation(self.theme.btn_offerTakeIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.theme.btn_offerLeaveIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)

	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.theme.btn_offerTakeIt:setTouchEnabled(true)
			self.theme.btn_offerLeaveIt:setTouchEnabled(true)

			self:initTakeBtnEvent()
			self:initLeaveBtnEvent()
		end)
	))
end

function bonusGame:initTakeBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_offerTakeIt:setTouchEnabled(false)
	    self.theme.btn_offerLeaveIt:setTouchEnabled(false)
	    self.theme:playMusic(self.theme.audio_list.common_click)
	    self.theme.btn_offerTakeIt:removeAllChildren()
	    self.theme.btn_offerLeaveIt:removeAllChildren()
	    self.theme:playMusic(self.theme.audio_list.offer_off)
        self:showDealBonusCollectBoard(true)
	    self.data.gameEnd = true
	    self:saveBonus()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_offerTakeIt:addTouchEventListener(onTouch)
end

function bonusGame:initLeaveBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_offerTakeIt:setTouchEnabled(false)
	    self.theme.btn_offerLeaveIt:setTouchEnabled(false)
	    self.theme:playMusic(self.theme.audio_list.common_click)
	    self.theme.btn_offerTakeIt:removeAllChildren()
	    self.theme.btn_offerLeaveIt:removeAllChildren()
	    self.theme:playMusic(self.theme.audio_list.offer_off)

	    if self.data.playRound < 6 then       
	        self.data.roundState[self.data.playRound] = roundBonusStateList["finish"]
	        self.data.playRound = self.data.playRound + 1
		    self:saveBonus()
		    self:playNextRound()
		    self.theme.dealBonusTopNode:stopAllActions()
	    	self.theme.dealBonusTopNode:runAction(cc.FadeTo:create(0.3,255))
		elseif self.data.playRound == 6 then			
			self.data.roundState[self.data.playRound] = roundBonusStateList["finish"]
			self.data.playRound = self.data.playRound + 1
			self:saveBonus()
			self:showLastOfferBoard(true)
		end
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_offerLeaveIt:addTouchEventListener(onTouch)
end

function bonusGame:playNextRound()
	self.theme.dealbonusOfferNode:runAction(cc.Sequence:create(
		cc.FadeOut:create(0.5),
		cc.CallFunc:create(function ( ... )
			self.theme.dealbonusOfferNode:setVisible(false)
		end)))
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self:showNextRoundTip()			
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()			
			self:showTipTitleState("choose")
			for i = 1,maxMapLevel do
				if self.data.giftList[i] == 0 then
					self.theme.dealBonusGiftList[i].node:setVisible(true)
					self.theme.dealBonusGiftList[i].label:setString(i)
					self.theme.dealBonusGiftBtnList[i]:setVisible(true)
					self.theme.dealBonusGiftBtnList[i]:setTouchEnabled(true)
					self:initDealBonusGiftBtnEvent(i)
				end
			end
		end)
	))
end

function bonusGame:showNextRoundTip( ... )
	if self.data.playRound < 6 then
		self.theme.dealBonusRoundTipList[1].labelRoundCount:setString(self.data.playRound-1)
		self.theme.dealBonusRoundTipList[1].labelPickCount:setString(self.roundPickCountList[self.data.playRound])
		self.theme.dealBonusRoundTipList[1].node:setVisible(true)
		self.theme.dealBonusRoundTipList[2].node:setVisible(false)
	elseif self.data.playRound == 6 then
		self.theme.dealBonusRoundTipList[1].node:setVisible(false)
		self.theme.dealBonusRoundTipList[2].node:setVisible(true)
	end

	self.theme.dealBonusRoundTipNode:setScale(0)
	self.theme.dealBonusRoundTipNode:setVisible(true)
	
	self.theme:playMusic(self.theme.audio_list.treasure_dialog_round)
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.dealBonusRoundTipNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.4,1.5,1.5),
				cc.ScaleTo:create(0.2,1,1)
			))
		end),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
			self.theme.dealBonusRoundTipNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.15,1.5,1.5),
				cc.ScaleTo:create(0.2,0,0)
			))
		end)
	))
end

function bonusGame:showLastOfferBoard(isAnimate)
	local startPosLeft = cc.p(69.5,-128)
	local startPosRight = cc.p(285,-128)
	local originScale = 0.5
	self.theme.dealBonusLastOfferBoxLeft:setPosition(startPosLeft)
	self.theme.dealBonusLastOfferBoxLeft:setScale(originScale)
	self.theme.dealBonusLastOfferBoxRight:setPosition(startPosRight)
	self.theme.dealBonusLastOfferBoxRight:setScale(originScale)

	self.data.roundState[self.data.playRound] = roundBonusStateList["get_result"]
	self:saveBonus()

	self.theme.label_dealBonusLastOfferMul:setScale(0)
	self.theme.label_dealBonusLastOfferMul:setVisible(true)

	local lastIndex = 0
	for i = 1,maxMapLevel do
		if self.data.giftList[i] == 0 then
			lastIndex = i
		end
	end
	self.data.choosedGiftIndex[maxMapLevel-1] = lastIndex
	self.theme.label_lastOfferNumLeft:setString(self.data.choosedGiftIndex[maxMapLevel])
	self.theme.label_lastOfferNumRight:setString(lastIndex)
	self.theme.dealBonusLastOfferDealLabel:setString(self.bestDeal.."X")

	self.theme.dealBonusLastOfferCharacterNode:removeAllChildren()
    local file_character = self.theme:getPic("spine/deal_bonus/xsxh_01")
    self.theme:addSpineAnimation(self.theme.dealBonusLastOfferCharacterNode,nil,file_character,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)

	if isAnimate then
		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				local file = self.theme:getPic("spine/deal_bonus/2_1qieping_01")
				self.theme:addSpineAnimation(self.theme.theDealNodeRoot,nil,file,cc.p(0,0),"animation")
				self.theme:playMusic(self.theme.audio_list.offer_open)
			end),
			cc.DelayTime:create(13/30),
			cc.CallFunc:create(function()
				self:showLastOffer(lastIndex)
			end)
		))
	else
		self.theme.dealBonusTopNode:stopAllActions()
    	self.theme.dealBonusTopNode:setOpacity(0)
		self:showLastOffer(lastIndex)
	end
end

function bonusGame:showLastOffer( lastIndex )
	self.theme:playMusic(self.theme.audio_list.mystery_guest)
	self.theme.dealBonusLastOfferNode:setVisible(true)
	self.theme.dealbonusOfferNode:setVisible(false)

	self.theme.dealBonusGiftList[lastIndex].node:setVisible(false)
	self.theme.dealBonusGiftList[self.data.choosedGiftIndex[maxMapLevel]].node:setVisible(false)

	self.theme.btn_lastOfferKeepIt:setTouchEnabled(true)
	self.theme.btn_lastOfferTradeIt:setTouchEnabled(true)

	local file_btn = self.theme:getPic("spine/dialog/anniuliuguang_01")
	local btn_size = self.theme.btn_lastOfferKeepIt:getContentSize()
	self.theme:addSpineAnimation(self.theme.btn_lastOfferKeepIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.theme.btn_lastOfferTradeIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)

	self:initLastKeepBtnEvent()
	self:initLastTradeBtnEvent()
end
function bonusGame:initLastKeepBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_lastOfferKeepIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferTradeIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferKeepIt:removeAllChildren()
	    self.theme.btn_lastOfferTradeIt:removeAllChildren()

        local lastIndex = 0
	    for i = 1,maxMapLevel do
			if self.data.giftList[i] == 0 then
				lastIndex = i
			end
		end

	    self.data.pickedCount = self.data.pickedCount + 1
	    self.data.choosedGiftIndex[self.data.pickedCount-1] = lastIndex
	    self.data.giftList[lastIndex] = self.data.playRound

	    self.theme:playMusic(self.theme.audio_list.common_click)
        local mul = self.multiList[maxMapLevel]
        self.theme.label_dealBonusLastOfferMul:setString(mul.."X")
        self:showLastOfferAnimation("keep")
	    self.data.gameEnd = true 
	    self:saveBonus()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_lastOfferKeepIt:addTouchEventListener(onTouch)
end

function bonusGame:initLastTradeBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_lastOfferKeepIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferTradeIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferKeepIt:removeAllChildren()
	    self.theme.btn_lastOfferTradeIt:removeAllChildren()

	    self.theme:playMusic(self.theme.audio_list.common_click)

	    local lastIndex = 0
	    for i = 1,maxMapLevel do
			if self.data.giftList[i] == 0 then
				lastIndex = i
			end
		end

	    self.data.pickedCount = self.data.pickedCount + 1
	    self.data.choosedGiftIndex[self.data.pickedCount-1] = lastIndex
	    self.data.giftList[lastIndex] = self.data.playRound
	    self.theme.dealBonusGiftList[lastIndex].node:setVisible(false)

        local mul = self.multiList[maxMapLevel]
        self.theme.label_dealBonusLastOfferMul:setString(mul.."X")
	    self:showLastOfferAnimation("trade")
	    self.data.gameEnd = true 
	    self:saveBonus()

	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_lastOfferTradeIt:addTouchEventListener(onTouch)
end

function bonusGame:showLastOfferAnimation(boxType)
	self.theme.dealBonusLastDimmer:setOpacity(0)
	self.theme.dealBonusLastDimmer:setVisible(true)

	local moveBox 		= nil
	local moveBoxLabel 	= nil
	if boxType == "keep" then
		moveBox 		= self.theme.dealBonusLastOfferBoxLeft
		moveBoxLabel 	= self.theme.label_lastOfferNumLeft
	elseif boxType == "trade" then
		moveBox 		= self.theme.dealBonusLastOfferBoxRight
		moveBoxLabel 	= self.theme.label_lastOfferNumRight
	end

	bole.changeParent(moveBox,self.theme.dealBonusLastBoxAniNode)
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme:playMusic(self.theme.audio_list.treasure_final)
			moveBox:runAction(cc.Spawn:create(
				cc.ScaleTo:create(1,1.25),
				cc.MoveTo:create(1,cc.p(0,0))
			))
			self.theme.dealBonusLastDimmer:runAction(cc.FadeTo:create(0,200))
		end),
		cc.DelayTime:create(0.9),
		cc.CallFunc:create(function()
        	local _,s = self.theme:addSpineAnimation(self.theme.dealBonusLastBoxAniNode,-1,self.theme:getPic("spine/deal_bonus/zhuanguang"),cc.p(-5,0),"animation",nil,nil,nil,true,true,nil)
        	s:setScale(0.5)
        	s:runAction(cc.ScaleTo:create(0.2,1))
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.theme:addSpineAnimation(self.theme.dealBonusLastBoxAniNode,nil,self.theme:getPic("spine/deal_bonus/bouns_bx_01"),cc.p(10,0),"animation2")
		end),
		cc.DelayTime:create(3/30),
		cc.CallFunc:create(function ( ... )
			bole.updateSpriteWithFile(moveBox:getChildByName("box_image"),"#theme3142_bonus_12.png")
			moveBoxLabel:setVisible(false)
		end),
		cc.DelayTime:create(12/30),
		cc.CallFunc:create(function()
			self.theme.label_dealBonusLastOfferMul:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.4,1.5),
				cc.ScaleTo:create(0.2,1)
			))
		end),
		cc.DelayTime:create(1.5),
		cc.CallFunc:create(function( ... )
			self.theme:playMusic(self.theme.audio_list.offer_off)

			self.theme.dealBonusLastDimmer:runAction(cc.FadeOut:create(0.3))
			bole.changeParent(moveBox,self.theme.dealBonusLastOfferNode)
			bole.updateSpriteWithFile(moveBox:getChildByName("box_image"),"#theme3142_bonus_11.png")
			moveBoxLabel:setVisible(true)
			self.theme.label_dealBonusLastOfferMul:setVisible(false)
			self.theme.dealBonusLastOfferNode:setVisible(false)
			self.theme.dealBonusLastBoxAniNode:removeAllChildren()
			self.dealBonusWin = self.dealBonusWinList[self.data.playRound - 1]
			self:showDealBonusCollectBoard()
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			self.theme.dealBonusLastDimmer:setVisible(false)
		end)
	))
end

function bonusGame:showTipTitleState(state)
	for k,v in pairs(self.theme.dealBonusGiftTextList) do
		v:setVisible(false)
	end
	self.theme.dealBonusGiftTextList["start"]:stopAllActions()
	if state == "start" then
		local tipNode = self.theme.dealBonusGiftTextList["start"]
		tipNode:setVisible(true)
		tipNode:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(1,0.9),cc.ScaleTo:create(1,1.1))))
	elseif state == "choose" then
		local remaingCount = self.data.eachRoundRemainingCount[self.data.playRound]
		self.theme.dealBonusGiftTextList["choose"].lb:setString(remaingCount.."/"..roundPickCnt[self.data.playRound])
		self.theme.dealBonusGiftTextList["choose"]:setVisible(true)
		self.theme.dealBonusGiftTextList["choose"]:setVisible(true)
	elseif state == "tip" then
		self.theme.dealBonusGiftTextList["tip"]:setVisible(true)
	end
end

function bonusGame:showDealBonusCollectBoard(isTake)
	self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0)

	local csbPath = self.theme:getPic("csb/deal_dialog.csb")
	local dialog 		= cc.CSLoader:createNode(csbPath)
	local rootNode 		= dialog:getChildByName("root")
	local showNode 		= rootNode:getChildByName("node_collect")
	rootNode:getChildByName("node_start"):setVisible(false)
	local collectBtn 		= showNode:getChildByName("collect_btn")
	local labelWin 		= showNode:getChildByName("label_win")
	local labelbasic 	= showNode:getChildByName("label_mul")
	local labelMul 		= showNode:getChildByName("label_mul2")

	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(csbPath)
		dialog:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end

	self.theme.curScene:addToContentFooter(dialog)
	self.theme:playMusic(self.theme.audio_list.bonus_end_show)
	playLine(0, 30)

	labelWin:setString(FONTS.format(self.dealBonusWin,true))
	bole.shrinkLabel(labelWin,580,labelWin:getScale())
	local mul = self.dealList[self.data.playRound-1]
	labelMul:setString(mul)
	labelbasic:setString(FONTS.formatByCount4(self.avg_bet,5,true))

	collectBtn:setTouchEnabled(false)
	collectBtn:setBright(false)

	-- -- 播放spine 动画
	local size = collectBtn:getContentSize()
	self.theme:addSpineAnimation(collectBtn, nil, self.theme:getPic("spine/dialog/anniuliuguang_01"), cc.p(size.width/2,size.height/2), "animation1", nil, nil, nil, true, true)-- 添加特效

	self.theme:addSpineAnimation(showNode, nil, self.theme:getPic("spine/dialog/congzi1"), cc.p(0,215.5), "animation", nil, nil, nil, true,true)
	self.theme:addSpineAnimation(showNode, nil, self.theme:getPic("spine/dialog/guajian_b"), cc.p(0,0), "animation", nil, nil, nil, true,true)
	self.theme:addSpineAnimation(showNode, nil, self.theme:getPic("spine/dialog/lvkuang"), cc.p(0,-90.5), "animation", nil, nil, nil, true,true)
	
	local clickEndFunction = function ( ... )
		collectBtn:setTouchEnabled(false)
		collectBtn:setBright(false)

		playLine(60, 90)
		self.theme:playMusic(self.theme.audio_list.common_click)
		dialog:runAction(cc.Sequence:create(
			cc.DelayTime:create(1), 
			cc.CallFunc:create(function ( ... )
				local special_data = {}
		    	special_data.value = self.dealBonusWin
		    	self.ctl:collectCoins(2,special_data)	
			end), 
			cc.RemoveSelf:create()))
	end

	dialog:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5), 
		cc.CallFunc:create(function ()
			collectBtn:addTouchEventListener(clickEndFunction)
			collectBtn:setTouchEnabled(true)
			collectBtn:setBright(true)
		end)))
end

function bonusGame:clearDealBonusSceneAssets( ... )
	if bole.isValidNode(self.yourBoxBgSpine) then 
		self.yourBoxBgSpine:removeFromParent()
	end
	self.yourBoxBgSpine = nil
end

function bonusGame:exitDealBonus()

	local function dealBonusOver()
		-- self.theme:lockJackpotMeters(false)
  --       self.ctl:removePointBet()
  --       -- 播放背景音乐
		-- self.theme:dealMusic_ExitBonusGame()
		self.callback()
		self.theme:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function ( ... )
				LobbyThemeControl:getInstance():backToLobby(self.ctl.header, true, 10011, nil)
			end)))		
	end

	-- 在此之后断电重连就不用恢复了
	self.data["end_game"] = true
	self:saveBonus()
	RubTheLampController:getInstance():finishGenieThemeBonus()
	
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
	 		self.theme.dealBonusDimmer:runAction(cc.FadeOut:create(0.3))
		end),
		-- cc.DelayTime:create(0.35),
		-- cc.CallFunc:create(function()
		-- 	-- self.theme.mapPoints = 0
		--  --    self.theme:setCollectProgressImagePos(0)
		-- 	self.theme.dealBonusNode:runAction(cc.FadeOut:create(0.5))
		-- end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			-- self:clearDealBonusSceneAssets()
			self.ctl:startRollup(self.dealBonusWin, dealBonusOver)
		end)
	))
end

return ThemeActivityMammon
