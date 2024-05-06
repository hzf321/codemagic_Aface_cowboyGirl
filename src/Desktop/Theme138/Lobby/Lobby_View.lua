local BLNode 		   = require("UI/CreatorUI/BLNode")
local CreatorTableView = require("UI/CreatorUI/CreatorTableView")
local Lobby_Theme      = require (bole.getDesktopFilePath("Lobby/Lobby_Theme"))

local Lobby_View = class("Lobby_View", BLNode)

function Lobby_View:ctor(isFromTheme)
    self.isFromTheme = isFromTheme
    self.csb         = "ui/lobby/lobby_view"
    self.csbName     = "lobby_view"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self:loadControls()
end

function Lobby_View:loadControls()
    self.root = self.node.root
    self:configThemeScrollView()
    self:enterActions()
end

-- 机台列表
function Lobby_View:configThemeScrollView()
    local themeCount = 10
    local svSize     = cc.size(1280, 720)
    local theme_sv   = self.root.theme_sv
    if theme_sv then
        theme_sv:setContentSize(svSize)
        theme_sv:setScrollBarEnabled(false)
        theme_sv:setBounceEnabled(true)
        theme_sv:setInertiaScrollEnabled(true)
        theme_sv:setDirection(ccui.ScrollViewDir.horizontal)
        theme_sv:setInnerContainerSize({width = themeCount * 345, height = svSize.height})

        for index = 1, themeCount do
            local theme_node = Lobby_Theme.new(index)
            theme_sv:addChild(theme_node)
            theme_node:setLocalZOrder(themeCount - index)
            if not self.isFromTheme then
                theme_node:enterAction()
            else
                theme_node:playThemeLogoSpine()
            end
        end
    end

end


-- 从登录界面进入大厅，入场动画
function Lobby_View:enterActions ()
    
    local bg_node = self.root.bg_node
    if bg_node then
        if self.isFromTheme then
            if bg_node.bg_temp then
                bg_node.bg_temp:removeFromParent()
                 
            end
            if bg_node.lobby_bg then
                bg_node.lobby_bg:setPositionX(0)
            end
            return 
        end

     

        bg_node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.15),
                cc.CallFunc:create(function()
                    bole.playSounds("zhuanchang")
                end)
            )
        )
        bg_node:runAction(
            cc.Spawn:create(
                cc.MoveTo:create(0.9,cc.p(-3120, 0)),
                cc.Sequence:create(
                    cc.ScaleTo:create(0.2, 1.5),
                    cc.DelayTime:create(0.3),
                    cc.CallFunc:create(function()
                    end),
                    cc.ScaleTo:create(1, 1),
                    cc.CallFunc:create(function()
                        if bg_node and bg_node.bg_temp then
                            bg_node.bg_temp:removeFromParent()
                        end
                    end)
                )
            )
        )
    end
end


return Lobby_View