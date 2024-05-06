local getSpinePath = function (name)
    return string.format("lobby/spines/%s/spine", name)
end

local Lobby_Gift_Dialog = class("Lobby_Gift_Dialog", CreatorNode)

function Lobby_Gift_Dialog:ctor(data, callback)
    self.isPortrait = ScreenControl:getInstance().isPortrait
    self.ctl        = AdRewardControl:getInstance()
    self.giftCoins  = 6000000
	self.csb        = "ui/lobby/lobby_gift_pop"
    CreatorNode.ctor(self, self.csb)
    self:initButtonList(false)
    self.getFnc = data.getFunc
end

function Lobby_Gift_Dialog:loadControls()
    self.root = self.node.root  
    bole.playSounds("tiaochu")
    local gift_spine = self.root.gift_spine
    if gift_spine then
        gift_spine:setAnimation(0, "appear", false) 
        gift_spine:registerSpineEventHandler( function(event)
            if event.animation == "appear" then
                gift_spine:setAnimation(0, "loop", true) 
            end
            if event.animation == "disappear" then
                gift_spine:setVisible(false) 
            end
        end, sp.EventType.ANIMATION_COMPLETE)
    end

    local hand_spine = self.root.hand_spine
    if hand_spine then
        hand_spine:setAnimation(0, "appear", false) 
        hand_spine:registerSpineEventHandler( function(event)
            if event.animation == "appear" then
                hand_spine:setAnimation(0, "loop", true) 
            end
            if event.animation == "disappear" then
                hand_spine:setVisible(false);  
            end
        end, sp.EventType.ANIMATION_COMPLETE)
    end
    

end

function Lobby_Gift_Dialog:show( delay )
    delay = delay or 0.5
    
    if self.isPortrait then
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
    else
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
    end

    self:showActions()
    bole.scene:addChild(self, 1000)
    self:setVisible(false)
    self:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function ( ... )
                self:setVisible(true)
                bole.popWin_4(self.root, nil, 0.36, 1)
                self:showMask(self.isPortrait, 0.2)
        end)
    ))
end

function Lobby_Gift_Dialog:hide()
    if self.isHiding then return end

    if self.callback then self.callback() end
    self:hideActions(true)
    bole.closeDialog(self, bole.popExitWin)
end


function Lobby_Gift_Dialog:labelAnim()
  
    local label_coins = self.root.label_coins
    label_coins:setVisible(true)
    label_coins:setLocalZOrder(2)
    label_coins:setString(FONTS.formatByCount4(self.giftCoins, 12, false, false))

    label_coins:runAction(
        cc.Sequence:create(
            cc.ScaleTo:create(0.2, 1.82),
            cc.ScaleTo:create(0.4, 2.2),
            cc.ScaleTo:create(0.2, 0.97),
            cc.ScaleTo:create(0.2, 1),
            cc.DelayTime:create(4),
            cc.CallFunc:create(function()
                self:hide()
                self.getFnc()
            end)
        )
    )

end


function Lobby_Gift_Dialog:onBtnCollectClicked()
    self.root.btn_collect:setTouchEnabled(false)
  
    bole.playSounds("click")
    self.root.gift_spine:setAnimation(0, "disappear", false) 
    self.root.hand_spine:setAnimation(0, "disappear", false) 
    self:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function ()
                self.root.hand_spine:setVisible(false)
                self.root.gift_spine:setVisible(false)
                self.root.label_guide:setVisible(false)  
                bole.playSounds("baokai")
                bole.addSpineAnimation(self.root, nil, getSpinePath("upper"), cc.p(0,0), "appear", nil, nil, nil, true, false, nil)
 
                local _, lower = bole.addSpineAnimation(self.root, nil, getSpinePath("lower"), cc.p(0,0), "appear", nil, nil, nil, true, false, nil)
                lower:registerSpineEventHandler( function(event)
                    if event.animation == "appear" then
                        local user    = User:getInstance()
                        local pos     = bole.getWorldPos(self.root.label_coins)
                        local time    = 3.5
                        if libUI.isValidNode(user.header) then
                            time = HeaderFooterControl:getInstance():flyCoins(pos, user:getCoins(), self.giftCoins, self)
                            user:addCoins(self.giftCoins, 1)
                            user:updateGiftState(1)
                        end
                        lower:setAnimation(0, "loop", true) 
                    end
                end, sp.EventType.ANIMATION_COMPLETE)

                self:labelAnim()
            end)
        )
    )
end

return Lobby_Gift_Dialog