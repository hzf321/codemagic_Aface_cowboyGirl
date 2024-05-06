-- Create class
local parentClass = Theme
ThemeLuckyPuzzle2 = class("ThemeLuckyPuzzle2", parentClass)

local customizedTheme = ThemeLuckyPuzzle2

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
            [1] = 500           
		},
		["normal_symbol_list"]  = {
			1,2,3,4,5,6,7,8,9,10
		},
	},
	["theme_type"] = "payLine",
	["theme_type_config"] = {
		["pay_lines"] = {
			{1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{0,1,2,1,0},{2,1,0,1,2},{1,0,0,0,1},{1,2,2,2,1},{0,0,1,2,2},{2,2,1,0,0},{1,0,1,2,1},
			{1,2,1,0,1},{0,1,1,1,0},{2,1,1,1,2},{0,1,0,1,0},{1,2,1,2,1},{1,0,1,0,1},{2,1,2,1,2},{1,1,0,1,1},{1,1,2,1,1},{0,0,1,0,0},
			{2,2,1,2,2},{0,0,0,1,2},{2,2,2,1,0},{0,1,0,1,2},{2,1,2,1,0},{0,0,2,0,0},{2,2,0,2,2},{0,2,2,2,0},{2,0,0,0,2},{0,2,1,2,0}
	},
		["line_cnt"] = 30,
	},
	["theme_round_light_index"] = 1,
	["boardConfig"] = {
		{ -- free 1个棋盘 3*5 -1
			["reel_single"] = true, -- 每个棋盘单独一个空间，不共用一个clipnode。例如用于lockrespin
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 3,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = {  
				-- {["base_pos"] = cc.p(31.5,322.5)},
				-- {["base_pos"] = cc.p(95.5,307)},
				{["base_pos"] = cc.p(30,251)},
			},
		},
		{ -- free 2个棋盘 3*5 -2
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 3,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = {
				-- {["base_pos"] = cc.p(72,588)},
				-- {["base_pos"] = cc.p(72,216.5)},
				{["base_pos"] = cc.p(69,631.5)},
				{["base_pos"] = cc.p(69,214)},
			},
		},
		{ -- free 3个棋盘 3*5 -3
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 3,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = {
				-- {["base_pos"] = cc.p(392,1001)},
				-- {["base_pos"] = cc.p(46 ,628)},
				-- {["base_pos"] = cc.p(738,628)},
				{["base_pos"] = cc.p(390,1047.5)},
				{["base_pos"] = cc.p(44 ,630)},
				{["base_pos"] = cc.p(736.5,630)},
			},
		},
		{ -- free 4个棋盘 3*5 -4
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 3,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = {
				-- {["base_pos"] = cc.p(46 ,1001)},
				-- {["base_pos"] = cc.p(738,1001)},
				-- {["base_pos"] = cc.p(46 ,628)},
				-- {["base_pos"] = cc.p(738,628)},
				{["base_pos"] = cc.p(44 ,1050.5)},
				{["base_pos"] = cc.p(736.5,1050.5)},
				{["base_pos"] = cc.p(44 ,630)},
				{["base_pos"] = cc.p(736.5,630)},
			},
		},
		-----------------------------------------------
		{ -- free 2个棋盘 4*5 -5
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 4,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = { 
				-- {["base_pos"] = cc.p(186,756.5)},
				-- {["base_pos"] = cc.p(186,272)},
				{["base_pos"] = cc.p(184,820.5)},
				{["base_pos"] = cc.p(184,294)},
			},
		},
		{ -- free 3个棋盘 4*5 -6
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 4,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = {
				-- {["base_pos"] = cc.p(392,1035 )},
				-- {["base_pos"] = cc.p(46 ,550)},
				-- {["base_pos"] = cc.p(738,550)},
				{["base_pos"] = cc.p(390.5,1080.5)},
				{["base_pos"] = cc.p(44 ,550.5)},
				{["base_pos"] = cc.p(736,550.5)},
			},
		},
		{ -- free 4个棋盘 4*5 -7
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 4,
			["cellWidth"] = 132,
			["cellHeight"] = 112,
			["reelConfig"] = {
				-- {["base_pos"] = cc.p(46 ,1035)},
				-- {["base_pos"] = cc.p(738,1035)},
				-- {["base_pos"] = cc.p(46 ,550)},
				-- {["base_pos"] = cc.p(738,550)},
				{["base_pos"] = cc.p(42.5 ,1073)},
				{["base_pos"] = cc.p(736,1073)},
				{["base_pos"] = cc.p(42.5 ,550.5)},
				{["base_pos"] = cc.p(736,550.5)},
			},
		},
	}
    }

	self.baseBet = 5000
	self.DelayStopTime = 0
	self.UnderPressure = 1
    
	 
    local use_portrait_screen = true
	local ret = parentClass.ctor(self, themeid, use_portrait_screen)
    return ret
end

function customizedTheme:updateReelPaylineConfig(index)
	local payLine_list = 
	{
        [1] = { -- 3*5 / 30
                {1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{0,1,2,1,0},{2,1,0,1,2},{1,0,0,0,1},{1,2,2,2,1},{0,0,1,2,2},{2,2,1,0,0},{1,0,1,2,1},
				{1,2,1,0,1},{0,1,1,1,0},{2,1,1,1,2},{0,1,0,1,0},{1,2,1,2,1},{1,0,1,0,1},{2,1,2,1,2},{1,1,0,1,1},{1,1,2,1,1},{0,0,1,0,0},
				{2,2,1,2,2},{0,0,0,1,2},{2,2,2,1,0},{0,1,0,1,2},{2,1,2,1,0},{0,0,2,0,0},{2,2,0,2,2},{0,2,2,2,0},{2,0,0,0,2},{0,2,1,2,0}
             },
        [2] = { -- 4*5 / 40
                {1,1,1,1,1},{2,2,2,2,2},{0,0,0,0,0},{3,3,3,3,3},{0,1,2,1,0},{1,2,3,2,1},{2,1,0,1,2},{3,2,1,2,3},{0,1,1,1,0},{1,2,2,2,1},
				{2,3,3,3,2},{1,0,0,0,1},{2,1,1,1,2},{3,2,2,2,3},{0,0,1,0,0},{1,1,2,1,1},{2,2,3,2,2},{1,1,0,1,1},{2,2,1,2,2},{3,3,2,3,3},
				{0,1,0,1,0},{1,2,1,2,1},{2,3,2,3,2},{1,0,1,0,1},{2,1,2,1,2},{3,2,3,2,3},{1,0,1,2,1},{2,1,2,3,2},{1,2,1,0,1},{2,3,2,1,2},
				{0,0,1,2,2},{1,1,2,3,3},{2,2,1,0,0},{3,3,2,1,1},{0,0,2,0,0},{1,1,3,1,1},{2,2,0,2,2},{3,3,1,3,3},{0,0,0,1,2},{3,3,3,2,1}
             },
    }

    self.lines = payLine_list[index]
end

local G_cellHeight = 139
local delay = 0
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -40*60
local normalSpeed = -40*60
local fastSpeed = -40*60 - 300

local stopDelay = 20/60
local speedDownTime = 30/60
local downBounce = G_cellHeight*2/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 15/60
local specialAniTime = 0
local extraReelTime = 120/60
local spinMinCD = 0.5

function customizedTheme:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	local borderConfig = self.ThemeConfig["boardConfig"]

	for index = 1,#borderConfig do 
		local temp = borderConfig[index]
		if not temp then return end
		local newReelConfig = {}
		for cnt,posList in pairs(temp.reelConfig) do 
			for col=1,temp.colCnt do 
				local oneConfig = {}
				oneConfig["base_pos"] 	= cc.p((col-1)*temp["cellWidth"]+posList["base_pos"].x,posList["base_pos"].y)
		 		oneConfig["cellWidth"] 	= temp.cellWidth
				oneConfig["cellHeight"] = temp.cellHeight
				oneConfig["symbolCount"]= temp.rowCnt
				table.insert(newReelConfig,oneConfig)
			end
		end
		borderConfig[index]["reelConfig"] = newReelConfig
		borderConfig[index]["colReelCnt"] = temp.colCnt
	end
	self.boardConfigList = borderConfig
	return borderConfig
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
	
	if self.lockedReels and self.lockedReels[pCol] then
		spinAction.locked = true
	end

	return spinAction
end

function customizedTheme:getSpinColStopAction(themeInfoData, pCol, interval)
	local specialType = nil
	local checkNotifyTag = false

	local isLockTypeStop = false

	local lockCounts = 0
	for i = 1,pCol do
		if self.lockedReels[i] then
			lockCounts = lockCounts + 1
			isLockTypeStop = true
		end
	end
    
    pColNew = pCol - lockCounts
    --print("wy_getSpinColStopAction","pCol= ",pCol, "pColNew= ",pColNew)

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
	elseif isLockTypeStop then
		local temp = interval - speedUpTime - upBounceTime
		local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
		self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
		spinAction.stopDelay = timeleft+(pColNew-1)*stopDelay	
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
	bole.adaptScale(self.mainThemeScene,true)
	self.down_node = self.mainThemeScene:getChildByName("down_node")
	bole.adaptReelBoard(self.down_node)
	self.down_child = self.down_node:getChildByName("down_node")

	self.reelRoot = self.down_child:getChildByName("Node_root_node")
	self.boardRoot = self.reelRoot:getChildByName("board_root")
	self.animateNode = self.reelRoot:getChildByName("Node_animated")

	self.stickyWildNode = self.reelRoot:getChildByName("stick_wild_node")
	self.stackWildNode = self.reelRoot:getChildByName("stack_wild_node")

	self.shakyNode:addChild(self.mainThemeScene)
	self.dimmerNode = self.mainThemeScene:getChildByName("dimmer_node")
	self.dimmerNode:setVisible(false)

	self.logo_node = self.down_child:getChildByName("logo_node")

	self.free_collectNode = self.mainThemeScene:getChildByName("free_collect_node")
    self.free_collectNode:setVisible(false)

    self.freeCollectList = {}
   
	local function fontFormat1(num)
	    return FONTS.formatByCount2(num, 17, true)
	end
	self.freeCollectList["win_noDup"] = {}
    self.freeCollectList["win_noDup"].node = self.free_collectNode:getChildByName("win_node1")
    self.freeCollectList["win_noDup"].node:setVisible(false)
    self.freeCollectList["win_noDup"].label_win = self.freeCollectList["win_noDup"].node:getChildByName("label_win")
    inherit(self.freeCollectList["win_noDup"].label_win, LabelNumRoll)
    self.freeCollectList["win_noDup"].label_win:nrInit(0, 25, fontFormat1)
    self.freeCollectList["win_noDup"].btn_collect = self.freeCollectList["win_noDup"].node:getChildByName("btn_collect")
    self.freeCollectList["win_noDup"].aniNode1 = self.freeCollectList["win_noDup"].node:getChildByName("ani_node1")
    self.freeCollectList["win_noDup"].aniNode2 = self.freeCollectList["win_noDup"].node:getChildByName("ani_node2")
    
    self.freeCollectList["win_dup"] = {}
    self.freeCollectList["win_dup"].node = self.free_collectNode:getChildByName("win_node2")
    self.freeCollectList["win_dup"].node:setVisible(false)
    self.freeCollectList["win_dup"].label_freeWin = self.freeCollectList["win_dup"].node:getChildByName("label_win1")
    self.freeCollectList["win_dup"].label_dupWin = self.freeCollectList["win_dup"].node:getChildByName("label_win2")
    self.freeCollectList["win_dup"].label_allWin = self.freeCollectList["win_dup"].node:getChildByName("label_win3")
    inherit(self.freeCollectList["win_dup"].label_allWin, LabelNumRoll)
    self.freeCollectList["win_dup"].label_allWin:nrInit(0, 25, fontFormat1)
    self.freeCollectList["win_dup"].labelDupCount = self.freeCollectList["win_dup"].node:getChildByName("label_win4")
    self.freeCollectList["win_dup"].btn_collect = self.freeCollectList["win_dup"].node:getChildByName("btn_collect")
    self.freeCollectList["win_dup"].aniNode1 = self.freeCollectList["win_dup"].node:getChildByName("ani_node1")
    self.freeCollectList["win_dup"].aniNode2 = self.freeCollectList["win_dup"].node:getChildByName("ani_node2")


    self.freeCollectList["noWin"] = {}
    self.freeCollectList["noWin"].node = self.free_collectNode:getChildByName("no_win_node")
    self.freeCollectList["noWin"].node:setVisible(false)
    self.freeCollectList["noWin"].btn_back = self.freeCollectList["noWin"].node:getChildByName("btn_back")

    self.freeCounts = 0

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
end

function customizedTheme:initBoardNodes(pBoardConfigList)
	local boardRoot 	  = self.boardRoot
	local boardConfigList = pBoardConfigList or self.boardConfigList or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	-- 棋盘初始化
	for boardIndex, theConfig in ipairs(boardConfigList) do
		local theBoardNode 	= nil
		local reelNodes = {}
		
		if theConfig["reel_single"] then -- 一个棋盘用一个裁剪区域
			local colReelCnt = theConfig["colReelCnt"]
			self.clipData["reel_single"] = {}
			local reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			theBoardNode = cc.Node:create()
			boardRoot:addChild(theBoardNode)

   			local clipNode = nil
   			local reelNode = nil
   	   		for reelIndex,config in ipairs(theConfig["reelConfig"]) do
   	   			if (reelIndex-1)%colReelCnt == 0 then 
   	   				reelNode = cc.Node:create()
   	   				reelNode:setLocalZOrder(reelZorder)
   	   				
					local vex = {
						config["base_pos"], -- 第一个轴的左下角  下左边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, 0)),  -- 下右边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, config["cellHeight"]*config["symbolCount"])),-- 上右边界
						cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
					}
					if theConfig["allow_over_range"] then
						vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
						vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

						vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
						vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
					end
		   		    local stencil = cc.DrawNode:create()
		   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		   		    local clipAreaNode = cc.Node:create()
		   		    clipAreaNode:addChild(stencil)
		   		    clipNode = cc.ClippingNode:create(clipAreaNode)
		   		   
					theBoardNode:addChild(clipNode)	
					clipNode:addChild(reelNode)
   	   			end
				reelNodes[reelIndex] = reelNode
				self.clipData["reel_single"][reelIndex] = {}
				self.clipData["reel_single"][reelIndex]["vex"] = vex
				self.clipData["reel_single"][reelIndex]["stencil"] = stencil
   		    end
		end		
	
		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		pBoardNodeList[boardIndex] = theBoardNode
	end
	return pBoardNodeList
end

function customizedTheme:initSpinLayerBg()
    self:playLogoAnimation()
	Theme.initSpinLayerBg(self)
end

function customizedTheme:setBoardScene(n)
	if n<1 or n>8 then return end

    local frame_list = {0, 10, 20, 30, 40, 50, 60, 70} 
    local action = cc.CSLoader:createTimeline(self.csb)
    self.mainThemeScene:runAction(action)
    action:gotoFrameAndPause(frame_list[n])
end

function customizedTheme:playLogoAnimation()
	local file = self:getPic("spine/logo/spine")
	-- self:addSpineAnimation(self.logo_node,5,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
end

------------------------------轮带功能相关----------------------------------
-- 1-18 种 
function customizedTheme:changeSpinBoard(pType) -- 更改背景控制 已修改
	if pType == 1 then -- #set1 page 1 --reel1
		self:updateReelPaylineConfig(1)
		self:setBoardScene(1)
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1	
		self.freeCounts = 15
		self.maxRow = 3
		self.lockedReels = {false,false,false,false,false}
		self.stickyWildList =  -- 'sticky_wilds':[[[1,1],[3,0],[3,2]]]
		{
           {false,false,false},{false,true,false},{false,false,false},{true,false,true},{false,false,false}
	    }
        
	    self:showStickyWildImage(1, self.maxRow)
		
	elseif pType == 2 then -- #set1 page 2 --reel1
		self:updateReelPaylineConfig(1)
		self:setBoardScene(1)
		
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1
		self.freeCounts = 12
		self.maxRow = 3
		self.lockedReels = {false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[0,1],[3,0],[3,2]]]
		{
           {false,true,false},{false,false,false},{true,false,true},{false,true,false},{false,false,false}
	    }

	    self:showStickyWildImage(1, self.maxRow)

	elseif pType == 3 then -- #set1 page 3 --reel1
		self:updateReelPaylineConfig(1)
		self:setBoardScene(1)
		
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1
		self.freeCounts = 9
		self.maxRow = 3

        -- self.lockedReels = {false,false,true,false,false} -- 'wild_stack': [[2]]
        self.lockedReels = {false,false,false,false,false} -- 'wild_stack': [[2]]

		self:showStackWildImage(1,3)

		self.stickyWildList =  -- 'sticky_wilds': [[[0,0],[0,2],[4,0],[4,2]]]
		{
           {false,false,false},{false,true,false},{true,false,true},{false,true,false},{true,false,true}
	    }

	    self:showStickyWildImage(1, self.maxRow)

	elseif pType == 4 then -- #set1 page 4 --reel1
		self:updateReelPaylineConfig(1)
		self:setBoardScene(1)
		
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 1
		self.freeCounts = 10
		self.maxRow = 3

        -- self.lockedReels = {false,true,false,true,false} -- 'wild_stack': [[1,3]]
        self.lockedReels = {false,false,false,false,false} -- 'wild_stack': [[1,3]]

		self:showStackWildImage(1, self.maxRow)

		self.stickyWildList =  -- ' 'sticky_wilds': [] --No!!!
		{
           {false,false,true},{false,true,false},{true,false,true},{false,true,false},{false,false,true}
	    }

        self:showStickyWildImage(1, self.maxRow)

	elseif pType == 5 then -- #set2 page 1 -- reel2
		self:updateReelPaylineConfig(1)
		self:setBoardScene(2)
		
		if self.spinLayer ~= self.spinLayerList[2] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[2]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 2
		self.freeCounts = 10
		self.maxRow = 3

		self.lockedReels = {false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[1,1],[3,1]],[[1,1],[3,1]]]
                                  
		{
           {false,false,false},{false,true,false},{false,false,false},{false,true,false},{false,false,false},
           {false,false,false},{false,true,false},{false,false,false},{false,true,false},{false,false,false}
	    }

	    self:showStickyWildImage(2, self.maxRow)

	elseif pType == 6 then -- #set2 page 2 -- reel2
		self:updateReelPaylineConfig(1)
		self:setBoardScene(2)
		
		if self.spinLayer ~= self.spinLayerList[2] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[2]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 2
		self.freeCounts = 10
		self.maxRow = 3

		self.lockedReels = {false,false,false,false,false,false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[1,2],[2,0],[3,2]],[[1,2],[2,0],[3,2]]]
                                                         
		{
           {false,false,false},{false,false,true},{false,true,false},{false,false,true},{false,false,false},
           {false,false,false},{true,false,false},{false,true,false},{true,false,false},{false,false,false}
	    }

	    self:showStickyWildImage(2, self.maxRow)

	elseif pType == 7 then -- #set2 page 3 -- reel2
		self:updateReelPaylineConfig(1)
		self:setBoardScene(2)
		
		if self.spinLayer ~= self.spinLayerList[2] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[2]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 2
		self.freeCounts = 8
		self.maxRow = 3

        -- self.lockedReels = {false,false,true,false,false,false,false,true,false,false} -- 'wild_stack': [[2],[2]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false} -- 'wild_stack': [[2],[2]]

		self:showStackWildImage(2, self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': [[[0,1],[4,1]],[[0,1],[4,1]]]
                                      
		{
           {true,false,false},{false,false,false},{true,true,true},{false,false,false},{false,false,true},
           {false,false,true},{false,false,false},{true,true,true},{false,false,false},{true,false,false}
	    }

	    self:showStickyWildImage(2, self.maxRow)
      
	elseif pType == 8 then -- #set2 page 4 -- reel2
		self:updateReelPaylineConfig(2)
		self:setBoardScene(6)
		
		if self.spinLayer ~= self.spinLayerList[5] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[5]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 5
		self.freeCounts = 5
		self.maxRow = 4

        -- self.lockedReels = {true,false,true,false,false,false,false,true,false,true} -- 'wild_stack': [[0,2],[2,4]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false} -- 'wild_stack': [[0,2],[2,4]]

		self:showStackWildImage(2, self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': [[[4,0],[4,3]],[[0,0],[0,3]]]  
                                  
		{
           {false,false,false,false},{true,true,true,true},{true,false,false,true},{true,true,true,true},{false,false,false,false},
           {false,false,false,false},{true,true,true,true},{true,false,false,true},{true,true,true,true},{false,false,false,false}
	    }

	    self:showStickyWildImage(2, self.maxRow)

	elseif pType == 9 then -- #set3 page 1 --reel3
		self:updateReelPaylineConfig(1)
		self:setBoardScene(3)
		
		if self.spinLayer ~= self.spinLayerList[3] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[3]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 3
		self.freeCounts = 5
		self.maxRow = 3

		self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[1,0],[1,2],[2,1],[3,0],[3,2]],[[2,1],[3,0],[3,2]],[[1,0],[1,2],[2,0]] ]
                                      
		{
           {false,false,false},{false,true,false},{true,true,true},{false,true,false},{false,false,false},
           {false,false,false},{false,false,false},{true,true,true},{false,true,false},{false,false,false},
           {false,false,false},{false,true,false},{true,true,true},{false,false,false},{false,false,false}
	    }

	    self:showStickyWildImage(3, self.maxRow)

	elseif pType == 10 then -- #set3 page 2 --reel3
		self:updateReelPaylineConfig(1) 
		self:setBoardScene(3)
		
		if self.spinLayer ~= self.spinLayerList[3] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[3]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 3
		self.freeCounts = 6
		self.maxRow = 3

        -- self.lockedReels = {false,false,true,false,false,false,false,true,false,false,false,false,true,false,false} -- 'wild_stack': [[2],[2],[2]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false} -- 'wild_stack': [[2],[2],[2]]

		self:showStackWildImage(3, self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': [ [[0,1],[4,1]], [[4,1]], [[0,1]] ]
                                      
		{
           {false,true,false},{false,false,false},{true,true,true},{false,false,false},{false,true,false},
           {false,false,false},{false,false,false},{true,true,true},{false,false,false},{false,true,false},
           {false,true,false},{false,false,false},{true,true,true},{false,false,false},{false,false,false}
	    }

	    self:showStickyWildImage(3, self.maxRow)

	elseif pType == 11 then -- #set3 page 3 --reel3
		self:updateReelPaylineConfig(1)
		self:setBoardScene(3)
		
		if self.spinLayer ~= self.spinLayerList[3] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[3]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 3
		self.freeCounts = 6
		self.maxRow = 3

        -- self.lockedReels = {false,true,false,true,false,false,false,true,false,false,false,false,true,false,false} -- 'wild_stack': [[1,3],[2],[2]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false} -- 'wild_stack': [[1,3],[2],[2]]

		self:showStackWildImage(3, self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': []
                                      
		{
           {false,false,false},{true,true,true},{false,false,false},{true,true,true},{false,false,false},
           {false,false,false},{false,false,false},{true,true,true},{false,false,false},{true,true,true},
           {true,true,true},{false,false,false},{true,true,true},{false,false,false},{false,false,false}
	    }

        self:showStickyWildImage(3, self.maxRow)

	elseif pType == 12 then -- #set3 page 4 --reel3
		self:updateReelPaylineConfig(2)
		self:setBoardScene(7)
		
		if self.spinLayer ~= self.spinLayerList[6] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[6]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 6
		self.freeCounts = 5
		self.maxRow = 4

        -- self.lockedReels = {true,true,false,true,true,false,false,false,true,true,true,true,false,false,false} -- 'wild_stack': [[0,1,3,4],[3,4],[0,1]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false} -- 'wild_stack': [[0,1,3,4],[3,4],[0,1]]

		self:showStackWildImage(3,self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': []
                                      
		{
           {false,false,false,false},{true,true,true,true},{true,true,true,true},{true,true,true,true},{false,false,false,false},
           {true,true,true,true},{false,false,false,false},{true,true,true,true},{false,false,false,false},{true,true,true,true},
           {false,false,false,false},{true,true,true,true},{false,false,false,false},{true,true,true,true},{false,false,false,false}
	    }
            
        self:showStickyWildImage(3, self.maxRow)

    elseif pType == 13 then -- #set4 page 1 --reel4
		self:updateReelPaylineConfig(1)
		self:setBoardScene(4)
		
		if self.spinLayer ~= self.spinLayerList[4] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[4]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 4
		self.freeCounts = 5
		self.maxRow = 3

		self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[0,0],[0,2],[1,1],[2,1],[3,1],[4,0],[4,2]],[[0,0],[0,2],[1,1],[2,1],[3,1],[4,0],[4,2]], [[0,0],[0,2],[1,1],[2,1],[3,1],[4,0],[4,2]],[[0,0],[0,2],[1,1],[2,1],[3,1],[4,0],[4,2]],]
                                      
		{
           {true,false,true},{false,true,false},{false,true,false},{false,true,false},{true,false,true},
           {true,false,true},{false,true,false},{false,true,false},{false,true,false},{true,false,true},
           {true,false,true},{false,true,false},{false,true,false},{false,true,false},{true,false,true},
           {true,false,true},{false,true,false},{false,true,false},{false,true,false},{true,false,true}
	    }

	    self:showStickyWildImage(4, self.maxRow)

	elseif pType == 14 then -- #set4 page 2 --reel4
		self:updateReelPaylineConfig(1)
		self:setBoardScene(4)
		
		if self.spinLayer ~= self.spinLayerList[4] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[4]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 4
		self.freeCounts = 5
		self.maxRow = 3

		self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[1,0],[1,2],[2,1],[3,0],[3,2]],  [[1,0],[1,2],[2,1],[3,0],[3,2]],  [[1,0],[1,2],[2,1],[3,0],[3,2]],  [[1,0],[1,2],[2,1],[3,0],[3,2]],]
                                      
		{
            {false,false,false},{false,true,false},{true,false,true},{false,true,false},{true,false,true},
            {false,false,false},{false,true,false},{true,false,true},{false,true,false},{true,false,true},
            {false,false,false},{false,true,false},{true,false,true},{false,true,false},{true,false,true},
            {false,false,false},{false,true,false},{true,false,true},{false,true,false},{true,false,true}
	    }

	    self:showStickyWildImage(4, self.maxRow)

	elseif pType == 15 then -- #set4 page 3 --reel4
		self:updateReelPaylineConfig(1)
		self:setBoardScene(4)
		
		if self.spinLayer ~= self.spinLayerList[4] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[4]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 4
		self.freeCounts = 6
		self.maxRow = 3

        -- self.lockedReels = {true,false,false,false,true,true,false,false,false,true,true,false,false,false,true,true,false,false,false,true} --'wild_stack': [[0,4],[0,4],[0,4],[0,4]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false} --'wild_stack': [[0,4],[0,4],[0,4],[0,4]]

		self:showStackWildImage(4,self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': [[[2,1]], [[2,1]], [[2,1]], [[2,1]],]
                           
		{
            {false,true,false},{false,false,false},{true,true,true},{false,false,false},{true,true,true},
            {false,true,false},{false,false,false},{true,true,true},{false,false,false},{true,true,true},
            {false,true,false},{false,false,false},{true,true,true},{false,false,false},{true,true,true},
            {false,true,false},{false,false,false},{true,true,true},{false,false,false},{true,true,true}
	    }

	    self:showStickyWildImage(4, self.maxRow)
            

	elseif pType == 16 then -- #set4 page 4  --reel4
		self:updateReelPaylineConfig(1)
		self:setBoardScene(4)
		
		if self.spinLayer ~= self.spinLayerList[4] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[4]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 4
		self.freeCounts = 5
		self.maxRow = 3

        -- self.lockedReels = {true,false,true,false,true,true,false,true,false,true,true,false,true,false,true,true,false,true,false,true} --'wild_stack': [[0,2,4],[0,2,4],[0,2,4],[0,2,4]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false} --'wild_stack': [[0,2,4],[0,2,4],[0,2,4],[0,2,4]]

		self:showStackWildImage(4, self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': []
                                      
		{
            {false,false,false},{false,false,false},{true,true,true},{true,true,true},{true,true,true},
            {false,false,false},{false,false,false},{true,true,true},{true,true,true},{true,true,true},
            {false,false,false},{false,false,false},{true,true,true},{true,true,true},{true,true,true},
            {false,false,false},{false,false,false},{true,true,true},{true,true,true},{true,true,true}
	    }

        self:showStickyWildImage(4, self.maxRow)

	elseif pType == 17 then -- #set5 page 1 --reel4
		self:updateReelPaylineConfig(2)
		self:setBoardScene(8)
		
		if self.spinLayer ~= self.spinLayerList[7] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[7]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 7
		self.freeCounts = 5
		self.maxRow = 4

		self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}

		self.stickyWildList =  -- 'sticky_wilds': [[[0,1],[0,3],[1,0],[1,2],[2,1],[2,3],[3,0],[3,2],[4,1],[4,3]], [[0,1],[0,3],[1,0],[1,2],[2,1],[2,3],[3,0],[3,2],[4,1],[4,3]], [[0,0],[0,2],[1,1],[1,3],[2,0],[2,2],[3,1],[3,3],[4,0],[4,2]], [[0,0],[0,2],[1,1],[1,3],[2,0],[2,2],[3,1],[3,3],[4,0],[4,2]],]
                                 
		{
            {true,false,true,false},{false,true,false,true},{true,false,true,false},{false,true,false,true},{true,false,true,false},
            {true,false,true,false},{false,true,false,true},{true,false,true,false},{false,true,false,true},{true,false,true,false},
            {false,true,false,true},{true,false,true,false},{false,true,false,true},{true,false,true,false},{false,true,false,true},
            {false,true,false,true},{true,false,true,false},{false,true,false,true},{true,false,true,false},{false,true,false,true}
	    }

	    self:showStickyWildImage(4, self.maxRow)

	elseif pType == 18 then -- #set5 page 2 --reel4
		self:updateReelPaylineConfig(2)
		self:setBoardScene(8)
		
		if self.spinLayer ~= self.spinLayerList[7] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[7]
			self.spinLayer:Active()
		end

		self.initBoardIndex = 7
		self.freeCounts = 5
		self.maxRow = 4

		-- self.lockedReels = {false,true,true,true,true,false,true,true,true,true,false,true,true,true,true,false,true,true,true,true} --'wild_stack': [[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]
        self.lockedReels = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false} --'wild_stack': [[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]
		self:showStackWildImage(4, self.maxRow)

		self.stickyWildList =  -- 'sticky_wilds': []
                                      
		{
           {true,true,true,true},{true,true,true,true},{false,false,false,false},{true,true,true,true},{true,true,true,true},
           {true,true,true,true},{true,true,true,true},{false,false,false,false},{true,true,true,true},{true,true,true,true},
           {true,true,true,true},{true,true,true,true},{false,false,false,false},{true,true,true,true},{true,true,true,true},
           {true,true,true,true},{true,true,true,true},{false,false,false,false},{true,true,true,true},{true,true,true,true}
	    }
    
        self:showStickyWildImage(4, self.maxRow)

	end
end

function customizedTheme:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function customizedTheme:updateCellSprite(theCellNode, key, col, isShowResult,isReset)

	local theCellFile = self.pics[key]

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

function customizedTheme:onSpinStop(ret)	
    --print("wy_reelStop_data",tool.lua_to_json(ret))
    self:adjustWinRetData(ret)
	if ret.free_spins and (not self.ctl.freewin) then
		if ret.free_game then
		   self.freeType = ret.free_game["page"] + 1
		   print("wy_freeType", self.freeType)
		end
	end
	Theme.onSpinStop(self, ret)
end

function customizedTheme:onReelFallBottom( pCol )

end
function customizedTheme:onReelFastFallBottom( pCol )
	
end

function customizedTheme:adjustWinRetData(ret)
    if not ret["win_pos_list"] or not ret["win_lines"] then return end 
    local old_pos_list = ret["win_pos_list"]
    local old_lines_list = ret["win_lines"]

    local new_pos_list = {}
    for i = 1,#old_pos_list do
   	    for k ,v in ipairs(old_pos_list[i]) do
   	   	   table.insert(new_pos_list, {v[1] + (i-1)*5, v[2]})
   	   	end
   	end
    ret["win_pos_list"] = new_pos_list

    local new_lines_list = {}
    for i = 1,#old_lines_list do
    	for k,v in ipairs(old_lines_list[i]) do
    		v.col_ck = (i-1)*5
    		table.insert(new_lines_list,v)
    	end
    end
    ret["win_lines"] = new_lines_list
end
------------------------------Symbol动画相关--------------------------------

function customizedTheme:playCellRoundEffect(parent, ...)
	--parent:setScale(0.9,0.9)
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function customizedTheme:drawLinesThemeAnimate( lines, layer, rets, specials)
	-- print("wy_drawLinesThemeAnimate lines, rets, specials ",tool.lua_to_json(lines),tool.lua_to_json(rets), tool.lua_to_json(specials))
	self.stackSymbolsAniList = {}
	self.symbolsSkeleton = {}
	local timeList = {2,2}
	Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)	
end

-- 设置symbol动画
function customizedTheme:getItemAnimate(item, col, row, effectStatus,parent)
	if item == 1 then
		if self.stickyWildList[col][row] then
		   item = 11
		elseif self.lockedReels[col] then
		   item = 12
		end
	else
		if self.stickyWildList[col][row] then
		   item = 11
		end	
	end

	local spineSymbolSet = Set({1,2,3,4,5,6,7,8,9,10,11})
	local stackwildSymbolSet = Set({12})
	if spineSymbolSet[item] then
		-- 播放symbol动画
		return self:playItemAnimation(item, col, row, effectStatus, parent)
    elseif stackwildSymbolSet[item] then
    	return self:playStackedWildAnimation(col,row,effectStatus,parent)
	end
end

-- function customizedTheme:getItemAnimate_4(item)
-- 	local animate = cc.Sequence:create(
-- 		-- cc.DelayTime:create(7/60),
-- 		cc.FadeTo:create(0.01, 0),
-- 		cc.DelayTime:create(0.5), 
-- 		cc.FadeTo:create(0.01, 255),
-- 		cc.DelayTime:create(0.5))
-- 	return animate
-- end

-- function customizedTheme:getSingleItemAnimate(item)
-- 	local animate = cc.Sequence:create(
-- 		-- cc.DelayTime:create(7/60),
-- 		cc.FadeTo:create(0.01, 0),
-- 		cc.DelayTime:create(0.5), 
-- 		cc.FadeTo:create(0.01, 255),
-- 		cc.DelayTime:create(0.5))
-- 	return animate
-- end

-- 播放symbol spine动画
function customizedTheme:playItemAnimation( item, col, row, effectStatus, parent)
	local animationNameConfig = 
	{
		["1"]  = {"spine/symbols/sticky_wild2/spine", "animation", 1},
		["2"]  = {"spine/symbols/2/spine", "animation", 1},
		["3"]  = {"spine/symbols/3/spine", "animation", 1},
		["4"]  = {"spine/symbols/4/spine", "animation", 1},
		["5"]  = {"spine/symbols/5/spine", "animation", 1},
		["6"]  = {"spine/symbols/6/spine", "animation", 1},
		["7"]  = {"spine/symbols/7/spine", "animation", 1},
		["8"]  = {"spine/symbols/8/spine", "animation", 1},
		["9"]  = {"spine/symbols/9/spine", "animation", 1},
		["10"]  = {"spine/symbols/10/spine", "animation", 1},
		["11"] = {"spine/symbols/sticky_wild1/spine", "animation", 1},
	}

	local isFirst = false
	if effectStatus and effectStatus == "all_first" then
		isFirst = true
	else
		isFirst = false
	end	

	if item >= 6 and item <= 10 then return end
	local index = tostring(item)
	if animationNameConfig[index] then
		local spineName   = animationNameConfig[index][1]
		local animateName = animationNameConfig[index][2]
		local theScale    = animationNameConfig[index][3]

		self:playSymbol(parent, spineName, col, row, animateName, theScale,false,isFirst)
	end
end

-- 播放symbol的动画，包括中奖和挑逗
-- col是spinLayer里的col, 1-20
function customizedTheme:playSymbol(parent, spineName, col, row, animateName, theScale, loop ,isFirst)	
	local cell 	      = self.spinLayer.spins[col]:getRetCell(row)	
	local pos 		  = self.spinLayer:getCellPos(col, row)
	local spineFile   = self:getPic(spineName)
	   
    if isFirst and not self.symbolsSkeleton[col.."_"..row] then
    	local _, s1   =self:addSpineAnimation(parent, nil, spineFile, pos, animateName, callback, nil, nil,true,false, nil)
    	s1:setScale(theScale)
    	self.symbolsSkeleton[col.."_"..row] = s1
    else
    	if self.symbolsSkeleton[col.."_"..row] then
    		self.symbolsSkeleton[col.."_"..row]:setAnimation(0,animateName,false)
    	end
    end	
	cell:setVisible(false)
end

function customizedTheme:playStackedWildAnimation(col,row,effectStatus,parent)
	local pos = self:getCellPos(col,2)
	local aniName = "animation2"
	if self.maxRow == 4 then
       pos =cc.pAdd(pos,cc.p(0,-56))
       aniName = "animation1"
    end

    local file = self:getPic("spine/symbols/stack_wild/spine")

  	local isFirst = false
	if effectStatus and effectStatus == "all_first" then
		isFirst = true
	else
		isFirst = false
	end	
    
	if isFirst and not self.stackSymbolsAniList[col] then
		self:addSpineAnimation(parent,nil,file,pos,aniName,nil,nil,nil,true,true,nil)
		self.stackSymbolsAniList[col] = true

	end
end

function customizedTheme:stopDrawAnimate()
	self.stackSymbolsAniList = {}
	self.symbolsSkeleton = {}
	Theme.stopDrawAnimate(self)
end

function customizedTheme:showStickyWildImage(maxReel, maxRow) -- maxReel 棋盘个数  maxRow 每个棋盘的行数
    if not self.stickyWildList then return end
	local theSpriteFile = "#theme2005_symbol_sticky_wild.png"
	maxCol = maxReel * 5
	self.stickyWildImageList = {}
	for i = 1,maxCol do
		for j = 1,maxRow do
            if self.stickyWildList[i][j] then -- wild 的位置
				local pos = self:getCellPos(i, j)
				local sprite = bole.createSpriteWithFile(theSpriteFile)
				sprite:setPosition(pos)
				self.stickyWildNode:addChild(sprite)
				self.stickyWildImageList[i.."_"..j] = sprite
			end
		end
	end
end

function customizedTheme:showStackWildImage(maxReel,maxRow)
	-- if not self.lockedReels then return end
	-- local theSpriteFile = "#theme2005_symbol_wild_stack2.png"
	-- if maxRow == 4 then
	-- 	theSpriteFile = "#theme2005_symbol_wild_stack1.png"
	-- end
    -- maxCol = maxReel * 5
    -- self.stackWildImageList = {}
    -- for i = 1,maxCol do
    -- 	if self.lockedReels[i] then
    -- 		local pos = self:getCellPos(i,2)
    -- 		if maxRow == 4 then
    -- 			pos =cc.pAdd(pos,cc.p(0,-56))   		
    -- 		end

	-- 		local sprite = bole.createSpriteWithFile(theSpriteFile)
	-- 		sprite:setPosition(pos)
	-- 		self.stackWildNode:addChild(sprite)
	-- 		self.stackWildImageList[i] = sprite
	-- 	end
	-- end	
end

------------------------------Free功能相关----------------------------------

function customizedTheme:enterFreeSpin()
	self.ctl.footer:changeFreeSpinLayout3()
	parentClass.enterFreeSpin(self)
end

function customizedTheme:playStartFreeSpinDialog(theData)
	if theData.enter_event then
		theData.enter_event()
	end
	if theData.click_event then
		theData.click_event()
	end
	if theData.end_event then
		theData.end_event()
	end
	self:resetFreeAssetsData()
	self.freeType = self.freeType or 1
	self:changeSpinBoard(self.freeType)	
end

function customizedTheme:playCollectFreeSpinDialog( theData )
	self.ctl.footer:setSpinButtonState(true)	
	local freeWin = theData["coins"]
	self.btn_freeCollect,self.label_freeWin,self.freeWin = self:chooseFreeCollectBoard(freeWin)

	self.free_collectNode:setScale(0)
	self.free_collectNode:setVisible(true)

	self.dimmerNode:setOpacity(0)
	self.dimmerNode:setVisible(true)

	--self:showFreeBoardAnimation(self.free_CollectAniNode)
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function( ... )
			if theData.enter_event then
				theData.enter_event()
			end
			AudioControl:stopAudio("music")
			self.free_collectNode:runAction(cc.Sequence:create(
	   	    	cc.ScaleTo:create(0.2,1.5,1.5),
	   	    	cc.ScaleTo:create(0.1,1,1)
	   	    ))
	        self.dimmerNode:runAction(cc.FadeIn:create(0.3))
	        self:playMusic(self.audio_list.free_collect)
	        self:stopMusic(self.audio_list.roll_num)
	        self:playMusic(self.audio_list.roll_num,true)
	        --self:showBoardAnimation()
	        if self.freeWin > 0 then
		        local rollupDuration = 3
		        self.label_freeWin:nrStartRoll(0,self.freeWin,rollupDuration)
		    end
	        
	end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function()
			if self.freeWin > 0 then
		        self.label_freeWin:setString(FONTS.formatByCount2(freeWin,10,true))	
		    end
		    self.btn_freeCollect:setTouchEnabled(true)
		    self:initFreeCollectEvent(theData)	
	end)
	))
end

function customizedTheme:chooseFreeCollectBoard(freeWin)	
	local btn = nil
	local label = nil
	local all_win = freeWin

    if self.storeDupCount and self.storeDupCount > 0 then
    	self.freeCollectList["win_dup"].node:setVisible(true)
	    all_win = all_win + self.storeDupWin
	    btn = self.freeCollectList["win_dup"].btn_collect
	    btn:setBright(true)
	    label = self.freeCollectList["win_dup"].label_allWin
	    self.freeCollectList["win_dup"].label_freeWin:setString(FONTS.formatByCount2(freeWin,13,true))
		self.freeCollectList["win_dup"].label_dupWin:setString(FONTS.formatByCount2(self.storeDupWin,13,true))
		if self.storeDupCount then
	    	self.freeCollectList["win_dup"].labelDupCount:setString(FONTS.formatByCount2(self.storeDupCount,3, true))
	    end
	    self:showFreeBoardAnimation(self.freeCollectList["win_dup"].aniNode1,self.freeCollectList["win_dup"].aniNode2)
	else
		if freeWin and freeWin > 0 then
		   self.freeCollectList["win_noDup"].node:setVisible(true)
		   label = self.freeCollectList["win_noDup"].label_win
		   btn = self.freeCollectList["win_noDup"].btn_collect
		   btn:setBright(true)
		   self:showFreeBoardAnimation(self.freeCollectList["win_noDup"].aniNode1,self.freeCollectList["win_noDup"].aniNode2)
		else
		    self.freeCollectList["noWin"].node:setVisible(true)
	        btn = self.freeCollectList["noWin"].btn_back
	        btn:setBright(true)
		end
	end
    
    return btn,label,all_win

end

function customizedTheme:showFreeBoardAnimation(node1,node2)
	local pFile = self:getPic("spine/title/spine")
	self:addSpineAnimation(node1,nil,pFile,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)

	local file = self:getPic("spine/win_frame/spine")
	self:addSpineAnimation(node2,nil,file,cc.p(0,0),"animation",nil,nil,nil,true,true,nil)

	-- local pFile = self:getPic("particle/zilizi_01_1.plist")
	-- local pPos = cc.p(0,0)
	-- local lizi = cc.ParticleSystemQuad:create(pFile)
	-- lizi:setPosition(pPos)
	-- node1:addChild(lizi,10)
end

function customizedTheme:removeAllBoardAnimation()
	self.freeCollectList["win_dup"].aniNode1:removeAllChildren()
	self.freeCollectList["win_dup"].aniNode2:removeAllChildren()
	self.freeCollectList["win_noDup"].aniNode1:removeAllChildren()
	self.freeCollectList["win_noDup"].aniNode2:removeAllChildren()
end

function customizedTheme:initFreeCollectEvent(theData)
	self.isFreeCollectPress = false
	-- 点击按钮
	local pressFunc = function(obj)
		self.isFreeCollectPress = true
		self.btn_freeCollect:setBright(false)
        self.btn_freeCollect:setTouchEnabled(false)
        self:playMusic(self.audio_list.btn_click)
        if self.freeWin > 0 then
	        self.label_freeWin:nrStopRoll()
	        self.label_freeWin:setString(FONTS.formatByCount2(self.freeWin, 17, true))
	        self:stopMusic(self.audio_list.roll_num)
	    end
        
        self:freeExit(theData)
	end

	local function onTouch(obj, eventType)
		if self.isFreeCollectPress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
			if theData.click_event then
		       theData.click_event()
	        end
		end
	end

	-- 设置按钮
	self.btn_freeCollect:addTouchEventListener(onTouch)
end

-- function customizedTheme:initFreeBackEvent(theData)
-- 	self.isFreeBackPress = false
-- 	-- 点击按钮
-- 	local pressFunc = function(obj)
-- 		self.isFreeBackPress = true
-- 		self.btn_back:setBright(false)
--         self.btn_back:setTouchEnabled(false)
--         self:freeExit(theData)
-- 	end

-- 	local function onTouch(obj, eventType)
-- 		if self.isFreeBackPress then return nil end
-- 		if eventType == ccui.TouchEventType.ended then
-- 			pressFunc(obj)
-- 			if theData.click_event then
-- 		       theData.click_event()
-- 	        end
-- 		end
-- 	end

-- 	-- 设置按钮
-- 	self.btn_back:addTouchEventListener(onTouch)
-- end

function customizedTheme:freeExit(theData)
	self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				
		    	self.free_collectNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1,1.5,1.5),
					cc.ScaleTo:create(0.2,0,0)
				))
				self:playMusic(self.audio_list.popup_out)
				self.dimmerNode:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				--self:stopFreeBoardAnimation(self.free_CollectAniNode)
				self.free_collectNode:setVisible(false)
				self.dimmerNode:setVisible(false)
				self:removeAllBoardAnimation()
				if theData.end_event then	    
					theData.end_event()
				end
				self:resetFreeAssetsData()
				self:exitStoreFreeGames()
			end)
		))		
end

function customizedTheme:resetFreeAssetsData()
	self.stickyWildNode:removeAllChildren()
	self.stickyWildList = {}

	self.stackWildNode:removeAllChildren()
	self.lockedReels = {}

end


function customizedTheme:showFreeCollectBoardOnRecover(data)
	local freeCount     = {15,12,9,10,10,10,8,5,5,6,6,5,5,5,6,5,5,5}
	local recover_data = {}
	recover_data["coins"] = data["total_win"]
	self:playCollectFreeSpinDialog(recover_data)
	local all_count = freeCount[self.freeType] or 0
	self:showFreeSpinNode(0,all_count)
	self.ctl.footer:changeFreeSpinLayout3()
	-- 收钱协议 后端
	self.ctl:collectCoins(0)
end

function customizedTheme:exitStoreFreeGames( ... )
	local header = User:getInstance().header
	if header and header.themeCtl then
		-- exit game
		LobbyThemeControl:getInstance():setEnterThemeData(10009)
		--header:toLobbyScene()
		LobbyThemeControl:getInstance():enter_theme()
	end
end

---------------------------------断线重连相关-----------------------------------------

function customizedTheme:adjustEnterThemeRet(data)

	data["theme_reels"] = {

		["free_reel"] = {
			[1] =  {1,1,8,6,2,2,9,8,3,3,10,8,4,4,8,10,5,5,8,8,10,9,1,1,1,9,9,2,9,3,7,2,6,4,8,5,9,3,7,4,9,5,7,6,10,3,3,3,8,10,9,10,4,4,4,8,6,1,7,8,2,2,2,10,6,8,9,5,5,5,6,8,9,8},
    		[2] =  {1,1,10,8,2,2,6,10,3,3,6,7,4,4,10,9,5,5,10,10,7,6,1,1,1,9,10,2,8,3,6,2,6,4,10,5,10,3,6,4,9,5,7,9,10,3,3,3,8,9,7,8,4,4,4,8,6,1,8,6,2,2,2,9,6,9,7,5,5,5,6,9,10,6},
    		[3] =  {1,1,10,9,2,2,9,10,3,3,10,10,4,4,10,8,5,5,9,7,8,8,1,1,1,8,6,2,7,3,7,2,6,4,7,5,6,3,10,4,9,5,6,9,10,3,3,3,8,7,6,9,4,4,4,6,6,1,9,6,2,2,2,9,6,9,7,5,5,5,8,9,6,6},
    		[4] =  {1,1,9,6,2,2,9,7,3,3,7,8,4,4,7,9,5,5,8,6,8,9,1,1,1,7,10,2,6,3,10,2,7,4,7,5,8,3,9,4,7,5,6,7,9,3,3,3,7,7,10,6,4,4,4,10,7,1,10,6,2,2,2,6,6,8,8,5,5,5,10,10,10,9},
    		[5] =  {1,1,8,7,2,2,6,6,3,3,6,9,4,4,6,9,5,5,9,6,10,10,1,1,1,10,7,2,9,3,8,2,9,4,8,5,9,3,8,4,8,5,6,7,6,3,3,3,7,10,8,9,4,4,4,9,8,1,7,8,2,2,2,9,9,10,9,5,5,5,6,6,10,10},
    		[6] =  {1,1,8,6,2,2,9,8,3,3,10,8,4,4,8,10,5,5,8,8,10,9,1,1,1,9,9,2,9,3,7,2,6,4,8,5,9,3,7,4,9,5,7,6,10,3,3,3,8,10,9,10,4,4,4,8,6,1,7,8,2,2,2,10,6,8,9,5,5,5,6,8,9,8},
    		[7] =  {1,1,10,8,2,2,6,10,3,3,6,7,4,4,10,9,5,5,10,10,7,6,1,1,1,9,10,2,8,3,6,2,6,4,10,5,10,3,6,4,9,5,7,9,10,3,3,3,8,9,7,8,4,4,4,8,6,1,8,6,2,2,2,9,6,9,7,5,5,5,6,9,10,6},
    		[8] =  {1,1,10,9,2,2,9,10,3,3,10,10,4,4,10,8,5,5,9,7,8,8,1,1,1,8,6,2,7,3,7,2,6,4,7,5,6,3,10,4,9,5,6,9,10,3,3,3,8,7,6,9,4,4,4,6,6,1,9,6,2,2,2,9,6,9,7,5,5,5,8,9,6,6},
    		[9] =  {1,1,9,6,2,2,9,7,3,3,7,8,4,4,7,9,5,5,8,6,8,9,1,1,1,7,10,2,6,3,10,2,7,4,7,5,8,3,9,4,7,5,6,7,9,3,3,3,7,7,10,6,4,4,4,10,7,1,10,6,2,2,2,6,6,8,8,5,5,5,10,10,10,9},
    		[10] = {1,1,8,7,2,2,6,6,3,3,6,9,4,4,6,9,5,5,9,6,10,10,1,1,1,10,7,2,9,3,8,2,9,4,8,5,9,3,8,4,8,5,6,7,6,3,3,3,7,10,8,9,4,4,4,9,8,1,7,8,2,2,2,9,9,10,9,5,5,5,6,6,10,10},
    		[11] = {1,1,8,6,2,2,9,8,3,3,10,8,4,4,8,10,5,5,8,8,10,9,1,1,1,9,9,2,9,3,7,2,6,4,8,5,9,3,7,4,9,5,7,6,10,3,3,3,8,10,9,10,4,4,4,8,6,1,7,8,2,2,2,10,6,8,9,5,5,5,6,8,9,8},
    		[12] = {1,1,10,8,2,2,6,10,3,3,6,7,4,4,10,9,5,5,10,10,7,6,1,1,1,9,10,2,8,3,6,2,6,4,10,5,10,3,6,4,9,5,7,9,10,3,3,3,8,9,7,8,4,4,4,8,6,1,8,6,2,2,2,9,6,9,7,5,5,5,6,9,10,6},
    		[13] = {1,1,10,9,2,2,9,10,3,3,10,10,4,4,10,8,5,5,9,7,8,8,1,1,1,8,6,2,7,3,7,2,6,4,7,5,6,3,10,4,9,5,6,9,10,3,3,3,8,7,6,9,4,4,4,6,6,1,9,6,2,2,2,9,6,9,7,5,5,5,8,9,6,6},
    		[14] = {1,1,9,6,2,2,9,7,3,3,7,8,4,4,7,9,5,5,8,6,8,9,1,1,1,7,10,2,6,3,10,2,7,4,7,5,8,3,9,4,7,5,6,7,9,3,3,3,7,7,10,6,4,4,4,10,7,1,10,6,2,2,2,6,6,8,8,5,5,5,10,10,10,9},
    		[15] = {1,1,8,7,2,2,6,6,3,3,6,9,4,4,6,9,5,5,9,6,10,10,1,1,1,10,7,2,9,3,8,2,9,4,8,5,9,3,8,4,8,5,6,7,6,3,3,3,7,10,8,9,4,4,4,9,8,1,7,8,2,2,2,9,9,10,9,5,5,5,6,6,10,10},
    		[16] = {1,1,8,6,2,2,9,8,3,3,10,8,4,4,8,10,5,5,8,8,10,9,1,1,1,9,9,2,9,3,7,2,6,4,8,5,9,3,7,4,9,5,7,6,10,3,3,3,8,10,9,10,4,4,4,8,6,1,7,8,2,2,2,10,6,8,9,5,5,5,6,8,9,8},
    		[17] = {1,1,10,8,2,2,6,10,3,3,6,7,4,4,10,9,5,5,10,10,7,6,1,1,1,9,10,2,8,3,6,2,6,4,10,5,10,3,6,4,9,5,7,9,10,3,3,3,8,9,7,8,4,4,4,8,6,1,8,6,2,2,2,9,6,9,7,5,5,5,6,9,10,6},
    		[18] = {1,1,10,9,2,2,9,10,3,3,10,10,4,4,10,8,5,5,9,7,8,8,1,1,1,8,6,2,7,3,7,2,6,4,7,5,6,3,10,4,9,5,6,9,10,3,3,3,8,7,6,9,4,4,4,6,6,1,9,6,2,2,2,9,6,9,7,5,5,5,8,9,6,6},
    		[19] = {1,1,9,6,2,2,9,7,3,3,7,8,4,4,7,9,5,5,8,6,8,9,1,1,1,7,10,2,6,3,10,2,7,4,7,5,8,3,9,4,7,5,6,7,9,3,3,3,7,7,10,6,4,4,4,10,7,1,10,6,2,2,2,6,6,8,8,5,5,5,10,10,10,9},
    		[20] = {1,1,8,7,2,2,6,6,3,3,6,9,4,4,6,9,5,5,9,6,10,10,1,1,1,10,7,2,9,3,8,2,9,4,8,5,9,3,8,4,8,5,6,7,6,3,3,3,7,10,8,9,4,4,4,9,8,1,7,8,2,2,2,9,9,10,9,5,5,5,6,6,10,10},
		},
	}

	if data["free_game"] then
		if data["free_game"]["page"] then
			self.freeType = data["free_game"]["page"] + 1
			self.storeDupCount = data["free_game"]["duplicate_count"]
			self.storeDupWin = data["free_game"]["duplicate_win"]
		end
	end

	return data
end

function customizedTheme:adjustTheme(data)
	if self.freeType then
	    self:changeSpinBoard(self.freeType)
	else
		self:changeSpinBoard(1)
	end
end

--------------------------------声音相关--------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}
	
	self.audio_list.free_background         = "audio/free_bgm.mp3"
	self.audio_list.free_collect            = "audio/fg_collect_dialog.mp3" 
	self.audio_list.btn_click               = "audio/btn_click.mp3"

	-- rollup
	self.audio_list.rollup01		        = "audio/win1.mp3"
	self.audio_list.rollup01_end	        = "audio/win1end.mp3"
	self.audio_list.rollup02		        = "audio/win2.mp3"
	self.audio_list.rollup02_end	        = "audio/win2end.mp3"
	self.audio_list.rollup03		        = "audio/win3.mp3"
	self.audio_list.rollup03_end	        = "audio/win3end.mp3"
	self.audio_list.rollup04		        = "audio/win4.mp3"
	self.audio_list.rollup04_end	        = "audio/win4end.mp3"

end

return ThemeLuckyPuzzle2

