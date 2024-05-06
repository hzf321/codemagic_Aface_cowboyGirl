local Ad_Reward_Dialog = class("Ad_Reward_Dialog", CreatorNode)

function Ad_Reward_Dialog:ctor(data, callback)
    self.isPortrait = ScreenControl:getInstance().isPortrait
    self.ctl        = AdRewardControl:getInstance()
    self.adCoins    = self.ctl:getFreeCoins()
	self.csb        = "ui/free_coins/freecoins_pop"
    self.waitTime   = 3600
    CreatorNode.ctor(self, self.csb .. (self.isPortrait and "_v" or ""))
    self:initButtonList(true)

    -- local function timercall()
    --     bole.playSounds("beng")
    --     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.soundCallBack)  -- 清理活动倒计时的定时器
    -- end
    -- self.soundCallBack = cc.Director:getInstance():getScheduler():scheduleScriptFunc(timercall, 0.5, false)
end


function Ad_Reward_Dialog:showAnim()
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
    local label_coins = self.root.label_coins
    label_coins:setOpacity(0)
    label_coins:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.FadeIn:create(15 * speed)
        )
    )

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

function Ad_Reward_Dialog:loadControls()
    HttpManager:getInstance():doReport(ReportConfig.freecoins_open)
    self.root = self.node.root
    self:showAnim()
    self.isClose = true
    local closeBtn = self.root.btn_close;
    local label_coins = self.root.label_coins
    label_coins:setString(FONTS.format(self.adCoins, true))


    local gettime = User:getInstance():getFreeCoinsTime()
    if gettime == 0 then        --可以领取
        self.root.des_seconds:setVisible(false);
        self.root.label_seconds:setVisible(false);
        self.root.btn_collect:setTouchEnabled(true)
        self.root.btn_collect:setColor(cc.c3b(255,255,255))
    else
        local  nowtime = os.time();
        local seconds = nowtime - gettime;
        if seconds >=  self.waitTime then      --超过时间 ，可以领取
            self.root.des_seconds:setVisible(false);
            self.root.label_seconds:setVisible(false);
            self.root.btn_collect:setTouchEnabled(true)
            self.root.btn_collect:setColor(cc.c3b(255,255,255))
            User:getInstance():setFreeCoinsTime(0)
        else                        -- 冷却时间
            self.root.btn_collect:setColor(cc.c3b(123,123,123))
            self.root.btn_collect:setTouchEnabled(false)
            self.root.des_seconds:setVisible(true);
            self.root.label_seconds:setVisible(true);
            local residueTime =  self.waitTime - seconds
            self.residueTime = residueTime
            self.root.label_seconds:setString(self.residueTime);

            local function timercall()
                self.residueTime = self.residueTime - 1
                self.root.label_seconds:setString(self.residueTime);
                if self.residueTime <= 0 then       --时间到
                    self.root.des_seconds:setVisible(false);
                    self.root.label_seconds:setVisible(false);
                    self.root.btn_collect:setTouchEnabled(true)
                    User:getInstance():setFreeCoinsTime(0)
                    self.root.btn_collect:setColor(cc.c3b(255,255,255))
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.soundCallBack)  -- 清理活动倒计时的定时器
                end
            end
            self.soundCallBack = cc.Director:getInstance():getScheduler():scheduleScriptFunc(timercall, 1, false)
        end
    end
 
end

function Ad_Reward_Dialog:show( ... )
    
    if self.isPortrait then
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
    else
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
    end

    self:showActions()
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

    HttpManager:getInstance():doReport(ReportConfig.freecoins_get)
    self.root.btn_close:setTouchEnabled(false)
    self.root.btn_collect:setTouchEnabled(false)

    local user  = User:getInstance()
    local pos   = bole.getWorldPos(self.root.btn_collect)
    local time  = 3.5
    if libUI.isValidNode(user.header) then
        User:getInstance():setFreeCoinsTime(os.time())
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

end

function Ad_Reward_Dialog:onBtnCloseClicked()
    if  self.isClose then
        bole.playSounds("click")
    end
    if self.soundCallBack then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.soundCallBack)  -- 清理活动倒计时的定时器
    end
    HttpManager:getInstance():doReport(ReportConfig.freecoins_close)
    self:hide()
   
end

return Ad_Reward_Dialog