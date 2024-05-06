---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/02/24 11:11
---

local headItem = require("Themes/TournCash/Common/Rank/TCRankHeadItem")
local cls = class("TCRankTipView", function()
    return cc.Node:create()
end)
function cls:ctor(ctl, rankInfo, isSelf, multi)
    self.ctl = ctl
    self.rankInfo = rankInfo
    self.cellHeight = 75
    self.cellWidth = 369
    self.isSelf = isSelf
    self.multi = multi
    self:initRankTipItem()
    self:show()
end
function cls:initRankTipItem()
    self.csb = self.ctl:getCsbPath("rank_tip")
    self.node = cc.CSLoader:createNode(self.csb)
    self:addChild(self.node)
    self.root = self.node:getChildByName("root")
    self.bgSpine = self.root:getChildByName("bg_spine")
    self.headNode = self.root:getChildByName("rank_head")
    self.multiImg = self.root:getChildByName("multi")
    self.spineNode = self.root:getChildByName("loop_node")
    self.headItem = headItem.new(self.ctl, self.headNode, self.isSelf)
    self.headItem:setHeadStyle(self.rankInfo)
    self.headItem:updateIcon(self.rankInfo, self.isSelf)
    self.labelNode = self.root:getChildByName("label_node")
    self.labelName = self.labelNode:getChildByName("label_name")
    self:_initMultiImg()

    self:setLabelName(libUI.getCommonName(self.rankInfo))
    self:_loopAni()
end
function cls:_initMultiImg()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_tip_multi")
    data.parent = self.spineNode
    data.pos = cc.p(101, 0)
    data.isLoop = true
    data.animateName = "animation" .. self:getSpineIndex(self.multi)
    if data.animateName then
        bole.addAnimationSimple(data)
    end
end
function cls:getSpineIndex(multi)
    if multi == 2 then
        return 1
    end
    if multi == 3 then
        return 2
    end
    if multi == 5 then
        return 3
    end
    if multi == 10 then
        return 4
    end
end
function cls:show()
    bole.scene:addToFooter(self, 1)
    local posY = 0
    if bole.getAdaptationWidthScreen() then
        posY = FRAME_HEIGHT / 2 - 70 - (self.cellHeight / 2)
    else
        posY = (self.cellHeight / 2 + 150)
    end
    local startPos = cc.p(FRAME_WIDTH / 2 + self.cellWidth / 2, posY)
    local endPos = cc.p(FRAME_WIDTH / 2 - self.cellWidth / 2, posY)
    self:setPosition(startPos)
    self:_addAppearAni()
    self:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(0.2, endPos),
                    cc.DelayTime:create(2),
                    cc.MoveTo:create(0.3, startPos),
                    cc.RemoveSelf:create()
            )
    )
end
function cls:_addAppearAni()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_tip_bg")
    data.parent = self.bgSpine
    data.animateName = "animation2"
    bole.addAnimationSimple(data)
end
function cls:_loopAni()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_tip_bg")
    data.parent = self.bgSpine
    data.animateName = "animation1"
    data.isLoop = true
    bole.addAnimationSimple(data)
end
function cls:setLabelName(name)
    self.labelName:setString(bole.getShortName(name, 25))
    bole.shrinkLabel(self.labelName, 140, 1)

end
return cls