---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/02/24 11:11
---
local headItem = require("Themes/TournCash/Common/Rank/TCRankHeadItem")

local cls = class("TCRankItem", function()
    return cc.Node:create()
end)
function cls:ctor(ctl, parent, index, rankInfo)
    self.ctl = ctl
    self.parent = parent
    local path = self.ctl:getCsbPath("rank_item")
    self.node = cc.CSLoader:createNode(path)
    self:addChild(self.node)
    self.parent:addChild(self)
    self.rankInfo = rankInfo
    self:updateIndex(index)
    self:initUI()
end
function cls:updateIndex(index, isAni)
    local before = self.index

    if index ~= before then
        self.index = index
        if not before then
            before = index
        end
        self:updatePosition(index - 1, before - 1, isAni)
    end
end
function cls:updatePosition(now_rank, before_rank, isAni)
    local endPos = self.ctl:getRankItemPosByRank(now_rank)
    self:stopActionByTag(1002)
    if self.now_parent and self.now_parent == 1 then
        self:stopAllActions()
        bole.changeParent(self, self.parent, 1)
        self:setScale(1)
        self.now_parent = 2
    end
    if isAni then
        if before_rank then
            local startPos = self.ctl:getRankItemPosByRank(before_rank)
            self:setPosition(startPos)
        end
        local action = cc.Sequence:create(
                cc.DelayTime:create(0.2),
                cc.MoveTo:create(0.6, endPos)
        )
        action:setTag(1002)
        self:runAction(action)
    else
        self:setPosition(endPos)
    end
end
function cls:initUI()
    self.headNode = self.node:getChildByName("head_node")
    self.isSelf = self.ctl:checkIsSelf(self.rankInfo)
    local teamType = self.ctl:getTeamTypeByInfo(self.rankInfo)
    self.headItem = headItem.new(self.ctl, self.headNode, self.isSelf)

    self.rankNode = self.node:getChildByName("rank_node")
    bole.setEnableRecursiveCascading(self.rankNode, true)
    self.rankLabel = self.rankNode:getChildByName("rank_label")
    self.rankImg = self.rankNode:getChildByName("rank_img")
    self.scoreNode = self.node:getChildByName("score_node")
    self.scoreBg = self.scoreNode:getChildByName("bg")
    self.scoreLabel = self.scoreNode:getChildByName("score_label")
    self.headItem:updateIcon(self.rankInfo, self.isSelf)
    self.spineNode = self.node:getChildByName("spine_node")

    self:updateRankIndex(self.rankInfo.rank)
    self:updateScoreLabel(self.rankInfo.score)
    self.headItem:setHeadStyle(self.rankInfo)
    self:updateScoreBg(self.isSelf)
    if self.isSelf then
        self.headItem:addLoopAni()
    end
end
function cls:showReveiveAni()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_frame")
    data.parent = self.spineNode
    data.animateName = "animation2"
    local _, s = bole.addAnimationSimple(data)
    s:setScale(0.55)
end
function cls:updateRankItem(rankInfo, status)
    self:updateRankInfo(rankInfo)
    if status == "up" then
        self:updatePosition(self.rankInfo.rank, self.rankInfo.rank + 1, true)
    elseif status == "down" then
        self:updatePosition(self.rankInfo.rank, self.rankInfo.rank - 1, true)
    else
        self:updatePosition(self.rankInfo.rank)
    end

end
function cls:updateRankInfo(rankInfo)
    self.beforeInfo = self.rankInfo
    self.rankInfo = rankInfo
    self:updateScoreLabel(self.rankInfo.score)
    self:updateRankIndex(self.rankInfo.rank)
    self:updateHeadFrame(rankInfo)
end
function cls:updateRankItemInRound3(rankInfo)
    self.beforeInfo = self.rankInfo
    self.rankInfo = rankInfo
    if self.isSelf then
        self:updateScoreLabel(self.rankInfo.score)
    else
        self:updateScoreLabel("...")
    end
    self:updateRankIndex("?")
end
function cls:updateScoreBg(isSelf)
    --local score_bg_config = self.ctl:getRankConfig().score_bg
    --local img
    ----if isSelf then
    ----    img = score_bg_config[1]
    ----else
    --img = score_bg_config[2]
    ----end
    --bole.updateSpriteWithFile(self.scoreBg, img)
end
function cls:updateHeadFrame(rankInfo)
    self.headItem:updateHeadFrame(rankInfo)
end
function cls:updateScoreLabel(score)
    local str = score
    if type(score) == "number" then
        str = FONTS.formatByCount4(score, 8, true, true)
    end
    self.scoreLabel:setString(str)
end
function cls:updateRankIndex(rank)
    if type(rank) == "number" then
        local index = rank + 1
        if index == 1 then
            self.rankImg:setVisible(true)
            self.rankLabel:setVisible(false)
        else
            self.rankImg:setVisible(false)
            self.rankLabel:setVisible(true)
            self.rankLabel:setString(index)
            bole.shrinkLabel(self.rankLabel, 50, 1)
        end
    else
        self.rankImg:setVisible(false)
        self.rankLabel:setVisible(true)
        self.rankLabel:setString(rank)
    end

end
function cls:changePos(now, before)
end
function cls:rankChangeAni()
    self.rankNode:stopAllActions()
    local a1 = cc.FadeOut:create(0.2)

    local a2 = cc.DelayTime:create(0.3)
    local a3 = cc.FadeIn:create(0.2)
    local a4 = cc.CallFunc:create(function()
        self:showReveiveAni()
    end)
    self.rankNode:runAction(cc.Sequence:create(a1, a2, a4, a3))
end
function cls:getPos()
    return bole.getPos(self)
end
function cls:getUserID()
    return self.rankInfo.user_id
end
return cls

