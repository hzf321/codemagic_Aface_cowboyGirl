local BLControllerBase = require("UI/CreatorUI/BLControllerBase")

local CreatorWidget = class("CreatorWidget", BLControllerBase)

function CreatorWidget:ctor()
    BLControllerBase.ctor(self)
end

function CreatorWidget:setNode(_node)
    self.node = _node
end

function CreatorWidget:initUI()
    self._node = self:getRoot();
    self._widget = self:getConfig();
    self:updateAlignment();
end

function CreatorWidget:updateSize(_size)
    if self.__cname == "BLScrollView" then
        
    end
    self._node:setContentSize(_size)
    self:updateChildAlignment()
end

function CreatorWidget:updateChildAlignment()
    self._node = self:getRoot();
    local childs = self._node:getChildren()
    local ctrl = nil
    for i, node in ipairs(childs) do
        if node.getController then
            ctrl = node:getController("CreatorWidget")
            local _ = ctrl and ctrl:updateAlignment()
        end
    end
end

-- @property {_node} cc.Node
-- @property {widget} {}
function CreatorWidget:updateAlignment()
    local widget = self._widget
    local parent = self._node:getParent()
    if parent == nil then
        return
    end
    local anchor = self._node:getAnchorPoint()
    local windowSize = parent:getContentSize()
    if windowSize.width == 0 and windowSize.height == 0 then
        windowSize.width = FRAME_HEIGHT;
        windowSize.height = FRAME_WIDTH;
    end

    local size = self._node:getContentSize()
    local height = size.height
    local width = size.width
    local x,y = self._node:getPosition()

    if widget.top ~= nil or widget.bottom ~= nil then
        if widget.top ~= nil and widget.bottom ~= nil then
            height = windowSize.height - widget.top - widget.bottom
            y = widget.bottom + (height * anchor.y)
        elseif widget.top ~= nil then
            y = windowSize.height - widget.top - (height * (1- anchor.y))
        elseif widget.bottom ~= nil then
            y = widget.bottom + (height * anchor.y)
        end
    end

    if widget.right ~= nil or widget.left ~= nil then
        if widget.right ~= nil and widget.left ~= nil then
            width = windowSize.width - widget.right - widget.left
            x = widget.left + (width * anchor.x)
        elseif widget.right ~= nil then
            x = windowSize.width - widget.right - (width * (1 - anchor.x))
        elseif widget.left ~= nil then
            x = widget.left + (width * anchor.x)
        end
    end

    if widget.horizontalCenter then
        x = windowSize.width / 2 + widget.horizontalCenter
    end

    if widget.verticalCenter then
        y = windowSize.height / 2 + widget.verticalCenter
    end
    -- print("ok in ", self._node.name, x, y, width, height)
    self._node:setPosition(x, y)
    self:updateSize(cc.size(width, height))
end

function CreatorWidget:setWidget(_widget)
    self._widget = _widget
    self:updateAlignment()
end

return CreatorWidget
