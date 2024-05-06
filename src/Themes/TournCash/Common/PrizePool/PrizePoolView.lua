---
--- @program src 
--- @description:  
--- @author: rwb 
---@create: : 2021/02/22 19:00:00
local cls = class("PrizePoolView")
function cls:ctor(ctl, parent, flyNode)
    self.ctl = ctl
    self.node = parent
end
function cls:initRoot()
    self.prizePoolLabel = self.node:getChildByName("label_jp1")
    inherit(self.prizePoolLabel, LabelNumRoll)
    local function parseValue(num)
        return FONTS.formatByCount4(num, 17, true, true)
    end
    self.prizePoolLabel:nrInit(0, 24, parseValue)
    local middleNode = self.node:getChildByName("bg_loop")
    local data = {}
    data.file = self.ctl:getSpineFile("prize_pool")
    data.parent = middleNode
    data.isLoop = true
    bole.addAnimationSimple(data)
end
function cls:updatePrizePool(endValue, startValue, isAnimate)
    startValue = startValue or self.newPrizeValue or 0
    endValue = endValue or 0
    if isAnimate then
        if self.prizePoolLabel.nrStopRoll then
            self.prizePoolLabel:nrStopRoll()
        end
        self.prizePoolLabel:nrStartRoll(startValue, endValue, 6)
    else
        self.prizePoolLabel:setString(self.prizePoolLabel.nrParserFunc(endValue))
    end
    self.newPrizeValue = endValue
end
return cls





