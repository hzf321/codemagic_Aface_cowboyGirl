local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLScrollView = class("BLScrollView", function() return ccui.ScrollView:create() end)


function BLScrollView:ctor()
    ControllerMix:attach( self )
    self:registerScriptHandler( handler(self, self._ScriptHandler) )
end

function BLScrollView:create( ... )
    return self.new(... )
end

function BLScrollView:_ScriptHandler( evt, param )
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

function BLScrollView:onEnter( ... )
    
end

function BLScrollView:update(...)
    self.__controllerMix:update( ... )
end

function BLScrollView:onExit( ... )
    
end

function BLScrollView:onExitTransitionDidStart( ... )
    -- body
end

function BLScrollView:onEnterTransitionDidFinish( ... )
    -- body
end

function BLScrollView:startUpdate( ... )
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLScrollView:getItem( path )
    return CreatorUtils.getItemByPath(self, path)
end

function BLScrollView:stopUpdate()
    self:unscheduleUpdate()
end


function BLScrollView:onCleanup()
    self:removeAllController()
end

return BLScrollView