local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLClipNode = class("BLClipNode", function(type, ...) 
    if type == 1 then 
        return cc.Label:createWithBMFont(...)
    elseif type == 0 then
        return cc.Label:createWithSystemFont(...)
    else
        return cc.Label:createWithTTF(...)
    end
end)

function BLClipNode:ctor()
    ControllerMix:attach( self )
    self:registerScriptHandler( handler(self, self._ScriptHandler) )
end

function BLClipNode:create( ... )
    return self.new(... )
end

function BLClipNode:_ScriptHandler( evt, param )
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

function BLClipNode:onEnter( ... )
    
end

function BLClipNode:update(...)
    self.__controllerMix:update( ... )

end

function BLClipNode:onExit( ... )
    
end

function BLClipNode:onExitTransitionDidStart( ... )
    -- body
end

function BLClipNode:onEnterTransitionDidFinish( ... )
    -- body
end

function BLClipNode:startUpdate( ... )
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLClipNode:getItem( path )
    return CreatorUtils.getItemByPath(self, path)
end

function BLClipNode:stopUpdate()
    self:unscheduleUpdate()
end


function BLClipNode:onCleanup()
    self:removeAllController()
end

return BLClipNode