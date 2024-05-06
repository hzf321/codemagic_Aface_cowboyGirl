local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLLayout = class("BLLayout", function(type, ...) return ccui.Layout:create(); end)

function BLLayout:ctor()
    ControllerMix:attach( self )
    self:registerScriptHandler( handler(self, self._ScriptHandler) )
end

function BLLayout:create( ... )
    return self.new(... )
end

function BLLayout:_ScriptHandler( evt, param )
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

function BLLayout:onEnter( ... )
    
end

function BLLayout:update(...)
    self.__controllerMix:update( ... )

end

function BLLayout:onExit( ... )
    
end

function BLLayout:onExitTransitionDidStart( ... )
    -- body
end

function BLLayout:onEnterTransitionDidFinish( ... )
    -- body
end

function BLLayout:startUpdate( ... )
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLLayout:getItem( path )
    return CreatorUtils.getItemByPath(self, path)
end

function BLLayout:stopUpdate()
    self:unscheduleUpdate()
end


function BLLayout:onCleanup()
    self:removeAllController()
end

return BLLayout