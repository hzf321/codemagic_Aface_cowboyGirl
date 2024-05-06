local Setting_Dialog = class("Setting_Dialog", CreatorNode)

function Setting_Dialog:ctor(data, callback)
    self.data       = data or {}
    self.initPos    = data.pos or cc.p(311, 585)
    self.isGame = bole.isThemeScene() 
    self.ctl        = SettingControl:getInstance()
	self.csb        = "ui/setting/setting_pop"
    CreatorNode.ctor(self, self.csb .. (self.isGame and "_v" or ""))
    self:initButtonList(true)

    if self.isGame then
        HttpManager:getInstance():doReport(ReportConfig.btn_setting_game)
    else
        HttpManager:getInstance():doReport(ReportConfig.btn_setting_lobby)
    end
end

function Setting_Dialog:loadControls()
    self.root = self.node.root
    
    self:updateContrlNode("music")
    self:updateContrlNode("sound")

    if self.isGame then
        self:showThemeSetting()
    end
end

function Setting_Dialog:show(delay)
    delay = delay or 0.5

    if self.isGame then
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
    else
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
    end

    -- self:showActions()
    bole.scene:addChild(self, 1000)

    if self.isGame then
        self.mask_to_opa = 0
        self:showMask(self.isGame, 0.2)
    else
        self:setVisible(false)
        self:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(delay),
                cc.CallFunc:create(function ( ... )
                    self:setVisible(true)
                    bole.popWin_4(self.root, nil, 0.36, 1)
                    self:showMask(self.isGame, 0.2)
            end)
        ))
    end

end

function Setting_Dialog:hide()
    if self.isHiding then return end

    if self.callback then self.callback() end
    self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end

-- 刷新状态
function Setting_Dialog:updateContrlNode(type, state)
    
    local contrl_node = self.root.contrl_node
    if not contrl_node then return end

    local isOpen = true
    if state then
        isOpen = state == 0
        if type == "music" then
            self.ctl:updateMusicOpen(state)
            if self.ctl:isMusicOpen() then
                SettingControl:getInstance():setSettingStatus("music",  1)
            else
                SettingControl:getInstance():setSettingStatus("music",  0)
            end
             
        else
            self.ctl:updateSoundOpen(state)
            if self.ctl:isSoundOpen() then
                SettingControl:getInstance():setSettingStatus("sound", 1 )
            else
                SettingControl:getInstance():setSettingStatus("sound", 0)
            end
            
        end
    else
        if type == "music" then
            isOpen = self.ctl:isMusicOpen()
        else
            isOpen = self.ctl:isSoundOpen()
        end
    end

    local node = contrl_node[type.."_node"]
    bole.updateSpriteWithFile(node.bg, isOpen and "#switch_on.png" or "#switch_off.png")

    local btn  = node["btn_"..type]
    btn:setTouchEnabled(false)

    local move = node.move
    -- move:setPositionX(isOpen and 213.5 or 100)
    move:stopAllActions()
    move:runAction(
        cc.Sequence:create(
            cc.MoveTo:create(0.3, cc.p(isOpen and 213.5 or 100, move:getPositionY())),
            cc.CallFunc:create(function()
                btn:setTouchEnabled(true)
            end)
        )
    )

end


function Setting_Dialog:showThemeSetting()
	local contrl_node = self.root.contrl_node
	if contrl_node then
        local pos = bole.getNodePos(contrl_node, self.initPos)
		contrl_node:setVisible(true)
		contrl_node:stopAllActions()
		contrl_node:setOpacity(0)
		contrl_node:setScale(0)
        contrl_node:setPosition(cc.p(pos.x - 140, pos.y - 260))
		contrl_node:runAction(cc.Spawn:create(cc.FadeIn:create(0.2), cc.ScaleTo:create(0.2, 1)))
	end
end

function Setting_Dialog:hideThemeSetting()
	local contrl_node = self.root.contrl_node
	if contrl_node then
		contrl_node:setVisible(true)
		contrl_node:stopAllActions()
		contrl_node:setOpacity(255)
		contrl_node:setScale(1)
		contrl_node:runAction(        
            cc.Sequence:create(	
                cc.Spawn:create(cc.FadeOut:create(0.2), cc.ScaleTo:create(0.2, 0)),
                cc.CallFunc:create(function ()
                    self:hide()
                end)
            )
        )
	end
end


function Setting_Dialog:onBtnMusicClicked()
    HttpManager:getInstance():doReport(ReportConfig.btn_change_music_setting)
    self:updateContrlNode("music", self.ctl:isMusicOpen() and 1 or 0)
    bole.playSounds("click")
end

function Setting_Dialog:onBtnSoundClicked()
    HttpManager:getInstance():doReport(ReportConfig.btn_change_sound_setting)
    self:updateContrlNode("sound", self.ctl:isSoundOpen() and 1 or 0)
    bole.playSounds("click")
end

function Setting_Dialog:onBtnGameruleClicked()
    self:hide()
    local user = User:getInstance()
    if user.header and user.header.themeCtl then
        local themeCtl = user.header.themeCtl
        HttpManager:getInstance():doReport(ReportConfig.btn_rule_play)
        PopupController:getInstance():popupDialogDirectly("game_rules", {controller = themeCtl}, nil)
    end
end

function Setting_Dialog:onBtnCloseClicked()
    HttpManager:getInstance():doReport(ReportConfig.btn_close_setting)
    bole.playSounds("click")
    self.root.btn_close:setTouchEnabled(false)
    if self.isGame then
        self:hideThemeSetting()
    else
        self:hide()
    end
end


-- 服务条款
function Setting_Dialog:onBtnServiceClicked()
    bole.playSounds("click")
    local url = "https://sites.google.com/view/mayanfortunetermsofservice"
	cc.Application:getInstance():openURL(url)
    HttpManager:getInstance():doReport(ReportConfig.btn_service_setting)
end

-- 隐私协议
function Setting_Dialog:onBtnPrivacyClicked()
    bole.playSounds("click")
    local url = "https://sites.google.com/view/mayanfortuneprivacypolicy"
	cc.Application:getInstance():openURL(url)
    HttpManager:getInstance():doReport(ReportConfig.btn_privacy_setting)
end


return Setting_Dialog
