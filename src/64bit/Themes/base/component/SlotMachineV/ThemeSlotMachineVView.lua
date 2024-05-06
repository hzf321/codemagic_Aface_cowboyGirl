---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/01/20 13:26
---
local cls = class("ThemeSlotMachineVView", CCSNode)
function cls:ctor(slotMCtl, parent, csb)
    self.slotMCtl = slotMCtl
    self.parentNode = parent
    self.csb = self.slotMCtl:getPic("csb/") .. "slot_machine_portrait_3x1.csb"
    CCSNode.ctor(self, self.csb)
    self:addToParent()
end
function cls:loadControls(...)
    self.reelRoot = self.node:getChildByName("Node_root_node")
    self.symbolAniNode = self.node:getChildByName("symbol_ani_node")
    self.winKuangAnim = self.node:getChildByName("win_kuang_anim")

    self.dimmer = self.node:getChildByName("dimmer_node") --弹窗用到的dimmer
    self.dimmer:setVisible(false)

    self.reelDimmerNode = self.node:getChildByName("reelDimmerNode")
    self.reelDimmerNode:setVisible(false)

    self.startDialog = self.node:getChildByName("popup_trigger_node")
    self.startDialog:setVisible(false)

    self.collectDialog = self.node:getChildByName("popup_collect_node")
    self.collectDialog:setVisible(false)

    self.slotTransitionDimmer = self.node:getChildByName("tansition_dimmer")
    self.slotTransitionDimmer:setVisible(false)
    self:initStartDialog()
    self:initCollectDialog()
    self:addBgLightAnimation()
end

function cls:addToParent()
    self.parentNode:addChild(self)
end
function cls:addBgLightAnimation(...)
    self.bg_root = self.node:getChildByName("background")
    self.bg_lightAniNode = self.bg_root:getChildByName("bg_light_ani_node")
    local bgFile = self.slotMCtl:getSpineFile("bg_light")
    bole.addSpineAnimation(self.bg_lightAniNode, nil, bgFile, cc.p(0, -57), "animation", nil, nil, nil, true, true, nil)
end
function cls:changeBoardParent()
    self.slotMCtl:changeRootNodeParent(nil, self.reelRoot)
end
function cls:getReelParent()
    return self.reelRoot
end
function cls:updatePaytable(pays)
    self.paytableListNode = self.node:getChildByName("paytable_list")
    self.paytableLabels = {}
    local baseBet = self.slotMCtl:getBaseBet()
    for i = 1, 8 do
        self.paytableLabels[i] = self.paytableListNode:getChildByName("label" .. i)

        local value = pays[i] * self.slotMCtl.avgBet / baseBet
        self.paytableLabels[i]:setString(FONTS.formatByCount4(value, 5, true, true))
    end
end
function cls:initStartDialog(...)
    self.startPopWindowAniNode = self.startDialog:getChildByName("popup_window_ani_node")
    self.btn_start = self.startDialog:getChildByName("btn_start")
end
function cls:initCollectDialog(...)
    self.collectPopWindowAniNode = self.collectDialog:getChildByName("popup_window_ani_node")
    self.btn_collect = self.collectDialog:getChildByName("btn_collect")
    self.label_win = self.collectDialog:getChildByName("label_mapSlotWin")
    local labelInfo = self.slotMCtl:getLabelInfo()
    self.label_win.maxWidth = labelInfo.maxWidth
    self.label_win.maxScale = labelInfo.baseScale or 1
    inherit(self.label_win, LabelNumRoll)
    local function fontFormat(num)
        return FONTS.formatByCount4(num, 15, true)
    end
    self.label_win:nrInit(0, 25, fontFormat)
end
function cls:showPopUpWindowEffect(windowType)
    local parent
    if windowType == "start" then
        parent = self.startPopWindowAniNode
    elseif windowType == "collect" then
        parent = self.collectPopWindowAniNode
    end
    local file = self.slotMCtl:getSpineFile("popup_window")
    bole.addSpineAnimationInTheme(parent, nil, file, cc.p(0, -20), "animation", nil, nil, nil, true, true, nil)
end
----逻辑部分
function cls:drawWinLineSymbols(...)
    self.reelDimmerNode:setVisible(true)
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
    self.symbolAniNode:runAction(cc.Repeat:create(cc.Sequence:create(
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function()
                self.symbolAniNode:setVisible(false)
            end),
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function(...)
                self.symbolAniNode:setVisible(true)
            end)
    ), 9))
    local file2 = self.slotMCtl:getSpineFile("line_kuang")
    local animName = "animation" .. self.slotMCtl.resultIndex
    bole.addSpineAnimationInTheme(self.winKuangAnim, 5, file2, cc.p(0, -57), animName, nil, nil, nil, true, true)
end
function cls:playSymbolAnimation(parent, key)
    local file = self.slotMCtl:getPic("spine/symbols/" .. key .. "/spine")
    local _, s = bole.addSpineAnimationInTheme(parent, 5, file, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end

function cls:showSMStartDialog()
    self.startDialog:setScale(0)
    self.startDialog:setVisible(true)
    self:showPopUpWindowEffect("start")
    local startBtnFile = self.slotMCtl:getSpineFile("btn_start")
    local a1 = cc.DelayTime:create(0.5)
    local a2 = cc.CallFunc:create(function(...)
        bole.addSpineAnimationInTheme(self.btn_start, nil, startBtnFile, cc.p(149, 45.5), "animation", nil, nil, nil, true, true, nil)
        self.startDialog:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.25, 1.3, 1.3),
                cc.ScaleTo:create(0.15, 1, 1)
        ))
        self.slotMCtl:playMusicByName("slot_popup")
        self.dimmer:setOpacity(0)
        self.dimmer:setVisible(true)
        self.dimmer:runAction(cc.FadeIn:create(0.2))
    end)
    local a3 = cc.DelayTime:create(0.35)
    local a4 = cc.CallFunc:create(function(...)
        self.btn_start:setBright(true)
        self.btn_start:setTouchEnabled(true)
        self:initStartEvent()
    end)
    local a5 = cc.Sequence:create(a1, a2, a3, a4)

    self.node:runAction(a5)
end
function cls:hideSMStartDialog(...)
    self.node:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self.startDialog:setScale(1)
                self.startDialog:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.15, 1.3, 1.3),
                        cc.ScaleTo:create(0.25, 0, 0)
                ))
                self.dimmer:setOpacity(255)
                self.dimmer:runAction(cc.FadeOut:create(0.3))
            end),
            cc.DelayTime:create(0.35),
            cc.CallFunc:create(function(...)
                self.startPopWindowAniNode:removeAllChildren()
                self.slotMCtl:showSlotMachineStep(self.slotMCtl.gameData.machineStatus)
            end)
    ))
end
function cls:initStartEvent(...)
    local pressFunc = function(obj)
        self.slotMCtl:stopMusicByName("slot_popup")
        self.slotMCtl:playMusicByName("common_click")
        self:setBtnDisplay(self.btn_start)
        self:hideSMStartDialog()
        self.slotMCtl:changeMachineState(self.slotMCtl.machineStatus.current)
    end
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            pressFunc(obj)
        end
    end
    self.btn_start:addTouchEventListener(onTouch)
end
function cls:setBtnDisplay(btn)
    if not btn then
        return
    end
    btn:setTouchEnabled(false)
    btn:setBright(false)
    btn:removeAllChildren()
end
-- 展示结算的弹窗
function cls:showCoinLabelNode(labelCoin, coin, maxWidth, scale)
    if (not labelCoin) or (not coin) then
        return
    end
    local rollupDuration = 2
    scale = scale or 1
    inherit(labelCoin, LabelNumRoll)
    local function fontFormat2(num)
        return FONTS.format(num, true)
    end
    labelCoin:nrInit(0, 25, fontFormat2)
    labelCoin:setString(FONTS.format(coin, true))
    bole.shrinkLabel(labelCoin, maxWidth, scale)
    labelCoin:setString(0)
    labelCoin:nrStartRoll(0, coin, rollupDuration)
end
function cls:showSMColletDialog(...)
    self.collectDialog:setScale(0)
    self.collectDialog:setVisible(true)
    self.slotMCtl:setFooterBtnsEnable(false)
    self:showPopUpWindowEffect("collect")
    self.slotMCtl:playMusicByName("slot_popup")
    local collectBtnFile = self.slotMCtl:getSpineFile("btn_collect")
    local a1 = cc.DelayTime:create(0.5)
    local a2 = cc.CallFunc:create(function(...)
        self:showCoinLabelNode(self.label_win, self.slotMCtl.totalWin, self.label_win.maxWidth, self.label_win.maxScale)
        bole.addSpineAnimationInTheme(self.btn_collect, nil, collectBtnFile, cc.p(149, 45.5), "animation", nil, nil, nil, true, true, nil)
        self.collectDialog:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.25, 1.3, 1.3),
                cc.ScaleTo:create(0.15, 1, 1)
        ))
        self.dimmer:setOpacity(0)
        self.dimmer:setVisible(true)
        self.dimmer:runAction(cc.FadeIn:create(0.2))
    end)
    local a3 = cc.DelayTime:create(0.35)
    local a4 = cc.CallFunc:create(function(...)
        self.btn_collect:setBright(true)
        self.btn_collect:setTouchEnabled(true)
        self:initCollectEvent()
    end)
    local a5 = cc.Sequence:create(a1, a2, a3, a4)
    self.node:runAction(a5)
end
function cls:initCollectEvent(...)
    local pressFunc = function(obj)
        self.slotMCtl:stopMusicByName("slot_popup")
        self.slotMCtl:playMusicByName("common_click")
        self:setBtnDisplay(self.btn_collect)
        local a1 = cc.CallFunc:create(function(...)
            self.label_win:nrStopRoll()
            self.label_win:setString(FONTS.format(self.slotMCtl.totalWin, true))
        end)
        local a2 = cc.DelayTime:create(0.3)
        local a3 = cc.CallFunc:create(function(...)
            self.collectDialog:setScale(1)
            self.collectDialog:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.15, 1.3, 1.3),
                    cc.ScaleTo:create(0.25, 0, 0)
            ))
            self.dimmer:setOpacity(255)
            self.dimmer:runAction(cc.FadeOut:create(0.3))
        end)
        local a4 = cc.DelayTime:create(0.35)
        local a5 = cc.CallFunc:create(function(...)
            self.slotMCtl:exitSlotMachineScene()
        end)
        local a6 = cc.Sequence:create(a1, a2, a3, a4, a5)
        self.node:runAction(a6)
        self.slotMCtl:collectNotice()
    end
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            pressFunc(obj)
        end
    end
    self.btn_collect:addTouchEventListener(onTouch)
end
function cls:playDimmerTransitionIn()
    self.slotTransitionDimmer:setOpacity(0)
    self.slotTransitionDimmer:setVisible(true)
    self.slotTransitionDimmer:runAction(cc.FadeIn:create(0.2))
end
function cls:onExit(...)
    -- self.slotMRoot:removeFromParent()
    --self.slotMParent:removeFromParent()
    self:removeFromParent()
end
return cls

