
-- 每帧移动的距离大于单格cell高度的时候回出问题，需要重新考虑SpinCol:refresh与SpinCol:resetSpinNodePosY的书写
---------------------------------------------------------------------------------------------------------
-- 棋盘
-- @ 用于up滚轴有多个，同时需要展示的情况
-- @ upList 可以是多个情况，可以正常展示
---------------------------------------------------------------------------------------------------------
local l_fast_adjust_pos_y = 0
local ReelStatus = {
	["start"] = 1,
	["running"] = 2,
	["stopping"] = 3,
	["downbounce"] = 4,
	["stop"] = 5
}
local SpinLayerE = class("SpinLayerExtend", SpinLayer)
local SpinColE = class("SpinColExtend", SpinCol)

local l_win_size 	  = cc.Director:getInstance():getWinSize()

function SpinLayerE:ctor(theme, themeCtl,reelConfigList,boardNode)
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
		local theSpinReel = SpinColE.new(col, self, reelNode, reelConfig,self.theme.UnderPressure)
		reelNode:addChild(theSpinReel)
		self.spins[col]     = theSpinReel
	end
	
	self.running 	= false
	self.stopping 	= false
	self.endCallFunc= nil 
end

---------------------------------------------------------------------------------------------------------
-- nsm
-- 1，每一列都可以单独控制，与其他无强制关系
-- 2，停靠时通过self.curRowIndex来进行控制
---------------------------------------------------------------------------------------------------------
function SpinColE:ctor(colid, spinLayer, reelNodeParent, reelConfig)
	SpinCol.ctor(self, colid, spinLayer, reelNodeParent, reelConfig)
end

function SpinColE:nextCell()
	local tempIndex = self.currentIndex+self.addTop
	if tempIndex > self.number-1 then
		tempIndex = tempIndex%(self.number)
	end 
	return self.cells[tempIndex]
end

function SpinColE:fastResetResult()
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
		self:refreshCellZOrder(self:currentCell(),self.currentIndex)



		-- local index = i%(self.number)
		-- local cell = self.cells[index]
		-- self.themeCtl:updateCellSprite(cell, self.colid, false, self.itemList[self.row-resultIndex])
		-- self:refreshCellZOrder(cell,index)
		resultIndex = resultIndex+1
	end
	
	if #self.upList >0 then
		for i, value in pairs(self.upList) do 
			local index = (self.currentIndex+i)%(self.number)
			self.themeCtl:updateCellSprite(self.cells[index], self.colid, true, value,true)
		end
	end
	

	for k,theCell in pairs(self.cells) do
		theCell:setPositionY(theCell:getPositionY()-moveY)
	end
end

return SpinLayerE
