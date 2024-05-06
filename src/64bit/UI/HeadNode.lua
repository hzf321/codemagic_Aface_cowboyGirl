HeadNode = class("HeadNode", CCSNode)

function HeadNode:ctor(themeCtl, isPortrait, theme_id)
    self.themeCtl = themeCtl
    self.isPortrait = isPortrait
    self.theme_id = theme_id
    
    CCSNode.ctor(self, "head/csb/head.csb")
    
    local touchFunc = function (sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:backToLobbyEvent()   
        end
    end
    local btnHome = self.node:getChildByName("btn_home")
    btnHome:addTouchEventListener(touchFunc)
end

function HeadNode:backToLobbyEvent()
    bole.playMusic("game2")

	self.themeCtl:unregisterPotpCmds()
	self.themeCtl.theme:unloadThemeMusics()
    LobbyControl:getInstance():initScene("PlayScene")
end