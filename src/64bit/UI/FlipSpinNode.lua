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
	["stop"] = 5
}
FlipSpinLayer = class("FlipSpinLayer", function() return cc.Layer:create() end)
local l_win_size 	  = cc.Director:getInstance():getWinSize()

function FlipSpinLayer:ctor(theme, themeCtl,reelConfigList,boardNode)
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
	-- 初始化整体布局显示
	
	-- 初始化滚轴列
	for col,reelConfig in pairs(reelConfigList) do
		local reelNode    = boardNode:getReelNode(col) -- 获得整个棋盘的板子节点
		local theSpinReel = FlipSpinCol.new(col, self, reelNode, reelConfig,self.theme.UnderPressure)
		reelNode:addChild(theSpinReel)
		self.spins[col]     = theSpinReel
	end
	
	self.running 	= false
	self.stopping 	= false
	self.endCallFunc= nil
end

function FlipSpinLayer:getCellsByCol(col)
	return self.spins[col]:getCells()
end

function FlipSpinLayer:getCellSize( col )
	return cc.size(self.reelConfig[col].cellWidth,self.reelConfig[col].cellHeight)
end

function FlipSpinLayer:moveReel(colId, count, time)-- 列Id 、向下移动个数(正数向下,负数向上)、时间(s)
	self.spins[colId]:moveReel(count,time)
end

function FlipSpinLayer:setIconAtIndex( colId,index,key )
	self.spins[colId]:setIconAtIndex(index,key)
end

function FlipSpinLayer:Active(onlyShowBoard)
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
							local dialog = ClientErrorDialog.new()
							dialog:show()
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

function FlipSpinLayer:DeActive(notHideBoard)
	self.isActive = false
	self.running 	 = false
	self.stopping 	 = false
	if notHideBoard then 
		-- self.boardNode:setVisible(false)
	else
		self.boardNode:setVisible(false)
		self:resetBoard()
	end
	self:unscheduleUpdate()
end

function FlipSpinLayer:getCellPos( col, row )
	local reel = self.spins[col]
	-- local addPos  = cc.p(0.5*reel.cellWidth, (reel.row+reel.addTop-row-0.5)*reel.cellHeight)
	local addPos  = cc.p(0.5*reel.cellWidth, (reel.row - row + 0.5)*reel.cellHeight)
	return cc.pAdd(self.spins[col].basePos, addPos)
end

function FlipSpinLayer:refreshCellsZOrder( pcol)	-- 之后 设置 再进行查看
	if pcol then
		self.spins[pcol]:refreshCellsZOrder()
	else
		for index,theReel in pairs(self.spins) do
		theReel:refreshCellsZOrder()
		end
	end
	
end

function FlipSpinLayer:setSymbolStatus(visible)	-- 之后 设置 再进行查看
	for index,theReel in pairs(self.spins) do
		theReel:setSymbolStatus(visible)
	end
end
function FlipSpinLayer:checkDealWithReelStop( )
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
function FlipSpinLayer:getCenterPos( )
	return cc.p(l_win_size.width/2, l_win_size.height/2)
end

function FlipSpinLayer:getModifyNode( )
	return self.modifyNode
end
---------------------------------------------------------------------------------------
function FlipSpinLayer:startCalculateRequestTime( isStartSpin )
	if isStartSpin then 
		self.startCalculateSpinTime = true
	else
		self.startCalculateSpinTime = false
	end
end

function FlipSpinLayer:spin( spinConfig )
	if self.running then
		return nil
	end	
	self.running 	 = true
	self.rotatedTime = 0
	self.isShowingError = false
	self.startCalculateSpinTime = false
	self.endCallFunc = nil
	self.itemList 	 = nil
	for _,theReelConfig in ipairs(spinConfig) do
		local col 			= theReelConfig["col"]
		local actionConfig 	= theReelConfig["action"]
		self.spins[col]:spin(actionConfig)
	end
end

function FlipSpinLayer:onBegStop( colid )
	if self.stopCallConfig[colid] and self.stopCallConfig[colid].begCallFunc then
		self.stopCallConfig[colid].begCallFunc()
		self.stopCallConfig[colid].begCallFunc = nil
	end
end
function FlipSpinLayer:onEndStop( colid )
	if self.stopCallConfig[colid] and self.stopCallConfig[colid].endCallFunc then
		self.stopCallConfig[colid].endCallFunc()
		self.stopCallConfig[colid].endCallFunc = nil
	end	
end
function FlipSpinLayer:cleanStopState( )
	self.stopCallConfig = {}
	self.stopStartCall  = nil
end
function FlipSpinLayer:stop( stopConfig, stopItemList,uplist,downlist,endCallFunc )
	if not self.running or self.stopping then
		return nil
	end
	self.isShowingError = true
	-- bole.cleanAction(self.actionNode)	
	self.stopCallConfig = {}
	self.stopStartCall  = nil	
	self.endCallFunc 	= endCallFunc
	self.itemList 	 	= stopItemList
	self.stopping    	= true		
	-- for col,_ in pairs(self.spins) do
	-- 	self.spins[col].curRowIndex = nil
	-- end
	for index,stopReelConfig in pairs(stopConfig) do
		local theCol 	  = stopReelConfig[1]
		local theAction   = stopReelConfig[2]
		local colItemList = stopItemList[theCol]
		self.spins[theCol]:stop(theAction, colItemList,uplist and uplist[theCol],downlist and downlist[theCol])
	end
end

function FlipSpinLayer:fastStop()
	if not self.running or not self.itemList then
		return nil
	end
	for _,reel in ipairs(self.spins) do
		reel:fastStop()
	end
end

---------------------------------------------------------------------------------------
function FlipSpinLayer:stopChildActions( ... )
	for i = 1,#self.spins do
		local node  = self.spins[i]
		for _,theCell in pairs(node.cells) do
			bole.stopAllActions(theCell)
			theCell:setVisible(true)	
			theCell:setOpacity(255)	
			theCell:getChildren()[1]:setVisible(true)
		end		
	end	
end

function FlipSpinLayer:reelSpecialCelebrationShake(shakeDistance,shakeTime,colIndex)
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

function FlipSpinLayer:updateFreeBack( freeSpin )	
	-- for i = 1, self.theme.col do
	-- 	self.theme:updateReelFreeBack(self.reelBack[i], freeSpin, i)
	-- end
end
function FlipSpinLayer:setReelOpacityDown(list,time,opacity) -- 控制滚轴 显示灰色蒙版 通过透明度来控制
	for _,v in pairs(list) do
		if self.spins[v] then
			local reelNode = self.spins[v]
			bole.setEnableRecursiveCascading(reelNode, true)
			reelNode:runAction(cc.FadeTo:create(time, opacity))	
		end
	end
end
function FlipSpinLayer:setReelOpacityUp(list,time,opacity) -- 控制滚轴 关闭灰色蒙版 通过透明度来控制
	for _,v in pairs(list) do
		if self.spins[v] then
			local reelNode = self.spins[v]
		
			bole.setEnableRecursiveCascading(reelNode, true)
			reelNode:runAction(cc.FadeIn:create(time))	
		end
	end
end

function FlipSpinLayer:resetBoard() -- 控制滚轴 关闭灰色蒙版 通过透明度来控制
	for col,_ in pairs(self.spins) do
		self.spins[col]:resetCol()
	end
end
-- 
function FlipSpinLayer:hideVoucherView()
	for col,_ in pairs(self.spins) do
		self.spins[col]:hideVoucherView()
	end
end

---------------------------------------------------------------------------------------------------------
-- nsm
-- 1，每一列都可以单独控制，与其他无强制关系
-- 2，停靠时通过self.curRowIndex来进行控制
---------------------------------------------------------------------------------------------------------
FlipSpinCol = class("FlipSpinCol", function() return cc.Node:create() end)
function FlipSpinCol:ctor(colid, spinLayer, reelNodeParent, reelConfig)
	self.colid 	  		= colid
	self.spinLayer 		= spinLayer
	self.theme 	  		= spinLayer.theme
	self.themeCtl 	    = spinLayer.themeCtl
	self.row 	  		= reelConfig["symbolCount"]
	self.cellWidth 		= reelConfig["cellWidth"]
	self.cellHeight 	= reelConfig["cellHeight"]
	-- self.basePos 	    = cc.p(0,0)-- reelConfig["adjust_pos"] 修改因为把cell 放到每个reel 上面,同时reel自身有偏移
	self.reelNode 		= reelNodeParent-- cc.Node:create()

	self.basePos 	    = reelConfig["base_pos"] --修改因为把cell 放到每个reel 上面,同时reel自身有偏移
	-- self.reelNode 		= reelNodeParent -- cc.Node:create()
	-- reelNode:addChild(self.reelNode)
	------------------------------------------------------------------
	self.number	  = self.row -- self.addBelow + self.row  + self.addTop 
	self.minIndex = 0 -- 表示最上面的一个 id 从0 开始
	self.maxIndex = self.number-1 -- 表示最下面的一个 id
	self.localZorder = 0
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
			local sprVoucher = libUI.createSprite(s1, "commonpics/voucher_spin_logo_2.png")
			local fntVouCount = libUI.createFont(sprVoucher, "header_footer/style1/header/images/header_01.fnt", cc.p(34, 21), nil, 1)
			local adjustPos 		= cc.p(0.5*self.cellWidth, (i+0.5)*self.cellHeight)
			local cellPos   		= cc.pAdd(self.basePos, adjustPos)
			s1:setPosition(cellPos)
			sprVoucher:setPosition(cc.p(self.cellWidth * 0, -self.cellHeight * 0.2))
			sprVoucher:setVisible(false)
			fntVouCount:setString("")
			fntVouCount:setScale(0.71)
			self.reelNode:addChild(s1)
			self.cells[i] 			= s1
			s1.cell_index = i
			s1.sprVoucher = sprVoucher
			s1.fntVouCount = fntVouCount
		end
	end
	self.lastIndex = self.minIndex
	self.currentIndex = self.row-1
	self.actionQueue = {}
	self.curAction   = nil
	self.curStatus 	 = ReelStatus.stop
	self.ret 	  	 = nil
	self.itemList    = nil
	self.ExtraSymbolCount = 6
	self.TestColId = 1

	self.zOrderUnit = 1
	if self.theme.UnderPressure and self.theme.UnderPressure == 1 then -- 下压上逻辑
		self.zOrderUnit = -1
	end
	
end

function FlipSpinCol:resetCol()
	self:clearActions()
	self.curStatus = ReelStatus.stop
	self:resetCellsPosition()
	self.lastIndex = self.minIndex
	self.currentIndex = self.row-1
	self.curSpeed = 0
	self.curAction  = nil
	self.isReelStoping = false
end

function FlipSpinCol:getCells()
	return self.cells
end

function FlipSpinCol:resetCellsPosition()
	for index= self.minIndex,self.maxIndex do
		local theCell 	 = self.cells[index]
		local adjustPos 		= cc.p(0.5*self.cellWidth, (index+0.5)*self.cellHeight)
		local cellPos   		= cc.pAdd(self.basePos, adjustPos)
		-- self.themeCtl:updateCellSprite(theCell, self.colid, false, nil)
		theCell:setPosition(cellPos)
	end
end

function FlipSpinCol:getPreviousCellByIndex( index ) -- 获得索引相对应的cell 
	local cellIndex = index - 1
	if cellIndex < 0 then
		cellIndex = cellIndex+self.number
	elseif cellIndex > self.number - 1 then
		cellIndex = 0
	end
	return self.cells[cellIndex]
end

function FlipSpinCol:getRetCell( index ) -- 获得索引相对应的cell 
	local cellIndex = self.currentIndex - index + 1
	if cellIndex < 0 then
		cellIndex = cellIndex+self.number
	elseif cellIndex > self.number - 1 then
		cellIndex = 0
	end
	return self.cells[cellIndex]
end
--从0号位置更新 zorder
function FlipSpinCol:refreshCellsZOrder()	-- 之后 设置 再进行查看
	for index= self.minIndex,self.maxIndex do-- self.minIndex,self.maxIndex do
		local theCell 	 = self.cells[index]
		self:refreshCellZOrder(theCell,index)
	end
end
--从滚轴的最下面到上面更新 zorder
function FlipSpinCol:refreshCellsZOrderFromBottom( ... )
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

function FlipSpinCol:refreshCellZOrder(theCell,index)
	local baseZOrder = self.localZorder
	self.localZorder = self.localZorder + self.zOrderUnit
	local colZorder  = self.colid
	local addZOrder  = theCell.curZOrder or 0

	theCell:setLocalZOrder(baseZOrder+colZorder+addZOrder)
end

function FlipSpinCol:setSymbolStatus(visible)	-- 之后 设置 再进行查看
	for _,theCell in pairs(self.cells) do
		theCell:setVisible(visible)
		theCell.sprite:setVisible(visible)
		theCell.sprite:setOpacity(255)
		theCell:setScale(1)
	end
end

function FlipSpinCol:moveReel(count,time) -- 移动 reel 可以理解为 多翻转一个
	local moveEnd = false
	local function onMoveEnd( )
		if not moveEnd then
			moveEnd = true
			self:fixResult()
		end
	end
	local dis = -count*self.cellHeight
	for idx,theCell in pairs(self.cells) do 
		theCell:runAction(cc.Sequence:create(cc.MoveBy:create(time, cc.p(0,dis)),cc.CallFunc:create(onMoveEnd)))
	end
end

function FlipSpinCol:setIconAtIndex( index ,key)
	if index < 0 then
		index = index - self.row + 1
	end
	local iconIndex = (self.currentIndex + index + self.number)%self.number
	local cell = self.cells[iconIndex]

	self.theme:updateCellSprite(self.cells[iconIndex],key, self.colid, false,true)
end

function FlipSpinCol:updateCallFunc(dt) -- 移动控制回调
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

		if self.curAction.beginFun then
			self.curAction.beginFun(self.colid)
		end
	end
	if self.curAction then
		self:refresh(dt)
	end
end

function FlipSpinCol:refresh(dt)  -- whj: 现在仅用来控制时间
	self.currentTime = self.currentTime+dt
	local timeLeft = 0
	local isCurrentActionEnd = false
	
	if self.currentTime >= self.curAction.totalTime then
		timeLeft = self.currentTime - self.curAction.totalTime
		isCurrentActionEnd = true
		dt = dt - timeLeft
	end
	-- if not self.curAction.delay then
	-- 	-- 进行控制播放翻转动画
	-- end
	if isCurrentActionEnd then
		if self.curAction.endFun then
			self.curAction.endFun(self.colId)
		end
		self.curAction = nil
	end
	if timeLeft > 0 then
		self:updateCallFunc(timeLeft)
	end
end

function FlipSpinCol:currentCell()
	return self.cells[self.currentIndex]
end

function FlipSpinCol:nextCell()
	local tempIndex = self.currentIndex+1
	if tempIndex > self.number-1 then
		tempIndex = 0
	end 
	return self.cells[tempIndex]
end

function FlipSpinCol:firstCell()
	local firstIndex = self.lastIndex -1
	if firstIndex < 0 then
		firstIndex = self.number - 1
	end
	return self.cells[firstIndex]
end

function FlipSpinCol:lastCell()
	return self.cells[self.lastIndex]
end

function FlipSpinCol:increaseIndex(index)
	local tempIndex = index+1
	if tempIndex > self.number-1 then
		tempIndex = 0
	end 
	-- whj
	-- local _firstCell = self:firstCell()
	-- local _lastCell = self:lastCell()
	-- _lastCell:setPositionY(_firstCell:getPositionY()+self.cellHeight)
	self.lastIndex = self.lastIndex+1
	if self.lastIndex > self.number-1 then
		self.lastIndex = 0
	end

	return tempIndex
end

function FlipSpinCol:decreaseIndex(index)
	local tempIndex = index -1
	if tempIndex < 0 then
		tempIndex = tempIndex+self.number
	end
	-- whj
	-- local _firstCell = self:firstCell()
	-- local _lastCell = self:lastCell()
	-- _firstCell:setPositionY(_lastCell:getPositionY()-self.cellHeight)
	self.lastIndex = self.lastIndex-1
	if self.lastIndex <0 then
		self.lastIndex = self.number-1
	end
	return tempIndex
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- start deal
--------------------------------------------------------------------------------------------------------------------------------------------
function FlipSpinCol:start(spinConfig)
	-- print("zhf SpinCol:start = ")
	self.itemList     = nil
	self.curStatus    = ReelStatus.start
	self.spinNode:stopAllActions()
	self.spinConfig = spinConfig
	------------------------------
	self.actionQueue = {}
	self:parseStart(spinConfig)
end

function FlipSpinCol:parseStart( spinConfig )
	-- 进行开始动画 
	local function onReelHideFlip( )
		self.theme:onReelHideFlip(self.colid)
	end
	table.insert(self.actionQueue,{["totalTime"] = spinConfig.rollingOverTime,["beginFun"] = onReelHideFlip})
	table.insert(self.actionQueue,{["totalTime"] = 1000})
	
end

function FlipSpinCol:parseStop( stopConfig ,colItemList,upitem,downList)
	if stopConfig.ClearAction then
		self:clearActions()
	end
	self.stopConfig = stopConfig
	self.itemList 	 = colItemList
	-- local actions = stopConfig.actions or {}
	-- for i,action in ipairs(actions) do
	-- 	if action["endSpeed"] then
	-- 		table.insert(self.actionQueue,{["totalTime"] = action["totalTime"],["beginFun"] = action["beginFun"],["endFun"] = action["endFun"]})
	-- 	end
	-- end
	self.onDelayStopSchedule = true
	self.delayTotalTime = 0
	-- local stopDelayAction = cc.Sequence:create(cc.Sequence:create(cc.DelayTime:create(stopConfig.stopDelay), cc.CallFunc:create(function() self:onReelStartStop() end)))
	-- stopDelayAction:setTag(777)
	-- self:runAction(stopDelayAction)
end

function FlipSpinCol:onReelStartStop()
	if self.curStatus ~= ReelStatus.stop and self.curStatus ~= ReelStatus.downbounce then
		self:clearActions()
		self.curStatus   = ReelStatus.stopping
		self.spinLayer:onBegStop(self.colid)
		self.isReelStoping = true
		if self.stopConfig.stopType == 1 then
			self:normalStop()
			self:parseNormalBounceDown()
		-- elseif self.stopConfig.stopType == 0 then
		-- 	self:paseEaseStop()
		-- 	self:parseNormalBounceDown()
		-- elseif self.stopConfig.stopType == 2 then
		-- 	self:pasePhyicalStop()
		-- 	self:parsePhysicalBounceDown()
		-- elseif self.stopConfig.stopType == 3 then
		-- 	self:normalStop()
		-- 	self:parseFastBounceDown()
		end
		
	end
end

--匀速停止方式  用于非 quick stop
function FlipSpinCol:normalStop()
	local function onReelReachBottom( ) -- 更新 cell 的图片
		self:fastResetResult()
		self.curStatus = ReelStatus.downbounce
		self.curSpeed = 0
		self.theme:onReelFallBottom(self.colid)
	end
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.speedDownTime,["beginFun"] = onReelReachBottom})
end

--减速停止方式 用于非 quick stop
function FlipSpinCol:paseEaseStop()
	local extraCount = self.ExtraSymbolCount
	if self.theme.isTurbo then
		extraCount = extraCount/2
	end
	local bounceDis = extraCount*self.cellHeight
	local distance = (self:nextCell():getPositionY() + self.stopConfig.downBounce + 0.5*self.cellHeight - self.basePos.y)
	local t1 = -bounceDis/self.spinConfig.maxSpeed
	local v2 = -distance/(self.stopConfig.speedDownTime - t1)
	local function onReelReachBottom( )
		self.curSpeed = 0
		self.curStatus = ReelStatus.downbounce
		self.theme:onReelFallBottom(self.colid)
	end

	table.insert(self.actionQueue,{["endSpeed"] = self.spinConfig.maxSpeed,["totalTime"] = t1})
	table.insert(self.actionQueue,{["endSpeed"] = v2,["totalTime"] = self.stopConfig.speedDownTime-t1,["endFun"] = onReelReachBottom})
end

--物理轮子减速方式 用于非 quick stop
function FlipSpinCol:pasePhyicalStop()
	local extraCount = self.ExtraSymbolCount
	if self.theme.isTurbo then
		extraCount = extraCount/2
	end
	local bounceDis = extraCount*self.cellHeight
	local distance = (self:nextCell():getPositionY() + 0.5*self.cellHeight - self.basePos.y)
	local speed = -(bounceDis+distance)/self.stopConfig.speedDownTime
	local function onReelReachBottom( )
		self.curSpeed = 0
		self.curStatus = ReelStatus.downbounce
		self.theme:onReelFallBottom(self.colid)
	end
	table.insert(self.actionQueue,{["endSpeed"] = speed,["totalTime"] = self.stopConfig.downBounceTime,["endFun"] = onReelReachBottom})
end

function FlipSpinCol:parseNormalBounceDown()
	local function onReelResultStartShow( )
		self.theme:onReelShowFlip(self.colid)
		self.curStatus = ReelStatus.downbounce
		self.curSpeed = 0
	end
	local function onReelStoped( ... )
		self.curStatus = ReelStatus.stop
		-- self:fixResult()
		self.isReelStoping = false
		self.theme:onReelStop(self.colid)
		self.spinLayer:onEndStop(self.colid)
		self.spinLayer:checkDealWithReelStop()
	end
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime,["beginFun"] = onReelResultStartShow})
	table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})
end

function FlipSpinCol:parseFastBounceDown()
	local function onReelStoped( ... )
		self.curStatus = ReelStatus.stop
		-- self:fixResult()
		self.isReelStoping = false
		self.theme:onReelStop(self.colid)
		self.spinLayer:onEndStop(self.colid)
		self.spinLayer:checkDealWithReelStop()
	end
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})
end

function FlipSpinCol:parsePhysicalBounceDown()

	local function onReelStoped()
		self.curStatus = ReelStatus.stop
		self:fixResult()
		self.isReelStoping = false
		self.theme:onReelStop(self.colid)
		self.spinLayer:onEndStop(self.colid)
		self.spinLayer:checkDealWithReelStop()
	end
	self.curSpeed = 0

	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["totalTime"] = self.stopConfig.downBounceTime})
	table.insert(self.actionQueue,{["delay"] = 1,["totalTime"] = 0,["beginFun"] = onReelStoped})
end

function FlipSpinCol:parsePhysicalBounceDown_celebrationShake(shakeDistance,shakeTime)
	self.curSpeed = 0
	table.insert(self.actionQueue,{["endSpeed"] = shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = -shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] =shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = -shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = shakeDistance,["totalTime"] = shakeTime})
	table.insert(self.actionQueue,{["endSpeed"] = -shakeDistance,["totalTime"] = shakeTime})
end

function FlipSpinCol:fixResult()
	local _currentCell = self:currentCell()
	while _currentCell:getPositionY()<self.basePos.y + (self.row-1)*self.cellHeight do
		self.currentIndex = self:increaseIndex(self.currentIndex)
		_currentCell = self:currentCell()
	end
	while _currentCell:getPositionY()>self.basePos.y + self.row*self.cellHeight do
		self.currentIndex = self:decreaseIndex(self.currentIndex)
		_currentCell = self:currentCell()
	end
end

function FlipSpinCol:clearActions()
	self.actionQueue = {}
	self.curAction = nil
	self.onDelayStopSchedule = false
end

function FlipSpinCol:AddActions(spinConfig)
	for i,v in ipairs(spinConfig) do
		table.insert(self.actionQueue, spinConfig[i])
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- spin deal
--------------------------------------------------------------------------------------------------------------------------------------------
function FlipSpinCol:spin(spinConfig)
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
	self.curStatus    = ReelStatus.running
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- stop deal
--------------------------------------------------------------------------------------------------------------------------------------------
function FlipSpinCol:stop(stopConfig, colItemList,upitem,downlist)
	
	if self.curStatus ~= ReelStatus.running or not self.curAction then
		return nil
	end	
	self:parseStop(stopConfig,colItemList)
end

--------------------------------------------------------------------------------------------------------------------------------------------
-- fast stop deal
--------------------------------------------------------------------------------------------------------------------------------------------
function FlipSpinCol:fastStop()
	if self.curStatus == ReelStatus.stop or self.curStatus == ReelStatus.downbounce or not self.itemList then
		return nil
	end
	self.curStatus = ReelStatus.downbounce
	self:clearActions()
	self:fastResetResult()
	if self.stopConfig.stopType == 1 then
		self:parseNormalBounceDown()
	-- elseif self.stopConfig.stopType == 0 then
	-- 	self:parseNormalBounceDown()
	-- elseif self.stopConfig.stopType == 2 then
	-- 	self:parsePhysicalBounceDown()
	-- elseif self.stopConfig.stopType == 3 then
	-- 	self:parseFastBounceDown()
	end
	self.theme:onReelFastFallBottom(self.colid)
end

function FlipSpinCol:fastResetResult()
	-- 更新结果的 symbol
	local resultIndex = 0
	for i = self.currentIndex + 1,self.currentIndex + self.row do -- 同一列 的 symbol 倒叙赋值的
		self.currentIndex = self:increaseIndex(self.currentIndex) -- 增加 cell 的 Index 计数
		self.themeCtl:updateCellSprite(self:currentCell(), self.colid, true, self.itemList[self.row-resultIndex],nil)
		self.themeCtl:showCellsVoucherLogoFast(self.colid, self:currentCell(), self.row-resultIndex, true)
		self:refreshCellZOrder(self:currentCell(),self.currentIndex)
		resultIndex = resultIndex+1

		local key = self.themeCtl.theme:getCoinInfoKey(self.colid)
		self.themeCtl.theme:updateCellOtherAssets(self:currentCell(),key,self.colid)
	end
end

function FlipSpinCol:hideVoucherView()
	for i = 0, self.number - 1 do
		local cell = self.cells[i]
		if cell and cell.sprVoucher then
			cell.sprVoucher:setVisible(false)
			cell.sprVoucher.bShow = false
		end
	end
end