--- @program src
--- @description: theme2010 collect ctl
--- @author: rwb
---@create: : 2021/02/22 19:00:00

local parentClass = require "Themes/TournCash/Common/ThemeTournCashDelegate"
local cls = class("MultiControl", parentClass)
local view = require "Themes/TournCash/Common/Multi/MultiView"

function cls:ctor(mainCtl, commonCtl)
    parentClass.ctor(self, commonCtl)
    self.themeCtl = mainCtl
    self.tcCommonCtl = commonCtl
end
function cls:initLayout(parentNode)
    self.multiTipView = view.new(self, parentNode)
    self.multiTipView:initRoot()
end
function cls:getCommonConfig()
    return self.tcCommonCtl:getCommonConfig()
end

function cls:hideMultiTipNode(...)
    self.multiTipView:hideMultiTipNode(...)
end
function cls:setMultiSpinLeftCount(...)
    self.multiTipView:setMultiSpinLeftCount(...)
end
function cls:showMultiSpinLeftCount(...)
    self.multiTipView:showMultiSpinLeftCount(...)
end
function cls:getMultiNodeWorldPos(...)
    return self.multiTipView:getMultiNodeWorldPos(...)
end
function cls:clearMultiStatus()

    if self:getLeftMultiSpins() > 0 then
        self:setLeftMultiSpins(0)
        self:setPointsMulti(1)
        self:setIsMultiSpin(false)
        self:hideMultiTipNode()
    end
end
function cls:getLeftMultiSpins()
    return self.leftMultiSpins or 0
end
function cls:setLeftMultiSpins(count)
    self.leftMultiSpins = count
end
function cls:getPointsMulti()
    return self.pointMulti or 1
end
function cls:setPointsMulti(multi)
    self.pointMulti = multi
end
function cls:checkIsMultiSpin()
    return self.multiStatus or false
end
function cls:setIsMultiSpin(status)
    self.multiStatus = status
end
function cls:subMultiPoint()
    if self:checkIsMultiSpin() then
        self:setLeftMultiSpins(self:getLeftMultiSpins() - 1)
        local count = self:getLeftMultiSpins()
        local multi = self:getPointsMulti()
        if count < 0 then
            self:setIsMultiSpin(false)
        end
        self:setMultiSpinLeftCount(count, multi)
    end
end
function cls:playMultiPointsByBalloon(spinCount, multi)
    self:setLeftMultiSpins(spinCount)
    self:setIsMultiSpin(true)
    self:setPointsMulti(multi)
    self:showMultiSpinLeftCount(true)
end
function cls:showMultiSpinLeftCount(isAnimate)
    local spins = self:getLeftMultiSpins()
    local multi = self:getPointsMulti()
    if spins > 0 then
        self.multiTipView:showMultiSpinLeftCount(spins, multi, isAnimate)
    end
end
function cls:playMultiPointsDialog(spinCount, multi, from)
    local dialogStep = self.tcCommonCtl:getDialogStep()
    local dialogType = self.tcCommonCtl:getDialogType()
    local data = {}
    data.spins = spinCount .. " SPINS"
    data.label_multi = "X" .. multi .. " POINTS"
    data.music_mini = 1
    data.mask_id = 3
    self:playMusicByName("dialog_double")
    self:playMusicByName("dialog_double" .. multi)
    data.click_event = function()
        self:showMultiSpinLeftCount(true)
    end
    local dialog = self.tcCommonCtl:showThemeDialog(data, dialogStep.more, dialogType.multi)
    dialog:runAction(cc.Sequence:create(
            cc.DelayTime:create(50 / 30),
            cc.ScaleTo:create(0.5, 0)
    ))
    if from and from == "pick" then
        self:setLeftMultiSpins(spinCount)
    else
        self:setLeftMultiSpins(spinCount - 1)
    end
    self:setPointsMulti(multi)
    if spinCount > 0 then
        self:setIsMultiSpin(true)
    else
        self:setIsMultiSpin(false)
    end
end

return cls


