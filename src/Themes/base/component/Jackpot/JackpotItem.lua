---
--- @program src 
--- @description:
--- @author: rwb 
--- @create: 2021/03/15 14:50
---
---
local cls = class("ThemeJackpotItem")
function cls:ctor(jpCtl, node, index, label)
    self.ctl = jpCtl
    self.node = node
    self.index = index
    self.jackpotLabel = label
    local jackpot_config = self.ctl:getJackpotConfig()
    local width = jackpot_config.width[self.index]
    local scale = jackpot_config.scale[self.index]
    self.jackpotLabel.baseScale = scale
    self.jackpotLabel.maxWidth = width
    self.lockNode = node:getChildByName("bg_lock")
    self.unlockNode = node:getChildByName("bg_normal")
    self.bgLoop = self.unlockNode:getChildByName("bg_loop")
    self.btn = self.lockNode:getChildByName("btn")

    self.unlockSpineNode = self.unlockNode:getChildByName("bg_loop")
    self:_creatJpClickEvent()
    self.basePos = bole.getPos(self.node)
    self.node:setLocalZOrder(self.index)
    self.jackpotLabel:setLocalZOrder(self.index + 10)
    self.lockNode:setVisible(false)
    self:_addLoopAni()
end
function cls:_creatJpClickEvent()

    local function onTouchJp(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.ctl:jpBtnClickEvent(self.index)
        end
    end
    self.btn:addTouchEventListener(onTouchJp)
    self.btn:setTouchEnabled(false)
end
function cls:_addLoopAni()
    local data = {}
    data.parent = self.unlockSpineNode
    data.file = self.ctl:getSpineFile("jackpot_loop")
    data.isLoop = true
    local win_ani = self.ctl:getSpineAniList().jp_loop_ani
    data.animateName = string.format(win_ani, self.index)
    local _, s = bole.addAnimationSimple(data)
    self.loopAni = s
end
function cls:addWinJpAni()
    local data = {}
    self.node:setLocalZOrder(100)
    self.jackpotLabel:setLocalZOrder(100 + 10)
    if self.isLock then
        return
    end
    if not self.unlockSpineNode:getChildByName("jp_win") then
        data.parent = self.unlockSpineNode
        data.file = self.ctl:getSpineFile("jackpot_win")
        data.isLoop = true
        local win_ani = self.ctl:getSpineAniList().jp_win_ani
        data.animateName = string.format(win_ani, self.index)
        local _, s = bole.addAnimationSimple(data)
        s:setName("jp_win")
    end
end
function cls:removeJpAni()
    self.node:setLocalZOrder(self.index)
    self.jackpotLabel:setLocalZOrder(self.index + 10)
    local jp_win = self.unlockSpineNode:getChildByName("jp_win")
    if jp_win and bole.isValidNode(jp_win) then
        jp_win:removeFromParent()
    end
end
function cls:getParentNode()
    return self.node
end
function cls:changeJpStyle(isLock)

    if self.isLock and self.isLock == isLock then
        return
    end
    self.lockNode:setVisible(isLock)
    self.unlockNode:setVisible(not isLock)
    local jackpot_config = self.ctl:getJackpotConfig()
    local font
    if isLock then
        font = jackpot_config.fnt.lock
    else
        font = jackpot_config.fnt.unlock
    end
    if font then
        self.jackpotLabel:setFntFile(self.ctl:getFntFilePath(font))
    end
    self.isLock = isLock
end
function cls:setBtnTouchEnable(enable)
    self.btn:setTouchEnabled(enable)
end
function cls:addLockSpine(parent, base_pos, lock_ani)
    local file = self.ctl:getSpineFile("jackpot_lock")
    local _, s = bole.addSpineAnimation(parent, -1, file, base_pos, lock_ani, nil, nil, nil, true, false)
    self.lockSpine = s
end
function cls:playLockSpine(parent)
    local lock_ani = self.ctl:getSpineAniList().lock
    lock_ani = string.format(lock_ani, self.index)
    if not self.lockSpine then
        self:addLockSpine(parent, self.basePos, lock_ani)
    else
        self.lockSpine:setAnimation(0, lock_ani, false)
    end
    self.ctl:playMusicByOnce("jp_lock")
    self:delayForChangeStyle(true)
end

function cls:playUnLockSpine(parent)
    local unlock_ani = self.ctl:getSpineAniList().unlock
    unlock_ani = string.format(unlock_ani, self.index)
    if not self.lockSpine then
        self:addLockSpine(parent, self.basePos, unlock_ani)
    else
        self.lockSpine:setAnimation(0, unlock_ani, false)
    end
    self.ctl:playMusicByOnce("jp_unlock")
    self:delayForChangeStyle(false)
end
function cls:delayForChangeStyle(isLock)
    local delay = 0
    if isLock then
        delay = self.ctl:getSpineDelay("lock")
    else
        delay = self.ctl:getSpineDelay("unlock")
    end
    self.node:stopActionByTag(1001)
    local a1 = cc.DelayTime:create(delay)
    local a2 = cc.CallFunc:create(function()
        self:changeJpStyle(isLock)
    end)
    local a3 = cc.Sequence:create(a1, a2)
    a3:setTag(1001)
    self.node:runAction(a3)
end
return cls