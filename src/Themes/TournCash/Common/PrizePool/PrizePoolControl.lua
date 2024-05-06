--- @program src
--- @description: theme2010 collect ctl
--- @author: rwb
---@create: : 2021/02/22 19:00:00
local parentClass = require "Themes/TournCash/Common/ThemeTournCashDelegate"
local cls = class("PrizePoolControl", parentClass)
local view = require "Themes/TournCash/Common/PrizePool/PrizePoolView"

function cls:ctor(mainCtl, commonCtl)
    parentClass.ctor(self, commonCtl)
    self.themeCtl = mainCtl
    self.tcCommonCtl = commonCtl
end
function cls:initLayout(parentNode)
    self.prizePoolView = view.new(self, parentNode)
    self.prizePoolView:initRoot()
end
function cls:updatePrizePool(...)
    if not self.prizePoolView then
        return
    end
    self.prizePoolView:updatePrizePool(...)
end

return cls


