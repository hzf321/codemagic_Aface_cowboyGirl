--[[
Author: xiongmeng
Date: 2021-03-25 18:40:01
LastEditors: xiongmeng
LastEditTime: 2021-04-26 21:18:41
Description: 
--]]
local cls = class("ThemeSlotMachineVI_View", CCSNode)
function cls:ctor(slotMCtl, parent)
    self.slotMCtl = slotMCtl
    self.parentNode = parent
    self.csb = self.slotMCtl:getPic("csb/") .. "slot_machine_v.csb"
    CCSNode.ctor(self, self.csb)
    self:addToParent()
end
function cls:loadControls(...)
    self.reelRoot = self.node:getChildByName("Node_root_node")
    self.symbolAniNode = self.node:getChildByName("symbol_ani_node")
    self.winKuangAnim = self.node:getChildByName("win_kuang_anim")
    self.downNode = self.node:getChildByName("down_node")
    self.backgroundNode = self.node:getChildByName("background")
    local reel_bg = self.node:getChildByName("reel_bg")
    reel_bg:setScaleX(1.01)
    self:addBoardAnimation()
end

function cls:addToParent()
    self.parentNode:addChild(self)
    bole.adaptReelBoard(self.node)
    if self.backgroundNode then
        bole.adaptReelBoard(self.backgroundNode, -1)
    end
end
function cls:addBoardAnimation(...)
    self.bg_lightAniNode = self.downNode:getChildByName("bg_light_ani_node")
    local bgFile = self.slotMCtl:getSpineFile("bg_light")
    local _,spine = bole.addSpineAnimationInTheme(self.bg_lightAniNode, nil, bgFile, cc.p(0, 60), "animation", nil, nil, nil, true, true, nil)
    self.bgLightSpine = spine
end
function cls:changeBoardParent()
    self.slotMCtl:changeRootNodeParent(nil, self.reelRoot)
end
function cls:getReelParent()
    return self.reelRoot
end
function cls:updatePaytable(pays)
    self.paytableListNode = self.downNode:getChildByName("paytable_list")
    self.paytableLabels = {}
    local baseBet = self.slotMCtl:getBaseBet()
    for i = 1, 8 do
        self.paytableLabels[i] = self.paytableListNode:getChildByName("label" .. i)

        local value = pays[i] * self.slotMCtl.avgBet / baseBet
        self.paytableLabels[i]:setString(FONTS.formatByCount4(value, 5, true, true))
    end
end
----逻辑部分
function cls:drawWinLineSymbols(...)
    -- self.reelDimmerNode:setVisible(true)
    self.symbolAniNodeList = {}
    local winList = self.slotMCtl.slotRespinData[#self.slotMCtl.slotRespinData]
    for i = 1, 3 do
        local key = winList[i][1]
        self.symbolAniNodeList[i] = cc.Node:create()
        local pos = self.slotMCtl:getCellPos(i, 1)
        self.symbolAniNodeList[i]:setPosition(pos)
        self.symbolAniNode:addChild(self.symbolAniNodeList[i])
        local theCellFile = self.slotMCtl.pics[key]
        local theCellSprite = bole.createSpriteWithFile(theCellFile)
        self.symbolAniNodeList[i]:addChild(theCellSprite)
        self:playSymbolAnimation(self.symbolAniNodeList[i], key)
    end
    self.slotMCtl:playMusicByName("slot_win")
    self.symbolAniNode:stopAllActions()
    if self.bgLightSpine and bole.isValidNode(self.bgLightSpine) then
        bole.spChangeAnimation(self.bgLightSpine, "animation2", true)
    end
    self.slotMCtl:setFooterBtnsEnable(false)
    local file2 = self.slotMCtl:getSpineFile("line_kuang")
    local animName = "animation" .. self.slotMCtl.resultIndex
    bole.addSpineAnimationInTheme(self.winKuangAnim, 5, file2, cc.p(0, 0), animName, nil, nil, nil, true, true)
end
function cls:playSymbolAnimation(parent, key)
    local file = self.slotMCtl:getPic("spine/symbols/" .. key .. "/spine")
    local _, s = bole.addSpineAnimationInTheme(parent, 5, file, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end
function cls:showSMStartDialog()
    local theData = {}
    local csbName = self.slotMCtl:getPopupCsb()
    local dialogName = "dailog_start"
    local btnStart = nil
    theData.click_event = function ( ... )
        self:setBtnDisplay(btnStart)
        self.slotMCtl:stopMusicByName("slot_popup")
        self.slotMCtl:changeMachineState(self.slotMCtl.machineStatus.current)
        self.slotMCtl:laterCallBack(1, function ()
            self.slotMCtl:showSlotMachineStep(self.slotMCtl.gameData.machineStatus)
        end)
	end
    self.slotMCtl:playMusicByName("slot_popup")
    local dailog = self.slotMCtl:showThemeDialog(theData, 1, csbName, dialogName)
    btnStart = dailog.startRoot.btnStart
end
function cls:setBtnDisplay(btn)
    if not btn then
        return
    end
    btn:setTouchEnabled(false)
    btn:setBright(false)
    btn:removeAllChildren()
end
function cls:showSMColletDialog(...)
    local theData = {}
    theData.coins = self.slotMCtl.totalWin
    local csbName = self.slotMCtl:getPopupCsb()
    local dialogName = "dailog_collect"
    local btnCollect = nil
    theData.click_event = function ( ... )
        self:setBtnDisplay(btnCollect)
        self.slotMCtl:stopMusicByName("slot_popup")
        self.slotMCtl:laterCallBack(1, function ()
            self.slotMCtl:exitSlotMachineScene()
        end)
	end
    self.slotMCtl:playMusicByName("slot_popup")
    self.slotMCtl:setFooterBtnsEnable(false)
    local dailog = self.slotMCtl:showThemeDialog(theData, 3, csbName, dialogName)
    btnCollect = dailog.collectRoot.btnCollect
end
function cls:onExit(...)
    self:removeFromParent()
end
return cls

