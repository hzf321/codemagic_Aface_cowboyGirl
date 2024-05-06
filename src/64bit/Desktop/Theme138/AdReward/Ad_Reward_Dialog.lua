local Ad_Reward_Dialog = class("Ad_Reward_Dialog", CreatorNode)

function Ad_Reward_Dialog:ctor(data, callback)
    self.isPortrait = ScreenControl:getInstance().isPortrait
    self.ctl        = AdRewardControl:getInstance()
    self.adCoins    = self.ctl:getAdRewardCoins()
	self.csb        = "ui/ad_reward/ad_reward_pop"
    CreatorNode.ctor(self, self.csb)
    self:initButtonList(true)

    -- local function timercall()
    --     bole.playSounds("beng")
    --     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.soundCallBack)  -- 清理活动倒计时的定时器
    -- end
    -- self.soundCallBack = cc.Director:getInstance():getScheduler():scheduleScriptFunc(timercall, 0.5, false)
end

function Ad_Reward_Dialog:loadControls()
    -- self.root = self.node.root
    -- self.isClose = true
    -- self.root :runAction(
    --     cc.Sequence:create(
    --         cc.DelayTime:create(0.5),
    --         cc.CallFunc:create(function ()
    --             bole.playSounds("beng")
    --         end)
    --     )
    -- )
 

    local speed = 1 / 30

    self:setVisible(false)
    self:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function ( ... )
                self:setVisible(true)
                bole.popWin_4(self.root, nil, 0.36, 1)
                self:showMask(self.isPortrait, 0.2)
        end)
    ))

    --设置金币
    local label_coins = self.root.label_coins
    label_coins:setOpacity(0)
    label_coins:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.FadeIn:create(15 * speed)
        )
    )
    label_coins:setString(self:formatCoin(self.adCoins))

    local btn_close = self.root.btn_close
    btn_close:setOpacity(0)
    btn_close:runAction(cc.Sequence:create(
        cc.DelayTime:create(25 * speed),
        cc.FadeIn:create(15 * speed)
    ))

    local btn_collect = self.root.btn_collect
    btn_collect:setOpacity(0)
    btn_collect:runAction(cc.Sequence:create(
        cc.DelayTime:create(25 * speed),
        cc.FadeIn:create(10 * speed)
    ))
end

function Ad_Reward_Dialog:show( ... )
    
    if self.isPortrait then
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
    else
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
    end

    -- self:showActions()
    bole.scene:addChild(self, 1000)
    self:showMask(self.isPortrait, 0)
end

function Ad_Reward_Dialog:hide()
    if self.isHiding then return end

    if self.callback then self.callback() end
    self:hideActions(true)
    bole.closeDialog(self, bole.popExitWin)
end


function Ad_Reward_Dialog:onBtnCollectClicked()
    bole.playSounds("click")
    HttpManager:getInstance():doReport(ReportConfig.btn_video_get_lobby)
    Admop:getInstance():openAd(function ()
        self:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.1),
                cc.CallFunc:create(function ()
                    self.root.btn_close:setTouchEnabled(false)
                    self.root.btn_collect:setTouchEnabled(false)
                
                    local curCount = self.ctl:getAdCurrentCount()
                    self.ctl:updateAdCount(curCount + 1)
                
                    local user  = User:getInstance()
                    local pos   = bole.getWorldPos(self.root.btn_collect)
                    local time  = 3.5
                    if libUI.isValidNode(user.header) then
                        time = HeaderFooterControl:getInstance():flyCoins(pos, user:getCoins(), self.adCoins, self)
                        user:addCoins(self.adCoins, 1)
                    end
                
                    self:runAction(cc.Sequence:create(
                        cc.DelayTime:create(time),
                        cc.CallFunc:create(function ()
                            self.isClose = false
                            self:onBtnCloseClicked()
                        end)
                    ))
                end)
            )
        )
    end)
end

function Ad_Reward_Dialog:onBtnCloseClicked()
    if  self.isClose then
        bole.playSounds("click")
    end
    
    HttpManager:getInstance():doReport(ReportConfig.btn_video_close_lobby)
    self.root.label_coins:setVisible(false)
    self.root.btn_close:setVisible(false)
    self.root.btn_collect:setVisible(false)
    self:hide()
end

function Ad_Reward_Dialog:formatCoin(n)
    local last = ""
    if self.isAllowKB == true then
        if not ScreenControl:getInstance().isPortrait then
            if n > 999999999999999999999 then
                n = n / 1000000000
                n = math.floor(n)
                last = "B"
                return FONTS.format(n, true) .. last
            elseif n > 999999999999999999 then
                n = n / 1000000
                n = math.floor(n)
                last = "M"
                return FONTS.format(n, true) .. last
            elseif n > 999999999999999 then
                n = n / 1000
                n = math.floor(n)
                last = "K"
                return FONTS.format(n, true) .. last
            end
        else
            return FONTS.format(n, true) .. last
        end
    end 

    return FONTS.format(n, true)
end

return Ad_Reward_Dialog