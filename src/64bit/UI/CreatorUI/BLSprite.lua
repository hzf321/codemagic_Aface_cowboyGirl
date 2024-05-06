local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLSprite = class("BLSprite", function() return cc.Sprite:create() end)


function BLSprite:ctor()
    ControllerMix:attach( self )
    self:registerScriptHandler( handler(self, self._ScriptHandler) )
end

function BLSprite:create( ... )
    return self.new(... )
end

function BLSprite:_ScriptHandler( evt, param )
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

function BLSprite:onEnter( ... )
    
end

function BLSprite:update(...)
    self.__controllerMix:update( ... )
end

function BLSprite:onExit( ... )
    
end

function BLSprite:onExitTransitionDidStart( ... )
    -- body
end

function BLSprite:onEnterTransitionDidFinish( ... )
    -- body
end

function BLSprite:startUpdate( ... )
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLSprite:getItem( path )
    return CreatorUtils.getItemByPath(self, path)
end

function BLSprite:stopUpdate()
    self:unscheduleUpdate()
end


function BLSprite:onCleanup()
    self:removeAllController()
end

return BLSprite
