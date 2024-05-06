---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/02/24 11:10
---

local cls = class("TCRankHeadItem")

function cls:ctor(ctl, node, isSelf)

    self.ctl = ctl
    self.node = node
    self.isSelf = isSelf
    self.teamID = 0
    self:init()
end
function cls:init()
    self.frame = self.node:getChildByName("frame")
    self.headNode = self.node:getChildByName("head")
    self.headBg = self.node:getChildByName("bg")
    self.flagNode = self.node:getChildByName("flag_node")
    self.flagBg = self.flagNode:getChildByName("bg")
    self.spineNode = self.node:getChildByName("spine_node")
end
function cls:setFrameStyle(color)
    local head_frame = self.ctl:getRankConfig().head_frame
    local show_frame = head_frame[color]
    bole.updateSpriteWithFile(self.frame, show_frame)
end
function cls:getFrameColor(rankInfo)
    local teamType = self.ctl:getTeamTypeByInfo(rankInfo)
    local color = "blue"
    if teamType and teamType > 0 then
        if teamType == self.ctl:getTeamType().BLUE then
            color = "blue"
        else
            color = "red"
        end
    elseif rankInfo.rank == 0 then
        color = "purple"
    else
        color = "blue"
    end
    return color

end
function cls:setHeadStyle(rankInfo)
    local isSelf = self.ctl:checkIsSelf(rankInfo)
    local teamType = self.ctl:getTeamTypeByInfo(rankInfo)
    self.isSelf = isSelf
    self.teamID = teamType
    local color = self:getFrameColor(rankInfo)
    if self.showColor and self.showColor == color then
        return
    end
    self.showColor = color
    self:setFrameStyle(color)
    if self.flagCell and bole.isValidNode(self.flagCell) then
        self.flagCell:updateNodeColor(color)
    end
end
function cls:updateHeadFrame(rankInfo)
    self:setHeadStyle(rankInfo)
end
function cls:updateIcon(rankInfo, isSelf)
    local data = {}
    data.facebook_id = rankInfo.facebook_id == "bolegames" and "" or rankInfo.facebook_id
    data.user_icon_id = rankInfo.icon_id
    data.head_size = 180
    data.head_id = rankInfo.head_id
    data.stencil_sp = self.headBg
    libUI.updateCommonHead(self.headNode, data)
    if rankInfo.geo_code then
        local class = TournCashController:getInstance():getDialogClass("TournCashNationalFlagNode")
        self.flagCell = class.new()
        self.flagNode:addChild(self.flagCell)
        self.flagCell:updateNode(self:getFrameColor(rankInfo), rankInfo.geo_code)
    else
        self.flagNode:setVisible(false)
    end
end
function cls:addLoopAni()
    local data = {}
    data.file = self.ctl:getSpineFile("rank_frame")
    data.parent = self.spineNode
    data.isLoop = true
    data.animateName = "animation1"
    local _, s = bole.addAnimationSimple(data)
    --s:setScale(0.55)
end
return cls