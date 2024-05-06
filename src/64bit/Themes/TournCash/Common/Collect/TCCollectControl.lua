--- @program src
--- @description: theme2010 collect ctl
--- @author: rwb
---@create: : 2021/02/22 19:00:00


local parentClass = require "Themes/TournCash/Common/ThemeTournCashDelegate"
local cls = class("TCCollectControl", parentClass)
local view = require "Themes/TournCash/Common/Collect/TCCollectView"
function cls:ctor(mainCtl, tcCommonCtl)
    parentClass.ctor(self, tcCommonCtl)
    self.themeCtl = mainCtl
    self.tcCommonCtl = tcCommonCtl
end
function cls:initLayout(parentNode, flyNode)

    self.collectView = view.new(self, parentNode, flyNode)
    self.collectView:initCollectRoot()
end
function cls:getCollectNodeWorldPos()
    return self.collectView:getCollectNodeWorldPos()
end
function cls:getCommonConfig()
    return self.tcCommonCtl:getCommonConfig()
end
function cls:getCollectConfig()
    return self:getCommonConfig().collect_config
end
function cls:getCollectMaxPoint()
    return self:getCollectConfig().max_point
end
function cls:getCollectMaxLevel()
    return self:getCollectConfig().max_level
end
function cls:updateCollectCount(newCount, beforeCount, isAnimate)
    self.collectView:updateCollectCount(newCount, beforeCount, isAnimate)
end
function cls:setMapInfo(mapinfo)
    self.mapInfo = mapinfo
    self:setMapPoints(self.mapInfo.map_points)
end
function cls:getMapPoints()
    return self.featurePoints or 0
end
function cls:setMapPoints(map_point)
    self.featurePoints = map_point
end
function cls:addMapPoints(add_count)
    self:setMapPoints(self:getMapPoints() + add_count)
end
function cls:dealFlyCollectItem(_flyClawList, addCount)
    if self.isLockFeature then
        return
    end
    local old_map_point = self:getMapPoints()
    if #_flyClawList <= 0 then
        return
    end
    --local addCount = #_flyClawList * self:getUnitCount()
    self:addMapPoints(addCount)
    --self:setMapPoints(newCount)
    local new_map_point = self:getMapPoints()
    self:playMusicByName("collect_fly")
    self.collectView:flyItemActions(_flyClawList)
    self:laterCallBack(self.collectView:getFlyTime(), function()
        self:updateCollectCount(new_map_point, old_map_point, true)

    end
    )
end
function cls:getFlyItemList(cItemList)
    local _flyClawList = {}
    local collectID = self:getCollectConfig().collect_id
    for col = 1, #cItemList do
        for row = 1, #cItemList[col] do
            local storeCoinCount = cItemList[col][row]
            if storeCoinCount % 100 == collectID then
                local pos = self:getCellPos(col, row)
                table.insert(_flyClawList, { col, row, pos })
            end
        end
    end
    return _flyClawList
end

return cls


