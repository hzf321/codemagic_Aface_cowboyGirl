-- 每帧移动的距离大于单格cell高度的时候回出问题，需要重新考虑SpinCol:refresh与SpinCol:resetSpinNodePosY的书写
---------------------------------------------------------------------------------------------------------
-- 棋盘
---------------------------------------------------------------------------------------------------------
local l_fast_adjust_pos_y = 0
local ReelStatus = {
	["start"] = 1,
	["running"] = 2,
	["stopping"] = 3,
	["downbounce"] = 4,
	["stop"] = 5,
	["waiting"] = 6,
}
SpinLayer = class("SpinLayer", function() return cc.Layer:create() end)
local l_win_size 	  = cc.Director:getInstance():getWinSize()
local Diamond_Node   = require (bole.getDesktopFilePath("HeaderFooter/Diamond_Node"))
function SpinLayer:ctor(theme, themeCtl,reelConfigList,boardNode)
	self.theme 			 = theme
	self.themeCtl 		 = themeCtl
	self.theme.spinLayer = self
	self:setIgnoreAnchorPointForPosition(false)
	self:setAnchorPoint(0.5, 0.5)
	self:setContentSize(l_win_size)
	self:setPosition(cc.p(l_win_size.width/2, l_win_size.height/2))
	self.boardNode = boardNode
	self.reelConfig = reelConfigList
	self.spins  		= {}  -- 列_表
	self.startLinks  	= {}  -- 列_表关联
	self.animBool 		= true
	-- 初始化整体布局显示
	
	-- 初始化滚轴列
	for col,reelConfig in pairs(reelConfigList) do
		local reelNode    = boardNode:getReelNode(col) -- 获得整个棋盘的板子节点
		local theSpinReel = SpinCol.new(col, self, reelNode, reelConfig,self.theme.UnderPressure)
		reelNode:addChild(theSpinReel)
		self.spins[col]     = theSpinReel
	end
	
	self.running 	= false
	self.stopping 	= false
	self.endCallFunc= nil
	self.startCalculateSpinTime = false
	self.isShowingError = false
end

function SpinLayer:getCellsByCol(col)
	return self.spins[col]:getCells()
end
function SpinLayer:getNumberByCol(col)
	return self.spins[col]:getNumber()
end
function SpinLayer:getCurrentIndexByCol(col)
	return self.spins[col]:getCurrentIndex()
end
function SpinLayer:getExtraSymbolCountByCol(col)
	return self.spins[col]:getExtraSymbolCount()
end
function SpinLayer:setExtraSymbolCountByCol(col, value)
	self.spins[col]:setExtraSymbolCount(value)
end

function SpinLayer:getCellSize( col )
	return cc.size(self.reelConfig[col].cellWidth,self.reelConfig[col].cellHeight)
end

function SpinLayer:moveReel(colId, count, time, moveEndFunc)-- 列Id 、向下移动个数(正数向下,负数向上)、时间(s)
	self.spins[colId]:moveReel(count,time, moveEndFunc)
end

function SpinLayer:setIconAtIndex( colId,index,key )
	self.spins[colId]:setIconAtIndex(index,key)
end

function SpinLayer:getIconAtIndex( colId, index )
	return self.spins[colId]:getIconAtIndex(index)
end

function SpinLayer:getCurrentColLocalZorder( colId )
	local baseZorder = self.spins[colId]:getCurrentColLocalZorder()
	return baseZorder
end

function SpinLayer:Active(onlyShowBoard)
	self.isActive = true
	self.boardNode:setVisible(true)
	if onlyShowBoard then return end
	local i = 1
	local total = 0
	local dt_60 = {}

	self.fps_cnt = 0
	local fpsV = 0
	local fpsC = 0
	local onUpdate = function(dt)
		if dt_60[i] then
			total = total - dt_60[i]
		end
		dt_60[i] = dt
		total = total + dt
		i = i + 1
		if i > 60 then i = 1 end
		-- for k,v in ipairs(dt_60) do
		-- 	total = total + v
		-- end
		local calc_dt = total/#dt_60
		if calc_dt > 1/30 then
			dt_60 = {}
			i = 1
		else
			dt = calc_dt	
		end
		if self.isActive then
			if self.running then
				if self.startCalculateSpinTime then
					self.rotatedTime = self.rotatedTime + dt
					if self.rotatedTime > 25 then
						if not self.isShowingError then
							self.isShowingError = true
							-- local dialog = ClientErrorDialog.new()
							-- dialog:show()
						end
					end
				end
			end
			for col,theReel in pairs(self.spins) do
				theReel:updateCallFunc(dt)
			end
		end
	end
	self:scheduleUpdateWithPriorityLua(onUpdate, 0)
end

function SpinLayer:DeActive(notHideBoard)
	self.isActive = false
	self.running 	 = false
	self.stopping 	 = false
	self.startCalculateSpinTime = false
	if notHideBoard then 
		-- self.boardNode:setVisible(false)
	else
		self.boardNode:setVisible(false)
		self:resetBoard()
	end
	self:unscheduleUpdate()
end

function SpinLayer:getCellPos( col, row )
	local reel = self.spins[col]
	-- local addPos  = cc.p(0.5*reel.cellWidth, (reel.row+reel.addTop-row-0.5)*reel.cellHeight)
	local addPos  = cc.p(0.5*reel.cellWidth, (reel.row - row + 0.5)*reel.cellHeight)
	return cc.pAdd(self.spins[col].basePos, addPos)
end

function SpinLayer:refreshCellsZOrder( pcol)	-- 之后 设置 再进行查看
	if pcol then
		self.spins[pcol]:refreshCellsZOrder()
	else
		for index,theReel in pairs(self.spins) do
		theReel:refreshCellsZOrder()
		end
	end
	
end

function SpinLayer:setSymbolStatus(visible)	-- 之后 设置 再进行查看
	for index,theReel in pairs(self.spins) do
		theReel:setSymbolStatus(visible)
	end
end
function SpinLayer:checkDealWithReelStop( )
	local hasSpinningReel = false
	for index,theReel in pairs(self.spins) do
		if theReel.curStatus ~= ReelStatus.stop then
			hasSpinningReel = true
			break
		end
	end
	if not hasSpinningReel then
		self.running 	 = false
		self.stopping 	 = false
		if self.endCallFunc then
			self.endCallFunc()
			self.endCallFunc = nil
		end
	end	
end
---------------------------------------------------------------------------------------
function SpinLayer:getCenterPos( )
	return cc.p(l_win_size.width/2, l_win_size.height/2)
end

function SpinLayer:getModifyNode( )
	return self.modifyNode
end
---------------------------------------------------------------------------------------
function SpinLayer:startCalculateRequestTime( needCaculate )
	if needCaculate then 
		self.startCalculateSpinTime = true
	else
		self.startCalculateSpinTime = false
	end
end
function SpinLayer:spin( spinConfig )
	if self.running then
		return nil
	end	
	self.running 	 = true
	self.rotatedTime = 0
	-- self.startCalculateSpinTime = false
	-- self.isShowingError = false
	self.endCallFunc = nil
	self.itemList 	 = nil
	for _,theReelConfig in ipairs(spinConfig) do
		local col 			= theReelConfig["col"]
		local actionConfig 	= theReelConfig["action"]
		self.spins[col]:spin(actionConfig)
	end
end

function SpinLayer:onBegStop( colid )
	if self.stopCallConfig[colid] and self.stopCallConfig[colid].begCallFunc then
		self.stopCallConfig[colid].begCallFunc()
		self.stopCallConfig[colid].begCallFunc = nil
	end
end
function SpinLayer:onEndStop( colid )
	if self.stopCallConfig[colid] and self.stopCallConfig[colid].endCallFunc then
		self.stopCallConfig[colid].endCallFunc()
		self.stopCallConfig[colid].endCallFunc = nil
	end	
end
function SpinLayer:cleanStopState( )
	self.stopCallConfig = {}
	self.stopStartCall  = nil
end
function SpinLayer:stop( stopConfig, stopItemList,uplist,downlist,endCallFunc )
	if not self.running or self.stopping then
		return nil
	end
	-- self.isShowingError = true
	-- bole.cleanAction(self.actionNode)	
	self.stopCallConfig = {}
	self.stopStartCall  = nil	
	self.endCallFunc 	= endCallFunc
	self.itemList 	 	= stopItemList
	self.stopping    	= true		
	-- for col,_ in pairs(self.spins) do
	-- 	self.spins[col].curRowIndex = nil
	-- end
	-- print("zhf stopConfig = ",tool.lua_to_json(stopConfig))
	-- print("zhf stopItemList = ",tool.lua_to_json(stopItemList))
	for index,stopReelConfig in pairs(stopConfig) do
		local theCol 	  = stopReelConfig[1]
		local theAction   = stopReelConfig[2]
		local colItemList = stopItemList[theCol]
		self.spins[theCol]:stop(theAction, colItemList,uplist and uplist[theCol],downlist and downlist[theCol])
	end
end

function SpinLayer:fastStop()
	if not self.running or not self.itemList then
		return nil
	end
	for _,reel in ipairs(self.spins) do
		reel:fastStop()
	end
end

---------------------------------------------------------------------------------------
function SpinLayer:stopChildActions( ... )
	for i = 1,#self.spins do
		local node  = self.spins[i]
		for _,theCell in pairs(node.cells) do
			bole.stopAllActions(theCell)
			theCell:setVisible(true)	
			theCell:setOpacity(255)

			if theCell.sprite then
				theCell.sprite:setVisible(true)
			else
				theCell:getChildren()[1]:setVisible(true)
			end

			if self.themeCtl.stopChildActionsSpecial then 
				self.themeCtl:stopChildActionsSpecial(theCell)
			end
		end		
	end	
end

function SpinLayer:reelSpecialCelebrationShake(shakeDistance,shakeTime,colIndex)
	local colIndex = colIndex or nil
	-- bole.cleanAction(self.actionNode)
	if colIndex == nil then
		for col,_ in pairs(self.spins) do
			self:runAction(cc.Sequence:create(
				cc.DelayTime:create((col-1)*0.1),
				cc.CallFunc:create(function()
					self.spins[col]:parsePhysicalBounceDown_celebrationShake(shakeDistance,shakeTime)
				end)
				))	
		end
	else
		self.spins[colIndex]:parsePhysicalBounceDown_celebrationShake(shakeDistance,shakeTime)
	end
end

function SpinLayer:updateFreeBack( freeSpin )	
	-- for i = 1, self.theme.col do
	-- 	self.theme:updateReelFreeBack(self.reelBack[i], freeSpin, i)
	-- end
end
function SpinLayer:setReelOpacityDown(list,time,opacity) -- 控制滚轴 显示灰色蒙版 通过透明度来控制
	for _,v in pairs(list) do
		if self.spins[v] then
			local reelNode = self.spins[v]
			bole.setEnableRecursiveCascading(reelNode, true)
			reelNode:runAction(cc.FadeTo:create(time, opacity))	
		end
	end
end
function SpinLayer:setReelOpacityUp(list,time,opacity) -- 控制滚轴 关闭灰色蒙版 通过透明度来控制
	for _,v in pairs(list) do
		if self.spins[v] then
			local reelNode = self.spins[v]
		
			bole.setEnableRecursiveCascading(reelNode, true)
			reelNode:runAction(cc.FadeIn:create(time))	
		end
	end
end

function SpinLayer:resetBoard() -- 控制滚轴 关闭灰色蒙版 通过透明度来控制
	for col,_ in pairs(self.spins) do
		self.spins[col]:resetCol()
	end
end

function SpinLayer:resetStopItemList( stopItemList) -- 控制滚轴 滚动过程中对itemList进行修改，已经进入stop阶段
	if not stopItemList then return end

	self.itemList = stopItemList
	for theCol, colItemList in pairs(stopItemList) do
		if self.spins[theCol] then 
			self.spins[theCol]:resetStopItemList(colItemList)
		end
	end
end
function SpinLayer:resetSpinLayerInfo(data)
	for col = 1, #self.spins do
		if data[col] then
			self.spins[col]:resetSpinColInfo(data[col])
		end
	end
end
function SpinLayer:recoverStop()
	for col = 1, #self.spins do
		self.spins[col]:recoverStop()
	end
end
-- 
function SpinLayer:hideVoucherView()
	for col = 1, #self.spins do
		self.spins[col]:hideVoucherView()
	end
end


---------------------------------------------------------------------------------------------------------
-- nsm
-- 1，每一列都可以单独控制，与其他无强制关系
-- 2，停靠时通过self.curRowIndex来进行控制
---------------------------------------------------------------------------------------------------------
SpinCol = class("SpinCol", function() return cc.Node:create() end)
function SpinCol:ctor(colid, spinLayer, reelNodeParent, reelConfig)
	self.colid 	  		= colid
	self.spinLayer 		= spinLayer
	self.theme 	  		= spinLayer.theme
	self.themeCtl 	    = spinLayer.themeCtl
	self.row 	  		= reelConfig["symbolCount"]
	self.cellWidth 		= reelConfig["cellWidth"]
	self.cellHeight 	= reelConfig["cellHeight"]
	self.reelNode 		= reelNodeParent-- cc.Node:create()

	self.basePos 	    = reelConfig["base_pos"] --修改因为把cell 放到每个reel 上面,同时reel自身有偏移
	------------------------------------------------------------------
	self.addBelow = self.theme.addBelow or 3 -- 向最下添加的格子数量 
	self.addTop   = self.theme.addTop or 1 -- 向最上添加的格子数量 默认是2
	self.number	  = self.addBelow + self.row  + self.addTop -- 1+3+1  3+3+1
	self.maxIndex = self.number - 1 --self.number - self.addBelow -- 4 如果是三行的话  4 -- 表示最下面的一个 id
	self.minIndex = 0 -- 1 - self.addBelow -- 0 -2 -- 表示最上面的一个 id
	self.localZorder = 0
	self.symbolMoveLimit = self.basePos.y+(self.row)*self.cellHeight
	------------------------------------------------------------------
	self.width 			= self.cellWidth
	self.height 		= self.cellHeight*self.number
	self:setContentSize(cc.p(self.width, self.height))
	self.cells 	  = {}
	self.spinNode = cc.Node:create()	-- cell滚动参照点
	self.spinNode:setPosition(0,0)
	self.spinNode.cachePosY = self.spinNode:getPositionY()
	self.spinNode.cacheTime = 0 --os.time()
	self.spinNode.curMoveDiration  = -1  --最后记录的spinNode的移动方向(-1|1代表着向下,向上两个方向)
	self:addChild(self.spinNode)

	if self.themeCtl then
		for i = self.minIndex, self.maxIndex do --滚轴排序 0,1,2,3
			local s1 				= self.themeCtl:createCellSprite(colid,i)
			local adjustPos 		= cc.p(0.5*self.cellWidth, (i-self.addBelow+0.5)*self.cellHeight)
			local cellPos   		= cc.pAdd(self.basePos, adjustPos)

			s1:setPosition(cellPos)
			self.reelNode:addChild(s1)
			self.cells[i] 			= s1
			s1.cell_index = i
		end
	end
	self.lastIndex = self.minIndex
	self.currentIndex = self.row+self.addBelow-1
	self.actionQueue = {}
	self.curAction   = nil
	self.curStatus 	 = ReelStatus.stop
	self.ret 	  	 = nil
	self.itemList    = nil
	self.ExtraSymbolCount = 6
	self.TestColId = 1

	self.showTopid 	= nil

	self.zOrderUnit = 1
	if self.theme.UnderPressure and self.theme.UnderPressure == 1 then -- 下压上逻辑
		self.zOrderUnit = -1
	end
	
end
function SpinCol:resetCol()
	self.test6 = 3
	self:clearActions()
	self.curStatus = ReelStatus.stop
	self:resetCellsPosition()
	self.lastIndex = self.minIndex
	self.currentIndex = self.row+self.addBelow-1
	self.curSpeed = 0
	self.curAction  = nil
	self.isReelStoping = false
end

function SpinCol:resetCellsPosition()
	for index= self.minIndex,self.maxIndex do
		local theCell 	 = self.cells[index]
		local adjustPos 		= cc.p(0.5*self.cellWidth, (index-self.addBelow+0.5)*self.cellHeight)
		local cellPos   		= cc.pAdd(self.basePos, adjustPos)
		-- self.themeCtl:updateCellSprite(theCell, self.colid, false, nil)
		theCell:setPosition(cellPos)
	end
end

function SpinCol:getPreviousCellByIndex( index ) --  上一个 cell 
	local cellIndex = index - 1
	if cellIndex < 0 then
		cellIndex = cellIndex+self.number
	elseif cellIndex > self.number - 1 then
		cellIndex = 0
	end
	return self.cells[cellIndex]
end

function SpinCol:getNextCellByIndex( index ) --  下一个 cell
	local cellIndex = index + 1
	if cellIndex < 0 then
		cellIndex = cellIndex+self.number
	elseif cellIndex > self.number - 1 then
		cellIndex = 0
	end
	return self.cells[cellIndex]
end

function SpinCol:getRetCell( index ) -- 获得索引相对应的cell 
	local cellIndex = self.currentIndex - index + 1
	if cellIndex < 0 then
		cellIndex = cellIndex+self.number
	elseif cellIndex > self.number - 1 then
		cellIndex = 0
	end
	return self.cells[cellIndex]
end
--从0号位置更新 zorder
function SpinCol:refreshCellsZOrder()	-- 之后 设置 再进行查看
	for index= self.minIndex,self.maxIndex do-- self.minIndex,self.maxIndex do
		local theCell 	 = self.cells[index]
		self:refreshCellZOrder(theCell,index)
	end
end
--从滚轴的最下面到上面更新 zorder
function SpinCol:refreshCellsZOrderFromBottom( ... )
	local index = self.lastIndex
	for i = 0,self.number-1 do-- self.minIndex,self.maxIndex do
		local cell = self.cells[index]
		self:refreshCellZOrder(cell,0)
		index = index+1
		if index == self.number then
			index = 0
		end
	end
end

function SpinCol:refreshCellZOrder(theCell,index)
	local baseZOrder = self.localZorder
	self.localZorder = self.localZorder + self.zOrderUnit
	local colZorder  = self.colid
	local addZOrder  = theCell.curZOrder or 0
	-- if self.TestColId == self.colid then
	-- 	print("zhf: baseZOrder,colZorder,addZOrder,zorder",baseZOrder,colZorder,addZOrder,baseZOrder+colZorder+addZOrder)
	-- end
	theCell:setLocalZOrder(baseZOrder+colZorder*70+addZOrder)
end

function SpinCol:getCurrentColLocalZorder()
	local baseZOrder = self.localZorder or 0
	return baseZOrder
end

function SpinCol:setSymbolStatus(visible)	-- 之后 设置 再进行查看
	for _,theCell in pairs(self.cells) do
		if bole.isValidNode(theCell) then
			theCell:setVisible(visible)
			if bole.isValidNode(theCell.sprite) then
				theCell.sprite:setVisible(visible)
				theCell.sprite:setOpacity(255)
			end
			if theCell.themeBaseScale then 
				theCell:setScale(theCell.themeBaseScale)
			else
				theCell:setScale(1)
			end
		end
		if self.themeCtl.stopChildActionsSpecial then 
			self.themeCtl:stopChildActionsSpecial(theCell)
		end
	end
end

function SpinCol:moveReel(count,time, moveEndFunc)
	local moveEnd = false
	local function onMoveEnd( )
		if not moveEnd then
			moveEnd = true
			self:fixResult()
			if moveEndFunc then 
				moveEndFunc()
			end
		end
	end
	local dis = -count*self.cellHeight
	for idx,theCell in pairs(self.cells) do 
		theCell:runAction(cc.Sequence:create(cc.MoveBy:create(time, cc.p(0,dis)),cc.CallFunc:create(onMoveEnd)))
	end
end

function SpinCol:setIconAtIndex( index ,key)
	if index < 0 then
		index = index - self.row + 1
	end
	local iconIndex = (self.currentIndex + index + self.number)%self.number
	local cell = self.cells[iconIndex]
	-- if index < 0 and cell:getPositionY() > self.basePos.y then
	-- 	local _lastCell = self:lastCell()
	-- 	cell:setPositionY(_lastCell:getPositionY() - self.cellHeight)
	-- 	self.lastIndex = self.lastIndex-1
	-- 	if self.lastIndex < 0 then
	-- 		self.lastIndex = self.number - 1
	-- 	end
	-- 	-- self:refreshCellZOrder(cell,iconIndex)
	-- end
	self.themeCtl:updateCellSprite(self.cells[iconIndex], self.colid, false, key, true)
	-- self.theme:updateCellSprite(self.cells[iconIndex], key, self.colid, false,true)
end

function SpinCol:getIconAtIndex( index )
	if index < 0 then
		index = index - self.row + 1
	end
	local iconIndex = (self.currentIndex + index + self.number)%self.number
	return self.cells[iconIndex]
end

function SpinCol:updateCallFunc(dt) -- 移动控制回调
	if self.onDelayStopSchedule then
		self.delayTotalTime = self.delayTotalTime + dt
		if self.delayTotalTime>self.stopConfig.stopDelay then
			self.onDelayStopSchedule = false
			self:onReelStartStop()
		end
	end
	if not self.curAction and #self.actionQueue>0 then
		self.curAction = table.remove(self.actionQueue, 1)
		self.currentTime = 0
		self.acceleration = nil
		-- if self.colid == self.TestColId then
		-- 	print("zhf curAction =  ",tool.lua_to_json(self.curAction))
		-- end
		if self.curAction.beginFun then
			-- if self.colid == self.TestColId then
			-- 	print("zhf beginFun")
			-- end
			
			self.curAction.beginFun(self.colid)
		end
	end
	if self.curAction then
		self:refresh(dt)
		self:recoverStop()
		-- self.spinNode.cacheTime = retData["endTime"] or curTime
		-- if retType == 2 then
		-- 	self.curAction = nil
		-- end
	end
end

function SpinCol:refresh(dt)  -- 移动Node之后进行相关的添加smybol 的动作 添加smybol
	self.currentTime = self.currentTime+dt
	-- print(" curAction " .. tool.lua_to_json(self.curAction))
	local timeLeft = 0
	local isCurrentActionEnd = false
	-- if self.colid == 1 then
	-- 	print("zhf self.currentTime  = " .. self.currentTime)
	-- 	print("zhf self.curAction.totalTime  = " .. self.curAction.totalTime)
	-- end
	if self.currentTime >= self.curAction.totalTime then
		-- if self.colid == self.TestColId then
		-- 	print("zhf self.currentTime  = ",self.currentTime)
		-- end
		timeLeft = self.currentTime - self.curAction.totalTime
		isCurrentActionEnd = true
		dt = dt - timeLeft
	end


	if not self.curAction.delay then
		local moveY = self:getMoveY(dt)
		for _,theCell in pairs(self.cells) do 
			theCell:setPositionY(theCell:getPositionY()+moveY)
		end

		local _currentCell = self:currentCell()
		while _currentCell:getPositionY() < self.symbolMoveLimit do
			
			self.currentIndex = self:increaseIndex(self.currentIndex)
			self.themeCtl:updateCellSprite(self:nextCell(), self.colid, self.isReelStoping, nil)
			self:refreshCellZOrder(self:currentCell(),self.currentIndex)
			_currentCell = self:currentCell()

		end
	end
	if isCurrentActionEnd then
		if self.curAction.endFun then
			self.curAction.endFun(self.colid)
		end
		self.curAction = nil
	end
	if timeLeft > 0 then
		-- if self.colid == 1 then
		-- 	print("zhf timeLeft =  " .. timeLeft)
		-- end
		self:updateCallFunc(timeLeft)
	end
end

function SpinCol:getMoveY(dt)
	-- 计算每一个阶段的加速度
	if(not self.acceleration) then
		if not self.curSpeed then
			self.curSpeed = 0
		end
		if self.curAction.endSpeed ~= self.curSpeed and self.curAction.accelerationTime then
			self.acceleration = (self.curAction.endSpeed-self.curSpeed)/self.curAction.accelerationTime
		else
			self.acceleration = 0
			self.curSpeed = self.curAction.endSpeed
		end
	end
	local tempSpeed = self.curSpeed+self.acceleration*dt
	if self.acceleration>0 then
		if tempSpeed>self.curAction.endSpeed then
			tempSpeed = self.curAction.endSpeed
			self.acceleration = 0
		end
	elseif self.acceleration<0 then
		if tempSpeed<self.curAction.endSpeed then
			tempSpeed = self.curAction.endSpeed
			self.acceleration = 0
		end
	end
	local moveDis = (tempSpeed+self.curSpeed)/2*dt
	self.curSpeed = tempSpeed
	return moveDis
end

function SpinCol:currentCell()
	return self.cells[self.currentIndex]
end

function SpinCol:beforeCell()
	local tempIndex = self.currentIndex - 1
	if tempIndex < 0 then
		tempIndex = self.number - 1
	end 
	return self.cells[tempIndex]
end

function SpinCol:nextCell()
	local tempIndex = self.currentIndex+1
	if tempIndex > self.number-1 then
		tempIndex = 0
	end 
	return self.cells[tempIndex]
end

function SpinCol:firstCell()
	local firstIndex = self.lastIndex -1
	if firstIndex < 0 then
		firstIndex = self.number - 1
	end
	return self.cells[firstIndex]
end

function SpinCol:lastCell()
	return self.cells[self.lastIndex]
end

function SpinCol:increaseIndex(index)
	local tempIndex = index+1
	if tempIndex > self.number-1 then
		tempIndex = 0
	end 

	local _firstCell = self:firstCell()
	local _lastCell = self:lastCell()
	_lastCell:setPositionY(_firstCell:getPositionY()+self.cellHeight)
	self.lastIndex = self.lastIndex+1
	if self.lastIndex > self.number-1 then
		self.lastIndex = 0
	end

	return tempIndex
end

function SpinCol:decreaseIndex(index)
	local tempIndex = index -1
	if tempIndex < 0 then
		tempIndex = tempIndex+self.number
	end
	local _firstCell = self:firstCell()
	local _lastCell = self:lastCell()
	_firstCell:setPositionY(_lastCell:getPositionY()-self.cellHeight)
	self.lastIndex = self.lastIndex-1
	if self.lastIndex <0 then
		self.lastIndex = self.number-1
	end
	return tempIndex
end

function SpinCol:getCells()
	return self.cells
end

function SpinCol:getNumber()
	return self.number
end

function SpinCol:getCurrentIndex()
	return self.currentIndex
end
function SpinCol:getExtraSymbolCount()
	return self.ExtraSymbolCount
end
function SpinCol:setExtraSymbolCount(value)
	 self.ExtraSymbolCount = value
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- start deal
--------------------------------------------------------------------------------------------------------------------------------------------
function SpinCol:start(spinConfig)
	-- print("zhf SpinCol:start = ")
	self.itemList     = nil
	self.curStatus    = ReelStatus.start
	self.spinNode:stopAllActions()
	self.spinConfig = spinConfig
	self.onDelayStopSchedule = false
	------------------------------

	self.actionQueue = {}
	self:parseStart(spinConfig)
	-- self:AddActions(self:parseStart(spinConfig))
	-- local theIndex   	= spinConfig["deal_index"]
	-- local theParamData  = spinConfig["deal_param"]
	-- self:dealStartWithIndex(theIndex, theParamData)
	
	local seq = cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function  ()
			if THEME_DESKTOP_ID == 174 and self.colid == 6 then
			else
				self:createDiamond()
			end

	end))
	self:runAction(seq)
	 
end

function SpinCol:parseStart( spinConfig )
	-- if self.colid == self.TestColId then
		-- print("zhf spinConfig =  ",tool.lua_to_json(spinConfig))
	-- end
	 
	if spinConfig.upBounceTime >0 then
		local tAcc = (spinConfig.upBounceMaxSpeed*spinConfig.upBounceTime - spinConfig.upBounce)/spinConfig.upBounceMaxSpeed
		local tMax = spinConfig.upBounceTime - 2*tAcc
		table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = spinConfig.delay})
		table.insert(self.actionQueue,{["endSpeed"] = spinConfig.upBounceMaxSpeed,["totalTime"] = tAcc,["accelerationTime"] = tAcc})
		table.insert(self.actionQueue,{["endSpeed"] = spinConfig.upBounceMaxSpeed,["totalTime"] = tMax})
		table.insert(self.actionQueue,{["endSpeed"] = 0,["totalTime"] = tAcc,["accelerationTime"] = tAcc})
	elseif spinConfig.waitSpinTime and spinConfig.waitSpinTime > 0 then
		table.insert(self.actionQueue,{["delay"] = spinConfig.waitSpinTime,["totalTime"] = spinConfig.waitSpinTime})
	end
	table.insert(self.actionQueue,{["endSpeed"] = spinConfig.maxSpeed,["totalTime"] = spinConfig.speedUpTime,["accelerationTime"] = spinConfig.speedUpTime})
	table.insert(self.actionQueue,{["endSpeed"] = spinConfig.maxSpeed,["totalTime"] = 1000})
end

function SpinCol:parseStop( stopConfig ,colItemList,upitem,downList)
	-- if self.colid == self.TestColId then
	-- 	print("zhf stopConfig = ",tool.lua_to_json(stopConfig))
	-- 	print("zhf colItemList = ",tool.lua_to_json(colItemList))
	-- end
	if stopConfig.ClearAction then
		self.test2 = 1
		self:clearActions()
	end
	self.stopConfig = stopConfig
	self.itemList 	 = colItemList
	self.upList 	 = upitem or {}
	self.downList = downList or {}
	local actions = stopConfig.actions or {}
	for i,action in ipairs(actions) do
		if action["endSpeed"] then
			-- print("zhf action = ",tool.lua_to_json(action))
			table.insert(self.actionQueue,{["endSpeed"] = action["endSpeed"],["totalTime"] = action["totalTime"],["accelerationTime"] = action["accelerationTime"],["beginFun"] = action["beginFun"],["endFun"] = action["endFun"]})
			-- if self.colid == self.TestColId then
			-- 	print("zhf action = ",tool.lua_to_json(action))
			-- 	print("zhf actionQueue = ",tool.lua_to_json(self.actionQueue))
			-- end
		end
	end
	self.test3 = 1 + stopConfig.stopDelay
	self.onDelayStopSchedule = true
	self.delayTotalTime = 0
	
	-- local stopDelayAction = cc.Sequence:create(cc.DelayTime:create(stopConfig.stopDelay), cc.CallFunc:create(function() self:onReelStartStop() end))
	-- stopDelayAction:setTag(777)
	-- self:runAction(stopDelayAction)
end

function SpinCol:onReelStartStop()
	if self:isWaitingStatus() then
		return
	end
	self.test4 = 1
	if self.curStatus ~= ReelStatus.stop and self.curStatus ~= ReelStatus.downbounce then
		self.test5 = 1
		self:clearActions()
		self.curStatus   = ReelStatus.stopping
		self.spinLayer:onBegStop(self.colid)
		self.isReelStoping = true
		if self.stopConfig.stopType == 1 then
			self:normalStop()
			self:parseNormalBounceDown()
		elseif self.stopConfig.stopType == 0 then
			self:paseEaseStop()
			self:parseNormalBounceDown()
		elseif self.stopConfig.stopType == 2 then
			self:pasePhyicalStop()
			self:parsePhysicalBounceDown()
		elseif self.stopConfig.stopType == 3 then
			self:normalStop()
			self:parseFastBounceDown()
		elseif self.stopConfig.stopType == 4 then
			self:normalSpeedStop()
			self:parseFastBounceDown()
		end
		
	end
end

function SpinCol:getAimPosY(  )
	return self:nextCell():getPositionY()
end

function SpinCol:hideVoucherView()
	for i = 0, self.number - 1 do
		local cell = self.cells[i]
		if cell and cell.sprVoucher then
			cell.sprVoucher:setVisible(false)
			cell.sprVoucher.bShow = false
		end
	end
end


--根据时间计算下砸速度
function SpinCol:normalStop( ... )
	local extraCount = self.ExtraSymbolCount
	if self.theme.isTurbo then
		extraCount = extraCount/2
	end
	local aimPosition = self:getAimPosY()

	local distance = -(aimPosition +self.stopConfig.downBounce+(extraCount+0.5)*self.cellHeight-self.basePos.y)
	local endSpeed = distance/self.stopConfig.speedDownTime
	local function onReelReachBottom( )
		self.curSpeed = 0
		self.curStatus = ReelStatus.downbounce
		self.theme:onReelFallBottom(self.colid)
	end
	table.insert(self.actionQueue,{["endSpeed"] = endSpeed,["totalTime"] = self.stopConfig.speedDownTime,["endFun"] = onReelReachBottom})
end

--以MaxSpeed下砸
function SpinCol:normalSpeedStop( ... )
	local extraCount = self.ExtraSymbolCount
	if self.theme.isTurbo then
		extraCount = extraCount/2
	end
	local aimPosition = self:getAimPosY()
	-- while aimPosition < self.basePos.y do
	-- 	local _lastCell = self:lastCell()
	-- 	local _firstCell = self:firstCell()
	-- 	_lastCell:setPositionY(_firstCell:getPositionY()+self.cellHeight)
	-- 	self.lastIndex = self.lastIndex+1
	-- 	if self.lastIndex > self.number-1 then
	-- 		self.lastIndex = 0
	-- 	end 
	-- 	aimPosition = self:getAimPosY()
	-- end
	local distance = -(aimPosition +self.stopConfig.downBounce+(extraCount+0.5)*self.cellHeight-self.basePos.y)
	local stopTime = distance/self.stopConfig.maxSpeed
	local function onReelReachBottom( )
		self.curSpeed = 0
		self.curStatus = ReelStatus.downbounce
		self.theme:onReelFallBottom(self.colid)
	end
	table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.maxSpeed,["totalTime"] = stopTime,["endFun"] = onReelReachBottom})
end

--减速停止方式 用于非 quick stop
function SpinCol:paseEaseStop()
	local extraCount = self.ExtraSymbolCount
	if self.theme.isTurbo then
		extraCount = extraCount/2
	end
	local bounceDis = extraCount*self.cellHeight
	local distance = (self:getAimPosY() + self.stopConfig.downBounce + 0.5*self.cellHeight - self.basePos.y)
	local t1 = -bounceDis/self.stopConfig.maxSpeed
	local v2 = -distance/(self.stopConfig.speedDownTime - t1)
	local function onReelReachBottom( )
		self.curSpeed = 0
		self.curStatus = ReelStatus.downbounce
		self.theme:onReelFallBottom(self.colid)
	end

	table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.maxSpeed,["totalTime"] = t1})
	table.insert(self.actionQueue,{["endSpeed"] = v2,["totalTime"] = self.stopConfig.speedDownTime-t1,["endFun"] = onReelReachBottom})
end

--物理轮子减速方式 用于非 quick stop
function SpinCol:pasePhyicalStop()
	local extraCount = self.ExtraSymbolCount
	if self.theme.isTurbo then
		extraCount = extraCount/2
	end
	local bounceDis = extraCount*self.cellHeight
	local distance = (self:getAimPosY() + 0.5*self.cellHeight - self.basePos.y)
	local speed = -(bounceDis+distance)/self.stopConfig.speedDownTime
	local function onReelReachBottom( )
		self.curSpeed = 0
		self.curStatus = ReelStatus.downbounce
		self.theme:onReelFallBottom(self.colid)
	end
	table.insert(self.actionQueue,{["endSpeed"] = speed,["totalTime"] = self.stopConfig.speedDownTime,["endFun"] = onReelReachBottom})
end

function SpinCol:parseNormalBounceDown()

	local function onReelStoped( ... )
		self.curStatus = ReelStatus.stop
		self:fixResult()
		self.isReelStoping = false
		self.theme:onReelStop(self.colid)
		self.spinLayer:onEndStop(self.colid)
		self.spinLayer:checkDealWithReelStop()
	end
	self.curSpeed = 0
	-- local tAcc = (self.stopConfig.downBounceMaxSpeed*self.stopConfig.downBounceTime - self.stopConfig.downBounce)/self.stopConfig.downBounceMaxSpeed
	-- local tMax = self.stopConfig.downBounceTime - 2*tAcc

	local speed = self.stopConfig.downBounce/self.stopConfig.downBounceTime
	-- local tMax = self.stopConfig.downBounceTime - 2*tAcc
	table.insert(self.actionQueue,{["endSpeed"] = speed,["totalTime"] = self.stopConfig.downBounceTime})
	-- table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.downBounceMaxSpeed,["totalTime"] = tMax})
	-- table.insert(self.actionQueue,{["endSpeed"] = 0,["totalTime"] = 0})
	table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})

	-- if self.colid == self.TestColId then
	-- 	-- print("zhf self.stopConfig = ",tool.lua_to_json(self.stopConfig))
	-- 	print("zhf tMax = ",tMax)
	-- 	print("zhf tAcc = ",tAcc)
	-- 	-- print("zhf self.curSpeed = ",self.curSpeed)
	-- end
		-- print("zhf tMax = ",tMax)
		-- print("zhf tAcc = ",tAcc)
	-- table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.downBounceMaxSpeed,["totalTime"] = tAcc,["accelerationTime"] = tAcc})
	-- table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.downBounceMaxSpeed,["totalTime"] = tMax})
	-- table.insert(self.actionQueue,{["endSpeed"] = 0,["totalTime"] = tAcc,["accelerationTime"] = tAcc})
	-- table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})
end

function SpinCol:parseFastBounceDown()
	local function onReelStoped( ... )
		self.curStatus = ReelStatus.stop
		self:fixResult()
		self.isReelStoping = false
		self.theme:onReelStop(self.colid)
		self.spinLayer:onEndStop(self.colid)
		self.spinLayer:checkDealWithReelStop()
	end
	self.curSpeed = 0
	local speed = self.stopConfig.downBounce/self.stopConfig.downBounceTime
	table.insert(self.actionQueue,{["endSpeed"] = speed,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})
end

function SpinCol:parsePhysicalBounceDown()

	local function onReelStoped( ... )
		self.curStatus = ReelStatus.stop
		self:fixResult()
		self.isReelStoping = false
		self.theme:onReelStop(self.colid)
		self.spinLayer:onEndStop(self.colid)
		self.spinLayer:checkDealWithReelStop()
	end
	self.curSpeed = 0

	table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.shakeDistance,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["endSpeed"] = -self.stopConfig.shakeDistance,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.shakeDistance,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["endSpeed"] = -self.stopConfig.shakeDistance,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["endSpeed"] = self.stopConfig.shakeDistance,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["endSpeed"] = -self.stopConfig.shakeDistance,["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})
end

function SpinCol:parsePhysicalBounceDown_celebrationShake(shakeDistance,shakeTime)

	self.curSpeed = 0

	table.insert(self.actionQueue,{["endSpeed"] = shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = -shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] =shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = -shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = -shakeDistance,["totalTime"] = shakeTime})
end

function SpinCol:fixResult()
	local _currentCell = self:currentCell()
	while _currentCell:getPositionY()<self.basePos.y + (self.row-1)*self.cellHeight do
		self.currentIndex = self:increaseIndex(self.currentIndex)
		_currentCell = self:currentCell()
	end
	while _currentCell:getPositionY()>self.basePos.y + self.row*self.cellHeight do
		self.currentIndex = self:decreaseIndex(self.currentIndex)

		-- self.cells[self.currentIndex - 1]:setVisible(false)
		-- self.cells[self.currentIndex - 2]:setVisible(false)
		-- self.cells[self.currentIndex - 3]:setVisible(false)
		self.showTopid = self.currentIndex

		_currentCell = self:currentCell()
	end
end
--创建
function SpinCol:createDiamond(  )


	for k,theCell in pairs(self.cells) do
		local ui_diamond = theCell:getChildByName("diamondIcon")
		if ui_diamond then
			ui_diamond:removeFromParent()
		end
	end

	local random = 0
	for k,theCell in pairs(self.cells) do
		local item = theCell
		if item then
			local user  = User:getInstance()
			local dia_num = user:getDiamonds()
			random = self:getRandomNum(1,1000)
			local bool = false
			if dia_num <= 100  then
				if 100 >= random then
					bool = true
				end
			elseif dia_num> 100 and dia_num <= 200 then
				if 50 >= random then
					bool = true
				end
			elseif dia_num> 200 and dia_num <= 300 then
				if 25 >= random then
					bool = true
				end
			elseif dia_num> 300 and dia_num <= 400 then
				if 10 >= random then
					bool = true
				end
			elseif dia_num> 400 and dia_num <= 450 then
				if 2 >= random then
					bool = true
				end
			else
				bool = false
			end

			if bool then
				local spName = "commonEffect/newchips/theme" .. THEME_DESKTOP_ID .. "/1.png"
				local ui_diamond = cc.Sprite:create(spName)  
				if THEME_DESKTOP_ID == 194 then
					ui_diamond:setScale(0.5)
					ui_diamond:setPosition(40, -20)
				elseif THEME_DESKTOP_ID == 225 then
					ui_diamond:setScale(1)
					ui_diamond:setPosition(80, -40)
				elseif THEME_DESKTOP_ID == 231 then
					ui_diamond:setScale(0.5)
					ui_diamond:setPosition(70, -35)
				elseif THEME_DESKTOP_ID == 108 then
					ui_diamond:setScale(0.5)
					ui_diamond:setPosition(75, -40)
				elseif THEME_DESKTOP_ID == 240 then
					ui_diamond:setPosition(50, -30)
					ui_diamond:setScale(0.5)
				elseif THEME_DESKTOP_ID == 138 then
					ui_diamond:setPosition(65, -45)
					ui_diamond:setScale(0.5)
				elseif THEME_DESKTOP_ID == 244 then
					ui_diamond:setPosition(65, -45)
					ui_diamond:setScale(0.5)
				elseif THEME_DESKTOP_ID == 174 then
					ui_diamond:setPosition(55, -45)
					ui_diamond:setScale(0.5)
				else
					ui_diamond:setPosition(40, -20)
					ui_diamond:setScale(0.5)
				end
				item:addChild(ui_diamond, 99999)
			 
				ui_diamond:setVisible(true)
				ui_diamond:setName("diamondIcon")
				ui_diamond:setOpacity(0)
				ui_diamond:runAction( cc.FadeIn:create(0.3))
			end
	 
		end
	end

	end

 
 
--钻石飞
function SpinCol: diamondFly( )
	local currentIndex = self.showTopid
	local cells = self.cells
	local delayTime = 0.02;
	for i=0, (self.row - 1)  do
		local temp = (currentIndex - i) % (#cells  + 1)
		local item = cells[temp ]
		delayTime  = delayTime + 0.02
		if item then

			self:runAction(cc.Sequence:create(
				cc.DelayTime:create(delayTime),
				cc.CallFunc:create(function ()
				--获取
				local ui_diamond = item:getChildByName("diamondIcon")
				if ui_diamond then
			 
					ui_diamond:setPosition(0, 0)
						--节点和坐标转换， 换成sence下
					local diamond_Pos =  cc.p(ui_diamond:getPosition())
					local end_pos   = ui_diamond:getParent():convertToWorldSpace(diamond_Pos)
					local endNode   = bole.scene:convertToNodeSpace(end_pos)
					ui_diamond:setPosition(endNode)

					--父节点转换
					bole.changeParent(ui_diamond,bole.scene)

					--获取位移的目标位置
					local diaNode =  User:getInstance().header:getDiamondNode()
					local sp_diamond =  diaNode.diamond_node:getChildByName("sp_diamond")
					local nowPos =  cc.p(sp_diamond:getPosition())
					local end_pos2   = sp_diamond:getParent():convertToWorldSpace(nowPos)
					local targetPos   = bole.scene:convertToNodeSpace(end_pos2)
					

					local bezier = {
						cc.p(ui_diamond:getPosition()),
						cc.p(0, 500),
						targetPos,
					}
				
					local seq = cc.Sequence:create(
						cc.Spawn:create( 
							cc.ScaleTo:create(1,1),
							cc.BezierTo:create(1 , bezier) 
						),
						cc.CallFunc:create(function ()
							--icon 进入光效
							if self.spinLayer.animBool  then
								self.spinLayer.animBool  = false;
								local animSp = self:getLight(diaNode.diamond_node);
								animSp:runAction(cc.Sequence:create(
									cc.DelayTime:create(0.5),
									cc.CallFunc:create(function ()
										animSp:removeFromParent()
										self.spinLayer.animBool = true
									end)
								))
							end
							--移除icon
							ui_diamond:removeFromParent()
							--更新label
							local user  = User:getInstance()
							user:addDiamonds(1, 1)
							local num = user:getDiamonds()
							local label_diamonds = diaNode.diamond_node:getChildByName("label_diamonds")
							label_diamonds:setString(num)
							bole.playSounds("08_collect_wild")
						end)
					)
					ui_diamond:runAction(seq)
				end
			end)
			))
		end
	end
end

function SpinCol: getRandomNum(num1, num2)
    local random_num = math.random(num1, num2) -- 生成num1到num2之间的随机整数 
    return random_num
end

function SpinCol: getLight(parent)
	local path = "commonEffect/header/chips/spines/coins_fly_get/spine"
	local icon = parent:getChildByName("sp_diamond")
	local _, skeleton = bole.addSpineAnimation(parent, nil, path, cc.p(icon:getPosition()), "animation", nil, nil, nil, false, false, nil)
	return skeleton
end

function SpinCol:clearActions()
	self.actionQueue = {}
	self.curAction = nil
	self.onDelayStopSchedule = false
end

function SpinCol:AddActions(spinConfig)
	for i,v in ipairs(spinConfig) do
		table.insert(self.actionQueue, spinConfig[i])
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- spin deal
--------------------------------------------------------------------------------------------------------------------------------------------
function SpinCol:spin(spinConfig)
	if spinConfig.locked then
		self.curStatus = ReelStatus.stop
		self.locked = true
		return nil
	end
	if self.curStatus ~= ReelStatus.stop then
		return nil
	end
	self.locked = false
	self:start(spinConfig)
	self.localZorder = 500
	self.test1 = 0
	self.test2 = 0
	self.test3 = 0
	self.test4 = 0
	self.test5 = 0
	self.test6 = 0
	self.curStatus    = ReelStatus.running

	self.curSpeed = 0
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- stop deal
--------------------------------------------------------------------------------------------------------------------------------------------
function SpinCol:stop(stopConfig, colItemList,upitem,downlist)
	if self.curStatus ~= ReelStatus.running or not self.curAction then
		self.test1 = 1
		if self.curStatus == ReelStatus.running then
			self.stackData = {stopConfig, colItemList,upitem,downlist}
		end
		return nil
	end
	self.stackData = nil
	self:parseStop(stopConfig,colItemList,upitem,downlist)
end
function SpinCol:recoverStop()
	if self.stackData then
		self:stop(self.stackData[1],self.stackData[2],self.stackData[3],self.stackData[4])
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- fast stop deal
--------------------------------------------------------------------------------------------------------------------------------------------
function SpinCol:fastStop()
	if self:isWaitingStatus() then
		return nil
	end
	if self.curStatus == ReelStatus.stop or self.curStatus == ReelStatus.downbounce or not self.itemList then
		return nil
	end
	self.curStatus = ReelStatus.downbounce
	self.test6 = 2
	self:clearActions()
	self:fastResetResult()
	if self.stopConfig.stopType == 1 then
		self:parseNormalBounceDown()
	elseif self.stopConfig.stopType == 0 then
		self:parseNormalBounceDown()
	elseif self.stopConfig.stopType == 2 then
		self:parsePhysicalBounceDown()
	elseif self.stopConfig.stopType == 3 then
		self:parseFastBounceDown()
	elseif self.stopConfig.stopType == 4 then
		self:parseNormalBounceDown()
	end

	self.theme:onReelFastFallBottom(self.colid)
end

function SpinCol:fastResetResult()
	self.curSpeed = 0
	-- for i = 1,self.row do
	-- 	local _lastCell = self:lastCell()
	-- 	local _firstCell = self:firstCell()
	-- 	_lastCell:setPositionY(_firstCell:getPositionY()+self.cellHeight)
	-- 	self.lastIndex = self.lastIndex+1
	-- 	if self.lastIndex > self.number-1 then
	-- 		self.lastIndex = 0
	-- 	end 
	-- end
	local resultIndex = 0
	local moveY = self:currentCell():getPositionY()+self.cellHeight/2 - self.basePos.y + self.stopConfig.downBounce



	if #self.downList >0 then
		self.themeCtl:updateCellSprite(self.cells[self.currentIndex], self.colid, true, self.downList[1],true)
	end
	
	for i = self.currentIndex + 1,self.currentIndex + self.row do

		self.currentIndex = self:increaseIndex(self.currentIndex)
		self.themeCtl:updateCellSprite(self:currentCell(), self.colid, true, self.itemList[self.row-resultIndex],true)
		self.themeCtl:showCellsVoucherLogoFast(self.colid, self:currentCell(), self.row-resultIndex)
		self:refreshCellZOrder(self:currentCell(),self.currentIndex)



		-- local index = i%(self.number)
		-- local cell = self.cells[index]
		-- self.themeCtl:updateCellSprite(cell, self.colid, false, self.itemList[self.row-resultIndex])
		-- self:refreshCellZOrder(cell,index)
		resultIndex = resultIndex+1
	end
	local index = (self.currentIndex+1)%(self.number)
	if #self.upList >0 then
		self.themeCtl:updateCellSprite(self.cells[index], self.colid, true, self.upList[1],true)
	end
	

	for k,theCell in pairs(self.cells) do
		theCell:setPositionY(theCell:getPositionY()-moveY)
	end
end


function SpinCol:resetStopItemList( stopColItemList) -- 控制滚轴 滚动过程中对itemList进行修改，已经进入stop阶段
	if not stopColItemList then return end

	self.itemList = stopColItemList
end
function SpinCol:resetSpinColInfo(data)
	if data.cellHeight then
		self.cellHeight = data.cellHeight
	end
	if data.row then
		self.row = data.row
		self.addBelow = self.number - self.row - self.addTop
	end
end
function SpinCol:setWaitingStatus()
	if self.curStatus == ReelStatus.stop or self.curStatus == ReelStatus.downbounce or not self.itemList then
		return nil
	end
	self.lastCurStatus = self.curStatus
	self.curStatus = ReelStatus.waiting
end
function SpinCol:isWaitingStatus()
	return self.curStatus == ReelStatus.waiting
end
function SpinCol:recoverLastStatus()
	if self.lastCurStatus then
		self.curStatus = self.lastCurStatus
	end
	self.lastCurStatus = nil
end

 