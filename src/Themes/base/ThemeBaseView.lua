

ThemeBaseView = class("ThemeBaseView", function() return cc.Node:create() end)

local themeBView = ThemeBaseView


ThemeBaseView.Tags = {
	Floor = 30000,
}

function themeBView:ctor( ctl )
	self._mainViewCtl = ctl

	-- EventCenter:registerEvent(EVENTNAMES.THEME.STOP_ANIM, "theme_base_view", self.stopDrawAnimate, self)
end

function themeBView:setControl( ctl )	
	self.ctl = ctl
	self.spinActionConfig = self.spinActionConfig or {
		["spin_index"] = 2,
		["stop_index"] = 2,
		["fast_stop_index"] = 2,
	}
end

function themeBView:init()
	self:initLayout()
	self:initSpinLayer()	
	self:initFreeSpinNode()
	self:initSpecialFreatureNode()
	self:refreshColCellsZOrder()
	self:modifyThemeLayout()
end

function themeBView:initLayout( )
	local s = cc.Director:getInstance():getWinSize()
	self.shakyNode = cc.NodeGrid:create()
	self:addChild(self.shakyNode)

	-- 初始化 场景
	self:initScene(self)

	local l_bg_zOrder 	  = 1
	local l_board_zOrder  = 3
	local l_modify_zOrder = 5
	local l_effect_zOrder = 7
	if not self.bgRoot then
		self.bgRoot 	 = cc.Node:create()
		self:addChild(self.bgRoot, l_bg_zOrder)
	end	

	-- 棋盘层
	if not self.boardRoot then
		self.boardRoot 	 = cc.Node:create()
		self:addChild(self.boardRoot, l_board_zOrder)
	end
	-- modify_node
	self.modifyNode  = cc.Node:create()
	self:addChild(self.modifyNode, l_modify_zOrder)
	-- 动画层
	if not self.animateNode then
		self.animateNode = cc.Node:create()
		self:addChild(self.animateNode,l_effect_zOrder)	
	end

	-- 多主题商店层
	if self.store_data and not self.storeCoinsNode then
		self.storeCoinsNode = cc.Node:create()
		self:addChild(self.storeCoinsNode,l_effect_zOrder)	
	end

	self:initSpinLayerBg()
		-- 初始化各个棋盘
	local boardConfigList 	= self._mainViewCtl:getBoardConfig()
	self.boardNodeList = self:initBoardNodes(boardConfigList)	
end

function themeBView:removeWareEffect()

	if self.renderNode then
		self.renderNode:setVisible(true)
	end

	if self.renderTexture then
		self.renderTexture:release()
		self.renderTexture = nil
	end	

	if self.pgeRippleSprite then
		self.pgeRippleSprite:removeFromParent(true)
		self.pgeRippleSprite = nil
	end
end

function themeBView:addWareEffect()
	if self.isWaving then
		return
	end

	self.isWaving = true

	self:removeWareEffect()

	-- self.shakyNode
	local renderNode = self.shakyNode
	local renderNodeZOrder = renderNode:getLocalZOrder()
	self.renderNode = renderNode

	local winSize = cc.Director:getInstance():getWinSize()
	self.renderTexture = cc.RenderTexture:create(winSize.width, winSize.height, 2, 0x88f0)
	self.renderTexture:retain()

	self.renderNode:setPosition(cc.p(winSize.width/2, winSize.height/2))
	self.renderTexture:beginWithClear(0, 0, 0, 0)
	self.renderNode:visit()
	self.renderTexture:endToLua()
	self.renderNode:setPosition(cc.p(0, 0))

	-- self.pgeRippleSprite = cc.Sprite:createWithTexture(self.renderTexture:getSprite():getTexture())
	-- self:addChild(self.pgeRippleSprite, renderNodeZOrder)
	self.pgeRippleSprite = cc.PgeRippleSprite:create(self.renderTexture:getSprite():getTexture())
	self:addChild(self.pgeRippleSprite, renderNodeZOrder)
	self.pgeRippleSprite:setScaleY(-1)
	self.pgeRippleSprite:setPositionY(winSize.height/2)
	self.pgeRippleSprite:setPositionX(-winSize.width/2)

	local count = 0
	self.pgeRippleSprite:setVisible(false)

	local function update(dt)
		if self.renderTexture then
			count = count + 1
			
			self.renderNode:setVisible(true)
			self.renderNode:setPosition(cc.p(winSize.width/2, winSize.height/2))
			self.renderTexture:beginWithClear(0, 0, 0, 0)
			self.renderNode:visit()
			self.renderTexture:endToLua()
			self.renderNode:setPosition(cc.p(0, 0))
		
			if count >= 3 then
				self.renderNode:setVisible(false)
				self.pgeRippleSprite:setVisible(true)
			end
		end
    end
	local timerNode = cc.Node:create()
	self.pgeRippleSprite:addChild(timerNode)
    timerNode:scheduleUpdateWithPriorityLua(update, 0)

	-- local pos = cc.p(self.longball_10:getPosition())
	-- local pos1 = self.longball_10:getParent():convertToWorldSpace(pos)
	-- local pos2 = self:convertToNodeSpace(pos1)
	-- self.pgeRippleSprite:addRipple(cc.p(pos2.x, display.height - pos2.y), 2, 4)
	self.pgeRippleSprite:addRipple(cc.p(winSize.width/2, winSize.height/2), 2, 4)

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(2.1), 
		cc.CallFunc:create(function()
			self:removeWareEffect()
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.isWaving = false
			self:addWareEffect()
		end)
	))

end


function themeBView:initScene(spinLayer)
	-- body
end

function themeBView:initBoardNodes(pBoardConfigList)
	local boardRoot 	  = self.boardRoot
	local boardConfigList = pBoardConfigList or self._mainViewCtl:getBoardConfig() or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	-- 棋盘初始化
	for boardIndex, theConfig in pairs(boardConfigList) do
		local theBoardNode 	= nil
		local reelNodes = {}
		
		theBoardNode = cc.Node:create()
		boardRoot:addChild(theBoardNode)

		if theConfig["row_single"] then -- 一行使用一个裁剪区域 等距才可以
			self:initBoardNodesByRowSingle(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

		elseif theConfig["single"] then
			self:initBoardNodesBySingle(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

		elseif theConfig["reel_single"] then -- 一个棋盘用一个裁剪区域
			self:initBoardNodesByReelSingle(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

		elseif theConfig["show_parts"] then -- 一个棋盘用一个裁剪区域
			self:initBoardNodesByParts(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

		else
			self:initBoardNodesByNormal(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

		end		
	
		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		pBoardNodeList[boardIndex] = theBoardNode
	end

	self:initBoardTouchBtn(boardConfigList, pBoardNodeList)

	return pBoardNodeList
end

function themeBView:initBoardTouchBtn(boardConfigList, pBoardNodeList)
end

function themeBView:initBoardNodesByRowSingle( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	local rowReelCnt = theConfig["rowReelCnt"]
	local index = 0
	local clipNode = nil
	local reelNode = nil
	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		 
		if (reelIndex-1)%rowReelCnt == 0 then 
			reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
				
			local vex = {
			config["base_pos"], -- 第一个轴的左下角  下左边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt, 0)),  -- 下右边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt, config["cellHeight"])),-- 上右边界
				cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
			}
			local stencil = cc.DrawNode:create()
			stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

			local clipAreaNode = cc.Node:create()
			clipAreaNode:addChild(stencil)
			clipNode = cc.ClippingNode:create(clipAreaNode)
		   
			theBoardNode:addChild(clipNode)	
			clipNode:addChild(reelNode)
		end
		reelNodes[reelIndex] = reelNode
	end
end

function themeBView:initBoardNodesBySingle( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		local reelNode = cc.Node:create()
		reelNode:setLocalZOrder(reelZorder)
		local vex = {
			config["base_pos"], -- 第一个轴的左下角  下左边界
			cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
			cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"])),-- 上右边界
			cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
		}
		local stencil = cc.DrawNode:create()
		stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		local clipAreaNode = cc.Node:create()
		clipAreaNode:addChild(stencil)
		local clipNode = cc.ClippingNode:create(clipAreaNode)
		clipNode:addChild(reelNode)
		theBoardNode:addChild(clipNode)	
		reelNodes[reelIndex] = reelNode
    end
end

function themeBView:initBoardNodesByReelSingle( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	local colReelCnt = theConfig["colReelCnt"]
	self.clipData["reel_single"] = {}

	local clipNode = nil
	local reelNode = nil
	local stencil = nil	
	local vex
	for reelIndex,config in ipairs(theConfig["reelConfig"]) do

		if (reelIndex-1)%colReelCnt == 0 then 
			reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			
			vex = {
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
			self:addBoardMaskNode(reelNode, config["base_pos"], reelIndex)
		end
		

		reelNodes[reelIndex] = reelNode
		self.clipData["reel_single"][reelIndex] = {}
		self.clipData["reel_single"][reelIndex]["vex"] = vex
		self.clipData["reel_single"][reelIndex]["stencil"] = stencil
	end
end

function themeBView:initBoardNodesByParts( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	local reelNode = cc.Node:create()
	reelNode:setLocalZOrder(reelZorder)

	local clipAreaNode = cc.Node:create()
	for reelIndex, config in ipairs(theConfig["reelConfig"]) do
	    local vex = {
	        cc.pAdd(config["base_pos"], cc.p(0, -config["cellHeight"] * 0.5)), -- 第一个轴的左下角  下左边界
	        cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], -config["cellHeight"] * 0.5)), -- 下右边界
	        cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"] * (config["symbolCount"] + 0.5))), -- 上右边界
	        cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"] * (config["symbolCount"] + 0.5))), -- 上左边界
	    }

	    local stencil = cc.DrawNode:create()
	    stencil:drawPolygon(vex, #vex, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))
	    clipAreaNode:addChild(stencil)
	    reelNodes[reelIndex] = reelNode
	end
	local clipNode = cc.ClippingNode:create(clipAreaNode)

	theBoardNode:addChild(clipNode)
	clipNode:addChild(reelNode)
end
function themeBView:initBoardNodesByNormal( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	self.clipData["normal"] = {}
	local reelNode = cc.Node:create()
	reelNode:setLocalZOrder(reelZorder)
	local clipAreaNode = cc.Node:create()
	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		local vex = {
			config["base_pos"], -- 第一个轴的左下角  下左边界
			cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
			cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"]*config["symbolCount"])),-- 上右边界
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
		clipAreaNode:addChild(stencil)
		reelNodes[reelIndex] = reelNode

		self.clipData["normal"][reelIndex] = {}
		self.clipData["normal"][reelIndex]["vex"] = vex
		self.clipData["normal"][reelIndex]["stencil"] = stencil
	end
	local clipNode = cc.ClippingNode:create(clipAreaNode)

	theBoardNode:addChild(clipNode)
	clipNode:addChild(reelNode)

end

function themeBView:addBoardMaskNode(parentNode, base_pos, reelIndex)
    -- local boardIndex = math.floor((reelIndex - 1) / 5) + 1
    -- local startCol = reelIndex
    -- local endCol = reelIndex + 4

    -- local index = 0
    -- for col = startCol, endCol do

    --     local clipSp = bole.createSpriteWithFile("commonpics/common_black.png")
    --     clipSp:setAnchorPoint(0, 0)
    --     clipSp:setScaleX(self.gameConfig.G_cellWidth / self.gameConfig.BlackUint.width)
    --     clipSp:setScaleY(self.gameConfig.G_cellHeight * self.gameConfig.maxRowCnt / self.gameConfig.BlackUint.height)
    --     local myBase_pos = cc.pAdd(base_pos, cc.p(self.gameConfig.G_cellWidth * index, 0))
    --     clipSp:setPosition(myBase_pos)
    --     parentNode:addChild(clipSp)
    --     clipSp:setLocalZOrder(2000)
    --     self.baseBoardMaskList = self.baseBoardMaskList or {}
    --     self.baseBoardMaskList[col] = clipSp
    --     clipSp:setVisible(false)
    --     index = index + 1
    -- end

end

function themeBView:initSpinLayer( )
	self.spinLayerList = {}
	local _boardNodeList = self:getBoardNodeList()
	if _boardNodeList then 
		for index, cofig in pairs(_boardNodeList) do
			self.initBoardIndex = index
			local boardNode = _boardNodeList[index]
			local layer = SpinLayer.new(self._mainViewCtl.theme, self._mainViewCtl, boardNode.reelConfig, boardNode)
			layer:DeActive()
			self.shakyNode:addChild(layer,-1)
			table.insert(self.spinLayerList,layer)
		end
		self.initBoardIndex = nil

		self.spinLayer = self.spinLayerList[1]
		self.spinLayer:Active()
		self:changeSpinLayerByType(1)
	end
end

function themeBView:changeSpinLayerByType( pType )
	if self.spinLayer ~= self.spinLayerList[pType] then
		self.spinLayer:DeActive()
		self.spinLayer = self.spinLayerList[pType]
		self.spinLayer:Active()
	end

	self:refreshColCellsZOrder()
	-- todo 之后删除
	self._mainViewCtl:changeSpinLayer(self.spinLayer)
end

function themeBView:getCurSpinLayer( pType )
	return self.spinLayer
end

function themeBView:hasSpinLayer( pType )
	return bole.isValidNode(self.spinLayer)
end

function themeBView:getCellItem( col, row )
	return self.spinLayer.spins[col]:getRetCell(row)
end


function themeBView:initSpinLayerBg() -- 新增额外的 点击按钮，不需要
	local floor = self.bgRoot:getChildByTag(ThemeBaseView.Tags.Floor )
	if floor then
		bole.addClickEvent(floor, function (  )
			if self.ctl and self.ctl.footer:isCanSpin() then
				self.ctl:toSpin()
			end
		end)
	end
end

function themeBView:initFreeSpinNode( )
	-- self.freeSpinNode
end

function themeBView:initSpecialFreatureNode( )
	-- self.freeSpinNode
end

function themeBView:refreshColCellsZOrder( pCol )
	self.spinLayer:refreshCellsZOrder(pCol)
end


function themeBView:modifyThemeLayout( )
	-- body
end

function themeBView:adjustActivityScale(scale)
	if bole.isValidNode(self.down_node) and SHRINKSCALE_H == 1 then
		if scale then
			self.down_node:setScale(scale)
			if self._mainViewCtl.setDownNodeScale then
				self._mainViewCtl:setDownNodeScale(scale)
			end
		end
	end
	if bole.isValidNode(self.middle_node) and SHRINKSCALE_H == 1 then
		if scale then
			self.middle_node:setScale(scale)
		end
	end
end

function themeBView:resetReelScale( ... )
	if bole.isValidNode(self.down_node) and SHRINKSCALE_H == 1 then
		self.down_node:setScale(1)
	end

	if bole.isValidNode(self.middle_node) and SHRINKSCALE_H == 1 then
		self.middle_node:setScale(1)
	end
end

------------------------------------------------------------------------------------------------------------------------------------
--@ cell 初始化和更新

function themeBView:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
	if theCellNode.tipNode then 
		if (not tolua.isnull(theCellNode.tipNode)) then 
			theCellNode.tipNode:removeAllChildren()
		end
	end
	if theCellNode.symbolTipAnim then 
		if (not tolua.isnull(theCellNode.symbolTipAnim)) then 
			theCellNode.symbolTipAnim:stopAllActions()
			theCellNode.symbolTipAnim:removeFromParent()
		end
	end

	if bole.isValidNode(theCellNode.coinSprite)  then 
		theCellNode.coinSprite:removeAllChildren()
	end

	theCellNode.symbolTipAnim = nil 
end


function themeBView:createCellSprite(key, col, rowIndex)
	
	local theCellNode   = cc.Node:create()

	local notInitSymbolSet = {}
	if self.gameConfig.symbol_config and self.gameConfig.symbol_config.not_init_symbol_set then 
		notInitSymbolSet = self.gameConfig.symbol_config.not_init_symbol_set
	end

	if notInitSymbolSet[key] then 
		key = self._mainViewCtl:getNormalKey()
	end

	local theCellFile = self._mainViewCtl.pics[key]

	if not theCellFile then 
		print("whj: key, theCellFile",  key, theCellFile)
	end
	
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	local tipNode = cc.Node:create()
	theCellNode:addChild(tipNode, 2)
	theCellNode.tipNode = tipNode

	local coinSprite = cc.Node:create()
	theCellNode:addChild(coinSprite, 5)
	theCellNode.coinSprite = coinSprite

	bole.setEnableRecursiveCascading(theCellNode, true)

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	end
	return theCellNode
end

function themeBView:updateCellSprite( theCellNode, key, col, isShowResult, isReset, isNotChange) -- 控制 显示 cell 的 sprite 上面
	local theCellFile 	= self._mainViewCtl.pics[key]
	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0
	------------------------------------------------------------

	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
 
end
------------------------------------------------------------------------------------------------------------------------------------


--@中奖动画相关
-- ways类型 和 line类型主题生效相关
-- 1，后续需要考虑配置化实现方式
------------------------------------------------------------------------------------------------------------------------------------
function themeBView:drawWaysThemeAnimate( ways, layer, rets, specials,timeList, boardIndex)
	local draw 		= cc.Node:create()
	local symboldraw= cc.Node:create()
	local index 	= 0
	local itemList 	= rets["item_list"]
	local doFirst  = true
	local function drawEachWay(theWayData, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local posList 		=theWayData["win_pos"]
		local effectStatus 	= "half" -- 播放每条线的动画
		for _, crPos in pairs(posList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawEachCRPosGroup(theGroupItem, theGroupCRPosList, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "half" -- 
		for _,crPos in ipairs(theGroupCRPosList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, rets, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end	
	local function drawAllWinPos(winPosList)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "all" -- 播放所有中奖动画
		if doFirst then
			effectStatus = "all_first"
			doFirst = false
		end		
		local tipIndex  	= 0
		for _, theData in pairs(winPosList) do
			local col = theData[1]
			local row = theData[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end			
		end
	end
	self.animateNode:addChild(symboldraw,1)
	symboldraw.animations = {}
	
	if self.themeAnimateKuang then -- whj 添加存放中奖连线框动画，让他始终在 动画曾的最上面，包括lock 动画
		self.themeAnimateKuang:addChild(draw,10)
	else
		self.animateNode:addChild(draw,10)
	end

	if rets["win_pos_list"] and #rets["win_pos_list"]>0 then
		local delay = 0		
		draw:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
			local asList = {}
			local a1 = cc.CallFunc:create(function()
				drawAllWinPos(rets["win_pos_list"])
			end)
			local a2 = cc.DelayTime:create(timeList and timeList[1] or 3) -- 播放全条中奖连线是3秒
			table.insert(asList, a1)
			table.insert(asList, a2)
			local tipIndex = 0

			for index,theWayData in pairs(ways) do
				tipIndex = tipIndex + 1
				local curIndex = tipIndex -- whj 重新定义了一个参数用来索引当前的way的index。因为 for循环对tipIndex进行的修改在真正调用drawEachWay时候 tipIndex已经被更改成其他值了，所以定义local值只在当前循环中有效不会被更改
				local t1 = cc.CallFunc:create(function()
					drawEachWay(theWayData, curIndex)
				end)
				local t2 = cc.DelayTime:create(timeList and timeList[2] or 1) -- 延迟1秒去播放
				table.insert(asList, t1)
				table.insert(asList, t2)
			end
			draw:runAction(cc.RepeatForever:create(cc.Sequence:create(bole.unpack(asList))))
		end)))
	end
end

function themeBView:drawLinesThemeAnimate( lines, layer, rets, specials,timeList, boardIndex)
	lines = lines or {}
	local payLines = self._mainViewCtl:getPayLines()
	local itemList  = rets["item_list"]

	local draw 	    = cc.Node:create()
	local symboldraw= cc.Node:create()
	local doFirst   = true
	local function drawEachLine(theLineData, tipIndex)
		-- print("theLineData: ",tool.lua_to_json(theLineData))
		self:showAllItem("draw")
		local lineIndex = theLineData[1]
		local cols 		= payLines[lineIndex]
		local begCol 	= 1 -- 开始的列
		local endCol 	= theLineData[2] -- 结束的列
		local symbol 	= theLineData[3] -- 中奖 symbol
		local adjustCol = 1 -- 每次增量 1 
		if theLineData[4] then
			begCol 		= #self.spinLayer.spins
			endCol 		= #self.spinLayer.spins - theLineData[2] + 1
			adjustCol 	= -1
		end
		local effectStatus 	= "half"
		for col = begCol, endCol, adjustCol do
			local row 	 = cols[col] + 1
			local sprite = self:drawPayLineItem(col+theLineData.col_ck, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawEachCRPosGroup(theGroupItem, theGroupCRPosList, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "half"
		for _,crPos in ipairs(theGroupCRPosList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawAllWinPos(winPosList)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "all"
		if doFirst then
			effectStatus = "all_first"
			doFirst = false
		end		
		local tipIndex      = 0
		for _, theData in pairs(winPosList) do
			local col = theData[1] -- 列
			local row = theData[2] -- 行
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end			
		end
	end
	self.animateNode:addChild(symboldraw,2)
	if self.themeAnimateKuang then -- whj 添加存放中奖连线框动画，让他始终在 动画曾的最上面，包括lock 动画
		self.themeAnimateKuang:addChild(draw,10)
	else
		self.animateNode:addChild(draw,10)
	end
	
	if rets and rets["win_pos_list"] and #rets["win_pos_list"]>0 then
		local delay = 0		
		draw:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
			local asList = {}
			local a1 = cc.CallFunc:create(function()
				drawAllWinPos(rets["win_pos_list"])
			end)

			local a2 = cc.DelayTime:create(timeList and timeList[1] or 3)
			table.insert(asList, a1) -- 同时播放动画放到数组中
			table.insert(asList, a2)
			local tipIndex = 0
			if self.winCRPosGroupList and bole.getTableCount(self.winCRPosGroupList)>0 then
				for theItem,theCRPosList in pairs(self.winCRPosGroupList) do
					tipIndex = tipIndex + 1
					local g1 = cc.CallFunc:create(function()
						drawEachCRPosGroup(theItem, theCRPosList, tipIndex)
					end)
					local g2 = cc.DelayTime:create(timeList and timeList[2] or 1)
					table.insert(asList, g1) -- 特殊的 单条线播放
					table.insert(asList, g2)
				end				
			end
			local sameTimePlay = false
			for index,theLineData in pairs(lines) do
				if theLineData.play_idx then sameTimePlay = true; break end

				tipIndex = tipIndex + 1
				local t1 = cc.CallFunc:create(function()
					draw:removeAllChildren()
					drawEachLine(theLineData, tipIndex)
				end)
				local t2 = cc.DelayTime:create(timeList and timeList[2] or 1)
				table.insert(asList, t1)-- 普通的单条线播放
				table.insert(asList, t2)
			end
			--多表同时播
			if sameTimePlay then
				for i=1, 100 do
					local iIndexs = {}
					for index,theLineData in ipairs(lines) do
						if theLineData.play_idx == i then
							table.insert(iIndexs, theLineData)
						end
					end
					if #iIndexs == 0 then
						break
					else
						local t1 = cc.CallFunc:create(function()
							draw:removeAllChildren()
							for k,v in ipairs(iIndexs) do
								drawEachLine(v, i)
							end
						end)
						local t2 = cc.DelayTime:create(timeList and timeList[2] or 1)
						table.insert(asList, t1) -- 线排序 然后播放动画
						table.insert(asList, t2)
					end
				end
			end
			draw:runAction(cc.RepeatForever:create(cc.Sequence:create(bole.unpack(asList))))
		end)))
	end	
end

function themeBView:drawPayLineItem(reel, row, specials, itemList, effectStatus, tipIndex,parent) --想法子把smbol动画添加到sprite
	local sprite = cc.Sprite:create()
	sprite:setPosition(self._mainViewCtl:getCellPos(reel,row))
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

function themeBView:playCellRoundEffect(theSprite, item, col, row, effectStatus ) -- 通过图片自己制作帧动画 
	bole.addSpineAnimation(theSprite, nil, self._mainViewCtl:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function themeBView:getItemAnimate(item, col, row, effectStatus,parent)

end

function themeBView:getItemAnimate_80(item)
	local fs = 40
	local objOp = 0
	local animate = cc.Sequence:create(
		cc.DelayTime:create(7/fs),
		cc.FadeTo:create(19/fs, 255*objOp),
		cc.DelayTime:create(10/fs), 
		cc.FadeTo:create(17/fs, 255),
		cc.DelayTime:create(7/fs))
	return cc.Sequence:create(animate, animate:clone())
end

function themeBView:getItemAnimateScale_120(item)

	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.ScaleTo:create(26/fs,1.085),
		cc.DelayTime:create(2/fs),		
		cc.ScaleTo:create(26/fs,1),
		cc.DelayTime:create(2/fs))
	return cc.Sequence:create(animate, animate:clone())
end

function themeBView:getSingleItemAnimate_120(item)
	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.FadeTo:create(0, 255*objOp),
		cc.DelayTime:create(30/fs),		
		cc.FadeTo:create(0, 255),
		cc.DelayTime:create(28/fs))
	return cc.Sequence:create(animate, animate:clone())
end

function themeBView:showAllItem(showState) -- 没啥作用

end

function themeBView:stopDrawAnimate() -- 可能存在 手动调用的可能
	self:showAllItem()
	self.spinLayer:stopChildActions()
	self:clearAnimate()

	self:clearBGEffect()
end

function themeBView:clearAnimate( ... )
	self.animateNode:removeAllChildren()
	if bole.isValidNode(self.themeAnimateKuang) then 
		self.themeAnimateKuang:removeAllChildren()
	end

	self:cleanCellState()
end

function themeBView:cleanCellState( ... ) -- cell visible状态设置成 true
	self.spinLayer:setSymbolStatus(true)
end 

function themeBView:playSymbolNotifyEffect( pCol, reelSymbolState ) 
	if not self.gameConfig.symbol_config then return end
	local _symbol_config = self.gameConfig.symbol_config 
	for  key , list in pairs(self.notifyState[pCol]) do
		for _, crPos in pairs(list) do
			local cell = nil
			if self._mainViewCtl:checkIsFastStop() then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
			end
			if cell and cell.key == key then
				local tipAnim
				local firstName = "animation"

				local fileName = key
				local spineFile		= self:getPic("spine/item/"..fileName.."/spine")
				local _,s = self:addSpineAnimation(
					cell, 
					10, 
					spineFile, 
					cc.p(0,0), 
					firstName.._symbol_config.anim_suffix.notify, 
					nil, 
					nil, 
					nil, 
					true
				)
				tipAnim = s

				cell.sprite:setVisible(false)
				cell.symbolTipAnim = tipAnim

				tipAnim:addAnimation(0, tipAnim.firstName.._symbol_config.anim_suffix.loop, true)
			end	
		end
		self.mainView:playBGEffectByCol(key, pCol)
	end
end

function themeBView:playSymbolStopLoopEffect(pCol)
	local _spinLayer = self:getCurSpinLayer()
	local _symbol_config = self.gameConfig.symbol_config
	if _symbol_config and _spinLayer and _spinLayer.spins and _spinLayer.spins[pCol] and _spinLayer.spins[pCol].cells then

		for row, cell in pairs(_spinLayer.spins[pCol].cells) do 
			
			if _symbol_config.loop_symbol_list[cell.key] and not(bole.isValidNode(cell.symbolTipAnim)) then 

				local fileName = cell.key
				local spineFile		= self:getPic("spine/item/"..fileName.."/spine")
				local _,s = self:addSpineAnimation(
					cell, 
					10, 
					spineFile, 
					cc.p(0,0), 
					"animation".._symbol_config.anim_suffix.loop, 
					nil, 
					nil, 
					nil, 
					true,
					true
				)
				local tipAnim = s

				cell.sprite:setVisible(false)
				cell.symbolTipAnim = tipAnim
			end
		end
	end
end

function themeBView:playBGEffectByCol(key, pCol)
	
end

function themeBView:clearBGEffect()
	
end


----------------------------------------------------------------------------------------------------------------------------------------
--@ free 相关
function themeBView:onFreeDialogClose( ... )
	
end

function themeBView:playNodeShowAction( node, actionData )
	local nodeACAllList = {}

	for _, _singleACData in pairs(actionData) do
		local acList = {}
		local d1 = cc.DelayTime:create(_singleACData.delay)
		table.insert(acList, d1)
		local d2 = cc.Show:create()
		table.insert(acList, d2)

		if not _singleACData.acAnim or _singleACData.acAnim == "show" then 
			node:setVisible(false)
		end

		local _startState = _singleACData.startState

		if _singleACData.atype == "scale" then 
			local baseScale = _singleACData.baseScale or 1
			node:setScale(_startState * baseScale)

			for _, temp in pairs(_singleACData.list) do
				local a1 = temp[3] and cc.ScaleTo:create(temp[1], temp[2]*baseScale, temp[3]*baseScale) or cc.ScaleTo:create(temp[1], temp[2]*baseScale)
				table.insert(acList, a1)
			end

		elseif _singleACData.atype == "fade" then 

			node:setOpacity(_startState)

			for _, temp in pairs(_singleACData.list) do
				local a1 = cc.FadeTo:create(temp[1], temp[2])
				table.insert(acList, a1)
			end
		end

		if _singleACData.acAnim and _singleACData.acAnim == "hide" then 
			local d2 = cc.Hide:create()
			table.insert(acList, d2)
		end

		local a = cc.Sequence:create(bole.unpack(acList))
		table.insert(nodeACAllList, a)
	end

	local b = cc.Spawn:create(bole.unpack(nodeACAllList))
	libUI.runAction(node, b)
end

function themeBView:dialogPlayLineAnim( state, dimmer, root, animData )
    if state == "show" then 
        if bole.isValidNode(dimmer) then
        	local endOVale = animData or 200
            dimmer:setVisible(true)
            dimmer:setOpacity(0)
            dimmer:runAction(cc.Sequence:create(cc.FadeTo:create(0.3, endOVale)))
        end
        if bole.isValidNode(root) then
            root:setVisible(true)
            root:setScale(0)
            root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.4, 1.2),cc.ScaleTo:create(0.1, 1)))
        end
    else
        if bole.isValidNode(dimmer) then
        	local startOVale = animData or 200
            dimmer:setVisible(true)
            dimmer:setOpacity(startOVale)
            dimmer:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.FadeTo:create(0.2, 0)))
        end
        if bole.isValidNode(root) then
            root:setVisible(true)
            root:setScale(1)
            root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 1.2),cc.ScaleTo:create(0.4, 0)))
        end
    end
end

function themeBView:resetBoardCellsByItemList(_itemList)
	if _itemList then 
		for col, colList in pairs(_itemList) do
			for row, itemKey in pairs(colList) do
				local cell = self.spinLayer.spins[col]:getRetCell(row)
				self:updateCellSprite(cell, itemKey, col, true, true)
			end
		end
	end

end


function themeBView:resetBoardCellsByNormal(notItemListSet)
	local notItemListSet = notItemListSet or {}
	for col, reel in pairs(self.spinLayer.spins) do
		for row, cell in pairs(reel.cells) do 

			local key = self._mainViewCtl:getNormalKey()
			
			while notItemListSet[key] do 
				key = self._mainViewCtl:getNormalKey()
			end

			self:updateCellSprite(cell, key, col, true, true, true)
		end
	end
end

function themeBView:resetBoardCellsByCreateList(list)
	for col, reel in pairs(self.spinLayer.spins) do
		for row, cell in pairs(reel.cells) do 

			local key = list[math.random(1, #list)]

			self:updateCellSprite(cell, key, col, true, true, true)
		end
	end
end

function themeBView:updateCellShowByKey( col, row, key, hideCell)
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	if cell then 
		self:updateCellSprite(cell, key, col, true, true, true)

		if hideCell then 
			cell:setVisible(false)
		end
	end

end

-- return ThemeBaseView