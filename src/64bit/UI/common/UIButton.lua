--[[
    使用方法： style 按钮样式 | text 文本 | icon 图标路径 | callFunc 监听事件
    local data = {
        style    = 1
        text     = "INVITE", 
        icon     = "",
        callFunc = function (_self, btn) 
            
        end
    }
    UIButton.new(btn, self, data)
]]--

local UIButton = class("UIButton")

function UIButton:ctor(node, parent, data)
    if node[".classname"] ~= "ccui.Button" then
        self.button = node:getChildByName("btn")
    else
        self.button = node
    end

    if self.button then
        bole.ctorUIComponent(self.button, UIComponent.CommonButton)
        self.btnSize = self.button:getContentSize()  

        self.data    = data or {}
        self:setButtonStyle(self.data.style or 1)
        self:addTouchEvent(parent)
    end

end

------------------------------ 字体 ----------------------------
--设置按钮文本
function UIButton:setButtonText()
    if self.text and self.data.text then
        self.text:setString(self.data.text)
        self:shrinkButtonText()
    end
end

--限制字体最大长度
function UIButton:shrinkButtonText()
    if self.text then
        bole.shrinkLabel(self.text, self.btnSize.width * 0.8, self.text:getScale())
    end
end


------------------------------ 按钮样式 ----------------------------
--设置按钮样式
function UIButton:setButtonStyle(style)
    if style == 1 then       --纯文本
        self:buttonStylePureText()
    elseif style == 2 then   --左边文本+右边图标
        self:buttonStyleTextIcon()
    else
        self:buttonStylePureText()
    end
end
--样式一，纯文本
function UIButton:buttonStylePureText()
    if self.data and self.data.text then
        self.text    = self.button:getChildByName("text")
        self:setButtonText()
    end
end
--样式二，左边文本+右边图标
function UIButton:buttonStyleTextIcon()
    self:buttonStylePureText()
    local path = self.data.icon
    if path then
        local pos = cc.p(self.btnSize.width * 0.85, self.btnSize.height * 0.55)
        libUI.createSprite(self.button, path, pos)
    end
end

------------------------------ 事件 ----------------------------
--设置按钮监听事件
function UIButton:addTouchEvent(parent)
    if self.data and self.data.callFunc then
        bole.addTouchEvent(self.button, self.data.callFunc, parent, {self.button})
    end
end

function UIButton:setTouchEnabled(enabled)
    if self.button then
        self.button:setTouchEnabled(enabled)
    end
end

return UIButton