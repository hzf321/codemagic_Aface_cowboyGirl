---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/03/09 16:52
---
---
local cls = class("TCBattleView")
function cls:ctor(ctl, battleNode, flyNode)
    self.ctl = ctl
    self.battleNode = battleNode
    self.flyNode = flyNode
    self:initBattleNode()
end
function cls:initBattleNode()
    self.battleRoot = self.battleNode:getChildByName("root")
    self.logoNode = self.battleRoot:getChildByName("team_logo")
    self.redLogoNode = self.logoNode:getChildByName("red_logo")
    self.blueLogoNode = self.logoNode:getChildByName("blue_logo")
    self.scoreNode = self.battleRoot:getChildByName("score_node")
    self.redLabel = self.scoreNode:getChildByName("red_score")
    self.blueLabel = self.scoreNode:getChildByName("blue_score")
    self.barPanel = self.battleRoot:getChildByName("bar_panel")
    self.barNode = self.barPanel:getChildByName("bar_node")
    self.collectCell = self.barNode:getChildByName("bar_img")

    self.upNode = self.battleRoot:getChildByName("center_node")
    self.loopNode = self.battleRoot:getChildByName("loop_node")
    --self:initBattleBarNode()
    self:_initCenterAni()
    self:_initLabels()
    self:setProgress(0, 0)
    --bole.setEnableRecursiveCascading(self.battleRoot, true)
end
function cls:_initLabels()
    self.redLabel:setString(0)
    self.blueLabel:setString(0)
    inherit(self.redLabel, LabelNumRoll)
    inherit(self.blueLabel, LabelNumRoll)
    local function parseValue(num)
        return FONTS.formatByCount4(num, 5, true, true)
    end
    self.redLabel:nrInit(0, 24, parseValue)
    self.blueLabel:nrInit(0, 24, parseValue)
    self.curLeftScore = 0
    self.curRightScore = 0

end
function cls:_initCenterAni()
    local data = {}
    data.file = self.ctl:getSpineFile("battle_bg")
    data.parent = self.loopNode
    data.isLoop = true
    data.animateName = "animation2"
    bole.addAnimationSimple(data)

    local data2 = {}
    data2.file = self.ctl:getSpineFile("battle_lizi")
    data2.parent = self.upNode
    data2.isLoop = true
    data2.animateName = "animation2"
    bole.addAnimationSimple(data2)

    local data3 = {}
    data3.file = self.ctl:getSpineFile("battle_lead")
    data3.parent = self.scoreNode
    data3.isLoop = true
    data3.animateName = "animation2"
    local _, s = bole.addAnimationSimple(data3)
    self.leadIcon = s
    self.leadIcon.status = 0
end
function cls:setLeadIconPos(leftScore, rightScore)
    if leftScore == rightScore then
        self.leadIcon:setVisible(false)
        self.leadIcon.status = 0
    elseif leftScore < rightScore then
        self.leadIcon:setVisible(true)
        self.leadIcon:setPosition(cc.p(140, 0))
        if self.leadIcon.status ~= 1 then
            self.leadIcon:setAnimation(0, "animation1", false)
            self.leadIcon:addAnimation(0, "animation2", true)
        end
        self.leadIcon.status = 1
    else
        self.leadIcon:setVisible(true)
        self.leadIcon:setPosition(cc.p(-140, 0))
        if self.leadIcon.status ~= 2 then
            self.leadIcon:setAnimation(0, "animation1", false)
            self.leadIcon:addAnimation(0, "animation2", true)
        end
        self.leadIcon.status = 2
    end
end
--function cls:initBattleBarNode()
--local battleConfig = self.ctl:getBattleConfig()
--local stencil = cc.Node:create()
--local clipSp = bole.createSpriteWithFile(battleConfig.stencil_bar)
--clipSp:setAnchorPoint(0.5, 0.5)
--stencil:addChild(clipSp)
--local clipNode = cc.ClippingNode:create(stencil)
--clipNode:setAlphaThreshold(0)
--self.barNode:addChild(clipNode)
--self.clipNode = clipNode
--self.collectCell = cc.Node:create()
--self.clipNode:addChild(self.collectCell)
--local imgBar = bole.createSpriteWithFile(battleConfig.img_bar)
--self.collectCell:addChild(imgBar)
--end
function cls:setProgress(leftScore, rightScore, isAni)
    self:setLeadIconPos(leftScore, rightScore)
    local totoal = leftScore + rightScore
    if totoal == 0 then
        totoal = 1
    end
    local endPosX = (leftScore - rightScore) / totoal * 164
    if math.abs(endPosX) > 164 then
        if endPosX > 0 then
            endPosX = 164
        else
            endPosX = -164
        end
    end
    self.collectCell:stopAllActions()
    self.upNode:stopAllActions()
    if isAni then
        local a1 = cc.MoveTo:create(0.3, cc.p(endPosX, 0))
        self.collectCell:runAction(a1)
        self.upNode:runAction(a1:clone())
        self.redLabel:nrStartRoll(self.curLeftScore, leftScore, 1)
        self.blueLabel:nrStartRoll(self.curRightScore, rightScore, 1)
    else
        self.collectCell:setPosition(cc.p(endPosX, 0))
        self.upNode:setPosition(cc.p(endPosX, 0))
        self.redLabel:setString(self.redLabel.nrParserFunc(leftScore))
        self.blueLabel:setString(self.blueLabel.nrParserFunc(rightScore))
    end
    self.curLeftScore = leftScore
    self.curRightScore = rightScore
end
--function cls:showBattleNode(isAni)
--    if not self.battleRoot:isVisible() then
--        self.battleRoot:stopAllActions()
--        self.battleRoot:setVisible(true)
--        self.battleRoot:setOpacity(0)
--        self.battleRoot:runAction(cc.FadeIn:create(0.5))
--    end
--end
--function cls:hideBattleNode(isAni)
--    if self.battleRoot:isVisible() then
--        self.battleRoot:stopAllActions()
--        self.battleRoot:setVisible(true)
--        self.battleRoot:setOpacity(255)
--        self.battleRoot:runAction(
--                cc.Sequence:create(
--                        cc.FadeOut:create(0.5),
--                        cc.Hide:create()
--                )
--        )
--    end
--end
return cls
