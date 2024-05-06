---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/02/25 14:34
---
local cls = class("balloonItem", function()
    return cc.Node:create()
end)
function cls:ctor(ctl, balloonInfo, index, parent)
    self.ctl = ctl
    self.index = index
    self.balloonInfo = balloonInfo
    self.parent = parent
    self.parent:addChild(self)
    self.cellWidth = 200
    self.cellHeight = 240
    self.sType = balloonInfo.s_type or 1
    self:initBalloon()
end
function cls:initBalloon()
    self:_addFlySpineAni()
    self:addTouchEvent()
    self:beginToFly()
end
function cls:addTouchEvent()
    local unitSize = 10
    local img = "commonpics/kong.png"
    local touchSpin = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            --self.ctl:stopMusicByName("balloon_fly")
            self.ctl:playMusicByName("balloon_touch")
            self:_balloonBreakAction()
        end
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setScaleX(self.cellWidth / unitSize)
    touchBtn:setScaleY(self.cellHeight / unitSize)
    self:addChild(touchBtn, 0)
    self.touchBtn = touchBtn
end
function cls:_addFlySpineAni()
    local data = {}
    data.file = self.ctl:getSpineFile("balloon_fly")
    if self.sType == 2 then
        data.animateName = "animation4"
    else
        data.animateName = "animation" .. self.index
    end
    data.parent = self

    data.isLoop = true
    data.pos = cc.p(0, 0)
    local _, s = bole.addAnimationSimple(data)
    self.flyBalloon = s
end
function cls:_removeFlySpineAni()
    if self.flyBalloon and bole.isValidNode(self.flyBalloon) then
        self.flyBalloon:removeFromParent()
    end
end
function cls:_addBalloonBreak()
    local data = {}
    data.file = self.ctl:getSpineFile("balloon_touch")
    data.parent = self:getParent()
    data.pos = self:getPickPos(bole.getPos(self))

    data.zOrder = -1
    if self.sType == 1 then
        data.animateName = "animation" .. self.index
    else
        data.animateName = "animation4"
    end
    bole.addAnimationSimple(data)
end
function cls:addBonusPoints(from)
    if from == 1 then
        local map_points = self.balloonInfo.map_points
        self:createBalloonFont(map_points)
    else
        local map_points = self.balloonInfo.value
        self:createBalloonFont(map_points)
    end
end
function cls:_balloonBreakAction()
    if self.isClick then
        return
    end
    self.isClick = true
    if self.touchBtn then
        self.touchBtn:setTouchEnabled(false)
    end
    self:stopAllActions()
    self.ctl:clickBalloon(self.balloonInfo, 1)
    self:_removeFlySpineAni()
    self:_addBalloonBreak()
    if self.balloonInfo.map_points then
        self:addBonusPoints(1)
    elseif self.balloonInfo.type then
        if self.balloonInfo.type == 1 then
            self:addBonusPoints(2)
        elseif self.balloonInfo.type == 2 then
            local score = self.balloonInfo.value
            local basePos = bole.getPos(self)
            local basePos = self:getPickPos(basePos)
            local pick_pos = self:getParent():convertToWorldSpace(basePos)
            self:addRankPoints(score, pick_pos)

        elseif self.balloonInfo.type == 3 then
            local multi = self.balloonInfo.value
            self:addMultiPoints(multi)

        end
    end
end
function cls:_addMapPointsLabel(map_points)
    self.ctl:addMapPoint(map_points)
end
function cls:beginToFly()
    local startY = self.ctl:getStartPosY() - self.cellHeight / 2
    local endY = self.ctl:getEndY() + self.cellHeight
    self.startX = math.random(-640 + self.cellWidth / 2, 640 - self.cellWidth / 2)
    self:setPosition(cc.p(self.startX, startY))
    local moveTime = 10
    if self.sType == 2 then
        moveTime = 2.4
    end
    self:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(moveTime, cc.p(self.startX, endY)),
                    cc.CallFunc:create(function()
                        self.ctl:stopMusicByName("balloon_fly")
                        self.ctl:clickBalloon(self.balloonInfo, 0)
                    end),
                    cc.RemoveSelf:create()
            )
    )
end
function cls:createBalloonFont(map_points)
    local node = cc.Node:create()
    self.parent:addChild(node)
    local basePos = cc.pSub(bole.getPos(self), cc.p(0, 0))
    node:setPosition(self:getPickPos(basePos))

    local path = self.ctl:getPic("font/tourncash_ingame_theme_fnt01.fnt")
    local newNode = libUI.createFont(node, path, cc.p(0, -30), 1)
    local str = FONTS.formatByCount4(map_points, 4, true, true)
    newNode:setString(str)
    newNode:setLocalZOrder(1)
    local bonusSymbol = self.ctl:getBonusID()
    local resourceID = self.ctl:getThemeResourceId()
    local img_file = "#theme" .. resourceID .. "_s_" .. bonusSymbol .. ".png"
    local img = bole.createSpriteWithFile(img_file)
    img:setPosition(cc.p(0, 30))
    node:addChild(img, 0)
    local collectPos = self.ctl:getCollectPos()
    node:setScale(0)
    node:runAction(
            cc.Sequence:create(
                    cc.EaseIn:create(cc.ScaleTo:create(10 / 30, 1), 2),
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function()
                        self.ctl:playMusicByName("balloon_num")
                        self:addPractice(node)
                        self:_parabolaToAnimation(node, collectPos)
                    end),
                    cc.DelayTime:create(15 / 30),
                    cc.CallFunc:create(
                            function()
                                self:_addMapPointsLabel(map_points)
                            end),
                    cc.ScaleTo:create(5 / 30, 0),
                    cc.CallFunc:create(
                            function()
                                self:removeFromParent()
                            end),
                    cc.RemoveSelf:create()
            )
    )

end
function cls:_parabolaToAnimation(obj, to)
    local from = bole.getPos(obj)
    local half = cc.pMidpoint(to, from)
    local a = to.y - from.y
    local b = to.x - from.x
    local a1 = half.y - b / 2
    local b1 = half.x + a / 2
    local dur = 15 / 30
    obj:runAction(
            cc.Sequence:create(
                    cc.Spawn:create(
                            cc.BezierTo:create(dur, { from, cc.p(b1, a1), to }),
                            cc.ScaleTo:create(dur, 0.2)
                    ),
                    cc.ScaleTo:create(5 / 30, 0),
                    cc.DelayTime:create(10 / 15),
                    cc.RemoveSelf:create()
            )
    )
end
function cls:addPractice(parentNode, from)
    local p1 = self.ctl:getParticleFile("bonus_tail")
    local p2 = self.ctl:getParticleFile("bonus_lizi_tail")
    local s1 = cc.ParticleSystemQuad:create(p1)
    local s2 = cc.ParticleSystemQuad:create(p2)
    if not from then
        parentNode:addChild(s1, -1)
    end
    parentNode:addChild(s2, -1)
end
function cls:getPickPos(basePos)

    local down = self.ctl:getStartPosY() + 150
    local top = self.ctl:getEndY() - 130
    if basePos.y <= top and basePos.y >= down then
        return basePos
    elseif basePos.y > top then
        return cc.p(basePos.x, top)
    elseif basePos.y < down then
        return cc.p(basePos.x, down)
    end
    return basePos
end
function cls:addMultiPoints(multi)
    local node = cc.Node:create()
    self.parent:addChild(node)
    local basePos = cc.pSub(bole.getPos(self), cc.p(0, 0))
    node:setPosition(self:getPickPos(basePos))
    --local data = {}
    --data.file = self.ctl:getSpineFile("rank_tip_multi")
    --data.parent = node
    --if multi == 2 then
    --    data.animateName = "animation1"
    --else
    --    data.animateName = "animation2"
    --end
    local multiPos = self.ctl:getMultiPos()

    node:setScale(0)
    --local _, s = bole.addAnimationSimple(data)

    local path = self.ctl:getCsbPath("dialog_b_multi")
    local multiDialog = cc.CSLoader:createNode(path)
    local multiRoot = multiDialog:getChildByName("root")
    local node_more = multiRoot:getChildByName("node_more")
    local label1 = node_more:getChildByName("label_node1")
    local multiNode = label1:getChildByName("multi")
    local str = "X" .. multi .. " POINTS"
    multiNode:setString(str)
    node:addChild(multiDialog)
    node:runAction(
            cc.Sequence:create(
                    cc.EaseIn:create(cc.ScaleTo:create(10 / 30, 1.5), 2),
                    cc.DelayTime:create(15 / 30),
                    cc.CallFunc:create(function()
                        self.ctl:playMusicByName("balloon_num")
                        self:addPractice(node, 3)
                        self:_parabolaToAnimation(node, multiPos)
                    end),
                    cc.DelayTime:create(14 / 30),
                    cc.CallFunc:create(function()
                        self:removeFromParent()
                    end
                    )
            )
    )
    self.ctl:addMultiPoints(multi)
end
function cls:addRankPoints(score, pick_pos)

    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(1.5),
                    cc.RemoveSelf:create()
            )
    )
    self.ctl:addRankPoints(score, pick_pos)
end

return cls