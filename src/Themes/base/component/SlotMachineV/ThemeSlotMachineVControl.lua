---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/01/20 13:20
---
local parentClass = ThemeBaseViewControlDelegate
local slotViewV = require("Themes/base/component/SlotMachineV/ThemeSlotMachineVView")
local slotConfig = require("Themes/base/component/SlotMachineV/ThemeSlotMachineVConfig")

local cls = class("ThemeSlotMachineVControl", parentClass)

function cls:ctor(bonus, _mainViewCtl, data, bonus_key)
    self.themeResourceId = _mainViewCtl:getThemeSmallSlot()
    parentClass.ctor(self, _mainViewCtl)

    self.themeCtl = _mainViewCtl
    self.bonus = bonus
    self.data = data
    self.slotMachineData = self.data.core_data[bonus_key]
    self.avgBet = self.slotMachineData.avg_bet or 10000
    self.machineStatus = self:getSlotMachineStatus()
    self.saveDataKey = bonus_key
    self.tryResume = self.bonus.data[self.saveDataKey] and true or false
    self.gameData = tool.tableClone(self.bonus.data[self.saveDataKey]) or {}
    self.lastItemList = self.data.core_data["item_list"] or self.themeCtl.item_list
end
function cls:getLoadMusicList()
    return slotConfig.audioList
end
function cls:addData(key, value)
    self.gameData[key] = value
    self:saveBonus()
end
function cls:saveBonus()
    self.bonus:addData(self.saveDataKey, self.gameData)
end
function cls:getBaseBet()

    if self.themeCtl.getSmallSlotBaseBet then
        return self.themeCtl:getSmallSlotBaseBet()
    end
    return slotConfig.theme_config.base_bet

end
function cls:dealWithData(tryResume)
    self.themeCtl.rets = self.themeCtl.rets or {}
    self.themeCtl.cacheSpinRet = self.themeCtl.cacheSpinRet or self.themeCtl.rets -- 快停按钮显示相关
    self.themeCtl.rets["theme_respin"] = tool.tableClone(self.slotMachineData["theme_respin"])
    self.slotRespinData = tool.tableClone(self.slotMachineData["theme_respin"])
    self.allSpinCounts = #self.slotRespinData
    self.gameData.machineStatus = self.gameData.machineStatus or self.machineStatus.start
    self.gameData.useSpinCounts = self.gameData.useSpinCounts or 0
    self.resultIndex = self.slotMachineData.result_index or 8
    self.totalWin = self.slotMachineData.base_win or 0
end
function cls:enterBonusGame(tryResume)
    self:setPics()
    self:initLayout()
    self:showSlotMachineScene(tryResume)
end
function cls:initLayout()
    local slotView = slotViewV
    if self.themeResourceId == 2009 then
        --slotView = slotViewH
    end
    self.slotMachineView = slotView.new(self, self.themeCtl:getMapParentNode())
    self.slotMachineView:updatePaytable(self:getPays()) --更新pays
end
-- slot_machine
function cls:getPic(name)
    return string.format("theme_resource/theme%d/%s", self.themeResourceId, name)
end
function cls:getSpineFile(name)
    local spine_file = slotConfig.spine_path[name]
    return string.format("theme_resource/theme%d/%s", self.themeResourceId, spine_file)
end
function cls:playMusicByName(name, singleton, loop)
    local path = slotConfig.audioList[name]
    local audioFile = self:getPic(path)
    AudioControl:playEffect(audioFile, loop, singleton)
end
function cls:stopMusicByName(name, singleton, loop)
    local path = slotConfig.audioList[name]
    local audioFile = self:getPic(path)
    AudioControl:stopEffect(audioFile, loop, singleton)
end
function cls:getPays(...)
    return slotConfig.theme_config.pays
end
function cls:getReelKeys(...)
    return slotConfig.theme_config.reelKey
end
function cls:getSlotMachineStatus(...)

    return slotConfig.machine_status
end
function cls:getLabelInfo(...)
    return slotConfig.dialog_config[3]
end
function cls:changeRootNodeParent(toMain, newParent)
    self.themeCtl:changeRootNodeParent(toMain, newParent)
end
function cls:showSlotMachineScene(tryResume)

    local parent = self.slotMachineView:getReelParent()
    self.themeCtl:changeRootNodeParent(false, parent)
    if self.avgBet then
        self.themeCtl:setPointBet(self.avgBet)
    end
    self:changeSpinLayer()
    if not tryResume then
        self.themeCtl.spinning = false
    end
    self:setBoard()
    self:dealWithData(tryResume)
    self:showSlotMachineStep(self.gameData.machineStatus)
end
function cls:changeSpinLayer()
    self.themeCtl:showSmallSlotUI()
end
function cls:setBoard(item_list)
    local item_list = item_list or {}
    if #item_list == 0 then
        for i = 1, 3 do
            item_list[i] = { math.random(102, 109) }
        end
    end
    if self:getReelKeys() then
        self.themeCtl:resetBoardCellsByCreateList(self:getReelKeys())
    end
    self.themeCtl:resetBoardCellsByItemList(item_list)
end
function cls:handleResult()
    self:laterCallBack(1, function(...)
        self.themeCtl:handleResult()
    end)
end
function cls:showSlotMachineStep(step)
    if step == self.machineStatus.start then
        self:showSlotMachineStart()
    elseif step == self.machineStatus.collect then
        self:recoverLastBoard()
        self:showSlotMachineCollect()
    else
        self:themeReSpin()
    end
end
function cls:themeReSpin(...)
    local item_list = nil
    if self.gameData.useSpinCounts > 0 and self.gameData.useSpinCounts <= self.allSpinCounts then
        self.themeCtl.rets["theme_respin"] = tool.tableClone(self.slotMachineData["theme_respin"])
        local removeCount = self.gameData.useSpinCounts
        for i = 1, removeCount do
            table.remove(self.themeCtl.rets["theme_respin"], 1)
        end
        item_list = self.slotRespinData[self.gameData.useSpinCounts]
        self:recoverLastBoard(item_list)
    end
    if self.gameData.useSpinCounts < self.allSpinCounts then
        self:handleResult()
    else
        self.themeCtl.rets["theme_respin"] = nil
        self:showSlotMachineCollect()
    end
end
function cls:recoverLastBoard(item_list)
    item_list = item_list or self.slotRespinData[#self.slotRespinData]
    self.themeCtl:resetBoardCellsByItemList(item_list)
end
function cls:showSlotMachineStart()
    self.slotMachineView:showSMStartDialog()
end
function cls:showSlotMachineCollect(...)
    self:changeMachineState(self.machineStatus.collect)
    self.slotMachineView:showSMColletDialog()
end
function cls:changeMachineState(state)
    if self.gameData.machineStatus ~= state then
        self.gameData.machineStatus = state
        self:saveBonus()
    end
end
function cls:onRespinStart(...)
    self.gameData.useSpinCounts = self.gameData.useSpinCounts + 1
    self:saveBonus()
    self:stopMusicByName("slot_spin")
    self:playMusicByName("slot_spin", true)
end
function cls:onMapRepsinAllReelStop()
    self:stopMusicByName("slot_spin")
end

function cls:drawWinLineSymbols(...)
    self.slotMachineView:drawWinLineSymbols()
end
function cls:onRespinFinish()
    local animationTime = 4.5
    self.node:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self:drawWinLineSymbols()
            end),
            cc.DelayTime:create(animationTime),
            cc.CallFunc:create(function()
                self:showSlotMachineCollect()
            end)
    ))
end
function cls:setPics(...)
    self.pics = table.copy(self.themeCtl.pics)
end
function cls:setFooterBtnsEnable(enable)
    self.themeCtl:setFooterBtnsEnable(enable)
end
function cls:collectNotice(...)
    self.bonus.themeCtl:collectCoins(1)
    self.bonus.data["end_game"] = true
    self.bonus:saveBonus()
end
-- 
function cls:exitSlotMachineScene(...)
    local trans = self:getGameConfig().transition_config["map"]
    self.themeCtl:playTransition(nil, "map")
    local a1 = cc.DelayTime:create(trans.onCover)
    local a2 = cc.CallFunc:create(function(...)
        self:recoverNormalBoard()
        self:onExit()
        self.slotMachineView = nil
    end)
    local a3 = cc.DelayTime:create(trans.onEnd - trans.onCover)
    local a4 = cc.CallFunc:create(function(...)

        self.bonus:overSlotMachineScene(self.totalWin)
    end)
    local a5 = cc.Sequence:create(a1, a2, a3, a4)
    self.node:runAction(a5)
end
function cls:recoverNormalBoard(...)
    self.bonus:recoverBaseGame(self.saveDataKey)
    self.themeCtl:changeRootNodeParent(true, false)
end
function cls:onExit(...)
    if self.slotMachineView then
        self.slotMachineView:onExit()
    end
    self.slotMachineView = nil
end
return cls

