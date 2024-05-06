local ControllerMix = require("UI/CreatorUI/ControllerMix")
local CreatorUtils = require("UI/CreatorUI/CreatorUtils")

local BLScale9Sprite = class("BLScale9Sprite", function(...)
    return cc.Scale9Sprite:create(...)
end)

function BLScale9Sprite:ctor()
    ControllerMix:attach(self)
    self:registerScriptHandler(handler(self, self._ScriptHandler))
end

function BLScale9Sprite:create(...)
    return self.new(...)
end

function BLScale9Sprite:_ScriptHandler(evt, param)
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

function BLScale9Sprite:onEnter(...)

end

function BLScale9Sprite:update(...)
    self.__controllerMix:update(...)

end

function BLScale9Sprite:onExit(...)

end

function BLScale9Sprite:onExitTransitionDidStart(...)
    -- body
end

function BLScale9Sprite:onEnterTransitionDidFinish(...)
    -- body
end

function BLScale9Sprite:startUpdate(...)
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function BLScale9Sprite:getItem(path)
    return CreatorUtils.getItemByPath(self, path)
end

function BLScale9Sprite:stopUpdate()
    self:unscheduleUpdate()
end

function BLScale9Sprite:onCleanup()
    self:removeAllController()
end
function BLScale9Sprite:loadTexture(fileName,texType)
    if not fileName then
        return 
    end
    if texType ==  ccui.TextureResType.localType then
        -- self:initWithFile(fileName,consept);
     
    elseif texType ==  ccui.TextureResType.plistType then
        local spriteFrameCache = cc.SpriteFrameCache:getInstance()
        local rect = self:getCapInsets()
        local size = self:getContentSize()
        self:setSpriteFrame(spriteFrameCache:getSpriteFrame(fileName), rect)
        self:setContentSize(size)
    end
end

return BLScale9Sprite
