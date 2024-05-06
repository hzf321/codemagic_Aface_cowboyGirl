--- @program src
--- @description: theme2010 collect ctl
--- @author: rwb
---@create: : 2021/02/22 19:00:00


local parentClass = require "Themes/TournCash/Common/ThemeTournCashDelegate"
local cls = class("TCStageControl", parentClass)
local view = require "Themes/TournCash/Common/Stage/TCStageView"

function cls:ctor(mainCtl, commonCtl)
    parentClass.ctor(self, commonCtl)
    self.themeCtl = mainCtl
    self.tcCommonCtl = commonCtl
end
function cls:initLayout(parentNode, flyNode)

    self.stageView = view.new(self, parentNode)
    self.stageView:initRoot()
end
function cls:setStartRound(...)
    self.stageView:setStartRound(...)
end
function cls:updateStageNode(...)
    self.stageView:updateStageNode(...)
end
function cls:resetStageTime(...)
    self.stageView:resetStageTime(...)
end
function cls:stageNumChange(...)
    self.stageView:stageNumChange(...)
end
function cls:getStageTime()
    return self.themeCtl:getStageTime()
end
function cls:configCountDownLabel(...)
    self.stageView:configCountDownLabel(...)
end
function cls:getRoundLeftTime()
    return self.themeCtl:getRoundLeftTime()
end
function cls:last10Second()
    self.themeCtl:last10Second()
end
function cls:finishRoundSpin()
    self.themeCtl:finishRoundSpin()
end

return cls


