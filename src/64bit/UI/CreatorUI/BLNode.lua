local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")


---@class BLNode: Node
local BLNode = class("BLNode", function()
    return cc.Node:create()
end)

function BLNode:ctor()
    ControllerMix:attach(self)
    self:registerScriptHandler(handler(self, self._ScriptHandler))
end

function BLNode:create(...)
    return self.new(...)
end

function BLNode:initButtonList(is_grey)
    if self.uiTbl and self.uiTbl.buttonList then
        local btnList = self.uiTbl.buttonList;
        local node = nil;
        local name = "";
        local callback = nil
        for i = 1, #btnList do
            node = self:getItem(btnList[i].path);
            name = node.name;
			local btnName = bole.underscoreToCamel(name)
            callback = self["on"..btnName.."Clicked"]
            if node and callback then
                if is_grey then
                    bole.ctorUIComponent(node, UIComponent.CommonButton,UIComponent.CommonButton.Enum.ONLY_GRAY)
                end
                self:addTouchEvent(node, handler(self, callback), btnList[i].tag)
            end
        end
    end
end

function BLNode:initButtonListToNode(is_grey)
    if self.node and self.node.uiTbl and self.node.uiTbl.buttonList then
        local btnList = self.node.uiTbl.buttonList;
        local node = nil;
        local name = "";
        local callback = nil
        for i = 1, #btnList do
            node = self.node:getItem(btnList[i].path);
            name = node.name;
			local btnName = bole.underscoreToCamel(name)
            callback = self["on"..btnName.."Clicked"]
            if node and callback then
				if is_grey then
                    bole.ctorUIComponent(node, UIComponent.CommonButton, UIComponent.CommonButton.Enum.ONLY_GRAY)
                end
                self:addTouchEvent(node, handler(self, callback), btnList[i].tag)
            end
        end
    end
end


function BLNode:addTouchEvent( btn, event, param )
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            btn:setColor(cc.c3b(255, 255, 255))
        	if event then
        		event(param)
        	end
        elseif eventType == ccui.TouchEventType.began then
            btn:setColor(cc.c3b(123, 123, 123))
        elseif eventType == ccui.TouchEventType.canceled then
            btn:setColor(cc.c3b(255, 255, 255))
        elseif eventType == ccui.TouchEventType.moved then
            local point = sender:getTouchMovePosition()
            point = btn:convertToNodeSpace(point)
            local size = btn:getContentSize()
            local rect = cc.rect(0,0,size.width,size.height)
            if cc.rectContainsPoint(rect,point) then
                btn:setColor(cc.c3b(123, 123, 123))
            else
                btn:setColor(cc.c3b(255, 255, 255))
            end  
        end
    end
    btn:addTouchEventListener(btnEvent)
end

-- btn内所有子节点置灰
function BLNode:addTouchEventAllChildrenChange( btn, event, param )
    local function btnEvent(sender, eventType)
        local function changeChild(is_normal)
            for i, child in ipairs(btn:getChildren()) do
                if child.setColor then
                    if is_normal then
                        child:setColor(cc.c3b(255, 255, 255))
                    else
                        child:setColor(cc.c3b(123, 123, 123))
                    end
                end
            end
        end
        if eventType == ccui.TouchEventType.ended then
            btn:setColor(cc.c3b(255, 255, 255))
            changeChild(true)
        	if event then
        		event(param)
        	end
        elseif eventType == ccui.TouchEventType.began then
            btn:setColor(cc.c3b(123, 123, 123))
            changeChild(false)
        elseif eventType == ccui.TouchEventType.canceled then
            btn:setColor(cc.c3b(255, 255, 255))
            changeChild(true)
        elseif eventType == ccui.TouchEventType.moved then
            btn:setColor(cc.c3b(123, 123, 123))
            changeChild(false)
        end
    end
    btn:addTouchEventListener(btnEvent)
end

function BLNode:_ScriptHandler(evt, param)
    if evt == "enter" then
        self:onEnter()

    elseif evt == "exit" then
        self:onExit()

    elseif evt == "cleanup" then
        self:onCleanup()

    elseif evt == "exitTransitionStart" then
        self:onExitTransitionDidStart()

    elseif evt == "enterTransitionFinish" then
        self:onEnterTransitionDidFinish()
    end
end

function BLNode:setVisible(visible)
    if visible ~= self:isVisible() then
        cc.Node.setVisible(self, visible)
        if visible then
            self:onEnable()
        else
            self:onDisable()
        end
    end
    
end

function BLNode:onEnter(...)
end

function BLNode:onEnable(...)
end

function BLNode:onDisable(...)
end

function BLNode:update(...)
    self.__controllerMix:update(...)

end

function BLNode:onExit(...)

end

function BLNode:onExitTransitionDidStart(...)
    -- body
end

function BLNode:onEnterTransitionDidFinish(...)
    -- body
end

function BLNode:startUpdate(...)
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLNode:getItem(path)
    return CreatorUtils.getItemByPath(self, path)
end

function BLNode:stopUpdate()
    self:unscheduleUpdate()
end

function BLNode:onCleanup()
    self:removeAllController()
end

return BLNode
