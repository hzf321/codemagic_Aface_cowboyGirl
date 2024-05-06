-- 可绑定自定义Slider的ScrollView
local BLControllerBase = require("UI/CreatorUI/BLControllerBase")
local ScrollSliderView = class("ScrollSliderView", BLControllerBase)

function ScrollSliderView: reload()
    self:initUI()
end

function ScrollSliderView: setScrollViewMoveFunc(moved_func,bottom_func)
    self.scroll_view:addEventListener(function(event, tag)
        if not self.can_scroll then
            return
        elseif tag == ccui.ScrollviewEventType.containerMoved then
            self:updateSlider()
            if moved_func then moved_func() end        
        elseif tag == ccui.ScrollviewEventType.scrollToBottom then
            if bottom_func then bottom_func() end
        end
    end)
end

function ScrollSliderView: getScrollView()
    return self.scroll_view
end

function ScrollSliderView: getSlider()
    return self.slider
end

function ScrollSliderView: ctor()
    self.min_percent = 0
    self.max_percent = 100
    self.can_scroll = true
end

function  ScrollSliderView: initUI()
    self.node = self:getRoot();
    if self.node then
        self.slider_bg = self.node:getChildByName("real_bg")
        self:_setSliderNode(self.node:getChildByName("slider"))
        self:_setScrollViewNode(self.node:getChildByName("content_sv"))
        self:_configState()
        if self.can_scroll then
            self:_configSliderNode();
            self:updateSlider()
        end
    else
        print("ScrollSliderView: node not exist!")
    end
end

function ScrollSliderView: setNode(_node)
    self.node = _node;
end

function ScrollSliderView: _setSliderNode(_node)
    self.slider = _node;
end

function ScrollSliderView: _setScrollViewNode(_node)
    self.scroll_view = _node;
end

function ScrollSliderView: _configSliderNode()
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            local slider_moved_percent = self.slider:getPercent()
            if slider_moved_percent > self.max_percent then
                self.slider:setPercent(self.max_percent)
            elseif slider_moved_percent < self.min_percent then
                self.slider:setPercent(self.min_percent)
            else
                local percent = (slider_moved_percent - self.min_percent) / (self.max_percent - self.min_percent)
                self.scroll_view:scrollToPercentVertical(percent, 0.01, true)
            end
        end
    end  
    self.slider:setTouchEnabled(true)
    self.slider:addEventListener(percentChangedEvent)
end

function ScrollSliderView: _configState()
    local size_height = self.scroll_view:getContentSize().height
    local height = self.scroll_view:getInnerContainerSize().height - size_height
    self.can_scroll = height > 0
    self.slider:setVisible(self.can_scroll)
    self.slider_bg:setVisible(self.can_scroll)
    self.scroll_view:setTouchEnabled(self.can_scroll)
    return self.can_scroll
end

function ScrollSliderView:updateSlider()
    if not self.scroll_view and self.slider then return end
    local size_height = self.scroll_view:getContentSize().height
    local height = self.scroll_view:getInnerContainerSize().height - size_height
    local pos_y = self.scroll_view:getInnerContainerPosition().y
    local temp_percent = math.floor((height - math.abs(pos_y))/height * 100)
    self.slider:setPercent(temp_percent) 
end

return ScrollSliderView
