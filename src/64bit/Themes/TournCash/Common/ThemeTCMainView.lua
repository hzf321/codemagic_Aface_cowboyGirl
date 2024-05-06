---@program src 2010
---@create: : 2021/02/22 18:00:00
---@author: rwb
---
local cls = class("ThemeTCMainView")
--local TCCommonView = require("Themes/TournCash/Common/ThemeTC_CommonView")
local SpinLayerType

function cls:ctor(mainThemeScene, tcCommonCtl, themeCtl)
    self.mainThemeScene = mainThemeScene
    self.tcCommonCtl = tcCommonCtl
    self.themeCtl = themeCtl
    self:initScene()
end
function cls:getRetCell(col, row)
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    return cell
end
function cls:initScene(...)
    self.bgNode = self.mainThemeScene:getChildByName("theme_bg")
    self.balloonFlyNode = self.mainThemeScene:getChildByName("fly_node")
    self:_initBgNode()
    self:_initBoardNode()
    self.rankNode = self.mainThemeScene:getChildByName("rank_node")
    self:_initRankNode()

    self.top_node = self.mainThemeScene:getChildByName("top_node")
    self.tipNode = self.top_node:getChildByName("tip_node")
    self:_initTipBtn()
    self.stageNode = self.top_node:getChildByName("stage_node")
    self:_initStageNode()
    self.prizePoolNode = self.top_node:getChildByName("progressive")
    self:_initPrizePoolNode()
    self.collectNode = self.top_node:getChildByName("collect_node")
    self:_initCollectNode()
    self.battleNode = self.top_node:getChildByName("battle_node")
    self:_initBattleNode()
    self.multiTipNode = self.mainThemeScene:getChildByName("multi_tip")
    self:_initMultiTipNode()

    self.logoNode = self.mainThemeScene:getChildByName("logo_node")
    --self.dialogNode = self.down_node:getChildByName("dialog_node")
    self.topNode = self.mainThemeScene:getChildByName("top_node2")
    self:_initAddLongLabel()
    self:_initBalloonNode()
    self:_createTournCashNode()
end
function cls:_initAddLongLabel()
    if bole.getAdaptationWidthScreen() then
        local data = {}
        data.file = self.tcCommonCtl:getSpineFile("long_label")
        data.parent = self.logoNode
        local moveY = 320 + self.themeCtl:adaptMoveDownY() / 2
        data.pos = cc.p(0, moveY)
        data.isLoop = true
        bole.addAnimationSimple(data)
    end
end
function cls:getMainThemeScene()
    return self.mainThemeScene
end
function cls:_createTournCashNode()
    local node = TournCashController:getInstance():getDialogClass("TournCashPromotionEntrance").new()
    self.logoNode:addChild(node, 10)
    node:setPositionY(210)
    node:setPositionX(565)
end

--function cls:_addBoardSpine()
--    self.tableBaseSpine:removeAllChildren()
--    local data = {}
--    data.file = self.tcCommonCtl:getSpineFile("base_board")
--    data.parent = self.tableBaseSpine
--    data.isLoop = true
--    data.pos = cc.p(0, 0)
--    data.animateName = "animation2"
--    local _, s = bole.addAnimationSimple(data)
--    self.boardFrameSpine = s
--end

function cls:_initBoardNode(...)
    --self.excitationBg = self.reelRootNode:getChildByName("jili_bg")
    --self.skipNode = self.reelRootNode2:getChildByName("skip_node")
    --self.boardRoot = self.reelRootNode:getChildByName("board_root")
    --self.boardRoot:setLocalZOrder(1)
    --self.animateNode = self.reelRootNode2:getChildByName("animate_node")
    --self.animateNode:setLocalZOrder(4)
    --self.themeAnimateKuang = self.reelRootNode2:getChildByName("win_line")
    --self.themeAnimateKuang:setLocalZOrder(6)
    --
    --self.scatterNode = self.reelRootNode2:getChildByName("scatter_node")
    --self.scatterNode:setLocalZOrder(7)
    self.down_node = self.mainThemeScene:getChildByName("down_node")
    self.down_child = self.down_node:getChildByName("down_child")
    self.reelRootNode2 = self.down_child:getChildByName("node_board_2")
    self.flyNode = self.reelRootNode2:getChildByName("fly_node")
    --self.flyNode:setLocalZOrder(10)
    --
    --self.imgRespinMask = self.reelRootNode2:getChildByName("img_respin_mask")
    --self.imgRespinMask:setLocalZOrder(20)
    --self.imgRespinMask:setVisible(false)
    --self.imgBaseMask = self.reelRootNode2:getChildByName("img_base_mask")
    --self.imgBaseMask:setVisible(false)

end
--function cls:updateBaseUI()
--
--    self.collectNode:setVisible(true)
--    self.tableBase:setVisible(true)
--    self.battleNode:setVisible(false)
--    self.top_node:setPosition(cc.p(0, 244))
--end
--function cls:updateBattleUI()
--    self.collectNode:setVisible(true)
--    self.tableBase:setVisible(true)
--    self.battleNode:setVisible(true)
--    self.top_node:setPosition(cc.p(0, 253))
--end
--function cls:updateRound3UI(isAnimate)
--    self.collectNode:setVisible(true)
--    self.battleNode:setVisible(false)
--    self.top_node:setPosition(cc.p(0, 257))
--    self.multiTipNode:setVisible(false)
--    self.tcCommonCtl:setStartRound(3)
--end
function cls:changeBg(pType)

    local imgBG = { self.baseBg, self.freeBg, self.bonusBg }
    local showBg = imgBG[pType]
    if not showBg then
        return
    end
    if self.curBg ~= showBg then
        local _curBg = self.curBg
        _curBg:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 0), cc.DelayTime:create(0.5), cc.CallFunc:create(function(...)
            _curBg:setVisible(false)
        end)))
        showBg:setOpacity(0)
        showBg:setVisible(true)
        showBg:runAction(cc.FadeTo:create(0.5, 255))
        self.curBg = showBg
    end
end
function cls:_initBgNode(...)
    self.baseBg = self.bgNode:getChildByName("bg_base")
    self.curBg = self.baseBg
    self.freeBg = self.bgNode:getChildByName("bg_free")
    self.freeBg:setVisible(false)
    self.bonusBg = self.bgNode:getChildByName("bg_bonus")
    self.bonusBg:setVisible(false)

    self.spineBg = self.bgNode:getChildByName("bg_spine")
    local data = {}
    data.file = self.tcCommonCtl:getSpineFile("base_bg")
    data.parent = self.spineBg
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    self.bgSpine = s
    self:adaptBackgroundII(self.bgNode)
end
function cls:adaptBackgroundII(bg)
    local BG_WIDTH = 1560
    local BG_HEIGHT = 720
    if bg then
        local scale = FRAME_WIDTH / BG_WIDTH
        if scale > 1 then
            bg:setScale(bg:getScale() * scale)
        elseif scale < 0.82 then
            local showHeight = bole.getAdaptScale() * BG_HEIGHT
            if showHeight < DESIGN_HEIGHT then
                scale = DESIGN_HEIGHT / showHeight
                bg:setScale(bg:getScale() * scale)
            end
        end
    end
    self.themeCtl:adaptBottomHorizontal(bg, nil, 2)
end
function cls:_initRankNode(...)
    self.tcCommonCtl:getRankCtl():initLayout(self.rankNode, self.flyNode)
end
function cls:_initCollectNode(...)
    self.tcCommonCtl:getCollectViewCtl():initLayout(self.collectNode, self.flyNode)
end
function cls:_initBattleNode(...)
    self.tcCommonCtl:getRankCtl():initBattleLayout(self.battleNode)
end
function cls:_initBalloonNode(...)
    self.ballonBtns = self.mainThemeScene:getChildByName("node_btns")
    self.balloonNoTouchDown = self.ballonBtns:getChildByName("btn_down")
    self.balloonNoTouchTop = self.ballonBtns:getChildByName("btn_top")
    local moveY = self.themeCtl:adaptMoveDownY()
    local adaptMoveY1 = self.balloonNoTouchDown:getPositionY() / bole.getAdaptScale()
    local adaptMoveY2 = self.balloonNoTouchTop:getPositionY() / bole.getAdaptScale()
    self.themeCtl:adaptBottomHorizontal(self.ballonBtns, nil, 2)
    self.balloonNoTouchDown:setPositionY(adaptMoveY1)
    self.balloonNoTouchTop:setPositionY(adaptMoveY2)
    self.tcCommonCtl:getBalloonCtl():initLayout(self.balloonFlyNode)
end
---------------------- multi tip start ------------------------------------------
function cls:_initMultiTipNode()
    self.tcCommonCtl:getMultiCtl():initLayout(self.multiTipNode)
end
---------------------- multi tip end ----------------------------------------
------------------ stage node start ------------------------------------------
function cls:_initStageNode()
    self.tcCommonCtl:getStageViewCtl():initLayout(self.stageNode)
end
------------------ prize pool start --------------------------------
function cls:_initPrizePoolNode()
    self.tcCommonCtl:getPrizePoolCtl():initLayout(self.prizePoolNode)
end
------------------ prize pool end -------------------------------------
-------------------------  tip node start-------------------------
function cls:_initTipBtn()
    self.tipBtn = self.tipNode:getChildByName("tip_btn")
    self:_initTipBtnEvent()
end
function cls:_initTipBtnEvent()
    local click_event = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            libDebug.endLog("tourncash")
            PopupController:getInstance():addDialogToPopupFront("game_rules", { controller = self.themeCtl }, nil)
        end
    end
    self.tipBtn:addTouchEventListener(click_event)
end
---@override
function cls:setDelayToFadeOutLoopMusic()

end
---------------------------- tip node end-------------------------

--------------------- time out start -------------------------------------
function cls:playStartGoDialog()
    local data = {}
    data.file = self.tcCommonCtl:getSpineFile("dialog_start")
    data.parent = self.topNode
    data.pos = cc.p(0, 0)
    bole.addAnimationSimple(data)
    self.tcCommonCtl:playMusicByName("sound_num_go")
    if self.bgSpine and bole.isValidNode(self.bgSpine) then
        self.bgSpine:setAnimation(0, "animation2", false)
        self.bgSpine:addAnimation(0, "animation", true)
    end
    self:addForbidTouchLinster()
end
function cls:initBgListen()
    if self.listener then
        return
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    local function onTouchBegan (touch, event)
        return true
    end
    local function onTouchCancelled (touch, event)
        --self.baseBg.startPosition = nil
    end
    local function onTouchEnded (touch, event)
        --if self.baseBg.canTouch then
        --    local location = touch:getLocation()
        --end
    end
    self.baseBg.canTouch = true
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED) -- 同楼上
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.topNode:getEventDispatcher() -- 通过它管理当前节点（场景、层、精灵等）的所有事件的分发。
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.topNode)-- 添加一个事件监听器到事件派发器
    self.listener = listener
end

function cls:addForbidTouchLinster()
    self:initBgListen()
    self.listener:setSwallowTouches(true)
end
function cls:removeForbidTouchLinster()
    if self.listener then
        self.listener:setSwallowTouches(false)
    end
end
------------------ time out end -------------------------------------

return cls










