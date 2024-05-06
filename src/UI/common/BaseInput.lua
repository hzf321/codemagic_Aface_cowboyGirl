--[[
    输入框
    textfield -> editbox
]]

BaseInput = class("BaseInput")

function BaseInput:ctor( parent, template )
    local size = template:getContentSize()
    local fontName = template:getFontName()
    local node = nil
    if true then
        -- node = ccui.EditBox:create(size, "commonImages/b_theme_bar.png")
        node = ccui.EditBox:create(size, "commonpics/kong.png")
        node:registerScriptEditBoxHandler(function(eventType, sender)
            if eventType == "began" then
                if self._callback_began then
                    self._callback_began()
                end
            elseif eventType == "changed" then
                if self._callback_changed then
                    self._callback_changed()
                end
            elseif eventType == "ended" then
                if self._callback_ended then
                    self._callback_ended()
                end
            elseif eventType == "return" then
                if self._callback_return then
                    self._callback_return()
                end
            end
        end)
        -- node:setFontName(fontName)
        node:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
        node:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
        node:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    else
        node = ccui.TextField:create()
        node:addEventListener(function(sender, eventType)
            if eventType == ccui.TextFiledEventType.attach_with_ime then
                if self._callback_began then
                    self._callback_began()
                end
            elseif eventType == ccui.TextFiledEventType.detach_with_ime then
                if self._callback_ended then
                    self._callback_ended()
                end
            elseif eventType == ccui.TextFiledEventType.insert_text then
                if self._callback_changed then
                    self._callback_changed()
                end
            elseif eventType == ccui.TextFiledEventType.delete_backward then
                if self._callback_changed then
                    self._callback_changed()
                end
            end
        end)
        -- 需要先设置字体再设置光标
        node:setFontName(fontName)
        -- 显示末尾光标
        node:setCursorEnabled(true)
        -- 去掉开始光标
        libUI.initTextField(node)
        -- 固定大小
        node:ignoreContentAdaptWithSize(false)
        -- 限制长度
        node:setMaxLengthEnabled(true)
        -- 自动换行
        local render = node:getVirtualRenderer()
        if render then
            render = tolua.cast(render,"cc.Label")
            if render then
                render:setLineBreakWithoutSpace(true)
            end
        end
        -- 尺寸
        node:setContentSize(size)
    end
    self.__node = node
    self.__type = node[".classname"]
    parent:addChild(node)
    -- 元表，想实现函数检测优先级：1BaseInput 2node
    setmetatable(self, {__index = function (t, key)
        -- t.class=BaseInput
        if t.class[key] then
            return t.class[key]
        elseif self.__node[key] then
            return function ( _self, ... )
                self.__node[key](self.__node, ...)
            end
        end
    end})
    self:initByCsbTextField(template)
end

-- 是否可用
function BaseInput:isValidNode()
    if self.__type == "ccui.TextField" then
        return libUI.isValidNode(self.__node)
    elseif self.__type == "ccui.EditBox" then
        return libUI.isValidNode(self.__node)
    end
end

-- 获取字符串
function BaseInput:getString()
    if self.__type == "ccui.TextField" then
        return self.__node:getString()
    elseif self.__type == "ccui.EditBox" then
        return self.__node:getText()
    end
end
-- 设置字符串
function BaseInput:setString( str )
    if self.__type == "ccui.TextField" then
        return self.__node:setString(str)
    elseif self.__type == "ccui.EditBox" then
        return self.__node:setText(str)
    end
end
-- 显示隐藏键盘
function BaseInput:showKeyboard()
    if self.__type == "ccui.TextField" then
        return self.__node:attachWithIME()
    elseif self.__type == "ccui.EditBox" then

    end
end
function BaseInput:hideKeyboard()
    if self.__type == "ccui.TextField" then
        return self.__node:didNotSelectSelf()
    elseif self.__type == "ccui.EditBox" then

    end
end

-- 设置回调函数
-- 开始
function BaseInput:listenEventBegan( callback )
    self._callback_began = callback
end
-- 修改
function BaseInput:listenEventChanged( callback )
    self._callback_changed = callback
end
-- 结束
function BaseInput:listenEventEnded( callback )
    self._callback_ended = callback
end
-- 返回
function BaseInput:listenEventReturn( callback )
    self._callback_return = callback
end

function BaseInput:isEditBox()
    return self.__type == "ccui.EditBox"
end

function BaseInput:initByCsbTextField( node )
    self:setAnchorPoint(cc.p(node:getAnchorPoint()))
    self:setPosition(cc.p(node:getPosition()))
    self:setPlaceHolder(node:getPlaceHolder())
    self:setFontSize(node:getFontSize())
    self:setMaxLength(node:getMaxLength())
    self:setTouchEnabled(node:isTouchEnabled())
end