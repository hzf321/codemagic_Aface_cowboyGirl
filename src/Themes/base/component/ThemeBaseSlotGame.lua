ThemeBaseSlotGame = class("ThemeBaseSlotGame", CCSNode)
local slotMGame = ThemeBaseSlotGame

local paytableValueList = { 12500000, 100000, 62500, 30000, 37500, 30000, 20000, 10000 }

function slotMGame:ctor(themeCtl, bonusTheme, csbPath, data)
    --todo  small slots
    self.themeCtl = themeCtl
    self.bonusTheme = bonusTheme
    self.csb = csbPath .. "slot_machine_portrait_3x1.csb"
    self.data = data
    self.themeCtl.slotBonus = self
    -- self.ctl = self.bonusTheme.ctl
    self.avgBet = self.data.slotBet
    CCSNode.ctor(self, self.csb)

    self.gameConfig = self.themeCtl:getGameConfig()
end

function slotMGame:loadControls()
    self.dimmer = self.node:getChildByName("dimmer_node")
    self.dimmer:setVisible(false)
    self.reelRoot = self.node:getChildByName("Node_root_node")
    self.winKuangAnim = self.node:getChildByName("win_kuang_anim")
    self.triggerNode = self.node:getChildByName("popup_trigger_node")
    self.triggerNode:setVisible(false)
    self.btn_start = self.triggerNode:getChildByName("btn_start")
    self.startPopWindowAniNode = self.triggerNode:getChildByName("popup_window_ani_node")
    self.collectNode = self.node:getChildByName("popup_collect_node")
    self.collectNode:setVisible(false)
    self.label_win = self.collectNode:getChildByName("label_mapSlotWin")
    inherit(self.label_win, LabelNumRoll)
    local function fontFormat(num)
        return FONTS.formatByCount4(num, 15, true)
    end

    self.label_win:nrInit(0, 25, fontFormat)
    self.btn_collect = self.collectNode:getChildByName("btn_collect")
    self.collectPopWindowAniNode = self.collectNode:getChildByName("popup_window_ani_node")
    self.slotRespinData = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])
    self.allSpinCounts = #self.slotRespinData
    self.spinCount = self.data.lsSpinCount
    self.resultIndex = self.data.result_index or 8
    self.totalWin = self.data.core_data["map_ls_spin"]["total_win"]
    self.slotTransitionDimmer = self.node:getChildByName("tansition_dimmer")
    self.slotTransitionDimmer:setVisible(false)
    self.reelDimmerNode = self.node:getChildByName("reelDimmerNode")
    self.reelDimmerNode:setVisible(false)
    self.symbolAniNode = self.node:getChildByName("symbol_ani_node")
    self.symbolAniNodeList = {}
    self.paytableListNode = self.node:getChildByName("paytable_list")
    self.paytableLabels = {}
    for i = 1, 8 do
        self.paytableLabels[i] = self.paytableListNode:getChildByName("label" .. i)
        local value = paytableValueList[i] * self.avgBet / 5000
        self.paytableLabels[i]:setString(FONTS.formatByCount4(value, 5, true))
    end

    self.bg_root = self.node:getChildByName("background")
    self.bg_lightAniNode = self.bg_root:getChildByName("bg_light_ani_node")
end

function slotMGame:setData(...)
    self.bonusTheme:changeRootNodeParent(nil, self.reelRoot)
end

function slotMGame:showSlotMachineScene(tryResume)
    self.themeCtl:changeSpinBoard("MapSlot")
    if self.themeCtl.superAvgBet then
        self.themeCtl:setPointBet(self.themeCtl.superAvgBet)-- 更改 锁定的bet
        self.themeCtl.footer:isShowTotalBetLayout(false)-- 隐藏掉  footer bet
    end

    bole.scene:addToContentFooter(self)

    self:showBgAnimation()
    self.themeCtl.rets = self.themeCtl.rets or {}

    self.themeCtl.cacheSpinRet = self.themeCtl.cacheSpinRet or self.themeCtl.rets -- 快停按钮显示相关

    local function playIntro()
        self:setData()
        self.themeCtl.rets["theme_respin"] = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])

        self:setBoard()
        self.themeCtl.spinning = false
    end

    local function snapIntro()
        self.themeCtl:stopAllLoopMusic()
        local function recoverSpin()
            self:setData()
            if self.bonusTheme.data.lsSpinCount > 1 then
                self.bonusTheme.data.lsSpinCount = self.bonusTheme.data.lsSpinCount - 1
                self.bonusTheme:saveBonus()
            end

            local showItemList = {}
            if self.bonusTheme.data.lsSpinCount == 0 then
                for i = 1, 3 do
                    showItemList[i] = { math.random(102, 109) }
                end
            else
                showItemList = self.slotRespinData[self.bonusTheme.data.lsSpinCount + 1]
            end

            self.themeCtl:resetBoardCellsByItemList(showItemList)
            -- local x, y = self.themeBoardRoot:getPosition()
            -- for i = 1, 3 do

            --     local cell = self.themeCtl.spinLayer.spins[i]:getRetCell(1)
            --     local key = showItemList[i][1]
            --     local x, y = cell:getPosition()

            --     self.themeCtl:updateCellSprite(cell, key, i, 1)
            -- end

            if self.allSpinCounts > 1 and self.bonusTheme.data.lsSpinCount > 0 then

                local removeCount = self.bonusTheme.data.lsSpinCount

                self.themeCtl.rets["theme_respin"] = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])
                for i = 1, removeCount do
                    table.remove(self.themeCtl.rets["theme_respin"], 1)
                end
            else
                self.themeCtl.rets["theme_respin"] = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])
            end

            self.themeCtl:laterCallBack(1, function()
                self.themeCtl:handleResult()
            end)

        end

        local function recoverCollect(...)
            self:setData()
            local showItemList = self.slotRespinData[#self.slotRespinData]
            self.themeCtl:resetBoardCellsByItemList(showItemList)
            -- for i = 1, 3 do
            --     local cell = self.themeCtl.spinLayer.spins[i]:getRetCell(1)
            --     local key = showItemList[i][1]
            --     self.themeCtl:updateCellSprite(cell, key, i, 1)
            -- end
            self:onRespinFinish(false)
        end

        if self.allSpinCounts == self.bonusTheme.data.lsSpinCount then
            recoverCollect()
        else
            recoverSpin()
        end
    end

    if tryResume then
        snapIntro()
    else

        playIntro()
    end
end

function slotMGame:showBgAnimation()
    local file = self.themeCtl:getPic("slot_machine_portrait_3x1/spine/bg_light/spine")
    bole.addSpineAnimation(self.bg_lightAniNode, nil, file, cc.p(0, -57), "animation", nil, nil, nil, true, true, nil)
end

function slotMGame:setBoard(item_list)
    local item_list = item_list or {}
    if #item_list == 0 then
        for i = 1, 3 do
            item_list[i] = { math.random(102, 109) }
        end
    end

    if self.gameConfig.mapSlotConfig.reelKey then
        self.themeCtl:resetBoardCellsByCreateList(self.gameConfig.mapSlotConfig.reelKey)
    end

    self.themeCtl:resetBoardCellsByItemList(item_list)

    -- for i = 1, 3 do
    --     local cell = self.themeCtl.spinLayer.spins[i]:getRetCell(1)
    --     local x, y = cell:getPosition()
    --     local key = item_list[i][1]
    --     self.themeCtl:updateCellSprite(cell, key, i, 1)
    -- end
end

function slotMGame:showStartPopUpWindow()
    self.themeCtl:stopAllLoopMusic()
    self.triggerNode:setScale(0)
    self.triggerNode:setVisible(true)
    self:showPopUpWindowEffect("start")
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                local startBtnFile = self.themeCtl:getPic("slot_machine_portrait_3x1/spine/btn_start/spine")
                bole.addSpineAnimationInTheme(self.btn_start, nil, startBtnFile, cc.p(149, 45.5), "animation", nil, nil, nil, true, true, nil)
                self.triggerNode:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.25, 1.3, 1.3),
                        cc.ScaleTo:create(0.15, 1, 1)
                ))
                self.themeCtl:playMusicByName("slot_popup")
                self.dimmer:setOpacity(0)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeIn:create(0.2))
            end),
            cc.DelayTime:create(0.35),
            cc.CallFunc:create(function()
                self.btn_start:setBright(true)
                self.btn_start:setTouchEnabled(true)
                self:initStartEvent()
            end)
    ))
end

function slotMGame:initStartEvent()
    -- 点击按钮
    local pressFunc = function(obj)

        self.bonusTheme.data.start_dialog = true
        self.bonusTheme:saveBonus()
        self.btn_start:setTouchEnabled(false)
        self.btn_start:setBright(false)

        self.btn_start:removeAllChildren()
        -- 播放点击音乐
        self.themeCtl:playMusicByName("common_click")
        self:runAction(cc.Sequence:create(
                cc.CallFunc:create(function()
                    self.triggerNode:setScale(1)
                    self.triggerNode:runAction(cc.Sequence:create(
                            cc.ScaleTo:create(0.15, 1.3, 1.3),
                            cc.ScaleTo:create(0.25, 0, 0)
                    ))
                    self.dimmer:setOpacity(255)
                    self.dimmer:runAction(cc.FadeOut:create(0.3))
                end),
                cc.DelayTime:create(0.35),
                cc.CallFunc:create(function(...)
                    self.startPopWindowAniNode:removeAllChildren()
                    self.themeCtl:handleResult()
                end)
        ))

    end

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            pressFunc(obj)
        end
    end

    -- 设置按钮
    self.btn_start:addTouchEventListener(onTouch)
end

function slotMGame:drawWinLineSymbols()
    self.reelDimmerNode:setVisible(true)
    local winList = self.slotRespinData[#self.slotRespinData]
    for i = 1, 3 do
        local key = winList[i][1]
        self.symbolAniNodeList[i] = cc.Node:create()
        local pos = self.themeCtl:getCellPos(i, 1)
        self.symbolAniNodeList[i]:setPosition(pos)
        self.symbolAniNode:addChild(self.symbolAniNodeList[i])
        local theCellFile = self.themeCtl.pics[key]
        local theCellSprite = bole.createSpriteWithFile(theCellFile)
        self.symbolAniNodeList[i]:addChild(theCellSprite)
        self:playSymbolAnimation(self.symbolAniNodeList[i], key)
    end

    self.themeCtl:playMusicByName("slot_win")

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


    local file2 = self.themeCtl:getPic("slot_machine_portrait_3x1/spine/win_kuang/mini_lhj")
    local animName = "animation"..self.resultIndex
    bole.addSpineAnimationInTheme(self.winKuangAnim, 5, file2, cc.p(0, -57), animName, nil, nil, nil, true, true)
end

function slotMGame:playSymbolAnimation(parent, key)

    local file = self.themeCtl:getPic("slot_machine_portrait_3x1/spine/symbols/" .. key .. "/spine")
    local _, s = bole.addSpineAnimationInTheme(parent, 5, file, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)

end

function slotMGame:showCollectPopUpWindow()
    self.collectNode:setScale(0)
    self.collectNode:setVisible(true)
    self.themeCtl.footer:setSpinButtonState(true) -- 禁用spin 按钮
    self:showPopUpWindowEffect("collect")
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                local rollupDuration = 3
                self.label_win:nrStartRoll(0, self.totalWin, rollupDuration)
                self.themeCtl:stopMusicByName("win_rollUp")
                self.themeCtl:playMusicByName("win_rollUp", true)
                local collectBtnFile = self.themeCtl:getPic("slot_machine_portrait_3x1/spine/btn_collect/spine")
                bole.addSpineAnimationInTheme(self.btn_collect, nil, collectBtnFile, cc.p(149, 45.5), "animation", nil, nil, nil, true, true, nil)
                self.collectNode:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.25, 1.3, 1.3),
                        cc.ScaleTo:create(0.15, 1, 1)
                ))
                self.themeCtl:playMusicByName("slot_popup")
                self.dimmer:setOpacity(0)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeIn:create(0.2))
            end),
            cc.DelayTime:create(0.35),
            cc.CallFunc:create(function()
                self.btn_collect:setBright(true)
                self.btn_collect:setTouchEnabled(true)
                self:initCollectEvent()
                -- 在此之后断电重连就不用恢复了

                -- 收钱
            end)
    ))

end

function slotMGame:initCollectEvent(...)
    -- 点击按钮
    local pressFunc = function(obj)
        self.bonusTheme.themeCtl:collectCoins(1)
        self.bonusTheme.data["end_game"] = true
        self.bonusTheme:saveBonus()
        self.btn_collect:setTouchEnabled(false)
        self.btn_collect:setBright(false)
        self.btn_collect:removeAllChildren()
        -- 播放点击音乐
        self.themeCtl:playMusicByName("common_click")
        self:runAction(cc.Sequence:create(
                cc.CallFunc:create(function(...)
                    self.label_win:nrStopRoll()
                    self.themeCtl:stopMusicByName("win_rollUp")
                    self.label_win:setString(FONTS.formatByCount4(self.totalWin, 15, true))

                end),
                cc.DelayTime:create(0.3),
                cc.CallFunc:create(function()
                    self.collectNode:setScale(1)
                    self.collectNode:runAction(cc.Sequence:create(
                            cc.ScaleTo:create(0.15, 1.3, 1.3),
                            cc.ScaleTo:create(0.25, 0, 0)
                    ))
                    self.dimmer:setOpacity(255)
                    self.dimmer:runAction(cc.FadeOut:create(0.3))
                end),
                cc.DelayTime:create(0.35),
                cc.CallFunc:create(function(...)
                    self.collectPopWindowAniNode:removeAllChildren()
                    self:exitSlotMachineScene()
                end)
        ))

    end

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            pressFunc(obj)
        end
    end

    -- 设置按钮
    self.btn_collect:addTouchEventListener(onTouch)
end

function slotMGame:showPopUpWindowEffect(windowType)
    local parent
    if windowType == "start" then
        parent = self.startPopWindowAniNode
    elseif windowType == "collect" then
        parent = self.collectPopWindowAniNode
    end

    local file = self.themeCtl:getPic("slot_machine_portrait_3x1/spine/popup_window/spine")
    bole.addSpineAnimationInTheme(parent, nil, file, cc.p(0, -20), "animation", nil, nil, nil, true, true, nil)
end

function slotMGame:onRespinStart(...)
    self.bonusTheme.data.lsSpinCount = self.bonusTheme.data.lsSpinCount + 1
    self.bonusTheme:saveBonus()
    self.themeCtl:stopMusicByName("slot_spin")
    self.themeCtl:playMusicByName("slot_spin", true)
end

function slotMGame:onMapRepsinAllReelStop()
    self.themeCtl:stopMusicByName("slot_spin")
end

function slotMGame:onRespinFinish(tryResume)
    local animationTime = 2
    if tryResume then
        animationTime = 0
    end
    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                if not tryResume then
                    self:drawWinLineSymbols()
                end
            end),
            cc.DelayTime:create(animationTime),
            cc.CallFunc:create(function()
                self:showCollectPopUpWindow()
            end)
    ))

end

function slotMGame:playDimmerTransitionIn()
    self.slotTransitionDimmer:setOpacity(0)
    self.slotTransitionDimmer:setVisible(true)
    self.slotTransitionDimmer:runAction(cc.FadeIn:create(0.2))
end

function slotMGame:exitSlotMachineScene(...)
    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self:playDimmerTransitionIn()
            end),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function()

                self.bonusTheme:overSlotMachineScene()

            end),
            cc.RemoveSelf:create()
    ))
end