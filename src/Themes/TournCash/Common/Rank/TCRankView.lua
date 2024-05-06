---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/02/24 11:06
---

local rankItem = require("Themes/TournCash/Common/Rank/TCRankItem")
local cls = class("TCRankView")
function cls:ctor(ctl, rankNode, flyNode)

    self.rankNode = rankNode
    self.flyNode = flyNode
    self.ctl = ctl
    self:initRankNode()
end
function cls:initRankNode()
    self.rankRoot = self.rankNode:getChildByName("root")
    self.bgImg = self.rankRoot:getChildByName("bg")

    self.bgSpine = self.rankRoot:getChildByName("bg_spine")
    self.topNode = self.rankRoot:getChildByName("top")
    self.currentRank = self.topNode:getChildByName("index")
    self.currentScore = self.topNode:getChildByName("score")
    self.rankPanel = self.rankRoot:getChildByName("panel")
    self.rankPanel:setScrollBarEnabled(false)
    self.rankPanel:setTouchEnabled(false)
    self.stackNode = self.rankRoot:getChildByName("stack_node")
    self.rankPanelCon = self.rankPanel:getChildByName("child")
    self.rankMaskNode = self.rankRoot:getChildByName("mask_node")
    bole.setEnableRecursiveCascading(self.rankMaskNode, true)
    self.rankMaskSpine = self.rankMaskNode:getChildByName("bg_spine")
    self.maskBgImg = self.rankMaskNode:getChildByName("bg")
    self.rankMaskNode:setVisible(false)
    self.secondLabel = self.rankMaskNode:getChildByName("label")
    self:_initRankBgSpine()
    self:addSrcollViewListener()
    self:showRankMaskAndWhy()
    self.rankItemList = {}

end
function cls:_initRankBgSpine()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_bg")
    data.parent = self.bgSpine
    data.isLoop = true
    data.animateName = "animation1"
    data.pos = cc.p(0, 0)
    local _, s = bole.addAnimationSimple(data)
    s:setScale(2)
    local data2 = {}
    data2.file = self.ctl:getSpineFile("rank_mask")
    data2.parent = self.rankMaskSpine
    data2.isLoop = true
    data2.pos = cc.p(0, 0)
    local _, s2 = bole.addAnimationSimple(data2)
end
function cls:scoreReceiveAni()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_bg")
    data.parent = self.topNode
    data.animateName = "animation2"
    data.pos = cc.p(0, -196)
    bole.addAnimationSimple(data)
end
function cls:initRankItemList(info_list)
    local size = self.rankPanel:getInnerContainerSize()
    local newHeight = 0
    local newWidth = size.width
    newHeight = (#info_list) * 120
    self.rankPanel:setInnerContainerSize(cc.size(newWidth, newHeight))
    for key = 1, #info_list do
        local info = info_list[key]
        local index = key
        local rankItem = rankItem.new(self.ctl, self.rankPanelCon, index, info)
        table.insert(self.rankItemList, rankItem)
    end
    self:setRankPosition(self.ctl:getSelfRankIndex())
end

function cls:refreshRankItemList(info_list, status)
    for index = 1, #info_list do
        for rankIndex = 1, #self.rankItemList do
            local rankItem = self.rankItemList[rankIndex]
            if info_list[index].user_id == rankItem:getUserID() then
                if status == "normal" then
                    rankItem:updateRankItem(info_list[index])
                elseif status == "down" then
                    if index < self.ctl:getSelfIndex() and index >= self.ctl:getBeforeSelfIndex() then
                        rankItem:updateRankItem(info_list[index], "up")
                    elseif index == self.ctl:getSelfIndex() then
                        self:resetSelfNode(rankItem, info_list[index])
                    else
                        rankItem:updateRankItem(info_list[index])
                    end
                elseif status == "up" then
                    if index > self.ctl:getSelfIndex() and index <= self.ctl:getBeforeSelfIndex() then
                        rankItem:updateRankItem(info_list[index], "down")
                    elseif index == self.ctl:getSelfIndex() then
                        self:resetSelfNode(rankItem, info_list[index])
                    else
                        rankItem:updateRankItem(info_list[index])
                    end
                end

            end
        end
    end
    if status == "normal" then
        self:setRankPosition(self.ctl:getSelfRankIndex())
    end
end
function cls:getContainerPosY(selfRankIndex)
    local step_index
    if selfRankIndex == 0 then
        step_index = 1
    elseif selfRankIndex == 27 then
        step_index = 26
    else
        step_index = selfRankIndex
    end
    local containY = self.rankPanel:getContentSize().height
    local innerContainY = self.rankPanel:getInnerContainerSize().height
    local sizeY = containY - innerContainY
    local stepPos = self.ctl:getRankItemPosByRank(step_index).y
    local offset = containY / 2 - stepPos
    if offset < sizeY then
        offset = sizeY
    end
    return offset
end
function cls:setRankPosition(rankIndex, beforeIndex, isAni)

    rankIndex = rankIndex or 0
    local posy = self:getContainerPosY(rankIndex)
    local container_node = self.rankPanel:getInnerContainer()
    local posx = container_node:getPositionX()
    local runTag = 1001
    self.rankPanel:stopAutoScroll()
    container_node:stopActionByTag(runTag)
    if isAni then
        if beforeIndex then
            local beforey = self:getContainerPosY(beforeIndex)
            container_node:setPosition(cc.p(posx, beforey))
        end
        self:setPanelTouch(false)
        local action = cc.Sequence:create(
                cc.DelayTime:create(0.2),
                cc.MoveTo:create(0.6, cc.p(posx, posy))
        )
        action:setTag(runTag)
        container_node:runAction(action)
    else
        container_node:setPosition(cc.p(posx, posy))
        self:setPanelTouch(false)
    end
end
function cls:resetSelfNode(rankItem, rankInfo)
    local beforeIndex = self.ctl:getBeforeSelfRankIndex()
    local nextIndex = self.ctl:getSelfRankIndex()

    self.rankPanel:setTouchEnabled(false)
    rankItem:stopAllActions()
    if not rankItem.now_parent or rankItem.now_parent == 2 then
        bole.changeParent(rankItem, self.stackNode, 1)
        rankItem.now_parent = 1
    end
    self:setRankPosition(nextIndex, beforeIndex, true)
    rankItem:rankChangeAni()
    local pos = self:getPosByIndexInStickNode(beforeIndex)
    rankItem:setPosition(pos)
    local now_pos = self:getPosByIndexInStickNode(nextIndex)
    local aniList = {}
    table.insert(aniList, cc.ScaleTo:create(0.2, 1.2))
    if nextIndex == 0 or nextIndex == 27 then
        local a2 = cc.MoveTo:create(0.6, now_pos)
        table.insert(aniList, a2)
    elseif beforeIndex == 27 or beforeIndex == 0 then
        local a2 = cc.MoveTo:create(0.6, cc.p(0, 0))
        table.insert(aniList, a2)
    else
        local a2 = cc.DelayTime:create(0.6)
        table.insert(aniList, a2)
    end
    table.insert(aniList, cc.ScaleTo:create(0.2, 1))
    rankItem:runAction(cc.Sequence:create(unpack(aniList)))
    rankItem:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                rankItem:updateRankInfo(rankInfo)
            end),
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                self.rankPanel:setTouchEnabled(true)
                if rankItem.now_parent and rankItem.now_parent == 1 then
                    bole.changeParent(rankItem, self.rankPanelCon, 1)
                    rankItem.now_parent = 2
                    local pos = self.ctl:getRankItemPosByRank(nextIndex)
                    rankItem:setPosition(pos)
                end
            end)
    ))

end
function cls:getPosByIndexInStickNode(index)
    local pos
    if index == 0 then
        pos = cc.p(0, self.ctl:getCellHeight())
    elseif index == 27 then
        pos = cc.p(0, -self.ctl:getCellHeight())
    else
        pos = cc.p(0, 0)
    end
    return pos
end
function cls:updateRankScoreInfo(info, notAni)
    self:setRankScore(info.score)
    self:setCurrentRank(info.rank + 1)
end
function cls:setRankScore(score)
    if self.showScore and self.showScore < score then
        self:scoreReceiveAni()
    end
    local str = FONTS.formatByCount4(score, 8, true, true)
    self.currentScore:setString(str)
    self.showScore = score
end
function cls:refreshOnlyScoreByList(info_list)
    for key = 1, #info_list do
        local info = info_list[key]
        local index = key
        local isSelf = self.ctl:checkIsSelf(info)
        if isSelf then
            self:refreshOnlyScoreByInfo(info)
            break
        end
    end
end
function cls:refreshOnlyScoreByInfo(info)
    --self:setCurrentRank("?")
    self:setRankScore(info.score)
end

function cls:getScoreNodeWorldPos()
    local wEndPos = self.currentScore:convertToWorldSpace(cc.p(0, 0))
    return wEndPos
end
function cls:setCurrentRank(rank)
    self.currentRank:setString(rank)
end
function cls:updateSecondLabel(sec)
    self.secondLabel:setString(sec)
    if sec and type(sec) == "string" then
        self.secondLabel:setScale(1)
    end
end
-------------------- set mask node start----------------
function cls:triggerShowRankMask()
    self.showMaskStatus = true
    self.rankMaskNode:setVisible(true)
    self.rankMaskNode:setOpacity(0)
    self.rankMaskNode:stopAllActions()
    self.rankMaskNode:runAction(cc.FadeIn:create(0.2))
    self.rankPanel:setTouchEnabled(false)
end
function cls:triggerHideRankMask()
    self.showMaskStatus = false
    self.rankMaskNode:setVisible(true)
    self.rankMaskNode:setOpacity(255)
    self.rankMaskNode:stopAllActions()
    self.rankMaskNode:runAction(
            cc.Sequence:create(
                    cc.FadeOut:create(0.2),
                    cc.Hide:create()
            )
    )
    self.rankPanel:setTouchEnabled(true)
end
function cls:showRankMaskLabelNum(sec)
    self.rankStatus = 1
    self.secondLabel:setScale(0)
    local aniList = {}
    local a2 = cc.ScaleTo:create(10 / 30, 1)
    local a3 = cc.DelayTime:create(10 / 30)
    local a4 = cc.ScaleTo:create(10 / 30, 0)
    table.insert(aniList, a2)
    table.insert(aniList, a3)
    table.insert(aniList, a4)
    self:updateSecondLabel(sec)
    self.secondLabel:stopAllActions()
    self.secondLabel:runAction(cc.Sequence:create(unpack(aniList)))
end
function cls:showRankMaskLabelLoop()
    self.rankStatus = 2
    self:setCurrentRank("?")
    self.secondLabel:stopAllActions()
    self:updateSecondLabel("?")
    local a1 = cc.ScaleTo:create(0.4, 1.1)
    local a2 = cc.ScaleTo:create(0.4, 1)
    self.secondLabel:runAction(cc.RepeatForever:create(cc.Sequence:create(a1, a2)))
end
function cls:showRankMaskAndNumber()
    if not self.showMaskStatus then
        self:triggerShowRankMask()
    end
    local sec = self.ctl:getRoundLeftTime()
    if sec <= 0 or sec > 10 then
        self:showRankMaskLabelLoop()
    else
        self:showRankMaskLabelNum(sec)
    end
end
function cls:showRankMaskAndWhy()
    self:showRankMaskLabelLoop()
    if not self.showMaskStatus then
        self:triggerShowRankMask()
    end
    self:setCurrentRank("?")
end
function cls:hideRankMask()
    if self.showMaskStatus then
        self:triggerHideRankMask()
    end
end
-------------------- set mask node start----------------
function cls:showRankDialog(rankIndex, status, beforeIndex)
    local data = {}
    data.parent = self.flyNode
    data.pos = cc.p(640, 360)
    data.file = self.ctl:getSpineFile("rank_change")
    data.zOrder = 100
    local music_id
    if status == "up" then
        if rankIndex == 1 then
            music_id = "ranktop1"
            data.animateName = "animation1"
        elseif beforeIndex and beforeIndex > 10 and rankIndex <= 10 then
            music_id = "ranktop10"
            data.animateName = "animation2"
        else
            music_id = "rankup"
            data.animateName = "animation3"
        end
    end
    if music_id then
        self.ctl:playMusicByName(music_id)
    end
    if data.animateName then
        bole.addAnimationSimple(data)
    end
end
function cls:clearRankList()
    self.rankItemList = {}
end
function cls:addSrcollViewListener()
    local scrollViewDidScroll = function(target, event)
        if event == ccui.TouchEventType.ended then
            self:setPanelTouch(true)
            self:beginCaluteNoTouchRankTm()
        end
        if event == ccui.TouchEventType.canceled then
            self:setPanelTouch(true)
            self:beginCaluteNoTouchRankTm()
        end
        if event == ccui.TouchEventType.moved then
            self:setPanelTouch(true)
            self:beginCaluteNoTouchRankTm()
        end
    end
    self.rankPanel:addEventListener(scrollViewDidScroll)
end
function cls:beginCaluteNoTouchRankTm()
    self.rankNode:stopAllActions()
    self.rankNode:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(3),
                    cc.CallFunc:create(function()
                        if self:getPanelTouch() then
                            self.ctl:setRankPosition(true)
                        end
                    end)
            )
    )
    --end
end
function cls:setPanelTouch(status)
    self.rankPanelTouched = status
end

function cls:getPanelTouch()
    return self.rankPanelTouched
end
return cls


