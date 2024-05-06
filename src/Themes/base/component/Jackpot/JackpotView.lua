---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/03/15 14:55
---
local jackpotItemTip = require("Themes/base/component/Jackpot/JackpotItemTip")
local jackpotItem = require("Themes/base/component/Jackpot/JackpotItem")
local cls = class("ThemeJackpotView")
function cls:ctor(jpCtl, jpRoot, jpTipRoot)
    self.ctl = jpCtl
    self.gameConfig = self.ctl:getGameConfig()
    self.node = jpRoot
    self.parentTip = jpTipRoot
    self.hasJackpotNode = false
    self:initLayout()
    self:initJackpotItems()
    self:initJackpotTips()
end
function cls:initLayout()
    self.jackpotSpine = self.node:getChildByName("bg_spine")
end
function cls:initJackpotItems()
    local jackpot_config = self.ctl:getGameConfig().jackpot_config
    self.jackpotItemList = {}
    for i = 1, jackpot_config.count do
        local node = self.node:getChildByName("node_" .. i)
        local label = self.node:getChildByName("label_jp" .. i)
        local jackpotItemNode = jackpotItem.new(self.ctl, node, i, label)
        self.jackpotItemList[i] = jackpotItemNode
    end
end
function cls:initJackpotTips()
    local jackpot_config = self.ctl:getGameConfig().jackpot_config
    self.jackpotTipList = {}
    for i = 1, jackpot_config.count do
        self.jackpotTipList[i] = {}
        local tipNode = jackpotItemTip.new(self.ctl, i, self.parentTip)
        self.jackpotTipList[i] = tipNode
    end
end
function cls:getJackpotLabel(index)
    return self.jackpotItemList[index].jackpotLabel
end
function cls:getJackpotLabels()
    if not self.jackpotLabels then
        self.jackpotLabels = self.jackpotLabels or {}
        for key = 1, #self.jackpotItemList do
            self.jackpotLabels[key] = self:getJackpotLabel(key)
        end
    end
    return self.jackpotLabels
end

function cls:setJackpotPartState(index, isLock)
    local jackpotItem = self.jackpotItemList[index]
    jackpotItem:setBtnTouchEnable(isLock)

    if isLock then
        jackpotItem:playLockSpine(self.parentTip)
    else
        jackpotItem:playUnLockSpine(self.parentTip)
    end
end
function cls:showJpTipNode(index, status)
    local showNode = self.jackpotTipList[index]
    if self.showjpTipCacheNode then
        self.showjpTipCacheNode:hideTipNode()
    end
    showNode:showJpTipNode(status)
    self.showjpTipCacheNode = showNode
end
----------------------- jackpot win ani start -----------------------
function cls:addWinJpAni(jpIndex)
    self.jackpotItemList[jpIndex]:addWinJpAni()
end
function cls:removeJpAni(jpIndex)
    self.jackpotItemList[jpIndex]:removeJpAni()
end
----------------------- jackpot win ani end -----------------------

local viewCenter = {}
viewCenter.view = cls
viewCenter.jackpotItem = jackpotItem
viewCenter.jackpotItemTip = jackpotItemTip

return viewCenter
