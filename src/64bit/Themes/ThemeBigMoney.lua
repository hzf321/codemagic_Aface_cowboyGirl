-- Create class
local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"
local themeConfig = require "Themes/BigMoney/ThemeBigM_Config"

local parentClass = Theme
ThemeBigMoney = class("ThemeBigMoney", parentClass)

local customizedTheme = ThemeBigMoney

customizedTheme.plistAnimate = 
{
	"images/plist/symbols",
}

customizedTheme.csbList = 
{
	"csb/base.csb",
}
local fs_show_type = themeConfig.fs_show_type
local UnLockBetList = {
	jp4 = 1,
	jp3 = 2,
	collect = 3,
	jp2 = 4,
	jp1 = 5
}
local collectFeatureAnimation = {
	["unlock"]     = "animation3", --解锁
	["unlockLoop"]  = "animation4", 
	["lockLoop"] = "animation2",
	["lock"]       = "animation1",
}

local SpinBoardType = {
	Normal = 1,
	FreeSpin_normal = 2,
	FreeSpin_map_35 = 3,
	FreeSpin_map_36 = 4,
	FreeSpin_map_46 = 5,
	FreeSpin_map_45 = 6,
}

local Jsize = {
	["width"] = 179,
	["height"] = 179
}

local coinsMul = 
{
	[21] = 0.5,[22] = 1,[23] = 2,[24] = 3,[25] = 4,[26] = 5,[27] = 6,[28] = 7,[29] = 8,[30] = 9,[31] = 10,[32] = 15,[33] = 20,
	[34] = 25,[35] = 50,[36] = 75,[37] = 100
}
local jpEpicLinkMul = Set({14,15,16,17})

local BonusType = 
{
   MapWheel = 1,
   MapFreeGame = 2,  
}

local ReelType = 
{
	reel_36_normal = 1,
	reel_35 = 2,
	reel_36 = 3,
	reel_46 = 4,
	reel_45 = 5
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
            [9] = 200,[10] = 200,[11] = 200,[12] = 200,[13] = 200,[21] = 200,[22] = 200,[23] = 200,[24] = 200,[25] = 200,[26] = 200,[27] = 200,[28] = 200,[29] = 200,[30] = 200,
            [31] = 200,[32] = 200,[33] = 200,[34] = 200,[35] = 200,[36] = 200,[37] = 200,[38] = 200
            
		},
		["normal_symbol_list"]  = {
			1,2,3,4,5,6,7,8,10,14,15,16,17,18 -- 12 是空的 圆盘symbol -- "1_2"
		},
		["special_symbol_list"] = {
			--specialSymbol["fg_trigger"]
		},
		["no_roll_symbol_list"] = {
			-- 9,11,12,13
			9
		},
		["special_symbol_config"] = {
		},
	},
	["theme_type"] = "payLine",
	["theme_type_config"] = {
		["pay_lines"] = {
			{1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{0,1,2,1,0},{2,1,0,1,2},{1,0,1,0,1},{1,2,1,2,1},{0,1,0,1,0},
			{2,1,2,1,2},{1,0,0,0,1},{1,2,2,2,1},{2,2,1,2,2},{0,0,1,0,0},{2,1,1,1,2},{0,1,1,1,0},{0,2,0,2,0},
			{2,0,2,0,2},{1,1,0,1,1},{1,1,2,1,1},{2,2,0,2,2},			
		},
		["line_cnt"] = 20,
	},
	["theme_round_light_index"] = 1,
	["boardConfig"] = {
		{
			["allow_over_range"] = true, --index1
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(160,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(312.5,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(466,117),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(619.5,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(773,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(959,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
			}
		},
		{
			["allow_over_range"] = true, -- 3*5 index2
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(249,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(402.5,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(556,164),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(709.5,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(863,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
			}
		},
		{
			["allow_over_range"] = true, -- 3*6 index3
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(173,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(326.5,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(480,164),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(633.5,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(787,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
				{
					["base_pos"] = cc.p(938.5,164),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 3
				},
			}
		},
		{
			["allow_over_range"] = true, -- 4*6 index4
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(173,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(326.5,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(480,117),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(633.5,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(787,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(938.6,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
			}
		},
		{
			["allow_over_range"] = true, -- 4*5 index5
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(249,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(402.5,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(556,117),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(709.5,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(863.6,117),
					["cellWidth"] = 168,
					["cellHeight"] = 128,
					["symbolCount"] = 4
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

function customizedTheme:updateReelPaylineConfig(reelType)
	local payLine_list = 
	{
        [1] = { -- 3*5 / 20
                {1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{0,1,2,1,0},{2,1,0,1,2},{1,0,1,0,1},{1,2,1,2,1},{0,1,0,1,0},
				{2,1,2,1,2},{1,0,0,0,1},{1,2,2,2,1},{2,2,1,2,2},{0,0,1,0,0},{2,1,1,1,2},{0,1,1,1,0},{0,2,0,2,0},
				{2,0,2,0,2},{1,1,0,1,1},{1,1,2,1,1},{2,2,0,2,2}
             },
        [2] = { -- 3*6 / 20
                {1,1,1,1,1,1},{0,0,0,0,0,0},{2,2,2,2,2,2},{0,1,2,1,0,1},{2,1,0,1,2,1},{1,0,1,0,1,2},{1,2,1,2,1,0},{0,1,0,1,0,0},
				{2,1,2,1,2,1},{1,0,0,0,1,0},{1,2,2,2,1,2},{2,2,1,2,2,0},{0,0,1,0,0,2},{2,1,1,1,2,2},{0,1,1,1,0,0},{0,2,0,2,0,2},
				{2,0,2,0,2,0},{1,1,0,1,1,1},{1,1,2,1,1,1},{2,2,0,2,2,0}
             },
        [3] = { -- 4*6 / 30
                {1,1,1,1,1,1},{0,0,0,0,0,0},{2,2,2,2,2,2},{3,3,3,3,3,3},{0,1,2,1,0,1},{1,2,3,2,1,2},{2,1,0,1,2,1},{3,2,1,2,3,2},
                {1,0,1,0,1,0},{3,2,3,2,3,2},{1,2,1,2,1,2},{0,1,0,1,0,1},{2,1,2,1,2,1},{2,3,2,3,2,3},{1,0,0,0,1,0},{3,2,2,2,3,2},
                {1,2,2,2,1,2},{2,2,1,2,2,1},{0,0,1,0,0,1},{2,1,1,1,2,1},{0,1,1,1,0,1},{2,3,3,3,2,3},{0,2,0,2,0,2},{2,0,2,0,2,0},
                {3,1,3,1,3,1},{1,1,0,1,1,0},{1,1,2,1,1,2},{2,2,3,2,2,3},{2,2,0,2,2,0},{3,3,1,3,3,1}
              },
        [4] = { -- 4*5 / 30
                {1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{3,3,3,3,3},{0,1,2,1,0},{1,2,3,2,1},{2,1,0,1,2},{3,2,1,2,3},
                {1,0,1,0,1},{3,2,3,2,3},{1,2,1,2,1},{0,1,0,1,0},{2,1,2,1,2},{2,3,2,3,2},{1,0,0,0,1},{3,2,2,2,3},
                {1,2,2,2,1},{2,2,1,2,2},{0,0,1,0,0},{2,1,1,1,2},{0,1,1,1,0},{2,3,3,3,2},{0,2,0,2,0},{2,0,2,0,2},
                {3,1,3,1,3},{1,1,0,1,1},{1,1,2,1,1},{2,2,3,2,2},{2,2,0,2,2},{3,3,1,3,3}
              },
    }

    local index = 0
    if reelType == ReelType.reel_36_normal or reelType == ReelType.reel_35 then
    	index = 1
    elseif reelType == ReelType.reel_36 then
    	index = 2
    elseif reelType ==  ReelType.reel_46 then
    	index = 3
    elseif reelType ==  ReelType.reel_45 then
    	index = 4
    end

    self.lines = payLine_list[index]
end


local G_cellHeight = 139
local delay = 0
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 20/60
local rotateTime = 5/60
local maxSpeed = -26.5 * 60
local normalSpeed = -26.5 * 60
local fastSpeed = -26.5 * 60

local stopDelay = 10 / 60
local speedDownTime = 40/60
local downBounce = G_cellHeight*1/5
local stopDelayFree = 10/60
local downBounceMaxSpeed = 10*60
local downBounceTime = 10/60
local specialAniTime = 0
local extraReelTime = 120/60
-- local extraReelTimeInFreeGame = 480/60
local extraReelTimeInFreeGame = 170/30
local spinMinCD = 0.5
local eachPiggyDelay = 1.5
local stopDelayList = {
    [1] = 10 / 60,
	[2] = 10 / 60,
	[3] = 10 / 60,
}
local stopDelayListFree = {
	[1] = 24 / 60,
	[2] = 24 / 60,
	[3] = 24 / 60,
}
local checkStopColCnt = 6
local autoStopDelayMult = 1
-- local autoStopDelayMult = 2/3
local autoDownBounceTimeMult = 1

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
function customizedTheme:getSpinColStopAction(themeInfoData, pCol, interval)
	local specialType = nil	
    local checkNotifyTag = false
    local extraReelTime = pCol == 6 and 180/60 or 120/60
	if self.showBaseSpinBoard then	
	   if self.coinAnticipationList then
	   	    if pCol < 6 then
		       checkNotifyTag = self.coinAnticipationList[pCol]
		        if pCol == 5 then
		       	    if themeInfoData["anticipation"] and themeInfoData["anticipation"] == 1 then
			   	       self.isJpAnticipation = true
			   	    end
			   	end
		    else
		    	if themeInfoData["anticipation"] and themeInfoData["anticipation"] == 1 then
		   	       checkNotifyTag = true
		   	    end
		   	end
		   if checkNotifyTag then
			 self.DelayStopTime = self.DelayStopTime + extraReelTime
		   end
		end
	elseif self.showFreeSpinBoard then
		if pCol == 5 then
       	    if themeInfoData["anticipation"] and themeInfoData["anticipation"] == 1 then
	   	       self.isJpAnticipation = true
	   	    end
	   	end
		if pCol == 6 then
		    if themeInfoData["anticipation"] and themeInfoData["anticipation"] == 1 then
	   	       checkNotifyTag = true
	   	    end
		    if checkNotifyTag then
			   self.DelayStopTime = self.DelayStopTime + extraReelTime
		    end
		end
	else
		if self.isMapFreeAddPiggy then
			specialType = true
		end
	end
	
	if specialType and pCol == 1 then 
		self.canFastStop = false
		self.DelayStopTime = self.DelayStopTime + extraReelTimeInFreeGame
		self:showPiggyAddedAnimation(self.freeType)
	end

	local spinAction = {}
	spinAction.actions = {}
	local temp = interval - speedUpTime - upBounceTime
	self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0

	local _stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(stopDelayList, downBounceTime, checkStopColCnt, autoStopDelayMult, autoDownBounceTimeMult )
	if self:getMapFreeStatus() then
		_stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(stopDelayListFree, downBounceTime, checkStopColCnt, autoStopDelayMult, autoDownBounceTimeMult )
		-- _stopDelay = stopDelayFree
    end
	spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
	
	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = spinAction.speedDownTime * 1
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = downBounceTime
	spinAction.downBounceTime = _downBonusT
	spinAction.stopType = 1

		
	return spinAction
end

function customizedTheme:getCurSpinLayerSpinActionTime(stopDelayList, downBounceT, checkStopColCnt, autoSDMult, autoDBTMult )
    local _stopDelay = stopDelayList[1]
    local _downBounceTime = downBounceT
    if self.spinLayer.spins and #self.spinLayer.spins>0 then
        local tColCnt = #self.spinLayer.spins
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

-- 配置场景
function customizedTheme:initScene(spinNode)
	self.csb = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(self.csb)
	bole.adaptScale(self.mainThemeScene,false)
	self.baseBoardRoot = self.mainThemeScene:getChildByName("board_node")
	self.reelRoot = self.baseBoardRoot:getChildByName("Node_root_node")
	
	
	self.boardRoot = self.reelRoot:getChildByName("board_root")
	self.animateNode = self.reelRoot:getChildByName("Node_animated")
	self.jpReelBgRoot = self.reelRoot:getChildByName("jp_reel_node")

	self.shakyNode:addChild(self.mainThemeScene)
	self.dimmerNode = self.mainThemeScene:getChildByName("dimmer_node")

	self.dimmerNode:setVisible(false)

	

    self.mapBasePanel = self.mainThemeScene:getChildByName("map_show_node")
	self.baseMapLoadNode = self.mapBasePanel:getChildByName("node")
	self:enableBasePanelUI(false)
	self.scatterSkeleton = {}

	local reelBgNode = self.reelRoot:getChildByName("reel_bg")
	-- jp_reel_node
	self.baseKuangAniNode = cc.Node:create()
	self.jpReelBgRoot:addChild(self.baseKuangAniNode, 1)
	self.baseKuangAniNode:setPosition(cc.p(640, 360))
	-- self.baseKuangAniNode = self.reelRoot:getChildByName("reel_frame"):getChildByName("kuang_ani")

	self.reelBgList = {}
	self.reelLineList = {}
	for i = 1,6 do
		self.reelBgList[i] = reelBgNode:getChildByName("reel"..i)
		local reelLine = reelBgNode:getChildByName("reel_divider_"..i)
		if reelLine then 
			self.reelLineList[i] = reelLine
		end
	end

	---JackPot相关
    

	local jpReelNode = self.reelRoot:getChildByName("jp_reel_node")
	self.jpLogoImage = jpReelNode:getChildByName("jpReel_logo_ani")

	---FreeGame相关

    self.freeMessageNode = self.mainThemeScene:getChildByName("free_message_node")
    self.freeMessageNode:setVisible(false)
    self.label_piggyValue = self.freeMessageNode:getChildByName("label_piggy")
    self.label_piggyValue:setString("")

    self.reelPiggyValueNode = self.reelRoot:getChildByName("piggy_labels_node")
	self.reelPiggyValueList = {}
	local file = self:getPic("fonts/theme122_font_s2.fnt")
    for i = 1,6 do
    	local reelRoot = self.reelPiggyValueNode:getChildByName("reel"..i)
    	self.reelPiggyValueList[i] = {}
    	for j = 1,4 do
            self.reelPiggyValueList[i][j] = {}
            self.reelPiggyValueList[i][j].node = reelRoot:getChildByName("node"..j)
            self.reelPiggyValueList[i][j].node:setVisible(false)
			self.reelPiggyValueList[i][j].labelValue = self.reelPiggyValueList[i][j].node:getChildByName("label_value")
			self.reelPiggyValueList[i][j].labelValue:setScale(0.8)
			self.reelPiggyValueList[i][j].labelValue:setFntFile(file)
			self.reelPiggyValueList[i][j].labelRetrigger = self.reelPiggyValueList[i][j].node:getChildByName("label_free")
			self.reelPiggyValueList[i][j].labelRetrigger:setScale(0.9)
            self.reelPiggyValueList[i][j].labelRetrigger:setVisible(false)
        end
    end

    -- self.freeNorBoardNode = self.mainThemeScene:getChildByName("free_node")
    -- self.freeNorBoardNode:setVisible(false)
    self.mapFreeCollectNode = self.mainThemeScene:getChildByName("map_free_collect_node")
	self.mapFreeAddPiggyNode = self.reelRoot:getChildByName("reel_add_piggy_node")
	self.mapFreeAddPiggyNode:setCascadeOpacityEnabled(true)
	
    self.mapFreeAddPiggyMessage = self.mainThemeScene:getChildByName("free_piggy_add_node")
    self.mapFreeAddPiggyMessage:setVisible(true)


    ---Anticipation相关
    self.reelAnticipation_node = self.reelRoot:getChildByName("reel_anticipation_node")
    self.anticipationSkeletonList = {}
    self.jpAnticipation_node = self.reelRoot:getChildByName("jp_anticipation_node")
    self.jpAnticipation_node:setCascadeOpacityEnabled(true)

    self.jpWinValue = 0
    self.isJpWin = false
    self.isMapFreeAddPiggy = false
	self.flyCoinSkeleton = {}

	self:_initBackgroundBg()
	self:_initJpNode()
	self:_initCollectNode()
	self:_initBaseKuangNode()
	self:initTouchSpinBtn()
	self.ctl.hideGameRuleList = {true,nil,nil,true,true}
end
function customizedTheme:enableBasePanelUI(enabel)
	self.mapBasePanel:setVisible(enabel)
end
function customizedTheme:_initBaseKuangNode()
	local file = self:getPic("spine/base/qipan/qipanxunhuan")
	bole.addSpineAnimation(self.baseKuangAniNode, nil, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
end
function customizedTheme:_initBackgroundBg()
	self.backgroundRoot = self.mainThemeScene:getChildByName("background_node")
	self.base_bgRoot = self.backgroundRoot:getChildByName("background_base")
	local file = self:getPic("spine/base/ad/guanggaoxunhuan")
	bole.addSpineAnimation(self.base_bgRoot, 1, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
	self.base_bgRoot:setVisible(true)

	self.free_bgRoot = self.backgroundRoot:getChildByName("background_free")
	self.free_bgRoot:setVisible(false)
	
	self.bonus_bgRoot = self.backgroundRoot:getChildByName("background_bonus")
	self.bonus_bgRoot:setVisible(false)

	-- self.bgDimmer = self.backgroundRoot:getChildByName("background_shadow")  
	-- self.bgDimmer:setVisible(false)
	-- local scale = bole.getAdaptScale(false)
	-- self.bgDimmer:setScaleY(1 / scale)
end

function customizedTheme:enableBaseBoardUi(enable)
	self.progressiveParent:setVisible(enable)
	self.jpReelBgRoot:setVisible(enable)
	-- self.mapCollectRoot:setVisible(enable)
	self:setCollectNodeInGoldSpin(enable)
	self.bonus_bgRoot:setVisible(not enable)
	self.freeMessageNode:setVisible(enable)
end
-------------------------- 收集条功能相关 start----------------------------------
function customizedTheme:setCollectNodeInGoldSpin(enable)
	enable = enable or false
	if self.ctl.getGoldSpinStatus and self.ctl:getGoldSpinStatus() then 
		enable = false
	end
	self.mapCollectRoot:setVisible(enable)
end
function customizedTheme:_initCollectNode()
	self.maxMapPoints = 130
	self.maxMapLevel = 18
	self.mapCollectRoot = self.mainThemeScene:getChildByName("collcect_node")
	self.nextLevelImageList = {}
    for i = 1,5 do
    	self.nextLevelImageList[i] = self.mapCollectRoot:getChildByName("nextStep_"..i)
    	self.nextLevelImageList[i]:setVisible(false)
    end
	local collectProgressPanel = self.mapCollectRoot:getChildByName("progress_panel")
	local frame_boarder = self.mapCollectRoot:getChildByName("frame_boarder")
	frame_boarder:setScaleY(1.09)
    self.collectCoinProgressImage = collectProgressPanel:getChildByName("coinProgressImage")
	self.collectCoinAniNode = collectProgressPanel:getChildByName("progress_ani_node")
	self.colelctLoopAniNode = self.mapCollectRoot:getChildByName("collect_loop_ani")
    self.progressStartPosX = -287
    self.progressPosY = 19
    self.progressEndPosX = 287
    self.movePerUnit = self.progressEndPosX*2/self.maxMapPoints

	self.reelCoinFlyLayer = self.mainThemeScene:getChildByName("collectCoin_flyNode")
	self.reelCoinFlyLayer:setVisible(true)
    self.collectCoinReceiveAniNode = self.mapCollectRoot:getChildByName("coin_receive_ani_node")
    self.collectFullAniNode = self.mapCollectRoot:getChildByName("collect_full_ani_node")
	self.collectFrameAniNode = self.mapCollectRoot:getChildByName("frame_board_ani_node")
	self.collectFrameAniNode:setScaleY(0.9)
    self.btn_mapInfo = self.mapCollectRoot:getChildByName("btn_map")

    self.lockAniNode = self.mapCollectRoot:getChildByName("lock_ani_node")
    self.btn_unLock = self.mapCollectRoot:getChildByName("btn_unlock")
	self.lockAniNode:setScaleY(1.09)
    self.collectTipNode = self.mapCollectRoot:getChildByName("tip_node")
    self.collectTipNode:setScale(1,0)
    self.collectTipNode:setVisible(false)
    self.collectTipTextList = {}
    for i = 1,2 do
    	self.collectTipTextList[i] = self.collectTipNode:getChildByName("text"..i)
    	self.collectTipTextList[i]:setVisible(false)
    end
    self.btn_collectTip = self.mapCollectRoot:getChildByName("btn_tip")
	self.btn_collectTip:setVisible(false)
	self.btn_collectTip:removeAllChildren()

    self.collectBackNode = self.mainThemeScene:getChildByName("collect_back_node")
	self.isMapOpen = false
	self:initBtnUnlockEvent()
	self:addCollectLoopAni()
	self:setCollectNodeInGoldSpin(true)
end
function customizedTheme:addCollectLoopAni()
	local file = self:getPic("spine/base/jdt/jdtxunhuan")
	self.colelctLoopAniNode:setScaleY(1.09)
	bole.addSpineAnimation(self.colelctLoopAniNode, nil, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
end
function customizedTheme:setEnableCollectLoopAni(enable)
	enable = enable or false
	self.colelctLoopAniNode:setVisible(enable)
end
function customizedTheme:setEnableCollectNode(enable)
	if not self.mapCollectRoot then return end
	enable = enable or false
	self:setCollectNodeInGoldSpin(enable)
	-- self.mapCollectRoot:setVisible(enable)
end
function customizedTheme:setEnableBtnNode(enable)
	enable = enable or false
	-- self:enableCollectTipBtn(enable, 1)
	-- if not self.isLockFeature then
	-- 	enable = false
	-- end
	self.btn_unLock:setTouchEnabled(enable)
	self.btn_unLock:setVisible(enable)
end
function customizedTheme:initBtnUnlockEvent( ... )
	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
		 	self:tipBtnOnTouch()
		end
	end
	self.btn_unLock:addTouchEventListener(onTouch)
end
function customizedTheme:tipBtnOnTouch( ... )
	local maxBet = self.ctl:getMaxBet()
	if maxBet < self.tipBetList[UnLockBetList.collect] then
		return
	end
	if self.isLockFeature then
		self:setBet(UnLockBetList.collect)
	else 
		if (not self.curTipShow) then
			self:showCollectTip(1)
		else
			self:hideCollectTip()
		end
	end
end
function customizedTheme:changeCollectBet(theBet)
	if not self.lockAniNode then return end
	local tipBet = self.tipBetList[UnLockBetList.collect]
    if self.isLockFeature == nil then
        if theBet >= tipBet then
            self.isLockFeature = true
        else
            self.isLockFeature = false
        end
    end
    local isLock = theBet < tipBet
    if self.isLockFeature ~= isLock then
        if isLock then
            self:setCollectPartState(false, true)
        else
            self:setCollectPartState(true, true)
        end
	end
end
function customizedTheme:setCollectPartState(active,isAnimate)
	local file = self:getPic("spine/collectLock/spine")
	local parent = self.lockAniNode

	self:setEnableCollectLoopAni(active)
	if active then
		self.isLockFeature = false
		-- self:setEnableBtnNode(false)
		local aniName = collectFeatureAnimation["unlockLoop"]
		if isAnimate then
			aniName = collectFeatureAnimation["unlock"]
		end
		self:playMusic(self.audio_list.unlock)
	    if self.collectLockSkeleton then
		   self.collectLockSkeleton:setAnimation(0,aniName,false)
	    else
	    	local _,s = self:addSpineAnimation(parent,nil,file,cc.p(-40,0),aniName,nil,nil,nil,true,false,nil)
	    	self.collectLockSkeleton = s 
	    end
	    local tipScaleY = self.collectTipNode:getScaleY()
	    local backDelay = 0
	    if tipScaleY > 0 then
	    	backDelay = 0.3
	    end
	    self:runAction(cc.Sequence:create(
	    	cc.CallFunc:create(function()
	    		if tipScaleY > 0 then
	    			self:hideCollectTip()
	    		end
	    	end),
	    	cc.DelayTime:create(backDelay),
	    	cc.CallFunc:create(function()
	    		self:showCollectTip(1)
	            self:enableCollectTipBtn(true,1)
	    	end)
	    ))	    
	else
		local aniName = collectFeatureAnimation["lockLoop"]
		if isAnimate then
			aniName = collectFeatureAnimation["lock"]
		end
		self.isLockFeature = true
        if isAnimate then
        	self:playMusic(self.audio_list.lock)
        end
		if self.collectLockSkeleton then
		   self.collectLockSkeleton:setAnimation(0,aniName,false)
	    else
	    	local _,s = self:addSpineAnimation(parent,nil,file,cc.p(-40,0),aniName,nil,nil,nil,true,false,nil)
	    	self.collectLockSkeleton = s 
	    end
	    -- local maxBet = self.ctl:getMaxBet()
		-- if maxBet >= self.tipBetList[UnLockBetList["collect"]] then
		-- 	self:setEnableBtnNode(true)
        -- end
        self:enableCollectTipBtn(false,1)
	end
end
function customizedTheme:enableCollectTipBtn(enable,state)
	if enable then
		-- self.btn_collectTip:setVisible(true)
		-- self.btn_collectTip:setTouchEnabled(true)
		-- self:initBtnCollectEvent(state)
	else
		-- self.btn_collectTip:setVisible(false)
		-- self.btn_collectTip:setTouchEnabled(false)
		local tipScaleY = self.collectTipNode:getScaleY()
		if tipScaleY > 0 then
			self:hideCollectTip()
		end
	end
end
function customizedTheme:initBtnCollectEvent(state)
	local pressFunc = function(obj)
        -- self.btn_collectTip:setTouchEnabled(false)
        local tipScaleY = self.collectTipNode:getScaleY()
        self:runAction(cc.Sequence:create(
        	cc.CallFunc:create(function()
        		if tipScaleY ==0 then
        			self:showCollectTip(state)
        		else
        			self:hideCollectTip()
        		end
        	end),
        	cc.DelayTime:create(0.35),
        	cc.CallFunc:create(function()
        		--  self.btn_collectTip:setTouchEnabled(true)
        		 if state == 2 then
        		 	state = 1 
        		 end
        		 self:enableCollectTipBtn(true,state)
        	end)
        ))
    end
	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end
	-- self.btn_collectTip:addTouchEventListener(onTouch)
end
function customizedTheme:showCollectTip(state)
	state = state or 1
	for i = 1,2 do
	    self.collectTipTextList[i]:setVisible(i == state)
	end
	self.curTipShow = true
	self.curTipStatus = true
	self.collectTipNode:stopAllActions()
	self.collectTipNode:setScale(1,0)
	self.collectTipNode:setVisible(true)
	self:playMusic(self.audio_list.collect_tip_show)
	self.collectTipNode:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.2,1,1.3),
		cc.ScaleTo:create(0.1,1,1),
		cc.DelayTime:create(5),
		cc.CallFunc:create(function()
			self:hideCollectTip()
		end)
	))
end
function customizedTheme:hideCollectTip()
	if not self.curTipStatus then return end
	self.curTipStatus = false
	self.collectTipNode:stopAllActions()
	self.collectTipNode:setScale(1)
	self.collectTipNode:setVisible(true)
	self:playMusic(self.audio_list.collect_tip_hide)
	self.collectTipNode:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.1,1,1.2),
		cc.ScaleTo:create(0.2,1,0),
		cc.CallFunc:create(function()
			self.curTipShow = false
			self.collectTipNode:setVisible(false)
		end)
	))
end
-------------------------- 收集条功能相关 end  ----------------------------------


--------------------------JackPot功能相关 start----------------------------------
function customizedTheme:_initJpNode()
	self.jackpotLabels = {}
	self.jackpotUnlockLabels = {}
	
	self.progressiveParent = self.mainThemeScene:getChildByName("progressive_node")
	self.progressiveNode   = self.progressiveParent:getChildByName("progressive")
	self.progressiveJpNode = self.progressiveNode:getChildByName("progressive")
	self.progressiveTips = self.progressiveNode:getChildByName("progressive_tip")
	local jpfile = self:getPic("spine/jp/jpshangsuo")
	-- self.progressiveParent:setLocalZOrder(10)

	for key = 1, 4 do
		local jp_node = self.progressiveJpNode:getChildByName("node"..key)
		local jpLoopAni = jp_node:getChildByName("loop_ani")
		local blackCover = jp_node:getChildByName("cover_black")
		blackCover:setVisible(true)

		self.jackpotLabels[key] = jp_node:getChildByName("label_jp"..key)
		self.jackpotLabels[key].maxWidth = self:getJPLabelMaxWidth(key)
		self.jackpotLabels[key].baseScale = self.jackpotLabels[key]:getScale()

		local tip_node = self.progressiveTips:getChildByName("jp_"..key)
		local lock_tip = tip_node:getChildByName("lock_tip")
		local unlock_tip = tip_node:getChildByName("unlock_tip")
		lock_tip:setVisible(false)
		unlock_tip:setVisible(false)
		local btn      = tip_node:getChildByName("btn_"..key)
		local ani_node = tip_node:getChildByName("lock"..key)

        local animationUnlock = "animation"..key.."_1"
		local animationLock = "animation"..key
		-- 上锁是1，解锁是_1

		btn.index = key
		local _, lockSpine = bole.addSpineAnimation(ani_node, 1, jpfile, cc.p(0,0), animationLock, nil, nil, nil, true, nil)
		ani_node.lockSpine = lockSpine
		ani_node.animationLock = animationLock
		ani_node.animationUnlock = animationUnlock

		self.jackpotUnlockLabels[key] = {}
		self.jackpotUnlockLabels[key].btn = btn
		self.jackpotUnlockLabels[key].lock_tip = lock_tip
		self.jackpotUnlockLabels[key].unlock_tip = unlock_tip
		self.jackpotUnlockLabels[key].ani_node = ani_node
		self.jackpotUnlockLabels[key].jpLoopAni = jpLoopAni
		self.jackpotUnlockLabels[key].blackCover = blackCover
		self.jackpotUnlockLabels[key].isLocked = true
		self:_initJackTouchEvent(self.jackpotUnlockLabels[key], key)
	end
	self:initialJackpotNode()
end
function customizedTheme:_initJackTouchEvent(unlockLables, index)
	local btn = unlockLables.btn
	local function onTouchJp(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tipBet = self.tipBetList[UnLockBetList["jp" .. index]]
			if self.currentUnlockBet and tipBet > self.currentUnlockBet then
				self.jackpotUnlockLabels[index].isClick = true
				self:setBet(UnLockBetList["jp" .. index])
			end
		end
	end
	btn:addTouchEventListener(onTouchJp)
end
function customizedTheme:changeUnlockJpBet(theBet)
	 if not self.jackpotUnlockLabels then return end
	local unlock_count = 0
    local lock_count = 0
    local unlock_status = false
    local lock_status = false
    local status = self:_getLockStatus(self.currentUnlockBet, theBet)
    -- self.jackpotUnlockLabels = self.jackpotUnlockLabels

    for key = 1, 4 do
        local jackpot = key
        local betKey = "jp" .. jackpot
        local tipBet = self.tipBetList[UnLockBetList[betKey]]
        local parent = self.jackpotUnlockLabels[key]
        if theBet < tipBet then
            lock_count = lock_count + 1
            if not parent.isLocked then
                lock_status = true
                self:setJackpotPartState(key, true)
            end
            parent.btn:setTouchEnabled(true)
        else
            parent.btn:setTouchEnabled(false)
            if parent.isLocked then
                unlock_status = true
                self:setJackpotPartState(key, false)
            end
            unlock_count = unlock_count + 1
        end
        parent.isLocked = theBet < tipBet
    end
    -- to show bubble
    if self.ctl:noFeatureLeft() then
        if status == 1 or status == 2 then
            self:setJackPotTipState(status, lock_status, lock_count)
        else
            self:setJackPotTipState(status, unlock_status, lock_count)
        end
    end
end
function customizedTheme:getMapFreeStatus()
	local mapFreeStatus = false
	if self.showFreeSpin_35 or self.showFreeSpin_36 
		or self.showFreeSpin_46 or self.showFreeSpin_45 then
			mapFreeStatus = true
	end
	return mapFreeStatus
end
function customizedTheme:setJackpotPartState(index, isLock)
    local parent = self.jackpotUnlockLabels[index]
    local ani_node = parent.ani_node
	local lockSpine = ani_node.lockSpine
    local animationLock = ani_node.animationLock
    local animationUnlock = ani_node.animationUnlock
    if (not lockSpine) then return end
	if isLock then
		parent.blackCover:setVisible(true)
        bole.spChangeAnimation(lockSpine, animationLock)
	else
		parent.blackCover:setVisible(false)
        bole.spChangeAnimation(lockSpine, animationUnlock)  
    end
end
function customizedTheme:_getLockStatus(beforeBet, theBet)
	local status = 0
    if not beforeBet then
        status = 1
    elseif beforeBet > theBet then
        status = 2
    else
        status = 3
    end
    return status
end
function customizedTheme:setJackPotTipState( status, status2, count )
    if status == 1 then
        if status2 then
            self:showjpTipNode(count, 1)
        end
    elseif status == 2 then
        if status2 then
            self:showjpTipNode(count, 1)
            self:playMusic(self.audio_list.jp_lock)
        end
    elseif status == 3 then
        if status2 then
            local jpIndex = count + 1
            self:showjpTipNode(jpIndex, 2)
            self:playMusic(self.audio_list.jp_unlock)
        end
    end
end
function customizedTheme:showjpTipNode(count, status)
	-- self:playMusicByName("popup_out")
	if self.showjpTipCacheNode then
        self.showjpTipCacheNode:stopAllActions()
        self.showjpTipCacheNode:runAction(
                cc.ScaleTo:create(0.1, 0)
        )
	end
    local jpTipNode = self.jackpotUnlockLabels[count]
    local showNode = jpTipNode.lock_tip
    if status == 2 then
        showNode = jpTipNode.unlock_tip
    end
    showNode:setVisible(true)
    showNode:setScale(0)
    showNode:runAction(
            cc.Sequence:create(
                    cc.ScaleTo:create(0.1, 1.1),
                    cc.ScaleTo:create(0.1, 1),
                    cc.DelayTime:create(1),
                    cc.ScaleTo:create(0.1, 1, 1.1),
                    cc.ScaleTo:create(0.1, 0),
                    cc.CallFunc:create(function()
                        self.showjpTipCacheNode = nil
                    end)
            )
    )
    self.showjpTipCacheNode = showNode
end	
function customizedTheme:getJPLabelMaxWidth(index)
	local jackpotWidthList = {190,152,137,114}
	return jackpotWidthList[index]
end
function customizedTheme:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"grand", "major","minor","mini"},
		allowK = {[122] = false,[622] = false,[1122] = false,},
	}
	return jackpot_config_list
end
--------------------------JackPot功能相关 end----------------------------------

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

function customizedTheme:initSpinLayerBg()
	-- show game master start popup
   	if self.mapPoints then
		self:setCollectProgressImagePos(self.mapPoints)
	end
	if self.mapLevel then
		self:setNextCollectTargetImage(self.mapLevel)
	end
	if self.mapCollectRoot:isVisible() then
		self:enableMapInfoBtn(true)
		self:enableOtherInfoBtn(true)
	end	
	self:setBoardScene(1)
	Theme.initSpinLayerBg(self)
end

-- change board scene ，其中n：1 - 3x6 withJP，2 - 3x5，3 - 3x6，4 - 4x6 ，5 - 4x5
function customizedTheme:setBoardScene(n)
	if n<1 or n>5 then return end

	local function setReelBg(n)
		local file = ""
		local file1 = ""
		if n == 1 then
			file = self:getPic("images/base/theme122_reel_bg.png")
			file1 = "#theme122_reel_divider.png"
		else
			file = self:getPic("images/base/theme122_reel_bg_free.png")
			file1 = "#theme122_reel_divider_free.png"
		end
        for i = 1,6 do
			bole.updateSpriteWithFile(self.reelBgList[i],file)
			if self.reelLineList[i] then 
				bole.updateSpriteWithFile(self.reelLineList[i],file1)
			end
        end
	end

    local frame_list = {0, 5, 10, 15, 20} 
    local action = cc.CSLoader:createTimeline(self.csb)
    self.mainThemeScene:runAction(action)
    action:gotoFrameAndPause(frame_list[n])
    setReelBg(n)
    if n == 1 then
    	-- self.progressive_node:setVisible(true)
    	-- self.jpReelBgRoot:setVisible(true)
    	self:enableBaseBoardUi(true)
    	-- self.bonus_bgRoot:setVisible(false)
    	self:playJpLogoAnimation()
    else
    	-- self.progressive_node:setVisible(false)
    	-- self.jpReelBgRoot:setVisible(false)
    	-- self.mapCollectRoot:setVisible(false)
		self:enableBaseBoardUi(false)
		-- self.bonus_bgRoot:setVisible(true)
		-- self.freeMessageNode:setVisible(false)
		self:stopJpLogoAnimation()
    end
end

function customizedTheme:playJpLogoAnimation()
	self:stopJpLogoAnimation()
	local file = self:getPic("spine/jp_logo/spine")
	self:addSpineAnimation(self.jpLogoImage,5,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
end

function customizedTheme:stopJpLogoAnimation()
	self.jpLogoImage:removeAllChildren()
end
------------------------------轮带功能相关----------------------------------

function customizedTheme:changeSpinBoard(pType) -- 更改背景控制 已修改
	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		self.showBaseSpinBoard = true
		self.showFreeSpinBoard = false
		self.showFreeSpin_35 = false
		self.showFreeSpin_36 = false
		self.showFreeSpin_46 = false
		self.showFreeSpin_45 = false

		self:updateReelPaylineConfig(ReelType.reel_36_normal)
		
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1	
		self:setBoardScene(self.initBoardIndex)
		-- self.mapCollectRoot:setVisible(true)	
		self:setCollectNodeInGoldSpin(true)
		
		self.free_bgRoot:setVisible(false)
		self.freeMessageNode:setVisible(false)
		
	elseif pType == SpinBoardType.FreeSpin_normal then
		self.showFreeSpinBoard = true
		self.showFreeSpin_35 = false
		self.showFreeSpin_36 = false
		self.showFreeSpin_46 = false
		self.showFreeSpin_45 = false
		self.showBaseSpinBoard = false

		self:updateReelPaylineConfig(ReelType.reel_36_normal)
		self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(1)
		
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1
		self:setBoardScene(self.initBoardIndex)
		-- self.mapCollectRoot:setVisible(false)
		self:setCollectNodeInGoldSpin(false)

		self.free_bgRoot:setVisible(true)

		if self.freePiggyValue then
	       self.label_piggyValue:setString(FONTS.formatByCount2(self.freePiggyValue,5,true))
	    end
		self.freeMessageNode:setVisible(true)

	elseif pType == SpinBoardType.FreeSpin_map_35 then
		self.showFreeSpinBoard = false
		self.showFreeSpin_35 = true
		self.showFreeSpin_36 = false
		self.showFreeSpin_46 = false
		self.showFreeSpin_45 = false
		self.showBaseSpinBoard = false

		self:updateReelPaylineConfig(ReelType.reel_35)
		if self.isMapFreeAddPiggy then
			self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(102)
		else
		    self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(2)
		end

		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[2]
		self.spinLayer:Active()

		self.initBoardIndex = 2
		self:setBoardScene(self.initBoardIndex)
		self:setMapFreeReelSymbol(5,3)

	elseif pType == SpinBoardType.FreeSpin_map_36 then
		self.showFreeSpinBoard = false
		self.showFreeSpin_35 = false
		self.showFreeSpin_36 = true
		self.showFreeSpin_46 = false
		self.showFreeSpin_45 = false
		self.showBaseSpinBoard = false

		self:updateReelPaylineConfig(ReelType.reel_36)
		if self.isMapFreeAddPiggy then
			self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(103)
		else
		    self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(3)
		end

		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[3]
		self.spinLayer:Active()

		self.initBoardIndex = 3
		self:setBoardScene(self.initBoardIndex)
		self:setMapFreeReelSymbol(6,3)

	elseif pType == SpinBoardType.FreeSpin_map_46 then
		self.showFreeSpinBoard = false
		self.showFreeSpin_35 = false
		self.showFreeSpin_36 = false
		self.showFreeSpin_46 = true
		self.showFreeSpin_45 = false
		self.showBaseSpinBoard = false

		self:updateReelPaylineConfig(ReelType.reel_46)
		if self.isMapFreeAddPiggy then
			self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(104)
		else
		    self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(4)
		end

		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[4]
		self.spinLayer:Active()

		self.initBoardIndex = 4
		self:setBoardScene(self.initBoardIndex)
		self:setMapFreeReelSymbol(6,4)

	elseif pType == SpinBoardType.FreeSpin_map_45 then
		self.showFreeSpinBoard = false
		self.showFreeSpin_35 = false
		self.showFreeSpin_36 = false
		self.showFreeSpin_46 = false
		self.showFreeSpin_45 = true
		self.showBaseSpinBoard = false

		self:updateReelPaylineConfig(ReelType.reel_45)
		if self.isMapFreeAddPiggy then
			self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(105)
		else
		    self.ctl.theme_reels["free_reel"] = self:getFreeThemeReel(5)
		end

		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[5]
		self.spinLayer:Active()

		self.initBoardIndex = 5
		self:setBoardScene(self.initBoardIndex)
		self:setMapFreeReelSymbol(5,4)

	end
	if pType == SpinBoardType.Normal or pType == SpinBoardType.FreeSpin_normal then
		self.baseKuangAniNode:setVisible(true)
		self.baseBoardRoot:setScale(1)
	else
		self.baseKuangAniNode:setVisible(false)
		if SHRINKSCALE_H < 1 then
    	    local add = 1 / SHRINKSCALE_H
    	    if add > 1.1 then
    	        add = 1.1
    	    end
    	    self.baseBoardRoot:setScale(add)
    	end
	end
end

function customizedTheme:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function customizedTheme:stopControl( stopRet, stopCallFun )
	self.item_list = {}
	self.item_list = stopRet["item_list"]
	self.coinCounts = 0
	self.coinAnticipationList = {false,false,false,false,false,false}
	self.coinSoundList = {false, false, false, false, false}
	self.jpSymbolLandSound = false
	self.piggySoundList = {false,false,false,false,false,false}

	self.isJpWin = false
	self.jpWinValue = 0
	self.jpWinType = nil
	self.jpLockStatus = nil
	local jp_win = stopRet["jp_win"]
	local locked_jp = stopRet["theme_info"] and stopRet["theme_info"]["locked_jp"] or {}
	if #jp_win > 0 then
		self.isJpWin = true
	    self.jpWinValue = jp_win[1]["jp_win"]
	    self.jpWinType = jp_win[1]["jp_win_type"]
		self.coinAnticipationList[6] = true
	elseif locked_jp and #locked_jp > 0 then
		self.isJpWin = true
	    self.jpWinValue = locked_jp[1]["jp_win"]
	    self.jpWinType = locked_jp[1]["jp_win_type"]
		self.coinAnticipationList[6] = true
		self.jpLockStatus = true --  添加用于锁住的状态
	end

	if self.showBaseSpinBoard then
		-- self:setCoinsSymbolLand()
    	for i = 1,5 do
			for j = 1,3 do
    			if self.item_list[i][j] > 20 then
    				self.coinCounts = self.coinCounts  + 1
    				if i < 4 or (i == 4 and self.coinCounts >= 3) or (i == 5 and self.coinCounts >= 6) then
					   self.coinSoundList[i] = true	
					end

					if self.coinCounts >= 3 and i < 5 then
						for k = i+1, 5 do
							self.coinAnticipationList[k] = true
						end	
					end
				end
			end
		end
		if self.item_list[6] then
			if self.item_list[6][2] == 14 or self.item_list[6][2] == 15 or self.item_list[6][2] == 16 or self.item_list[6][2] == 17 then
				self.jpSymbolLandSound = true
			end
		end
	else
		if self.showFreeSpinBoard then
			if self.item_list[6] then
				if self.item_list[6][2] == 14 or self.item_list[6][2] == 15 or self.item_list[6][2] == 16 or self.item_list[6][2] == 17 then
					self.jpSymbolLandSound = true
				end
			end
		end
		for i = 1,6 do
			for j = 1,4 do
				if self.item_list[i] and self.item_list[i][j] and (self.item_list[i][j] == 10 or self.item_list[i][j] == 11 or self.item_list[i][j] == 12 or self.item_list[i][j] == 13) then
					self.piggySoundList[i] = true
				end
			end
		end
	end

	if stopRet["bonus_level"] then
		self.tipBetList = stopRet["bonus_level"]
		self:setTipBetListNum(stopRet["bonus_level"])
		self.bonusLevelChange = true
	end
	stopCallFun()
end

function customizedTheme:setCoinsSymbolLand()
	local itemList = self.item_list
	local maxCol = 5
	local maxRow = 3
	local limitCoinsId = 20
	local curColMaxCnt = 2 
	local coinCount = 0
	local jiliLimit = 5
	for col = 1, maxCol do
		local colItemList = itemList[col]
		for row, theItem in pairs(colItemList) do 
			if theItem > limitCoinsId then 
				coinCount = coinCount + 1
			end
		end

		local sumCnt = 0
		local sumCnt = sumCnt + curColMaxCnt * (maxCol - col + 1)
		local willGetFeatureInAfterCols = false
		if curColMaxCnt > 0 and sumCnt > 0 and (coinCount+sumCnt) >= jiliLimit then
			willGetFeatureInAfterCols = true
			self.coinSoundList[col] = true
		end

		if coinCount >= 3 and col <= 5 then 
			self.coinAnticipationList[col] = true
		end

		-- if willGetFeatureInAfterCols then 
		-- 	for row, theItem in pairs(colItemList) do 
		-- 		if theItem > limitCoinsId then 
		-- 			self.coinAnticipationList[col] = true
		-- 		end
		-- 	end
		-- end
	end
end

function customizedTheme:onThemeInfo(specialData,callFunc)
	if self.showBaseSpinBoard then
		local themeInfoData = specialData["theme_info"]	
		local bonusData = specialData["bonus_game"]

		if themeInfoData and themeInfoData["map_info"] then
			 self.map_avg_bet = themeInfoData["map_info"]["avg_bet"]
			 self.mapData["piggy_list"] = themeInfoData["map_info"]["piggy_list"]
			 local mapPoints = themeInfoData["map_info"]["map_points"]
		     local mapLevel = themeInfoData["map_info"]["map_level"]
		     --print("wy_onThemeInfo: ",mapPoints,mapLevel)
		     self.mapLevel = mapLevel

		     if mapPoints ~= self.mapPoints then
	       	    local bonusLevelDelay = 0
	       	    if self.bonusLevelChange then
	       	    	if self.ctl:getCurTotalBet() < self.tipBetList[UnLockBetList["collect"]] then
	       	    	   bonusLevelDelay = 0.5
	       	    	else
	       	    		self.bonusLevelChange = nil
	       	    	end
	       	    end
	            self:runAction(cc.Sequence:create(
	          	    cc.CallFunc:create(function()
	          		    self:showCoinsFlyToUp()          		   
	            end),
	          	    cc.DelayTime:create(0.33),
	          	    cc.CallFunc:create(function()
	          	    	 if callFunc then
				 		   callFunc()
				 	    end
	          	    end),
	          	    cc.DelayTime:create(0.5),
	          	    cc.CallFunc:create(function()
	          		   local isFull = bonusData and true or false
	          		   self:showProgressAnimation(mapPoints,isFull)		
	          		   self.reelCoinFlyLayer:removeAllChildren()       		   
	            end),
	          	    cc.DelayTime:create(bonusLevelDelay),
	          	    cc.CallFunc:create(function()
	          	    	if self.bonusLevelChange and self.ctl:getCurTotalBet() < self.tipBetList[UnLockBetList["collect"]] and bonusLevelDelay > 0 then
	          	    		self.bonusLevelChange = nil
	          	    		self:setCollectPartState(false,true)
	          	    	end
	          	    end)
	            ))
	        else
	        	if self.bonusLevelChange and self.ctl:getCurTotalBet() < self.tipBetList[UnLockBetList["collect"]] then
	        		self.bonusLevelChange = nil
	        		if self.isLockFeature then
	        		   self:setCollectPartState(false,false)
	        		else
	        			self:setCollectPartState(false,true)		        			
	        		end
	        	end
	        	if callFunc then
		 		   callFunc()
		 	    end
	        end
	    end
	else
		if callFunc then
 		   callFunc()
 	    end
 	end
end

function customizedTheme:onJackpotWin(rets,callback)
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
			self:showJackpotWinPopupWindow(callback)
		end)
	))	
end

function customizedTheme:onSpinStart()
	self.isJpAnticipation = false
	self.DelayStopTime = 0
	self.isFastStop = false
	self.piggySkeleton = {}
	self.piggyDelay = 0

	if self.showBaseSpinBoard then
		if self.isMapOpen then
			if self.theMapDialog and bole.isValidNode(self.theMapDialog) then
				self.theMapDialog:exitMapScene(false,true)
				self.isMapOpen = false
			end
		end
		self:enableMapInfoBtn(false)
		self:enableOtherInfoBtn(false)
		-- if self.mapCollectRoot:isVisible() then
		--    self:enableMapInfoBtn(false)
		-- end
		-- if self.isLocked then
		-- 	self.btn_unLock:setTouchEnabled(false)
		-- end
	else
		self:resetPiggyValueState()
	end
	self:hideMasterGameStartPopup()

	Theme.onSpinStart(self)
end
function customizedTheme:enableOtherInfoBtn(enable)
	self:setEnableBtnNode(enable)
	if self.jackpotUnlockLabels then
		for key = 1, 4 do
			local btn_click = self.jackpotUnlockLabels[key].btn
			btn_click:setTouchEnabled(enable)
		end
	end
	self.isCanOtherFeatureClick = enable
end

function customizedTheme:onSpinStop(ret)
	Theme.onSpinStop(self, ret)
    --print("wy_reelStop_data",tool.lua_to_json(ret))
	if ret.free_spins and (not self.ctl.freewin) then
		if ret.free_game and ret.free_game["piggy"] then
		   self.freePiggyValue = ret.free_game["piggy"]
		   self.freeType = ret.free_game["type"]
		   --print("wy_freePiggyValue1",self.freePiggyValue,self.freeType)
		end
	end


end

function customizedTheme:onReelStop( col )
	if col == 6 and (self.showBaseSpinBoard or self.showFreeSpinBoard) then
	    local isJpTrigger = self:isJackpotTrigger()
	    local jpIndex = {[14] = 1, [15] = 2, [16] = 3, [17] = 4}
	    if isJpTrigger and self.isJpWin then
			if self.item_list and self.item_list[6] and self.item_list[6][2] then
				local id = self.item_list[6][2]
				local winIndex = jpIndex[id]
				self:playJpSymbolAnimation(winIndex)
			end
        end
    end
	Theme.onReelStop(self, col)
end

local piggyKeySet = Set({10,11,12,13})

function customizedTheme:onAllReelStop()
	local function getPiggyCount()
		local piggyCount = 0
		for k,v in pairs(self.item_list) do
			for m,n in pairs(v) do
				if piggyKeySet[n] then
					piggyCount = piggyCount + 1
				end
			end
		end
        return piggyCount
	end

	local isJpTrigger = (self:isJackpotTrigger() and self.isJpWin) and true or false
	if self.showBaseSpinBoard then
		self:stopAnticipationAnimation()
		self:stopJpReelAnticipation()

		if self.ctl.rets["free_game"] and self.ctl.rets["free_game"]["game_master_flag"] then
			self.gameMasterFlag = self.ctl.rets["free_game"]["game_master_flag"] -- 0为非game master, 1为game master
		end

		-- if self.ctl.rets["free_game"] or self.ctl.rets["bonus_game"] then
		-- 	self:enableMapInfoBtn(false)
		-- else
		-- 	if self.mapCollectRoot:isVisible() then
		-- 	   self:enableMapInfoBtn(true)
		-- 	end
		-- 	if self.isLockFeature then
		-- 	   self.btn_unLock:setTouchEnabled(true)
		-- 	end
		-- end

		if isJpTrigger then
			self.ctl.rets["jackpot_win"] = 1
		end
	else
		local piggyCount = getPiggyCount()
		self.piggyDelay = piggyCount * eachPiggyDelay

		if self.showFreeSpinBoard then
			self:stopJpReelAnticipation()
			if isJpTrigger then
				self.ctl.rets["jackpot_win"] = 1
			else
				if self.piggyDelay > 0 then
					self.ctl.rets["control_add_delay"] = self.piggyDelay + 1
					self:showPiggyValues(piggyCount)
				end
			end
		else		
			if self.piggyDelay > 0 then
				self.ctl.rets["control_add_delay"] = self.piggyDelay + 1
				self:showPiggyValues(piggyCount)
			end
		end
	end
	Theme.onAllReelStop(self)
end

function customizedTheme:finshSpin()
	if self.ctl.autoSpin or self.showFreeSpinBoard then
		self:enableMapInfoBtn(false)
		self:enableOtherInfoBtn(false)
	else
		self:enableMapInfoBtn(true)
		self:enableOtherInfoBtn(true)
	end
end

function customizedTheme:onReelFallBottom( pCol )
	if self.showBaseSpinBoard then
		if pCol < 5 then
			if self.coinAnticipationList[pCol+1] then
				self:stopAnticipationAnimation()
				self:playAnticipationAnimation(pCol+1)
			end
		elseif pCol == 5 then
			self:stopAnticipationAnimation()
            if self.isJpAnticipation and self.coinAnticipationList[pCol+1] then
            	self:playJpReelAnticipation()
            end
		end

		if pCol <= 5 then
			self:showCoinSymbolLandAnimation(pCol,false)
		end

		if self.coinSoundList[pCol] then
			self:playSmartSound(1)
		elseif pCol == 6 and self.jpSymbolLandSound then
			self:playMusic(self.audio_list.jpSymbolSmart)
		else
			self:dealMusic_PlayReelStopMusic(pCol)
		end
	else
		local colCounts = #self.item_list
		if pCol <= colCounts then
			self:showPiggySymbolLandAnimation(pCol,false)
		end
		if self.showFreeSpinBoard then
			if pCol == 5 and self.isJpAnticipation and self.coinAnticipationList[pCol+1] then
				self:playJpReelAnticipation()
			end			
		end

		if self.showFreeSpinBoard then
			if self.piggySoundList[pCol] then
				self:playMusic(self.audio_list.piggySmart)
			elseif pCol == 6 and self.jpSymbolLandSound then
				self:playMusic(self.audio_list.jpSymbolSmart)
			else
				self:dealMusic_PlayReelStopMusic(pCol)
			end
		else
			if self.piggySoundList[pCol] then
				self:playMusic(self.audio_list.piggySmart)
			else
		        self:dealMusic_PlayReelStopMusic(pCol)
		    end
		end
				
	end

end

function customizedTheme:onReelFastFallBottom(pCol)
    self.isFastStop = true
	if self.showBaseSpinBoard then
	    if pCol < 5 then
			if self.coinAnticipationList[pCol+1] then
				self:stopAnticipationAnimation()
			end
		elseif pCol == 5 then
			if self.coinAnticipationList[pCol+1] then
				self:stopJpReelAnticipation()
			end
		end

		if pCol <= 5 then
			self:showCoinSymbolLandAnimation(pCol,true)
		end

		if self.coinSoundList[pCol] then
			self:playSmartSound(1)
		elseif pCol == 6 and self.jpSymbolLandSound then
			self:playMusic(self.audio_list.jpSymbolSmart)
		else
			self:dealMusic_PlayReelStopMusic(pCol)
		end
	else
		if self.showFreeSpinBoard then
			if pCol == 5 and self.coinAnticipationList[pCol+1] then
				self:stopJpReelAnticipation()
			end			
		end 
        
        local colCounts = #self.item_list
        if pCol <= colCounts then
			self:showPiggySymbolLandAnimation(pCol,true)
		end

		if self.showFreeSpinBoard then
			if self.piggySoundList[pCol] then
				self:playMusic(self.audio_list.piggySmart)
			elseif pCol == 6 and self.jpSymbolLandSound then
				self:playMusic(self.audio_list.jpSymbolSmart)
			else
				self:dealMusic_PlayReelStopMusic(pCol)
			end
		else
			if self.piggySoundList[pCol] then
				self:playMusic(self.audio_list.piggySmart)
			else
		        self:dealMusic_PlayReelStopMusic(pCol)
		    end
		end
	end
end

function customizedTheme:isJackpotTrigger()
	local isTrigger = false
	if self.showBaseSpinBoard or self.showFreeSpinBoard then
		local jpSet = Set({14,15,16,17}) 	   
		local item_list = self.item_list
		if item_list and item_list[6] and item_list[6][2] then 
			local id = item_list[6][2]
			if jpSet[id] then
				isTrigger = true
			end
		end
	end
    return isTrigger
end

-- 添加Font
function customizedTheme:addCoinSymbolLabel()
	local file = self:getPic("fonts/theme122_font_S1.fnt")
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

local keyValueSet = Set({21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37})

function customizedTheme:getCoinSymbolValue(key) 
	
	if keyValueSet[key] then
		local bet = self.ctl:getCurTotalBet()
		local value = bet * coinsMul[key]
		return value
	else
		return ""
	end
end
local freeRetriggerSet = Set({11,12,13}) 
function customizedTheme:createCellSprite(key, col, rowIndex)
	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key
	local lock = false
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
	------------------------------------------------------------
	--print("wy_self.initBoardIndex",self.initBoardIndex)
	if self.initBoardIndex == 1 then
		if col == 6 then
			if key < 14 then
				key = 18 
			elseif key < 18 then
                key = math.random(16,17)
			end
		end
		if self.showFreeSpinBoard then
			if keyValueSet[key] or key == 9 then
				key = math.random(1,8)
			end
		else
			if key == 9 then
				key = math.random(1,8)
			elseif keyValueSet[key] then
				self.value = self:getCoinSymbolValue(key)
		        key = 9
			end
		end
		
	else
		if key >= 14 then
			key = math.random(1,8)
		end
	end

	local theCellFile = self.pics[key]
	if freeRetriggerSet[key] then 
		theCellFile = self.pics[10]
	end
	if not theCellFile then 
		key = math.random(1,8)
		theCellFile = self.pics[key]
	end

	--print("wy_createCell",key,theCellFile)

	local theCellNode   = cc.Node:create()
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	if self.initBoardIndex == 1 and col == 6 then 
		if jpEpicLinkMul[key] then 
			lock = self:getBetLockName(key)
			self:addExtraJpAni(col, key, false, lock, theCellNode)
		end
	end
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

	if self.initBoardIndex == 1 then
		ret.font = self:addCoinSymbolLabel()
		local cellSize = self.spinLayer:getCellSize(col)
		ret.sprite:addChild(ret.font,10)
		ret.font:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
		ret.font:setString("")

		if key == 9 then
			if self.value then
				ret.font:setString(self.value)
				self.value = nil
			else
				local randomKey = math.random(21,37)
				local coinValue = self:getCoinSymbolValue(randomKey)
				ret.font:setString(coinValue)
			end
			ret.font:setVisible(true)
		end
	end
	theCellNode.jpLock = lock
	--print("wy_createCellSprite",key,theCellFile)
	return ret
end

function customizedTheme:updateCellSprite(theCellNode, key, col, isShowResult,isReset,isClick)
	local lastLock = theCellNode.jpLock
	local lock = false

	if theCellNode.aniNode then
		theCellNode.aniNode:removeAllChildren()
	end
	if theCellNode.piggyAniNode then
		theCellNode.piggyAniNode:removeAllChildren()
		theCellNode.piggyAniNode = nil
	end

	if self.initBoardIndex == 1 then
		if self.showBaseSpinBoard then	
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
				key = 9
			else
				if theCellNode.font then
					theCellNode.font:setVisible(false)
				end
			end		
			
		else
			if keyValueSet[key] then
				key = math.random(1,8)
				if theCellNode.font then
					theCellNode.font:setVisible(false)
				end
			elseif freeRetriggerSet[key] then
				key = 10
			end
			if theCellNode.font then
				theCellNode.font:setVisible(false)
			end
		end
		if col == 6 then
			if key < 14 then
				key = 18 
				self:refreshJpStatic(theCellNode)
			elseif jpEpicLinkMul[key] then
				lock = self:getBetLockName(key)
				self:addExtraJpAni(col, key, lastLock, lock, theCellNode, isClick)
			else
				self:refreshJpStatic(theCellNode)
			end
		end
	else
		if key >= 14 then
			key = math.random(1,8)
		end
	end

	local theCellFile = self.pics[key]
	if freeRetriggerSet[key] then 
		theCellFile = self.pics[10]
	end
	theCellNode.jpLock = lock

	if not theCellFile then 
		key = math.random(1,8)
		theCellFile = self.pics[key]
	end

	--print("wy_updatedCell",key,theCellFile)

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

function customizedTheme:getBetLockName(key)
	local lock = false
	local jpNext = 13
   	if (self.currentUnlockBet) and (self.tipBetList) then
		local tipBet = self.tipBetList[UnLockBetList["jp"..(key - jpNext)]]
   		if tipBet > self.currentUnlockBet then
   			lock = true
   		end
   	end
   	return lock
end
function customizedTheme:changeCellJpSprite()
	if self:getLastJpCol() then 
		local specialRow = 6
		if self.spinLayer and self.spinLayer.spins[specialRow] then
			for row = -1, 4 do	
				local cell = self.spinLayer.spins[specialRow]:getRetCell(row)
				if cell then
					self:updateCellSprite(cell, cell.key, specialRow, true, true, true)
				end
			end
		end
	end
end
function customizedTheme:getLastJpCol()
	if self.showBaseSpinBoard or self.showFreeSpinBoard then
		return true
	end
	return false
end

-- @给jp那列添加锁住的状态
-- isClick 修改bet
function customizedTheme:addExtraJpAni(col, key, lastLock, lock, theCellNode, isClick)
	local file = self:getPic("spine/symbols/jp/spine")
	local index = key - 13
	-- 14 是grand
	local animationName = "animation"..index.."_1" -- 正常的状态
	if (lastLock == lock) and lock then --前后两次都是锁住的状态，静帧即可
		animationName = "animation"..index.."_2"
	elseif (lastLock == lock) then -- 前后两次都是开锁的状态,不用解锁
		animationName = "animation"..index.."_1"
	elseif (lastLock ~= lock) and lock then -- 需要播放锁住的动画
		animationName = "animation"..index.."_2"
	elseif (lastLock ~= lock) then -- 播放开锁的动画
		animationName = "animation"..index.."_1"
	end
	if animationName then
		if theCellNode.symbolTipAnim3 then
			bole.spChangeAnimation(theCellNode.symbolTipAnim3, animationName)
			theCellNode.symbolTipAnim3:setVisible(true)
		else
			local _, s = bole.addSpineAnimation(theCellNode, 5000, file, cc.p(0,0), animationName, nil, nil, nil, true, nil)
			theCellNode.symbolTipAnim3 = s
		end
	end
end
--@delate lock jpcol
function customizedTheme:refreshJpStatic( theCellNode ) 
	if theCellNode.symbolTipAnim3 then
		theCellNode.symbolTipAnim3:setVisible(false)
    end
end

function customizedTheme:setMapFreeReelSymbol(col_counts,row_counts)
	for i = 1,col_counts do
		for j = 1,row_counts do
			local cell = self.spinLayer.spins[i]:getRetCell(j)
			local key = math.random(1,8)
			self:updateCellSprite(cell, key, i, true)
		end
	end
end

---------------------------------Collect相关-----------------------------------------------
local mapLevelConfig = {5,5,1,5,5,5,2,5,5,5,5,3,5,5,5,5,5,4} -- 1:building1 / 2:building1 / 3:building1 / 4:building1 / 5: steel safe

function customizedTheme:setNextCollectTargetImage(level)
	level = level + 1
	if level > self.maxMapLevel then
	   level = 1
	end
	
	for i = 1,5 do
		self.nextLevelImageList[i]:setVisible(i == mapLevelConfig[level])
	end
end

function customizedTheme:setCollectProgressImagePos(map_points)
	if map_points > self.maxMapPoints then
		map_points = self.maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end

	--self.mapPoints = map_points
	local cur_posX = self.movePerUnit * map_points + self.progressStartPosX

	self.collectCoinProgressImage:setPosition(cc.p(cur_posX,self.progressPosY))
	self.collectCoinAniNode:setPosition(cc.p(cur_posX,self.progressPosY))
end

function customizedTheme:showProgressAnimation(map_points,isFull)
	local function fullCollectAnimation()
		local parent = self.collectFullAniNode
		local file = self:getPic("spine/collect_full/full1/spine")
		local file1 = self:getPic("spine/collect_full/full2/shoujitiaojiman")
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				local _,s = self:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
				self:addSpineAnimation(self.collectFrameAniNode,nil,file1,cc.p(0,0),"animation1",nil,nil,nil,true,true,nil)
			end),
			cc.DelayTime:create(3),
			cc.CallFunc:create(function()
				self.collectFrameAniNode:removeAllChildren()
				self.collectFullAniNode:removeAllChildren()
			end)
		))
	end

	if map_points > self.maxMapPoints then
		map_points = self.maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end

	local oldPosX = self.movePerUnit * self.mapPoints + self.progressStartPosX
	local startPos = cc.p(oldPosX,self.progressPosY)

	local newPosX = self.movePerUnit * map_points + self.progressStartPosX
	local endPos = cc.p(newPosX,self.progressPosY)

	self.mapPoints = map_points

    self.collectCoinProgressImage:setPosition(startPos)
    self.collectCoinProgressImage:runAction(cc.MoveTo:create(0.5,endPos))
    self.collectCoinAniNode:setPosition(startPos)
	self.collectCoinAniNode:runAction(cc.MoveTo:create(0.5,endPos))

	local parent = self.collectCoinAniNode
	local file = self:getPic("spine/collect_progress/spine")
	local _,s1 = self:addSpineAnimation(parent,2,file,cc.p(0,0),"animation2",nil,nil,nil,false,false,nil)

	local _,s2 = self:addSpineAnimation(self.collectFrameAniNode,2,file,cc.p(0,0),"animation1",nil,nil,nil,false,false,nil)
	self:laterCallBack(0.5,function( ... )
		--local _,s2 = self:addSpineAnimation(parent,5,file,pos,"animation2",nil,nil,nil,false,false,nil)
		if isFull then
			fullCollectAnimation()
			self:playMusic(self.audio_list.coin_collect_full)
		end
	end)	
end

function customizedTheme:showCoinsFlyToUp()
	self.reelCoinFlyLayer:removeAllChildren()
	self.flyCoinSkeleton = {}
	local item_list = self.item_list
	local endPos = cc.p(186.3,549)
	local isPlay = false
	local isFly = false
	local spine_file = self:getPic("spine/coin_collect_fly/spine")
	for i = 1,5 do
		for j = 1,3 do
			if item_list and item_list[i] and item_list[i][j] > 20 then
				local node = cc.Node:create()
				local pos = self:getCellPos(i,j)
				node:setPosition(pos)
				self.reelCoinFlyLayer:addChild(node,j)
				
				local pFile = self:getPic("particles/jinbituowei_01_1.plist")
				local pPos = cc.p(0,0)
				local lizi = cc.ParticleSystemQuad:create(pFile)
				lizi:setPosition(pPos)
				node:addChild(lizi,10)
				
				local spine_pos = cc.p(0,0)

				local _,s = self:addSpineAnimation(node,nil,spine_file,spine_pos,"animation1",nil,nil,nil,true,false,nil)
                self.flyCoinSkeleton[i.."_"..j]  = s   
				local a1 = cc.DelayTime:create(0.33)
				local a2 = cc.CallFunc:create(function ()
					if not tolua.isnull(self.flyCoinSkeleton[i.."_"..j]) then
					   self.flyCoinSkeleton[i.."_"..j]:setAnimation(0,"animation2",false)
					   self:parabolaToAnimation(node,i,j,pos,endPos,0.5)
					end
					if not isFly then
						isFly = true
					    self:playMusic(self.audio_list.coin_fly)
					end
					if lizi and bole.isValidNode(lizi) then
						lizi:runAction(cc.ScaleTo:create(0.5,0.4,0.4))
					end
				end)
				local a3 = cc.DelayTime:create(0.5)
				local a4 = cc.CallFunc:create(function ()
					if not isPlay then
						isPlay = true
						local parent = self.collectCoinReceiveAniNode
						local file = self:getPic("spine/coin_collect_burst/spine")
						local pos = cc.p(0,0)
						local _,s1 = self:addSpineAnimation(parent,5,spine_file,pos,"animation3",nil,nil,nil,false,false,nil)
						local _,s2 = self:addSpineAnimation(parent,10,file,pos,"animation1",nil,nil,nil,false,false,nil)
						self:playMusic(self.audio_list.coin_collect)
					end
				end)
				local a5 = cc.RemoveSelf:create()
				local a6 = cc.Sequence:create(a1,a2,a3,a4,a5)
				node:runAction(a6)


				-- self:runAction(cc.Sequence:create(
				-- 	cc.CallFunc:create(function()
				-- 	   local _,s = self:addSpineAnimation(node,nil,spine_file,spine_pos,"animation1",nil,nil,nil,true,false,nil)
                --        self.flyCoinSkeleton[i.."_"..j]  = s                   
				-- 	end),
				-- 	cc.DelayTime:create(0.33),
				-- 	cc.CallFunc:create(function()
				-- 		if not tolua.isnull(self.flyCoinSkeleton[i.."_"..j]) then
				-- 		   self.flyCoinSkeleton[i.."_"..j]:setAnimation(0,"animation2",false)
				-- 		   self:parabolaToAnimation(node,i,j,pos,endPos,0.5)
				-- 		end
				-- 		if not isFly then
				-- 			isFly = true
				-- 		    self:playMusic(self.audio_list.coin_fly)
				-- 		end
				-- 		if lizi and bole.isValidNode(lizi) then
				-- 			lizi:runAction(cc.ScaleTo:create(0.5,0.4,0.4))
				-- 		end
				-- 	end),
				-- 	cc.DelayTime:create(0.5),
				-- 	cc.CallFunc:create(function()
				-- 		if not isPlay then
				-- 			isPlay = true
				-- 			local parent = self.collectCoinReceiveAniNode
				-- 			local file = self:getPic("spine/coin_collect_burst/spine")
				-- 			local pos = cc.p(0,0)
				-- 			local _,s1 = self:addSpineAnimation(parent,5,spine_file,pos,"animation3",nil,nil,nil,false,false,nil)
				-- 			local _,s2 = self:addSpineAnimation(parent,10,file,pos,"animation1",nil,nil,nil,false,false,nil)
				-- 			self:playMusic(self.audio_list.coin_collect)
				-- 		end
				-- 	end)
				-- ))


			end




		end
	end	
end

function customizedTheme:parabolaToAnimation(obj,col,row,from,to,duration)
	if (not obj) or (not col) or (not row) then return end

	local radian_config = 
	{
       {{-50,50},{-50,60},{-50,75}},{{-60,30},{-60,40},{-60,55}},{{-70,-30},{-70,-40},{-70,-55}},{{-80,-50},{-80,-60},{-80,-75}},{{-90,-50},{-90,-60},{-90,-75}},
    }
	local from = from or self:getCellPos(col,row)
	local to = to or cc.p(0,0)
	local config = radian_config[col][row]
	duration = duration or 0.5

	local myBezier = function (p0, p1, p2, duration, frame)
		local t = frame / duration
		if t > 1 then t = 1 end
		local x = math.pow(1-t,2)*p0.x + 2*t*(1-t)*p1.x + math.pow(t,2)*p2.x
		local y = math.pow(1-t,2)*p0.y + 2*t*(1-t)*p1.y + math.pow(t,2)*p2.y

		return cc.p(x,y)
	end

	local cp = cc.p(from.x + config[1], from.y + config[2])
	local frame = 1

	obj:runAction(cc.Repeat:create(cc.Sequence:create(
		cc.CallFunc:create(function () 
			frame = frame or 1
			local pos = myBezier(from, cp, to, duration*60, frame)
			obj:setPosition(pos)
			frame = frame + 1
		end),
		cc.DelayTime:create(1/60)
		), duration*60))

end

function customizedTheme:enableMapInfoBtn(enable)
	self.btn_mapInfo:setVisible(true)
	self.btn_mapInfo:setTouchEnabled(enable)
	self.btn_mapInfo:setBright(enable)
	self:addMapBtnSpine(enable)
    local function initBtnEvent( ... )
		local pressFunc = function(obj)
	        self.btn_mapInfo:setTouchEnabled(false)
	        self.btn_mapInfo:setBright(false)
	        self:playMusic(self.audio_list.btn_click)
	        local theGameData = {}
	    	local data = {}
	    	data["mapLevel"] = self.mapLevel
	    	data["mapInfo"] = self.mapData
	        self.theMapDialog = BigMoneyMapGame.new(self, self:getPic("csb/"), data)
	        self.theMapDialog:showMapScene(false)
	    end
		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				pressFunc(obj)
			end
		end
		self.btn_mapInfo:addTouchEventListener(onTouch)
	end
	if enable then
		initBtnEvent()
	end
	self.isCanFeatureClick = enable
end
function customizedTheme:addMapBtnSpine(enable)
	if not self.btn_mapInfo.spineNode then 
		local file = self:getPic("spine/base/xiaoi/xiaoi")
		local size = self.btn_mapInfo:getContentSize()
		local pos = cc.p(size.width/2, size.height/2)
		local _, spine = bole.addSpineAnimation(self.btn_mapInfo,nil,file,pos,"animation",nil,nil,nil,true,true)
		self.btn_mapInfo.spineNode = spine
	end
	if self.btn_mapInfo.spineNode and bole.isValidNode(self.btn_mapInfo.spineNode) then
		self.btn_mapInfo.spineNode:setVisible(enable)
	end
end




function customizedTheme:resetMapInfoData()
	self.mapData = {}
    self.mapData["extra_fg"]   = 0
    self.mapData["incre_pay"]  = 0
    self.mapData["reel_count"] = 0
    self.mapData["row_count"]  = 0
    self.mapData["stick"]      = 0
    self.mapData["piggy_list"] = {0,0,0,0}
end

-- collect Tip related

-------------------------------处理Bet变化相关-----------------------------------------------
function customizedTheme:dealAboutBetChange(theBet,isPointBet)
	if (not self.tipBetList) or (not self.lockAniNode) then
		return
	end
	theBet = theBet or self.ctl:getCurTotalBet()
	local maxBet = self.ctl:getMaxBet()
	self:changeCollectBet(theBet)
	-- self:adaptAllJpWidth()
	if maxBet >= theBet then
		self:changeUnlockJpBet(theBet)
		self.currentUnlockBet = theBet
		self:changeCellJpSprite()
	else
		self.currentUnlockBet = theBet
	end
	
end

function customizedTheme:setBet(index)
	local set_Bet = self.tipBetList[index]
	local maxBet = self.ctl:getMaxBet()
	if maxBet >= set_Bet then
		self.ctl:setCurBet(set_Bet)
	end
end

function customizedTheme:getRollUpBet(ret)
	local tb = nil
	if not self.showFreeSpinBoard and not self.showBaseSpinBoard then
		tb = self.map_avg_bet
	end
	return tb
end
----------------------------------Symbol动画相关-----------------------------------
function customizedTheme:playCellRoundEffect(parent, ...)
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function customizedTheme:drawLinesThemeAnimate( lines, layer, rets, specials)
	self.animNodeList = self.animNodeList or {}
	self.symbolsSkeleton = self.symbolsSkeleton or {}
	local timeList = {2,2}
	Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)	
end

-- 设置symbol动画
function customizedTheme:getItemAnimate(item, col, row, effectStatus,parent)
	local spineSymbolSet = Set({1,2,3,4,5,6,7,8})
	if self.symbolsSkeleton and self.symbolsSkeleton[col.."_"..row] then
		self:playOldAnimation(col, row)
	elseif effectStatus and effectStatus == "all_first" then
		self:playItemAnimation(item, col, row, item)
	else
		if effectStatus and effectStatus=="all_first" then
			return self:getItemAnimate_4(self, item)
		else
			return self:getSingleItemAnimate(self, item)
		end
	end
	-- if spineSymbolSet[item] then
	-- 	-- 播放symbol动画
	-- 	return self:playItemAnimation(item, col, row, effectStatus, parent)
	-- else
	-- 	if effectStatus and effectStatus=="all_first" then
	-- 		return self:getItemAnimate_4(self, item)
	-- 	else
	-- 		return self:getSingleItemAnimate(self, item)
	-- 	end
	-- end
end

function customizedTheme:getItemAnimate_4(item)
	local animate = cc.Sequence:create(
		-- cc.DelayTime:create(7/60),
		cc.FadeTo:create(0.01, 0),
		cc.DelayTime:create(0.5), 
		cc.FadeTo:create(0.01, 255),
		cc.DelayTime:create(0.5))
	return animate
end

function customizedTheme:getSingleItemAnimate(item)
	local animate = cc.Sequence:create(
		-- cc.DelayTime:create(7/60),
		cc.FadeTo:create(0.01, 0),
		cc.DelayTime:create(0.5), 
		cc.FadeTo:create(0.01, 255),
		cc.DelayTime:create(0.5))
	return animate
end

-- 播放symbol spine动画
function customizedTheme:playItemAnimation( item, col, row, effectStatus, parent)
	local animateName = "animation"
	local fileName = item
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos  = self:getCellPos(col,row)
	local spineFile = self:getPic("spine/symbols/"..item.."/spine")
	local _, s1	= self:addSpineAnimation(self.animateNode, nil, spineFile, pos, animateName, nil, nil, nil, true)
	self.symbolsSkeleton = self.symbolsSkeleton or {}
	self.symbolsSkeleton[col.."_"..row] = {}
	self.symbolsSkeleton[col.."_"..row] = {s1,animateName}
	cell.sprite:setVisible(false)
end
function customizedTheme:playOldAnimation(col, row)
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    if self.symbolsSkeleton[col .. "_" .. row] then
        local node = self.symbolsSkeleton[col .. "_" .. row][1]
        local animationName = self.symbolsSkeleton[col .. "_" .. row][2]
        if bole.isValidNode(node) and animationName then
            bole.spChangeAnimation(node, animationName)
        end
    end
end

-- 播放symbol的动画，包括中奖和挑逗
-- col是spinLayer里的col, 1-20
function customizedTheme:playSymbol(parent, spineName, col, row, animateName, theScale, loop)
	local cell 	      = self.spinLayer.spins[col]:getRetCell(row)
	local pos 		  = self.spinLayer:getCellPos(col, row)
	local spineFile   = self:getPic(spineName)
	local _, s1 	  = self:addSpineAnimation(parent, nil, spineFile, pos, animateName, nil, nil, nil, false, loop, nil)
	theScale = theScale or 1
	s1:setScale(theScale)
	--cell:setVisible(true)
	return s1
end
function customizedTheme:getNormalStopAddCount()
    local G_CELL_HEIGHT = G_cellHeight
    local addHeight = downBounce + G_CELL_HEIGHT * 0.5
    local extra = math.ceil(addHeight / G_CELL_HEIGHT)
    return extra
end

function customizedTheme:showCoinSymbolLandAnimation(col, isFast)
	local file = self:getPic("spine/symbols/coin/spine")
	local extraAddCnt = self:getNormalStopAddCount()
	local itemList = self.item_list or {}
	if itemList and #itemList > 0 and self.coinSoundList and self.coinSoundList[col] then 
		local itemColList = itemList[col]
		for row, item in pairs(itemColList) do
			if item and item > 20 then 
				local cell = nil
				if isFast then 
					cell = self.spinLayer.spins[col]:getRetCell(row)
				else 
					cell = self.spinLayer.spins[col]:getRetCell(row + extraAddCnt)
				end
				if cell then
					if not cell.aniNode then
			    	   cell.aniNode = cc.Node:create()
			    	   cell.aniNode:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
			    	   cell.sprite:addChild(cell.aniNode,8)
			    	end
			    	local parent = cell.aniNode
			    	self:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation1",nil,nil,nil,false,false,nil)	
				end
			end
		end
	end
end
function customizedTheme:playCoinsTriggerAnimation()
    local file = self:getPic("spine/symbols/coin/spine")
	for i = 1,5 do
		for j = 1,3 do
			if self.item_list[i][j] > 20 then
				local cell = self.spinLayer.spins[i]:getRetCell(j)
				if not cell.aniNode then
			       cell.aniNode = cc.Node:create()
			       cell.aniNode:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
			       cell.sprite:addChild(cell.aniNode,8)
			    end
			    self:addSpineAnimation(cell.aniNode,nil,file,cc.p(0,0),"animation2",nil,nil,nil,false,false,nil)
			end	
		end
	end
end

function customizedTheme:showPiggySymbolLandAnimation(col,isFast)
	local piggySet = Set({10,11,12,13}) 
	local file = self:getPic("spine/symbols/piggy/spine")
	local extraAddCnt = self:getNormalStopAddCount()
	local itemList = self.item_list or {}
	if itemList and #itemList > 0 then 
		local itemColList = itemList[col]
		for row, item in pairs(itemColList) do
			if piggySet[item] then 
				local cell = nil
				if isFast then 
					cell = self.spinLayer.spins[col]:getRetCell(row)
				else 
					cell = self.spinLayer.spins[col]:getRetCell(row + extraAddCnt)
				end
				if cell then
					if not cell.piggyAniNode then
			    	   cell.piggyAniNode = cc.Node:create()
			    	   cell.piggyAniNode:setPosition(cc.p(0,0))
			    	   cell:addChild(cell.piggyAniNode,8)
			    	end
					local parent = cell.piggyAniNode
					cell.sprite:setVisible(false)
			    	self:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation1",nil,nil,nil,true,false,nil)	
				end
			end
		end
	end
end

function customizedTheme:playPiggyTriggerAnimation(col,row)
	local file = self:getPic("spine/symbols/piggy/spine")
    local pos = self:getCellPos(col,row)
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    
    if self.piggySkeleton[col.."_"..row] then
    	self.piggySkeleton[col.."_"..row]:setAnimation(0,"animation2",false)
    else
    	local _,s = self:addSpineAnimation(self.animateNode,nil,file,pos,"animation2",nil,nil,nil,true,false,nil)
    	self.piggySkeleton[col.."_"..row] = s 
    end
    cell.sprite:setVisible(false)
    self:updatePiggyBreakCellSprite(cell.sprite)

    if cell.piggyAniNode then
		cell.piggyAniNode:removeAllChildren()
		cell.piggyAniNode = nil
	end
    self:laterCallBack(1.23,function()
    	--self.piggySkeleton[col.."_"..row]:setAnimation(0,"animation3",true)
    	if bole.isValidNode(self.piggySkeleton[col.."_"..row]) then
	    	self.piggySkeleton[col.."_"..row]:setAnimation(0,"animation3",true)
	    else
	    	local _,s = self:addSpineAnimation(self.animateNode,nil,file,pos,"animation3",nil,nil,nil,true,true,nil)
	    	self.piggySkeleton[col.."_"..row] = s 
	    end
    end)
end

function customizedTheme:updatePiggyBreakCellSprite(sprite)
	local newFile = "#theme122_s_19.png"
	bole.updateSpriteWithFile(sprite, newFile)
end

function customizedTheme:stopDrawAnimate()
	self.animNodeList = nil
	self.symbolsSkeleton = nil
	Theme.stopDrawAnimate(self)
end

function customizedTheme:playAnticipationAnimation(index)
	local anticipationPosList = 
	{  
	   [2] = cc.p(397.64,310),[3] = cc.p(550.64,310),[4] = cc.p(703.64,310),[5] = cc.p(856.64,310)
    }
    self.reelAnticipation_node:setVisible(true)
	local parent = self.reelAnticipation_node
	local file = self:getPic("spine/anticipation/spine")
	local pos = anticipationPosList[index]
	local aniName = "animation"

	local _,s = self:addSpineAnimation(parent,nil,file,pos,aniName,nil,nil,nil,true,true,nil)

	self:stopMusic(self.audio_list.anticipation)
	self:playMusic(self.audio_list.anticipation,true)
end

function customizedTheme:stopAnticipationAnimation()
	self.reelAnticipation_node:setVisible(false)
	self.reelAnticipation_node:removeAllChildren()	
	self:stopMusic(self.audio_list.anticipation)
end

function customizedTheme:playJpReelAnticipation()
	local pos = cc.p(1042,310)
	self.jpAnticipation_node:setOpacity(0)
	self.jpAnticipation_node:setVisible(true)
	local file = self:getPic("spine/anticipation_jpReel/spine")
	local _,s = self:addSpineAnimation(self.jpAnticipation_node,nil,file,pos,"animation",nil,nil,nil,true,true,nil)

	self.jpAnticipation_node:runAction(cc.FadeIn:create(0.2))

	self:stopMusic(self.audio_list.anticipation_jp)
	self:playMusic(self.audio_list.anticipation_jp,true)
end

function customizedTheme:stopJpReelAnticipation( ... )
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.jpAnticipation_node:stopAllActions()
		    self.jpAnticipation_node:runAction(cc.FadeOut:create(0.2))
		    self:stopMusic(self.audio_list.anticipation_jp)
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			self.jpAnticipation_node:setVisible(false)
	        self.jpAnticipation_node:removeAllChildren()
		end)
	))
end


-- jp win
function customizedTheme:playJpSymbolAnimation(winIndex)
	local file = self:getPic("spine/symbols/jp/spine")
	local pos = self.spinLayer:getCellPos(6,2)
	local cell = self.spinLayer.spins[6]:getRetCell(2)
	local aniName = "animation"..winIndex
	if self.jpLockStatus then
		aniName = "animation"..winIndex.."_3"
	end
	self:addSpineAnimation(self.animateNode,nil,file,pos,aniName,nil,nil,nil,true,true,nil)
end

--------------------------jp dialog start----------------------------
function customizedTheme:showJackpotWinPopupWindow(callback)
	if self.jpLockStatus then 
		self:playLockJackpotCollectDialog(callback)
		self.jpLockStatus = nil
	else
		self:playJackpotCollectDialog(callback)
	end
end
function customizedTheme:playJackpotCollectDialog(callback)
	local winType = self.jpWinType + 1 or 4
	local winValue = self.jpWinValue
	local theData = {}
	theData.bg = winType
	if winType > 4 or winType < 1 then 
		theData.bg = 4
	end
	theData.coins = winValue
	local sType = fs_show_type.collect
	local csbName = "dialog_jp"
	local dialogType = "jp_collect"
	self.ctl.footer:setSpinButtonState(true)
	theData.click_event = function ()
		self:initJackpotCollectEvent(callback,winValue)
		self:playFadeToMaxVlomeMusic()
	end
	self:playMusic(self.audio_list.bonus_jp_celebration_show)
	self:laterCallBack(0.5, function ()
		self:playMusic(self.audio_list.popup_jp)
	end)
	self:showThemeDialog(theData, sType, csbName, dialogType)
end
-- xm add for lock jp
function customizedTheme:playLockJackpotCollectDialog(callback)
	local jpWinValue = self.jpWinValue
	self:initJackpotCollectEvent(callback, jpWinValue, true)
end
function customizedTheme:initJackpotCollectEvent(callback,jpwin,nomusic)
	-- local a1 = cc.CallFunc:create(function ()
		-- function customizedTheme:setCoinsSymbolLand()
-- 
	-- 	-- local user = User:getInstance()
	-- 	-- user:addCoins(jpwin)

	-- 	-- 添加金币
	-- 	-- self.ctl.footer:setWinCoins(jpwin, 0, 0.5)-- footer 进行加钱
    --    	-- User:getInstance():addCoins(jpwin)
	-- 	-- 金币展示
	-- 	self.ctl.footer:setWinCoins( self.ctl.totalWin, self.ctl.totalWin + jpwin, 0.3)
	-- 	self.ctl.totalWin = self.ctl.totalWin + jpwin
	-- 	if self.showFreeSpinBoard then 
	-- 		self.ctl.freewin = self.ctl.freewin + jpwin
	-- 	end
	-- 	if not nomusic then
	-- 		self:playMusic(self.audio_list.frame_out)
	-- 	end
	-- end)
	-- local a2 = cc.DelayTime:create(0.35)
	-- local a3 = cc.CallFunc:create(function ()
	-- 	if self.showFreeSpinBoard then
    --     	if self.piggyDelay > 0 then
    --     		self.ctl.rets["control_add_delay"] = self.piggyDelay + 1
    --     		self:showPiggyValues(self.piggyDelay / eachPiggyDelay)
    --     	end
    --     end
    --     if callback then
    --        callback()  
    --     end 
	-- end)
	-- local a4 = cc.Sequence:create(a1,a2,a3)
	-- self:runAction(a4)
	local callFun = function ()
		if self.showFreeSpinBoard then
        	if self.piggyDelay > 0 then
        		self.ctl.rets["control_add_delay"] = self.piggyDelay + 1
        		self:showPiggyValues(self.piggyDelay / eachPiggyDelay)
        	end
		end
		self.jpWinValue = 0
		if callback then
           callback()  
        end 
	end
	if not nomusic then
		self:playMusic(self.audio_list.frame_out)
	end
	if self.showBaseSpinBoard then 
		if self.ctl.rets and self.ctl.rets["base_win"] and self.ctl.rets["base_win"] > 0 then 
		else 
			self.ctl.rets["total_win"] = 0
			self.ctl.rets["setWinCoins"] = nil
			self.jpWinValue = 0
		end
	end
	self.ctl:startRollup(jpwin, callFun)

end
function customizedTheme:noFeatureLeft()
	if self.jpWinValue and self.jpWinValue > 0 then 
		return false
	end
	return true
end
--------------------------jp dialog end  ----------------------------

--------------------------Transition相关----------------------------
function customizedTheme:playTransition()
	local function delayAction()
		self.node_Transition = nil
		self.node_Transition = cc.Node:create()
		self.curScene:addToContentFooter(self.node_Transition)
        self:runAction(cc.Sequence:create(
        	   cc.CallFunc:create(function()
        	   	  self:showTransitionAnimation()
        	   	  self:playMusic(self.audio_list.transition)
        	   	  --播放转场音乐       	   	  
        	end)
        	))
	end	
	local endTime = 2.67
	self:playFadeToMinVlomeMusic()
	delayAction()
	self:laterCallBack(endTime, function ()
		self:playFadeToMaxVlomeMusic()
	end)
end

function customizedTheme:showTransitionAnimation()
	local file = self:getPic("spine/transition/spine")
	self.transitionSkeleton = self.transitionSkeleton or nil
	local pos = cc.p(0,0)
	local _, s =self:addSpineAnimation(self.node_Transition,nil, file,pos,"animation",nil,nil,nil,false,false,nil)
end

--------------------------------Free Game相关-------------------------------------
function customizedTheme:setDealFreeCollectState()
    self.ctl.spin_processing = true
    self.ctl.isProcessing  = true
end
function customizedTheme:enterFreeSpin()

	if  self.isFreeGameRecoverState == true then
		self.isFreeGameRecoverState = false
		--print("wy_isFreeGameRecoverState",self.freeType)
		if self.freeType == 1 then 
			if self.freePiggyValue then
		       self.label_piggyValue:setString(FONTS.formatByCount2(self.freePiggyValue,5,true))
		    end
		   self:changeSpinBoard(SpinBoardType.FreeSpin_normal)
		else
			if self.isMapFreeTriggerState then
				self:changeSpinBoard(SpinBoardType.Normal)
			else
			    self:setFreeSceneState()
			    self.ctl.footer:changeFreeSpinLayout3()
			end
		end
		
	end 
	self:showAllItem()
	self.playNormalLoopMusic = false
	self:dealMusic_PlayFreeSpinLoopMusic()
end

-- 设置进入free spin界面
function customizedTheme:showFreeSpinNode( count, sumCount, first)
	if self.freeType == 1 then
		if self.freePiggyValue then
	       self.label_piggyValue:setString(FONTS.formatByCount2(self.freePiggyValue,5,true))
	    end
	    if self.ctl and self.ctl.footer then
			self.ctl.footer:setFreeSpinLabel(count, sumCount)
			self.ctl.footer:changeFreeSpinLayout()
		end
	else
		if self.ctl and self.ctl.footer then
			self.ctl.footer:setFreeSpinLabel(count, sumCount)
			self.ctl.footer:changeFreeSpinLayout3()
		end		
	end	
	self:lockLobbyBtn()
end

function customizedTheme:updatedFreeSpinCount(remainingCount,totalCount) -- only rewritte
	self.ctl.footer:setFreeSpinLabel(remainingCount, totalCount)
end

function customizedTheme:setFreeSceneState()
	local freeType = self.freeType
	if freeType == nil then return end
	if freeType == 1 then
		self:changeSpinBoard(SpinBoardType.FreeSpin_normal)
	elseif freeType == 2 then
		self:changeSpinBoard(SpinBoardType.FreeSpin_map_35)
	elseif freeType == 3 then
		self:changeSpinBoard(SpinBoardType.FreeSpin_map_36)
	elseif freeType == 4 then
		self:changeSpinBoard(SpinBoardType.FreeSpin_map_46)
	elseif freeType == 5 then
		self:changeSpinBoard(SpinBoardType.FreeSpin_map_45)
	end
end

function customizedTheme:setFreeGameRecoverState(data)
    if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
        self.isFreeGameRecoverState = true
    end
end

function customizedTheme:playStartFreeSpinDialog( theData )                              
	self:enableMapInfoBtn(false)
	self.freeType = self.freeType or 1
	if self.freeType > 1 then
		if theData.enter_event then
			theData.enter_event()
		end
		if theData.click_event then
			theData.click_event()
		end
		if theData.end_event then
			theData.end_event()
		end
	else
		local enter_event = theData.enter_event 
		theData.enter_event = nil
		self:stopDrawAnimate()
		self:hideActivitysNode()
		local a1 = cc.DelayTime:create(1)
		local a2 = cc.CallFunc:create(function() 
			self.ctl.footer:setSpinButtonState(true)
			self:playMusic(self.audio_list.trigger_bell)
			self:playCoinsTriggerAnimation()
		end)
		local a3 = cc.DelayTime:create(2)
		local a4 = cc.CallFunc:create(function()
			-- if theData.enter_event then
			--     theData.enter_event()
			-- end 
			if enter_event then 
				enter_event()
			end
			self:stopAllLoopMusic()
			self:playMusic(self.audio_list.free_intro)
			if ADSControl:getInstance():canShowAds(ADType.REWARDVIDEO) then
				self:playAdStartFreeSpinDailog(theData)
			else
				self:playNoAdStartFreeSpinDailog(theData)
			end
		end)
		local a5 = cc.Sequence:create(a1,a2,a3,a4)
		self:runAction(a5)
	end
end
-- freespin音效相关
function customizedTheme:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	-- self.showBaseSpinBoard = true
	-- 	self.showFreeSpinBoard = false
	-- if self.showFreeSpinBoard then 
	-- 	self:playMusic(self.audio_list.free_dialog_start_show)
	-- else 
	-- 	self:playMusic(self.audio_list.map_start)
	-- end 
end
function customizedTheme:dealMusic_StopFSEnterMusic( )
	if self.showFreeSpinBoard then 
		self:stopMusic(self.audio_list.free_dialog_start_show)
	else 
		self:stopMusic(self.audio_list.map_start)
	end 
end
--Free Game 收集音乐
function customizedTheme:dealMusic_PlayFSCollectMusic( )
	if self.showFreeSpinBoard then 
		self:playMusic(self.audio_list.free_dialog_collect_show)
	else 
		self:playMusic(self.audio_list.map_collect)
	end 
end
function customizedTheme:dealMusic_StopFSCollectMusic( )
	if self.showFreeSpinBoard then 
		self:stopMusic(self.audio_list.free_dialog_collect_show)
	else 
		self:stopMusic(self.audio_list.map_collect)
	end 
end
function customizedTheme:dealMusic_PlayFSCollectEndMusic( )
	self:playMusic(self.audio_list.free_dialog_collect_close)
end
-- 添加没有广告的情况
function customizedTheme:playNoAdStartFreeSpinDailog(theData)
	theData = theData or {}
	local sType = fs_show_type.start
	local csbName = "dialog_free"
	local dialogType = "free_start"
	self.ctl.footer:setSpinButtonState(true)
	local end_event = theData.end_event
	theData.end_event = nil
	local pos = cc.p(0,182)
	theData.bg = 1
	if self.gameMasterFlag and self.gameMasterFlag == 1 then
		theData.bg = 4
	end
	theData.click_event = function ()
		self:playMusic(self.audio_list.btn_click)
		local a0 = cc.DelayTime:create(0.5)
		local a01 = cc.CallFunc:create(function ()
			self:playTransition()
		end)
		local a1 = cc.DelayTime:create(2.67)
		local a2 = cc.CallFunc:create(function ()
			self:changeSpinBoard(SpinBoardType.FreeSpin_normal)
		end)
		local a3 = cc.DelayTime:create(1)
		local a4 = cc.CallFunc:create(function() 
			self:showActivitysNode()
			self:dealMusic_PlayFreeSpinLoopMusic()
			if end_event then 
				end_event()
			end
		end)
		local a5 = cc.Sequence:create(a0,a01,a1,a2,a3,a4)
		self:runAction(a5)
	end
	local dialog = self:showThemeDialog(theData, sType, csbName, dialogType)
	self:setStartFreeBoardState(dialog, "start", self.freePiggyValue)
end
-- 添加有广告的情况
function customizedTheme:playAdStartFreeSpinDailog(theData)
	theData = theData or {}
	theData = theData or {}
	local sType = fs_show_type.start
	local csbName = "dialog_free"
	local dialogType = "free_start"
	self.ctl.footer:setSpinButtonState(true)
	local end_event = theData.end_event
	theData.end_event = nil
	theData.bg = 1
	if self.gameMasterFlag and self.gameMasterFlag == 1 then
		theData.bg = 4
	end
	theData.click_event = function ()
		self:playMusic(self.audio_list.btn_click)
		
		self.freeStartAdNode = nil
		self.isFreeNorTriggerShowAD = false
		local a0 = cc.DelayTime:create(0.5)
		local a01 = cc.CallFunc:create(function ()
			self:playTransition()
		end)
		local a1 = cc.DelayTime:create(2.67)
		local a2 = cc.CallFunc:create(function ()
			self:changeSpinBoard(SpinBoardType.FreeSpin_normal)
		end)
		local a3 = cc.DelayTime:create(1)
		local a4 = cc.CallFunc:create(function() 
			self:showActivitysNode()
			self:dealMusic_PlayFreeSpinLoopMusic()
			if end_event then 
				end_event()
			end
		end)
		local a5 = cc.Sequence:create(a0,a01,a1,a2,a3,a4)
		self:runAction(a5)
	end
	local dialog = self:showThemeDialog(theData, sType, csbName, dialogType)
	self:setStartFreeBoardState(dialog,"startAd",self.freePiggyValue,theData)
end
function customizedTheme:setStartFreeBoardState(dialog,state,pigValue,theData)
	if not dialog then return end
	local startRoot = dialog.startRoot
	local ad_node = startRoot:getChildByName("ad_node")
	local btn_node = startRoot:getChildByName("btn_node")
	local btnAdStart = btn_node:getChildByName("btn_ad_start")
	local ad_logo = btn_node:getChildByName("ad_logo")
	local pig_node = startRoot:getChildByName("pig_node")
	local pig_coins = pig_node:getChildByName("pig_coins")
	local label_node = startRoot:getChildByName("label_node")
	local label_add_node = ad_node:getChildByName("label_add_node")
	local btn_close_node = ad_node:getChildByName("btn_close_node")
	local btnClose = btn_close_node:getChildByName("btn_close")
	local btnStart = startRoot.btnStart
	pig_coins:setString(FONTS.formatByCount2(pigValue,7,true))
	if state == "start" then 
		ad_logo:setVisible(false)
		ad_node:setVisible(false)
		btnAdStart:setVisible(false)
		label_node:setPosition(cc.p(0,182))
	elseif state == "startAd" then  
		label_node:setPosition(cc.p(0,182))
		ad_logo:setVisible(true)
		btnAdStart:setVisible(true)
		label_add_node:setVisible(false)
		btn_close_node:setVisible(true)

		dialog.btnAdClose = btnClose
		dialog.btnAdStart = btnAdStart
		dialog.label_add_node = label_add_node
		dialog.label_node = label_node
		dialog.ad_logo = ad_logo

		self.freeStartAdNode = dialog
		self.isFreeNorTriggerShowAD = false
		self.freeNorTriggerTheData  = theData
		bole.send_codeInfo("record", {pid = PID.ad_BigMoney_FreeGame_show}, false)

		local function btnEvent(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				sender:setBright(false)
				sender:setTouchEnabled(false)
        	    btnStart:setBright(false)
				btnStart:setTouchEnabled(false)
        	    btnAdStart:setBright(false)
				btnAdStart:setTouchEnabled(false)
				dialog:clickStartBtn()
        	end
		end
		local function showAdFunc(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
        	    sender:setBright(false)
				sender:setTouchEnabled(false)
				sender:removeAllChildren()
				btnClose:setTouchEnabled(false)
				btnClose:setBright(false)
				self:showFreeNorTriggerAD(theData)
        	end
		end
		btnClose:addTouchEventListener(btnEvent)
        self:addBtnSpine(btnAdStart)
		btnAdStart:addTouchEventListener(showAdFunc)
	end
end
function customizedTheme:addBtnSpine(btnNode)
	if not btnNode then return end
	local size = btnNode:getContentSize()
	local _, s = bole.addSpineAnimation(btnNode, nil, self:getSpineFile("dialog_btn"), cc.p(size.width / 2 + 5, size.height / 2), "animation", nil, nil, nil, true, true)
end
function customizedTheme:showFreeNorTriggerAD(theData)
	if not self.isFreeNorTriggerShowAD then
		self.isFreeNorTriggerShowAD = true
		bole.send_codeInfo("record", {pid = PID.ad_BigMoney_FreeGame_click}, false)
		ADSControl:getInstance():showAds(ADType.REWARDVIDEO,ADSource.BigMoney,1)
	end
end
function customizedTheme:showFreeNorTriggerADClose(theData) -- 关闭广告
	self:showStartAdBtnStatus(theData)
end

function customizedTheme:showStartAdBtnStatus(theData)
	if self.freeStartAdNode then 
		local btnClose = self.freeStartAdNode.btnAdClose
		local btnAdStart = self.freeStartAdNode.btnAdStart
		local btnStart = self.freeStartAdNode.startRoot.btnStart
		local adLogo = self.freeStartAdNode.ad_logo
		if btnClose and bole.isValidNode(btnClose) then
			btnClose:setVisible(false)
		end
		if btnAdStart and bole.isValidNode(btnAdStart) then
			btnAdStart:setVisible(false)
		end
		if adLogo and bole.isValidNode(adLogo) then
			adLogo:setVisible(false)
		end
		if btnStart and bole.isValidNode(btnStart) then
			btnStart:setVisible(true)
			btnStart:setTouchEnabled(true)
			btnStart:setBright(true)
		end
	end
end

function customizedTheme:showFreeNorTriggerADError(theData) -- 关闭广告
	self:showStartAdBtnStatus(theData)
end
function customizedTheme:showFreeNorTriggerADSuccess(data) -- 关闭广告
	data = data or 0
	if self.ctl.sumFreeSpinCnt then
		self.ctl.sumFreeSpinCnt = self.ctl.sumFreeSpinCnt + data
	end
	if self.ctl.freespin then 
		self.ctl.freespin = self.ctl.freespin + data
	end
	if self.freeStartAdNode then 
		local label_add_node = self.freeStartAdNode.label_add_node
		local label_node = self.freeStartAdNode.label_node
		if label_add_node and bole.isValidNode(label_add_node) then 
			label_add_node:setVisible(true)
			local ad_labels = label_add_node:getChildByName("ad_labels")
			if ad_labels then 
				ad_labels:setString(data)
			end
		end
		if label_node and bole.isValidNode(label_node) then 
			label_node:setPosition(cc.p(-80, 182))
		end
	end
	self:showStartAdBtnStatus()
end
-- 

-- 进入free spin的弹窗 不弹窗
function customizedTheme:playMoreFreeSpinDialog( theData ) 
	self:hideActivitysNode()
	self.ctl.footer:setSpinButtonState(true)
	theData = theData or {}
	self:playMusic(self.audio_list.trigger_bell)
	local sType = fs_show_type.more
	local csbName = "dialog_free"
	local dialogType = "free_more"
	theData.bg = 2
	if theData["count"] and theData["count"] == 1 then
		 theData.bg = 5
	end
	if theData.enter_event then
        theData.enter_event()
    end
	local end_event = theData.end_event
	local click_event = theData.click_event
	theData.end_event = nil
	theData.click_event = nil
	theData.click_event = function ()
		if click_event then 
			click_event()
		end
        if end_event then
            end_event()
		end
		self:playFadeToMaxVlomeMusic()
		self.ctl.footer:setSpinButtonState(false)
		self:showActivitysNode()
	end
	local dialog = self:showThemeDialog(theData, sType, csbName, dialogType)
end
function customizedTheme:playCollectFreeSpinDialog(theData)
	self:hideActivitysNode()
	self:stopDrawAnimate()
	if self.freeType > 1 then 
		if theData.enter_event then
			theData.enter_event()
		end
		local data = {}
		data["mapLevel"] = self.mapLevel
	    data["mapInfo"] = self.mapData
		data["theData"] = theData
	    local theDialog = BigMoneyMapFreeCollect.new(self, self:getPic("csb/"), data)
	    theDialog:showMapFreeCollectDialog()
	else
		if self.gameMasterFlag and self.gameMasterFlag == 1 then  --gamemaster的加成
			self.ctl.freewin = self.ctl.freewin * 2
			if self.ctl.totalWin then 
				self.ctl.totalWin = self.ctl.totalWin * 2
				self.ctl:updateFooterCoin()
			end
			theData["coins"] = self.ctl.freewin
		end
		if ADSControl:getInstance():canShowAds(ADType.REWARDVIDEO) and self:canShowAds() then 
			self:playAdCollectFreeSpinDailog(theData)
		else
			self:playNoAdCollectFreeSpinDailog(theData)
		end
	end
end

function customizedTheme:playNoAdCollectFreeSpinDailog(theData)
	theData = theData or {}
	local sType = fs_show_type.collect
	local dialog = nil
	local csbName = "dialog_free"
	local dialogType = "free_collect"
	local end_event = theData.end_event
	local click_event = theData.click_event
	local changeLayer_event = theData.changeLayer_event
	theData.bg = 3
	if self.gameMasterFlag and self.gameMasterFlag == 1 then 
		theData.bg = 6
	end
	theData.end_event = nil
	theData.changeLayer_event = nil
	theData.click_event = function ()
		-- self:playTransition()
		if click_event then 
			click_event()
		end
		local a0 = cc.DelayTime:create(0.5)
		local a01 = cc.CallFunc:create(function ()
			self:playTransition()
		end)
		local a1 = cc.DelayTime:create(2.67)
		local a2 = cc.CallFunc:create(function() 
			self:showActivitysNode()
			self:changeSpinBoard(SpinBoardType.Normal)
			self:resetPiggyValueState()
			if changeLayer_event then
				changeLayer_event()
			end
		end)
		local a3 = cc.DelayTime:create(1)
		local a4 = cc.CallFunc:create(function()
			self:setEnableBtnNode(true)
			self:finshSpin()
			if end_event then	    
				end_event()
			end
		end)
		local a5 = cc.Sequence:create(a0,a01,a1,a2,a3,a4)
		self:runAction(a5)
	end
	local dialog = self:showThemeDialog(theData, sType, csbName, dialogType)
	self:setCollectFreeBoardState(dialog, "collect", theData)
end
function customizedTheme:playAdCollectFreeSpinDailog(theData)
	--添加点击事件,控制按钮的点击
	theData = theData or {}
	local sType = fs_show_type.collect
	local dialog = nil
	local csbName = "dialog_free"
	local dialogType = "free_collect"
	local end_event = theData.end_event
	local click_event = theData.click_event
	local changeLayer_event = theData.changeLayer_event
	theData.bg = 3
	if self.gameMasterFlag and self.gameMasterFlag == 1 then 
		theData.bg = 6
	end
	theData.end_event = nil
	theData.changeLayer_event = nil
	theData.click_event = function ()
		self.freeCollectAdNode = nil
		self.isFreeNorCollectShowAD = false
		-- self:playTransition()
		if click_event then 
			click_event()
		end
		local a0 = cc.DelayTime:create(0.5)
		local a01 = cc.CallFunc:create(function ()
			self:playTransition()
		end)
		local a1 = cc.DelayTime:create(2.67)
		local a2 = cc.CallFunc:create(function() 
			self:showActivitysNode()
			self:changeSpinBoard(SpinBoardType.Normal)
			self:resetPiggyValueState()
			if changeLayer_event then
				changeLayer_event()
			end
		end)
		local a3 = cc.DelayTime:create(1)
		local a4 = cc.CallFunc:create(function()
			self:setEnableBtnNode(true)
			self:finshSpin()
			if end_event then	    
				end_event()
			end
		end)
		local a5 = cc.Sequence:create(a0,a01,a1,a2,a3,a4)
		self:runAction(a5)
	end
	local dialog = self:showThemeDialog(theData, sType, csbName, dialogType)
	self:setCollectFreeBoardState(dialog, "collectAd", theData)
end
-- 特殊处理有广告的情况
function customizedTheme:setCollectFreeBoardState(dialog,state,theData)
	local collectRoot = dialog.collectRoot
	local btnNode = collectRoot:getChildByName("btn_node")
	local ad_logo = btnNode:getChildByName("ad_logo")
	local ad_node = collectRoot:getChildByName("ad_node")
	local btnAdCollect = btnNode:getChildByName("btn_ad_collect")
	local btn_close_node = ad_node:getChildByName("btn_close_node")
	local btnClose = btn_close_node:getChildByName("btn_close")
	local btnCollect = collectRoot.btnCollect
	if state == "collect" then 
		ad_node:setVisible(false)
		ad_logo:setVisible(false)
		btnAdCollect:setVisible(false)
	elseif state == "collectAd" then 
		self.freeCollectAdNode = dialog
		ad_node:setVisible(true)
		dialog.btnAdClose = btnClose
		dialog.btnAdCollect = btnAdCollect
		dialog.btnCollect = btnCollect
		dialog.ad_logo = ad_logo
		self:addBtnSpine(btnAdCollect)
		self.isFreeNorCollectShowAD = false
		bole.send_codeInfo("record", {pid = PID.ad_BigMoney_Collect_show}, false)

		local function btnEvent(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				sender:setBright(false)
				sender:setTouchEnabled(false)
        	    btnCollect:setBright(false)
				btnCollect:setTouchEnabled(false)
        	    btnAdCollect:setBright(false)
				btnAdCollect:setTouchEnabled(false)
				dialog:clickCollectBtn()
        	end
		end
		local function showAdFunc(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
        	    sender:setBright(false)
				sender:setTouchEnabled(false)
				sender:removeAllChildren()
				btnClose:setTouchEnabled(false)
				btnClose:setBright(false)
				self:showFreeNorCollectAD(theData)
        	end
		end
		btnClose:addTouchEventListener(btnEvent)
		btnAdCollect:addTouchEventListener(showAdFunc)
	end
end
function customizedTheme:showFreeNorCollectAD(theData)
	if not self.isFreeNorCollectShowAD then
		self.isFreeNorCollectShowAD = true
		bole.send_codeInfo("record", {pid = PID.ad_BigMoney_Collect_click}, false)
		ADSControl:getInstance():showAds(ADType.REWARDVIDEO,ADSource.BigMoney,2)
	end
end
function customizedTheme:showFreeNorCollectADClose(theData)
	self:showCollectAdBtnStatus()
end
function customizedTheme:showFreeNorCollectADError(theData)
	self:showCollectAdBtnStatus()
end
function customizedTheme:showCollectAdBtnStatus(delayTime)
	if self.freeCollectAdNode then 
		local btnClose = self.freeCollectAdNode.btnAdClose
		local btnAdCollect = self.freeCollectAdNode.btnAdCollect
		local collectRoot = self.freeCollectAdNode.btnCollect
		local adLogo = self.freeCollectAdNode.ad_logo
		if btnClose and bole.isValidNode(btnClose) then
			btnClose:setVisible(false)
		end
		if btnAdCollect and bole.isValidNode(btnAdCollect) then
			btnAdCollect:setVisible(false)
		end
		if adLogo and bole.isValidNode(adLogo) then
			adLogo:setVisible(false)
		end
		if collectRoot and bole.isValidNode(collectRoot) then
			collectRoot:setVisible(true)
			collectRoot:setBright(true)
			collectRoot:setTouchEnabled(false)
		end
		if delayTime and delayTime > 0 then 
			self:laterCallBack(delayTime, function()
				if collectRoot and bole.isValidNode(collectRoot) then
					collectRoot:setTouchEnabled(true)
				end
			end)
		end
	end
end
function customizedTheme:showFreeNorCollectADSuccess(data)
	data = data or 1
	local oldfreewin = self.ctl.freewin or 0
	if self.ctl.freewin then 
		self.ctl.freewin = self.ctl.freewin * data
	end
	if self.ctl.totalWin then 
		self.ctl.totalWin = self.ctl.totalWin * data
	end
	local freewin = self.ctl.freewin or 0
	local rollupDuration = 2
	if self.freeCollectAdNode then 
		self.freeCollectAdNode.fsData["coins"] = freewin
		local collectRoot = self.freeCollectAdNode.collectRoot
		if collectRoot and collectRoot.labelWin then 
			if collectRoot.labelWin.nrOverRoll then
        	    collectRoot.labelWin:nrOverRoll()
			end
			if self.freeCollectAdNode.dialog_config then
    		    local width = self.freeCollectAdNode.dialog_config.maxWidth
    		    self.freeCollectAdNode:_setCollectScaleByValue(freewin, width)
			end
			collectRoot.labelWin:nrStartRoll(oldfreewin, freewin, rollupDuration)
		end
	end
	self:showCollectAdBtnStatus(rollupDuration)
end

-- 当前的奖励值大于 bet * 15时则不展示广告
function customizedTheme:canShowAds()
	-- 判断是不是看完广告了
	local curBet       = self.ctl:getCurBet() or 1
	local freeWin      = self.ctl.freewin or 1
	local finish_ad    = self.ctl.collectAdFinish or 0
	local notGameMaster = true
	if self.gameMasterFlag and self.gameMasterFlag == 1 then
		notGameMaster = false
	end
	if curBet * 15 > freeWin and finish_ad == 0 and notGameMaster then
		return true
	end
	return false
end

function customizedTheme:showBoardAnimation() 
	self.freeNorBoardAniNode:removeAllChildren()
	local file1 = self:getPic("spine/free_board/1/spine")
	local file2 = self:getPic("spine/free_board/2/spine")

	self:addSpineAnimation(self.freeNorBoardAniNode,2,file1,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	self:addSpineAnimation(self.freeNorBoardAniNode,5,file2,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
end

function customizedTheme:stopBoardAnimation()
	self.freeNorBoardAniNode:removeAllChildren()
end

function customizedTheme:resetPiggyValueState( ... )
	for i = 1,6 do
		for j = 1,4 do
			self.reelPiggyValueList[i][j].node:setVisible(false)
			self.reelPiggyValueList[i][j].labelRetrigger:setVisible(false)
			self.reelPiggyValueList[i][j].labelRetrigger:setString("")
			self.reelPiggyValueList[i][j].labelValue:setString("")
		end
	end
end

function customizedTheme:showPiggyValues(counts)
	self.ctl.footer:setSpinButtonState(true) -- whj 添加,控制 显示小猪Valus动画的时候，spin按钮不可点击
    local piggyAllForEachSpin = 0
	local recordList = {}
	for i = 1,6 do
		recordList[i] = {}
		for j = 1,4 do
			recordList[i][j] = true
		end
	end

	local isWait = true

	local item_list = self.item_list
	self:runAction(cc.Repeat:create(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			for m = 1,6 do
				for n = 1,4 do
					if isWait then
						if item_list[m] and item_list[m][n] then
							if piggyKeySet[item_list[m][n]] and recordList[m][n] then
								recordList[m][n] = false
								isWait = false
								local freeInfo = item_list[m][n] - 10
								local cell = self.spinLayer.spins[m]:getRetCell(n)
								local pos = self.spinLayer:getCellPos(m, n)
								self.reelPiggyValueList[m][n].node:setPosition(pos)
								self.reelPiggyValueList[m][n].node:setScale(0)
								self.reelPiggyValueList[m][n].node:setVisible(true)
								self.reelPiggyValueList[m][n].labelValue:setString(FONTS.formatByCount2(self.freePiggyValue,5,true))
								if freeInfo > 0 then
									local text = " FREE GAME"
									if freeInfo >1 then
										text = " FREE GAMES"
									end
									self.reelPiggyValueList[m][n].labelRetrigger:setString("+"..freeInfo..text)
									self.reelPiggyValueList[m][n].labelRetrigger:setVisible(true)
								end
								self.reelPiggyValueList[m][n].node:runAction(cc.Sequence:create(
									cc.CallFunc:create(function()
										self:playPiggyTriggerAnimation(m,n)
										self:playMusic(self.audio_list.piggy_value)
									end),
									cc.DelayTime:create(0.8),
									cc.ScaleTo:create(0.15,1.3,1.3),
			   	    	            cc.ScaleTo:create(0.1,1,1),
			   	    	            cc.CallFunc:create(function()
			   	    	            	piggyAllForEachSpin = piggyAllForEachSpin + self.freePiggyValue
			   	    	            	--local totalWin = self.ctl.totalWin + piggyAllForEachSpin
			   	    	            	--self.ctl.footer:setWinCoinsString(totalWin)
			   	    	            	if self.ctl.rets and self.ctl.rets["base_win"] then
			   	    	            		self.ctl.rets["base_win"] = self.ctl.rets["base_win"] + self.freePiggyValue
			   	    	            	end
			   	    	            	--print("wy_showPiggyValues_baseWin= ",self.ctl.rets["base_win"],self.ctl.rets["setWinCoins"],self.freePiggyValue)
			   	    	            end)
								))
							end
						end
					end
				end
			end
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function( ... )
			isWait = true
		end)
	),counts))
end

function customizedTheme:showPiggyAddedAnimation(freeType)
	local allCol = 5
	local allRow = 3
	freeType = freeType or 1
	if freeType == 1 then return end

	if freeType == 3 or freeType == 4 then 
		allCol = 6
	end
	if freeType == 4 or freeType == 5 then 
		allRow = 4
	end
	local file = self:getPic("spine/dialog/jiazhutanchuang") --展示的弹窗
	local file_piggy = self:getPic("spine/base/add_pig/zaqipan")
	local delayPig = 60/30
	self:addPigsAnticipate(file_piggy, allCol, allRow)

	local a1 = cc.DelayTime:create(delayPig)
	local a2 = cc.CallFunc:create(function ()
		self.dimmerNode:setOpacity(0)
		self.dimmerNode:setVisible(true)
		bole.addSpineAnimation(self.mapFreeAddPiggyMessage, nil, file, cc.p(0,0), "animation")
		self.dimmerNode:runAction(cc.FadeIn:create(0.3))
	end)
	local a3 = cc.DelayTime:create(2)
	local a4 = cc.CallFunc:create(function ()
		self.dimmerNode:runAction(cc.FadeOut:create(0.3))
		self.mapFreeAddPiggyNode:runAction(cc.FadeOut:create(0.3))
	end)
	local a5 = cc.DelayTime:create(0.3)
	local a6 = cc.CallFunc:create(function ()
		self.dimmerNode:setVisible(false)
		self.mapFreeAddPiggyNode:removeAllChildren()
		self.isMapFreeAddPiggy = false
	end)
	local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a6)
	libUI.runAction(self, a7)
end
function customizedTheme:addPigsAnticipate( file1, allCol, allRow )
	self.mapFreeAddPiggyNode:setOpacity(255)
    local symbolCount = allRow
	local random1 = {}
	local randomLen = {0,0,0,0,0}
    for col = 1, allCol do
        for key = 1, symbolCount do
			local num = math.random()
			local ran = math.random(1, 5)
			if randomLen[ran] > 4 then 
				for key1, val1 in ipairs(randomLen) do
					if val1 < 4  then
						ran = key1
					end
				end
			end
            if num < 0.9 then
                table.insert(random1, {col, key, ran})
			end
			randomLen[ran] = randomLen[ran] + 1
        end
    end
    local delayTime = {0, 10/30, 20/30, 30/30, 40/30}
    for key, val in ipairs(random1) do
        local pos = self:getCellPos(val[1], val[2])
        local random = val[3]
        local node = cc.Node:create()
        node:setPosition(pos)
        self.mapFreeAddPiggyNode:addChild(node,30)
        local a1 = cc.DelayTime:create(delayTime[random])
		local a2 = cc.CallFunc:create(function ( ... )
			-- self:playMusic(self.audio_list.piggy_added)
			self:playEffectWithInterval(self.audio_list["piggy_added"],0.1,false)
            bole.addSpineAnimation(node, 30, file1, cc.p(0,0), "animation")
        end)
        local a3 = cc.DelayTime:create(27/30)
        local a4 = cc.RemoveSelf:create()
        local a5 = cc.Sequence:create(a1,a2,a3,a4)
        libUI.runAction(node, a5)
    end
end

function customizedTheme:exitMapFreeGame(theData)
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self:playTransition()
		end),
		cc.DelayTime:create(2.67),
		cc.CallFunc:create(function()		
			self:setNextCollectTargetImage(self.mapLevel)
			self:setCollectProgressImagePos(0)
			if theData.click_event then
				theData.click_event()
			end
			self:changeSpinBoard(SpinBoardType.Normal)
			self.ctl.footer:changeNormalLayout2()			
			self:resetPiggyValueState()
			if theData.changeLayer_event() then
			   theData.changeLayer_event()
		    end
			self.ctl.footer:enableOtherBtns(false) -- whj 添加,控制super free 结束之后,在changeLayer_event 里面通过 removePointBet 方法解锁的 加减bet 和maxBet, 按钮通过这个方法关闭
		    self.ctl.footer:setSpinButtonState(true)
		    self:stopDrawAnimate()
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self:dealMusic_PlayNormalLoopMusic()
			local data = {}
	    	data["mapLevel"] = self.mapLevel
	    	data["mapInfo"] = self.mapData
			local theDialog = BigMoneyMapGame.new(self, self:getPic("csb/"), data)
	        theDialog:showMapScene(true)			
		end),
		cc.DelayTime:create(6.5),
		cc.CallFunc:create(function()
			if theData.end_event then
				theData.end_event()
			end
			self:showActivitysNode()
			--self:resetMapInfoData()
			self.mapPoints = 0
			self:enableMapInfoBtn(true)
		end)
	))
end

function customizedTheme:showMasterGameStartPopup()
	if self.ctl and self.ctl.isMasterTheme and self.themeid and self.ctl:isMasterTheme(self.themeid) then
		local theData = {}
		theData.click_event = function ()
			self.gameMasterDialog = nil
			self:playFadeToMaxVlomeMusic()
			self:playMusic(self.audio_list.btn_click)
		end
		local sType = fs_show_type.start
		local csbName = "dialog_gameMaster"
		local dialogType = "gamemaster"
		local dialog = nil
		dialog = self:showThemeDialog(theData, sType, csbName, dialogType)
		self.gameMasterDialog = dialog
	end
end
function customizedTheme:hideMasterGameStartPopup()
	if self.gameMasterDialog then 
		self.gameMasterDialog:clickStartBtn()
		self.gameMasterDialog = nil
	end
end

--------------------------Bonus Game相关----------------------------
BigMoneyBonusGame = class("BigMoneyBonusGame", CCSNode)
local BSGame = BigMoneyBonusGame

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl
	self.mapLevel = self.theme.mapLevel
	if self.data.core_data["map_wheel_spin"] then
		self.bonusType = 1
		self:updateWheelData()
	else
		self.bonusType = 2
		self:updateMapFreeData()    
	end
	CCSNode.ctor(self, self.csb)
end

function BSGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end
function BSGame:updateWheelData()
	self.csb = self.csbPath .."wheel.csb"
	self.wheelConfigList = self.data.core_data["map_wheel_spin"]["wheel"]
	self.baseBet = 1
	self.avgBet = self.data.core_data["map_wheel_spin"]["avg_bet"]
	self.winIndex = self.data.core_data["map_wheel_spin"]["index"]+1
	self.isBooster = self.winIndex == 1 and true or false
	self.winValue = self.data.core_data["map_wheel_spin"]["total_win"]
	self.stopAngle = 360-((self.winIndex-1) * 360 / #self.wheelConfigList)

	self.isAdFinish = self.data.core_data["map_wheel_spin"]["finish_ad"] or 0

	self.data.isStart = self.data.isStart or false
	self.data.isWheelStop = self.data.isWheelStop or false
	self.data.isWheelStopExtra = self.data.isWheelStopExtra or false
	self.data.isWheelCollect = self.data.isWheelCollect or false

	self:saveBonus()
	self.boosterItem = self.wheelConfigList[1] - 10 

	if self.isBooster then
	 	self.theme.mapData = self.theme.mapData or {}
	 	if self.theme.mapData["extra_fg"] == 0 then
	 	   self.theme.mapData["extra_fg"]   = self.data.core_data["map_wheel_spin"]["extra_fg"]
	 	end
	 	if self.theme.mapData["incre_pay"] == 0 then
	       self.theme.mapData["incre_pay"]  = self.data.core_data["map_wheel_spin"]["incre_pay"]
	    end
	    if  self.theme.mapData["reel_count"] == 0 then
	        self.theme.mapData["reel_count"] = self.data.core_data["map_wheel_spin"]["add_reel"]
	    end
	    if self.theme.mapData["row_count"] == 0 then
	       self.theme.mapData["row_count"]  = self.data.core_data["map_wheel_spin"]["add_row"]
	    end
	    if self.theme.mapData["stick"] == 0 then
	       self.theme.mapData["stick"]      = self.data.core_data["map_wheel_spin"]["stick"]
	    end
	    self.theme.mapData["piggy_list"] = self.data.core_data["piggy_list"]
	end  
end
function BSGame:updateMapFreeData()
	local boosterCountsList = {[3] = 2,[7] = 3,[12] = 4,[18] = 5}
	self.csb = self.csbPath.."map_free.csb"
	self.data.isBoard = self.data.isBoard or false
	self:saveBonus()
	self.mapInfoList = {}
	self.mapInfoList["extra_fg"] = self.theme.mapData["extra_fg"]
	self.mapInfoList["incre_pay"] = self.theme.mapData["incre_pay"]
	self.mapInfoList["reel_count"] = self.theme.mapData["reel_count"]
	self.mapInfoList["row_count"] = self.theme.mapData["row_count"]
	self.mapInfoList["stick"] = self.theme.mapData["stick"]
	self.mapInfoList["piggy_list"] = self.theme.mapData["piggy_list"]

	self.boosterTriggerList = {}
	local data = self.mapInfoList
	self.boosterGetInfo = {}
	self.boosterGetInfo = self.theme:getBoosterInfo(data)
	if self.mapLevel == 0 then
		self.boosterAllCount = 5
	else
	    self.boosterAllCount = boosterCountsList[self.mapLevel] or 0
	end
end

function BSGame:loadControls()
	if self.bonusType == 1 then
		self:initMapWheelNode()
    elseif self.bonusType == 2 then
    	self:initMapFreeBonusNode()
    end
end
--------------  转盘的玩法  --------------
function BSGame:initMapWheelNode()
	self.wheel_root = self.node:getChildByName("wheel_node")
	self.wheel_root:setPosition(cc.p(0,-830))
	self.wheel = self.wheel_root:getChildByName("wheel_bg")
	local num_node = self.wheel:getChildByName("num_node")
	self.num_list = {}
	for i = 1,4 do 
	    self.num_list[i] = num_node:getChildByName("num_"..i)
	    if i == 1 then
	    	local num = self.avgBet / self.baseBet
	        self.num_list[i]:setString(FONTS.formatByCount2(num, 4, true))
	    else
	       local num = self.wheelConfigList[i] * self.avgBet / self.baseBet
	       self.num_list[i]:setString(FONTS.formatByCount2(num, 4, true))
	    end
	end

	local booster_node = self.wheel:getChildByName("booster_node")
	local booster_item = self.boosterItem
	for i = 1,5 do
		local item = booster_node:getChildByName(i)
		item:setVisible(i == booster_item)
	end

	self.wheel_ad_pic = self.wheel:getChildByName('ad_pic')
	self.wheel_ad_pic:setVisible(false)

	self.btn_spin = self.wheel_root:getChildByName("btn_spin")
    self.btn_aniNode = self.wheel_root:getChildByName("spinBtn_ani_node")
    self.win_aniNode = self.wheel_root:getChildByName("win_ani_node")
	self.spinText = self.wheel_root:getChildByName("spinBtn_text")
	self.wheel_pointer = self.wheel_root:getChildByName("wheel_pointer")
	self.wheel_bg_node = self.wheel_root:getChildByName("bg_node")
	self:_addWheelPointAni()
    self.spinText:setColor(cc.c3b(255, 255, 255))
    self.spinText:setVisible(true)

    self.dimmer1 = self.node:getChildByName("dimmer_node1")
	self.dimmer1:setVisible(false)
end
function BSGame:_addWheelPointAni()
	local file = self.theme:getPic("spine/wheel/zhizhen")
	local file1 = self.theme:getPic("spine/wheel/zhuanpan")
	local file2 = self.theme:getPic("spine/wheel/zhuanpan2")
	local wheelBG = self.wheel:getChildByName("wheel_bg")
	self.wheel_pointer:removeAllChildren()
	bole.addSpineAnimation(self.wheel_pointer, nil, file, cc.p(38.5,33), "animation", nil, nil, nil, true, true)
	bole.addSpineAnimation(self.wheel_bg_node, -1, file1, cc.p(0, 0), "animation", nil, nil, nil, true, true)
	bole.addSpineAnimation(wheelBG, 1, file2, cc.p(235, 235), "animation", nil, nil, nil, true, true)
end
function BSGame:initMapFreeBonusNode()
	self.node:setVisible(false)
end

function BSGame:enterBonusGame(tryResume)
	self.theme:stopDrawAnimate()
	self.theme:enableMapInfoBtn(false)
	self.theme:stopAllLoopMusic()
	self.theme:setEnableBtnNode(true)
	self.theme.ctl.footer:setSpinButtonState(true)
	if tryResume then
		self.callback = function ( ... )
        	-- 断线重连回调方法
        	local endCallFunc2 = function ( ... )
        		self.ctl.rets.setWinCoins = nil
        		self.ctl:handleResult()
        		
        		if self.endCallBack then 
        			self.endCallBack()
        		end
        	end
	        endCallFunc2()
        end
		self.ctl.isProcessing = true
	end

	if self.bonusType == 1 then
		self:enterMapWheelBonus(tryResume)
	elseif self.bonusType == 2 then
		self:enterMapFreeBonus(tryResume)
	end

end

-- Map Wheel 相关
function BSGame:enterMapWheelBonus(tryResume)
	local function playIntro()
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(function( ... )
				self.theme:playMusic(self.theme.audio_list.trigger_bell)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()				
				-- self:playTriggerBoard()
				self:playMapWheelStartDialog()
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				--self.theme.collectProgressAniNode:removeAllChildren()
				--self.theme.collectWheelAniNode:removeAllChildren()
			end)		
		))	
		
	end

	local function snapIntro()
		self.isAdFinish = self.isAdFinish or 0
		local function recoverSpin( ... )
			local winIndex = self.data.core_data["map_wheel_spin"]["index_2"]+1
			self.winIndex  = winIndex
			self.isBooster = self.winIndex == 1 and true or false
			self.winValue  = self.data.core_data["map_wheel_spin"]["total_win_2"]
			self.stopAngle = 360-((self.winIndex-1) * 360 / #self.wheelConfigList)
		end

        local function recoverTriggerBoardState( ... )
        	if self.isAdFinish == 1 then
        		recoverSpin()
        	end
			-- self:playTriggerBoard()
			self:playMapWheelStartDialog()
        end		

		local function recoverCollectState( ... )
			self:showWheelScene()
			self.spinText:setColor(cc.c3b(92,92,92))
			--self:shwoSpinBtnPressedAnimation()
			self.spinText:setVisible(false)
			self.wheel:setRotation(self.stopAngle)
			-- self:playWheelBonusCollect()
			self:playMapWheelCollectDialog()
			self.theme:dealMusic_PlayBonusLoopMusic()
		end

		local function recoverCollectAdState( ... )
			-- recoverSpin()
			self:showWheelScene()
			self.spinText:setColor(cc.c3b(92,92,92))
			self.spinText:setVisible(false)
			self.wheel:setRotation(self.stopAngle)
			-- self:playWheelBonusAdCollect()
			self:playMapWheelADCollectDialog()
			self.theme:dealMusic_PlayBonusLoopMusic()
		end

		local function recoverSpinState( ... )
			self:showWheelScene()
			self.theme:dealMusic_PlayBonusLoopMusic()
			self:runAction(cc.Sequence:create(
				cc.CallFunc:create(function()
					self:playSpinBtnAnimation("idle")
				end),
				cc.DelayTime:create(0.5),
				cc.CallFunc:create(function()					
					self.btn_spin:setVisible(true)
				    self.btn_spin:setTouchEnabled(true)
					self:initSpinEvent()
				end)
			))
		end
		
		if not self.data.isStart then
		    self.data.isWheelStop = false
		    self.data.isWheelStopExtra = false
		    self:saveBonus()
		    recoverTriggerBoardState()
		elseif self.data.isWheelStopExtra then
			if self.isAdFinish == 1 then
				self.winValue = self.data.core_data["map_wheel_spin"]["total_win_2"]
			end			
			recoverCollectState()
		elseif self.data.isWheelStop then
			if self:canShowWheelAds() then
				recoverCollectAdState()
			elseif self.data.isWheelCollect then
				if self.isAdFinish == 1 then
					recoverSpin()
					recoverSpinState()
				else
					recoverCollectState()
				end	
			else	
				recoverCollectState()	
			end
		else
			if self.isAdFinish == 1 then
				recoverSpin()
			end	
			recoverSpinState()
		end
		
	end
	self.theme.curScene:addToContentFooter(self)
	if tryResume then
		snapIntro()
	else
		playIntro()
	end
end

------------------------------------ mapwheel start弹窗 start ------------------------------------
function BSGame:playMapWheelStartDialog()
	local theData = {}
	self.theme:playMusic(self.theme.audio_list.popup_trigger_in)
	theData.click_event = function ()
		self.data.isStart = true
		self:saveBonus()
		self.theme:playMusic(self.theme.audio_list.btn_click)
		local a1 = cc.DelayTime:create(0.5)
		local a2 = cc.CallFunc:create(function ()
			self.theme:stopDrawAnimate()
			self:playWheelScene()
		end)
		local a3 = cc.DelayTime:create(0.67)
		local a4 = cc.CallFunc:create(function ()
			self:playSpinBtnAnimation("idle")
			self.theme:dealMusic_PlayBonusLoopMusic()
		end)
		local a5 = cc.DelayTime:create(0.3)
		local a6 = cc.CallFunc:create(function ()
			self.btn_spin:setVisible(true)
			self.btn_spin:setTouchEnabled(true)
			self:initSpinEvent()
			self.theme:playFadeToMaxVlomeMusic()
		end)
		local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a6)
		self:runAction(a7)
	end
	local sType = fs_show_type.start
	local csbName = "dialog_wheel"
	local dialogType = "wheel_start"
	local dialog = self.theme:showThemeDialog(theData, sType, csbName, dialogType)
end
------------------------------------ mapwheel start弹窗 end ------------------------------------
------------------------------------ mapwheel collect弹窗 start ------------------------------------
function BSGame:playMapWheelCollectDialog()
	-- playWheelBonusCollect
	self.theme:stopAllLoopMusic()
	self.theme:playMusic(self.theme.audio_list.popup_collect_in)
	local theData = {}
	theData.coins = self.winValue
	theData.click_event = function ()
		if self.theme then 
			if self.initMapWheelCollectEvent then 
				self:initMapWheelCollectEvent()
			end
			self.theme:playMusic(self.theme.audio_list.btn_click)
			self.theme:playFadeToMaxVlomeMusic()
		end
	end
	local sType = fs_show_type.collect
	local csbName = "dialog_wheel"
	local dialogType = "wheel_collect"
	theData.bg = 6
	if self.isBooster then
		theData.bg = 7
	end
	local dialog = self.theme:showThemeDialog(theData, sType, csbName, dialogType)
	self:setMapWheelState(dialog.collectRoot)
end
function BSGame:setMapWheelState(collectRoot, dialog)
	if not collectRoot then return end
	local ad_node = collectRoot:getChildByName("ad_node")
	local ad_btn_node = ad_node:getChildByName("btn_close_node")
	local close_btn = ad_btn_node:getChildByName("btn_close")
	local label_content = collectRoot:getChildByName("label_content")
	local label_node = collectRoot:getChildByName("label_node")
	local btn_node = collectRoot:getChildByName("btn_node")
	local ad_logo = btn_node:getChildByName("ad_logo")
	local btnPos = cc.p(0, -128)
	local labelPos = cc.p(0, 9)
	label_node:setScale(1)
	label_node:setVisible(true)
	ad_node:setVisible(false)
	label_content:setVisible(false)
	ad_logo:setVisible(false)
	if self.isBooster then
		local booster_node = label_content:getChildByName("booster_node")
		bole.updateSpriteWithFile(booster_node, "#theme122_popup_booster_text"..self.boosterItem..".png")
		labelPos = cc.p(0, 86)
		label_node:setScale(0.95)
		label_content:setVisible(true)
		btnPos = cc.p(0, -214)
	elseif self:canShowWheelAds() then
		--  添加点击事件
		local pressFunc = function (obj)
			self.data.isWheelCollect = true
			self:saveBonus()
			collectRoot.btnCollect:setTouchEnabled(false)
			dialog:clickCollectBtn()
			-- self:initMapWheelADCloseEvent()
		end
		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				obj:setTouchEnabled(false)
				obj:setBright(false)
				pressFunc(obj)
			end
		end
		close_btn:addTouchEventListener(onTouch)
		ad_node:setVisible(true)
		ad_logo:setVisible(true)
		local btnCollect = collectRoot.btnCollect
		local extrespinImage = "theme122_popup_btn_extrespin.png"
		local extrespinImage1 = "theme122_popup_btn_extrespin_0.png"
		if btnCollect then 
			btnCollect:loadTextures(extrespinImage,extrespinImage1,extrespinImage1, ccui.TextureResType.plistType)
		end
	end
	label_node:setPosition(labelPos)
	btn_node:setPosition(btnPos)
end
function BSGame:initMapWheelCollectEvent()
	self.data["end_game"] = true
	self:saveBonus()
	self.ctl:collectCoins(1)
	local a1 = cc.DelayTime:create(1.5)
	local a2 = cc.CallFunc:create(function()
		self:onBonusExit()
	end)
	local a3 = cc.Sequence:create(a1,a2)
	self:runAction(a3)
end
function BSGame:playMapWheelADCollectDialog()
	-- playWheelBonusAdCollect
	self.theme:stopAllLoopMusic()
	self.theme:playMusic(self.theme.audio_list.popup_collect_in)
	local theData = {}
	local dialog = nil
	theData.coins = self.winValue
	theData.click_event = function ()
		self.mapWheelCollectClick = true
		if self.theme then 
			if self:canShowWheelAds() then
				self:initMapWheelADCollectEvent(dialog)
			else
				self:initMapWheelCollectEvent()
			end
			self.theme:playMusic(self.theme.audio_list.btn_click)
			self.theme:playFadeToMaxVlomeMusic()
		end
	end
	local sType = fs_show_type.collect
	local csbName = "dialog_wheel"
	local dialogType = "wheel_collect"
	theData.bg = 6
	dialog = self.theme:showThemeDialog(theData, sType, csbName, dialogType)
	self:setMapWheelState(dialog.collectRoot, dialog)
end
function BSGame:initMapWheelADCollectEvent(dialog)
	bole.send_codeInfo("record", {pid = PID.ad_BigMoney_WheelCollect_click}, false)
	self.data.isWheelCollect = true
	self:saveBonus()
	local wp = cc.p(0,0)
	if dialog and dialog.collectRoot and dialog.collectRoot:getChildByName("label_node") then
		wp = bole.getWorldPos(dialog.collectRoot:getChildByName("label_node"))
	end
    local coinspos = wp
    local total_win = self.winValue or 0
	local user = User:getInstance()
	local delay = user.header:flyCoins(coinspos, user.coins, total_win)
	user:addCoins(total_win, 1)
	if dialog then
		dialog.curFrameConfig[4] = delay + 1.5
	end
	self:stopBonusBoardAnimation(self.win_aniNode)
	local a1 = cc.DelayTime:create(delay + 1.5)
	local a2 = cc.CallFunc:create(function ()
		ADSControl:getInstance():showAdDialog(self)
		ADSControl:getInstance():showAds(ADType.REWARDVIDEO,ADSource.BigMoney,3)
	end)
	local a3 = cc.Sequence:create(a1,a2)
	self:runAction(a3)
end
-- @关闭按钮, todo添加关闭按钮的点击事件
function BSGame:initMapWheelADCloseEvent()
	if self.mapWheelCollectClick then return end
	if self.theme then
		self.theme:playMusic(self.theme.audio_list.btn_click)
		self:initMapWheelCollectEvent()
	end
end
------------------------------------ mapwheel collect弹窗 end ------------------------------------

function BSGame:playWheelScene()
	local endPos = cc.p(0,10)
    local duration = 0.5
    -- 判断是否显示广告的标签
    if self:canShowWheelAdPic() and bole.isValidNode(self.wheel_ad_pic) then
    	self.wheel_ad_pic:setVisible(true)
	end
	self.dimmer1:setOpacity(0)
	self.dimmer1:setVisible(true)
	self.dimmer1:runAction(cc.FadeIn:create(duration))
	self.wheel_root:runAction(cc.MoveTo:create(duration,endPos))
	self.theme:playMusic(self.theme.audio_list.wheel_in)
end

function BSGame:showWheelScene()
	local endPos = cc.p(0,10)
    self.dimmer1:setOpacity(255)
    self.dimmer1:setVisible(true)
	self.wheel_root:setPosition(endPos)
end

function BSGame:playSpinBtnAnimation(state)
	self.btn_aniNode:removeAllChildren()
	local file = self.theme:getPic("spine/wheel/spin")
	if state == "idle" then 
		self.theme:addSpineAnimation(self.btn_aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
	elseif state == "click" then
		file = self.theme:getPic("spine/wheel/dianji")
		self.theme:addSpineAnimation(self.btn_aniNode,nil,file,cc.p(0,0),"animation")
	end
end

function BSGame:initSpinEvent()
	self.isClick = false
	-- 点击按钮
	if self:canShowWheelAdPic() and bole.isValidNode(self.wheel_ad_pic) then
    	self.wheel_ad_pic:setVisible(true)
    else
    	self.wheel_ad_pic:setVisible(false)	
    end
    
	local pressFunc = function(obj)
		self.isClick = true
		self.btn_spin:setTouchEnabled(false)
        self.btn_spin:setVisible(false)
        self.theme:playMusic(self.theme.audio_list.wheel_btn_spin)
       
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self:playSpinBtnAnimation("click")
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				 self.spinText:setColor(cc.c3b(92,92,92))
				 self:spin()		
			end)
		))			        		
	end

	local function onTouch(obj, eventType)
		if self.isClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	self.btn_spin:addTouchEventListener(onTouch)
end

function BSGame:spin()
	local function finishSpin()		
		self.theme:playMusic(self.theme.audio_list.wheel_end)
		if self.data.isWheelStop then
			self.data.isWheelStopExtra = true
		end

		self.data.isWheelStop = true
		self:saveBonus()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				local file = self.theme:getPic("spine/wheel/zhongjiang")
				self.theme:addSpineAnimation(self.win_aniNode,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
				self.theme:playMusic(self.theme.audio_list.wheel_celebration)
			end),
			cc.DelayTime:create(2.6),
			cc.CallFunc:create(function()
				-- 用户判断当前是
				if self:canShowWheelAds() then
					-- self:playWheelBonusAdCollect()
					self:playMapWheelADCollectDialog()
				else
					self:playMapWheelCollectDialog()
				end
			end)
		))		
	end

	local node = self.wheel

	local wheelData= {
			["itemCount"]           = 4, -- 上下加一个 cell 之后的个数
			["delayBeforeSpin"]     = 0.0,   --开始旋转前的时间延迟
		    ["upBounce"]     		= 0,    --开始滚动前，向上滚动距离
		    ["upBounceTime"]     	= 0,   --开始滚动前，向上滚动时间
		    ["speedUpTime"]     	= 1,   --加速时间
		    ["rotateTime"]    	 	= 3,   -- 匀速转动的时间之和
		    ["maxSpeed"]     	 	= 60*10,    --每一秒滚动的距离
		    ["downBounce"]      	= 0,  --滚动结束前，向下反弹距离  都为正数值
		    ["speedDownTime"]      	= 2, -- 4
		    ["downBounceTime"]      = 0,
			["bounceSpeed"]         = 0,
			["direction"]      		= 1,
			["endAngle"]            = self.stopAngle
		}
	self.miniWheel = BaseWheelExtend.new(self,node,nil,wheelData,finishSpin)
	self.miniWheel:start()
	self.theme:playMusic(self.theme.audio_list.wheel_spin)
end
function BSGame:showBonusCollectADClose() -- 广告失败
	
end

function BSGame:showBonusCollectADError() -- 广告失败
	if self.initMapWheelCollectEvent then 
		self:initMapWheelCollectEvent()
	end
end

function BSGame:showBonusCollectADSuccess() -- 广告成功
	-- 再次spin时
	self.isAdFinish = 1
	if bole.isValidNode(self.wheel_ad_pic) then
		self.wheel_ad_pic:setVisible(false)
	end
	self.ctl:collectCoins(3)

	local winIndex = self.data.core_data["map_wheel_spin"]["index_2"]+1
	self.winIndex  = winIndex
	self.isBooster = self.winIndex == 1 and true or false
	self.winValue  = self.data.core_data["map_wheel_spin"]["total_win_2"]
	self.stopAngle = 360-((self.winIndex-1) * 360 / #self.wheelConfigList)
	self.wheel:setRotation(0)
	if self.isBooster then
		self.theme.mapData = self.theme.mapData or {}
	    if self.theme.mapData["extra_fg"] == 0 then
	       self.theme.mapData["extra_fg"]   = self.data.core_data["map_wheel_spin"]["extra_fg_2"]
	    end
	    if self.theme.mapData["incre_pay"] == 0 then
		   self.theme.mapData["incre_pay"]  = self.data.core_data["map_wheel_spin"]["incre_pay_2"]
		end
		if  self.theme.mapData["reel_count"] == 0 then
		    self.theme.mapData["reel_count"] = self.data.core_data["map_wheel_spin"]["add_reel_2"]
		end
		if self.theme.mapData["row_count"] == 0 then
		   self.theme.mapData["row_count"]  = self.data.core_data["map_wheel_spin"]["add_row_2"]
		end
		if self.theme.mapData["stick"] == 0 then
		   self.theme.mapData["stick"]      = self.data.core_data["map_wheel_spin"]["stick_2"]
		end
		self.theme.mapData["piggy_list"] = self.data.core_data["piggy_list"]
	end
	--文字需要变化，按钮需要更新
	self.btn_spin:setTouchEnabled(true)
	self.btn_spin:setVisible(true)
	self:playSpinBtnAnimation("idle")
	self.spinText:setColor(cc.c3b(255,255,255))
	self.spinText:setVisible(true)
	self:initSpinEvent()
end

function BSGame:canShowWheelAds()
	self.isAdFinish = self.isAdFinish or 0
	if ADSControl:getInstance():canShowAds(ADType.REWARDVIDEO) and (not self.data.isWheelStopExtra) and (self.isAdFinish == 0) and (not self.isBooster) and (not self.data.isWheelCollect) then	
		return true
	end
	return false
end

function BSGame:canShowWheelAdPic()
	self.isAdFinish = self.isAdFinish or 0
	if ADSControl:getInstance():canShowAds(ADType.REWARDVIDEO) and (not self.data.isWheelStopExtra) and (self.isAdFinish == 0) and (not self.data.isWheelCollect) then	
		return true
	end
	return false
end

function BSGame:playOutOfScene()
    local endPos = cc.p(0,-830)
    local duration = 0.5
    self.dimmer1:setOpacity(255)
    self.dimmer1:setVisible(true)
	self.wheel_root:runAction(cc.MoveTo:create(duration,endPos))
	self.theme:playMusic(self.theme.audio_list.wheel_out)
	self.dimmer1:runAction(cc.FadeOut:create(0.3))
end

function BSGame:onBonusExit()
	local function respinOver( ... )
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				-- 禁掉spin按钮
	            -- self.ctl.footer:setSpinButtonState(false)

				-- 直接收集钱的操作 给用户加钱 播放动画 主要原因是因为 self.saveWin 设置的原因
				self.ctl.footer.isFreeSpin = false
				self.ctl.footer:changeLabelDescription("notFS_Win")
				self.saveWin = false
				-- 不是 在 freespin 里面进入 lockrespin 的时候 清掉 对bet的 限制
				self.ctl:removePointBet()
	            self.callback()
			end),
			cc.RemoveSelf:create()
		))
	end
	local user = User:getInstance()
	local curretCoin = user.coins
	local lineWin = self.ctl.totalWin

	local win = self.winValue
	--print("wy_bonusWin","curretCoins= ",curretCoin,"bonuswin= ",win,"lineWin= ",lineWin,"all_add= ",curretCoin + lineWin + win )
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme:setNextCollectTargetImage(self.theme.mapLevel)
			self.theme.mapPoints = 0
			self.theme:setCollectProgressImagePos(0)

			self:playOutOfScene()
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			-- 播放背景音乐
			self.theme:dealMusic_ExitBonusGame()
			local data = {}
	    	data["mapLevel"] = self.mapLevel
	    	--print("wy_newMapData2= ",tool.lua_to_json(self.theme.mapData),self.mapLevel)
	    	data["mapInfo"] = self.theme.mapData
			local theDialog = BigMoneyMapGame.new(self.theme, self.theme:getPic("csb/"), data)
	        theDialog:showMapScene(true)
		end),
		cc.DelayTime:create(6.5),
		cc.CallFunc:create(function()
			self.ctl:startRollup(win, respinOver)	
		end)
	))
	
end

-- common
-- function BSGame:showBonusBoardAnimation(node)
-- 	node:removeAllChildren()
-- 	local file = self.theme:getPic("spine/mapFree_board/spine")
-- 	self.theme:addSpineAnimation(node,2,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
-- end

function BSGame:stopBonusBoardAnimation(node)
	node:removeAllChildren()
end

-- Map free
function BSGame:enterMapFreeBonus(tryResume)
	local function playIntro( ... )
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.CallFunc:create(function( ... )
				self.theme:playMusic(self.theme.audio_list.trigger_bell)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()				
				-- self:playMapTriggerBoard()
				self:showMapFreeStartDialog()
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				--self.theme.collectProgressAniNode:removeAllChildren()
				--self.theme.collectWheelAniNode:removeAllChildren()
			end)		
		))	
	end

	local function snapIntro()
		-- self:playMapTriggerBoard()
		self:showMapFreeStartDialog()
	end
	self.theme.curScene:addToContentFooter(self)
	if tryResume then
		snapIntro()
	else
	    playIntro()
	end
end

-- mapfree 的初始弹窗
function BSGame:showMapFreeStartDialog()
	-- 直接弹窗
	-- playMapTriggerBoard
	local mapFreeIndex = {[3] = 1,[7] = 2,[12] = 3,[18] = 4}
	local index = self.mapLevel == 0 and 4 or mapFreeIndex[self.mapLevel]
	local piggy_value = self.mapInfoList["piggy_list"][index]
	local theData = {}
	local dialog = nil
	local sType = fs_show_type.start
	local csbName = "dialog_mapfree"
	local dialogType = "map_free_start"
	theData.bg = 1
	theData.count = self.boosterGetInfo[1] and 15 or 10
	if self.ctl and self.ctl.isMasterTheme and self.theme and self.theme.themeid and self.ctl:isMasterTheme(self.theme.themeid) then
	-- if ActivityCenterControl:getInstance():isMasterTheme(self.theme.themeid) then 
		theData.bg = 8
	end
	theData.click_event = function ()
		self.data.isBoard = true
	    self.data["end_game"] = true
	    self.ctl:collectCoins(1)
		self:saveBonus()
		self.theme:playMusic(self.theme.audio_list.btn_click)
		local a1 = cc.DelayTime:create(0.5)
		local a2 = cc.CallFunc:create(function ()
			self:exitMapFreeBonus()
			self.theme:playFadeToMaxVlomeMusic()
		end)
		local a3 = cc.Sequence:create(a1,a2)
		self:runAction(a3)
	end
	dialog = self.theme:showThemeDialog(theData, sType, csbName, dialogType)
	local startRoot = dialog.startRoot
	local pig_node = startRoot:getChildByName("pig_node")
	local pg_coins = pig_node:getChildByName("pg_coins")
	local booster_node = startRoot:getChildByName("booster_node")
	pg_coins:setString(FONTS.formatByCount2(piggy_value,5,true))
	self:setMapFreeStartBoardState(booster_node)
	self.theme:playMusic(self.theme.audio_list.map_start)
	-- self.theme:showMapFreeStartDialog()
end

function BSGame:setMapFreeStartBoardState(booster_node)
	if not booster_node then return end
	local count = self.boosterAllCount
	for key = 1, 5 do
		local boosterItem = booster_node:getChildByName("booster"..key)
		if boosterItem then 
			local dimmer = boosterItem:getChildByName("dimmer")
			if key > count then 
				boosterItem:setVisible(false)
			else
				boosterItem:setVisible(true)
				if not self.boosterGetInfo[key] then
					dimmer:setVisible(true)
				else
					if key == 5 then
						self.theme.isMapFreeAddPiggy = true 
					end	
					dimmer:setVisible(false)
				end
			end
		end
	end
end

function BSGame:exitMapFreeBonus()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme:playTransition()
		end),
		cc.DelayTime:create(2.67),
		cc.CallFunc:create(function()
			self.theme:setFreeSceneState()
			self.theme:setNextCollectTargetImage(self.theme.mapLevel)
			self.theme:setCollectProgressImagePos(0)
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.ctl.footer.isFreeSpin = false
			self.ctl.footer:changeLabelDescription("notFS_Win")
			self.saveWin = false
			-- 不是 在 freespin 里面进入 lockrespin 的时候 清掉 对bet的 限制
			self.ctl:removePointBet()
            self.callback()
		end),
		cc.RemoveSelf:create()
	))
end

-------------------------------MapFreeCollect相关-----------------------------------
BigMoneyMapFreeCollect = class("BigMoneyMapFreeCollect")
local MapFreeCollect = BigMoneyMapFreeCollect

function MapFreeCollect:ctor( theme, csbPath, data)
	self.theme 	   	   = theme
	self.csbPath       = csbPath
	self.data          = data
	
	self.mapLevel = self.data.mapLevel
	self.mapInfo = self.data.mapInfo
	self.free_theData = self.data.theData
	self.freeWin = self.free_theData["coins"] or 0

	if self.theme.mapPoints >= self.theme.maxMapPoints and self.mapLevel == 0 then
		self.mapLevel = self.theme.maxMapLevel
	end

	local boosterCountsList = {[3] = 2,[7] = 3,[12] = 4,[18] = 5}
	if self.mapLevel == 0 then
		self.boosterAllCount = 5
	else
	    self.boosterAllCount = boosterCountsList[self.mapLevel] or 0
	end

	self.boosterCollectList = {}
	local data = self.mapInfo
	self.boosterCollectList = self.theme:getBoosterInfo(data)
end

function MapFreeCollect:loadControls()
	
end

function MapFreeCollect:showMapFreeCollectDialog()
	-- self.theme:hideActivitysNode()
	self.theme:stopDrawAnimate()
	AudioControl:stopAudio("music")
	self.theme.ctl.theme_reels["free_reel"] = self.theme:getFreeThemeReel(1)
	self.theme.ctl.footer:setSpinButtonState(true)
	local dialog = nil
	local theData = {}
	theData.bg = 2
	theData.coins = self.freeWin
	if self.theme.gameMasterFlag and self.theme.gameMasterFlag == 1 then
		theData.bg = 4
		self.theme.ctl.freewin = self.freeWin * 2
		if self.theme.ctl.totalWin then 
			self.theme.ctl.totalWin = self.theme.ctl.totalWin * 2
			self.theme.ctl:updateFooterCoin()
		end
		theData.coins = self.freeWin * 2
	end
	local sType = fs_show_type.collect
	local csbName = "dialog_mapfree"
	local dialogType = "map_free_collect"
	theData.click_event = function ()
		self.theme:playMusic(self.theme.audio_list.btn_click)
		self.theme:playMusic(self.theme.audio_list.popup_out)
		self.theme:laterCallBack(0.5, function()
			self.theme:playFadeToMaxVlomeMusic()
			self.theme:exitMapFreeGame(self.free_theData)
		end)
	end
	dialog = self.theme:showThemeDialog(theData, sType, csbName, dialogType)
	local booster_node = dialog.collectRoot:getChildByName("booster_node")
	self:setMapFreeCollectBoardState(booster_node)
end
function MapFreeCollect:setMapFreeCollectBoardState( booster_node )
	if not booster_node then return end
	local count = self.boosterAllCount
	for key = 1, 5 do
		local boosterItem = booster_node:getChildByName("booster"..key)
		if boosterItem then 
			local dimmer = boosterItem:getChildByName("dimmer")
			if key > count then 
				boosterItem:setVisible(false)
			else
				boosterItem:setVisible(true)
				if not self.boosterCollectList[key] then
					dimmer:setVisible(true)
				else
					dimmer:setVisible(false)
				end
			end
		end
	end
end
------------------------------------Map相关-----------------------------------------
function customizedTheme:setReelSymbolsState(isShow)
	for i = 1,5 do
		for j = 1,3 do
			local cell = self.spinLayer.spins[i]:getRetCell(j)
			cell:setVisible(isShow)
		end
	end
	self.animateNode:setVisible(isShow)
end

function customizedTheme:getBoosterInfo(data)
	if not data then return end

	local table = {false,false,false,false,false}
	if data["extra_fg"] > 0 then table[1] = true end
	if data["incre_pay"] == 1 then table[2] = true end
	if data["reel_count"] == 1 then table[3] = true end
	if data["row_count"] == 1 then table[4] = true end
	if data["stick"] == 1 then table[5] = true end

	return table
end

BigMoneyMapGame = class("BigMoneyMapGame", CCSNode)
local MapGame = BigMoneyMapGame

local buildingLevel = Set({3,7,12,18})
local nextBuildingLevel = {[0] = 3,3,3,7,7,7,7,12,12,12,12,12,18,18,18,18,18,18,3}
local boosterLevelCount = {[0] = 0,1,2,0,1,2,3,0,1,2,3,4,0,1,2,3,4,5,5}
local boosterLevelCount_bonus = {[0] = 0,1,2,2,1,2,3,3,1,2,3,4,4,1,2,3,4,5,5}
local boosterCountsList = {[3] = 2,[7] = 3,[12] = 4,[18] = 5}

local userIconPosList = 
{
	[0] = cc.p(108,-18),[1] = cc.p(209,-18),[2] = cc.p(332,-18),[3] = cc.p(514,40),[4] = cc.p(683,-18),[5] = cc.p(803,-18),
	[6] = cc.p(925,-18),[7] = cc.p(1111,80),[8] = cc.p(1268,-18),[9] = cc.p(1388,-18), [10] = cc.p(1510,-18),[11] = cc.p(1631,-18),
	[12] = cc.p(1829,60),[13] = cc.p(2020,-18),[14] = cc.p(2140,-18),[15] = cc.p(2262,-18),[16] = cc.p(2383,-18),[17] = cc.p(2503,-18),[18] = cc.p(2690,80)
}

function MapGame:ctor( theme, csbPath, data)
	self.theme 	   	   = theme
	self.csbPath       = csbPath
	self.csb 		   = csbPath .. "map.csb"
	self.data          = data
	
	self.mapLevel = self.data.mapLevel
	--print("wy_MapGameData:mapLevel= ",self.mapLevel)
	self.mapInfo = self.data["mapInfo"]
	--print("wy_MapGameData",tool.lua_to_json(self.mapInfo))

	if self.theme.mapPoints >= self.theme.maxMapPoints and self.mapLevel == 0 then
		self.mapLevel = self.theme.maxMapLevel
	end
	--print("wy_MapGameData2:mapLevel= ",self.mapLevel)

	self.boosterTriggerList = {}
	local data = self.mapInfo
	self.boosterTriggerList = self.theme:getBoosterInfo(data)
	self:getPiggyValueInfo()

	CCSNode.ctor(self, self.csb)
end

function MapGame:loadControls()
	self.root     = self.node:getChildByName("root")
	--self:loadData()
	local map_node = self.root:getChildByName("map_node")
	map_node:setScrollBarEnabled(false)
	self.mapContainerNode = map_node
	self.mapNode = map_node:getChildByName("map_items")
	self.userIcon = self.mapNode:getChildByName("user_node")
	self.userIcon:setScale(1)
	self:updateIconAni()

	local bg_node = self.mapNode:getChildByName("bg_node")
	local bg1 = bg_node:getChildByName("map_bg1")
	local map_ani = bg_node:getChildByName("map_ani")
	self.startPosShadow = bg1:getChildByName("startPoint")
	self.startPosShadow:setVisible(false)
	self:setMapBgAni(map_ani)

	local boosterFile = self.theme:getPic("spine/map/tishitanban")
	local buildFile = self.theme:getPic("spine/map/dajiedian")
	self.mapItemList = {}
	local buildIndex = 1
	for i = 1,18 do
		self.mapItemList[i] = {}
		if buildingLevel[i] then			
			local node = self.mapNode:getChildByName("map_item"..i)
			local booster_table = node:getChildByName("booster_table_node")
			local boosterAniNode = booster_table:getChildByName("booster_ani")
			bole.addSpineAnimation(boosterAniNode, nil, boosterFile, cc.p(0,0), "animation"..buildIndex, nil, nil, nil, true, true)
			
			self.mapItemList[i].tableNode = booster_table
			self.mapItemList[i].tableNode:setCascadeOpacityEnabled(true)
			self.mapItemList[i].tableNode:setOpacity(255)
			self.mapItemList[i].booster = {}
			self.mapItemList[i].right = {}
			self.mapItemList[i].wrong = {}
			self.mapItemList[i].label_triggered = self.mapItemList[i].tableNode:getChildByName("label_get")
			self.mapItemList[i].label_triggered:setString(0)
			for k = 1,boosterCountsList[i] do
				self.mapItemList[i].booster[k] = self.mapItemList[i].tableNode:getChildByName("booster"..k)
				self.mapItemList[i].booster[k]:setVisible(false)
	            self.mapItemList[i].right[k] = self.mapItemList[i].tableNode:getChildByName("right"..k)
	            self.mapItemList[i].right[k]:setVisible(false)
	            self.mapItemList[i].wrong[k] = self.mapItemList[i].tableNode:getChildByName("wrong"..k)
	            self.mapItemList[i].wrong[k]:setVisible(false)
			end
			-- node:getChildByName("state0"):setVisible(false) -- 实际的图片隐藏起来
			local buildAniNode = node:getChildByName("build_ani")
			self.mapItemList[i].buildImage = buildAniNode
			local _, spine = bole.addSpineAnimation(buildAniNode, nil, buildFile, cc.p(0,0), "animation"..buildIndex.."_1", nil, nil, nil, true, true)
			buildAniNode.spineNode = spine
			buildAniNode.spineAniName = "animation"..buildIndex
			-- self.mapItemList[i].buildImage = node:getChildByName("state0")
			-- build_ani
	        self.mapItemList[i].piggyInfoNode = node:getChildByName("piggy_value_info")
	        self.mapItemList[i].piggyInfoNode:setCascadeOpacityEnabled(true)
	        self.mapItemList[i].piggyInfoNode:setOpacity(255)
	        self.mapItemList[i].label_piggyValue = self.mapItemList[i].piggyInfoNode:getChildByName("label_piggy_value")  
	        self.mapItemList[i].label_piggyValue:setString("")

			local game_master_icon = node:getChildByName("game_master")
			game_master_icon:setVisible(false)
			-- if game_master_icon and self.theme and self.theme.themeid and ActivityCenterControl:getInstance():isMasterTheme(self.theme.themeid) then
			if game_master_icon and self.theme and self.theme.themeid and self.ctl and self.ctl.isMasterTheme and self.ctl:isMasterTheme(self.theme.themeid) then
				game_master_icon:setVisible(true)
			end
			buildIndex = buildIndex + 1
	    else
	    	local node = self.mapNode:getChildByName("map_item"..i)
	    	self.mapItemList[i].stateImage = {}
	    	self.mapItemList[i].stateImage[0] = node:getChildByName("state0")
	    	self.mapItemList[i].stateImage[1] = node:getChildByName("state1")
	    	self.mapItemList[i].stateImage[1]:setVisible(false)
	    	self.mapItemList[i].aniNode = node:getChildByName("ani_node")
	    end
	end

end
function  MapGame:updateIconAni()
	if not self.userIcon.spineNode then 
		local file = self.theme:getPic("spine/map/xiaozhu")
		local _, s = bole.addSpineAnimation(self.userIcon, nil, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
		self.userIcon.spineNode = s
	else
		self.userIcon.spineNode:setAnimation(0, "animation2", false)
    	self.userIcon.spineNode:addAnimation(0, "animation", true)
	end
end
function  MapGame:setMapBgAni( aniParent )
	if not aniParent then return end
	local file = self.theme:getPic("spine/map/dituxunhuan")
	bole.addSpineAnimation(aniParent,nil, file,cc.p(-45,0),"animation",nil,nil,nil,true,true,nil)
end

function  MapGame:getPiggyValueInfo( ... )
	local data = self.mapInfo["piggy_list"]
	self.piggyValueList = {}
	self.piggyValueList[3] = data[1]
	self.piggyValueList[7] = data[2]
	self.piggyValueList[12] = data[3]
	self.piggyValueList[18] = data[4]
end

function MapGame:configMapInfo(index,isBonus)
	local next_bul_level = nextBuildingLevel[index]
	local itemTriggerCounts = 0
	--print("wy_configMapInfo_boosterTriggerList",tool.lua_to_json(self.boosterTriggerList))
	for i = 1,18 do
		if i <= index then
			if buildingLevel[i] then
				self.mapItemList[i].tableNode:setOpacity(0)
				self.mapItemList[i].piggyInfoNode:setOpacity(0)				
			    self.mapItemList[i].buildImage:setColor(cc.c3b(92, 92, 92))
			else
				self.mapItemList[i].stateImage[0]:setVisible(false)
				self.mapItemList[i].stateImage[1]:setVisible(true)
			end
		else
			if buildingLevel[i] then
				for n = 1,boosterCountsList[i] do
					self.mapItemList[i].booster[n]:setVisible(false)
					self.mapItemList[i].right[n]:setVisible(false)
					self.mapItemList[i].wrong[n]:setVisible(false)
				end
				self.mapItemList[i].tableNode:setOpacity(255)
				-- 设置显示出Table的小猪Info
				self.mapItemList[i].label_piggyValue:setString(FONTS.formatByCount2(self.piggyValueList[i],5,true))
				-- 设置Table上的状态

			    --print("wy_next_bul_level",index,next_bul_level)
				if i == next_bul_level then
				    local showBoosterCount = boosterLevelCount[index]
				    if isBonus then -- if bonus, we should display all the win
				    	showBoosterCount = boosterLevelCount_bonus[index+1]
				    end
				    self.mapItemList[i].label_triggered:setString(itemTriggerCounts)
				    if showBoosterCount > 0 then
				   	    for m = 1,showBoosterCount do
				   	  	    self.mapItemList[i].booster[m]:setVisible(true)
				   	  	    if self.boosterTriggerList[m] then
				   	  	  	   self.mapItemList[i].right[m]:setVisible(true)
				   	  	  	   itemTriggerCounts = itemTriggerCounts + 1
				   	  	  	   self.mapItemList[i].label_triggered:setString(itemTriggerCounts)
				   	  	    else
				   	  	  	   self.mapItemList[i].wrong[m]:setVisible(true)
				   	  	    end
				   	  	end
				   	end
				end
			else
				self.mapItemList[i].stateImage[0]:setVisible(true)
				self.mapItemList[i].stateImage[1]:setVisible(false)
			end
		end
	end

end

function MapGame:getContainerPosX(step_index)
	local step      = step_index or 1
	local posX_list = {0, 0, -130, -304, -423, -548, -730, -890, -1009, -1128, -1253, -1450, -1640, -1761, -1880, -2005, -2124, -2214}
	return posX_list[step]
end

function MapGame:setMapPosition(step_index)
	step_index = step_index or 1
	step_index = step_index > 0 and step_index or 1
	local posx = self:getContainerPosX(step_index)
	local container_node = self.mapContainerNode:getInnerContainer()
	local posy = container_node:getPositionY()
	container_node:setPosition(cc.p(posx,posy))
end

function MapGame:showMapForwardPosition(next_index)
	next_index = next_index or 1
	if next_index == 0 or next_index - 1 == 0 then return end
	local container_node = self.mapContainerNode:getInnerContainer()
	self:setMapPosition(next_index - 1)
	local posX = self:getContainerPosX(next_index)
	local posY = container_node:getPositionY()

	container_node:runAction(cc.MoveTo:create(0.5, cc.p(posX, posY)))
end

function MapGame:setUserIconPosition(index)
	local pos = userIconPosList[index]
	if index > 18 then
		pos = userIconPosList[18]
	elseif index <= 0 then
		pos = userIconPosList[0]
	end
	self.userIcon:setPosition(pos)
	if index == 0 then
		self.startPosShadow:setVisible(true)
	else
		self.startPosShadow:setVisible(false)
	end
end

function MapGame:showUserIconForwardPosition(next_index)
	self:updateIconAni()
	-- self.theme:laterCallBack(9/30,function( ... )
	-- 	self:parabolaToAnimation(self.userIcon,next_index,start_pos,pos,0.5)
	self.theme:playMusic(self.theme.audio_list.piggy_move)
	-- end)
end

function MapGame:parabolaMapToAnimation(obj,index,from,to,duration)
	-- local radian_config = 
	-- {
 --       [1] = {54,100},[2] = {54,60},[3] = {91,70},[7] = {93,90},[12] = {99,90},[18] = {92,90}
 --    }
 	index = index or 1
 	duration = duration or 0.5
 	if obj and bole.isValidNode(obj) then 
 		local from = from or userIconPosList[index-1]
		local to = to or userIconPosList[index]
		local jumpDisY = math.abs(to.y - from.y) * 2 
		obj:runAction(cc.JumpTo:create(duration, to, 0, jumpDisY))
 	end
	
	-- local config = radian_config[2]
	-- if index == 1 or buildingLevel[index] then
	--    config = radian_config[index]
	-- end

	-- local myBezier = function (p0, p1, p2, duration, frame)
	-- 	local t = frame / duration
	-- 	if t > 1 then t = 1 end
	-- 	local x = math.pow(1-t,2)*p0.x + 2*t*(1-t)*p1.x + math.pow(t,2)*p2.x
	-- 	local y = math.pow(1-t,2)*p0.y + 2*t*(1-t)*p1.y + math.pow(t,2)*p2.y

	-- 	return cc.p(x,y)
	-- end

	-- local cp = cc.p(from.x + config[1], from.y + config[2])
	-- local frame = 1

	-- obj:runAction(cc.Repeat:create(cc.Sequence:create(
	-- 	cc.CallFunc:create(function () 
	-- 		frame = frame or 1
	-- 		local pos = myBezier(from, cp, to, duration*60, frame)
	-- 		obj:setPosition(pos)
	-- 		frame = frame + 1
	-- 	end),
	-- 	cc.DelayTime:create(1/60)
	-- 	), duration*60))

end

function MapGame:showMapScene(isBonus)
	self.theme.isMapOpen = true
	self.theme:enableBasePanelUI(true)
	-- close blast tip window
	ActivityBController:getInstance():showBlastTips(ACTIVITY_B.BLAST, false)
	if isBonus then
		self:setMapPosition(self.mapLevel-1)
	    self:configMapInfo(self.mapLevel-1,isBonus)
		self:setUserIconPosition(self.mapLevel-1)
		self.mapContainerNode:setTouchEnabled(false)
	else
		self.mapContainerNode:setTouchEnabled(true)
		self:setMapPosition(self.mapLevel)
	    self:configMapInfo(self.mapLevel,isBonus)
	    self:setUserIconPosition(self.mapLevel)
		-- self.old_parent_panel = self.theme.mapBasePanel:getParent()
		-- self.old_Zorder_panel = self.theme.mapBasePanel:getLocalZOrder()
		-- local newParent = self.theme.ctl.curScene.nodeList["footer_header"]
		-- bole.changeParent(self.theme.mapBasePanel,newParent)

		local newParent = self.theme.collectBackNode
		self.old_parent_btnInfo = self.theme.btn_mapInfo:getParent()
		self.old_Zorder_btnInfo = self.theme.btn_mapInfo:getLocalZOrder()
		bole.changeParent(self.theme.btn_mapInfo,newParent)
		-- 暂停主题
	    --bole.pauseTheme() 
	end

	local function initBackBtn()
		-- 点击按钮
		local pressFunc = function(obj) 
	        self.theme.btn_mapInfo:setTouchEnabled(false)
	        self.theme.btn_mapInfo:setBright(false)
	    	-- 播放点击音乐
	    	self.theme:playMusic(self.theme.audio_list.btn_click)

	        self:exitMapScene(false)
		
	    end

		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				pressFunc(obj)
			end
		end

		-- 设置按钮
		self.theme.btn_mapInfo:addTouchEventListener(onTouch)
	end

    
    self.theme.baseMapLoadNode:addChild(self)
    self.theme.baseMapLoadNode:setPosition(380.5,580)
    self.theme:playMusic(self.theme.audio_list.map_open)
	self.theme.baseMapLoadNode:runAction(cc.Sequence:create(
		cc.MoveTo:create(0.3,cc.p(380.5,193)),
        cc.CallFunc:create(function()
        	self.theme:setReelSymbolsState(false)
        	if isBonus then
        		self:showIncreaseAnimation(isBonus)
        	else
	        	self.theme.btn_mapInfo:setTouchEnabled(true)
		        self.theme.btn_mapInfo:setBright(true)
		        initBackBtn()
		    end
        end)

	))
	
end

-- 先移动后播放到达大节点的特效
function MapGame:showIncreaseAnimation(isBonus)

    local function showCustomLevelAnimation()
    	local file = self.theme:getPic("spine/map/safe_box/spine")
    	local parent = self.mapItemList[self.mapLevel].aniNode
    	
    	self.mapItemList[self.mapLevel].stateImage[0]:setVisible(false)
    	self:runAction(cc.Sequence:create(
    		cc.CallFunc:create(function()
    			local _,s = self.theme:addSpineAnimation(parent,5,file,cc.p(0,0),"animation1",nil,nil,nil,true,false,nil)
    	        self.safeBoxSkeleton = s
    	        self.theme:playMusic(self.theme.audio_list.safe_box)
    		end),
    		cc.DelayTime:create(0.56),
			cc.CallFunc:create(function()
				if self.safeBoxSkeleton and bole.isValidNode(self.safeBoxSkeleton) then 
					self.safeBoxSkeleton:setAnimation(0,"animation2",true)
				end
    			self.theme:addSpineAnimation(parent,10,file,cc.p(0,0),"animation3",nil,nil,nil,false,false,nil)
    		end)
    	))
    end

	local function showBuildingLevelAnimation()
		self:runAction(cc.Sequence:create(
    		cc.CallFunc:create(function()
				-- self.mapItemList[self.mapLevel].buildImage
				local spineNode = self.mapItemList[self.mapLevel].buildImage.spineNode
				local spineAniName = self.mapItemList[self.mapLevel].buildImage.spineAniName
				bole.spChangeAnimation(spineNode, spineAniName)
				self.theme:playMusic(self.theme.audio_list.building)
    		end),
    		cc.DelayTime:create(36/30),
    		cc.CallFunc:create(function()
    			self.mapItemList[self.mapLevel].tableNode:setOpacity(255)
    			self.mapItemList[self.mapLevel].piggyInfoNode:setOpacity(255)
    			self.mapItemList[self.mapLevel].buildImage:setColor(cc.c3b(92, 92, 92))
    			self.mapItemList[self.mapLevel].tableNode:runAction(cc.FadeOut:create(0.3))
    			self.mapItemList[self.mapLevel].piggyInfoNode:runAction(cc.FadeOut:create(0.3))
    		end)
    	))
    	
    end

    local aniDelay = 0.7
    
    if buildingLevel[self.mapLevel] then
    	aniDelay = 40/30  -- 36/30
    end

    self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()   		
   			self:showUserIconForwardPosition(self.mapLevel)
		   end),
		cc.DelayTime:create(9/30),
		cc.CallFunc:create(function ()
			if self.mapLevel then 
				local start_pos = userIconPosList[self.mapLevel-1]
				local pos = userIconPosList[self.mapLevel]
				self:parabolaMapToAnimation(self.userIcon,self.mapLevel,start_pos,pos,0.5)
			end
			-- self.theme:playMusic(self.theme.audio_list.piggy_move)
		end),
   		cc.DelayTime:create(6/30),
   		cc.CallFunc:create(function( ... )
   			self.startPosShadow:setVisible(false)
   			self:showMapForwardPosition(self.mapLevel)
		   end),
		cc.DelayTime:create(20/30),
   		cc.CallFunc:create(function()   		
   			if self.mapLevel and buildingLevel[self.mapLevel] then
   				showBuildingLevelAnimation()
   			else
   				showCustomLevelAnimation()
   			end	   	
   		end),
   		-- cc.DelayTime:create(aniDelay),
   		cc.DelayTime:create(2.8 + aniDelay),
   		cc.CallFunc:create(function()
   			self:exitMapScene(isBonus)
   		end)
   	))
end


function MapGame:exitMapScene(isBonus,isForbid)
	self.theme.isMapOpen = false
	if not isBonus then
	   -- bole.changeParent(self.theme.mapBasePanel,self.old_parent_panel,self.old_Zorder_panel)
	   bole.changeParent(self.theme.btn_mapInfo,self.old_parent_btnInfo,self.old_Zorder_btnInfo)
	   self.mapContainerNode:stopAutoScroll()
       
	   -- 恢复主题
	   --bole.resumeTheme()
	end
	
	self.theme.baseMapLoadNode:setPosition(380.5,200)
	self.theme:setReelSymbolsState(true)
	self.theme.baseMapLoadNode:stopAllActions()
	self:stopAllActions()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.baseMapLoadNode:runAction(cc.MoveTo:create(0.3,cc.p(380.5,580)))	
			self.theme:playMusic(self.theme.audio_list.map_close)	       
		end),
		cc.CallFunc:create(function()
			if isForbid then
				self.theme:enableMapInfoBtn(false)
			else
        	    self.theme.btn_mapInfo:setTouchEnabled(true)
	            self.theme.btn_mapInfo:setBright(true)
	            self.theme:enableMapInfoBtn(true)
	        end
        end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			if isBonus then
				self.theme.ctl.footer:enableOtherBtns(true) -- whj 添加,控制 superFree结束之后设置的关闭加减bet和maxBet按钮,通过这个方法显示
				if buildingLevel[self.mapLevel] then
					self.theme:resetMapInfoData()
					self.theme.mapPoints = 0
					if self.mapLevel == 18 then
					   self.theme:showCollectTip(2)
					end				    
				end
			end
			self.theme.theMapDialog = nil
			self.theme:enableBasePanelUI(false)
		end),
		cc.RemoveSelf:create()
	))
end

---------------------------声音相关----------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	-- base
	self.audio_list.base_background  = "audio/base/base_bgm.mp3"
	
	self.audio_list.coinSmart_1   = "audio/base/coinSmart_stop.mp3"
	self.audio_list.jpSymbolSmart  = "audio/base/jpSymbolSmart_stop.mp3"
	
	self.audio_list.transition       = "audio/base/transition.mp3"
	self.audio_list.reel_stop        = "audio/base/reel_stop.mp3"	
	self.audio_list.anticipation 	 = "audio/base/anticipation.mp3"
	self.audio_list.anticipation_jp 	 = "audio/base/anticipation_jp.mp3"
	self.audio_list.bonus_jp_celebration_show = "audio/base/jp_dialog.mp3"
	self.audio_list.coin_fly        = "audio/base/coin_fly.mp3"
	self.audio_list.coin_collect    = "audio/base/coin_collect.mp3"
	self.audio_list.coin_collect_full = "audio/base/collect_coin_full.mp3"

	self.audio_list.unlock          = "audio/base/collect_unlock.mp3"
	self.audio_list.lock            = "audio/base/collect_lock.mp3"
	self.audio_list.btn_click   = "audio/base/click_btn.mp3"
	self.audio_list.collect_tip_show = "audio/base/tip_show.mp3"

	-- free
	--self.audio_list.free_background  = "audio/free/free_bgm.mp3"
	self.audio_list.trigger_bell = "audio/base/fg_bell.mp3"
	self.audio_list.free_intro   = "audio/free/free_intro.mp3"
	self.audio_list.piggySmart   = "audio/free/piggySmart_stop.mp3"
	self.audio_list.piggy_added  = "audio/free/free_piggy_added.mp3"
	self.audio_list.piggy_value  = "audio/free/free_piggy_value.mp3"
	self.audio_list.game_master  = "audio/free/game_master.mp3"

	-- map
	self.audio_list.map_open         = "audio/map/map_close.mp3"
	self.audio_list.map_close        = "audio/map/map_open.mp3"
	self.audio_list.piggy_move         = "audio/map/piggy_move.mp3"
	self.audio_list.safe_box         = "audio/map/box_open.mp3"
	self.audio_list.building = "audio/map/building.mp3"

	-- bonus
	self.audio_list.bonus_background    = "audio/map/wheel_bgm.mp3"
	self.audio_list.wheel_in           = "audio/map/wheel_in.mp3"
	self.audio_list.wheel_out          = "audio/map/wheel_out.mp3"
	self.audio_list.wheel_spin           = "audio/bonus/wheel_spin.mp3"
	self.audio_list.wheel_btn_spin       = "audio/bonus/wheel_click_spinbtn.mp3"	
	self.audio_list.wheel_end           = "audio/bonus/wheel_end.mp3"
	self.audio_list.wheel_celebration   = "audio/bonus/wheel_celebration.mp3"
	self.audio_list.popup_trigger_in    = "audio/bonus/wheel_popup_trigger.mp3"
	self.audio_list.popup_collect_in    = "audio/bonus/wheel_popup_collect.mp3"
	self.audio_list.popup_out           = "audio/bonus/popup_out.mp3"

	-- map_add
	self.audio_list.map_collect      = "audio/map/map_collect.mp3"
	self.audio_list.map_start        = "audio/map/map_start.mp3"
	-- self.audio_list.wheel_bgm        = "audio/map/wheel_bgm.mp3"
	-- self.audio_list.wheel_in         = "audio/map/wheel_in.mp3"
	-- self.audio_list.wheel_out        = "audio/map/wheel_out.mp3"

	self.audio_list.jp_lock   = "audio/base/jp_lock.mp3"
	self.audio_list.jp_unlock   = "audio/base/jp_unlock.mp3"

	self.audio_list.collect_tip_hide   = "audio/base/tip_out.mp3"
	self.audio_list.symbol_in = "audio/base/symbol_coin.mp3"
	

    -- rollup
	self.audio_list.rollup01		 = "audio/base/win1.mp3"
	self.audio_list.rollup01_end	 = "audio/base/win1end.mp3"
	self.audio_list.rollup02		 = "audio/base/win2.mp3"
	self.audio_list.rollup02_end	 = "audio/base/win2end.mp3"
	self.audio_list.rollup03		 = "audio/base/win3.mp3"
	self.audio_list.rollup03_end	 = "audio/base/win3end.mp3"
	self.audio_list.rollup04		 = "audio/base/win4.mp3"
	self.audio_list.rollup04_end	 = "audio/base/win4end.mp3"

end

function customizedTheme:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.collect_tip_show,	
		self.audio_list.anticipation,
		self.audio_list.coinSmart_1,
		self.audio_list.jpSymbolSmart,
        self.audio_list.piggy_added,
        self.audio_list.piggy_value,
        self.audio_list.game_master,
        self.audio_list.wheel_end,
        self.audio_list.wheel_spin,
        self.audio_list.map_open,
        self.audio_list.map_close,
		self.audio_list.transition,
		self.audio_list.free_intro,
		self.audio_list.wheel_celebration,
		self.audio_list.bonus_background,

		--
		self.audio_list.popup_trigger_in,
		self.audio_list.popup_collect_in,
		self.audio_list.map_collect,
		self.audio_list.map_start,
		self.audio_list.jp_lock,
		self.audio_list.jp_unlock,
		self.audio_list.collect_tip_hide,
		self.audio_list.symbol_in,
		self.audio_list.building,
	}
	return loadMuscList
end

-- 播放smart sound
function customizedTheme:playSmartSound(index)
	local index = 1
	local soundName = ""
	soundName = "coinSmart_"..index
	local sound = self.audio_list[soundName]
	-- self:playMusic(sound)
	self:playEffectWithInterval(sound,0.1,false)
end

function customizedTheme:dealMusic_PlayBonusLoopMusic()
	self:stopAllLoopMusic()
	-- 播放背景音乐
	self:playLoopMusic(self.audio_list.bonus_background)
end
---------------------------------断线重连相关-----------------------------------------
function customizedTheme:getFreeThemeReel(FreeType)
	--print("wy_getFreeThemeReel",FreeType)
	local freeReel = {}
	if FreeType == 1 then -- 3*6_normal
		freeReel = {
			[1] = {7,6,6,6,7,7,10,2,2,7,6,7,10,5,5,6,10,7,6,6,6,10,10,7,7,7,6,10,6,6,3,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,5,7,6,6,5,5},
			[2] = {1,1,5,5,7,2,2,2,2,6,5,7,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,6,5,5,10,6,1,7,7,10,7,6,6,5,5},
			[3] = {1,1,7,6,7,10,2,2,2,5,10,7,5,10,5,7,6,1,6,6,6,7,7,7,7,7,10,5,7,1,3,10,3,6,7,5,4,4,10,6,7,1,5,5,10,7,5,1,7,7,6,6,6,6,6,7},
			[4] = {1,1,6,10,5,2,2,2,10,6,5,6,5,5,5,6,5,1,6,6,6,5,6,7,7,7,6,6,6,1,3,3,3,5,5,7,4,4,4,6,7,1,6,5,5,5,7,1,7,7,5,6,6,6,5,5},
	        [5] = {6,5,6,10,10,2,2,2,10,6,7,6,5,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,3,10,7,7,4,4,4,7,5,6,5,5,5,6,5,10,7,7,6,7,6,6,7,7},
			[6] = {14,18,17,18,15,18,16,18,17,18}
		}
	elseif FreeType == 2 then -- 3*5
		freeReel = {
		    [1] = {7,6,6,6,7,7,10,2,2,7,6,7,10,5,5,6,10,7,6,6,6,10,10,7,7,7,6,10,6,6,3,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,5,7,6,6,5,5},
			[2] = {1,1,5,5,7,2,2,2,2,6,5,7,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,6,5,5,10,6,1,7,7,10,7,6,6,5,5},
			[3] = {1,1,7,6,7,10,2,2,2,5,10,7,5,10,5,7,6,1,6,6,6,7,7,7,7,7,10,5,7,1,3,10,3,6,7,5,4,4,10,6,7,1,5,5,10,7,5,1,7,7,6,6,6,6,6,7},
			[4] = {1,1,6,10,5,2,2,2,10,6,5,6,5,5,5,6,5,1,6,6,6,5,6,7,7,7,6,6,6,1,3,3,3,5,5,7,4,4,4,6,7,1,6,5,5,5,7,1,7,7,5,6,6,6,5,5},
	        [5] = {6,5,6,10,10,2,2,2,10,6,7,6,5,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,3,10,7,7,4,4,4,7,5,6,5,5,5,6,5,10,7,7,6,7,6,6,7,7}
	    }
	elseif FreeType == 3 then -- 3*6
		freeReel = {
		    [1] = {7,6,6,6,7,7,10,2,2,7,6,7,10,5,5,6,10,7,6,6,6,10,10,7,7,7,6,10,6,6,3,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,5,7,6,6,5,5},
	        [2] = {1,1,5,5,7,2,2,2,2,6,5,7,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,6,5,5,10,6,1,7,7,10,7,6,6,5,5},
	        [3] = {1,1,7,6,7,10,2,2,2,5,10,7,5,10,5,7,6,1,6,6,6,7,7,7,7,7,10,5,7,1,3,10,3,6,7,5,4,4,10,6,7,1,5,5,10,7,5,1,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,5,5,5,6,5,1,6,6,6,5,6,7,7,7,6,6,6,1,3,3,3,5,5,7,4,4,4,6,7,1,6,5,5,5,7,1,7,7,5,6,6,6,5,5},
	        [5] = {6,5,6,10,10,2,2,2,10,6,7,6,5,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,3,10,7,7,4,4,4,7,5,6,5,5,5,6,5,10,7,7,6,7,6,6,7,7},
	        [6] = {6,5,10,7,7,2,2,10,2,6,7,6,10,10,5,7,7,6,6,6,10,5,5,7,7,7,6,10,6,5,3,3,3,10,7,7,4,4,10,7,5,6,5,10,5,10,5,5,7,7,6,7,6,6,7,7}
	    }
	elseif FreeType == 4 then --4*6
		freeReel = {
		    [1] = {7,6,6,6,7,7,10,2,2,7,6,7,10,5,5,6,10,7,6,6,6,10,10,7,7,7,6,10,6,6,3,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,5,7,6,6,5,5},
	        [2] = {1,1,5,5,7,2,2,2,2,6,5,7,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,6,5,5,10,6,1,7,7,10,7,6,6,5,5},
	        [3] = {1,1,7,6,7,10,2,2,2,5,10,7,5,10,5,7,6,1,6,6,6,7,7,7,7,7,10,5,7,1,3,10,3,6,7,5,4,4,10,6,7,1,5,5,10,7,5,1,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,5,5,5,6,5,1,6,6,6,5,6,7,7,7,6,6,6,1,3,3,3,5,5,7,4,4,4,6,7,1,6,5,5,5,7,1,7,7,5,6,6,6,5,5},
	        [5] = {6,5,6,10,10,2,2,2,10,6,7,6,5,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,3,10,7,7,4,4,4,7,5,6,5,5,5,6,5,10,7,7,6,7,6,6,7,7},
	        [6] = {6,5,10,7,7,2,2,10,2,6,7,6,10,10,5,7,7,6,6,6,10,5,5,7,7,7,6,10,6,5,3,3,3,10,7,7,4,4,10,7,5,6,5,10,5,10,5,5,7,7,6,7,6,6,7,7}
	    }
	elseif FreeType == 5 then --4*5
		freeReel = {
		    [1] = {7,6,6,6,7,7,10,2,2,7,6,7,10,5,5,6,10,7,6,6,6,10,10,7,7,7,6,10,6,6,3,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,5,7,6,6,5,5},
	        [2] = {1,1,5,5,7,2,2,2,2,6,5,7,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,6,5,5,10,6,1,7,7,10,7,6,6,5,5},
	        [3] = {1,1,7,6,7,10,2,2,2,5,10,7,5,10,5,7,6,1,6,6,6,7,7,7,7,7,10,5,7,1,3,10,3,6,7,5,4,4,10,6,7,1,5,5,10,7,5,1,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,5,5,5,6,5,1,6,6,6,5,6,7,7,7,6,6,6,1,3,3,3,5,5,7,4,4,4,6,7,1,6,5,5,5,7,1,7,7,5,6,6,6,5,5},
	        [5] = {6,5,6,10,10,2,2,2,10,6,7,6,5,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,3,10,7,7,4,4,4,7,5,6,5,5,5,6,5,10,7,7,6,7,6,6,7,7}
	    }
	elseif FreeType == 102 then 
		freeReel = {
		    [1] = {7,6,6,6,7,10,10,2,2,7,6,10,10,5,10,6,10,7,6,6,6,10,10,10,7,7,6,10,6,6,10,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,10,7,6,10,5,5},
			[2] = {1,1,5,5,10,10,2,2,2,10,5,10,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,10,5,10,10,6,1,7,7,10,10,6,10,5,5},
	        [3] = {1,1,10,6,7,10,2,2,2,5,10,10,5,10,5,7,6,1,6,10,10,7,10,7,7,7,10,5,7,1,3,10,10,6,7,5,4,4,10,6,10,1,5,5,10,7,10,10,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,10,5,10,6,5,1,6,10,10,5,6,7,7,10,10,6,6,1,3,10,10,5,5,10,4,4,10,10,7,1,10,5,5,5,7,1,7,7,5,6,6,10,10,5},
	        [5] = {6,5,6,10,10,2,2,10,10,6,7,6,10,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,10,10,7,7,4,4,4,10,10,6,5,10,5,6,5,10,10,7,6,7,10,6,7,7}
		}
	elseif FreeType == 103 then
		freeReel = {
		    [1] = {7,6,6,6,7,10,10,2,2,7,6,10,10,5,10,6,10,7,6,6,6,10,10,10,7,7,6,10,6,6,10,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,10,7,6,10,5,5},
	        [2] = {1,1,5,5,10,10,2,2,2,10,5,10,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,10,5,10,10,6,1,7,7,10,10,6,10,5,5},
	        [3] = {1,1,10,6,7,10,2,2,2,5,10,10,5,10,5,7,6,1,6,10,10,7,10,7,7,7,10,5,7,1,3,10,10,6,7,5,4,4,10,6,10,1,5,5,10,7,10,10,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,10,5,10,6,5,1,6,10,10,5,6,7,7,10,10,6,6,1,3,10,10,5,5,10,4,4,10,10,7,1,10,5,5,5,7,1,7,7,5,6,6,10,10,5},
	        [5] = {6,5,6,10,10,2,2,10,10,6,7,6,10,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,10,10,7,7,4,4,4,10,10,6,5,10,5,6,5,10,10,7,6,7,10,6,7,7},
	        [6] = {6,5,10,7,7,10,2,10,2,6,7,10,10,10,5,7,10,6,10,6,10,5,5,10,10,7,6,10,6,5,10,10,3,10,7,7,4,4,10,7,5,10,5,10,5,10,5,10,7,7,6,7,10,10,7,7}
		}
	elseif FreeType == 104 then
		freeReel = {
		    [1] = {7,6,6,6,7,10,10,2,2,7,6,10,10,5,10,6,10,7,6,6,6,10,10,10,7,7,6,10,6,6,10,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,10,7,6,10,5,5},
	        [2] = {1,1,5,5,10,10,2,2,2,10,5,10,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,10,5,10,10,6,1,7,7,10,10,6,10,5,5},
	        [3] = {1,1,10,6,7,10,2,2,2,5,10,10,5,10,5,7,6,1,6,10,10,7,10,7,7,7,10,5,7,1,3,10,10,6,7,5,4,4,10,6,10,1,5,5,10,7,10,10,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,10,5,10,6,5,1,6,10,10,5,6,7,7,10,10,6,6,1,3,10,10,5,5,10,4,4,10,10,7,1,10,5,5,5,7,1,7,7,5,6,6,10,10,5},
	        [5] = {6,5,6,10,10,2,2,10,10,6,7,6,10,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,10,10,7,7,4,4,4,10,10,6,5,10,5,6,5,10,10,7,6,7,10,6,7,7},
	        [6] = {6,5,10,7,7,10,2,10,2,6,7,10,10,10,5,7,10,6,10,6,10,5,5,10,10,7,6,10,6,5,10,10,3,10,7,7,4,4,10,7,5,10,5,10,5,10,5,10,7,7,6,7,10,10,7,7}
		}
	elseif FreeType == 105 then 
		freeReel = {
		    [1] = {7,6,6,6,7,10,10,2,2,7,6,10,10,5,10,6,10,7,6,6,6,10,10,10,7,7,6,10,6,6,10,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,10,7,6,10,5,5},
	        [2] = {1,1,5,5,10,10,2,2,2,10,5,10,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,10,5,10,10,6,1,7,7,10,10,6,10,5,5},
	        [3] = {1,1,10,6,7,10,2,2,2,5,10,10,5,10,5,7,6,1,6,10,10,7,10,7,7,7,10,5,7,1,3,10,10,6,7,5,4,4,10,6,10,1,5,5,10,7,10,10,7,7,6,6,6,6,6,7},
	        [4] = {1,1,6,10,5,2,2,2,10,6,5,6,10,5,10,6,5,1,6,10,10,5,6,7,7,10,10,6,6,1,3,10,10,5,5,10,4,4,10,10,7,1,10,5,5,5,7,1,7,7,5,6,6,10,10,5},
	        [5] = {6,5,6,10,10,2,2,10,10,6,7,6,10,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,10,10,7,7,4,4,4,10,10,6,5,10,5,6,5,10,10,7,6,7,10,6,7,7}
		}
	end

	return freeReel

end

function customizedTheme:adjustEnterThemeRet(data)

	data.theme_reels = {
		["main_reel"] = {
			[1]={8,7,21,5,5,7,2,2,21,2,6,5,21,5,5,5,2,5,6,8,21,6,6,5,6,8,24,8,6,6,7,2,22,7,7,6,8,21,3,3,3,8,5,5,4,21,4,7,6,7,8,8,8,21,5,5,5,8,6,7,7,7,7,2,6,6,8,7},
			[2]={1,1,1,8,7,6,2,2,2,2,7,7,6,5,5,5,2,21,8,1,21,6,6,6,6,8,8,8,7,6,7,2,7,7,6,7,5,1,3,3,3,5,8,5,4,21,4,7,7,1,8,8,7,8,21,5,7,8,1,7,7,5,21,2,6,6,7,5},
			[3]={1,1,1,21,8,5,2,2,2,2,7,23,22,5,5,5,2,8,5,1,6,21,6,5,5,8,8,8,6,7,7,21,7,7,6,5,7,1,3,3,3,8,21,21,4,4,4,7,5,1,8,8,8,7,5,5,6,8,1,7,7,6,8,2,6,6,5,5},
			[4]={1,1,21,6,5,5,2,2,2,2,8,8,8,5,5,5,2,8,5,1,6,6,6,5,5,8,8,25,8,5,7,2,7,7,8,5,7,1,3,3,3,5,6,7,4,4,4,6,5,1,8,8,5,5,5,5,6,5,1,7,7,6,7,2,6,6,6,5},
			[5]={5,7,21,5,8,5,22,2,2,2,8,8,21,5,5,5,2,25,7,5,6,21,6,7,5,8,8,8,21,21,7,2,7,7,8,6,8,21,3,3,3,5,21,24,4,4,4,6,8,21,21,8,5,8,5,5,6,8,7,7,23,26,8,2,6,6,6,5},
			[6]={14,18,17,18,15,18,16,18,17,18}
		},
		["free_reel"] = {
			[1] = {7,6,6,6,7,7,10,2,2,7,6,7,10,5,5,6,10,7,6,6,6,10,10,7,7,7,6,10,6,6,3,10,3,5,7,10,4,4,10,7,7,7,10,5,10,7,7,10,7,7,5,7,6,6,5,5},
			[2] = {1,1,5,5,7,2,2,2,2,6,5,7,5,5,10,10,6,1,6,6,10,6,7,7,7,10,7,6,7,1,3,10,3,5,6,5,4,4,4,10,10,1,6,5,5,10,6,1,7,7,10,7,6,6,5,5},
			[3] = {1,1,7,6,7,10,2,2,2,5,10,7,5,10,5,7,6,1,6,6,6,7,7,7,7,7,10,5,7,1,3,10,3,6,7,5,4,4,10,6,7,1,5,5,10,7,5,1,7,7,6,6,6,6,6,7},
			[4] = {1,1,6,10,5,2,2,2,10,6,5,6,5,5,5,6,5,1,6,6,6,5,6,7,7,7,6,6,6,1,3,3,3,5,5,7,4,4,4,6,7,1,6,5,5,5,7,1,7,7,5,6,6,6,5,5},
	        [5] = {6,5,6,10,10,2,2,2,10,6,7,6,5,5,10,7,7,6,6,6,6,5,10,7,7,7,6,5,6,5,3,3,3,10,7,7,4,4,4,7,5,6,5,5,5,6,5,10,7,7,6,7,6,6,7,7},
			[6] = {14,18,17,18,15,18,16,18,17,18}
		},
	}
    
    
	if data["map_info"] then
	   	self.mapPoints = data["map_info"]["map_points"]
	    self.mapLevel = data["map_info"]["map_level"]
	    self.mapData = {}
	    self.mapData["extra_fg"]   = data["map_info"]["extra_fg"]
	    self.mapData["incre_pay"]  = data["map_info"]["incre_pay"]
	    self.mapData["reel_count"] = data["map_info"]["reel_count"]
	    self.mapData["row_count"]  = data["map_info"]["row_count"]
	    self.mapData["stick"]      = data["map_info"]["stick"]
	    self.mapData["piggy_list"] = data["map_info"]["piggy_list"]
		self.map_avg_bet = data["map_info"]["avg_bet"]
	else 
		self.mapPoints = 0
	    self.mapLevel = 0
	    self.mapData = {}
	end

	if data["free_game"] then
    	if data["free_game"]["type"] then
			if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
	    		self.freeType = data["free_game"]["type"]
	    		if self.freeType == 1 then
			    	self.showFreeSpinBoard = true
			    end
	    		self.freePiggyValue = data["free_game"]["piggy"]
	    		if self.freeType and self.freeType > 1 then
			   	   self.mapPoints = 130
			   	end
			end
    	end
    	if data["free_game"] and data["free_game"]["game_master_flag"] then
			self.gameMasterFlag = data["free_game"]["game_master_flag"] -- 0为非game master, 1为game master
		end
		-- if data["free_game"]["free_spin_total"] == data["free_game"]["free_spins"] then
        --     data["first_free_game"] = {}
        --     data["first_free_game"]["free_spins"] = data["free_game"]["free_spins"]
        --     data["first_free_game"]["free_spin_total"] = data["free_game"]["free_spin_total"]
        --     data["first_free_game"]["total_win"] = data["free_game"]["total_win"]
        --     data["first_free_game"]["bet"] = data["free_game"]["bet"]
        --     data["first_free_game"]["item_list"] = data["free_game"]["item_list"]
        --     data["free_game"] = nil
        --     self.item_list = data["first_free_game"]["item_list"]
		-- end
    end

	-- self.collectEnableBet = data["bonus_level"]
	self.tipBetList = data["bonus_level"] or {100,100,100,100,100}
	self:setTipBetListNum(data["bonus_level"])
	return data
end
function customizedTheme:setTipBetListNum(bonus_level)
	if type(self.tipBetList) ~= "table" then 
		self.tipBetList = {}
		for key = 1, 5 do
			if type(bonus_level) == "number" then
				table.insert(self.tipBetList,bonus_level)
			else 
				table.insert(self.tipBetList,100) 
			end
		end
	end
end

function customizedTheme:adjustTheme(data)
	if self.showFreeSpinBoard then
		self:changeSpinBoard(SpinBoardType.FreeSpin_normal)
	else
		self:changeSpinBoard(SpinBoardType.Normal)
	end

	if data["free_game"] then
		if data["bonus_game"] then
	       self.isMapFreeTriggerState = true
	    end
	end

	if data["free_game"] or data["bonus_game"] then 
	else 
		self:showMasterGameStartPopup()
	end
end

--断线重连
function customizedTheme:enterThemeByBonus(theBonusGameData, endCallFunc)
    -- print("wy_theBonusGameData",tool.lua_to_json(theBonusGameData))
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end


-------------------------------------- add dial
function customizedTheme:playFadeToMinVlomeMusic()
	self:dealMusic_FadeLoopMusic(2,1,0)
end
function customizedTheme:playFadeToMaxVlomeMusic()
	self:dealMusic_FadeLoopMusic(2,0,1)
end
---@param theData /info
---@param sType /1:start 2:more 3:collect
---@param index /1:free 2:jp 3:map/wheel,pick
function customizedTheme:showThemeDialog(theData, sType, csbName, dialogType)
    self:playFadeToMinVlomeMusic()
    local end_event = theData.click_event
    theData.click_event = function()
        if end_event then
            end_event()
		end
		-- self:playFadeToMaxVlomeMusic()
        if sType == fs_show_type.start or sType == fs_show_type.collect then
            -- self:playMusicByName("common_click")
        end
    end
    local config = {}
    config["csb_file"] = self:getCsbPath(csbName)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 3, nil, 2 },
        ["collect"] = { nil, 1, nil, 2 },
    }
	config.dialog_config = themeConfig.dialog_config[dialogType]
	if not self.theme then 
		self.theme = self
	end
	local theDialog = nil 
	if dialogType == "wheel_collect" then 
		theDialog = ThemeBaseDialog.new(self, config)
	else 
		theDialog = ThemeBaseDialog.new(self, config, themeConfig.dialog_config["black_common"])
	end
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData)
    elseif sType == fs_show_type.collect then
        theDialog:showCollect(theData)
    end
    return theDialog
end
function customizedTheme:getCsbPath( file_name )
    local path2 = themeConfig.csb_list[file_name]
    local path = string.format("theme_resource/theme%d/%s", self.themeResourceId, path2)
    return path
end
function customizedTheme:getSpineFile(file_name)
	local path2 = themeConfig.spine_path[file_name]
    local path = string.format("theme_resource/theme%d/spine/%s", self.themeResourceId, path2)
    return path
end


---------------- testFun ---------------------
function customizedTheme:initTouchSpinBtn()
	local boardW = 168 * 6
	local boardH = 128 * 3
	local base_pos = cc.p(160,117)
	local unitSize = 10
    local parent = self.boardRoot
	local img = "commonpics/kong.png"
	local touchSpin = function()
		self:footerCopySpinBtnEvent()
		-- if self:getCanTouchFeature() then
  --           self.ctl:toSpin()
  --       end
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn, 1)
end
function customizedTheme:getCanTouchFeature( ... )
	local isClick = false
	if self.isCanOtherFeatureClick and self.isCanFeatureClick and (not self.isMapOpen) then 
		isClick = true
	end
    return isClick
end

-- 添加clipNode的裁切
-- function customizedTheme:getScale9Sprite(parent)
-- 	local bg = ccui.Scale9Sprite:create("theme122_collect_coinProgress.png")
-- 	bg:setPosition(cc.p(0,-100))
-- 	bg:setCapInsets(cc.rect(30, 30, 660, 49)) 
-- 	bg:setContentSize(cc.size(720, 49)) 
-- 	parent:addChild(bg, 11)
-- end
-- function customizedTheme:addMaskNode()
-- 	local gameTitle = bole.createSpriteWithFile("#theme122_collect_bg.png")
-- 	local spark = bole.createSpriteWithFile("#theme122_collect_coinProgress.png")
-- 	local clippingNode = cc.ClippingNode:create(gameTitle) 
-- 	self.mainThemeScene:addChild(clippingNode, 10)
-- 	clippingNode:setAlphaThreshold(0.8)
-- 	clippingNode:addChild(gameTitle, 1)
-- 	clippingNode:addChild(spark, 2)
-- 	self:getScale9Sprite(self.mainThemeScene)
-- end

return ThemeBigMoney









