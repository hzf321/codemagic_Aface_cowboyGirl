local BLControllerBase = require("UI/CreatorUI/BLControllerBase")
local CreatorScrollBar = class("CreatorScrollBar", BLControllerBase)

function CreatorScrollBar:ctor()
    BLControllerBase.ctor(self)
end


function CreatorScrollBar:initUI()
    self._node = self:getRoot();
    self.bar = self._node.bar
    self.size = self._node:getContentSize()
    local barSize = self.bar:getContentSize()
    self.maxX = self.size.width - barSize.width;
    self.maxY = self.size.height - barSize.height;
    
    self.direction = self.maxX > self.maxY and 0 or 1
    local anchor = self.bar:getAnchorPoint()
    if self.direction == 0 then
        self.bar:setPositionX(0)
        self.bar:setAnchorPoint(cc.p(0,anchor.y))
    else
        self.bar:setPositionY(self.maxY)
        self.bar:setAnchorPoint(cc.p(anchor.x, 0))
    end
    self.currentPosition = 0
    self:addTouchEvent(self.bar, self.on_move_clicked)
end

function CreatorScrollBar:addTouchEvent( btn, event, param )
	local function btnEvent(sender, eventType)
       self:on_move_clicked(sender, eventType)
    end
    btn:addTouchEventListener(btnEvent)
end

function CreatorScrollBar:on_move_clicked(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        if self.direction == 0 then
            self.currentPosition = self.bar:getPositionX()
        else
            self.currentPosition = self.bar:getPositionY()
        end
    else
        local beganPosition = sender:getTouchBeganPosition();
        local move = sender:getTouchMovePosition();
        if self.direction == 0 then
            local offsetX = self.currentPosition + move.x - beganPosition.x
            if offsetX < 0 then
                offsetX = 0
            elseif offsetX > self.maxX then
                offsetX = self.maxX
            end
            self.percent = offsetX / self.maxX
            self.bar:setPositionX(offsetX)
            self:updateScrollViewPositionX()
            local _ = self._callback and self._callback(self.percent * 100)
        else
            local offsetY = self.currentPosition + move.y - beganPosition.y
            if offsetY < 0 then
                offsetY = 0
            elseif offsetY > self.maxY then
                offsetY = self.maxY
            end
            self.percent = offsetY / self.maxY
            self.bar:setPositionY(offsetY)
            self:updateScrollViewPositionY()
            local _ = self._callback and self._callback(self.percent * 100)
        end
    end
end

function CreatorScrollBar:setScrollView(_node, _initEvent)
    self.scrollView = _node
    if _initEvent == true then
        self:initScrollViewEvent()
    end
    
end

function CreatorScrollBar:initScrollViewEvent( ... )
    self.scrollView:addEventListener(function(event, tag)
        self:on_scroll_view_event(event, tag)
    end)
end

function CreatorScrollBar:on_scroll_view_event(event, tag)
    if tag == ccui.ScrollviewEventType.containerMoved then
        local nodeSize = self.scrollView:getContentSize()
        local contentSize = self.scrollView:getInnerContainerSize()
        local pos = self.scrollView:getInnerContainerPosition()
        local percent = 0
        if self.direction == 0 then
            local maxX = contentSize.width - nodeSize.width;
            percent = maxX == 0 and 100 or -pos.x / maxX * 100
        else
            local maxY = contentSize.height - nodeSize.height;
            percent = maxY == 0 and 100 or -pos.y / maxY * 100
        end
        self:setPercent(percent)
    end
end

function CreatorScrollBar:updateScrollViewPositionX()
    if self.scrollView then
        local node = self.scrollView:getInnerContainer()
        local nodeSize = self.scrollView:getContentSize()
        local contentSize = node:getContentSize()
        local maxX = contentSize.width - nodeSize.width;
        self.scrollView:stopAutoScroll()
        node:setPositionX(self.percent * maxX * -1)
    end
end

function CreatorScrollBar:updateScrollViewPositionY()
    if self.scrollView then
        local node = self.scrollView:getInnerContainer()
        local nodeSize = self.scrollView:getContentSize()
        local contentSize = node:getContentSize()
        local maxY = contentSize.height - nodeSize.height;
        self.scrollView:stopAutoScroll()
        node:setPositionY(self.percent * maxY * -1)
    end
end

function CreatorScrollBar:setPercent(value)
    value = math.min(value, 100)
    value = math.max(value, 0)
    self.percent = value * 0.01
    if self.direction == 0 then
        self.bar:setPositionX(self.percent * self.maxX)
    else
        self.bar:setPositionY(self.percent * self.maxY)
    end
end

function CreatorScrollBar:setChangeCallback(callback)
    self._callback = callback
end

return CreatorScrollBar
