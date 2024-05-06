local BLControllerBase = require("UI/CreatorUI/BLControllerBase")

local LOBBY_MAIN_HEIGHT = 560
local LOBBY_THEME_LEFT_MARGIN = 19

local LOBBY_SIDER_BAR_WIDTH = 100
local LOBBY_SIDER_BAR_UPFOLD = 180

local lobbyPageColCnt = 4
local lobbyThemeWidth = 234
local lobbyThemeLineWidth = 60
local lobbyFavoriteMargin = 34
local lobbyDoubleWidth = 468

local TableView = class("TableView", BLControllerBase)

function TableView:ctor()
    BLControllerBase.ctor(self)
    self.moveCellIndex = 0
    self.width = 210;
    self.height = 250;

    self.paddingTop = 0;
    self.paddingBottom = 0
    self.paddingLeft = 0;
    self.paddingRight = 0;
    self.spacingX = 0;
    self.spacingY = 0;

    self.groupHeight = 0;
    self.groupWidth = 0;

    self.cellWidth = 210;
    self.cellHeight = 250;

    self.nodeMaxOffsetY = 0
    self.itemNodes = {};
    self.itemNode = nil;
    self.data = {}
    self.dataList = {}
end

function TableView:setNode(_node)
    self.node = _node
    local size = _node:getContentSize()
    self.width = size.width
    self.height = size.height
end

function TableView:initUI()
    self.node = self:getRoot();
    local size = self.node:getContentSize()
    self.width = size.width
    self.height = size.height
end

function TableView:updateDataList(_dataList)
    self.dataList = _dataList;
    self:updateCells()
end

function TableView:setViewData(_data)
    for k, v in pairs(_data) do
        self[k] = v
    end
    self.dataList = _data.data.dataList
    self:initTableView()
end

function TableView:initTableView()
    local showMaxCell = math.floor((self.height - self.paddingTop - self.paddingBottom + self.spacingY) / (self.cellHeight + self.spacingY)) + 2
    local cellCount = math.floor((self.width - self.paddingLeft - self.paddingRight + self.spacingX) / (self.cellWidth + self.spacingX))
    self.showMaxCell = showMaxCell
    self.cellCount = cellCount
    local itemCount = cellCount * showMaxCell
    local addNode = nil
    for i=1, itemCount do
        if self.itemNodes[i] == nil then
            addNode = self.itemNode.new(self.cellWidth, self.cellHeight)
            self.node:addChild(addNode, 1)
            
            self.itemNodes[i] = addNode
        end
    end

    local cellNum = math.floor(#self.dataList / cellCount) + 1
    if #self.dataList % cellCount == 0 then
        cellNum = cellNum - 1
    end
    
    local nodeSize = cc.size(self.width, cellNum * (self.cellHeight + self.spacingY) + self.paddingTop + self.paddingBottom)
    self.nodeMaxOffsetY = nodeSize.height - self.height
    
    self.groupHeight = nodeSize.height
    self.groupWidth = nodeSize.width
    if self.node.setInnerContainerSize then
        nodeSize.height = math.max(nodeSize.height, self.height)
        self.groupHeight = nodeSize.height
        self.node:setInnerContainerSize(nodeSize)
    end
    

    if self.listViewListener == nil and self.node.addEventListener then
        self.node:addEventListener(function(event, tag)
            if tag == ccui.ScrollviewEventType.containerMoved then
                local y = self.node:getInnerContainerPosition().y
                self:updateViewOffseY(y)
            end
        end)
        self.listViewListener = true
    end
    self:updateCells()
end

function TableView:updateViewOffseY(y)
    y = y + self.nodeMaxOffsetY
    if y > 0 and y < self.nodeMaxOffsetY then
        self:updateCellAtIndex(math.floor(y /( self.cellHeight + self.spacingY)))
    end
end

-- 更新当前在第几行
function TableView:updateCellAtIndex(_index)

    if self.moveCellIndex ~= _index then
        self.moveCellIndex = _index
        self:updateCells()
    end
end

-- 更新每个item
function TableView:updateCells(_isUpdate)
    local index = self.cellCount * self.moveCellIndex;
    local maxCell = self.showMaxCell;
    local itemCount = self.cellCount * maxCell;
    local listView = self.node;
    
    local pos = nil;
    local themeIndex = index + 1

    local anchor = self.itemNodes[1]:getAnchorPoint()

    local x, y = self.cellWidth * anchor.x + self.paddingLeft, self.groupHeight - self.cellHeight * (1-anchor.y) - self.paddingTop;
    y = y - (self.moveCellIndex * (self.cellHeight +self.spacingY))
    
    local nodeIndex = 0;

    for i = themeIndex, themeIndex + itemCount - 1 do
        local nodeIndex = i % itemCount
        if nodeIndex == 0 then
            nodeIndex = itemCount
        end
        if self.dataList[i] == nil then
            self.itemNodes[nodeIndex]:setVisible(false)
            -- 移除屏幕外
            self.itemNodes[nodeIndex]:setPositionY(-200)
        else
            self.itemNodes[nodeIndex]:setVisible(true)
            
   
            self.itemNodes[nodeIndex]:setPosition(x, y)
            if (i ~= self.itemNodes[nodeIndex].__index and self.itemNodes[nodeIndex].updateNode) or _isUpdate == true then
                self.itemNodes[nodeIndex].__index = i
                self.itemNodes[nodeIndex]:updateNode(i, self.data)
            end
        end
        
        x = x + self.cellWidth + self.spacingX
        if i % self.cellCount == 0 then
            x = self.cellWidth * anchor.x + self.paddingLeft
            y = y - self.cellHeight - self.spacingY
        end
    end
end

function TableView:reloadData()
    self:updateCells(true)
end

-- 获取第一个cell
function TableView:getFirstCellNode()
    if self.itemNodes and self.itemNodes[1] then
        return self.itemNodes[1]
    end
end

return TableView
