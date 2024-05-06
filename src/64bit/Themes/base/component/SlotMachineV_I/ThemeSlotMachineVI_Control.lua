--[[
Author: xiongmeng
Date: 2021-03-25 18:34:31
LastEditors: xiongmeng
LastEditTime: 2021-04-22 20:12:28
Description: 
--]]
local parentClass = ThemeBaseViewControlDelegate
local slotView = require("Themes/base/component/SlotMachineV_I/ThemeSlotMachineVI_View")
local slotConfig = require("Themes/base/component/SlotMachineV_I/ThemeSlotMachineVI_Config")
local ThemeBaseDialog = require("Themes/base/ThemeBaseDialog")
local cls = class("ThemeSlotMachineVI_Control", parentClass)

function cls:ctor(bonus, _mainViewCtl, data, bonus_key)
    self.themeResourceId = _mainViewCtl:getThemeSmallSlot()
    parentClass.ctor(self, _mainViewCtl)
    self._mainViewCtl = _mainViewCtl
    self.bonus = bonus
    self.data = data
    self.slotMachineData = self.data.core_data[bonus_key]
    self.avgBet = self.slotMachineData.avg_bet or 10000
    self.machineStatus = self:getSlotMachineStatus()
    self.saveDataKey = bonus_key
    self.tryResume = self.bonus.data[self.saveDataKey] and true or false
    self.gameData = tool.tableClone(self.bonus.data[self.saveDataKey]) or {}
    self.lastItemList = self.data.core_data["item_list"] or self._mainViewCtl.item_list
    self.curScene = self._mainViewCtl.curScene
    self.theme = self
end
function cls:getLoadMusicList()
    return slotConfig.audioList
end
function cls:getPopupCsb()
    return slotConfig.csb_list.dialog
end
function cls:getPopupDialog()
    return slotConfig.dialog_config
end
function cls:addData(key, value)
    self.gameData[key] = value
    self:saveBonus()
end
function cls:saveBonus()
    self.bonus:addData(self.saveDataKey, self.gameData)
end
function cls:getBaseBet()

    if self._mainViewCtl.getSmallSlotBaseBet then
        return self._mainViewCtl:getSmallSlotBaseBet()
    end
    return slotConfig.theme_config.base_bet

end
function cls:dealWithData(tryResume)
    self._mainViewCtl.rets = self._mainViewCtl.rets or {}
    self._mainViewCtl.cacheSpinRet = self._mainViewCtl.cacheSpinRet or self._mainViewCtl.rets -- 快停按钮显示相关
    self._mainViewCtl.rets["theme_respin"] = tool.tableClone(self.slotMachineData["theme_respin"])
    self.slotRespinData = tool.tableClone(self.slotMachineData["theme_respin"])
    self.allSpinCounts = #self.slotRespinData
    self.gameData.machineStatus = self.gameData.machineStatus or self.machineStatus.start
    self.gameData.useSpinCounts = self.gameData.useSpinCounts or 0

    self.resultIndex = self.slotMachineData.result_index or 8
    self.totalWin = self.slotMachineData.base_win or 0
end
function cls:enterBonusGame(tryResume, waitTime)
    self:setPics()
    self:initLayout()
    self:showSlotMachineScene(tryResume, waitTime)
end
function cls:initLayout()
    self.slotMachineView = slotView.new(self, self._mainViewCtl:getMapParentNode())
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
    self._mainViewCtl:changeRootNodeParent(toMain, newParent)
end
function cls:showSlotMachineScene(tryResume, waitTime)
    local parent = self.slotMachineView:getReelParent()
    self:changeRootNodeParent(false, parent)
    if self.avgBet then
        self._mainViewCtl:setPointBet(self.avgBet)
    end
    self:changeSpinLayer()
    if not tryResume then
        self._mainViewCtl.spinning = false
    end
    self:setBoard()
    self:dealWithData(tryResume)
    self:showSlotMachineStep(self.gameData.machineStatus, waitTime)
end
function cls:changeSpinLayer()
    self._mainViewCtl:showSmallSlotUI()
end
function cls:setBoard(item_list)
    local item_list = item_list or {}
    if #item_list == 0 then
        for i = 1, 3 do
            item_list[i] = { math.random(102, 109) }
        end
    end
    if self:getReelKeys() then
        self._mainViewCtl:resetBoardCellsByCreateList(self:getReelKeys())
    end
    self._mainViewCtl:resetBoardCellsByItemList(item_list)
end
function cls:handleResult()
    self:laterCallBack(1, function(...)
        self._mainViewCtl:handleResult()
    end)
end
function cls:showSlotMachineStep(step, waitTime)
    if step == self.machineStatus.start then
        waitTime = waitTime or 0
        self:laterCallBack(waitTime, function ()
            self:showSlotMachineStart()
        end)
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
        self._mainViewCtl.rets["theme_respin"] = tool.tableClone(self.slotMachineData["theme_respin"])
        local removeCount = self.gameData.useSpinCounts
        for i = 1, removeCount do
            table.remove(self._mainViewCtl.rets["theme_respin"], 1)
        end
        item_list = self.slotRespinData[self.gameData.useSpinCounts]
        self:recoverLastBoard(item_list)
    end
    if self.gameData.useSpinCounts < self.allSpinCounts then
        self:handleResult()
    else
        self._mainViewCtl.rets["theme_respin"] = nil
        self:showSlotMachineCollect()
    end
end
function cls:recoverLastBoard(item_list)
    item_list = item_list or self.slotRespinData[#self.slotRespinData]
    self._mainViewCtl:resetBoardCellsByItemList(item_list)
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
                self:onMapRepsinAllReelStop()
                self:showSlotMachineCollect()
            end)
    ))
end
function cls:setPics(...)
    self.pics = table.copy(self._mainViewCtl.pics)
end
function cls:setFooterBtnsEnable(enable)
    self._mainViewCtl:setFooterBtnsEnable(enable)
end
function cls:collectNotice(...)
    self._mainViewCtl:collectCoins(1)
    self.bonus.data["end_game"] = true
    self.bonus:saveBonus()
end
-- 
function cls:exitSlotMachineScene(...)
    local trans = self:getGameConfig().transition_config["slot_machine"]
    self._mainViewCtl:playTransition(nil, "slot_machine")
    self:collectNotice()
    local a1 = cc.DelayTime:create(trans.onCover)
    local a2 = cc.CallFunc:create(function(...)
        self:recoverNormalBoard()
        self.bonus:overSlotMachineCollect()
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
    self._mainViewCtl:changeRootNodeParent(true, false)
    self._mainViewCtl:changeSpinBoard("Normal")
    self._mainViewCtl:setFooterStyle(1)
    self.bonus:recoverLastBoard()
end

function cls:showThemeDialog(theData, sType, csbName, dialogType)
    -- self:playFadeToMinVlomeMusic()
    local fs_show_type = {
        start = 1,
        more  = 2,
        collect = 3
    }
    local end_event = theData.click_event
    local theDialog = nil
    theData.click_event = function()
        -- self:playFadeToMaxVlomeMusic()
        self:playMusicByName("common_click")
        if end_event then
            end_event()
        end
    end
    local config = {}
    local btnInfo = table.copy(slotConfig.dialog_config["black_common"])
    config["csb_file"] = self:getPic(csbName)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 3, nil, 3 },
        ["collect"] = { nil, 1, nil, 2 },
    }
    config.dialog_config = table.copy(slotConfig.dialog_config[dialogType])
    theDialog = ThemeBaseDialog.new(self, config, btnInfo)
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
    elseif sType == fs_show_type.collect then
        theDialog:showCollect(theData)
    end
    return theDialog
end

function cls:onExit(...)
    if self.slotMachineView then
        self.slotMachineView:onExit()
    end
    self.slotMachineView = nil
end
return cls

