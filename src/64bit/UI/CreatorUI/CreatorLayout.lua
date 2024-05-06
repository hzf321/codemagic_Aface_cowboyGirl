local BLControllerBase = require("UI/CreatorUI/BLControllerBase")
-- 布局类型
local Type = {
    -- 取消布局
    NONE = 0,
    -- 水平布局
    HORIZONTAL = 1,
    --  垂直布局
    VERTICAL = 2,
    -- 网格布局
    GRID = 3
};

-- 缩放模式
local ResizeMode = {
    -- 不做任何缩放
    NONE = 0,
    -- 容器的大小会根据子节点的大小自动缩放。
    CONTAINER = 1,
    -- 子节点的大小会随着容器的大小自动缩放。
    CHILDREN = 2
};

--  布局轴向，只用于 GRID 布局。
local AxisDirection = {
    -- 进行水平方向布局
    HORIZONTAL = 0,
    -- 进行垂直方向布局
    VERTICAL = 1
};

--  垂直方向布局方式
local VerticalDirection = {
    -- 从下到上排列
    BOTTOM_TO_TOP = 0,
    -- 从上到下排列
    TOP_TO_BOTTOM = 1
};

-- 水平方向布局方式
local HorizontalDirection = {
    -- 从左往右排列
    LEFT_TO_RIGHT = 0,
    -- 从右往左排列
    RIGHT_TO_LEFT = 1
};

--  Layout 组件相当于一个容器，能自动对它的所有子节点进行统一排版。
-- 注意：
-- 1.不会考虑子节点的缩放和旋转。
-- 2.对 Layout 设置后结果需要到下一帧才会更新，除非你设置完以后手动调用。
local Layout = class("Layout", BLControllerBase)

function Layout:ctor()
    self._layoutSize = cc.size(0, 0)
    self._layoutDirty = true
    self.resizeMode = ResizeMode.NONE;
    self.type = Type.NONE;
    self.cellSize = cc.size(40, 40)
    self.startAxis = AxisDirection.HORIZONTAL
    self.paddingLeft = 0
    self.paddingRight = 0
    self.paddingTop = 0
    self.paddingBottom = 0
    self.spacingX = 0
    self.spacingY = 0
    self.verticalDirection = VerticalDirection.TOP_TO_BOTTOM
    self.horizontalDirection = HorizontalDirection.LEFT_TO_RIGHT
    self.affectedByScale = false
end

function Layout:initUI()
    self.node = self:getRoot();
end

function Layout:setNode(_node)
    self.node = _node;
end


-- 布局类型
-- @property {Layout.Typeend type
-- @default Layout.Type.NONE
function Layout:getType()
    return self.type
end

function Layout:setType(value)
    self.type = value
    self:_doLayoutDirty();
end

-- 缩放模式
-- @property {Layout.ResizeModeend resizeMode
-- @default ResizeMode.NONE
function Layout:getResize()
    return self.resizeMode
end

function Layout:setResize(value)
    if value == self.resizeMode then
        return
    end
    self.resizeMode = value
    self:_doLayoutDirty();
end

-- 每个格子的大小，只有布局类型为 GRID 的时候才有效。
-- @property {Sizeend cellSize
-- @default cc.size(40, 40)
function Layout:getCellSize()
    return self.cellSize
end

function Layout:setCellSize(value)
    self.cellSize = value
    self:_doLayoutDirty();
end

-- 起始轴方向类型，可进行水平和垂直布局排列，只有布局类型为 GRID 的时候才有效。
-- @property {Layout.AxisDirectionend startAxis
-- @default AxisDirection.HORIZONTAL
function Layout:getStartAxis()
    return self.startAxis
end

function Layout:setStartAxis(value)
    self.startAxis = value
    self:_doLayoutDirty();
end

-- 容器内左边距，只会在一个布局方向上生效。
-- @property {Numberend paddingLeft
-- @default 0
function Layout:getPaddingLeft()
    return self.paddingLeft
end

function Layout:setPaddingLeft(value)
    self.paddingLeft = value
    self:_doLayoutDirty();
end

-- 容器内右边距，只会在一个布局方向上生效。
-- @property {Numberend paddingRight
-- @default 0
function Layout:getPaddingRight()
    return self.paddingRight
end

function Layout:setPaddingRight(value)
    self.paddingRight = value
    self:_doLayoutDirty();
end

-- 容器内上边距，只会在一个布局方向上生效。
-- @property {Numberend} paddingRight
-- @default 0
function Layout:getPaddingTop()
    return self.paddingTop
end

function Layout:setPaddingTop(value)
    self.paddingTop = value
    self:_doLayoutDirty();
end

-- 容器内下边距，只会在一个布局方向上生效。
-- @property {Numberend paddingBottom
-- @default 0
function Layout:getPaddingBottom()
    return self.paddingBottom
end

function Layout:setPaddingBottom(value)
    self.paddingBottom = value
    self:_doLayoutDirty();
end

-- 子节点之间的水平间距。
-- @property {Numberend spacingX
-- @default 0
function Layout:getSpacingX()
    return self.spacingX
end

function Layout:setSpacingX(value)
    self.spacingX = value
    self:_doLayoutDirty();
end

-- 子节点之间的垂直间距。
-- @property {Numberend spacingY
-- @default 0
function Layout:getSpacingY()
    return self.spacingY
end

function Layout:setSpacingY(value)
    self.spacingY = value
    self:_doLayoutDirty();
end

-- 垂直排列子节点的方向。
-- @property {Layout.VerticalDirectionend verticalDirection
-- @default 0
function Layout:getVerticalDirection()
    return self.verticalDirection
end

function Layout:setVerticalDirection(value)
    self.verticalDirection = value
    self:_doLayoutDirty();
end

-- 垂直排列子节点的方向。
-- @property {Layout.HorizontalDirectionend horizontalDirection
-- @default 0
function Layout:getHorizontalDirection()
    return self.horizontalDirection
end

function Layout:setHorizontalDirection(value)
    self.horizontalDirection = value
    self:_doLayoutDirty();
end

function Layout:onEnable(...)
    self:_addEventListeners();
    if (self.node:getContentSize() == cc.size(0, 0)) then
        self.node:setContentSize(self._layoutSize);
    end
    self:doLayoutDirty();
end

function Layout:onDisable(...)
    self:_removeEventListeners();
end

function Layout:_doLayoutDirty()
    self._layoutDirty = true;
end

function Layout:_doScaleDirty()
    self._layoutDirty = self._layoutDirty or self.affectedByScale;
end

function Layout:_addEventListeners(...)
end

function Layout:_removeEventListeners(...)
end

function Layout:_addChildrenEventListeners(...)
end

function Layout:_addEventListeners(...)
end

function Layout:_childAdded()
end

function Layout:_childRemoved()
end

function Layout:_resized()
    self._layoutSize = self.node:getContentSize();
    self:_doLayoutDirty();
end

function Layout:_doLayoutHorizontally(baseWidth, rowBreak, fnPositionY, applyChildren)
    local layoutAnchor = self.node:getAnchorPoint();
    local children = self.node:getChildren();

    local sign = 1;
    local paddingX = self.paddingLeft;
    local leftBoundaryOfLayout = 0;
    if self.horizontalDirection == HorizontalDirection.RIGHT_TO_LEFT then
        sign = -1;
        leftBoundaryOfLayout = baseWidth;
        paddingX = self.paddingRight;
    end

    local nextX = leftBoundaryOfLayout + sign * paddingX - sign * self.spacingX;
    local rowMaxHeight = 0;
    local tempMaxHeight = 0;
    local secondMaxHeight = 0;
    local row = 0;
    local containerResizeBoundary = 0;

    local maxHeightChildAnchorY = 0;

    local activeChildCount = 0;
    for i, v in ipairs(children) do
        local child = v;
        if child:isVisible() then
            activeChildCount = activeChildCount + 1;
        end
    end

    local newChildWidth = self.cellSize.width;
    if self.type ~= Type.GRID and self.resizeMode == ResizeMode.CHILDREN then
        newChildWidth = (baseWidth - (self.paddingLeft + self.paddingRight) - (activeChildCount - 1) * self.spacingX) /
                            activeChildCount;
    end

    for i = 1, #children do
        local child = children[i];
        local childScaleX = self:_getUsedScaleValue(child:getScaleX());
        local childScaleY = self:_getUsedScaleValue(child:getScaleY());
        local childSize = child:getContentSize();
        local anchor = child:getAnchorPoint()
        if child:isVisible() then
            if self.resizeMode == ResizeMode.CHILDREN then
                childSize.width = newChildWidth / childScaleX;
                if self.type == Type.GRID then
                    childSize.height = self.cellSize.height / childScaleY;
                    
                end
                child:setContentSize(childSize)
            end

            local anchorX = anchor.x;
            local childBoundingBoxWidth = childSize.width * childScaleX;
            local childBoundingBoxHeight = childSize.height * childScaleY;

            if secondMaxHeight > tempMaxHeight then
                tempMaxHeight = secondMaxHeight;
            end

            if childBoundingBoxHeight >= tempMaxHeight then
                secondMaxHeight = tempMaxHeight;
                tempMaxHeight = childBoundingBoxHeight;
                maxHeightChildAnchorY = child:getAnchorPoint().y;
            end

            if self.horizontalDirection == HorizontalDirection.RIGHT_TO_LEFT then
                anchorX = 1 - anchor.x;
            end

            nextX = nextX + sign * anchorX * childBoundingBoxWidth + sign * self.spacingX;
            local rightBoundaryOfChild = sign * (1 - anchorX) * childBoundingBoxWidth;

            if rowBreak then
                local rowBreakBoundary = nextX + rightBoundaryOfChild + sign *
                                             (sign > 0 and self.paddingRight or self.paddingLeft);
                local leftToRightRowBreak = self.horizontalDirection == HorizontalDirection.LEFT_TO_RIGHT and
                                                rowBreakBoundary >  baseWidth;
                local rightToLeftRowBreak = self.horizontalDirection == HorizontalDirection.RIGHT_TO_LEFT and
                                                rowBreakBoundary < 0;

                if leftToRightRowBreak or rightToLeftRowBreak then

                    if childBoundingBoxHeight >= tempMaxHeight then
                        if secondMaxHeight == 0 then
                            secondMaxHeight = tempMaxHeight;
                        end
                        rowMaxHeight = rowMaxHeight + secondMaxHeight;
                        secondMaxHeight = tempMaxHeight;

                    else
                        rowMaxHeight = rowMaxHeight + tempMaxHeight;
                        secondMaxHeight = childBoundingBoxHeight;
                        tempMaxHeight = 0;
                    end
                    nextX = leftBoundaryOfLayout + sign * (paddingX + anchorX * childBoundingBoxWidth);
                    row = row + 1;
                end
            end

            local finalPositionY = fnPositionY(child, rowMaxHeight, row);
            if baseWidth >= (childBoundingBoxWidth + self.paddingLeft + self.paddingRight) then
                if applyChildren then
                    child:setPosition(nextX, finalPositionY);
                end
            end

            local signX = 1;
            local tempFinalPositionY;
            local topMarign = tempMaxHeight == 0 and childBoundingBoxHeight or tempMaxHeight;

            if self.verticalDirection == VerticalDirection.TOP_TO_BOTTOM then
                containerResizeBoundary = containerResizeBoundary or self.node._contentSize.height;
                signX = -1;
                tempFinalPositionY = finalPositionY + signX * (topMarign * maxHeightChildAnchorY + self.paddingBottom);
                if tempFinalPositionY < containerResizeBoundary then
                    containerResizeBoundary = tempFinalPositionY;
                end
            else
                containerResizeBoundary = containerResizeBoundary or -self.node._contentSize.height;
                tempFinalPositionY = finalPositionY + signX * (topMarign * maxHeightChildAnchorY + self.paddingTop);
                if tempFinalPositionY > containerResizeBoundary then
                    containerResizeBoundary = tempFinalPositionY;
                end
            end
            nextX = nextX + rightBoundaryOfChild;
        end
    end

    return containerResizeBoundary;
end

function Layout:_getVerticalBaseHeight(children)
    local newHeight = 0;
    local activeChildCount = 0;
    
    if self.resizeMode == ResizeMode.CONTAINER then
        for i = 1, #children do
            local child = children[i];
            if child:isVisible() then
                local size = child:getContentSize()
                activeChildCount = activeChildCount + 1;
                newHeight = newHeight + size.height * self:_getUsedScaleValue(child:getScaleY());
            end
        end
        newHeight = newHeight + (activeChildCount - 1) * self.spacingY + self.paddingBottom + self.paddingTop;
    else
        newHeight = self.node:getContentSize().height;
    end
    return newHeight;
end

function Layout:_doLayoutVertically(baseHeight, columnBreak, fnPositionX, applyChildren)
    local layoutAnchor = self.node:getAnchorPoint();
    local children = self.node:getChildren();

    local sign = 1;
    local paddingY = self.paddingBottom;
    local bottomBoundaryOfLayout = 0;
    if self.verticalDirection == VerticalDirection.TOP_TO_BOTTOM then
        sign = -1;
        bottomBoundaryOfLayout = baseHeight;
        paddingY = self.paddingTop;
    end

    local nextY = bottomBoundaryOfLayout + sign * paddingY - sign * self.spacingY;
    local columnMaxWidth = 0;
    local tempMaxWidth = 0;
    local secondMaxWidth = 0;
    local column = 0;
    local containerResizeBoundary = 0;
    local maxWidthChildAnchorX = 0;

    local activeChildCount = 0;
    for i = 1, #children do
        local child = children[i];
        if child:isVisible() then
            activeChildCount = activeChildCount + 1;
        end
    end

    local newChildHeight = self.cellSize.height;
    if self.type ~= Type.GRID and self.resizeMode == ResizeMode.CHILDREN then
        newChildHeight =
            (baseHeight - (self.paddingTop + self.paddingBottom) - (activeChildCount - 1) * self.spacingY) /
                activeChildCount;
    end

    for i = 1, #children do
        local child = children[i];
        local childScaleX = self:_getUsedScaleValue(child:getScaleX());
        local childScaleY = self:_getUsedScaleValue(child:getScaleY());
        local anchor = child:getAnchorPoint()
        local childSize = child:getContentSize()
        if child:isVisible() then
            if self.resizeMode == ResizeMode.CHILDREN then
                childSize.height = newChildHeight / childScaleY;
                if self.type == Type.GRID then
                    childSize.width = self.cellSize.width / childScaleX;
                    child:setContentSize(childSize)
                end
            end

            local anchorY = anchor.y;
            local childBoundingBoxWidth = childSize.width * childScaleX;
            local childBoundingBoxHeight = childSize.height * childScaleY;

            if secondMaxWidth > tempMaxWidth then
                tempMaxWidth = secondMaxWidth;
            end

            if childBoundingBoxWidth >= tempMaxWidth then
                secondMaxWidth = tempMaxWidth;
                tempMaxWidth = childBoundingBoxWidth;
                maxWidthChildAnchorX = anchor.x;
            end

            if self.verticalDirection == VerticalDirection.TOP_TO_BOTTOM then
                anchorY = 1 - anchor.y;
            end

            nextY = nextY + sign * anchorY * childBoundingBoxHeight + sign * self.spacingY;
            local topBoundaryOfChild = sign * (1 - anchorY) * childBoundingBoxHeight;

            if columnBreak then
                local columnBreakBoundary = nextY + topBoundaryOfChild + sign *
                                                (sign > 0 and self.paddingTop or self.paddingBottom);
                local bottomToTopColumnBreak = self.verticalDirection == VerticalDirection.BOTTOM_TO_TOP and
                                                   columnBreakBoundary > baseHeight;
                local topToBottomColumnBreak = self.verticalDirection == VerticalDirection.TOP_TO_BOTTOM and
                                                   columnBreakBoundary < 0;

                if bottomToTopColumnBreak or topToBottomColumnBreak then
                    if childBoundingBoxWidth >= tempMaxWidth then
                        if secondMaxWidth == 0 then
                            secondMaxWidth = tempMaxWidth;
                        end
                        columnMaxWidth = columnMaxWidth + secondMaxWidth;
                        secondMaxWidth = tempMaxWidth;

                    else
                        columnMaxWidth = columnMaxWidth + tempMaxWidth;
                        secondMaxWidth = childBoundingBoxWidth;
                        tempMaxWidth = 0;
                    end
                    nextY = bottomBoundaryOfLayout + sign * (paddingY + anchorY * childBoundingBoxHeight);
                    column = column + 1;
                end
            end

            local finalPositionX = fnPositionX(child, columnMaxWidth, column);
            if baseHeight >= (childBoundingBoxHeight + (self.paddingTop + self.paddingBottom)) then
                if applyChildren then
                    child:setPosition(finalPositionX, nextY);
                end
            end

            local signX = 1;
            local tempFinalPositionX;

            local rightMarign = (tempMaxWidth == 0) and childBoundingBoxWidth or tempMaxWidth;

            if self.horizontalDirection == HorizontalDirection.RIGHT_TO_LEFT then
                signX = -1;
                containerResizeBoundary = containerResizeBoundary or self.node._contentSize.width;
                tempFinalPositionX = finalPositionX + signX * (rightMarign * maxWidthChildAnchorX + self.paddingLeft);
                if tempFinalPositionX < containerResizeBoundary then
                    containerResizeBoundary = tempFinalPositionX;
                end
            else
                containerResizeBoundary = containerResizeBoundary or -self.node._contentSize.width;
                tempFinalPositionX = finalPositionX + signX * (rightMarign * maxWidthChildAnchorX + self.paddingRight);
                if tempFinalPositionX > containerResizeBoundary then
                    containerResizeBoundary = tempFinalPositionX;
                end
            end
            nextY = nextY + topBoundaryOfChild;
        end
    end
    return containerResizeBoundary;
end

local function parseFloat(num)
    local n = 2;
    if type(num) ~= "number" then
        return num    
    end
    n = n or 2
    if num < 0 then
        return -(math.abs(num) - math.abs(num) % 0.1 ^ n)
    else
        return num - num % 0.1 ^ n
    end
end

function Layout:_doLayoutBasic()
    local children = self.node:getChildren();

    local allChildrenBoundingBox = null;

    for i = 0, #children do
        local child = children[i];
        if child:isVisible() then
            if not allChildrenBoundingBox then
                allChildrenBoundingBox = child:getBoundingBoxToWorld();
            else
                allChildrenBoundingBox:union(allChildrenBoundingBox, child:getBoundingBoxToWorld());
            end
        end
    end

    if allChildrenBoundingBox then
        local leftBottomSpace = self.node:convertToNodeSpaceAR(cc.v2(allChildrenBoundingBox.x, allChildrenBoundingBox.y));
        leftBottomSpace = cc.v2(leftBottomSpace.x - self.paddingLeft, leftBottomSpace.y - self.paddingBottom);

        local rightTopSpace = self.node:convertToNodeSpaceAR(
            cc.v2(allChildrenBoundingBox.xMax, allChildrenBoundingBox.yMax));
        rightTopSpace = cc.v2(rightTopSpace.x + self.paddingRight, rightTopSpace.y + self.paddingTop);

        local newSize = rightTopSpace:sub(leftBottomSpace);
        newSize = cc.size(parseFloat(newSize.x), parseFloat(newSize.y));

        if newSize.width ~= 0 then
            local newAnchorX = (-leftBottomSpace.x) / newSize.width;
            self.node.anchorX = parseFloat(newAnchorX);
        end
        if newSize.height ~= 0 then
            local newAnchorY = (-leftBottomSpace.y) / newSize.height;
            self.node.anchorY = parseFloat(newAnchorY);
        end
        self.node:setContentSize(newSize);
    end
end

function Layout:_doLayoutGridAxisHorizontal(layoutAnchor, layoutSize)
    local baseWidth = layoutSize.width;

    local sign = 1;
    local bottomBoundaryOfLayout = 0;
    local paddingY = self.paddingBottom;
    if self.verticalDirection == VerticalDirection.TOP_TO_BOTTOM then
        sign = -1;
        bottomBoundaryOfLayout = layoutSize.height;
        paddingY = self.paddingTop;
    end

    local fnPositionY = function(child, topOffset, row)
        return bottomBoundaryOfLayout + sign *
                   (topOffset + child:getAnchorPoint().y * child:getContentSize().height * self:_getUsedScaleValue(child:getScaleY()) + paddingY + row *
                       self.spacingY);
    end

    local newHeight = 0;
    if self.resizeMode == ResizeMode.CONTAINER then

        local boundary = self:_doLayoutHorizontally(baseWidth, true, fnPositionY, false);
        newHeight = bottomBoundaryOfLayout - boundary;
        if newHeight < 0 then
            newHeight = newHeight * -1;
        end

        bottomBoundaryOfLayout = 0;

        if self.verticalDirection == VerticalDirection.TOP_TO_BOTTOM then
            sign = -1;
            bottomBoundaryOfLayout = newHeight;
        end
    end

    self:_doLayoutHorizontally(baseWidth, true, fnPositionY, true);
    if self.resizeMode == ResizeMode.CONTAINER then
        self.node:setContentSize(baseWidth, newHeight);
    end
end

function Layout:_doLayoutGridAxisVertical(layoutAnchor, layoutSize)
    local baseHeight = layoutSize.height;

    local sign = 1;
    local leftBoundaryOfLayout = 0;
    local paddingX = self.paddingLeft;
    if self.horizontalDirection == HorizontalDirection.RIGHT_TO_LEFT then
        sign = -1;
        leftBoundaryOfLayout = layoutSize.width;
        paddingX = self.paddingRight;
    end

    local fnPositionX = function(child, leftOffset, column)
        
        return leftBoundaryOfLayout + sign *
                   (leftOffset + child:getAnchorPoint().x * child:getContentSize().width * self:_getUsedScaleValue(child:getScaleX()) + paddingX + column *
                       self.spacingX);
    end

    local newWidth = 0;
    if self.resizeMode == ResizeMode.CONTAINER then
        local boundary = self:_doLayoutVertically(baseHeight, true, fnPositionX, false);
        newWidth = leftBoundaryOfLayout - boundary;
        if newWidth < 0 then
            newWidth = newWidth * -1;
        end

        leftBoundaryOfLayout = -layoutAnchor.x * newWidth;

        if self.horizontalDirection == HorizontalDirection.RIGHT_TO_LEFT then
            sign = -1;
            leftBoundaryOfLayout = newWidth;
        end
    end

    self:_doLayoutVertically(baseHeight, true, fnPositionX, true);

    if self.resizeMode == ResizeMode.CONTAINER then
        self.node:setContentSize(newWidth, baseHeight);
    end
end

function Layout:_doLayoutGrid()
    local layoutAnchor = self.node:getAnchorPoint();
    local layoutSize = self.node:getContentSize();

    if self.startAxis == AxisDirection.HORIZONTAL then
        self:_doLayoutGridAxisHorizontal(layoutAnchor, layoutSize);
    elseif self.startAxis == AxisDirection.VERTICAL then
        self:_doLayoutGridAxisVertical(layoutAnchor, layoutSize);
    end
end

function Layout:_getHorizontalBaseWidth(children)
    local newWidth = 0;
    local activeChildCount = 0;
    if self.resizeMode == ResizeMode.CONTAINER then
        for i = 1, #children do
            local child = children[i];
            if child:isVisible() then
                activeChildCount = activeChildCount + 1;
                newWidth = newWidth + child:getContentSize().width * self:_getUsedScaleValue(child:getScaleX());
            end
        end
        newWidth = newWidth + (activeChildCount - 1) * self.spacingX + self.paddingLeft + self.paddingRight;
    else
        newWidth = self.node:getContentSize().width;
    end
    return newWidth;
end

function Layout:_doLayout()
    if self.type == Type.HORIZONTAL then
        local newWidth = self:_getHorizontalBaseWidth(self.node:getChildren());

        local fnPositionY = function(child)
            return child:getPositionY();
        end;

        self:_doLayoutHorizontally(newWidth, false, fnPositionY, true);

        local size = self.node:getContentSize()
        size.width = newWidth;
        self.node:setContentSize(size)

    elseif self.type == Type.VERTICAL then
        local newHeight = self:_getVerticalBaseHeight(self.node:getChildren());

        local fnPositionX = function(child)
            return child:getPositionX();
        end;

        self:_doLayoutVertically(newHeight, false, fnPositionX, true);

        local size = self.node:getContentSize()
        size.height = newHeight;
        self.node:setContentSize(size)

    elseif self.type == Type.NONE then
        if self.resizeMode == ResizeMode.CONTAINER then
            self:_doLayoutBasic();
        end

    elseif self.type == Type.GRID then
        self:_doLayoutGrid();
    end
end

function Layout:_getUsedScaleValue(value)
    return self.affectedByScale and Math.abs(value) or 1;
end

-- 立即执行更新布局
-- @example
-- layout.type = cc.Layout.HORIZONTAL;
-- layout.node.addChild(childNode);
-- cc.log(childNode.x); // not yet changed
-- layout.updateLayout();
-- cc.log(childNode.x); // changed
function Layout:updateLayout()
    local children = self.node:getChildren()
    if self._layoutDirty and #children > 0 then
        local activeChild = false;
        for i, v in ipairs(children) do
            if v:isVisible() then
                activeChild = true
                break
            end
        end
        if activeChild then
            self:_doLayout();
            self._layoutDirty = false;
        end
    end
end

return Layout
