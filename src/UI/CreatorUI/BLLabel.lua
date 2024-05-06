local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLLabel = class("BLLabel", function(type, ...) 
    if type == 1 then 
        return cc.Label:createWithBMFont(...)
    elseif type == 0 then
        return cc.Label:createWithSystemFont(...)
    else
        return cc.Label:createWithTTF(...)
    end
end)

function BLLabel:ctor()
    ControllerMix:attach( self )
    self:registerScriptHandler( handler(self, self._ScriptHandler) )
end

function BLLabel:create( ... )
    return self.new(... )
end

function BLLabel:_ScriptHandler( evt, param )
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

function BLLabel:onEnter( ... )
    
end

function BLLabel:update(...)
    self.__controllerMix:update( ... )

end

function BLLabel:onExit( ... )
    
end

function BLLabel:onExitTransitionDidStart( ... )
    -- body
end

function BLLabel:onEnterTransitionDidFinish( ... )
    -- body
end

function BLLabel:startUpdate( ... )
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLLabel:getItem( path )
    return CreatorUtils.getItemByPath(self, path)
end

function BLLabel:stopUpdate()
    self:unscheduleUpdate()
end


function BLLabel:onCleanup()
    self:removeAllController()
end

function BLLabel:setFntFile(...)
    if self.setBMFontFilePath then
        self:setBMFontFilePath(...)
    end
end

function BLLabel:setTTFStroke(...)
    self:enableOutline(...)
end

return BLLabel
