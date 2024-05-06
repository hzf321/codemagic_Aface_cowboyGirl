-- Author:wanghongjie
-- Email:wanghongjie@bolegames.com
-- 2019年6月6日 19:00
-- Using:主题 3128   

ThemeActivityRoyalPuppies = class("ThemeActivityRoyalPuppies", Theme)
local cls = ThemeActivityRoyalPuppies

-- 资源异步加载相关
cls.plistAnimate = {
	"image/plist/symbol",
}
cls.csbList = {
	"csb/base_game.csb",
}

local SpinBoardType = {
	Normal = 1,
	FreeSpin = 2,
}

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	local borderConfig = self.ThemeConfig["boardConfig"]

	for idx = 1,#borderConfig do 
		local temp = borderConfig[idx]
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
		borderConfig[idx]["reelConfig"] = newReelConfig
		borderConfig[idx]["colReelCnt"] = temp.colCnt
	end
	self.boardConfigList = borderConfig
	return borderConfig
end

-- 初始化
function cls:ctor(themeid)
	self.spinActionConfig = {
		["start_index"] = 1,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1
	}
	self.ThemeConfig = {
		["theme_symbol_coinfig"]= {
			["symbol_zorder_list"] = {
			},
			["normal_symbol_list"] = {
				1,2,3,4,5,6,7,8,9,10,11
			},
			["no_roll_symbol_list"] = {
			},
			["special_symbol_list"] = {
			},
			["special_symbol_config"] = {
			},
		},
		["theme_round_light_index"] = 1,
		["theme_type"] = "payLine",
		["theme_type_config"] = {
			["pay_lines"] = {
				{1,1,1,1,1},{2,2,2,2,2},{0,0,0,0,0},{3,3,3,3,3},{0,1,2,1,0},{1,2,3,2,1},{2,1,0,1,2},{3,2,1,2,3},{0,1,1,1,0},{1,2,2,2,1},
				{2,3,3,3,2},{1,0,0,0,1},{2,1,1,1,2},{3,2,2,2,3},{0,0,1,0,0},{1,1,2,1,1},{2,2,3,2,2},{1,1,0,1,1},{2,2,1,2,2},{3,3,2,3,3},
				{0,1,0,1,0},{1,2,1,2,1},{2,3,2,3,2},{1,0,1,0,1},{2,1,2,1,2},{3,2,3,2,3},{1,0,1,2,1},{2,1,2,3,2},{1,2,1,0,1},{2,3,2,1,2},
				{0,0,1,2,2},{1,1,2,3,3},{2,2,1,0,0},{3,3,2,1,1},{0,0,2,0,0},{1,1,3,1,1},{2,2,0,2,2},{3,3,1,3,3},{0,0,0,1,2},{3,3,3,2,1}  
			},
			["line_cnt"] = 40,
			["pay_lines2"] = {
				{1,1,1,1,1},{0,0,0,0,0},{2,2,2,2,2},{0,1,2,1,0},{2,1,0,1,2},{1,0,0,0,1},{1,2,2,2,1},{0,0,1,2,2},{2,2,1,0,0},{1,0,1,2,1},
				{1,2,1,0,1},{0,1,1,1,0},{2,1,1,1,2},{0,1,0,1,0},{1,2,1,2,1},{1,0,1,0,1},{2,1,2,1,2},{1,1,0,1,1},{1,1,2,1,1},{0,0,1,0,0},
				{2,2,1,2,2},{0,0,0,1,2},{2,2,2,1,0},{0,1,0,1,2},{2,1,2,1,0},{0,0,2,0,0},{2,2,0,2,2},{0,2,2,2,0},{2,0,0,0,2},{0,2,1,2,0}
			},
		},
		["boardConfig"] = {
			{ -- free 1个棋盘 3*5
				["reel_single"] = true, -- 每个棋盘单独一个空间，不共用一个clipnode。例如用于lockrespin
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 3,
				["cellWidth"] = 130,
				["cellHeight"] = 108,
				["reelConfig"] = {  
					{["base_pos"] = cc.p(35,324)},
				},
			},
			{ -- free 2个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 3,
				["cellWidth"] = 130,
				["cellHeight"] = 108,
				["reelConfig"] = {
					{["base_pos"] = cc.p(75,596)},
					{["base_pos"] = cc.p(75,240)},
				},
			},
			{ -- free 3个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 3,
				["cellWidth"] = 130,
				["cellHeight"] = 108,
				["reelConfig"] = {
					{["base_pos"] = cc.p(367,954.5)},
					{["base_pos"] = cc.p(27 ,598)},
					{["base_pos"] = cc.p(706,598)},
				},
			},
			{ -- free 4个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 3,
				["cellWidth"] = 130,
				["cellHeight"] = 108,
				["reelConfig"] = {
					{["base_pos"] = cc.p(27 ,954.5)},
					{["base_pos"] = cc.p(706,954.5)},
					{["base_pos"] = cc.p(27 ,598)},
					{["base_pos"] = cc.p(706,598)},
				},
			},
			-----------------------------------------------
			{ -- free 1个棋盘 4*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 130,
				["cellHeight"] = 107.5,
				["reelConfig"] = {
					{["base_pos"] = cc.p(35,243.5)},
				},
			},
			{ -- free 2个棋盘 4*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 130,
				["cellHeight"] = 107.5,
				["reelConfig"] = { 
					{["base_pos"] = cc.p(75,679.5)},
					{["base_pos"] = cc.p(75,217.5)},
				},
			},
			{ -- free 3个棋盘 4*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 130,
				["cellHeight"] = 107.5,
				["reelConfig"] = {
					{["base_pos"] = cc.p(368,931.5)},
					{["base_pos"] = cc.p(27 ,469.5)},
					{["base_pos"] = cc.p(706,469.5)},
				},
			},
			{ -- free 4个棋盘 4*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 130,
				["cellHeight"] = 107.5,
				["reelConfig"] = {
					{["base_pos"] = cc.p(27 ,931.5)},
					{["base_pos"] = cc.p(706,931.5)},
					{["base_pos"] = cc.p(27 ,469.5)},
					{["base_pos"] = cc.p(706,469.5)},
				},
			},
		}
	}
	self.baseBet = 10000
	self.UnderPressure = 1 -- 下压上 控制

	local use_portrait_screen = true -- true 代表竖屏
	local ret = Theme.ctor(self, themeid, use_portrait_screen)
	return ret
end

----------------------------------------- 滚轴相关 -----------------------------------
cls.spinTimeConfig = { -- spin 时间控制
		[1] = 81/60,-- 欺骗 比基础spin多加的时间 --42/60 在基础spin时间为81帧的时候
		[2] = 181/60,-- 出现大象比基础spin多加的时间  -- 181/60,
		["base"] = 21/60,
		[0] = 39/60,
		["spinMinCD"] = 50/60,
}

local G_cellHeight = 108
local delay = 0 -- 3/60 -- 各个 滚轴开始滚动的 间隔时间
local upBounce = 0 -- G_cellHeight*2/3 -- 上弹位移
local upBounceMaxSpeed = 6*60 -- 上弹的最大速度
local upBounceTime = 0 -- 滚轴滚动开始上弹时间
local speedUpTime = 20/60 -- 开始滚动时候的 加速时间
local rotateTime = 5/60 -- 匀速滚动时间 
local maxSpeed = -26.5*60 -- 最大速度
local normalSpeed = -30*60 -- not Turbo 最大速度
local fastSpeed = -30*60 - 400 -- Turbo 最大速度

local stopDelay = 20/60 -- 滚轴停止的 延迟时间（两个轴 中间的间隔）
local speedDownTime = 45/60 -- 减速时间
local downBounce = G_cellHeight*1/3 -- 下砸位移
local downBounceMaxSpeed = 10*60 -- 下砸的最大速度
local downBounceTime = 5/60 -- 下砸时间
local specialDelay = 1 -- 特殊feature 的延迟时间
local spinMinCD = 0.5 -- 最短出现 stop按钮的时间
local extraReelTime = 120/60 -- anticipation 时间

function cls:getSpinConfig( spinTag )
	local spinConfig = {}
	if self.showFreeSpinBoard then
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
function cls:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}
	if self.showFreeSpinBoard then
		for col,_ in pairs(self.spinLayer.spins) do
			local theAction = self:getSpinColStopAction(ret["theme_info"], col,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	end
	return stopConfig
end
function cls:getSpinColStartAction( pCol, reelCol)
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

function cls:getSpinColStopAction(themeInfo, pCol, interval )

	local spinAction = {}
	spinAction.actions = {}

	local temp = interval - speedUpTime - upBounceTime
	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
	
	self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
	spinAction.stopDelay = timeleft+(pCol-1)*stopDelay

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

function cls:onSpinStop(ret)
	self:fixRet(ret)
	if ret.free_spins and ret.free_game.fg_type and ret.free_game.fg_type ==1 and (not self.ctl.freewin) then --ret.theme_respin
		ret.free_random_pick = {
			["free_cnt"] 	= ret.free_spins,
			["dice_list"] 	= ret.free_game.dice_list,
			["add_reels"] 	= ret.free_game.add_reels,
			["dice_count"] 	= ret.free_game.dice_count,
			["pos_list"] 	= ret.free_game.pos_list,
			["wild_reel"]	= ret.free_game.wild_reel,
			["add_row"]		= ret.free_game.add_row,
			["pos_count"]	= ret.free_game.pos_count,
			["total_dice_list"]	= tool.tableClone(ret.free_game.dice_list),
		}
	end
	Theme.onSpinStop(self, ret)
end

function cls:checkPlaySymbolNotifyEffect( pCol ) -- 是否播放特殊symbol 的 下落音效
	return false
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
end

-- 初始化spinNode
function cls:initSpinLayer( )
	self.spinLayerList = {}
	for index,cofig in pairs(self.boardNodeList) do
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

function cls:initBoardNodes(pBoardConfigList)
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

function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
	self:clearAnimate()
	if pType == SpinBoardType.FreeSpin then
		self:changeFreeBoardByType()

		self.showFreeSpinBoard = true
	end
end
local freeBoardData = {
	[3] = {
		[1]= {["boardIndex"] = 1,["time"] = 30},
		[2]= {["boardIndex"] = 2,["time"] = 90},
		[3]= {["boardIndex"] = 3,["time"] = 150},
		[4]= {["boardIndex"] = 4,["time"] = 210},
	},
	[4] = {
		[1]= {["boardIndex"] = 5,["time"] = 60},
		[2]= {["boardIndex"] = 6,["time"] = 120},
		[3]= {["boardIndex"] = 7,["time"] = 180},
		[4]= {["boardIndex"] = 8,["time"] = 240},
	},
}
function cls:changeFreeBoardByType( ... )
	local curFreeBoardData = freeBoardData[self.freeColCnt][self.freeBoardCnt]
	if not curFreeBoardData then return end
	if self.spinLayer ~= self.spinLayerList[curFreeBoardData["boardIndex"]] then
		self.spinLayer:DeActive()
		self.spinLayer = self.spinLayerList[curFreeBoardData["boardIndex"]]
		self.spinLayer:Active()
	end

	local action = cc.CSLoader:createTimeline(self:getPic("csb/base_game.csb"))
	self.mainThemeScene:runAction(action)
	action:gotoFrameAndPause(curFreeBoardData["time"])
	self:addWildReel()
end

function cls:addWildReel()
	if self.freeWildReelPos and #self.freeWildReelPos>0 then 

		self.freeHoldLayer:removeAllChildren()
		self.wildReelSpineList = {}
		local spineFile = self:getPic("spine/item/1_big/spine")
		local anim1 = "animation" .. self.freeColCnt

		local _cellHeight = self.spinLayer.spins[1].cellHeight
		local posY = self.freeColCnt/2
		for id = 1,self.freeBoardCnt do 
			for _,col in pairs(self.freeWildReelPos) do 
				local realCol = (id-1)*5+col
				local pos = nil
				if self.freeColCnt == 3 then 
					pos = self:getCellPos(realCol,2)
				else
					pos = cc.pAdd(self:getCellPos(realCol,3),cc.p(0,_cellHeight/2))
				end
				local _,s  = self:addSpineAnimation(self.freeHoldLayer, nil, spineFile, pos, (anim1 .. "_1"), nil, nil, nil, true)
				self.wildReelSpineList[realCol] = {}
				self.wildReelSpineList[realCol]["spine"] = s
				self.wildReelSpineList[realCol]["anim1"] = anim1
			end
		end
	end
end
------------------------------------------------------------------------------------------------------------
-- 主题布局相关
------------------------------------------------------------------------------------------------------------
function cls:initScene(spinNode)
	local path = self:getPic("csb/base_game.csb")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	bole.adaptScale(self.mainThemeScene,true) -- 第二个参数 是否是 竖版
	self.bgRoot = self.mainThemeScene:getChildByName("theme_bg")
	self.down_node = self.mainThemeScene:getChildByName("down_node")
	bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
	self.down_child = self.down_node:getChildByName("down_node")
	self.boardRoot 		= self.down_child:getChildByName("board_root")
	self.logoNode		= self.down_child:getChildByName("logo")
	self.animateNode 	= self.down_child:getChildByName("animate")
	self.freeHoldLayer 	= self.down_child:getChildByName("hold_free")

	-- local progressive_nodes = self.mainThemeScene:getChildByName("progressive"):getChildByName("jackpots_labels")-- 初始化jackpot
	-- self.jackpotLabels 	= {}
	-- for i=1,4 do
	-- 	self.jackpotLabels[i] 	= progressive_nodes:getChildByName("label_jp" .. i)
	-- 	self.jackpotLabels[i].maxWidth 	= self:getJPLabelMaxWidth(i)
	-- 	self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	-- end

	self.freeBg = self.bgRoot:getChildByName("bg_free")
	self.curBg = self.freeBg
	self.freeBg:setVisible(true)

	self.shakyNode:addChild(self.mainThemeScene)
	-- self:initialJackpotNode()
end

-- function cls:getJPLabelMaxWidth(index)
-- 	if index == 1 then
-- 		return 218
-- 	elseif index ==2 then 
-- 		return 182
-- 	elseif index == 3 then 
-- 		return 158
-- 	else
-- 		return 139
-- 	end
-- end

-- function cls:getThemeJackpotConfig()
-- 	local jackpot_config_list = 
-- 	{
-- 		link_config = {"grand", "major", "minor","mini"},
-- 		allowK = {[3128] = false}
-- 	}
-- 	return jackpot_config_list
-- end

------------------------------------------------------------------------------------------------------------
-- Cell相关
------------------------------------------------------------------------------------------------------------
function cls:createCellSprite(key, col, rowIndex )
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
	local theCellFile = self.pics[key]
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
	return ret
end
function cls:updateCellSprite(theCellNode, key, col,isShowResult,isReset)
	local theCellFile = self.pics[key]
	if not theCellFile then 
		print("whj: key ,file ",key,theCellFile)
	end
	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0
	------------------------------------------------------------

	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col)	
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	theCellSprite:setPosition(cc.p(0,0))

end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的
end

function cls:stopReelNotifyEffect(pCol)
end

function cls:drawPayLineItem(reel, row, specials, itemList, effectStatus, tipIndex,parent)
	local sprite = cc.Sprite:create()
	sprite:setPosition(self:getCellPos(reel,row))
	local tt 		= itemList[reel][row]

	local action    = self:getItemAnimate(tt, reel, row, effectStatus,parent) -- 获得相应动画
	if action then	
		local s = self.spinLayer.spins[reel]:getRetCell(row) -- 获得相应位置 
		s:setCascadeOpacityEnabled(true) -- 子节点透明度随父节点变化
		if type(action) == "table" then
			local i = action[2]
			s = s:getChildren()[i]
			action = action[1]
		end
		s:runAction(action)
	end
	self:playCellRoundEffect(sprite, tt, reel, row, effectStatus) -- 播放中奖连线 调用每个主题本身的方法, 直接播放spine 动画来实现
	return sprite
end

function cls:getItemAnimate(item, col, row, effectStatus,parent)
	local spineItemsSet = Set({1,2,3,4,5,6,7})
	if spineItemsSet[item] then 
		if effectStatus == "all_first" then
			self:playItemAnimation(item, col, row)
		else
			self:playOldAnimation(col,row)
		end
		return nil
	else
		return self:playSAllAnimation(item ,col)
	end

end
function cls:playSAllAnimation(item ,col)
	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.ScaleTo:create(26/fs,1.15),
		cc.DelayTime:create(2/fs),		
		cc.ScaleTo:create(26/fs,1),
		cc.DelayTime:create(2/fs))
	return cc.Sequence:create(animate,animate:clone())
end

function cls:playItemAnimation(item, col, row)
	self.animNodeList = self.animNodeList or {}
	if self.wildReelSpineList and self.wildReelSpineList[col] then 
		bole.spChangeAnimation(self.wildReelSpineList[col].spine,self.wildReelSpineList[col].anim1,false)
	elseif not self.animNodeList[col.."_"..row] then 
		local animateName = "animation"
		local pos = self:getCellPos(col,row)
		local spineFile = self:getPic("spine/item/" .. item .. "/spine")
		local _, s1	= self:addSpineAnimation(self.animateNode, nil, spineFile, pos, animateName, nil, nil, nil, true)
		
		self.animNodeList[col.."_"..row] = {}
		self.animNodeList[col.."_"..row][1] = s1 
		self.animNodeList[col.."_"..row][2] = animateName

		local cell = self.spinLayer.spins[col]:getRetCell(row)
		cell:setVisible(false)
	end
end

function cls:playOldAnimation(col,row)
	self.animNodeList = self.animNodeList or {}
	if self.wildReelSpineList and self.wildReelSpineList[col] then 
		bole.spChangeAnimation(self.wildReelSpineList[col].spine,self.wildReelSpineList[col].anim1,false)
	elseif self.animNodeList[col.."_"..row] then 
		node = self.animNodeList[col.."_"..row][1]
		animationName = self.animNodeList[col.."_"..row][2]

		if node and animationName then 
			bole.spChangeAnimation(node,animationName,false)
		end
	end
end

function cls:playCellRoundEffect(parent, ...)
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
	local timeList = {2,2}
	Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)
end

------------------------------------------------------------------------------------------------------------
-- theme_info 相关
------------------------------------------------------------------------------------------------------------
function cls:getRollUpBet(ret) -- 进行 bet 设置
	local tb = nil 
	if self.superAvgBet then 
		tb = self.superAvgBet
	end
	return tb
end

function cls:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果
    local new_pos_List = {} -- 更新新的 pos list
    for i = 1, #ret["win_pos_list"] do
        for k, v in ipairs(ret["win_pos_list"][i]) do
            table.insert(new_pos_List, {v[1] + (i-1) * 5, v[2]})
        end
    end
    ret["win_pos_list"] = new_pos_List

    local new_win_List = {} -- 更新新的 winLisne
    for i = 1, #ret["win_lines"] do
        for k, v in ipairs(ret["win_lines"][i]) do
            v.col_ck = 5 * (i-1)
            table.insert(new_win_List, v)
        end
    end
    ret["win_lines"] = new_win_List
end
------------------------------------------------------------------------------------------------------------
-- 进入不同 freature 相关
------------------------------------------------------------------------------------------------------------
function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	if ret == nil then ret = {} end
	ret["free_random_pick"] = {
		["free_cnt"] 	= theFreeSpinData.data,
		["dice_list"]	= theFreeSpinData.dice_list,
		["add_reels"] 	= theFreeSpinData.add_reels,
		["dice_count"] 	= theFreeSpinData.dice_count,
		["pos_list"]	= theFreeSpinData.pos_list,
		["wild_reel"]	= theFreeSpinData.wild_reel,
		["add_row"]		= theFreeSpinData.add_row,
		["pos_count"]	= theFreeSpinData.pos_count,
		["base_win"]	= theFreeSpinData.base_win,
		["total_dice_list"]	= tool.tableClone(theFreeSpinData.dice_list),
		["tryResume"] 	= true,
	}
	ret["total_win"]	    = self.ctl.total_win

	self.ctl:free_random_pick(ret)
end

function cls:clearFreeData()
	LoginControl:getInstance():savePick(self.themeid, nil) -- 清除数据 Pick 数据
end

function cls:getPickData()
	return LoginControl:getInstance():getPick(self.themeid)
end


function cls:checkIsNewBonusAndChangeData( theBonusGameData )
	local localBonusData = self:getPickData() or {}

	if not tool.isEqTwoTable(localBonusData.total_dice_list, theBonusGameData.total_dice_list)  then 

		self:clearFreeData()
	else

	end
end

function cls:enterPickGame(ret, theGameData, endCallfunc)
	self:checkIsNewBonusAndChangeData(theGameData)

	theGameData.core_data = self:getPickData() or {}
	if theGameData.tryResume and theGameData.core_data.end_game then 
		self.ctl.rets.free_spins = theGameData.free_cnt
		self.freeBoardCnt = theGameData.add_reels -- 对Free 数据 进行 赋值
		self.freeColCnt = theGameData.add_row 
		self.freeWildReelPos = theGameData.wild_reel 
		-- self.cookieCount = theGameData.cookie_count 
		self.ctl.totalWin = theGameData.total_win
		endCallfunc()
		return 
	end
	self.ctl.spinning 		= false
	self:lockLobbyBtn() -- 锁定lobbyBtn
	self.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
 	self.ctl.footer:enableOtherBtns(false) -- 禁掉 其他按钮

	local endCallfunc_old = endCallfunc
	endCallfunc = function (spin_count)
		self.PickDialog = nil
		endCallfunc_old()
	end

	self.PickData = theGameData
	self.PickDialog = ActivityRoyalPuppiesFreePick.new(self, self:getPic("csb/"), theGameData, endCallfunc,theGameData.tryResume)
	self.PickDialog:enterPickGame(theGameData.tryResume)
end

function cls:changePayLine(ptype)
	if ptype ==2 then 
		self.lines   = self.ThemeConfig["theme_type_config"]["pay_lines2"]
	else
		self.lines   = self.ThemeConfig["theme_type_config"]["pay_lines"]
	end
	self.maxLine = #self.lines
end

function cls:showFreeSpinNode( count, sumCount, first)
	if self.freeColCnt==3 then 
		self:changePayLine(2)
	else
		self:changePayLine(1)
	end
	
	self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类型
	Theme.showFreeSpinNode(self,count, sumCount, first)

	-- if self.superAvgBet then 
	-- 	self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
	-- 	self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet 
	-- end
end

function cls:hideFreeSpinNode(...) -- 进行出去freespin棋盘控制
	self:changePayLine(1)
	self.freeHoldLayer:removeAllChildren()
	self.wildReelSpineList 	= nil
	self.freeBoardCnt 		= nil
	self.freeColCnt			= nil
	self.freeWildReelPos 	= nil
	--------------------
	-- if self.superAvgBet then 
	-- 	self.superAvgBet = nil
	-- 	self.ctl.footer:changeNormalLayout2()
	-- 	if not self.ctl.freeItem then 
	-- 		for k,reel in pairs(self.spinLayer.spins) do
	-- 			local key = math.random(1,11)
	-- 			local cell = reel:currentCell()
	-- 			self:updateCellSprite(cell, key, k, 1)
	-- 		end
	-- 	end
	-- end
	Theme.hideFreeSpinNode(self, ...)
end

-- function cls:resetPointBet() -- 仅仅在断线的时候 被调用了
-- 	if self.superAvgBet then 
-- 		self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
-- 		self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet 
-- 	end
-- end

local fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}
function cls:showFreeSpinDialog(theData, sType)
	if not self.freeSpinConfig then
		local config = {}
		config["gen_path"] = self:getPic("csb/")
		config["csb_file"] = config["gen_path"].."free_dialog.csb"
		config["frame_config"] = {
			["more"] 		 = {{0,30},2.7,  {90, 120},0.3,0,0,0.5},
			["collect"] 	 = {{0,30}, 1,	 {90, 120},0,0,0.4,0.5},-- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
		}
		self.freeSpinConfig = config 
	end
	local addLizi = function (node) -- 添加粒子特效 和 spine 动画的入口
		self:addSpineAnimation(node:getChildByName("spine"),nil, self:getPic("spine/dialog/fr_tk_01"), cc.p(0,0), "animation1", nil, nil, nil, true, true)-- 背景特效
		self:addSpineAnimation(node:getChildByName("spine2"),nil, self:getPic("spine/dialog/anniu_01"), cc.p(0,0), "animation", nil, nil, nil, true, true)-- 添加按钮
	end
	local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
	if sType == fs_show_type.collect then
		theDialog:setCollectScaleByValue(theData.coins,480)
		addLizi(theDialog.collectRoot.collectNode)
		theDialog:showCollect(theData)
	end
end

function cls:playStartFreeSpinDialog( theData )
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

function cls:playCollectFreeSpinDialog( theData )
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		RubTheLampController:getInstance():finishGenieThemeBonus()
		-- self:playMusic(self.audio_list.transition1)-- 播放转场声音
		-- self:playTransition(nil,"free")-- 转场动画
	end

	local changeLayer_event = theData.changeLayer_event
	theData.changeLayer_event = function (  )
		-- self.theme:dealMusic_PlayFSCollectEndMusic()
		-- if self.isDealFSCollectEnd then return end
		-- self.isDealFSCollectEnd = true
		-- self.freespin = nil
		-- self:removePointBet()
		-- self:outFreeSpinStage()
	end

	-- local end_event = theData.end_event
	-- theData.end_event = function ( ... )
	-- 	if end_event then
	-- 		end_event()
	-- 	end
	-- end
	self:showFreeSpinDialog(theData, fs_show_type.collect)
end

function cls:collectFreeRollEnd(  )
	
	LobbyThemeControl:getInstance():backToLobby(self.ctl.header, true, 10011, nil)
end
---------------------------场景恢复处理-------------------------------------
-- 处理场景恢复的数据
function cls:adjustEnterThemeRet(retData)

	retData["theme_reels"] = {
		["main_reel"] = {
			[1] = {8,11,2,2,8,11,1,3,10,8,3,4,11,8,2,4,9,2,5,5,3,10,8,6,6,11,4,8,8,7,7,11,9,8,8,8,9,5,10,5,8,11,2,8,9,10,11,10,6,10,6,6,9,1,10,11,8,10,11,10,7,8,9,10,11,2,8,11,10,10,10,11,2,9,8,2,2,1,3,9,8,10,5,11,3,8,6,4,4,5,7,11,10,3,9,5,9,9,1,9,10},
    		[2] = {10,10,2,2,9,9,1,3,9,10,3,4,8,8,2,4,11,2,5,5,3,9,9,6,6,11,4,9,11,7,7,10,9,8,9,8,8,5,10,5,11,10,2,11,9,10,11,10,6,8,6,6,10,1,10,8,8,9,10,10,7,8,9,10,8,2,8,11,11,10,11,9,2,9,10,2,2,1,3,10,11,8,5,10,3,11,6,4,4,5,7,11,8,3,8,5,9,11,1,10,9},
    		[3] = {11,8,2,2,9,10,1,3,9,9,3,4,11,8,2,4,9,2,5,5,3,10,11,6,6,9,4,10,11,7,7,11,11,8,10,8,9,5,11,5,10,11,2,11,9,10,11,10,6,11,6,6,10,1,10,8,8,9,9,11,7,9,9,10,9,2,9,11,11,10,8,11,2,10,8,2,2,1,3,11,11,9,5,11,3,11,6,4,4,5,7,11,9,3,10,5,9,8,1,10,11},
    		[4] = {11,8,2,2,11,10,1,3,11,9,3,4,11,11,2,4,10,2,5,5,3,11,11,6,6,8,4,11,11,7,7,8,11,8,9,8,8,5,8,5,11,8,2,8,9,10,11,11,6,11,6,6,11,1,9,8,8,9,10,9,7,8,9,10,10,2,10,11,10,10,10,9,2,9,8,2,2,1,3,9,9,11,5,8,3,11,6,4,4,5,7,10,11,3,10,5,9,9,1,8,10},
    		[5] = {11,10,2,2,8,11,1,3,9,10,3,4,11,8,2,4,10,2,5,5,3,8,9,6,6,11,4,10,8,7,7,11,8,8,11,8,9,5,8,5,10,11,2,9,9,10,11,11,6,9,6,6,9,1,11,9,8,11,10,9,7,11,9,10,9,2,10,11,11,8,10,8,2,9,11,2,2,1,3,9,10,9,5,10,3,11,6,4,4,5,7,8,8,3,11,5,10,9,1,11,8},
		},
		["free_reel"] = {
			[1] = {8,11,2,2,8,11,1,3,10,8,3,4,11,8,2,4,9,2,5,5,3,10,8,6,6,11,4,8,8,7,7,11,9,8,8,8,9,5,10,5,8,11,2,8,9,10,11,10,6,10,6,6,9,1,10,11,8,10,11,10,7,8,9,10,11,2,8,11,10,10,10,11,2,9,8,2,2,1,3,9,8,10,5,11,3,8,6,4,4,5,7,11,10,3,9,5,9,9,1,9,10},
    		[2] = {10,10,2,2,9,9,1,3,9,10,3,4,8,8,2,4,11,2,5,5,3,9,9,6,6,11,4,9,11,7,7,10,9,8,9,8,8,5,10,5,11,10,2,11,9,10,11,10,6,8,6,6,10,1,10,8,8,9,10,10,7,8,9,10,8,2,8,11,11,10,11,9,2,9,10,2,2,1,3,10,11,8,5,10,3,11,6,4,4,5,7,11,8,3,8,5,9,11,1,10,9},
    		[3] = {11,8,2,2,9,10,1,3,9,9,3,4,11,8,2,4,9,2,5,5,3,10,11,6,6,9,4,10,11,7,7,11,11,8,10,8,9,5,11,5,10,11,2,11,9,10,11,10,6,11,6,6,10,1,10,8,8,9,9,11,7,9,9,10,9,2,9,11,11,10,8,11,2,10,8,2,2,1,3,11,11,9,5,11,3,11,6,4,4,5,7,11,9,3,10,5,9,8,1,10,11},
    		[4] = {11,8,2,2,11,10,1,3,11,9,3,4,11,11,2,4,10,2,5,5,3,11,11,6,6,8,4,11,11,7,7,8,11,8,9,8,8,5,8,5,11,8,2,8,9,10,11,11,6,11,6,6,11,1,9,8,8,9,10,9,7,8,9,10,10,2,10,11,10,10,10,9,2,9,8,2,2,1,3,9,9,11,5,8,3,11,6,4,4,5,7,10,11,3,10,5,9,9,1,8,10},
    		[5] = {11,10,2,2,8,11,1,3,9,10,3,4,11,8,2,4,10,2,5,5,3,8,9,6,6,11,4,10,8,7,7,11,8,8,11,8,9,5,8,5,10,11,2,9,9,10,11,11,6,9,6,6,9,1,11,9,8,11,10,9,7,11,9,10,9,2,10,11,11,8,10,8,2,9,11,2,2,1,3,9,10,9,5,10,3,11,6,4,4,5,7,8,8,3,11,5,10,9,1,11,8},
    		[6] = {8,11,2,2,8,11,1,3,10,8,3,4,11,8,2,4,9,2,5,5,3,10,8,6,6,11,4,8,8,7,7,11,9,8,8,8,9,5,10,5,8,11,2,8,9,10,11,10,6,10,6,6,9,1,10,11,8,10,11,10,7,8,9,10,11,2,8,11,10,10,10,11,2,9,8,2,2,1,3,9,8,10,5,11,3,8,6,4,4,5,7,11,10,3,9,5,9,9,1,9,10},
    		[7] = {10,10,2,2,9,9,1,3,9,10,3,4,8,8,2,4,11,2,5,5,3,9,9,6,6,11,4,9,11,7,7,10,9,8,9,8,8,5,10,5,11,10,2,11,9,10,11,10,6,8,6,6,10,1,10,8,8,9,10,10,7,8,9,10,8,2,8,11,11,10,11,9,2,9,10,2,2,1,3,10,11,8,5,10,3,11,6,4,4,5,7,11,8,3,8,5,9,11,1,10,9},
    		[8] = {11,8,2,2,9,10,1,3,9,9,3,4,11,8,2,4,9,2,5,5,3,10,11,6,6,9,4,10,11,7,7,11,11,8,10,8,9,5,11,5,10,11,2,11,9,10,11,10,6,11,6,6,10,1,10,8,8,9,9,11,7,9,9,10,9,2,9,11,11,10,8,11,2,10,8,2,2,1,3,11,11,9,5,11,3,11,6,4,4,5,7,11,9,3,10,5,9,8,1,10,11},
    		[9] = {11,8,2,2,11,10,1,3,11,9,3,4,11,11,2,4,10,2,5,5,3,11,11,6,6,8,4,11,11,7,7,8,11,8,9,8,8,5,8,5,11,8,2,8,9,10,11,11,6,11,6,6,11,1,9,8,8,9,10,9,7,8,9,10,10,2,10,11,10,10,10,9,2,9,8,2,2,1,3,9,9,11,5,8,3,11,6,4,4,5,7,10,11,3,10,5,9,9,1,8,10},
    		[10] = {11,10,2,2,8,11,1,3,9,10,3,4,11,8,2,4,10,2,5,5,3,8,9,6,6,11,4,10,8,7,7,11,8,8,11,8,9,5,8,5,10,11,2,9,9,10,11,11,6,9,6,6,9,1,11,9,8,11,10,9,7,11,9,10,9,2,10,11,11,8,10,8,2,9,11,2,2,1,3,9,10,9,5,10,3,11,6,4,4,5,7,8,8,3,11,5,10,9,1,11,8},
    		[11] = {8,11,2,2,8,11,1,3,10,8,3,4,11,8,2,4,9,2,5,5,3,10,8,6,6,11,4,8,8,7,7,11,9,8,8,8,9,5,10,5,8,11,2,8,9,10,11,10,6,10,6,6,9,1,10,11,8,10,11,10,7,8,9,10,11,2,8,11,10,10,10,11,2,9,8,2,2,1,3,9,8,10,5,11,3,8,6,4,4,5,7,11,10,3,9,5,9,9,1,9,10},
    		[12] = {10,10,2,2,9,9,1,3,9,10,3,4,8,8,2,4,11,2,5,5,3,9,9,6,6,11,4,9,11,7,7,10,9,8,9,8,8,5,10,5,11,10,2,11,9,10,11,10,6,8,6,6,10,1,10,8,8,9,10,10,7,8,9,10,8,2,8,11,11,10,11,9,2,9,10,2,2,1,3,10,11,8,5,10,3,11,6,4,4,5,7,11,8,3,8,5,9,11,1,10,9},
    		[13] = {11,8,2,2,9,10,1,3,9,9,3,4,11,8,2,4,9,2,5,5,3,10,11,6,6,9,4,10,11,7,7,11,11,8,10,8,9,5,11,5,10,11,2,11,9,10,11,10,6,11,6,6,10,1,10,8,8,9,9,11,7,9,9,10,9,2,9,11,11,10,8,11,2,10,8,2,2,1,3,11,11,9,5,11,3,11,6,4,4,5,7,11,9,3,10,5,9,8,1,10,11},
    		[14] = {11,8,2,2,11,10,1,3,11,9,3,4,11,11,2,4,10,2,5,5,3,11,11,6,6,8,4,11,11,7,7,8,11,8,9,8,8,5,8,5,11,8,2,8,9,10,11,11,6,11,6,6,11,1,9,8,8,9,10,9,7,8,9,10,10,2,10,11,10,10,10,9,2,9,8,2,2,1,3,9,9,11,5,8,3,11,6,4,4,5,7,10,11,3,10,5,9,9,1,8,10},
    		[15] = {11,10,2,2,8,11,1,3,9,10,3,4,11,8,2,4,10,2,5,5,3,8,9,6,6,11,4,10,8,7,7,11,8,8,11,8,9,5,8,5,10,11,2,9,9,10,11,11,6,9,6,6,9,1,11,9,8,11,10,9,7,11,9,10,9,2,10,11,11,8,10,8,2,9,11,2,2,1,3,9,10,9,5,10,3,11,6,4,4,5,7,8,8,3,11,5,10,9,1,11,8},
    		[16] = {8,11,2,2,8,11,1,3,10,8,3,4,11,8,2,4,9,2,5,5,3,10,8,6,6,11,4,8,8,7,7,11,9,8,8,8,9,5,10,5,8,11,2,8,9,10,11,10,6,10,6,6,9,1,10,11,8,10,11,10,7,8,9,10,11,2,8,11,10,10,10,11,2,9,8,2,2,1,3,9,8,10,5,11,3,8,6,4,4,5,7,11,10,3,9,5,9,9,1,9,10},
    		[17] = {10,10,2,2,9,9,1,3,9,10,3,4,8,8,2,4,11,2,5,5,3,9,9,6,6,11,4,9,11,7,7,10,9,8,9,8,8,5,10,5,11,10,2,11,9,10,11,10,6,8,6,6,10,1,10,8,8,9,10,10,7,8,9,10,8,2,8,11,11,10,11,9,2,9,10,2,2,1,3,10,11,8,5,10,3,11,6,4,4,5,7,11,8,3,8,5,9,11,1,10,9},
    		[18] = {11,8,2,2,9,10,1,3,9,9,3,4,11,8,2,4,9,2,5,5,3,10,11,6,6,9,4,10,11,7,7,11,11,8,10,8,9,5,11,5,10,11,2,11,9,10,11,10,6,11,6,6,10,1,10,8,8,9,9,11,7,9,9,10,9,2,9,11,11,10,8,11,2,10,8,2,2,1,3,11,11,9,5,11,3,11,6,4,4,5,7,11,9,3,10,5,9,8,1,10,11},
    		[19] = {11,8,2,2,11,10,1,3,11,9,3,4,11,11,2,4,10,2,5,5,3,11,11,6,6,8,4,11,11,7,7,8,11,8,9,8,8,5,8,5,11,8,2,8,9,10,11,11,6,11,6,6,11,1,9,8,8,9,10,9,7,8,9,10,10,2,10,11,10,10,10,9,2,9,8,2,2,1,3,9,9,11,5,8,3,11,6,4,4,5,7,10,11,3,10,5,9,9,1,8,10},
    		[20] = {11,10,2,2,8,11,1,3,9,10,3,4,11,8,2,4,10,2,5,5,3,8,9,6,6,11,4,10,8,7,7,11,8,8,11,8,9,5,8,5,10,11,2,9,9,10,11,11,6,9,6,6,9,1,11,9,8,11,10,9,7,11,9,10,9,2,10,11,11,8,10,8,2,9,11,2,2,1,3,9,10,9,5,10,3,11,6,4,4,5,7,8,8,3,11,5,10,9,1,11,8},
		},
	}
	if retData["free_game"] then -- free 断线重连数据 控制
		if retData["free_game"].super_bet then -- 更新themeInfo 的 super_level 显示
			self.superAvgBet = retData["free_game"].super_bet
		end
		if retData["free_game"]["free_spins"] == retData["free_game"]["free_spin_total"] and retData["free_game"]["fg_type"] == 1 then
			retData["first_free_game"] = {}
			retData["first_free_game"]["data"] 		= retData["free_game"]["free_spins"]
			retData["first_free_game"]["win"] 		= retData["free_game"]["win"]
			retData["first_free_game"]["base_win"] 	= retData["free_game"]["base_win"]
			retData["first_free_game"]["total_win"] = retData["free_game"]["total_win"]
			retData["first_free_game"]["bet"] 		= retData["free_game"]["bet"]
			retData["first_free_game"]["item_list"] = retData["free_game"]["item_list"]

			retData["first_free_game"]["dice_list"] = retData["free_game"]["dice_list"]
			retData["first_free_game"]["add_reels"] = retData["free_game"]["add_reels"]
			retData["first_free_game"]["dice_count"]= retData["free_game"]["dice_count"]
			retData["first_free_game"]["pos_list"]	= retData["free_game"]["pos_list"]
			retData["first_free_game"]["wild_reel"] = retData["free_game"]["wild_reel"]
			retData["first_free_game"]["add_row"] 	= retData["free_game"]["add_row"]
			retData["first_free_game"]["pos_count"] = retData["free_game"]["pos_count"]
			retData["free_game"] = nil
		end
	end
	return retData
end

function cls:adjustTheme(data) -- 进入主题调用的函数 解析 jackpot 数据在这里
	self:changeSpinBoard(SpinBoardType.Normal) 
end

function cls:getBtnFlashInfo()
	local ret = Theme.getBtnFlashInfo(self)
	return ret
end
function cls:setFreeGameRecoverState(data) --  "free_spins": 8, "win": 310000, "add_reels": 3, "dice_count": 21, "wild_reel": [ 3, 4 ], "add_row": 4, "pos_count": 19 
	-- libDebug.printTable("whj: setFreeGameRecoverState : ",data)
	if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
		self.freeBoardCnt 		= data["add_reels"]
		self.freeColCnt  		= data["add_row"]
		self.freeWildReelPos 	= data["wild_reel"]
		-- self.cookieCount 		= data["cookie_count"]
		self.isFreeGameRecoverState = true
	end
end
-----------------------------------------------------------------------------------
-- 滚轴相关
-----------------------------------------------------------------------------------
function cls:genSpecials( )
	local specials 	 = {}
	self.ctl.specials = specials	
end

function cls:genSpecialSymbolState( rets )
	rets = rets or self.ctl.rets
	if not self.checkItemsState then
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
	end
end

function cls:onReelFastFallBottom( pCol )
	self.reelStopMusicTagList[pCol] = true

	if not self.fastStopMusicTag then
		if pCol == 1 then 
			self:playMusic(self.audio_list.reel_stop)
		end
	end

	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	self:checkPlaySymbolNotifyEffect(pCol)
	self:stopReelNotifyEffect(pCol)
end
function cls:stopDrawAnimate()
 	self.speicalDelay = 0
	local delay = 0

	self.animNodeList = nil
	if self.wildReelSpineList then 
		for k,v in pairs(self.wildReelSpineList) do 
			bole.spChangeAnimation(v.spine,(v.anim1 .. "_1"),false)
		end
	end
	Theme.stopDrawAnimate(self)
end
----------------------------------------------
-- 新加方法
function cls:collectSpeicalGame( ... )
 	if self.PickDialog then 
 		self.PickDialog:playEndDialogClickEnd()
 	end
end 


-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack,tType)
	local function delayAction()
		local transition = ActivityRoyalPuppiesTransition.new(self,endCallBack)
		transition:play(tType)
	end	
	delayAction()
end

ActivityRoyalPuppiesTransition = class("ActivityRoyalPuppiesTransition", CCSNode)
local GameTransition = ActivityRoyalPuppiesTransition
function GameTransition:ctor(theme, endCallBack)
	self.spine = nil
	self.theme = theme
	self.endFunc = endCallBack
end


function GameTransition:play(tType)
	local spineFile = self.theme:getPic("spine/base/qieping_01") -- 默认显示 Free transition
	local pos = cc.p(0,0)
	local delay1 = 40/30 -- 切屏结束 的时间

	self.theme.curScene:addToContentFooter(self)
	bole.adaptTransition(self,true,true)
    self:setVisible(false) 
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    	self:setVisible(true)
    	self.theme:addSpineAnimation(self, nil, spineFile, pos, "animation")
    end),
    cc.DelayTime:create(delay1), -- 切屏动画完成时间
    cc.CallFunc:create(function ( ... )
    	if self.endFunc then 
    		self.endFunc()
    	end
    end),
    cc.RemoveSelf:create()))
end

function cls:onExit( )
	if self.shaker then
		self.shaker:stop()
	end
	Theme.onExit(self)
end

function cls:configAudioList()
	Theme.configAudioList(self)
	self.audio_list = self.audio_list or {}
	-- base
	self.audio_list.transition1 	= "audio/base/transition1.mp3"    	-- 进地图 出Free 进出superFree 
	self.audio_list.common_dialog_click = "audio/base/click1.mp3" -- 所有弹窗的点击音效
	self.audio_list.common_dialog_close = "audio/base/normal_dialog_close.mp3" -- 所有弹窗的关闭音效
	-- map
	self.audio_list.pick_bgm = "audio/map/map_bgm.mp3" 
	self.audio_list.map_dialog = "audio/map/map_dialog.mp3" -- 地图开始弹窗
	self.audio_list.coin 	= "audio/map/coin.mp3" -- 出现到收集
	self.audio_list.dice_spin = "audio/map/dice_spin.mp3" -- 筛子转
	self.audio_list.dice_stop = "audio/map/dice_stop.mp3" -- 筛子停
	self.audio_list.dog1 	= "audio/map/dog1.mp3" -- 小狗正常移动
	self.audio_list.dog2 	= "audio/map/dog2.mp3" -- 小狗过桥
	self.audio_list.fly3 	= "audio/map/fly3.mp3" -- 图案add_reel/wild_reel/add_row 飞+接收 
	self.audio_list.fly4 	= "audio/map/fly4.mp3" -- 图案+1 spins飞+接收
	self.audio_list.map_end = "audio/map/map_end.mp3"
	self.audio_list.fg_dialog = "audio/map/fg_dialog.mp3" -- pick 结算弹窗
	-- free
	self.audio_list.free_background  		  = "audio/map/free_bgm.mp3"
	self.audio_list.free_dialog_collect_show  = "audio/base/normal_dialog_show2.mp3" -- Free collect 
	self.audio_list.free_dialog_collect_click = "audio/base/click1.mp3"
	self.audio_list.free_dialog_collect_close = "audio/base/normal_dialog_close.mp3"
	self.audio_list.retrigger_bell	= "audio/base/bell.mp3"
end
function cls:getLoadMusicList()
	local loadMuscList = {
		self.audio_list.transition1,
		self.audio_list.common_dialog_click,
		self.audio_list.free_dialog_collect_show,
		self.audio_list.common_dialog_close,
		self.audio_list.free_dialog_collect_show,
		self.audio_list.retrigger_bell,

		self.audio_list.map_dialog,
		self.audio_list.coin,
		self.audio_list.dice_spin,
		self.audio_list.dice_stop,
		self.audio_list.dog1,
		self.audio_list.dog2,
		self.audio_list.fly3,
		self.audio_list.fly4,
		self.audio_list.fg_dialog,
		self.audio_list.map_end,
	}
	return loadMuscList
end
--------------------------- 音效控制 ---------------------------
-- 播放pick game的背景音乐
function cls:dealMusic_PlayPickLoopMusic()
	-- 播放背景音乐
	self:playLoopMusic(self.audio_list.pick_bgm)
	self:refreshAllAudioVolume()
end
-- 滚轮音效相关
function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效
end
function cls:dealMusic_StopReelNotifyMusic( pCol ) --self.fastStopMusicTag
end

----------------------- pick game -----------------------
ActivityRoyalPuppiesFreePick = class("ActivityRoyalPuppiesFreePick", CCSNode) 
local pickGame = ActivityRoyalPuppiesFreePick

local FG_MAP_CONFIG = {
    -- # 0:add reels # 1:wild reel # 2:add arow # 3:+ freegame # 4:credits #5:go to
    [1]= {0,1,0.1},[2]= {4,0.3,0.3},[3]= {3,2,0.1},[4]= {4,0.2,0.2},[5]= {0,1,0.1},[6]= {4,0.3,0.3},
    [7]= {3,3,0.1},[8]= {4,0.2,0.2},[9]= {1,1,0.1},[10]={4,0.3,0.3},[11]={3,1,0.1},[12]={4,0.2,0.2},
    [13]={1,1,0.1},[14]={4,0.1,0.1},[15]={3,2,0.1},[16]={4,0.3,0.3},[17]={0,1,0.1},[18]={4,0.2,0.2},
    [19]={3,1,0.1},[20]={5,0.3,0.3},[21]={1,1,0.1},[22]={4,0.2,0.2},[23]={3,1,0.1},[24]={4,0.3,0.3},
    [25]={3,2,0.1},[26]={4,0.2,0.2},[27]={3,1,0.1},[28]={5,0.3,0.3},[29]={1,1,0.1},[30]={4,0.2,0.2},
    [31]={3,3,0.1},[32]={4,0.3,0.3},[33]={2,1,0.1},[34]={4,0.2,0.2},[35]={3,1,0.1},[36]={4,0.3,0.3}
}
local fg_map_pos = {
	cc.p(-128,-327),	cc.p(-201,-282),
	cc.p(-246,-217),	cc.p(-261,-140),
	cc.p(-188,-90),		cc.p(-105,-103),
	cc.p(-20,-134),		cc.p(58,-165),
	cc.p(150,-180),		cc.p(226,-156),
	cc.p(276,-89),		cc.p(221,-25),
	cc.p(132,-17),		cc.p(44,-14),
	cc.p(-42,-2),		cc.p(-114,48),
	cc.p(-81,127),		cc.p(2,152),
	cc.p(94,152),		cc.p(179,135),
	cc.p(263,142),		cc.p(288,218),
	cc.p(222,274),		cc.p(138,284),
	cc.p(51,281),		cc.p(-32,264),
	cc.p(-116,244),		cc.p(-205,234),
	cc.p(-282,266),		cc.p(-272,342),
	cc.p(-202,391),		cc.p(-113,395),
	cc.p(-19,388),		cc.p(71,380),
	cc.p(164,395),		cc.p(220,461),			cc.p(157,490),
}
local fg_map_feature_pos = Set({1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35})
local fg_map_feature_idx = {[1]=1,[3]=2,[5]=3,[7]=4,[9]=5,[11]=6,[13]=7,[15]=8,[17]=9,[19]=10,[21]=11,[23]=12,[25]=13,[27]=14,[29]=15,[31]=16,[33]=17,[35]=18}
local fg_map_back_pos = {[20]=13,[28]=5}

local wildColPosBase= {[3] = 20,[4]=30}
local endFreeCntPos	= cc.p(-215,546)

local ReelRowData 	= {
	[3] = {
		["width"] 	= 148,
		["height"] 	= 86,
		["reelPic"] = "#theme3128_map_6.png",
		["wildPic"] = "#theme3128_map_4.png",
		["wildBasePos"] = cc.p(2.75,86/2),
		["wildWidth"] = 28.5,
	},
	[4] = {
		["width"] 	= 148,
		["height"] 	= 103,
		["reelPic"] = "#theme3128_map_3.png",
		["wildPic"] = "#theme3128_map_2.png",
		["wildBasePos"] = cc.p(2.75,103/2),
		["wildWidth"] = 28.5,
	},
}
local ReelScale 	= {[1] = 1,[2] = 0.7,[3] = 0.52,[4]=0.52}
local moveRoadData = {
	[5] 	= {["pos"] = {cc.p(-276,90),cc.p(-209,-20),cc.p(-188,-90)},["spineName"] = "animation2",["spineName2"] = "animation2_2"}, 
	[13] 	= {["pos"] = {cc.p(132,-17)},["spineName"] = "animation1",["spineName2"] = "animation1_1"}
}

function pickGame:ctor(theme, csbPath, data, callback,tryResume)
	self.theme 	   	   = theme
	self.csbPath       = csbPath
	self.csb 		   = csbPath .. "free_map.csb"
	self.data          = data
	self.ctl 		   = theme.ctl

	CCSNode.ctor(self, self.csb)
	self:initLayout(tryResume)
	self.callback = function ()
		self.ctl.rets.free_spins = self.data.free_cnt
		self.theme.freeBoardCnt = self.data.add_reels -- 对Free 数据 进行 赋值
		self.theme.freeColCnt = self.data.add_row 
		self.theme.freeWildReelPos = self.data.wild_reel 
		-- self.theme.cookieCount = self.data.cookie_count 

		callback()
		self:addData("end_game",true) -- 保存数据 不在进入-- LoginControl:getInstance():savePick(self.theme.themeid, nil)
	end
end

function pickGame:addData(key,value)
	self.data[key] = value
	self:savePick()
end
function pickGame:savePick()
	LoginControl:getInstance():savePick(self.theme.themeid, self.data)
end

function pickGame:initLayout(tryResume)
	self.theme.curScene:addToContentFooter(self)
	if SHRINKSCALE_H < 0.8 then
		self:setScale(self:getScale()-0.02)
	end
	self.startRoot = self.node:getChildByName("node_start")
	if tryResume then 
		self.pickWin = self.data.base_win or 0
	else
		self.pickWin = self.ctl.totalWin or 0 
	end
	self.ctl.totalWin = 0
	self.ctl.rets["win_type"] = nil
	self.ctl.rets["total_win"] = 0
    if self.theme.superAvgBet then 
    	self.ctl:setPointBet(self.theme.superAvgBet)
    end

	self.baseBet = self.ctl:getCurTotalBet()
	if self.startRoot then
		if not tryResume then 
			self.data.core_data = {}
		end
		self.featurePosParent = self.startRoot:getChildByName("pos_list")
		self.mapFeatureList = self.featurePosParent:getChildren()
		self.diceBtn 		= self.startRoot:getChildByName("dice_btn")  -- 骰子按钮
		self.freeCntLabel	= self.startRoot:getChildByName("free_cnt")  -- free 次数

		self.moveNode		= self.startRoot:getChildByName("move_node") -- 移动节点
		self.reelRoot		= self.startRoot:getChildByName("reel_root") -- 小棋盘节点
		self.diceSp			= self.startRoot:getChildByName("dice_sp") 
		self.diceParticle		= self.startRoot:getChildByName("dice_particle") 
		self.freeParticle		= self.startRoot:getChildByName("free_particle") 
		self.diceParticle:setVisible(false)
		self.freeParticle:setVisible(false)
		self.theme:addSpineAnimation(self.startRoot:getChildByName("spine"), nil, self.theme:getPic("spine/map/map_01"), cc.p(0,0), "animation",nil,nil,nil,true,true)-- 播放爆炸特效
		
		local _,s2 = self.theme:addSpineAnimation(self.startRoot:getChildByName("spine"), nil, self.theme:getPic("spine/map/sz_01"), cc.p(227,-347), "animation1",nil,nil,nil,true)-- 播放爆炸特效
		self.mapDiceSpine = s2
		self.mapDiceSpine:setVisible(false)
		local _,s3 = self.theme:addSpineAnimation(self.moveNode, nil, self.theme:getPic("spine/map/gouzi01"), cc.p(-4,-19), "animation1",nil,nil,nil,true,true)-- 播放爆炸特效
		self.mapMoveSpine = s3

		self.touchIndex = self.data.core_data["touchIndex"] or 0
		local count = self.touchIndex
		while count>0 do 
			if #self.data.dice_list>0 then 
				local item = table.remove(self.data.dice_list,1) 
			end
			count = count -1 
		end
		self.collectData	= self.data.core_data["collectData"] or {}
		for _key=1,#FG_MAP_CONFIG do
			local cnt = self.collectData[_key] or 0 -- 对选中的 计数进行显示
			if cnt>0 and fg_map_feature_pos[_key] then -- 隐藏 地图上 feature 显示
				local idx = fg_map_feature_idx[_key]
				if idx and self.mapFeatureList[idx] then 
					self.mapFeatureList[idx]:setVisible(false)
				end
			end
			self.collectData[_key] = cnt
		end
		-- 显示位置
		if self.touchIndex > 0 then 
			endPos = self.data.pos_list[self.touchIndex]
			if endPos ~= 0 then 
				if endPos >37 then endPos = 37 end
				self.moveNode:setPosition(fg_map_pos[endPos])
			end
		end
		-- 显示路
		self.overRoad = self.data.core_data["overRoad"] or {}
		for k,v in pairs(self.overRoad) do 
			local moveDataList = moveRoadData[v]
			self.theme:addSpineAnimation(self.startRoot:getChildByName("spine"), nil, self.theme:getPic("spine/map/xianshilu_01"), cc.p(0,0), moveDataList.spineName2,nil,nil,nil,true)-- 播放爆炸特效
		end

		-- 显示 小棋盘
		self.curFreeCnt = self.data.core_data["curFreeCnt"] or 5
		self.curWildCnt = self.data.core_data["curWildCnt"] or 0
		self.curReelCnt = self.data.core_data["curReelCnt"] or 1
		self.curRowCnt 	= self.data.core_data["curRowCnt"] or 3
		self.curCoinsMutl = self.data.core_data["curCoinsMutl"] or 0

		self.pickWin = self.pickWin + self.curCoinsMutl*self.baseBet
		self.freeCntLabel:setString(self.curFreeCnt)
		
		self:updateReelState()
	end
	self.ctl.footer:reSetWinCoinsString(self.pickWin, 0, 0)--footer 加钱
	self.curDice = 6

	self.data["touchIndex"] 	= self.touchIndex-- 保存数据
	self.data["collectData"] 	= self.collectData
	self.data["curFreeCnt"] 	= self.curFreeCnt
	self.data["curWildCnt"] 	= self.curWildCnt
	self.data["curReelCnt"] 	= self.curReelCnt
	self.data["curRowCnt"] 		= self.curRowCnt
	self.data["curCoinsMutl"] 	= self.curCoinsMutl
	self.data["overRoad"] 		= self.overRoad
	self:savePick()

	self.data.core_data = {} -- 清除数据
	self:setVisible(false)
end

function pickGame:updateReelState()
	self.reelRoot:setScale(ReelScale[self.curReelCnt])
	if self.curReelCnt==1 then 
		local reeldata = ReelRowData[self.curRowCnt]
		self:createSingleReel(cc.p(0,0),reeldata)
	elseif self.curReelCnt==2 then
		local reeldata = ReelRowData[self.curRowCnt]
		self:createSingleReel(cc.p(0,reeldata.height/2),reeldata)
		self:createSingleReel(cc.p(0,-reeldata.height/2),reeldata)
	elseif self.curReelCnt==3 then
		local reeldata = ReelRowData[self.curRowCnt]
		self:createSingleReel(cc.p(0                , reeldata.height/2),reeldata)
		self:createSingleReel(cc.p(-reeldata.width/2,-reeldata.height/2),reeldata)
		self:createSingleReel(cc.p(reeldata.width/2 ,-reeldata.height/2),reeldata)
	elseif self.curReelCnt==4 then
		local reeldata = ReelRowData[self.curRowCnt]
		self:createSingleReel(cc.p(-reeldata.width/2, reeldata.height/2),reeldata)
		self:createSingleReel(cc.p(reeldata.width/2 , reeldata.height/2),reeldata)
		self:createSingleReel(cc.p(-reeldata.width/2,-reeldata.height/2),reeldata)
		self:createSingleReel(cc.p(reeldata.width/2 ,-reeldata.height/2),reeldata)
	end
end

function pickGame:createSingleReel(pos,reeldata,parent)
	local _floor = bole.createSpriteWithFile(reeldata.reelPic)
	_floor:setPosition(pos)
	if self.curWildCnt>0 then 
		for k=1,self.curWildCnt do 
			local col = self.data.wild_reel[k]
			if col then 
				local _colWild = bole.createSpriteWithFile(reeldata.wildPic)
				local pos = cc.pAdd(reeldata.wildBasePos,cc.p((col-0.5)*reeldata.wildWidth,0))
				_colWild:setPosition(pos)
				_floor:addChild(_colWild)
			end
		end
	end
	local parent = parent or self.reelRoot
	parent:addChild(_floor)
end

function pickGame:enterPickGame(tryResume)
	local function playIntro() -- 第一次进入
		self:addData("touchIndex", 0) --	第一次进入初始化为0
		self:showStartPickDialog()
	end

	local function snapIntro() -- 重连进入
		-- 断线重连的 回调方法
		local function startSpin()
			self:showPickNode()
			self.theme:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function ( ... )
				if #self.data.dice_list>0 then 
					self:openEvent()
				else
					self:finshPickGame(true)
				end
    		end)))
		end
    	startSpin()
	end

	if tryResume then 
    	snapIntro()
    else
		playIntro()
    end
end

function pickGame:updateOverChoose(endDice)
 	-- 进行移动 小熊
	self:showMovePuppies(endDice)
end

function pickGame:showMovePuppies(endDice)
	local curPos 	= self.data.pos_list[self.touchIndex] or 0
	local endPos 	= curPos + endDice
	
	local collectCnt = self.collectData[endPos] or 0
	if collectCnt<1 and fg_map_back_pos[endPos] then 
		self.haveRunRoad = fg_map_back_pos[endPos]
	end

	local actionList = {}
	if endDice > 0 then 
		for k = curPos+1,endPos do 
			if k>37 then break end
			local t0 = cc.CallFunc:create(function()
							self.theme:playMusic(self.theme.audio_list.dog1)
							bole.spChangeAnimation(self.mapMoveSpine,"animation2")
						end)
			local t1 = cc.MoveTo:create(15/30,fg_map_pos[k])
			local t11 = cc.DelayTime:create(10/30)
			local t12 = cc.CallFunc:create(function ( ... )
				bole.spChangeAnimation(self.mapMoveSpine,"animation1",true)
			end)
			table.insert(actionList,t0)		
			table.insert(actionList,t01)		
			table.insert(actionList,t1)		
			table.insert(actionList,t11)		
			table.insert(actionList,t12)		
		end
	end
	
	local diceData 	= FG_MAP_CONFIG[endPos] -- # 0:add reels # 1:wild reel # 2:add arow # 3:+ freegame # 4:credits
	local winData 	= {}
	if not diceData and endPos > 36 then 
		local t3 = cc.CallFunc:create(function()
						self:finshPickGame()
					end)
		table.insert(actionList,t3)	
	else
		if collectCnt <1 then 
			if diceData[1] == 0 then 
				winData["type"] 	= diceData[1]
				winData["value"] 	= self.curReelCnt + diceData[2]
				self.curReelCnt 	= self.curReelCnt + diceData[2]
			elseif diceData[1] == 1 then 
				winData["type"] 	= diceData[1]
				winData["value"] 	= self.curWildCnt + diceData[2]
				self.curWildCnt 	= self.curWildCnt + diceData[2]
			elseif diceData[1] == 2 then 
				winData["type"] 	= diceData[1]
				winData["value"] 	= self.curRowCnt + diceData[2]
				self.curRowCnt 		= self.curRowCnt + diceData[2]
			elseif diceData[1] == 3 then 
				winData["type"] 	= diceData[1]
				winData["value"] 	= self.curFreeCnt + diceData[2]
				self.curFreeCnt 	= self.curFreeCnt + diceData[2]
			elseif diceData[1] == 5 then 
				winData["type"] 	= diceData[1]
				winData["value"] 	= diceData[3]
				self.curCoinsMutl 	= self.curCoinsMutl + diceData[3]
			else
				winData["type"] 	= 4
				winData["value"] 	= diceData[3]
				self.curCoinsMutl 	= self.curCoinsMutl + diceData[3]
			end
		else
			winData["type"] 	= 4
			winData["value"] 	= diceData[3]
			self.curCoinsMutl 	= self.curCoinsMutl + diceData[3]
		end
		local t2 = cc.CallFunc:create(function()
						self:showCollectItemAnim(endPos,winData)
					end)
		table.insert(actionList,t2)	
	end
	if endDice > 0 then 
		self.touchIndex = self.touchIndex + 1
	end
	self.collectData[endPos] = collectCnt +1
	self.data["touchIndex"] 	= self.touchIndex-- 保存数据
	self.data["collectData"] 	= self.collectData
	self.data["curFreeCnt"] 	= self.curFreeCnt
	self.data["curWildCnt"] 	= self.curWildCnt
	self.data["curReelCnt"] 	= self.curReelCnt
	self.data["curRowCnt"] 		= self.curRowCnt
	self.data["curCoinsMutl"] 	= self.curCoinsMutl
	self:savePick()

	self.moveNode:runAction(cc.Sequence:create(bole.unpack(actionList)))
end

local flyFeatureTime = 40/60
local endScale = 0.5
function pickGame:showCollectItemAnim(endPos,winData) -- -- # 0:add reels # 1:wild reel # 2:add arow # 3:+ freegame # 4:credits
	if winData.type < 4 then
		local moveEndPos = cc.p(0,0)
		local laterFunc  = function ()  end
		local animNode 	 = nil
		if winData.type >= 0 and winData.type <=2 then 
			moveEndPos = cc.p(self.reelRoot:getPosition())
			animNode = self.reelRoot
			laterFunc = function ( ... )
				self.freeParticle:setPosition(moveEndPos)
				self.freeParticle:setVisible(true)
				self.freeParticle:resetSystem()
				self.reelRoot:removeAllChildren()
				self:updateReelState()
			end	
			self.theme:playMusic(self.theme.audio_list.fly3)
		elseif winData.type == 3 then 
			moveEndPos = cc.p(self.freeCntLabel:getPosition())
			animNode = self.freeCntLabel
			laterFunc = function ( ... )
				self.freeParticle:setPosition(moveEndPos)
				self.freeParticle:setVisible(true)
				self.freeParticle:resetSystem()
				self.freeCntLabel:setString(self.curFreeCnt)
			end	
			self.theme:playMusic(self.theme.audio_list.fly4)
		end

		local featureNode = self.mapFeatureList[fg_map_feature_idx[endPos]]
		featureNode:setLocalZOrder(100)
		local endPos1 = bole.getWorldPosByPos(self.startRoot,moveEndPos)
		local endPos2 = bole.getNodePos(featureNode,endPos1)

		local flyNode = featureNode:getChildren()[2]
		local s1 = cc.ParticleSystemQuad:create(self.theme:getPic("particle/tuowei_01_1.plist"))
		flyNode:addChild(s1,-1)
		s1:setPosition(cc.p(flyNode:getContentSize().width/2, flyNode:getContentSize().height/2))

		featureNode:runAction(cc.Sequence:create(cc.DelayTime:create(flyFeatureTime-0.2),cc.FadeTo:create(0.2,0)))
		flyNode:runAction(cc.Sequence:create(
			cc.Spawn:create(cc.MoveTo:create(flyFeatureTime,endPos2),cc.ScaleTo:create(flyFeatureTime,endScale)),
			cc.CallFunc:create(function()
				s1:setEmissionRate(0) -- 设置发射速度为不发射
				if laterFunc then 
					laterFunc()
				end
			end),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function()
				self:checkIsOver()
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				s1:removeFromParent()
			end)))
	else
		if not self.flyTopLayer then
			self.flyTopLayer = cc.Node:create()
			bole.scene:addToTop(self.flyTopLayer)
			self.flyTopLayer:setPosition(-640,-360)
		end
		self.flyTopLayer:removeAllChildren()
		local moveStartPos1 = bole.getWorldPosByPos(self.featurePosParent,fg_map_pos[endPos])
		local moveStartPos= bole.getNodePos(self.flyTopLayer,moveStartPos1)
		local _footerPos  = bole.getWorldPos(self.ctl.footer.winNode)
		local moveEndPos2 = bole.getNodePos(self.flyTopLayer,_footerPos)   
		
		self.theme:playMusic(self.theme.audio_list.coin)
		local s1 = cc.ParticleSystemQuad:create(self.theme:getPic("particle/tuowei_01_1.plist"))
		self.flyTopLayer:addChild(s1,-1)
		s1:setPosition(moveStartPos)

		s1:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				local fntLabel = cc.Label:createWithBMFont(self.theme:getPic("font/theme128_font_map_1.fnt"),FONTS.formatByCount2(winData.value*self.baseBet,6,true))
				fntLabel:setPosition(moveStartPos)
				-- fntLabel:setString(winData.value*self.baseBet)
				self.flyTopLayer:addChild(fntLabel)
				fntLabel:setOpacity(0)
				fntLabel:runAction(cc.Sequence:create(
					cc.FadeTo:create(0.2,255),
					cc.DelayTime:create(1.3),
					cc.Spawn:create(cc.MoveTo:create(flyFeatureTime,moveEndPos2),cc.ScaleTo:create(flyFeatureTime,0.2)),
					cc.RemoveSelf:create()))
			end),
			cc.DelayTime:create(1.5),
			cc.MoveTo:create(flyFeatureTime,moveEndPos2),
			cc.CallFunc:create(function()
				s1:setEmissionRate(0) -- 设置发射速度为不发射
				self.ctl.footer:setWinCoins(winData.value*self.baseBet, self.pickWin, 0)--footer 加钱
				self.pickWin = self.pickWin + winData.value*self.baseBet
				self:checkIsOver()
			end),
			cc.DelayTime:create(0.2),
			cc.RemoveSelf:create()))
	end
end

function pickGame:finshPickGame(tryResume)
	local delay = 2
	if tryResume then 
		delay =0.5 
	else
		self.theme:playMusic(self.theme.audio_list.map_end)
	end
	self:runAction(cc.Sequence:create(-- 显示弹窗 FREE 次数
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ( ... )
			self:showFinshPickDialog()
		end)
	))
end

function pickGame:playEndDialogClickEnd()
	self.ctl.totalWin = self.pickWin

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ()-- 执行关闭动画
			local action = cc.CSLoader:createTimeline(self.theme:getPic("csb/free_dialog.csb"))
			self.finshPickDialog:runAction(action)
			action:gotoFrameAndPlay(90, 120, false)
			self.theme:playMusic(self.theme.audio_list.common_dialog_close)
			
			self.node:runAction(cc.FadeTo:create(0.5,0))
		-- end),
		-- cc.DelayTime:create(0.5),
		-- cc.CallFunc:create(function () -- 执行回调 
			self.callback()
			if self.finshPickDialog then
				self.finshPickDialog:removeFromParent()
			end
			self.node:setVisible(false)
		end),
		cc.DelayTime:create(1),
		cc.RemoveSelf:create()))
end

function pickGame:showFinshPickDialog( ) 
	local path = self.theme:getPic("csb/free_dialog.csb")
	self.finshPickDialog = cc.CSLoader:createNode(path)
	local rootNode 	 = self.finshPickDialog:getChildByName("root")
	rootNode:getChildByName("node_collect"):setVisible(false)
	local showNode = rootNode:getChildByName("node_start")
	local startBtn 	 = showNode:getChildByName("btn_start")
	local showNormal = showNode:getChildByName("node_normal")
	local reelNode 	 = showNormal:getChildByName("reel_sp")
	local freeCntLb  = showNormal:getChildByName("count")
	local reelCntSP  = showNormal:getChildByName("cnt_sp")
	-- 显示中奖的滚轴
	local reeldata = ReelRowData[self.curRowCnt]
	self:createSingleReel(cc.p(0,0),reeldata,reelNode)
	reelNode:setScale(0.7)
	-- 更新free 次数计数
	freeCntLb:setString(self.curFreeCnt)
	bole.updateSpriteWithFile(reelCntSP,"#theme3128_popup_free_cnt" .. self.curReelCnt .. ".png")
	-- 添加特效
	self.theme:addSpineAnimation(showNode:getChildByName("spine"),nil, self.theme:getPic("spine/dialog/fr_tk_01"), cc.p(0,0), "animation1", nil, nil, nil, true, true)-- 背景特效
	self.theme:addSpineAnimation(showNode:getChildByName("spine2"),nil, self.theme:getPic("spine/dialog/anniu_01"), cc.p(0,0), "animation", nil, nil, nil, true, true)-- 添加按钮
	self.theme:addSpineAnimation(showNode:getChildByName("spine2"),nil, self.theme:getPic("spine/dialog/fr_tk_02"), cc.p(8,529), "animation", nil, nil, nil, true, true)-- 背景特效
	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(path)
		self.finshPickDialog:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end
	self.theme.curScene:addToContentFooter(self.finshPickDialog)
	local touchOver 	= false  -- 按钮状态 控制
	playLine(0, 30)
	self.theme:playMusic(self.theme.audio_list.fg_dialog)
	local function touchEvent(sender,eventType)			
		if eventType == ccui.TouchEventType.ended then
			if not touchOver then 
				touchOver = true
				startBtn:setBright(false)
				startBtn:setTouchEnabled(false)
				self.theme:playMusic(self.theme.audio_list.common_dialog_click)
				-- 向服务器发送 协议
				self.ctl:collectCoins(3)
			end
		end
	end
	rootNode:runAction(cc.Sequence:create(
		cc.DelayTime:create(1), 
		cc.CallFunc:create(function ()
			startBtn:addTouchEventListener(touchEvent)
		end)
	))
end

function pickGame:openEvent()
	self.isClick = false
	local function onTouch(obj, eventType)
		if self.isClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			self.isClick = true
	    	self.diceSp:stopAllActions()
	    	self.diceSp:setRotation(0)
	    	-- print("whj: onTouch -> self.isShowTip ,self.mapTip ",self.isShowTip ,self.mapTip)
	    	if self.isShowTip and self.mapTip then 
	    		bole.spChangeAnimation(self.mapTip,"animation3",false)
	    	end
	    	self.isShowTip = false
	    	self:playDiceAnim()
		end
	end
	-- 设置按钮的点击事件
	self.diceBtn:addTouchEventListener(onTouch)
	-- 添加 引导用户点击
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(2),
		cc.CallFunc:create(function ( ... )
			if not self.isClick then 
				-- print("whj: 111111 self.isShowTip ,self.isClick ",self.isShowTip,self.isClick)
				self:playTipAnim()				
			end
		end)
	))
end

function pickGame:playTipAnim()
	self.isShowTip = true
	-- print("whj: 222222 self.isShowTip ,self.isClick ",self.isShowTip,self.isClick)
	if not self.mapTip then 
		local _,s = self.theme:addSpineAnimation(self, nil, self.theme:getPic("spine/map/sz_zhishi_01"), cc.p(0,0), "animation1",nil,nil,nil,true)-- 桥消失动画
		self.mapTip = s
	else
		bole.spChangeAnimation(self.mapTip,"animation1",false)
	end
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function ( ... )
			-- print("whj: 333333 self.isShowTip ,self.isClick ",self.isShowTip,self.isClick)
			if self.isShowTip then 
				bole.spChangeAnimation(self.mapTip,"animation2",true)
			end
		end)
	))
	self.diceSp:runAction(cc.RepeatForever:create(cc.Sequence:create(
			cc.RotateTo:create(10/60,-15),
			cc.RotateTo:create(10/60,7),
			cc.RotateTo:create(8/60,-5),
			cc.RotateTo:create(7/60,4),
			cc.RotateTo:create(5/60,0),
			cc.DelayTime:create(1)
		)))
end

function pickGame:playDiceAnim()
	local endDice 	= table.remove(self.data.dice_list,1)-- 获得点击之后的结果
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... ) -- 播放 骰子动画
			self.theme:playMusic(self.theme.audio_list.dice_spin)
			self.diceSp:setVisible(false)
			self.mapDiceSpine:setVisible(true)
			self.diceParticle:setVisible(true)
			self.diceParticle:resetSystem()
			bole.spChangeAnimation(self.mapDiceSpine,"animation" .. self.curDice,false)
		end),
		cc.DelayTime:create(48/30),
		cc.CallFunc:create(function ( ... )
			self.theme:playMusic(self.theme.audio_list.dice_stop)
			bole.updateSpriteWithFile(self.diceSp,("#theme3128_map_dice" .. endDice .. ".png")) -- 修改图片
			self.curDice = endDice
			self.diceSp:setVisible(true)
			self.mapDiceSpine:setVisible(false)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function ( ... )
			self.diceParticle:setVisible(false)
			self:updateOverChoose(endDice)
		end)))
end

function pickGame:checkIsOver()
	if self.haveRunRoad and table.find(self.overRoad,self.haveRunRoad) == -1 then 
		table.insert(self.overRoad,self.haveRunRoad)
		self:addData("overRoad",self.overRoad)
		local moveDataList = moveRoadData[self.haveRunRoad]
		self.haveRunRoad = false
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function ()
				-- 播放移动动画
				local moveList = {}
				local moveTime = 1/#moveDataList.pos
				for k,v in pairs(moveDataList.pos) do 
					local t1 = cc.MoveTo:create(moveTime,v)
					table.insert(moveList,t1)
				end
				self.theme:playMusic(self.theme.audio_list.dog2)
				self.moveNode:runAction(cc.Sequence:create(bole.unpack(moveList)))
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ( ... )
				self.theme:addSpineAnimation(self.startRoot:getChildByName("spine"), nil, self.theme:getPic("spine/map/xianshilu_01"), cc.p(0,0), moveDataList.spineName,nil,nil,nil,true)-- 桥消失动画
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ( ... )
				self:showMovePuppies(0)
			end)))
	else
		if #self.data.dice_list>0 then 
			self.isClick = false
			-- 添加 引导用户点击
			self:runAction(cc.Sequence:create(
				cc.DelayTime:create(2),
				cc.CallFunc:create(function ( ... )
					if not self.isClick then 
						self:playTipAnim()				
					end
				end)
			))
		else
			self:finshPickGame()
		end
	end
	
end


function pickGame:transitionOverFunc( ... )	
	if #self.data.dice_list>0 then 
		self:openEvent()
	else
		self:finshPickGame(true)
	end
end

function pickGame:showStartPickDialog(endFunc)
	self.ctl.footer:setSpinButtonState(true)
	local dialog = cc.CSLoader:createNode(self.theme:getPic("csb/map_start.csb"))--  加载 进入respin 的弹板
	local rootNode = dialog:getChildByName("root")
	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(self.theme:getPic("csb/map_start.csb"))
		dialog:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end
	self.theme:addSpineAnimation(rootNode:getChildByName("spine"), nil, self.theme:getPic("spine/dialog/fr_tk_01"), cc.p(0.5,36), "animation2", nil, nil, nil, true,true)-- 播放 结果动画
	bole.scene:addToContentFooter(dialog)

	dialog:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			playLine(0, 30)
			self.theme:playMusic(self.theme.audio_list.map_dialog)
		end),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function ()
			playLine(90, 120)
			self.theme:playMusic(self.theme.audio_list.common_dialog_close)
			self.theme:stopMusic(self.theme.audio_list.retrigger_bell, true)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function ( ... )
	    	self.theme:playMusic(self.theme.audio_list.transition1)-- 播放转场
	    	self.theme:stopMusic(self.theme.audio_list.retrigger_bell, true) -- 停止打铃声
	    	local endFunc = function ( ... )
	    		self:transitionOverFunc()
	    	end
			self.theme:playTransition(endFunc,"free")
		end),
		cc.DelayTime:create(25/30), -- 切屏覆盖全屏时间
		cc.CallFunc:create(function ( ... )
	    	self:showPickNode()
		end),
		cc.RemoveSelf:create()
	))
end

function pickGame:showPickNode( ... )
	self:setVisible(true)
	self.node:setVisible(true)
	self.startRoot:setOpacity(0)
	self.theme:dealMusic_PlayPickLoopMusic()
	self.startRoot:runAction(cc.FadeIn:create(0.5))
end

return ThemeActivityRoyalPuppies

