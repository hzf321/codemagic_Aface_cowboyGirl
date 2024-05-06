-- Create class
local parentClass = Theme
ThemeSmokinHotRespin = class("ThemeSmokinHotRespin", parentClass)

local customizedTheme = ThemeSmokinHotRespin

customizedTheme.plistAnimate = 
{
	"images/plist/symbols",
}

customizedTheme.csbList = 
{
	"csb/base.csb",
}

local SpinBoardType = {
	Normal = 1,
	ReSpin = 2,
}

local Jsize = {
	["width"] = 180,
	["height"] = 170
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
	[21] = 1,[22] = 2,[23] = 3,[24] = 4,[25] = 5,[26] = 6,[27] = 7,[28] = 8,[29] = 9,[30] = 10,[31] = 15,[32] = 20,[33] = 25,
	[34] = 50,[35] = 75,[36] = 100,[37] = 150,[38] = 200
}

local reelIndexChangeList = 
{
	[1] = {1,6,11},[2] = {2,7,12},[3] = {3,8,13},[4] = {4,9,14},[5] = {5,10,15},
}

local reverseReelIndexChangeList = 
{
	[1]  = {1,1},[2]  = {2,1},[3]  = {3,1},[4]  = {4,1}, [5]  = {5,1},
	[6]  = {1,2},[7]  = {2,2},[8]  = {3,2},[9]  = {4,2}, [10] = {5,2},
	[11] = {1,3},[12] = {2,3},[13] = {3,3},[14] = {4,3}, [15] = {5,3},
}

function customizedTheme:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	local borderConfig = self.ThemeConfig["boardConfig"]
	local reelConfig = borderConfig[2]["reelConfig"]
	local newConfig = {}
	for i=0, 14 do
		local oneConfig = {}
		oneConfig["base_pos"] = cc.p((i%5)*reelConfig["cellWidth"]+reelConfig["base_pos"].x,math.floor((14-i)/5)*reelConfig["cellHeight"]+reelConfig["base_pos"].y)
 		oneConfig["cellWidth"] = reelConfig["cellWidth"]
		oneConfig["cellHeight"] = reelConfig["cellHeight"]
		oneConfig["symbolCount"] = reelConfig["symbolCount"]
		table.insert(newConfig,oneConfig)
	end
	borderConfig[2]["reelConfig"] = newConfig
	self.boardConfigList = borderConfig
	return borderConfig
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
            [31] = 500,[32] = 500,[33] = 500,[34] = 500,[35] = 500,[36] = 500,[37] = 500,[38] = 500
            
		},
		["special_symbol_list"] = {
			--specialSymbol["fg_trigger"]
		},
		["normal_symbol_list"]  = {
			1,2-- 12 是空的 圆盘symbol -- "1_2"
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
					["base_pos"] = cc.p(190,114),
					["cellWidth"] = 178,
					["cellHeight"] = 148,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(368,114),
					["cellWidth"] = 178,
					["cellHeight"] = 148,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(546,114),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 178,
					["cellHeight"] = 148,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(724,114),
					["cellWidth"] = 178,
					["cellHeight"] = 148,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(902,114),
					["cellWidth"] = 178,
					["cellHeight"] = 148,
					["symbolCount"] = 3
				},
			}
		},
		{
			["row_single"] = true, -- 每个reel单独一个空间，不共用一个clipnode。例如用于lockrespin
			["rowReelCnt"] = 5,
			["reelConfig"] = {
				["base_pos"] = cc.p(190,114),
				["cellWidth"] = 178,
				["cellHeight"] = 148,
				["symbolCount"] = 1
			}
		},
	}
    }

	self.baseBet = 5000
	self.DelayStopTime = 0
	self.UnderPressure = 1
    
	 
    local use_portrait_screen = false
	local ret = parentClass.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 148
local delay = 0
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
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
	if self.showReSpinBoard and self.lockedReels[reelCol] then
		spinAction.locked = true
	end
	--print("wy_spinAction",tool.lua_to_json(spinAction))
	return spinAction
end

function customizedTheme:getSpinColStopAction(themeInfoData, pCol, interval)
	local specialType = nil
	--local checkNotifyTag = false

	local function onSpecialBegain( pcol)
      
	end

	local function onSpecialEnd( )
       
	end
	local spinAction = {}
	spinAction.actions = {}


	if specialType then
		table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
		local temp = interval - speedUpTime - upBounceTime - (pCol-1)*delay
		local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
		spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime

		self.ExtraStopCD = spinAction.stopDelay+speedDownTime
		self.canFastStop = false
		spinAction.ClearAction = true
	else
		local temp = interval - speedUpTime - upBounceTime
		local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
		self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
		spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime		
		
	end
	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = speedDownTime - 20/60
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

	self.dimmer = self.mainThemeScene:getChildByName("dimmer_node")
	self.dimmer:setVisible(false)
	self.coinScaleAniNode = self.mainThemeScene:getChildByName("scale_node")
	local reelbgNode = self.reelRoot:getChildByName("reel_bg")
	local recordCollectedNode = reelbgNode:getChildByName("collectFrame_bg")
	self.label_collectedNum = recordCollectedNode:getChildByName("collected_num")

 ---JackPot相关
    -- 初始化jackpot
	self.progressive_node = self.mainThemeScene:getChildByName("progressive_node")
	self.progressive_node:setVisible(false)
	self.jackpotLabels = {}
	for i=1,3 do
		self.jackpotLabels[i] = self.progressive_node:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	end

	self:initialJackpotNode()

--- topMessage相关
	local topMessageNode = self.mainThemeScene:getChildByName("top_message_node")
	self.chooseMessageNode = topMessageNode:getChildByName("select_node")
	self.choosedNumImageList = {}
	for i = 1,3 do
		self.choosedNumImageList[i] = self.chooseMessageNode:getChildByName("tipNum_"..i)
	end

	self.label_currentMul = self.chooseMessageNode:getChildByName("label_mul")

	self.topWinMessageNode = topMessageNode:getChildByName("win_node")
	self.label_topWin = self.topWinMessageNode:getChildByName("label_win")

	self.pressStartNode = topMessageNode:getChildByName("start_node")
	self.btn_pressStartGame = self.pressStartNode:getChildByName("btn_pressToStart")
	self.pressStartText = self.pressStartNode:getChildByName("text")

--- choose相关
    self.chooseNode = self.mainThemeScene:getChildByName("choose_node")
    self.chooseItemList = {}
    for i = 1,15 do
		self.chooseItemList[i] = {}
		self.chooseItemList[i].node = self.chooseNode:getChildByName(i)
		self.chooseItemList[i].green = self.chooseItemList[i].node:getChildByName("choose_green")
		self.chooseItemList[i].green:setVisible(false)
		self.chooseItemList[i].gray = self.chooseItemList[i].node:getChildByName("choose_gray")
		self.chooseItemList[i].gray:setVisible(false)
		self.chooseItemList[i].btn = self.chooseItemList[i].node:getChildByName("btn")
		self.chooseItemList[i].btn_index = i   	
    end
    
    self.chooseRedImageNode = self.reelRoot:getChildByName("mul_red_node")
    self.chooseMulLabelNode = self.reelRoot:getChildByName("mul_label_node")
    self.chooseMulAniNode = self.reelRoot:getChildByName("mul_ani_node")
    self.chooseRecordList_redImage = {}
    self.chooseRecordList_mulLabel = {}
    self.chooseRecordList_aniNode = {}
    for i = 1,15 do
		self.chooseRecordList_redImage[i] = self.chooseRedImageNode:getChildByName(i)
		self.chooseRecordList_redImage[i]:setVisible(false)
	    self.chooseRecordList_mulLabel[i] = self.chooseMulLabelNode:getChildByName(i)
	    self.chooseRecordList_mulLabel[i]:setVisible(false)
	    self.chooseRecordList_aniNode[i] = self.chooseMulAniNode:getChildByName(i)		
    end

--- spinCount相关
    self.earNode = self.reelRoot:getChildByName("ear_node")
    self.earNode:setVisible(false)
    self.leftRemainingNumList = {}
    self.rightRemainingNumList = {}
    for i = 0,3 do
    	self.leftRemainingNumList[i] = self.earNode:getChildByName("left_num"..i)
        self.rightRemainingNumList[i] = self.earNode:getChildByName("right_num"..i)
    end

    self.remainingResetAniNodeLeft = self.earNode:getChildByName("aniNode_left")
    self.remainingResetAniNodeRight = self.earNode:getChildByName("aniNode_right")

--- win 相关
    self.winNode = self.mainThemeScene:getChildByName("win_node")
    self.winNode:setVisible(false)

    self.label_allWin = self.winNode:getChildByName("label_win")
    inherit(self.label_allWin, LabelNumRoll)
	local function fontFormat1(num)
        return FONTS.formatByCount2(num, 11, true)
	end
	self.label_allWin:nrInit(0, 25, fontFormat1)

    self.btn_collectAll = self.winNode:getChildByName("btn_collect")
    self.winBoardAniNode = self.winNode:getChildByName("win_ani_node")

    self.jpWinNode = self.mainThemeScene:getChildByName("jp_win_node")
    self.jpWinNode:setVisible(false)

    self.label_jpWin = self.jpWinNode:getChildByName("label_jp_win")
    inherit(self.label_jpWin, LabelNumRoll)
	local function fontFormat2(num)
        return FONTS.formatByCount2(num, 11, true)
	end
	self.label_jpWin:nrInit(0, 25, fontFormat2)

    self.btn_collectJp = self.jpWinNode:getChildByName("btn_collect")

    self.jpWinTitleList = {}
    for i = 1,3 do
    	self.jpWinTitleList[i] = self.jpWinNode:getChildByName("jp_title_"..i)
    end

    self.jpWinBoardAniNode = self.jpWinNode:getChildByName("jpWin_ani_node")

-- triggerBoard相关
   self.triggerBoardNode = self.mainThemeScene:getChildByName("trigger_node")
   self.triggerBoardNode:setVisible(false)
   self.triggerText = self.triggerBoardNode:getChildByName("text_trigger")
   self.triggerText:setVisible(false)
   self.logoAniNode = self.triggerBoardNode:getChildByName("logo_ani_node")

-- collect bonus Node
    self.bonusCollectReelAniNode = self.mainThemeScene:getChildByName("collect_aniNode")
    local bonusCollectlabelsNode = self.mainThemeScene:getChildByName("collect_mul_node")
    self.bonusCollectMulLabelList = {}
    for i = 1,15 do
   	   self.bonusCollectMulLabelList[i] = {}
   	   self.bonusCollectMulLabelList[i].label = bonusCollectlabelsNode:getChildByName(i)
   	   self.bonusCollectMulLabelList[i].label:setVisible(false)
   	   self.bonusCollectMulLabelList[i].pos = bole.getPos(self.bonusCollectMulLabelList[i].label)
   	end

-- finishBoard相关
   self.finishBoardNode = self.mainThemeScene:getChildByName("finish_node")
   self.finishBoardNode:setVisible(false)

   self.ctl.footer:isShowTotalBetLayout(false)

end


function customizedTheme:hideActivitysNode(  ) -- 
	if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
end

function customizedTheme:showActivitysNode(  ) -- 
	if self.ctl.footer then
        self.ctl.footer:showActivitysNode()
    end
end
--------------------------JackPot功能相关----------------------------------	

function customizedTheme:getJPLabelMaxWidth(index)
	if index == 1 then
		return 255
	elseif index == 2 then
		return 255
	else
		return 255
	end
end

function customizedTheme:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"grand", "major","minor"},
		allowK = {[2001] = false},
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
	
end

function customizedTheme:changeSpinBoard(pType) -- 更改背景控制 已修改
	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		self.showReSpinBoard = false
		
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1

	elseif pType == SpinBoardType.ReSpin then
		if self.showReSpinBoard then return end
		self.lockedReels = {}
		self.showReSpinBoard = true

		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[2]
		self.spinLayer:Active()

		self.lockedReels = {}

		self.initBoardIndex = 2
	end
end

function customizedTheme:getSpinConfig( spinTag )
	local spinConfig = {}
	if self.showReSpinBoard then
		for i=0, 14 do
			local col = i+1
			local tempCol = i%5+1
			local theStartAction = self:getSpinColStartAction(tempCol,col)
			local theReelConfig = {
				["col"]     = col,
				["action"]  = theStartAction,
			}
			table.insert(spinConfig, theReelConfig)
		end		
		return spinConfig
	else
		for col,_ in pairs(self.spinLayer.spins) do
			local theStartAction = self:getSpinColStartAction(col)
			local theReelConfig = {
				["col"]     = col,
				["action"]  = theStartAction,
			}
			table.insert(spinConfig, theReelConfig)
		end	
		return spinConfig
	end
end

function customizedTheme:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function customizedTheme:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}
	if self.showReSpinBoard then
		--print("wy_showReSpinBoard_firstTriggerBonus",self.firstTriggerBonus)
		for i=0, 14 do
			local col = i+1
			local tempCol = i%5+1
			local theAction = self:getSpinColStopAction(ret["theme_info"], tempCol,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	else 
		
		local stopColOrderList = {}

		for i=1, 5 do
			table.insert(stopColOrderList, i)
		end	

		for index,col in pairs(stopColOrderList) do
			local theAction = self:getSpinColStopAction(ret["theme_info"], col,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	end
	return stopConfig
end

function customizedTheme:onReelStop(col)

	if self.showReSpinBoard then
		if self.lockedReels[col] then return end
		local item_List = self.recvItemList
		local key = item_List[col][1]
		if key > 20 then
			self.lockedReels[col] = true
			if self.bonus and self.bonus.lockReelList then
			   self.bonus.lockReelList[col] = true
			end
            
            local cell = self.spinLayer.spins[col]:getRetCell(1)
            
            local old_parent = cell:getParent()
            bole.changeParent(cell,self.coinScaleAniNode,col)

			self:playMusic(self.audio_list.bonus_symbolLand)
			cell:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.5,1.5),
				cc.ScaleTo:create(0.15,1,1)
			))
            
            local i,j = reverseReelIndexChangeList[col][1],reverseReelIndexChangeList[col][2]
            if self.bonus and self.bonus.data.mulPosRecordList[i][j] then
	            self.chooseRecordList_redImage[col]:setVisible(false)
				self.bonus:showMulFrameAnimation(col,true)
			end
			
			self:laterCallBack(0.5,function( ... )
				bole.changeParent(cell, old_parent)
				if not cell.aniNode then
					cell.aniNode = cc.Node:create()
					cell.aniNode:setCascadeOpacityEnabled(true)
	                cell.sprite:addChild(cell.aniNode,8)
	                cell.aniNode:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
	            end
                
                self.bonus:showCoinSymbolFireAnimation(cell.aniNode,true,true)

			end)
			
            self.isReelChange = true 
           
            if self.respinStep == ReSpinStep.Playing then
				self.respinStep = ReSpinStep.Reset
			end
		end
	end

	Theme.onReelStop(self, col)
end

function customizedTheme:onReelFallBottom( pCol )

end

function customizedTheme:onReelFastFallBottom(pCol)

end

function customizedTheme:onSpinStart()

	self.DelayStopTime = 0
	Theme.onSpinStart(self)
end

function customizedTheme:onRespinStart()
	self.DelayStopTime = 0
	self.bonus:onRespinStart()
	
	Theme.onRespinStart(self)
end

function customizedTheme:onRespinStop(ret)
	self:fixRet(ret)
	--print("wy_onRespinStop_fixRet")
	if #ret["theme_respin"] == 0 then
		self.respinStep = ReSpinStep.Over
		ret.theme_deal_show = true
	end
	Theme.onRespinStop(self, ret)
end

function customizedTheme:onAllReelStop()
    if self.showReSpinBoard then  	
    	if self.isReelChange then
    		self.isReelChange = false    		
			local respin_item = self.ctl.rets["item_list"]
			--print("wy_respinItem",tool.lua_to_json(respin_item))
			local all_count = 0
			for i = 1,15 do
				if respin_item[i][1] > 20 then -- 只有有钱的算在内
					all_count = all_count + 1
				end    				
			end
			local nextSpinDelay = (all_count > 0) and 0.8 or 0.5
			
    		self.ctl.rets["control_add_delay"] = nextSpinDelay
    		self.bonus:updateNormalRespinState()
    	end
    end

    Theme.onAllReelStop(self)
end

function customizedTheme:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果

	if self.respinStep == ReSpinStep.Playing then 
		--print("wy_fixRet")
		self.ctl.resultCache = {}	-- ret["reelItem_list"] = {} -- 添加

		local itemsList = table.copy(ret.item_list)

		for i=0,14 do -- 横向拆分 和 棋盘一致
			ret.item_list[1+i] = {itemsList[1+(i%5)][1+math.floor(i/5)]}
			-- 在每一轴 拼接结果数据
			self.ctl.resultCache[1+i] = {math.random(21,38),itemsList[1+(i%5)][1+math.floor(i/5)]} --向上插入一个值 {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}-- ret["reelItem_list"][1+i] = {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}
			local col = 1+ (i-1)%5 -- 5,1,2,3,4
			local symbols = self.ctl.currentReels[col] -- 获得 1-5 轴的 滚轴数据
			--print("wy_symbols",col,tool.lua_to_json(symbols))

			local key = math.random(2,#symbols)
			local extraCount = 6
			if self.isTurbo then
				extraCount = 3
			end
			for k = 1,extraCount do -- 向下插入 六个 值
				key = 1 + (key + k - 1)%#symbols
				table.insert(self.ctl.resultCache[1+i],symbols[key])
				--print("wy_0?",key,symbols[key])
			end
			--print("wy_fixRet_for",col,tool.lua_to_json(self.ctl.resultCache[1+i]))
		end
	end

	self.recvItemList = ret.item_list
	--print("wy_fixRet",tool.lua_to_json(self.recvItemList))
end

function customizedTheme:theme_respin( rets )
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
		local respinList = rets["theme_respin"]
		
		--print("wy_respinList",#respinList)
		if respinList and #respinList>0 then
			rets["item_list"] = table.remove(respinList, 1)
			--print("wy_respinList",tool.lua_to_json(rets["item_list"]))
			
			local respinStopDelay = 1
			local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
			self:stopDrawAnimate()
			self.ctl:respin(respinStopDelay, endCallFunc)
		else
			rets["theme_respin"] = nil
		end	
	end)))
end

function customizedTheme:theme_deal_show(ret)
	ret.theme_deal_show = nil
	if self.respinStep == ReSpinStep.Over then
		self.bonus:onRespinFinish(ret)
	end
end

-- 添加Font
function customizedTheme:addCoinSymbolLabel()
	local file = self:getPic("fonts/HQ.fnt")

	local fntLabel = NumberFont.new(file, nil, true)
	function fntLabel:setString( n )  -- 控制显示文字 带k,m 同时保留3位有效数字
		if n == "" then 
			self.font:setString("")
		else
			self.font:setString(FONTS.formatByCount2(n,5,true))
		end
	end
	
	return fntLabel
end

local keyValueSet = Set({21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38})

function customizedTheme:getCoinSymbolValue(key) 
	
	if keyValueSet[key] then
		local bet = self.ctl:getCurTotalBet()
		--print("wy_getCoinSymbolValue_bet= ",bet,"key= ",key)
		local value = bet * epicLinkMul[key]
		return value
	else
		return ""
	end
end

function customizedTheme:createCellSprite(key, col, rowIndex)
	--print("wy_createCellSprite:key= ",key)
	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key
----------------
	self.initialPics = self.initialPics or {}
	if self.specialItemConfig[key] then
		local colSet = self.specialItemConfig[key]["col_set"] or {}
		if colSet[col] then
			if colSet[col] == 0 then
				key = self:getNormalKey(col)
			elseif colSet[col] == 1 then
				if self.initialPics[col] then
					key = self:getNormalKey(col)
				else
					self.initialPics[col] = true
				end
			end
		end
	end
	--print("wy_createCellSprite2:key= ",key)
	------------------------------------------------------------

	key = 1
	theCellFile   = self.pics[key]

	local theCellNode   = cc.Node:create()
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0
	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	end
	
	local ret = theCellNode

	ret.font = self:addCoinSymbolLabel(true)
	local cellSize = self.spinLayer:getCellSize(col)
	ret.sprite:addChild(ret.font,10)
	ret.font:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
	ret.font:setString("")
	ret.font:setVisible(false)

	ret.aniNode = cc.Node:create()
	ret.aniNode:setCascadeOpacityEnabled(true)
	ret.sprite:addChild(ret.aniNode,6)
	ret.aniNode:setPosition(cc.p(Jsize.width/2, Jsize.height/2))

	if key == 1 then
		if self.value then
			ret.font:setString(self.value)
			self.value = nil
		else
			local randomKey = math.random(21,38)
			local coinValue = self:getCoinSymbolValue(randomKey)
			ret.font:setString(coinValue)
		end
		ret.font:setVisible(true)
	end

	--print("wy_createCellSprite",key,theCellFile)

	return ret
end

function customizedTheme:updateCellSprite(theCellNode, key, col)
    --print("wy_updateCellSprite1",key)
    if key == 1 then
    	key = math.random(21,38)
    end
	if keyValueSet[key] then
		if not theCellNode.font then
			theCellNode.font = self:addCoinSymbolLabel()
			theCellNode.sprite:addChild(theCellNode.font,10)
			theCellNode.font:setPosition(cc.p(Jsize.width/2, Jsize.height/2))	
		end
		theCellNode.font:setVisible(true)
		
		local coinValue = self:getCoinSymbolValue(key)
		--print("wy_coinValue",coinValue)
		theCellNode.font:setString(coinValue)
		key = 1
	else
		if theCellNode.font then
			theCellNode.font:setVisible(false)
		end
		
		key = 2		
	end

	--print("wy_updateCellSprite2",key)

	local theCellFile 	= self.pics[key]

	--print("wy_updatedCell_change",key,theCellFile)

	------------------------------------------------------------
	
	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0
	------------------------------------------------------------

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

--------------------------Bonus Game相关----------------------------
function customizedTheme:saveBonusCheckData(bonusData)
    -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
    local data = {}
    data["bonus_id"] = bonusData.bonus_id
    LoginControl:getInstance():saveBonus(self.themeid, data)
end

function customizedTheme:cleanBonusSaveData(data)
    -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
    LoginControl:getInstance():saveBonus(self.themeid, nil)
end

function customizedTheme:getBonusTriggerItemList()
	--print("wy_bonusRets",tool.lua_to_json(self.ctl.rets))
	local item_list = {{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}}
	return item_list
end

function customizedTheme:clearChooseBouns( ... )
	if self.bonus then
		self.bonus:setTopMessageState("jp")
		self.ctl:handleResult()
		self:dealMusic_PlayBonusLoopMusic()
	end
end

function customizedTheme:setBet(bet)
	local set_Bet = bet
	self.ctl:setCurBet(set_Bet)
end

SmokinHotRespinBonusGame = class("SmokinHotRespinBonusGame")
local BSGame = SmokinHotRespinBonusGame

local jpWinTypeList = {[13] = 2,[14] = 1,[15] = 0}

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.theme.bonus 	= self 
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.ctl 			= bonusControl.themeCtl

	self.currentBet = self.data.core_data["bet"]
	--print("wy_respinData",tool.lua_to_json(self.data.core_data["theme_respin"]))
    self.respinData = tool.tableClone(self.data.core_data["theme_respin"])
    self.mulplier = self.data.core_data["multi"]
    --print("wy_mulplier",self.data.core_data["multi"])
    self.winRecordList = self.respinData[#self.respinData]
    self.allSpinCount = self.data.core_data["theme_respin_count"]
    self.isServerRecall = self.data.core_data["multi_pos"]
    self.bonusItem = self.theme:getBonusTriggerItemList()
    self.lockReelList = {}
    self.mulFrameSkeletonList = {}


	self.data.spinCount = self.data.spinCount or 0
	--print("wy_data.spinCount",self.data.spinCount)
	self.data.remainingCount = self.data.remainingCount or 3

	self.data.mulPosRecordList = self.data.mulPosRecordList or {{false,false,false},{false,false,false},{false,false,false},{false,false,false},{false,false,false}}
	
	if self.isServerRecall and not self.data.mulPosRecordList then
		local serverRecord = self.data.core_data["multi_pos"]
		for i = 1,#serverRecord do
			local data = serverRecord[i]
			self.data.remainingCount[data[1]][data[2]] = true
		end
	end

	-- for i = 1,5 do
	-- 	for j = 1,3 do
	-- 		if self.data.mulPosRecordList[i][j] then
 --               print("wy_mulPosRecordList:i= ",i,"j= ",j)
 --            end
 --        end
 --    end
	self:saveBonus()
    
    

    local winCount = 0
    self.jpWinType = nil
    for i = 1,5 do
    	for j = 1,3 do
    		if self.winRecordList[i][j] > 0 then
    			winCount = winCount + 1
    			if winCount >= 13 then
                   self.jpWinType = jpWinTypeList[winCount]
                end
    		end
    	end
    end
    --print("wy_jpWinType",self.pWinType)

    if self.jpWinType and self.jpWinType >= 0 then   
    	local jpWinList = self.data.core_data["jp_win"]
    	--print("wy_jpWinList",tool.lua_to_json(jpWinList))
    	if jpWinList[1]["jp_win_type"] == self.jpWinType then
    	   self.jpWin = jpWinList[1]["jp_win"]
    	end	    
    end
end

function BSGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:enterBonusGame(tryResume)
	
	-- 锁住jackpot meter
	self.theme:lockJackpotMeters(true)

	self.theme:hideActivitysNode()
	
	self:setJackotValue(self.currentBet)

	-- 禁掉spin按钮
	self.theme.ctl.footer:setSpinButtonState(true)
	self.theme.ctl.footer:isShowTotalBetLayout(false)
    
    -- 更改棋盘
	self.theme:showBonusNode()
	self.theme:changeSpinBoard(SpinBoardType.ReSpin)
	self:setBoardSymbols(self.bonusItem)
	--self.theme:setBet(self.currentBet)

	-- spin 结果数据和 显示stop 按钮有关
    self.ctl.cacheSpinRet = self.ctl.cacheSpinRet or self.ctl.rets

    --self.theme:dealMusic_PlayBonusLoopMusic()
    
    local function playIntro()

    	self:initNormalRespinData()
    	-- self.theme.triggerText:setScale(0)
    	-- self.theme.triggerText:setVisible(true)
    	-- self.theme.triggerBoardNode:setOpacity(255)
    	-- self.theme.triggerBoardNode:setVisible(true)
    	self.theme:dealMusic_PlayBonusLoopMusic("choose")
    	
    	self.theme:runAction(cc.Sequence:create(
    		cc.CallFunc:create(function()
    			self:initAllChooseBtnState()
    			self:setTopMessageState("choose",0)
    			self.theme.label_collectedNum:setString(0)
    			--self.theme.triggerBoardNode:runAction(cc.FadeOut:create(0.3))
    			
    		end),
    		cc.DelayTime:create(0.5),
    		cc.CallFunc:create(function()
    			for i = 1,5 do
    				for j = 1,3 do
    					local index = reelIndexChangeList[i][j]
    					 --print("wy_btn_index",index)
    					self:initChooseBtnEvent(index,"choose")
    				end
    			end 			
    		end)
    	))
    end

    local function snapIntro()
    	local function recoverSpinState( ... ) 
    		local function recoverNormalSpin()
    			
				if self.data.spinCount > 0 then
					self.data.spinCount = self.data.spinCount - 1
					if self.data.remainingCount < 3 then
		    		   self.data.remainingCount = self.data.remainingCount + 1
		    		end
		    	end
		    	self:saveBonus()

		    	self:initCoinsOnBoard()

		    	for i = 1,15 do
	    			if self.data.mulPosRecordList[i] and #self.data.mulPosRecordList[i] > 0 then
	    				
	    			end
	    		end

	    		for i = 1,5 do
					for j = 1,3 do
						if self.data.mulPosRecordList[i][j] then
						   local index = reelIndexChangeList[i][j]
						    if self.lockReelList[index] then
						   	    self:showMulFrameAnimation(index)
						   	else
			                    self.theme.chooseRecordList_redImage[index]:setVisible(true)
			                end
	    				    self.theme.chooseRecordList_mulLabel[index]:setString("X"..self.mulplier)
	    				    self.theme.chooseRecordList_mulLabel[index]:setVisible(true)
			            end
			        end
			    end

		    	local count = self:getLockedCount()
		        self.theme.label_collectedNum:setString(count)

				local recoverList = self.respinData[self.data.spinCount + 1]
				self:setBoardSymbols(recoverList)

				--self:playRecoverCoinsAnimation(recoverList)

				self:setRemainingCount(self.data.remainingCount)

				local removeCount = self.data.spinCount+1
	           
	    		for i=1,removeCount do
	    			table.remove(self.ctl.rets["theme_respin"],1)
	    		end

	    		self.theme:laterCallBack(1,function()
	    			self.ctl:handleResult()
			        --self.theme:dealMusic_PlayBonusLoopMusic()
	    		end)    		
	    	end

	    	local function showCollect()
	    		self:initCoinsOnBoard()
	    		for i = 1,5 do
					for j = 1,3 do
						if self.data.mulPosRecordList[i][j] then
						   local index = reelIndexChangeList[i][j]
			               if self.lockReelList[index] then
						   	    self:showMulFrameAnimation(index)
						   	else
			                    self.theme.chooseRecordList_redImage[index]:setVisible(true)
			                end
	    				   self.theme.chooseRecordList_mulLabel[index]:setString("X"..self.mulplier)
	    				   self.theme.chooseRecordList_mulLabel[index]:setVisible(true)
			            end
			        end
			    end
				local count = self:getLockedCount()
				self.theme.label_collectedNum:setString(count)
				self.ctl.rets["theme_respin"] = nil
				local recoverList = self.respinData[self.allSpinCount+1]
				self:setBoardSymbols(recoverList)
				--self:playRecoverCoinsAnimation(recoverList)
				self:onRespinFinish()
	    	end

    		if self.data.spinCount == self.allSpinCount then 
    			self:setTopMessageState("win",nil,0)
    			showCollect()
    		else
    			self:setTopMessageState("jp")
    			recoverNormalSpin()
    			self.theme:dealMusic_PlayBonusLoopMusic()
    		end
    	end

    	local function recoverChooseState( ... )
    		self.theme.label_collectedNum:setString(0)
    		self:initAllChooseBtnState()
    		local choosedCount = self:getChoosedCount()
    		if choosedCount == 3 then
    			for i = 1,5 do
    				for j = 1,3 do
    					if self.data.mulPosRecordList[i][j] then
    				       local index = reelIndexChangeList[i][j]
    					   self:initChooseBtnEvent(index,"regret")
    					end
    				end
    			end
    			self:setTopMessageState("start",3)
    			self:initStartBtnEvent()
    		else
    		    local choosedCount = 0 
    		    for i = 1,5 do
    				for j = 1,3 do
    					local index = reelIndexChangeList[i][j]
    					if self.data.mulPosRecordList[i][j] then
    					   self:initChooseBtnEvent(index,"regret")
    					   choosedCount = choosedCount + 1
    					else
                           self:initChooseBtnEvent(index,"choose")
    					end
    				end
    			end  				
	    		self:setTopMessageState("choose",choosedCount)
	    	end
    	end

    	if self.isServerRecall then
    		recoverSpinState()
    	else
    		recoverChooseState()
    		self.theme:dealMusic_PlayBonusLoopMusic("choose")
    	end
    end

	
	if self.data.mulPosRecordList and self:getChoosedCount() > 0 then
		snapIntro()
	else
		playIntro()
	end

end

function BSGame:initNormalRespinData( ... )
	-- 去掉第一组值
	local allData = tool.tableClone(self.data.core_data["theme_respin"])
	table.remove(allData,1)
    self.ctl.rets["theme_respin"] 		= allData
	self.ctl.rets["progressive_list"] 	= self.data.core_data["progressive_list"]
end

function BSGame:setJackotValue(bet)
	local mulList = {5000,100,10}
	local jpLabels = self.theme.jackpotLabels
	for i = 1,3 do
		local mul = mulList[i]
		local value = bet * mul
		jpLabels[i]:setString(self.theme:formatJackpotMeter(value))
	end
end

function BSGame:initAllChooseBtnState()
	local recordList = self.data.mulPosRecordList or {}
	local choosedCount = self:getChoosedCount()
	for i = 1,5 do
	    for j = 1,3 do
	        local index = reelIndexChangeList[i][j]	
		    if recordList[i][j] then	
				self.theme.chooseRecordList_redImage[index]:setVisible(true)
				self.theme.chooseRecordList_mulLabel[index]:setVisible(true)
				self.theme.chooseRecordList_mulLabel[index]:setString("X"..self.mulplier)
				self.theme.chooseItemList[index].green:setVisible(false)
				self.theme.chooseItemList[index].gray:setVisible(false)
				self.theme.chooseItemList[index].btn:setTouchEnabled(true)
			else
				if choosedCount == 3 then
			        self.theme.chooseRecordList_redImage[index]:setVisible(false)
				    self.theme.chooseRecordList_mulLabel[index]:setVisible(false)
				    self.theme.chooseItemList[index].green:setVisible(false)
				    self.theme.chooseItemList[index].gray:setVisible(true)
				    self.theme.chooseItemList[index].btn:setTouchEnabled(false)		
				else
					self.theme.chooseRecordList_redImage[index]:setVisible(false)
				    self.theme.chooseRecordList_mulLabel[index]:setVisible(false)
				    self.theme.chooseItemList[index].green:setVisible(true)
				    self.theme.chooseItemList[index].gray:setVisible(false)
				    self.theme.chooseItemList[index].btn:setTouchEnabled(true)	
				end
			end
		end

	end
end

function BSGame:initChooseBtnEvent(btn_index,state)
    
	-- 点击按钮
	local pressFunc_choose = function(obj)
		local i,j = reverseReelIndexChangeList[btn_index][1],reverseReelIndexChangeList[btn_index][2]
		self.data.mulPosRecordList[i][j] = true
		local choosedCount = self:getChoosedCount()
		self:saveBonus()
		-- for k,v in pairs(self.data.mulPosRecordList) do
		-- 	print("wy_k= ",k,"v=",tool.lua_to_json(v))
		-- end
		--print("wy_initChooseBtnEvent:btn_index",btn_index)
		self.theme.chooseRecordList_redImage[btn_index]:setVisible(true)
		self.theme.chooseRecordList_mulLabel[btn_index]:setVisible(true)
		self.theme.chooseRecordList_mulLabel[btn_index]:setString("X"..self.mulplier)
		self.theme.chooseItemList[btn_index].green:setVisible(false)
		self.theme.chooseItemList[btn_index].gray:setVisible(false)
		self.theme.chooseItemList[btn_index].btn:setTouchEnabled(true)
		local remainingCount = 3 - choosedCount
		for i = 1,3 do
			if remainingCount > 0 then
			   self.theme.choosedNumImageList[i]:setVisible(i == remainingCount)
			end
		end
        
        self.theme:stopMusic(self.theme.audio_list.bonus_select)
		self.theme:playMusic(self.theme.audio_list.bonus_select,true)

		self:initChooseBtnEvent(btn_index,"regret")	
		
		if choosedCount == 3 then
		   self:judgeIsChooseFinish()	
		end
	end

	local pressFunc_reget = function(obj)
	    local i,j = reverseReelIndexChangeList[btn_index][1],reverseReelIndexChangeList[btn_index][2]
		self.data.mulPosRecordList[i][j] = false
		  
		self:saveBonus()
		
		local choosedCount = self:getChoosedCount()
	
		local remainingCount = 3 - choosedCount

		for i = 1,3 do
			if remainingCount > 0 then
			   self.theme.choosedNumImageList[i]:setVisible(i == remainingCount)
			end
		end
		self.theme.chooseRecordList_redImage[btn_index]:setVisible(false)
		self.theme.chooseRecordList_mulLabel[btn_index]:setVisible(false)
		self.theme.chooseItemList[btn_index].green:setVisible(true)
		self.theme.chooseItemList[btn_index].gray:setVisible(false)
		self.theme.chooseItemList[btn_index].btn:setTouchEnabled(true)
		
		self:initChooseBtnEvent(btn_index,"choose")	

		self.theme:stopMusic(self.theme.audio_list.bonus_cancel)
		self.theme:playMusic(self.theme.audio_list.bonus_cancel,true)
			
		self:recoverCouldChooseState()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
		    if state == "choose" then
			   pressFunc_choose(obj)
			elseif state == "regret" then
			   pressFunc_reget(obj)
			end
		end
	end

	-- 设置按钮
	self.theme.chooseItemList[btn_index].btn:addTouchEventListener(onTouch)
end

function BSGame:getChoosedCount()
	local count = 0
	for i = 1,5 do
		for j = 1,3 do
			if self.data.mulPosRecordList[i][j] then
				count = count + 1
			end
		end
	end
	return count 
end

function BSGame:judgeIsChooseFinish()
	for i = 1,5 do
		for j = 1,3 do
			local index = reelIndexChangeList[i][j]
			if not self.data.mulPosRecordList[i][j] then
				self:setBtnUnEnableState(index)
			end
		end
	end
    self:setTopMessageState("start")
	self.theme.btn_pressStartGame:setTouchEnabled(true)
	self:initStartBtnEvent()
	
end

function BSGame:recoverCouldChooseState()
	if self:getChoosedCount() < 3 then
		
		for i = 1,5 do
			for j = 1,3 do
				local index = reelIndexChangeList[i][j]
				if not self.data.mulPosRecordList[i][j] then
					self.theme.chooseItemList[index].green:setVisible(true)
					self.theme.chooseItemList[index].gray:setVisible(false)
					self.theme.chooseItemList[index].btn:setTouchEnabled(true)
					self:initChooseBtnEvent(index,"choose")	
				end
			end
		end
		self:setTopMessageState("choose",self:getChoosedCount())
	end
end


function BSGame:setBtnUnEnableState(btn_index)
	self.theme.chooseItemList[btn_index].green:setVisible(false)
	self.theme.chooseItemList[btn_index].gray:setVisible(true)
	self.theme.chooseItemList[btn_index].btn:setTouchEnabled(false)
end

function BSGame:initStartBtnEvent()
	self.isStartBtnPress = false
	-- 点击按钮
	local pressFunc = function(obj)
	    self.theme.pressStartText:stopAllActions()
	    self.theme.pressStartText:setOpacity(255)
	    self.theme.btn_pressStartGame:setTouchEnabled(false)
		local special_data = {}
	    special_data.multi_pos = {}
	    local index = 0
	    for i = 1,5 do
	    	for j = 1,3 do
	    		local btn_index = reelIndexChangeList[i][j]
	    		self.theme.chooseItemList[btn_index].btn:setTouchEnabled(false)
	    		if self.data.mulPosRecordList[i][j] then
	    			index = index + 1
	    			special_data.multi_pos[index] = {}
	    		    special_data.multi_pos[index][1] = i
	    		    special_data.multi_pos[index][2] = j
	    		end
	    	end
	    end
	    --self.theme:playMusic(self.theme.audio_list.bonus_pressStart)
	    self.ctl:collectCoins(2,special_data)    
	end

	local function onTouch(obj, eventType)
		if self.isStartBtnPress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.theme.btn_pressStartGame:addTouchEventListener(onTouch)
end

function BSGame:setTopMessageState(state,choosedCount,winValue)
	if state == "choose" then
		self.theme.label_currentMul:setString("X"..self.mulplier)
		local remainingCount = 3 - choosedCount
		for i = 1,3 do
			self.theme.choosedNumImageList[i]:setVisible(i == remainingCount)
		end
		self.theme.chooseMessageNode:setVisible(true)
		self.theme.topWinMessageNode:setVisible(false)
		self.theme.progressive_node:setVisible(false)
		self.theme.pressStartNode:setVisible(false)
		self.theme.btn_pressStartGame:setTouchEnabled(false)
		self.theme.chooseNode:setVisible(true)
		self:setPressTextState(false)
	elseif state == "start" then
		self.theme.chooseMessageNode:setVisible(false)
		self.theme.topWinMessageNode:setVisible(false)
		self.theme.progressive_node:setVisible(false)
		self.theme.pressStartNode:setVisible(true)
		self.theme.btn_pressStartGame:setTouchEnabled(true)
		self.theme.chooseNode:setVisible(true)
		self:setPressTextState(true)
	elseif state == "jp" then
		self.theme.chooseMessageNode:setVisible(false)
		self.theme.topWinMessageNode:setVisible(false)
		self.theme.progressive_node:setVisible(true)
		self.theme.pressStartNode:setVisible(false)
		self.theme.btn_pressStartGame:setTouchEnabled(false)
		self.theme.chooseNode:setVisible(false)
		self:setPressTextState(false)
	elseif state == "win" then
		self.theme.chooseMessageNode:setVisible(false)
		self.theme.topWinMessageNode:setVisible(true)
		self.theme.progressive_node:setVisible(false)
		self.theme.pressStartNode:setVisible(false)
		self.theme.btn_pressStartGame:setTouchEnabled(false)
		self.theme.chooseNode:setVisible(false)
		if winValue == 0 then
			self.theme.label_topWin:setString("")
		else
			self.theme.label_topWin:setString(FONTS.formatByCount2(winValue,24,true))
		end
	end
end

function BSGame:setPressTextState(isShow)
	if isShow then
		self.theme.pressStartText:setOpacity(255)
		self.theme.pressStartText:runAction(cc.RepeatForever:create(cc.Sequence:create(
			cc.FadeOut:create(0.8),
			cc.FadeIn:create(0.8)
		)))
	else
		self.theme.pressStartText:stopAllActions()
	end
end

function BSGame:setBoardSymbols(item_list)
	for i = 1,5 do 
		for j = 1,3 do
			local col = reelIndexChangeList[i][j]
			
			local cell = self.theme.spinLayer.spins[col]:getRetCell(1)
			local key = 0
			if item_list[i][j] > 20 then
				key = item_list[i][j]
				self.theme.lockedReels[col] = true	
				if not cell.aniNode then
					cell.aniNode = cc.Node:create()
					cell.aniNode:setCascadeOpacityEnabled(true)
	                cell.sprite:addChild(cell.aniNode,8)
	                cell.aniNode:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
	            end
				self:showCoinSymbolFireAnimation(cell.aniNode)							
			end
	
			self.theme:updateCellSprite(cell, key, col, 1)
			if not cell.font then
				if keyValueSet[key] then
		            cell.font = self.theme:addCoinSymbolLabel(key)
		            local value = self.theme:getCoinSymbolValue(key)
		            cell.font:setString(FONTS.formatByCount2(value,5,true))
		        end
		    end
		end
	end
end

function BSGame:initCoinsOnBoard()

	local index = self.data.spinCount + 1
	--print("wy_initCoinsOnBoard:index= ",index, "list = ",tool.lua_to_json(self.respinData[index]))
	local itemList = self.respinData[index]
	for i = 1,5 do
		for j = 1,3 do
			if itemList[i][j] > 20 then
				local index = reelIndexChangeList[i][j]
				self.lockReelList[index] = true
				self.theme.lockedReels[index] = true
	        end
	    end
	end
end

function BSGame:getLockedCount()
	local count = 0
	for k,v in pairs(self.lockReelList) do
		if v then
			count = count + 1
		end
	end

	return count
end

function  BSGame:updateNormalRespinState()
	local count = self:getLockedCount()
	self.theme.label_collectedNum:setString(count)
	self.data.remainingCount = 3
	self:saveBonus()
	self:setRemainingCount(3)
end

function  BSGame:setRemainingCount(remainingNum)
	local function playResetAnimation()
		if remainingNum == 3 then
			local file = self.theme:getPic("spine/resetRemainingEffect/spine")
			self.theme:addSpineAnimation(self.theme.remainingResetAniNodeLeft,nil,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
			self.theme:addSpineAnimation(self.theme.remainingResetAniNodeRight,nil,file,cc.p(0,0),"animation",nil,nil,nil,false,false,nil)
			--self.theme:playMusic(self.theme.audio_list.bonus_remainingReset)
		end
	end

	if remainingNum then    
		for i = 0,3 do
			self.theme.leftRemainingNumList[i]:setVisible(i == remainingNum)
			self.theme.rightRemainingNumList[i]:setVisible(i == remainingNum)
		end
        self.theme.earNode:setVisible(true)
		
		playResetAnimation()
	end	
end

function BSGame:onRespinStart()
	self.theme.respinStep = ReSpinStep.Playing
	self.data.spinCount = self.data.spinCount + 1
	
	self.data.remainingCount = self.data.remainingCount - 1
	self:setRemainingCount(self.data.remainingCount)
	if self.data.remainingCount >= 0 then
		self.theme:playMusic(self.theme.audio_list.bonus_remaining)
	end	
	self:saveBonus()
end

function BSGame:showCoinSymbolFireAnimation(node,isTrigger,isPlaySound)
	local parent = node
	local file = self.theme:getPic("spine/symbol/spine")
	local _,skeleton = nil,nil
	if isTrigger then
		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				 _,skeleton = self.theme:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation1",nil,nil,nil,true,false,nil)
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				skeleton:setAnimation(0,"animation2",true)
			end)
		))
	else
		self.theme:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation2",nil,nil,nil,true,true,nil)
	end
		
	if isPlaySound then
		self.theme:playMusic(self.theme.audio_list.bonus_coin_effect)
	end
end

function BSGame:showMulFrameAnimation(index,isTrigger)
	local parent = self.theme.chooseRecordList_aniNode[index]
	local file = self.theme:getPic("spine/mul_frame/spine")
	if isTrigger then
		local _,s = self.theme:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
		self.mulFrameSkeletonList[index] = s
	else
		local _,s = self.theme:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
		self.mulFrameSkeletonList[index] = s
	end
end

function BSGame:onRespinFinish(ret)
	local jpWinDelay = 0
	local jpWinShow = false
	--print("wy_jpWin",self.jpWin)
	if self.jpWin and self.jpWin > 0 then
		jpWinDelay = 4
		jpWinShow = true
	end
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function( ... )
			self.theme:stopAllLoopMusic()
			self.theme:playMusic(self.theme.audio_list.bonus_respinEnd)			
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()
			
			self:setTopMessageState("win",nil,0)
			if jpWinShow then
				self:showJpWinBoard()
			end				
		end),
		cc.DelayTime:create(jpWinDelay),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function( ... )
			if not jpWinShow then
			   self:collectBonusWin(true)
			end
		end)
	))	
	
end

function BSGame:showJpWinBoard()
	local jpwinType = self.jpWinType + 1
	for i = 1,3 do
    	self.theme.jpWinTitleList[i]:setVisible(i == jpwinType)
    end
	self.theme.jpWinNode:setScale(0)
	self.theme.dimmer:setOpacity(0)
	local rollupDuration = 3
	self.bonusWin = self.jpWin
	self.theme.label_jpWin:nrStartRoll(0,self.bonusWin,rollupDuration)
	self.theme.jpWinNode:setVisible(true)
	self.theme.dimmer:setVisible(true)
	local file = self.theme:getPic("spine/jpBoardEffect/spine")
	self.theme:addSpineAnimation(self.theme.jpWinBoardAniNode,nil,file,cc.p(5,20),"animation",nil,nil,nil,true,true,nil)
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function( ... )
			self.theme.jpWinNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.25,1.5,1.5),
				cc.ScaleTo:create(0.15,1,1)
			))
			self.theme.dimmer:runAction(cc.FadeIn:create(0.3))
			self.theme:playMusic(self.theme.audio_list.bonus_popup_in)	
		end),
		cc.DelayTime:create(0.4),
		cc.CallFunc:create(function( ... )
			self.theme.btn_collectJp:setTouchEnabled(true)
			self:initJpWinBoardEvent()			
		end)
	))
	
end

function BSGame:initJpWinBoardEvent()
	-- 点击按钮
	local pressFunc = function(obj)
	    self.theme.btn_collectJp:setBright(false)
	    self.theme.btn_collectJp:setTouchEnabled(false)
	    self.theme.jpWinNode:setScale(1)
		self.theme.jpWinNode:setVisible(true)
		self.theme.dimmer:setOpacity(255)
		self.theme.dimmer:setVisible(true)
		
		self.theme.label_topWin:setString(FONTS.formatByCount2(self.bonusWin,24,true))
		self.ctl.footer:setWinCoins(self.bonusWin)
		self.theme.label_jpWin:nrStopRoll()
		self.theme.label_jpWin:setString(FONTS.formatByCount2(self.jpWin,11,true))

		self.theme:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function( ... )
				self.theme.jpWinNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.15,1.5,1.5),
					cc.ScaleTo:create(0.25,0,0)
				))
				self.theme.dimmer:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function( ... )
				self.theme.jpWinBoardAniNode:removeAllChildren()
				self:collectBonusWin(true)
			end)
		))
		
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.theme.btn_collectJp:addTouchEventListener(onTouch)
end

function BSGame:collectBonusWin(isFirst,allCount,coinsWinCounts,resultRecordList)
	local resultList = self.respinData[#self.respinData]
	--print("wy_respinData",tool.lua_to_json(self.respinData))
	--print("wy_resultList",tool.lua_to_json(resultList))
	
	allCollectCount = allCount or 0
	coins_winCount = coinsWinCounts or 0
	resultRecordList = resultRecordList or {}
	if isFirst then
		--self.allBonusWin = self.previousWin
		self.bonusWin = self.bonusWin or 0
		
		resultRecordList =  -- 0 none / 1 normal / 2 jp
		{
	       {0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},
	    }

	    for i = 1,5 do
	    	for j = 1,3 do
	    		local key = resultList[i][j]
	    		if key > 20 then
	    			resultRecordList[i][j] = 1
	    			coins_winCount = coins_winCount + 1
	    			allCollectCount = allCollectCount + 1
	    		end
	    	end
	    end
	    
	    --allCollectCount = (allCollectCount == 15) and 16 or allCollectCount
	end

    local function showNormalCollect()
    	local key = 0
    	local reelX = 0
    	local reelY = 0
    	local cur_value = 0
    	local jpType = 0
    	local jpWin = 0
    	local choose_mul = 1

    	for i = 1,5 do
    		for j = 1,3 do
    			if cur_value == 0 then
	    			key = resultList[i][j]
	                if key > 20 and resultRecordList[i][j] > 0 then
	    				resultRecordList[i][j] = 0
	    				coins_winCount = coins_winCount - 1
	                    cur_value = self.currentBet * epicLinkMul[key]
                        reelX = i
                        reelY = j
                        if self.data.mulPosRecordList[i][j] then
                        	choose_mul = self.mulplier
                        end

		            end
		        end
            end
        end

        local reelIndex = reelIndexChangeList[reelX][reelY]
        local cell = self.theme.spinLayer.spins[reelIndex]:getRetCell(1)

        self.theme:runAction(cc.Sequence:create(
        	cc.DelayTime:create(0.5),
        	cc.CallFunc:create(function()
        		local aniName = "animation"..reelIndex
        		if not self.bonusCollectReelSkeleton then
	        		local parent = self.theme.bonusCollectReelAniNode
	        		local file = self.theme:getPic("spine/bonus_collect_reelEffect/spine")	
	        		local pos = cc.p(0,0)
	        		local _,s = bole.addSpineAnimation(parent,nil,file,pos,aniName,nil,nil,nil,true,false,nil)
	        		self.bonusCollectReelSkeleton = s
	        	else
	        		self.bonusCollectReelSkeleton:setAnimation(0,aniName,false)
	        	end

	        	self.theme:playMusic(self.theme.audio_list.bonus_respinCollect)
                if cell.aniNode then
                	cell.aniNode:runAction(cc.FadeOut:create(0.3))
                end

                if self.data.mulPosRecordList[reelX][reelY] then
                	local value = cur_value * choose_mul
                	self:showCollectMulLabelAnimation(reelIndex,value)
                end
	        	-- if self.coinsInfoList[reelIndex] then
	        	--    self:showCoinSymbolNormalRespinBurstAnimation(self.coinsInfoList[reelIndex])
	        	--    self.theme:laterCallBack(0.3,function()
	        	--        self.coinsInfoList[reelIndex][1]:setVisible(false)
	        	--    end)
	        	-- end
        	end),
        	cc.DelayTime:create(0.47),
        	cc.CallFunc:create(function()
        		cell.aniNode:removeAllChildren()
        		cur_value = cur_value * choose_mul
        		self.bonusWin = self.bonusWin + cur_value
        		self:setTopMessageState("win",nil,self.bonusWin)
        		--self.theme.label_allWin:setString(FONTS.formatByCount2(self.bonusWin, 15, true))
        		self.theme:playMusic(self.theme.audio_list.num_change)  
        		
        		self.ctl.footer:setWinCoins(self.bonusWin)
        	end),
        	cc.DelayTime:create(0.5),
        	cc.CallFunc:create(function( ... )
        		self:collectBonusWin(false,allCollectCount,coins_winCount,resultRecordList)
        	end)   

        ))

    end

    local function isFinishBonusCollect()
		if allCollectCount == 0 then
			self:showCollectBoard()
		end		
	end
  

	local function playCollect()
		
		if coins_winCount > 0 then
			showNormalCollect()
			allCollectCount = allCollectCount - 1
		else
			isFinishBonusCollect()
		end
	end

	playCollect()

end

function BSGame:showCollectMulLabelAnimation(index,value)
	local startPos = self.theme.bonusCollectMulLabelList[index].pos
	local endPos = cc.p(startPos.x,startPos.y+40)
	self.theme.bonusCollectMulLabelList[index].label:setOpacity(0)
	self.theme.bonusCollectMulLabelList[index].label:setPosition(startPos)
	self.theme.bonusCollectMulLabelList[index].label:setString(FONTS.formatByCount2(value,5,true))
	self.theme.bonusCollectMulLabelList[index].label:setVisible(true)

	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.bonusCollectMulLabelList[index].label:runAction(cc.Spawn:create(
				cc.MoveTo:create(3,endPos),
				cc.FadeIn:create(0.5)
			))
		end),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
			self.theme.bonusCollectMulLabelList[index].label:runAction(cc.FadeOut:create(0.5))
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.theme.bonusCollectMulLabelList[index].label:stopAllActions()
			self.theme.bonusCollectMulLabelList[index].label:setVisible(false)
		end)
	))
end

function BSGame:showCollectBoard( ... )
	self.theme.winNode:setScale(0)
	self.theme.winNode:setVisible(true)
	self.theme.dimmer:setOpacity(0)
	self.theme.dimmer:setVisible(true)
	local file = self.theme:getPic("spine/jpBoardEffect/spine")
	self.theme:addSpineAnimation(self.theme.winBoardAniNode,nil,file,cc.p(5,20),"animation",nil,nil,nil,true,true,nil)
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function( ... )
			local rollupDuration = 3
			self.theme.label_allWin:nrStartRoll(0,self.bonusWin,rollupDuration)
			--self.theme.label_allWin:setString(FONTS.formatByCount2(self.bonusWin,11,true))			
			self.theme.winNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.25,1.5,1.5),
				cc.ScaleTo:create(0.15,1,1)
			))
			self.theme.dimmer:runAction(cc.FadeIn:create(0.3))	
			self.theme:playMusic(self.theme.audio_list.bonus_popup_in)			
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function( ... )
			self.theme.btn_collectAll:setBright(true)
			self.theme.btn_collectAll:setTouchEnabled(true)
			self:initCollectAllEvent()
			-- 在此之后断电重连就不用恢复了
			self.data["end_game"] = true
			self:saveBonus()
			LoginControl:getInstance():saveBonus(self.theme.themeid, nil)

			-- 收钱
			self.theme.ctl:collectCoins(1)
		end)
	))
end

function BSGame:initCollectAllEvent( ... )
	-- 点击按钮
	local pressFunc = function(obj)
	    self.theme.btn_collectAll:setBright(false)
	    self.theme.btn_collectAll:setTouchEnabled(false)
	    self.theme.winNode:setScale(1)
		self.theme.winNode:setVisible(true)
		self.theme.dimmer:setOpacity(255)
		self.theme.dimmer:setVisible(true)
		self.theme.label_allWin:nrStopRoll()
		self.theme.label_allWin:setString(FONTS.formatByCount2(self.bonusWin,11,true))

		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function( ... )
				local user = User:getInstance()
		        user:addCoins(self.bonusWin)
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function( ... )				
				self.theme.winNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.15,1.5,1.5),
					cc.ScaleTo:create(0.25,0,0)
				))
				self.theme.dimmer:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function( ... )
				self.theme.winBoardAniNode:removeAllChildren()
				self.theme.finishBoardNode:setOpacity(0)
				self.theme.finishBoardNode:setVisible(true)
				self.theme.finishBoardNode:runAction(cc.FadeIn:create(0.3))
				self.theme:playMusic(self.theme.audio_list.bonus_complete)
			end),
			cc.DelayTime:create(2),
		    cc.CallFunc:create(function()
		    	self:exitBonus()
		    end)
		))
		
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.theme.btn_collectAll:addTouchEventListener(onTouch)
end


function BSGame:exitBonus( ... )
	self.theme:showActivitysNode()
	self.callback()
	-- 禁掉spin按钮
	self.theme.ctl.footer:setSpinButtonState(true)

	-- 退出blast mini game
	ActivityBController:getInstance():exitMiniGame(ACTIVITY_B.BLAST)
end
---------------------------声音相关----------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	-- bonus
	self.audio_list.bonus_background            = "audio/bonus/bonus_bgm.mp3"
	self.audio_list.bonus_background_choose     = "audio/bonus/bonus_bgm_choose.mp3"	
	self.audio_list.bonus_select                = "audio/bonus/bonus_select.mp3"
	self.audio_list.bonus_cancel                = "audio/bonus/bonus_cancel.mp3"
	--self.audio_list.bonus_pressStart            = "audio/bonus/bonus_start.mp3"
	self.audio_list.bonus_symbolLand            = "audio/bonus/bonus_symbolLand.mp3"
	self.audio_list.bonus_respinEnd             = "audio/bonus/bonus_respinEnd.mp3"
	self.audio_list.bonus_remaining             = "audio/bonus/bonus_remaining.mp3"
	--self.audio_list.bonus_remainingReset        = "audio/bonus/bonus_remainingReset.mp3"
	self.audio_list.bonus_respinCollect         = "audio/bonus/bonus_respin_collect.mp3"
	self.audio_list.bonus_popup_in              = "audio/bonus/bonus_popup_in.mp3"
	self.audio_list.bonus_complete              = "audio/bonus/bonus_complete.mp3"
	
end

function customizedTheme:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.bonus_select,
		self.audio_list.bonus_cancel,
		self.audio_list.bonus_symbolLand,  
		self.audio_list.bonus_respinEnd, 
		self.audio_list.bonus_remaining, 	
		self.audio_list.bonus_respinCollect,
		self.audio_list.bonus_popup_in,
		self.audio_list.bonus_complete
	}
	return loadMuscList
end

function customizedTheme:dealMusic_PlayBonusLoopMusic(type)
	self:stopAllLoopMusic()
	if type == "choose" then
		self:playLoopMusic(self.audio_list.bonus_background_choose)
	else
	    -- 播放背景音乐
	    self:playLoopMusic(self.audio_list.bonus_background)
	end
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
			[1] = {0,0,21,22,0,23,25,0,21,29,0,21,30,0,21,0,34,21,0,0,36,0,21,21,0,0},
			[2] = {0,22,0,21,0,21,25,0,21,29,0,21,21,0,30,0,21,21,0,0,21,0,21,21,0,0},
			[3] = {24,0,22,21,0,23,21,0,30,21,0,25,0,21,22,0,21,24,0,0,22,0,21,38,0,0},
			[4] = {0,0,21,22,0,21,25,0,21,29,0,30,21,0,21,0,21,21,0,0,0,21,35,0,21,0},
			[5] = {0,0,21,22,0,23,21,0,21,29,0,21,21,0,0,21,23,21,0,0,23,0,21,23,0,0}
		},
		["bonus_reel"] = {
			[1] = {0,0,21,22,0,23,25,0,21,29,0,21,30,0,21,0,34,21,0,0,36,0,21,21,0,0},
			[2] = {0,22,0,21,0,21,25,0,21,29,0,21,21,0,30,0,21,21,0,0,21,0,21,21,0,0},
			[3] = {24,0,22,21,0,23,21,0,30,21,0,25,0,21,22,0,21,24,0,0,22,0,21,38,0,0},
			[4] = {0,0,21,22,0,21,25,0,21,29,0,30,21,0,21,0,21,21,0,0,0,21,35,0,21,0},
			[5] = {0,0,21,22,0,23,21,0,21,29,0,21,21,0,0,21,23,21,0,0,23,0,21,23,0,0}
		},		
	}

	return data
end

----- 断线重连
function customizedTheme:adjustTheme(data)	
	--print("wy_adjustTheme_data",tool.lua_to_json(data))
    self:changeSpinBoard(SpinBoardType.ReSpin) 
end

--断线重连
function customizedTheme:enterThemeByBonus(theBonusGameData, endCallFunc)
    -- print("wy_theBonusGameData",tool.lua_to_json(theBonusGameData))
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

return ThemeSmokinHotRespin