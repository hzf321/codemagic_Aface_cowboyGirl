---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/03/15 14:50
---
local cls = class("JackpotItemTip", function()
    return cc.Node:create()
end)
function cls:ctor(jpCtl, index, parent)
    self.parent = parent
    self.ctl = jpCtl
    self.index = index
    self.csb = self.ctl:getCsbPath("jp_tip")
    self.node = cc.CSLoader:createNode(self.csb)
    self:addChild(self.node)
    self:loadControls()

end
function cls:loadControls()

    local jackpot_config = self.ctl:getJackpotConfig()
    local lock_img = jackpot_config.tip.lock_jp_img
    local unlock_img = jackpot_config.tip.unlock_jp_img
    local str_lock = string.format(lock_img, self.index)
    local str_unlock = string.format(unlock_img, self.index)
    local base_pos = jackpot_config.jp_tip_pos[self.index]
    self.rootNode = self.node:getChildByName("root")
    self.unlockNode = self.rootNode:getChildByName("unlock")
    self.unlockNode:setVisible(false)

    self.lockNode = self.rootNode:getChildByName("lock")
    self.lockNode:setVisible(false)

    local jackpot1 = self.unlockNode:getChildByName("img")
    bole.updateSpriteWithFile(jackpot1, str_unlock)

    local jackpot2 = self.lockNode:getChildByName("img")
    bole.updateSpriteWithFile(jackpot2, str_lock)

    self.parent:addChild(self)
    self:setPosition(base_pos)
end
function cls:showJpTipNode(status)
    local showNode = self.lockNode
    if status == 2 then
        showNode = self.unlockNode
        self.lockNode:stopAllActions()
        self.lockNode:setVisible(false)
    else
        self.unlockNode:stopAllActions()
        self.unlockNode:setVisible(false)
    end
    showNode:setVisible(true)
    showNode:setScale(0)
    showNode:runAction(
            cc.Sequence:create(
                    cc.ScaleTo:create(0.1, 1.1),
                    cc.ScaleTo:create(0.1, 1),
                    cc.DelayTime:create(1),
                    cc.ScaleTo:create(0.1, 1, 1.1),
                    cc.ScaleTo:create(0.1, 0),
                    cc.Hide:create()
            )
    )
end
function cls:hideTipNode()
    if self.lockNode:isVisible() then
        self.lockNode:stopAllActions()
        self.lockNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.1, 0),
                        cc.Hide:create()
                )
        )
    end
    if self.unlockNode:isVisible() then
        self.unlockNode:stopAllActions()
        self.unlockNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.1, 0),
                        cc.Hide:create()
                )
        )
    end
end
return cls