---
--- @program src 
--- @description:  
--- @author: rwb 
---@create: : 2021/02/22 19:00:00
local cls = class("TCCollectView")
function cls:ctor(ctl, parent, flyNode)
    self.ctl = ctl
    self.node = parent
    self.flyNode = flyNode
end
function cls:initCollectRoot()
    local collect_config = self.ctl:getCommonConfig().collect_config
    self._upTime = collect_config.up_time
    self._flyTime = collect_config.fly_time
    self.collectRoot = self.node:getChildByName("root")
    self.collectItem = self.collectRoot:getChildByName("collect_item")
    self.collectLabel = self.collectRoot:getChildByName("label")
    self.collectLabel.maxWidth = collect_config.label_max_width
    self.collectLabel.baseScale = collect_config.label_max_scale
    inherit(self.collectLabel, LabelNumRoll)
    local function parseValue1(num)
        local str = FONTS.formatByCount4(num, 12, true, true)
        return str
    end
    self.collectLabel:nrInit(0, 24, parseValue1)
end
function cls:getUpTime()
    return self._upTime or 0.2
end
function cls:getFlyTime()
    return self._flyTime or 0.3
end
function cls:_updateLoopSpine(isLock)
    if isLock then
        self.loopAni:setVisible(false)
    else
        self.loopAni:setVisible(true)
    end
end
function cls:_addReceiveLight()
    local downData = {}
    downData.parent = self.collectItem
    downData.file = self.ctl:getSpineFile("collect_receive")
    downData.animateName = "animation"
    downData.zOrder = 1
    bole.addAnimationSimple(downData)
    if self.m1Spine and bole.isValidNode(self.m1Spine) then
        self.m1Spine:setAnimation(0, "animation2", false)
        self.m1Spine:addAnimation(0, "animation1", true)
    end
end
function cls:getCollectNodeWorldPos()
    local wEndPos = self.collectItem:convertToWorldSpace(cc.p(-72, 0))
    return wEndPos
end
function cls:updateCollectCount(newCount, beforeCount, isAnimate)
    beforeCount = beforeCount or 0
    self:setCollectNum(newCount, beforeCount, isAnimate)
end

---@param status /1:打开，2:关闭，0:忽略
function cls:setCloseTipStatus(status)
    self.closeTipStatus = status
end
function cls:getCloseTipStatus()
    return self.closeTipStatus or 2
end
function cls:flyItemActions(info)

    local endWPos = self:getCollectNodeWorldPos()
    local endNPos = bole.getNodePos(self.flyNode, endWPos)

    self.ctl:playMusicByName("collect_fly")
    for i = 1, #info do
        local file = self.ctl:getSpineFile("collect_fly")
        local data = {}
        data.file = file
        data.parent = self.flyNode
        data.pos = info[i][3]
        data.animateName = "animation2"
        local _, s = bole.addAnimationSimple(data)
        s:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(5 / 30),
                        cc.CallFunc:create(function()
                            self:addPractice(s)
                            self:_parabolaToAnimation(s, endNPos)
                        end)

                )
        )
    end
end
function cls:addPractice(parentNode)
    local p1 = self.ctl:getParticleFile("bonus_tail")
    local p2 = self.ctl:getParticleFile("bonus_lizi_tail")
    local s1 = cc.ParticleSystemQuad:create(p1)
    local s2 = cc.ParticleSystemQuad:create(p2)
    parentNode:addChild(s1, -1)
    parentNode:addChild(s2, -1)
end
function cls:_parabolaToAnimation(obj, to)
    local from = bole.getPos(obj)
    local half = cc.pMidpoint(to, from)
    local a = to.y - from.y
    local b = to.x - from.x
    local a1 = half.y - b / 2
    local b1 = half.x + a / 2
    local dur = 13 / 30
    obj:runAction(
            cc.Sequence:create(
                    cc.Spawn:create(
                            cc.BezierTo:create(dur, { from, cc.p(b1, a1), to }),
                            cc.ScaleTo:create(dur, 0.2)
                    ),
                    cc.DelayTime:create(15 / 30),
                    cc.RemoveSelf:create()
            )
    )
end

function cls:setCollectNum(nowCount, beforeCount, isAnimate)

    local value_str = FONTS.formatByCount4(nowCount, 12, true, true)
    self.collectLabel:setString(value_str)
    bole.shrinkLabel(self.collectLabel, self.collectLabel.maxWidth, self.collectLabel.baseScale)
    if isAnimate then
        bole.shrinkLabel(self.collectLabel, self.collectLabel.maxWidth, self.collectLabel.baseScale)
        self.collectLabel:nrStartRoll(beforeCount, nowCount, self:getUpTime())
        self:_playReceiveAni()
    end
end
function cls:_playReceiveAni()
    local data = {}
    data.file = self.ctl:getSpineFile("collect_receive")
    data.parent = self.collectRoot
    data.pos = self:receivePos()
    bole.addAnimationSimple(data)
end
function cls:receivePos()
    local pos = bole.getPos(self.collectItem)
    return cc.pSub(pos, cc.p(72, 0))
end

return cls





