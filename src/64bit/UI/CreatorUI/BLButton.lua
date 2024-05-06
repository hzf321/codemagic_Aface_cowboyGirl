local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLButton = class("BLButton", function() return ccui.Button:create() end)


function BLButton:ctor()
    ControllerMix:attach( self )
    self:registerScriptHandler( handler(self, self._ScriptHandler) )
end

function BLButton:create( ... )
    return self.new(... )
end

function BLButton:_ScriptHandler( evt, param )
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

function BLButton:onEnter( ... )
    
end

function BLButton:update(...)
    self.__controllerMix:update( ... )

end

function BLButton:onExit( ... )
    
end

function BLButton:onExitTransitionDidStart( ... )
    -- body
end

function BLButton:onEnterTransitionDidFinish( ... )
    -- body
end

function BLButton:startUpdate( ... )
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLButton:getItem( path )
    return CreatorUtils.getItemByPath(self, path)
end


function BLButton:addTouchEvent(event, param)
    local function btnEvent(sender, eventType)
        local function changeChild(is_normal)
            for i, child in ipairs(self:getChildren()) do
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
            self:setColor(cc.c3b(255, 255, 255))
            changeChild(true)
        	if event then
        		event(param)
        	end
        elseif eventType == ccui.TouchEventType.began then
            self:setColor(cc.c3b(123, 123, 123))
            changeChild(false)
        elseif eventType == ccui.TouchEventType.canceled then
            self:setColor(cc.c3b(255, 255, 255))
            changeChild(true)
        elseif eventType == ccui.TouchEventType.moved then
            self:setColor(cc.c3b(123, 123, 123))
            changeChild(false)
        end
    end
    self:addTouchEventListener(btnEvent)
end

function BLButton:setAllItemBright(state)
    local function setBrght(node,state)
        if node.setColor then
            if state then
                node:setColor(cc.c3b(255, 255, 255))
            else
                node:setColor(cc.c3b(123, 123, 123))
            end
        end
    end
    for i, child in ipairs(self:getChildren()) do
        setBrght(child,state)
    end
    setBrght(self,state)
end

function BLButton:stopUpdate()
    self:unscheduleUpdate()
end


function BLButton:onCleanup()
    self:removeAllController()
end

return BLButton