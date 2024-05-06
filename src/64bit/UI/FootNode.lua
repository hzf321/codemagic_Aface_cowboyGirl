Footer = class("Footer", function() return cc.Node:create() end)


local HeaderFooterConfig = require("UI/HeaderFooterConfig")
local createContainer      = HeaderFooterConfig.createContainer
local createSprite         = HeaderFooterConfig.createSprite
local createButton         = HeaderFooterConfig.createButton
local createNode           = HeaderFooterConfig.createNode
local createFont           = HeaderFooterConfig.createFont
local updateSpriteWithFile = bole.updateSpriteWithFile

local hideWinNodeActTag = 123
local footer_scale = 1
local SPIN_STATUS_NAME = {
    NORMAL_SPIN = "normalspin",
    AUTO_SPIN   = "autospin",
    FREE_SPIN   = "freespin",
}

-- 1 mutiplier 2 interval 3 upDistance 4 locaktime  
local WIN_EFFECT_CONFIG = {
    {
        ["mutiplier"] = 0.3,
        ["upinterval"] = 0,
        ["interval"] = 0.6,
        ["locktime"] = 0,
        ["scale"] = 0,
        ["smallwin"] = 1
    },
    {
        ["mutiplier"] = 0.6,
        ["upinterval"] = 0,
        ["interval"] = 0.8,
        ["locktime"] = 0,
        ["scale"] = 0,
        ["smallwin"] = 1
    },
    {
        ["mutiplier"] = 1,
        ["upinterval"] = 0,
        ["interval"] = 1.2,
        ["locktime"] = 0,
        ["scale"] = 0,
        ["smallwin"] = 1
    },
    {
        ["mutiplier"] = 2,
        ["upinterval"] = 0,
        ["interval"] = 1.8,
        ["locktime"] = 0,
        ["scale"] = 0,
        ["smallwin"] = 1
    },
    {
        ["mutiplier"] = 3,
        ["upinterval"] = 0,
        ["interval"] = 2.4,
        ["locktime"] = 0,
        ["scale"] = 0,
        ["smallwin"] = 1
    },
    {
        ["mutiplier"] = 5,
        ["upinterval"] = 0,
        ["interval"] = 3,
        ["locktime"] = 0,
        ["scale"] = 0,
        ["smallwin"] = 1
    },
    {
        ["mutiplier"] = 10,
        ["upinterval"] = 0.2, -- 0.5,
        ["interval"] = 5,
        ["distance"] = 110,
        -- ["distance"] = 80,
        ["portraitdistance"] = 75,
        -- ["coinMoveTime"] = 0.2,
        ["coinMoveTime"] = 0.25,
        ["coinInterval"] = 1/30,
        -- ["coinDistance"] = 400,
        ["coinDistance"] = 300,
        ["locktime"] = 1,
        ["scale"] = 1,
        ["normalwin"] = 1
    },
    {
        ["mutiplier"] = 25,
        ["upinterval"] = 1,
        ["interval"] = 8,
        ["downinterval"] = 1,
        ["portraitdistance"] = 170,
        ["coinMoveTime"] = 0.3,
        ["coinInterval"] = 1/60,
        ["coinDistance"] = 300,
        ["locktime"] = 1.5,
        ["scale"] = 1.8,
        ["filename"] = "bigwin",
        ["portraitScale"] = 1,
        ["bigwin"] = 1,
        ["label_bg_name"] = "big_win_bg",
        ["label_win_pos"] = cc.p(0, -185),
        ["label_win_pos_v"] = cc.p(0, -185),
        ["show_diamond_config"] = {true, true}, -- 金币，白，绿，紫，红
    },
    {
        ["mutiplier"] = 50,
        ["upinterval"] = 1,
        ["interval"] = 15,
        ["portraitdistance"] = 210,
        ["coinMoveTime"] = 0.4,
        ["coinInterval"] = 1/70,
        ["coinDistance"] = 400,
        ["locktime"] = 1.5,
        ["scale"] = 2,
        ["filename"] = "huge_win",
        ["portraitScale"] = 1,
        ["bigwin"] = 1,
        ["label_bg_name"] = "huge_win_bg",
        ["show_diamond_blue"] = true,
        ["label_win_pos"] = cc.p(0, -185),
        ["label_win_pos_v"] = cc.p(0, -185),
        ["show_diamond_config"] = {true, true, false, false, true}, -- 金币，白，绿，紫，红
    },
    {
        ["mutiplier"] = 100,
        ["upinterval"] = 1,
        ["interval"] = 25,
        ["portraitdistance"] = 150,
        ["coinMoveTime"] = 0.4,
        ["coinInterval"] = 1/80,
        ["coinDistance"] = 400,
        ["locktime"] = 1.5,
        ["scale"] = 2,
        ["filename"] = "masslvewin",
        ["portraitScale"] = 0.85,
        ["bigwin"] = 1,
        ["show_diamond_blue"] = true,
        ["show_diamond_purple"] = true,
        ["label_bg_name"] = "massive_win_bg",
        ["label_win_pos"] = cc.p(0, -185),
        ["label_win_pos_v"] = cc.p(0, -155),
        ["show_diamond_config"] = {true, true, false, true, true}, -- 金币，白，绿，紫，红
    },
    {
        ["mutiplier"] = -1,
        ["upinterval"] = 1,
        ["interval"] = 25,
        ["portraitdistance"] = 150,
        ["coinMoveTime"] = 0.4,
        ["coinInterval"] = 1/90,
        ["coinDistance"] = 400,
        ["locktime"] = 1.5,
        ["scale"] = 2,
        ["filename"] = "apocalyptlcwin",
        ["portraitScale"] = 0.68,
        ["bigwin"] = 1,
        ["show_diamond_blue"] = true,
        ["show_diamond_purple"] = true,
        ["label_bg_name"] = "eff_bg",
        ["label_win_pos"] = cc.p(0, -185),
        ["label_win_pos_v"] = cc.p(0, -145),
        ["show_diamond_config"] = {true, true, true, true, true}, -- 金币，白，绿，紫，红
    },
}

local TOTAL_BET_THRESHOLD = 1000000

-------------------------------------------------------------------
-- footer
-------------------------------------------------------------------
function Footer:parserWinLabelFunc(num)
    return bole.dealValueToRetString(num, -1, nil, false)--'$' ..
end
function Footer:ctor( ctl, isPortrait)
    self.versionCode = self:getVersionCode()
    self.ctl         = ctl
    self.isPortrait = isPortrait
    self.isFreeSpin  = false
    self.showLoungePointsBigFlag = 0
    self.showLoungePointsBigFirst = 0
    G_THEME_FAST_TAG = false

    self.is_show_unlock_bubble = true

    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    -- 创建footer node
    self.node = createNode(self, 1)
    self.node:setScale(HEADER_FOOTER_SCALE)
  
    ----------------------------------------------------------------------
    local footerConfig = HeaderFooterConfig.footer_config_list[1]
    self.footerConfig = footerConfig
    -- 配置footer背景
    local bg_config = footerConfig.background
    self:configBackground (bg_config)


    -- 配置total bet
    local totalbet_config = footerConfig.totalbet
    self:configTotalbet(totalbet_config)

    -- 配置free games
    local freegames_config = footerConfig.freegames
    self:configFreegames(freegames_config)

    -- -- 配置total win
    local totalwin_config = footerConfig.totalwin
    self:configTotalwin (totalwin_config)

    -- 配置max bet
    local maxbet_config = footerConfig.maxbet
    self:configMaxbet(maxbet_config)

    -- 配置spin
    local spin_config = footerConfig.spin
    self:configSpin(spin_config)
    
    self:listenEvent()
end

function Footer:listenEvent()

    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.ALL_SHOW_QUIET, "Footer", self._showActivityNode, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_QUIET, "Footer", self._hideActivityNode, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.ALL_SHOW_ACTION, "Footer", self._showActivityNode, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION, "Footer", self._hideActivityNode, self)
    EventCenter:registerEvent(EVENTNAMES.THEME.FOOTER_HIDE, "Footer", self._hideFooterNode, self)
    EventCenter:registerEvent(EVENTNAMES.THEME.FOOTER_SHOW, "Footer", self._showFooterNode, self)
    EventCenter:registerEvent(EVENTNAMES.THEME.CHANGE_KEYBOARD_TOUCH, "Footer", self._changeDialogTouch, self)
    -- EventCenter:registerEvent(EVENTNAMES.MISSIONPASS.MP_CHANGE_THEME_FOOTER_SHOWTYPE_TO_MP, "Footer", function ( ... )
    --     if not libUI.isValidNode(self) then return end
    --     self:_changeDashboardShowType(3)
    -- end)
end

function Footer:_changeDialogTouch(data)
    local data = data or {}
    self.keySpaceDialogFunc = data.touch_func
end

---@desc 显示footer
function Footer:_showFooterNode(action)
    if not libUI.isValidNode(self) then
        return
    end
    if self.node and bole.isValidNode(self.node) then
        local tag1 = 10001
        local tag2 = 10002
        local a1 = cc.MoveTo:create(10 / 30, cc.p(0, 0))
        if action and action[1] and type(action[1]) == "userdata" and action[1].setTag then
            table.insert(action, a1)
            a1 = cc.Sequence:create(bole.unpack(action))
        end
        a1:setTag(tag1)
        self.node:stopActionByTag(tag1)
        self.node:stopActionByTag(tag2)
        self.node:setVisible(true)
        self.node:runAction(a1)
    end
end

---@desc 隐藏footer
---args1 bool 最终是否隐藏footer 
-- @param args 参数1 和 参数2 同时是 true的时候不播放消失动画，直接隐藏
function Footer:_hideFooterNode(args)
    if not libUI.isValidNode(self) then
        return
    end
    if self.node and bole.isValidNode(self.node) then
        local args = args or {} -- { ... }
        local tag1 = 10001
        local tag2 = 10002
        local actionList = {}
        local a1 = cc.MoveTo:create(10 / 30, cc.p(0, -100))
        if ScreenControl:getInstance().isPortrait then
            a1 = cc.MoveTo:create(10 / 30, cc.p(0, -300))
        end
        if not args[2] then -- 是否需要隐藏动画
            table.insert(actionList, a1)
        end
        if args[1] then
            local nextAction = cc.Hide:create()
            table.insert(actionList, nextAction)
        end
        local a3 = cc.CallFunc:create(function()
            self:displayAutoplayInterface()
        end)
        table.insert(actionList, a3)
        if table.nums(actionList) > 0 then
            local action = cc.Sequence:create(unpack(actionList))
            action:setTag(tag2)
            self.node:stopActionByTag(tag1)
            self.node:stopActionByTag(tag2)
            self.node:runAction(action)
        end
    end
end

function Footer:runShowAnimation()
    self.node:setPosition(cc.p(0, -180))
    local action = cc.MoveTo:create(0.3, cc.p(0, 0))
    self.node:runAction(action)
end

function Footer:cancelEvent()
    EventCenter:removeTag("Footer")
end

function Footer:configBackground (bg_config)
    if bg_config then
        
        if bg_config.leftBg then
            local left = createSprite(self.node,  bg_config.leftBg[1],  bg_config.leftBg[2], 1, bg_config.leftBg[3])
            left:setAnchorPoint(cc.p(1,0.5))
        end
        if bg_config.rightBg then
            local right = createSprite(self.node, bg_config.rightBg[1], bg_config.rightBg[2], 1,bg_config.rightBg[3])
            right:setAnchorPoint(cc.p(0,0.5))
        end
        if bg_config.centerBg then
            local center = createSprite(self.node, bg_config.centerBg[1], bg_config.centerBg[2], 1,bg_config.centerBg[3])
        end

        if bg_config.spine then
            local spineNode = createNode(self.node, 2)
            Theme:addSpineAnimation(spineNode, nil, bg_config.spine[1], bg_config.spine[2], bg_config.spine[3] or "animation",nil,nil,nil,true,true,nil)
        end
    end
end




--------------  Dashboard --------------
-- 设置dashboard节点显示，给外部调用
function Footer:displayDashboard(show)
    local ui = self.dashboard or {}
    if not libUI.isValidNode(ui.node) then return end

    if ui.node then
        ui.node:setVisible(show)
    end
end
-- 刷新显示逻辑
function Footer:refreshDashboard()
    local ui = self.dashboard or {}
    if not libUI.isValidNode(ui.node) then return end
    
    if not self:_checkDashboardUnlock() then return end

    if not self:_checkDashboardNewFinish() then
        if self:_checkDashboardShowTypeEnable(self.dashboard.showType) then
            -- 没有新任务完成，当前类型可显示，刷新当前，bc任务完成后会消失
            self:_refreshDashboardShowTypeUI(self.dashboard.showType)
        else
            -- 切换到下一个可以显示的类型
            self:_nextDashboardShowType()
        end
    end
end

function Footer:configFreegames(freegames_config)
    if freegames_config then
        self.freegamesNode = createNode(self.node, 3, cc.p(freegames_config.position.x*footer_scale,freegames_config.position.y))
        local fg_bg = createSprite(self.freegamesNode, freegames_config.bgImage[1], freegames_config.bgImage[2], 1, nil)
        fg_bg:setScaleX(freegames_config.bgImage[3] or 1)
        self.labelFSCnt  = createFont(self.freegamesNode, freegames_config.labelCount[1], freegames_config.labelCount[2], freegames_config.labelCount[3], 2)
        self.labelFSCnt:setString("")
        self.labelFSCnt.scale = freegames_config.labelCount[3]
        self.labelFSCnt.width = freegames_config.labelCount[4]
        self.labelFsTip = createSprite(self.freegamesNode, freegames_config.labelImage[1], freegames_config.labelImage[2], 3, nil)
        self.freegamesNode:setVisible(false)
    end
end

function Footer:configTotalbet(totalbet_config)
    if totalbet_config then

        self.maxBetSpine = totalbet_config.max_bet_spine

        self.totalbetNode = createNode(self.node, 3, cc.p(totalbet_config.position.x*footer_scale,totalbet_config.position.y))
        self.betBg1 = createSprite(self.totalbetNode, totalbet_config.bigBgImage[1], totalbet_config.bigBgImage[2], 1, nil)
        self.betBg2 = createSprite(self.totalbetNode, totalbet_config.smallBgImage[1], totalbet_config.smallBgImage[2], 1, nil)
        self.betBg2:setVisible(false)
        self.betBg1:setScaleX(totalbet_config.bigBgImage[3] or 1)
        self.betBg2:setScaleX(totalbet_config.smallBgImage[3] or 1)

        local touchUpBet = function (...)
            if self.showLoungePointsBigFirst == 0 then
                self.showLoungePointsBigFirst = 1
            end
            self.ctl:changeToUpBet()
            local isMaxBet = self.ctl:checkIsMaxBet()
            if isMaxBet == true then
                self:showMaxBetEffect()
            end
            self:displayAutoplayInterface(false)
            EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_ADDBET)
        end

        self.btnAddBet = createButton (self.totalbetNode, touchUpBet, totalbet_config.addButton[1], totalbet_config.addButton[2], totalbet_config.addButton[3], totalbet_config.addButton[4], 2)
       if totalbet_config.addButton[5] then
            self.btnAddBet:setScaleX(totalbet_config.addButton[5])
        end

        local touchDownBet = function (...)
            if self.showLoungePointsBigFirst == 0 then
                self.showLoungePointsBigFirst = 1
            end
            self.ctl:changeToDownBet()
            local isMaxBet = self.ctl:checkIsMaxBet()
            if isMaxBet == true then
                self:showMaxBetEffect()
            end
            self:displayAutoplayInterface(false)
            EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_SUBBET)
        end

        self.btnSubBet = createButton (self.totalbetNode, touchDownBet, totalbet_config.subButton[1], totalbet_config.subButton[2], totalbet_config.subButton[3], totalbet_config.subButton[4], 2)
        if totalbet_config.subButton[5] then
            self.btnSubBet:setScaleX(totalbet_config.subButton[5])
        end

        self.labelTotalBet = createFont (self.totalbetNode, totalbet_config.labelBet[1], totalbet_config.labelBet[2], totalbet_config.labelBet[3], 3)
        if self.labelTotalBet then
            self.labelTotalBet.normalPos   = totalbet_config.labelBet[2]
            self.labelTotalBet.normalScale = totalbet_config.labelBet[3]
            self.labelTotalBet.normalWidth = totalbet_config.labelBet[4]
            self.labelTotalBet.freePos     = totalbet_config.labelBet[5]
            self.labelTotalBet.freeScale   = totalbet_config.labelBet[6]
            self.labelTotalBet.freeWidth   = totalbet_config.labelBet[7]
        end
        self.tipBet1 = createSprite(self.totalbetNode, totalbet_config.totalBetImage1[1], totalbet_config.totalBetImage1[2], 4, nil)
        if self.tipBet1 then
        end
        self.tipBet2 = createSprite(self.totalbetNode, totalbet_config.totalBetImage2[1], totalbet_config.totalBetImage2[2], 4, nil)
        if self.tipBet2 then
            self.tipBet2:setVisible(false)
        end
        self.tipBet = self.tipBet1

        self.Node_maxBetChoosedAnimation = createNode (self.totalbetNode, 4)
        self.Node_maxBetChoosedAnimation:setPosition(totalbet_config.animNode)

        self.maxBetChoosedParticle = libUI.createParticle(self.totalbetNode, totalbet_config.particle[1], totalbet_config.particle[2], 5)

        self.totalbetNode.changeToFreeGame = function (isFree)
            self.freegamesNode:setVisible(isFree)
            self.betBg1:setVisible(not isFree)
            self.betBg2:setVisible((isFree and not self.isSFreeSpinLayer))
            self.btnAddBet:setVisible(not isFree)
            self.btnSubBet:setVisible(not isFree)

            if self.jpFlag and self.jpIndex and self.jpIndex > 0 then
                for i = 1, #self.jpFlag do
                    self.jpFlag[i]:setVisible(not isFree and self.jpIndex == i)
                end
            end

            local pos = isFree and self.labelTotalBet.freePos or self.labelTotalBet.normalPos
            if pos then
                self.labelTotalBet:setPosition(pos)
            end

            self.tipBet1:setVisible(not isFree)
            self.tipBet2:setVisible(isFree and not self.isSFreeSpinLayer)
            self.tipBet = (isFree and self.tipBet2) or self.tipBet1
            
        end

        self.totalbetNode.isShowTotalBet = function(isShow,notShowLoungeTip)
            self.betBg1:setVisible(isShow)

            if isShow and self.isFreeSpinLayer and (not self.isSFreeSpinLayer) then 
                self.betBg2:setVisible(isShow)
            else
                self.betBg2:setVisible(false)
            end
            self.btnAddBet:setVisible(isShow)
            self.btnSubBet:setVisible(isShow)
            self.labelTotalBet:setVisible(isShow)
            self.tipBet1:setVisible(isShow)
        end        
    end
end
 


-- function Footer:configRespin (respin_config)
--     if respin_config then
--         self.RCntNode = createNode(self.node, 3, cc.p(respin_config.position.x*HEADER_FOOTER_RATE,respin_config.position.y))
--         createSprite(self.RCntNode, respin_config.bgImage[1], respin_config.bgImage[2], 1, nil)
--         self.labelRCnt  = createFont (self.RCntNode, respin_config.labelCount[1], respin_config.labelCount[2], respin_config.labelCount[3], 2)
--         self.labelRCnt:setString("")
--         createSprite(self.RCntNode, respin_config.labelImage[1], respin_config.labelImage[2], 3, nil)
--         self.spineNode = createNode (self.RCntNode, 4)
--         self.spineNode:setPosition(respin_config.animNode)
--         self.RCntNode:setVisible(false)
--     end
-- end

function Footer:configTotalwin(totalwin_config)
    if totalwin_config then
        self.totalwinNode = createNode (self.node, 4, cc.p(totalwin_config.position.x*footer_scale,totalwin_config.position.y))

        -- Celebration时喷的粒子，放最底层
        self.winParticle = libUI.createParticle(self.totalwinNode, totalwin_config.particle[1], totalwin_config.particle[2], 1)
        if self.winParticle then
            self.winParticle:stopSystem()
            self.winParticle:setVisible(false)
        end

        -- Celebration时喷的金币和BigWin文字 放在第二层
        self.coinNode = createNode(self.totalwinNode, 2)
        self.coinNode:setPosition(totalwin_config.animNode)

        -- win meter层级最高，放在第三层
        self.winNode = createNode(self.totalwinNode, 3)
        self.winNode:setCascadeOpacityEnabled(true)
        self.winNode:setPosition(totalwin_config.animNode)
        -- if libUI.isValidNode(self.winNode) then
        --     self.smallWinBg = libUI.createSprite(self.winNode, totalwin_config.small_win_bg[1], totalwin_config.small_win_bg[2])
        -- end
        self.labelWin = createFont(self.winNode, totalwin_config.winLabel[1], totalwin_config.winLabel[2], totalwin_config.winLabel[3], 2)
        self.labelWin2 = createFont(self.winNode, totalwin_config.effectLabel[1], totalwin_config.effectLabel[2], totalwin_config.effectLabel[3], 2)
        self:setWinCoinsString(0)
        self.labelWin.objString = 0
        -- self.labelWin:setCascadeOpacityEnabled(true)
        self.labelWin:setOpacity(0)
        self.labelWin.baseScale = self.labelWin:getScale()

        self.smallWinSpineName1 = totalwin_config.small_win_spine1
        self.smallWinSpineName2 = totalwin_config.small_win_spine2

        local totalwin_label = createSprite(self.totalwinNode, totalwin_config.label[1], totalwin_config.label[2], 3, nil)
        if totalwin_label then
            totalwin_label:setName("totalwin_label")
        end
        inherit(self.labelWin, LabelNumRoll)
        local parserFunc    = function(mm)
            return self:parserWinLabelFunc(mm)
        end
        self.labelWin:nrInit(0, 24, parserFunc)

        self.labelWin2:setVisible(true)
        -- self.labelWin2:setCascadeOpacityEnabled(true)
        self.labelWin2:setOpacity(0)

        self:playSmallWinSpine()


        -- if libUI.isValidNode(self.smallWinBg) then
        --     self.smallWinBg:setOpacity(0)
        -- end

        inherit(self.labelWin2, LabelNumRoll)
        local parserFunc    = function(mm)
            return self:parserWinLabelFunc(mm)
        end
        self.labelWin2:nrInit(0, 24, parserFunc)

        self.winNode.baseScale = self.winNode:getScale()
        self.winNode.basePositionY = self.winNode:getPositionY()
        self.winNode.basePositionX = self.winNode:getPositionX()
        
    end
end



function Footer:configMaxBetActivated(maxbet_config)
    if not maxbet_config or not maxbet_config.bubble then return end

    self.maxbetBubble = createNode (self.node, 5, cc.p(maxbet_config.bubble[1][3].x*footer_scale,maxbet_config.bubble[1][3].y))
    -- local bubble_image = createSprite(self.maxbetBubble, maxbet_config.bubble[1], maxbet_config.bubble[2], 1, nil)
    createSprite(self.maxbetBubble, maxbet_config.bubble[1][1], maxbet_config.bubble[1][2], 1, nil)
	local tip_text = createFont(self.maxbetBubble, maxbet_config.bubble[2][1], maxbet_config.bubble[2][2], maxbet_config.bubble[2][3], 2)
	if tip_text and maxbet_config.bubble[2][4] then
		-- tip_text:setString(maxbet_config.bubble[2][4])
        bole.ctorUIComponent(tip_text, UIComponent.LanguageLabel)
        tip_text:setOriginFntColor(cc.c3b(183, 74, 21))
        tip_text:setOriginLineHeight(20)
        tip_text:setStringConfig({
            string_type = LANGUAGE_STRING_TYPE.KEY,
            string_key = maxbet_config.bubble[2][4],
        })
	end
    if libUI.isValidNode(self.maxbetBubble) then
        self.maxbetBubble:setVisible(false)
    end
end

function Footer:showMaxBetActivated(show)

    -- if not bole.canDisturbTheme() then
    --     return
    -- end

    if show then
        if self.maxbet_bubble_show then
            return
        end
        -- self:showMaxBetRaiseTip(false)
        local delay = self.maxbet_raise_show and 0.1 or 0
        if libUI.isValidNode(self.maxbetBubble) then
            self.maxbet_bubble_show = true
            self.maxbetBubble:setScale(0.001)
            self.maxbetBubble:setVisible(true)
            self.maxbetBubble:stopAllActions()
            self.maxbetBubble:runAction(cc.Sequence:create(
                cc.CallFunc:create(function ()
                    self:showMaxBetRaiseTip(false)
                end),
                cc.DelayTime:create(delay),
                cc.ScaleTo:create(0.2, 1.1),
                cc.ScaleTo:create(0.1, 1),
                cc.DelayTime:create(3),
                cc.ScaleTo:create(0.1, 0),
                cc.CallFunc:create(function ()
                    self.maxbet_bubble_show = false
                    if libUI.isValidNode(self.maxbetBubble) then
                        self.maxbetBubble:setVisible(false)
                    end
                end)
            ))
        end
    else
        if libUI.isValidNode(self.maxbetBubble) then
            self.maxbetBubble:stopAllActions()
            self.maxbetBubble:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.1, 0),
                cc.CallFunc:create(function ()
                    self.maxbet_bubble_show = false
                    if libUI.isValidNode(self.maxbetBubble) then
                        self.maxbetBubble:setVisible(false)
                    end
                end)
            ))
        end
    end
end

function Footer:configMaxBetRaiseTip(maxbet_config)
	if not maxbet_config or not maxbet_config.raise_tip then return end
	
    local pos = cc.p(0, 0)
    if self.isPortrait then
        if libUI.isValidNode(self.betBg1) then
            local wP = self.betBg1:getParent():convertToWorldSpace(bole.getPos(self.betBg1))
            local cP = self.node:convertToNodeSpace(wP)
            pos = cc.p(cP.x, cP.y + 25)
        end
    else
        if libUI.isValidNode(self.btnAddBet) then
            local wP = self.btnAddBet:getParent():convertToWorldSpace(bole.getPos(self.btnAddBet))
            local cP = self.node:convertToNodeSpace(wP)
            pos = cc.p(cP.x, cP.y + 50)
        end
    end
	self.maxbetRaiseTip = createNode(self.node, 5, pos)
    if maxbet_config.raise_tip.scale and self.maxbetRaiseTip then
        self.maxbetRaiseTip:setScale(maxbet_config.raise_tip.scale)
        self.maxbetRaiseTip.origin_scale = maxbet_config.raise_tip.scale
    end
	createSprite(self.maxbetRaiseTip, maxbet_config.raise_tip.bg[1], maxbet_config.raise_tip.bg[2], 1, nil)
	local tip_text = createFont(self.maxbetRaiseTip, maxbet_config.raise_tip.text[1], maxbet_config.raise_tip.text[2], maxbet_config.raise_tip.text[3], 2)
	if tip_text and maxbet_config.raise_tip.text[4] then
		-- tip_text:setString(maxbet_config.raise_tip.text[4])
        bole.ctorUIComponent(tip_text, UIComponent.LanguageLabel)
        tip_text:setOriginFntColor(cc.c3b(183, 74, 21))
        tip_text:setOriginLineHeight(20)
        tip_text:setStringConfig({
            string_type = LANGUAGE_STRING_TYPE.KEY,
            string_key  = maxbet_config.raise_tip.text[4],
        })
	end
	if libUI.isValidNode(self.maxbetRaiseTip) then
		self.maxbetRaiseTip:setVisible(false)
	end
    if maxbet_config.raise_tip.spine_pos then
        self.click_hand_spine_pos = maxbet_config.raise_tip.spine_pos
    end
end

function Footer:showMaxBetClickSpine(show)
    if not libUI.isValidNode(self.node) or not libUI.isValidNode(self.btnAddBet) then
        return 
    end

    -- 2级之前不要手
    if User:getInstance().level <= 2 then return end

    local spine_path = "userguide/spine/click/spine"
    if self.node and cc.FileUtils:getInstance():isFileExist(spine_path .. ".atlas") then
        if self.node.click_spine == nil and show then
            local wP = self.btnAddBet:getParent():convertToWorldSpace(bole.getPos(self.btnAddBet))
		    local cP = self.node:convertToNodeSpace(wP)
            local pos = self.click_hand_spine_pos or cc.p(0, 0)
            pos.x = cP.x

            local _, s = libUI.addSpineAnimation(self.node, 5, spine_path, pos, "animation", nil, nil, nil, true, true, nil)
            self.node.click_spine = s
        elseif self.node.click_spine and not show then
            self.node.click_spine:removeFromParent()
            self.node.click_spine = nil
        end
    end
end

function Footer:showMaxBetRaiseTip(show)
    if show then
        if self.maxbet_raise_show then
            return
        end
        -- self:showMaxBetActivated(false)
        local delay = self.maxbet_bubble_show and 0.1 or 0
        if libUI.isValidNode(self.maxbetRaiseTip) then
            self.maxbet_raise_show = true
            self.maxbetRaiseTip:setScale(0.001)
            self.maxbetRaiseTip:setVisible(true)
            self.maxbetRaiseTip:stopAllActions()
            local origin_scale = self.maxbetRaiseTip.origin_scale or 1
            self.maxbetRaiseTip:runAction(cc.Sequence:create(
                cc.CallFunc:create(function ()
                    self:showMaxBetActivated(false)
                end),
                cc.DelayTime:create(delay),
                cc.ScaleTo:create(0.2, origin_scale + 0.1),
                cc.ScaleTo:create(0.1, origin_scale),
                cc.CallFunc:create(function ()
                    self:showMaxBetClickSpine(true)
                end),
                cc.DelayTime:create(3),
                cc.CallFunc:create(function ()
                    self:showMaxBetClickSpine(false)
                end),
                cc.ScaleTo:create(0.1, 0),
                cc.CallFunc:create(function ()
                    self.maxbet_raise_show = false
                    if libUI.isValidNode(self.maxbetRaiseTip) then
                        self.maxbetRaiseTip:setVisible(false)
                    end
                end)
            ))
        end
    else
        self:showMaxBetClickSpine(false)
        if libUI.isValidNode(self.maxbetRaiseTip) then
            self.maxbetRaiseTip:stopAllActions()
            self.maxbetRaiseTip:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.1, 0),
                cc.CallFunc:create(function ()
                    self.maxbet_raise_show = false
                    if libUI.isValidNode(self.maxbetRaiseTip) then
                        self.maxbetRaiseTip:setVisible(false)
                    end
                end)
            ))
        end
    end
end

function Footer:configMaxbet (maxbet_config)
    if maxbet_config then

        self.maxbetNode = createNode (self.node, 3, cc.p(maxbet_config.position.x*footer_scale,maxbet_config.position.y))

        local touchFunc = function (...)
            self.ctl:changeToMaxBet()
            self:showMaxBetEffect()
            self:displayAutoplayInterface(false)
            EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_MAXBET)
        end

        self.btnMaxBet = createButton (self.maxbetNode, touchFunc, maxbet_config.button[1], maxbet_config.button[2], maxbet_config.button[3], maxbet_config.button[4], 1)
        if self.btnMaxBet then
        end
        local qidong   = createSprite(self.btnMaxBet, maxbet_config.image[1], maxbet_config.image[2], 1, nil)
        self.btnMaxBet.setMaxState = function(theSelf, isMax)
            qidong:setVisible(isMax)
        end
        --PD: 等待Max bet动画资源
        self:addMaxBetFlash()
    end

end


-- todo无用
function Footer:hideBoosterDimmer(hideInfo)
    -- self.boosterDimmer:setVisible(false)
    -- if hideInfo then
    --     self.boosterInfo:setVisible(false)
    -- end
end

-- todo无用
function Footer:showBoosterTips(show, play, endCallFunc)
    -- if not self.boosterTipsNode then return end

    -- if show then
    --     if play then
    --         local level = User:getInstance().level
    --         local pop_info = ((level - 14)%20 == 0)
    --         if pop_info then
    --             self.boosterDimmer:setVisible(true)
    --         end
    --         self.boosterInfo:setVisible(false)
    --         self.boosterTipsNode:setVisible(true)
    --         self.boosterTipsNode:runAction(cc.Sequence:create(
    --             cc.CallFunc:create(self.boosterTipsAnimation),
    --             cc.DelayTime:create(2.8),
    --             cc.CallFunc:create(function ( ... )
    --                 if pop_info then
    --                     self.boosterInfo:setVisible(true)
    --                     bole.send_codeInfo("record", {pid = PID.cashbackInfo})
    --                 end                                                                                                                                                                   
    --                 self:addEventToBoosterTip()
    --                 if endCallFunc then
    --                     endCallFunc()
    --                 end
    --             end)))

    --     else
    --         self.boosterTipsNode:setVisible(true)
    --         self.boosterDimmer:setVisible(false)
    --         self.boosterInfo:setVisible(false)
    --         self.boosterTipsAnimation(true)
    --     end
    -- else
    --     self.boosterTipsNode:setVisible(false)
    --     self.boosterTipsAnimation(false)
    -- end
end


function Footer:configSpin(spin_config)
    if spin_config then

        self.spinNode = createNode(self.node, 4, cc.p(spin_config.position.x*footer_scale,spin_config.position.y))
        local function onTouchEnded(sender, eventType)
            self.touchLayer:setVisible(false)
            self:stopWinAction()
        end

        local file = "commonpics/kong.png"--self:getPic(bgPath["base"])
        self.touchLayer = Widget.newButton(onTouchEnded, file, file, file)
        self.touchLayer:setScale(1000)
        self.touchLayer:setSwallowTouches(false)
        self.touchLayer:setVisible(false)
        self.spinNode:addChild(self.touchLayer,100)

        ---------------autoplay按钮--------------
        self.autoSpinNode   = createNode (self.spinNode, 1)
        self.autoSpinNode:setPosition(spin_config.autoOn.root)
        self.autoSpinNode:setVisible(false)
        createSprite(self.autoSpinNode, spin_config.autoOn.background[1], spin_config.autoOn.background[2], 1, nil)

        local onAutoTouch = function( autoCount )
            self:displayAutoplayInterface(false)
            self.ctl:setAutoSpinCount(autoCount)
            self.ctl:enableAuto(true)
        end
        local touchAuto10 = function (...)
            onAutoTouch(10)
        end

        self.btnAuto10  = createButton (self.autoSpinNode, touchAuto10, spin_config.autoOn.button10[1], spin_config.autoOn.button10[2], spin_config.autoOn.button10[3], spin_config.autoOn.button10[4], 2)

        local touchAuto20 = function (...)
            onAutoTouch(20)
        end
        self.btnAuto20  = createButton (self.autoSpinNode, touchAuto20, spin_config.autoOn.button20[1], spin_config.autoOn.button20[2], spin_config.autoOn.button20[3], spin_config.autoOn.button20[4], 2)

        local touchAuto50 = function (...)
            onAutoTouch(50)
        end

        self.btnAuto50 = createButton (self.autoSpinNode, touchAuto50, spin_config.autoOn.button50[1], spin_config.autoOn.button50[2], spin_config.autoOn.button50[3], spin_config.autoOn.button50[4], 2)

        local touchAuto100 = function (...)
            onAutoTouch(100)
        end
        self.btnAuto100  = createButton (self.autoSpinNode, touchAuto100, spin_config.autoOn.button100[1], spin_config.autoOn.button100[2], spin_config.autoOn.button100[3], spin_config.autoOn.button100[4], 2)

        local touchAuto500 = function (...)
            onAutoTouch(500)
        end
        self.btnAuto500 = createButton(self.autoSpinNode, touchAuto500, spin_config.autoOn.button500[1], spin_config.autoOn.button500[2], spin_config.autoOn.button500[3], spin_config.autoOn.button500[4], 2)

        local touchAutoFast = function (...)
            onAutoTouch("fast")
        end
        self.btnAutoFast = createButton(self.autoSpinNode, touchAutoFast, spin_config.autoOn.buttonFast[1], spin_config.autoOn.buttonFast[2], spin_config.autoOn.buttonFast[3], spin_config.autoOn.buttonFast[4], 2)

        -- 在这里写创建一个点击事件，点击后选择自动spin次数的弹窗消失
        local disappear_touch = function ()
            self:displayAutoplayInterface(false) -- 点击spin 使autospin 小弹窗消失
        end
        self.disappear_btn  = createButton (self.autoSpinNode, disappear_touch, spin_config.autoOn.disappearButton[1], spin_config.autoOn.disappearButton[1], spin_config.autoOn.disappearButton[1], spin_config.autoOn.disappearButton[2], 1)
        self.disappear_btn:setScale(spin_config.autoOn.disappearButton[3], spin_config.autoOn.disappearButton[4])

        ---------------autostop按钮--------------
        local touchAutoStop = function (...)
            self.ctl:setAutoSpinCount(0)
            self.ctl:enableAuto(false)
        end

        self.btnStop = createButton(self.spinNode, touchAutoStop, spin_config.autoStop.button[1], spin_config.autoStop.button[2], spin_config.autoStop.button[3], spin_config.autoStop.button[4], 2)
        if self.btnStop then
            self.btnStop:setName("btnStop")
        end
        self.btnStop.stop = createSprite(self.btnStop, spin_config.autoStop.labelStop[1], spin_config.autoStop.labelStop[4], 1, nil)
        if self.btnStop.stop then
            self.btnStop.stop:setName("labelStop")
        end
        self.btnStop.stop_fast = createSprite(self.btnStop, spin_config.autoStop.labelStopFast[1], spin_config.autoStop.labelStopFast[4], 1, nil)
        if self.btnStop.stop_fast then
            self.btnStop.stop_fast:setName("stop_fast")
        end

        -- createSprite(self.btnStop, spin_config.autoStop.labelDing[1], spin_config.autoStop.labelDing[2], 2, nil)
        self.btnStop.label_normal = createFont (self.btnStop, spin_config.autoStop.remaining[1], spin_config.autoStop.remaining[3], spin_config.autoStop.remaining[4], 3)
        self.btnStop.label_pressed = createFont (self.btnStop, spin_config.autoStop.remaining[2], spin_config.autoStop.remaining[3], spin_config.autoStop.remaining[4], 3)
        self.btnStop.label_pressed:setPositionY(self.btnStop.label_pressed:getPositionY() - 5)
        local function stopBtnEvent(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                updateSpriteWithFile (self.btnStop.stop, spin_config.autoStop.labelStop[2])
                self.btnStop.stop:setPositionY(spin_config.autoStop.labelStop[4].y - 5)
                self.btnStop.stop_fast:setPositionY(spin_config.autoStop.labelStopFast[4].y - 5)
                self.btnStop.label_normal:setVisible(false)
                self.btnStop.label_pressed:setVisible(true)
            elseif eventType == ccui.TouchEventType.moved then
                local point = sender:getTouchMovePosition()
                point = self.btnStop:convertToNodeSpace(point)
                if point.x < 0 or point.x > self.btnStop:getContentSize().width or point.y < 0 or point.y > self.btnStop:getContentSize().height then
                    -- 移出按钮
                    updateSpriteWithFile (self.btnStop.stop, spin_config.autoStop.labelStop[1])
                    self.btnStop.stop:setPositionY(spin_config.autoStop.labelStop[4].y)
                    self.btnStop.stop_fast:setPositionY(spin_config.autoStop.labelStopFast[4].y)
                    self.btnStop.label_normal:setVisible(true)
                    self.btnStop.label_pressed:setVisible(false)
                else
                    updateSpriteWithFile (self.btnStop.stop, spin_config.autoStop.labelStop[2])
                    self.btnStop.stop:setPositionY(spin_config.autoStop.labelStop[4].y - 5)
                    self.btnStop.stop_fast:setPositionY(spin_config.autoStop.labelStopFast[4].y - 5)
                    self.btnStop.label_normal:setVisible(false)
                    self.btnStop.label_pressed:setVisible(true)
                end
            elseif eventType == ccui.TouchEventType.ended then
                updateSpriteWithFile (self.btnStop.stop, spin_config.autoStop.labelStop[1])
                self.btnStop.stop:setPositionY(spin_config.autoStop.labelStop[4].y)
                self.btnStop.stop_fast:setPositionY(spin_config.autoStop.labelStopFast[4].y)
                self.btnStop.label_normal:setVisible(true)
                self.btnStop.label_pressed:setVisible(false)
                touchAutoStop()
            elseif eventType == ccui.TouchEventType.canceled then
                updateSpriteWithFile (self.btnStop.stop, spin_config.autoStop.labelStop[1])
                self.btnStop.stop:setPositionY(spin_config.autoStop.labelStop[4].y)
                self.btnStop.stop_fast:setPositionY(spin_config.autoStop.labelStopFast[4].y)
                self.btnStop.label_normal:setVisible(true)
                self.btnStop.label_pressed:setVisible(false)
            end
        end
        self.btnStop:addTouchEventListener(stopBtnEvent)



        ---------------spin按钮--------------
        local function spinEvent(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelSpin.enable[2])
                self.btnSpin.spin_l:setPositionY(spin_config.spin.labelSpin.position.y - 5)
                updateSpriteWithFile (self.btnSpin.hold_l, spin_config.spin.labelHold.enable[2])
                self.btnSpin.hold_l:setPositionY(spin_config.spin.labelHold.position.y - 5)
                updateSpriteWithFile (self.btnSpin.stop_l, spin_config.spin.labelStop[2])
                self.btnSpin.stop_l:setPositionY(spin_config.spin.labelStop[4].y - 3)
                self.btnStop.label_normal:setVisible(false)
                self.btnStop.label_pressed:setVisible(true)

                self.isAutoNodeVisible = self.autoSpinNode:isVisible()

                local isBreakSpin = self.ctl:touchSpinCheckDealAutoSpin()
                if not isBreakSpin and not self.isAutoNodeVisible and self:checkCanClickSpin() then
                    self.ctl:touchSpinBtnBegan( self.btnSpin )                
                end
                self:showMaxBetActivated(false)
                -- self:showMaxBetRaiseTip(false)
                return false
            elseif eventType == ccui.TouchEventType.moved then
                local point = sender:getTouchMovePosition()
                point = self.btnSpin:convertToNodeSpace(point)
                if point.x < 0 or point.x > self.btnSpin:getContentSize().width or point.y < 0 or point.y > self.btnSpin:getContentSize().height then
                    -- 移出按钮
                    updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelSpin.enable[1])
                    self.btnSpin.spin_l:setPositionY(spin_config.spin.labelSpin.position.y)
                    updateSpriteWithFile (self.btnSpin.hold_l, spin_config.spin.labelHold.enable[1])
                    self.btnSpin.hold_l:setPositionY(spin_config.spin.labelHold.position.y)
                    updateSpriteWithFile (self.btnSpin.stop_l, spin_config.spin.labelStop[1])
                    self.btnSpin.stop_l:setPositionY(spin_config.spin.labelStop[4].y)
                    self.btnStop.label_normal:setVisible(true)
                    self.btnStop.label_pressed:setVisible(false)
                else
                    updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelSpin.enable[2])
                    self.btnSpin.spin_l:setPositionY(spin_config.spin.labelSpin.position.y - 5)
                    updateSpriteWithFile (self.btnSpin.hold_l, spin_config.spin.labelHold.enable[2])
                    self.btnSpin.hold_l:setPositionY(spin_config.spin.labelHold.position.y - 5)
                    updateSpriteWithFile (self.btnSpin.stop_l, spin_config.spin.labelStop[2])
                    self.btnSpin.stop_l:setPositionY(spin_config.spin.labelStop[4].y - 3)
                    self.btnStop.label_normal:setVisible(false)
                    self.btnStop.label_pressed:setVisible(true)
                end
            elseif eventType == ccui.TouchEventType.ended then
                updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelSpin.enable[1])
                self.btnSpin.spin_l:setPositionY(spin_config.spin.labelSpin.position.y)
                updateSpriteWithFile (self.btnSpin.hold_l, spin_config.spin.labelHold.enable[1])
                self.btnSpin.hold_l:setPositionY(spin_config.spin.labelHold.position.y)
                updateSpriteWithFile (self.btnSpin.stop_l, spin_config.spin.labelStop[1])
                self.btnSpin.stop_l:setPositionY(spin_config.spin.labelStop[4].y)
                self.btnStop.label_normal:setVisible(true)
                self.btnStop.label_pressed:setVisible(false)

                -- self:showSpinNodeClickSpine(false)
                self:stopWinAction()
                -- 用于处理主题中spin按钮的press to start或其他非bet功能
                if self.ctl.theme.spinButtonPressed then
                    self.ctl.theme:spinButtonPressed()
                end

                if not self.autoSpinNode:isVisible() then
                    self.ctl:touchSpinBtnEnded(self.btnSpin )
                else
                    if self.isAutoNodeVisible then
                        self:displayAutoplayInterface(false)
                    end
                end

                EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_SPIN)
                self:hideSpinChargeSpine()

            elseif eventType == ccui.TouchEventType.canceled then
                updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelSpin.enable[1])
                self.btnSpin.spin_l:setPositionY(spin_config.spin.labelSpin.position.y)
                updateSpriteWithFile (self.btnSpin.hold_l, spin_config.spin.labelHold.enable[1])
                self.btnSpin.hold_l:setPositionY(spin_config.spin.labelHold.position.y)
                updateSpriteWithFile (self.btnSpin.stop_l, spin_config.spin.labelStop[1])
                self.btnSpin.stop_l:setPositionY(spin_config.spin.labelStop[4].y)
                self.btnStop.label_normal:setVisible(true)
                self.btnStop.label_pressed:setVisible(false)
                
                self.ctl:touchSpinBtnCanceled( self.btnSpin )
            end
        end

        self.btnSpin = ccui.Button:create()
        self.btnSpin:setName("btnSpin")
        self.btnSpin:setTouchEnabled(true)
        self.btnSpin:loadTextures(spin_config.spin.button[1],spin_config.spin.button[2], spin_config.spin.button[3])
        self.btnSpin:setPosition(spin_config.spin.button[4])
        self.btnSpin:addTouchEventListener(spinEvent)
        self.spinNode:addChild(self.btnSpin, 3)

        self.btnSpin.spin_enable = spin_config.spin.labelSpin.enable
        self.btnSpin.spin_disable = spin_config.spin.labelSpin.disable
        self.btnSpin.hold_enable = spin_config.spin.labelHold.enable
        self.btnSpin.hold_disable = spin_config.spin.labelHold.disable
        self.btnSpin.spin_l  = createSprite(self.btnSpin, self.btnSpin.spin_enable[1], spin_config.spin.labelSpin.position, 1, nil)
        if self.btnSpin.spin_l then
            self.btnSpin.spin_l:setName("spin_l")
        end
        self.btnSpin.hold_l  = createSprite(self.btnSpin, self.btnSpin.hold_enable[1], spin_config.spin.labelHold.position, 1, nil)
        if self.btnSpin.hold_l then
            self.btnSpin.hold_l:setName("hold_l")
        end
        self.btnSpin.stop_l  = createSprite(self.btnSpin, spin_config.spin.labelStop[1], spin_config.spin.labelStop[4], 1, nil)
        if self.btnSpin.stop_l then
            self.btnSpin.stop_l:setName("stop_l")
        end

        self.btnSpin.spin_l._baseScaleX = self.btnSpin.spin_l:getScaleX()
        self.btnSpin.spin_l._baseScaleY = self.btnSpin.spin_l:getScaleY()
        self.btnSpin.hold_l._baseScaleX = self.btnSpin.hold_l:getScaleX()
        self.btnSpin.hold_l._baseScaleY = self.btnSpin.hold_l:getScaleY()

        self.spinNode.changeSpinLabel = function (disable)
            local spin_file = (disable and self.btnSpin.spin_disable) or self.btnSpin.spin_enable[1]
            local hold_file = (disable and self.btnSpin.hold_disable) or self.btnSpin.hold_enable[1]
            updateSpriteWithFile (self.btnSpin.spin_l, spin_file)
            updateSpriteWithFile (self.btnSpin.hold_l, hold_file)
        end

        self.spinNode.changeBtnState = function(theSelf, theState, isStop, isForbid, isSpineGray)

            self.ctl.touchSpinTag = false
            if not (theState and theState=="ingore") then
                theSelf.curStatue  = theState
            end
            if not (isStop and isStop=="ingore") then
                theSelf.isStop  = isStop
            end
            if not (isForbid and isForbid=="ingore") then
                theSelf.isForbid  = isForbid
            end
            theSelf:refreshState()
            if isSpineGray then
                updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelSpin.disable)
            end
        end
        
        self.spinNode.refreshState = function( theSelf )
            if theSelf.curStatue == SPIN_STATUS_NAME.NORMAL_SPIN then
                self.btnSpin.spin_l:setVisible(true)
                self.btnSpin.hold_l:setVisible(true)
                self.btnSpin.stop_l:setVisible(false)
                self.btnSpin:setVisible(true)
                self.btnStop:setVisible(false)
            elseif theSelf.curStatue == SPIN_STATUS_NAME.AUTO_SPIN then
                self.btnSpin:setVisible(false)
                self.btnStop:setVisible(true)
                if self:isAutoSpinFast() then 
                    self.btnStop.stop_fast:setVisible(true)
                    self.btnStop.stop:setVisible(false)
                    self:setAutoplayRemaining("")
                else
                    self.btnStop.stop_fast:setVisible(false)
                    self.btnStop.stop:setVisible(true)
                end
            end

            if theSelf.isStop then
                self.btnSpin.spin_l:setVisible(false)
                self.btnSpin.hold_l:setVisible(false)
                self.btnSpin.stop_l:setVisible(true)
                self.btnSpin:setVisible(true)
                self.btnStop:setVisible(false)
            else
            end
            local touchEnabled = (not theSelf.isForbid) and (not self.autoSpinNode:isVisible())
            if self:checkInAutoSpin() then --self:checkInFreeSpin() or 
                touchEnabled = true
            end            
            self.btnSpin:setTouchEnabled(touchEnabled)
            self.btnSpin:setBright(touchEnabled)
            self.btnStop:setTouchEnabled(touchEnabled)
            self.btnStop:setBright(touchEnabled)
            self.spinNode.changeSpinLabel(not touchEnabled)


            if touchEnabled then
                if self.spinBtnEnableCallback then
                    self.spinBtnEnableCallback()
                    self.spinBtnEnableCallback = nil
                end
                updateSpriteWithFile (self.btnSpin.stop_l, spin_config.spin.labelStop[1])
            else
                updateSpriteWithFile (self.btnSpin.spin_l, spin_config.spin.labelStop[3])
            end

            
            -------------玩家5秒内没有操作，突出Spin按钮，吸引玩家继续拍-----------------------------
            -- if theSelf.curStatue == SPIN_STATUS_NAME.NORMAL_SPIN and not theSelf.isStop and touchEnabled then
            --     self.btnSpin:stopAllActions()
            --     self.btnSpin:runAction(cc.RepeatForever:create(cc.Sequence:create(
            --         cc.DelayTime:create(5),
            --         cc.CallFunc:create(function()
            --             if not self.spinSaoGuang then
            --                 local file = "header_footer/style2/footer/spines/spin/spine"
            --                 local skeleton = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
            --                 skeleton:setAnimation(0, "animation", false) 
            --                 self.btnSpin:addChild(skeleton, 1)
            --                 local size = self.btnSpin:getContentSize()
            --                 skeleton:setPosition(cc.p(size.width/2, size.height/2+2))
            --                 self.spinSaoGuang = skeleton
            --                 skeleton:registerSpineEventHandler(function (event)
            --                     self.spinSaoGuang:setVisible(false)
            --                 end, sp.EventType.ANIMATION_COMPLETE)
            --             else
            --                 self.spinSaoGuang:setVisible(true)
            --                 self.spinSaoGuang:setAnimation(0, "animation", false) 
            --             end

            --             local scaleFunc = function(node, delay)
            --                 local baseScaleX = node._baseScaleX
            --                 local baseScaleY = node._baseScaleY
            --                 node:runAction(cc.Sequence:create(
            --                     cc.DelayTime:create(delay),
            --                     cc.EaseSineOut:create(cc.ScaleTo:create(0.25,baseScaleX*1.05,baseScaleY*1.05)),
            --                     cc.EaseSineIn:create(cc.ScaleTo:create(0.25, baseScaleX, baseScaleY)
            --                 )))
            --             end

            --             scaleFunc(self.btnSpin.spin_l, 0.65)
            --             scaleFunc(self.btnSpin.hold_l, 0.65)
            --         end)
            --     )))
            -- else
            --     self.btnSpin:stopAllActions()
            --     if self.spinSaoGuang then
            --         self.spinSaoGuang:setVisible(false)
            --     end

            --     local resetFunc = function(node)
            --         if node._baseScaleX > node:getScaleX() then
            --             node:stopAllActions()
            --             node:setScaleX(node._baseScaleX)
            --             node:setScaleY(node._baseScaleY)
            --         end
            --     end
            --     resetFunc(self.btnSpin.spin_l)
            --     resetFunc(self.btnSpin.hold_l)
            -- end
        end
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, false, false)

        self.canSpin = true

        -- self:showSpinNodeUserGuide()
        
        self.copyBtnEvent = function ( ... )
            if self.btnSpin:isVisible() and self.btnSpin:isTouchEnabled() then
                spinEvent(nil,ccui.TouchEventType.began)
                spinEvent(nil,ccui.TouchEventType.ended)
            elseif self.btnStop:isVisible() and self.btnStop:isTouchEnabled() then
                stopBtnEvent(nil,ccui.TouchEventType.began)
                stopBtnEvent(nil,ccui.TouchEventType.ended)
            end
        end
            
        if spin_config.spin and spin_config.spin.spineCharge then
            self.spinChargeSpineConfig = spin_config.spin.spineCharge
        end

        local listener = cc.EventListenerKeyboard:create()
        local function onKeyReleased(keyCode, event)
            if keyCode == cc.KeyCode.KEY_SPACE then
                if self.keySpaceDialogFunc then
                    self.keySpaceDialogFunc()
                else
                    self.copyBtnEvent()
                end
            end
        end
        listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
        local eventDispatcher = self.spinNode:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, bole.scene) -- self.spinNode

    end

end

function Footer:playSpinChargeSpine()
    if not self.spinChargeSpineConfig then 
        return 
    end

    if not libUI.isValidNode(self.spinNode) then 
        return 
    end
 
    local _, s = libUI.addSpineAnimation(self.spinNode, 4, self.spinChargeSpineConfig[1], self.spinChargeSpineConfig[2], "animation", nil, nil, nil, true, false, nil)
    self.spinChargeSpine = s
end

function Footer:hideSpinChargeSpine()
    if libUI.isValidNode(self.spinChargeSpine) then
        self.spinChargeSpine:removeFromParent()
        self.spinChargeSpine = nil
    end
end

function Footer:isSpinBtnCanTouch()
    if libUI.isValidNode(self.btnSpin) then
        return self.btnSpin:isVisible() and self.btnSpin:isTouchEnabled()
    end
end

function Footer:isStopBtnCanTouch()
    if libUI.isValidNode(self.btnStop) then
        return self.btnStop:isVisible() and self.btnStop:isTouchEnabled()
    end
end

function Footer:setSpinBtnEnableCallback(callback)
    self.spinBtnEnableCallback = callback
end

function Footer:copySpinBtnEvent()
    if self.copyBtnEvent then
        self.copyBtnEvent()
    end
end

function Footer:showSpinNodeUserGuide() -- 新手引导spin按钮引导特效
    if UserGuideControl:getInstance():isUserGuideSpinClick() then -- 如果满足展示条件，则展示特效
        self:showSpinNodeClickSpine(true)
    end
end

function Footer:showSpinNodeClickSpine(show)
    if not libUI.isValidNode(self.spinNode) then
        return 
    end
    local spine_path = "userguide/spine/click/spine"
    if self.spinNode and cc.FileUtils:getInstance():isFileExist(spine_path .. ".atlas") then
        if self.spinNode.click_spine == nil and show then
            local _, s = libUI.addSpineAnimation(self.spinNode, 4, spine_path, cc.p(0, 20), "animation", nil, nil, nil, true, true, nil)
            self.spinNode.click_spine = s
            -- UserGuideControl:getInstance():setUserGuideSpinClick()-- 注释掉flag
        elseif self.spinNode.click_spine and not show then
            self.spinNode.click_spine:removeFromParent()
            self.spinNode.click_spine = nil
        end
    end
end

-----------------------循环播放赢钱框上的背景粒子动画-------------------


function Footer:getVersionCode()
    -- todo
end
function Footer:addSpinLightAction(...)
    -- todo
end
function Footer:initEvent( ... )

end

--------------------配置Auto Play相关--------------------------------
function Footer:displayAutoplayInterface(show)
    self.autoSpinNode:setVisible(show)
    --self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, "ingore", "ingore")
end   

function Footer:setAutoplayRemaining(count)
    if self:isAutoSpinFast() then
        count = ""
    end
    self.btnStop.label_normal:setString(tostring(count))
    self.btnStop.label_pressed:setString(tostring(count))
end 

     

-------------------获取当前Fast Play状态-----------------------------
function Footer:getTurboStatus( ... )
    return G_THEME_FAST_TAG
end
--------------------------------------------------------------------
function Footer:changeFreeSpinLayout( ... ) -- free 状态1 (正常显示 free 计数和bet)
    if self.isFreeSpinLayer then return end
    self.totalbetNode.changeToFreeGame(true)
    self:updateTotalBetLabelShrink(true)
    self.isFreeSpinLayer = true
end

function Footer:changeFreeSpinLayout2( ... ) -- free 状态2 不需要更 成 FreeGame Layout，只标记状态
    if self.isFreeSpinLayer then return end
    self.isFreeSpinLayer = true
end

function Footer:changeFreeSpinLayout3( ... ) -- free 状态3 用于BonusGame中的Free Spin (whj:用于隐藏bet 的 freeSpin)
    self.totalbetNode.changeToFreeGame(true)
    self.tipBet2:setVisible(false)
    self.betBg2:setVisible(false)
    self.labelTotalBet:setVisible(false)
    self.isSFreeSpinLayer = true
end

function Footer:changeRespinLayerState( state )
    self.isRespinLayer = state
end

-- function Footer:showRespinLayout( ... )
--     if self.isRespinLayer then return end
    
--     -- 显示 节点
--     self.RCntNode:setVisible(true)
--     self.isRespinLayer = true
--     -- spine 动画显示
--     local _,s1 = Theme:addSpineAnimation(self.spineNode, nil, "header_footer/style2/footer/spines/respin/spine", cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
--     self.respinSpine = s1
-- end

-- function Footer:hideRespinLayout( ... )
--     if self.isRespinLayer== false then return end
    
--     -- 隐藏 节点
--     self.RCntNode:setVisible(false)
--     self.isRespinLayer = false
--     if self.respinSpine then 
--         self.respinSpine:removeFromParent()
--     end
-- end

function Footer:changeNormalLayout( ... ) -- 从 free 状态1 恢复 成 base
    if (self.isFreeSpinLayer == false and self.isSFreeSpinLayer == false) then return end
    self.totalbetNode.changeToFreeGame(false)
    self.isFreeSpinLayer = false
    self.isSFreeSpinLayer = false
end

function Footer:changeNormalLayout2( ... ) -- 从 free 状态3 恢复 成 base用于Bonus Game中的FreeSpin Layout的恢复
    self.totalbetNode.changeToFreeGame(false)
    self.labelTotalBet:setVisible(true)
    self.isSFreeSpinLayer = false
end
---@desc is used for hideing the bet in bonus -- added by whj
function Footer:isShowTotalBetLayout(isShow,notShowLoungeTip)
    self.totalbetNode.isShowTotalBet(isShow,notShowLoungeTip)
end

---@desc can be used in base and free  -- added by whj
---@param isShow
---@param notShowLoungeTip  @desc notshow the loungeTip Dialog
function Footer:isShowTotalBetLayout2(isShow,notShowLoungeTip)
    self.totalbetNode.isShowTotalBet(isShow,notShowLoungeTip)
    if self.isFreeSpinLayer then
        if isShow then
            self.totalbetNode.changeToFreeGame(isShow)
        end
        self.tipBet2:setVisible(isShow)
        self.betBg2:setVisible(isShow)
        self.labelTotalBet:setVisible(isShow)
    end
end

-------------------------------------------------------------------
-- label相关
---------------------设置FreeGames 当前spin次数 of 总spin次数 -------
function Footer:setFreeSpinLabel(leftCnt, sumCnt)
    if libUI.isValidNode(self.labelFSCnt) and self.labelFSCnt.scale and self.labelFSCnt.width then
        self.labelFSCnt:setString((sumCnt-leftCnt).."/"..sumCnt)
        bole.shrinkLabel(self.labelFSCnt, self.labelFSCnt.width, self.labelFSCnt.scale)
    end
end

---------------------设置Respin SPIN 剩余次数 OF -------
function Footer:setRespinLabel( cur,sum )
    self.labelRCnt:setString("SPIN "..cur.." OF "..sum)
end



--------------------设置total bet值--------------------------------
function Footer:isFree_totalbet(n)
    local last
    if n > 999999999999999999 then -- 21
        n = n / 1000000000
        n = math.floor(n)
        last = "Q"
        return FONTS.format(n, true) .. last
    elseif n > 9999999999999999 then -- 18
        n = n / 1000000000
        n = math.floor(n)
        last = "T"
        return FONTS.format(n, true) .. last
    elseif n > 99999999999999 then -- 15
        n = n / 1000000000
        n = math.floor(n)
        last = "B"
        return FONTS.format(n, true) .. last
    elseif n > 999999999999 then -- 12
        n = n / 1000000
        n = math.floor(n)
        last = "M"
        return FONTS.format(n, true) .. last
    elseif n > 999999999 then  -- 9
        n = n / 1000
        n = math.floor(n)
        last = "K"
        return FONTS.format(n, true) .. last
    else 
        return FONTS.format(n, true)
    end
end
function Footer:setBetInfo( bet, curBetMul, total,isFree )  
    total = total or bet*curBetMul

    if libUI.isValidNode(self.labelTotalBet) then
        if isFree and self.labelTotalBet.freeScale and self.labelTotalBet.freeWidth then
            self.labelTotalBet:setString(self:isFree_totalbet(total))
            bole.shrinkLabel(self.labelTotalBet, self.labelTotalBet.freeWidth, self.labelTotalBet.freeScale)
        elseif self.labelTotalBet.normalScale and self.labelTotalBet.normalWidth then
            self.labelTotalBet:setString(FONTS.format(total,true))
            bole.shrinkLabel(self.labelTotalBet, self.labelTotalBet.normalWidth, self.labelTotalBet.normalScale)
            -- self:showJPFlag(total)
            self:showLoungePointsTip(total)
            self:showRaiseYourBetToMakeQualifiedSpinForYourFriends(total)
        end
    end
end

-- qsj
function Footer:showRaiseYourBetToMakeQualifiedSpinForYourFriends(total)
    -- bet得到当前赌局的下注数量，是一个number
    -- 判断当前赌资是否是最低赌资 + 是否该玩家第一次进入游戏
    if not libUI.isValidNode(self.jpTips) then
        return 
    end
    self.jpTips:setVisible (false)
    if not ActivityCenterControl:getInstance ():canPlay ("specialcare_voucher") then return end
    local voucher_jp_data = ActivityCenterControl:getInstance():getSpecialCareBetData()
    if not voucher_jp_data then return end
    if UserGuideControl:getInstance():isNewUser() or total < voucher_jp_data [4] then -- voucher_jp_data [4]是最抵挡
        if not self:checkInFreeSpin() then
            self.jpTips:setVisible (true)
            self.jpTips:stopAllActions()
            self.jpTips:runAction(cc.Sequence:create(
                cc.CallFunc:create (
                    function ( )
                    end
                ),
                cc.DelayTime:create(3),
                cc.CallFunc:create(
                    function( ) 
                        self.jpTips:setVisible(false) 
                    end
                ))) 
        end
    end
end

function Footer:showJPFlag(total)
    ActivityCenterControl:getInstance():setThemeFooterFlag(false)
    local actCtl          = ActivityCenterControl:getInstance()
    local voucher_jp_data = actCtl:getSpecialCareBetData()
    local total           = self.labelTotalBet:getString()
    local total1          = string.gsub(total, ",", "")
    local total2          = tonumber(total1)
    if self.jpFlag and voucher_jp_data and total2 then
        local temp_index = 0
        for i = 1, #voucher_jp_data do
            if total2 >= voucher_jp_data[i] then
                temp_index = i
                break
            end
        end

        temp_index = actCtl:canPlay("specialcare_voucher") and temp_index or 0

        if temp_index > 0 then
            ActivityCenterControl:getInstance():setThemeFooterFlag(true)
        end
        if self.jpIndex == nil or self.jpIndex ~= temp_index then
            self.jpIndex = temp_index
            for i = 1, #self.jpFlag do
                if self.jpFlag[i] then
                    self.jpFlag[i]:setVisible(temp_index == i)
                end
                if self.jpFlag[i].big then
                    self.jpFlag[i].big:setVisible(temp_index == i)
                end
            end

            if self.jpFlag and libUI.isValidNode(self.jpFlag[temp_index]) and libUI.isValidNode(self.jpFlag[temp_index].big) then
                self.jpFlag[temp_index].big:stopAllActions()
                self.jpFlag[temp_index].big:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function( ) self.jpFlag[temp_index].big:setVisible(false) end))) 
            end

        end

    end
end

function Footer:updateTotalBetLabelShrink( isFree )

    if libUI.isValidNode(self.labelTotalBet) then
        if isFree and self.labelTotalBet.freeScale and self.labelTotalBet.freeWidth then
            bole.shrinkLabel(self.labelTotalBet, self.labelTotalBet.freeWidth, self.labelTotalBet.freeScale)
        elseif self.labelTotalBet.normalScale and self.labelTotalBet.normalWidth then
            bole.shrinkLabel(self.labelTotalBet, self.labelTotalBet.normalWidth, self.labelTotalBet.normalScale)
        end
    end

end

function Footer:showLoungePointsTip(total)
    if self.loungePointsBet and self.loungePointsFadeBet and self.loungePointsFadeBet2 and not UserGuideControl:getInstance():isNewUser() then
        local lounge_points_bet = LobbyControl:getInstance():getLoungeSpinBet()
        if  not lounge_points_bet then
            return
        end
        -- local info = "RAISE BET TO " .. FONTS.format(lounge_points_bet,true) .. " TO GET"
        -- self.loungePointsBet:setString(FONTS.format(lounge_points_bet,true))
        -- for i = 1, 9 do
        --     info = string.gsub(info, tostring(i), " ")
        -- end 
        -- info = string.gsub(info, tostring(0), " ")
        -- info = string.gsub(info, ",", " ")
        
        self.center_pos_x = self.center_pos_x or self.loungePointsBet:getPositionX()

        -- self.loungePointsFadeBet:setString("RAISE BET TO")
        self.loungePointsFadeBet:setStringConfig({
            string_type = LANGUAGE_STRING_TYPE.KEY,
            string_key  = "LOBBY.raise_bet_to"
        })
        local width1 = self.loungePointsFadeBet:getContentSize().width

        self.loungePointsBet:setString(" " .. FONTS.format(lounge_points_bet,true))
        local width2 = self.loungePointsBet:getContentSize().width

        -- self.loungePointsFadeBet2:setString(" TO GET")
        self.loungePointsFadeBet2:setStringConfig({
            string_type = LANGUAGE_STRING_TYPE.KEY,
            string_key  = "LOBBY.to_go"
        })
        local width3 = self.loungePointsFadeBet2:getContentSize().width

        local start_pos_x = self.center_pos_x - (width1 + width2 + width3) / 2

        self.loungePointsFadeBet:setPositionX(start_pos_x)
        self.loungePointsBet:setPositionX(start_pos_x + width1)
        self.loungePointsFadeBet2:setPositionX(start_pos_x + width1 + width2)

        local show_big = 0
        if total >= lounge_points_bet then
            show_big = 1
        else
            show_big = 2
        end

        if self.showLoungePointsBigFlag == show_big then
            self.loungePointsNode:setVisible(false)
        else
            self:playLoungePointsTip(show_big)
        end

        if self.showLoungePointsBigFirst == 1 then
            self.showLoungePointsBigFirst = 2
            self:playLoungePointsTip(show_big)
        end

    end
end

function Footer:playLoungePointsTip(show_big)
    if ActivityCenterControl:getInstance():getThemeFooterFlag() or ActivityCenterControl:getInstance():canPlay("specialcare_voucher") then
        self.loungePointsNode:setVisible(false)
        return 
    end
    ActivityCenterControl:getInstance():setThemeFooterFlag(true)
    self.loungePointsNode:setVisible(true)
    self.bigLoungePointsNode:setVisible(show_big == 1)
    self.smallLoungePointsNode:setVisible(not (show_big == 1))
    self.showLoungePointsBigFlag = show_big
    self.loungePointsNode:stopAllActions()
    self.loungePointsNode:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(function( ) self.loungePointsNode:setVisible(false) end)))      
end

-----------------------------------------------------------------
function Footer:setWinCoins( coins , start, tb)  -- tb:totalBet
    start = start or 0
    coins = coins or 0
    tb    = tb    or 0    
    if coins==0 then
        if not self:checkInFreeSpin() then
            self.labelWin.objString = nil
            self:changeLabelDescription("notFS_notWin")
        else
            self:changeLabelDescription("FS_notWin")
        end
    else
        self.labelWin:stopAllActions()
        self:showWinNode()
        self.labelWin:setOpacity(255)
        self.labelWin2:setOpacity(0)

        self:playSmallWinSpine()

        -- if libUI.isValidNode(self.smallWinBg) then
        --     self.smallWinBg:setOpacity(0)
        -- end

        if coins>0 and tb>0 then
            if self:checkInFreeSpin() then
                self:changeLabelDescription("FS_Win", coins)
            else
                self:changeLabelDescription("notFS_Win")
            end
            -- local dur = 0.4
            self.labelWin:setString(FONTS.format(start+coins,true))--(self:parserWinLabelFunc(number))
            local max_width = (self.isPortrait and 500 or 450)
            bole.shrinkLabel (self.labelWin, max_width, 1)
            self.labelWin:setString(start)
            
            local dur = 0.7
            self.labelWin:nrStartRoll(start, start+coins, dur)
        else
            self:setWinCoinsString(start+coins)
        end
        self.labelWin.objString = start+coins
    end
end

function Footer:_getEffectConfig(muti)
    for k,v in pairs(WIN_EFFECT_CONFIG) do
        if v["mutiplier"] == -1 then
            return v
        end
        if v["mutiplier"]>muti then
            return v
        end
    end
end

-- 赢钱动画效果，根据不同的倍数，显示不同的效果
function Footer:setWinCoinsEffect( coins , start, tb, endCallFunc)  -- tb:totalBet
    coins = coins or 0
    if(coins>0) then
        self.winCallback = endCallFunc
        local muti = coins/tb
        self:realSetWinCoinsEffect(coins , start, muti)
    elseif endCallFunc then
        endCallFunc()
    end
end

function Footer:setWinCoinsEffectByMuti(coins, start, endCallFunc,muti)
    if(coins>0) then
        self.winCallback = endCallFunc
        local muti = muti
        self:realSetWinCoinsEffect(coins, start, muti)
    elseif endCallFunc then
        endCallFunc()
    end
end

function Footer:realSetWinCoinsEffect(coins , start, muti)
    if self.showingWinEffect then
        return
    end
    self.showingWinEffect = true
    self.cMuti = muti
    self.cCoins = coins
    self.cStartCoins = start
    self.cEffectConfig = self:_getEffectConfig(self.cMuti)
    self.winNode:stopActionByTag(hideWinNodeActTag)
    if(self.cEffectConfig["smallwin"]) then
        self.ctl.theme:playRollupSound(self.cMuti)
        self:showWinNode()
        self.isSamllWinpop = true
        self.labelWin:setOpacity(255)
        self.labelWin2:setOpacity(0)

        self:playSmallWinSpine()


        self:updateWin(coins,start,self.cEffectConfig["interval"]+self.cEffectConfig["upinterval"],false)
        local action = cc.Sequence:create(cc.DelayTime:create(self.cEffectConfig["interval"] - self.cEffectConfig["upinterval"]), cc.CallFunc:create(function( )
            self:stopSmallWinEffect()
        end))
        self.winNode:runAction(action)
    elseif (self.cEffectConfig["normalwin"]) then
        self.ctl.theme:playRollupSound(self.cMuti)
        self:showWinNode()
        self.isNormalWinpop = true
        self.labelWin:setOpacity(0)
        self.labelWin2:setOpacity(255)
        self:showWinEffect()
        self.labelWin2:setString(self:parserWinLabelFunc(coins))
        
        local endWidth = self.labelWin2:getContentSize().width*self.labelWin2:getScaleX()
        self:updateWin(coins, start, self.cEffectConfig["interval"]+self.cEffectConfig["upinterval"], true)

        self:playSmallWinSpine(true)

        local tempScale = self.cEffectConfig["scale"]
        tempScale = 700/endWidth
        local scaleSize = tempScale < self.cEffectConfig["scale"] and tempScale or self.cEffectConfig["scale"]
        local moveDis = self.isPortrait and self.cEffectConfig["portraitdistance"] or self.cEffectConfig["distance"]
        local moveTo = cc.MoveBy:create(self.cEffectConfig["upinterval"],cc.p(0,moveDis))
        local moveBack = cc.MoveBy:create(self.cEffectConfig["upinterval"],cc.p(0,-moveDis))
        local scaleTo = cc.ScaleTo:create(self.cEffectConfig["upinterval"],scaleSize)
        local scaleBack = cc.ScaleTo:create(self.cEffectConfig["upinterval"],self.winNode.baseScale)
        local moveUp = cc.Spawn:create(moveTo,scaleTo)
        local moveDown = cc.Spawn:create(moveBack,scaleBack)
        local action = cc.Sequence:create(moveUp, cc.DelayTime:create(self.cEffectConfig["interval"] - self.cEffectConfig["upinterval"]), cc.CallFunc:create(function( )
            self:stopNormalWinEffect()
            self:playSmallWinSpine(false)
        end))
        self.winNode:runAction(action)
    elseif(self.cEffectConfig["bigwin"]) then
        self.isBigWinpop = true
        self.effectNode = createNode(self.node,10)
        if self.isPortrait then
            self.effectNode:setPosition(cc.p(0,FRAME_WIDTH/2))
        else
            self.effectNode:setPosition(bole.getNodePos(self.effectNode, cc.p(FRAME_WIDTH/2, FRAME_HEIGHT/2 - 40*HEADER_FOOTER_SCALE_H)))
        end
        local action = cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function( )
                self.ctl.theme:playRollupSound(self.cMuti)
                self:showWinNode()
                self:showBigWinEffect(coins)
            end),
            cc.DelayTime:create(self.cEffectConfig["interval"]),
            cc.CallFunc:create(function( )
                self:stopBigWinEffect(false)
            end))
        self.effectNode:runAction(action)
    end
    if self.cEffectConfig["locktime"]>0 then
        self.islocked = true
        self.spinNode:changeBtnState("ingore", "ingore", true)
        self.node:runAction(cc.Sequence:create(cc.DelayTime:create(self.cEffectConfig["locktime"]),cc.CallFunc:create(function( )
            self.islocked = false
            self.touchLayer:setVisible(true)
            self.spinNode:changeBtnState("ingore", "ingore", false)
        end)))
    else
        self.spinNode:changeBtnState("ingore", false, false)
        self.islocked = false
    end
end

function Footer:playSmallWinSpine(show)

    if self.smallWinSpineName1 then
        if show and libUI.isValidNode(self.winNode) then
            local _, s = libUI.addSpineAnimation(self.winNode, nil, self.smallWinSpineName1[1], self.smallWinSpineName1[2], "animation", nil, nil, nil, true, true, nil)
            s:setOpacity(0)
            s:runAction(cc.FadeTo:create(0.2, 255))
            self.smallWinSpine1 = s
        elseif libUI.isValidNode(self.smallWinSpine1) then
            self.smallWinSpine1:runAction(cc.Sequence:create(
                cc.FadeTo:create(0.2, 0),
                cc.CallFunc:create(function ()
                    if libUI.isValidNode(self.smallWinSpine1) then
                        self.smallWinSpine1:removeFromParent()
                        self.smallWinSpine1 = nil
                    end
                end)
                ))
        end
    end

    if self.smallWinSpineName2 then
        if show and libUI.isValidNode(self.winNode) then
            local _, s = libUI.addSpineAnimation(self.winNode, nil, self.smallWinSpineName2[1], self.smallWinSpineName2[2], "animation2", nil, nil, nil, true, true, nil)
            s:setAnimation(0, "animation1", false)
            s:addAnimation(0, "animation2", true)
            self.smallWinSpine2 = s
            -- if libUI.isValidNode(self.smallWinSpine2) then
            --     self.smallWinSpine2:setOpacity(0)
            --     self.smallWinSpine2:runAction(cc.FadeTo:create(0.2, 255))
            -- end
            if libUI.isValidNode(self.labelWin2) then
                local base_scale = self.labelWin2:getScale()
                
                self.labelWin2:setScale(0.2*base_scale)
                -- self.labelWin2:stopAllActions()
                self.labelWin2:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(7/30, 1.2*base_scale),
                    cc.ScaleTo:create(6/30, 0.95*base_scale),
                    cc.ScaleTo:create(5/30, 1*base_scale)
                    ))
            end
        elseif libUI.isValidNode(self.smallWinSpine2) then
            self.smallWinSpine2:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.2, 0),
                cc.CallFunc:create(function ()
                    if libUI.isValidNode(self.smallWinSpine2) then
                        self.smallWinSpine2:removeFromParent()
                        self.smallWinSpine2 = nil
                    end
                end)
                ))
        end
    end

end

function Footer:updateWin(coins , start, interval,isup)
    start = start or 0
    if isup then
        self.labelWin2:stopAllActions()
        self.labelWin2:setString(self:parserWinLabelFunc(start+coins))
        bole.shrinkLabel(self.labelWin2, 570, 1)
        self.labelWin2:setString(self:parserWinLabelFunc(start))
        self.labelWin2:nrStartRoll(start, start+coins, interval)
        self.labelWin.objString = start+coins
        self:setWinCoinsString(self.labelWin.objString)
    else
        self.labelWin:setString(FONTS.format(start+coins,true))--(self:parserWinLabelFunc(number))
        local max_width = (self.isPortrait and 500 or 450)
        bole.shrinkLabel (self.labelWin, max_width, 1)
        self.labelWin:setString(start)
        self.labelWin.objString = start+coins
        self.labelWin:nrStartRoll(start, start+coins, interval)
    end
end

function Footer:showWinEffect()
    if self.winParticle then
        self.winParticle:setVisible(true)
        self.winParticle:resetSystem()
    end
    self.stopCoinEffect = false
    -- self.coins = self.coins or {}
    local coins = {}

    local dt = 1/60
    local iconInterval = self.cEffectConfig["coinInterval"]
    local totalTime = 0
    local direction = 1

    local function effect_coins( ... )
        coins = coins or {}
        totalTime = totalTime+dt
        if not self.stopCoinEffect and totalTime > iconInterval then
            totalTime = 0
            direction = direction*-1
            self:createNewCoin(coins,direction)
        end
        local deleteKey = nil    
        if coins and type(coins) == "table" then
            for key,coin in ipairs(coins) do
                if self:AnimateCoin(coin) then
                    deleteKey = key
                end
            end
        end
        
        if deleteKey then
            local deleteCoin = table.remove(coins,deleteKey)
            deleteCoin:removeFromParent()
            if #coins == 0 and libUI.isValidNode(self.coinNode) then
                self.coinNode:stopAllActions()
                self.coinNode:removeAllChildren()
            end
        end
    end

    self.coinNode:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            effect_coins()
        end),
        cc.DelayTime:create(dt))))
end

function Footer:showBigWinEffect(coins)
    self.DirectionX = {1, 1, 1, 1, 1}
    self.winMask = cc.Sprite:create("commonpics/common_black.png")
    self.winMask:setOpacity(200)
    self.winMask:setScale(100)
    self.effectNode:addChild(self.winMask)
    
    local path = self.ctl.theme:getWinEffectPath()
    self.winEffect1 = sp.SkeletonAnimation:create(path .."reward_g_01.json", path .. "reward_g_01.atlas", 1)
    self.effectNode:addChild(self.winEffect1,1)

    self.winParticle2 = cc.ParticleSystemQuad:create( path .. "big_win_particle.plist" )
    self.effectNode:addChild(self.winParticle2)
    self.winEffect2 = sp.SkeletonAnimation:create(path .. self.cEffectConfig["filename"]..".json", path .. self.cEffectConfig["filename"]..".atlas", 1)
    self.effectNode:addChild(self.winEffect2,10)
    if self.isPortrait then
        self.winEffect2:setScale(self.cEffectConfig["portraitScale"])
    end

    self.lbParent = libUI.createNode(self.effectNode, 20)
    local pos = self.isPortrait and self.cEffectConfig["label_win_pos_v"] or self.cEffectConfig["label_win_pos"]
    self.lbBg = libUI.createSprite(self.lbParent, path .. self.cEffectConfig["label_bg_name"] .. ".png", pos, 0, nil, 0.3)
    self.lbBigwin = libUI.createFont(self.lbParent, "commonfonts/levelup_NB_font01.fnt", pos, 0.3, 0)
    if libUI.isValidNode(self.lbBigwin) then
        inherit(self.lbBigwin, LabelNumRoll)
        self.lbBigwin:nrInit(0, 24, bole.parseValueWithoutKB)
        self.lbBigwin:setString(bole.parseValueWithoutKB(coins))
        -- local width = self.isPortrait and self.cEffectConfig["label_width_v"] or self.cEffectConfig["label_width"]
        bole.shrinkLabel(self.lbBigwin, 570, 1)
        local base_scale = self.lbBigwin:getScale()
        self.lbBigwin:setString(0)
        self.lbBigwin:nrStartRoll(0,coins,self.cEffectConfig["interval"])
        self.lbBigwin:runAction(cc.Sequence:create(
            libUI.scaleToAction(5/30, 1.3*base_scale),
            libUI.scaleToAction(5/30, 0.95*base_scale),
            libUI.scaleToAction(5/30, 1*base_scale)
            ))
    end

    if libUI.isValidNode(self.lbBg) then
        self.lbBg:runAction(cc.Sequence:create(
            libUI.scaleToAction(5/30, 1.3*1),
            libUI.scaleToAction(5/30, 0.95*1),
            libUI.scaleToAction(5/30, 1*1)
            ))
    end

    self.effectNode:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        self.winEffect2:setAnimation(0, "animation1", false)
        self.winEffect1:setAnimation(0, "animation1", false)
        end),
        cc.DelayTime:create(35/30), 
        cc.CallFunc:create(function()
            self.winEffect2:setAnimation(0, "animation2", true)
            self.winEffect1:setAnimation(0, "animation2", true)
        end)))

    self.stopCoinEffect = false
    self.bigwinCoins = {}
    self.diamondConfig = self.cEffectConfig["show_diamond_config"] or {}
    local totalTime = {}
    for i = 1, #self.diamondConfig do
        self.bigwinCoins[i] = {}
        totalTime[i] = 0
    end

    self.bigWinDtNormal = 1/60
    self.bigWinDtDiamond = self.bigWinDtNormal/6
    local iconInterval = self.cEffectConfig["coinInterval"]
    local function effect_coins(mytable, index)
        totalTime = totalTime or {}
        totalTime[index] = totalTime[index] or {}
        local big_win_dt = index == 1 and self.bigWinDtNormal or self.bigWinDtDiamond
        totalTime[index] = totalTime[index] + big_win_dt
        if not self.stopCoinEffect and totalTime[index] > iconInterval then
            totalTime[index] = 0
            self:createBigWinCoin(mytable, index)
        end

        local deleteKey = nil   
        if mytable and type(mytable) == "table" then
            for key,coin in ipairs(mytable) do
                if self:AnimateBigCoin(coin, index) then
                    deleteKey = key
                end
            end
        end
        
        if deleteKey then
            local deleteCoin = table.remove(mytable, deleteKey)
            if bole.isValidNode(deleteCoin) then
                deleteCoin:removeFromParent()
            end
        end
    end

    if self.diamondConfig then
        for i = 1, #self.diamondConfig do
            if self.diamondConfig[i] then
                if i == 1 then
                    self.effectNode:runAction(cc.RepeatForever:create(cc.Sequence:create(
                        cc.CallFunc:create(function ( ... )
                            effect_coins(self.bigwinCoins[i], i)
                        end),
                        cc.DelayTime:create(self.bigWinDtNormal))))
                else
                    self.effectNode:runAction(cc.RepeatForever:create(cc.Sequence:create(
                        cc.CallFunc:create(function ( ... )
                            effect_coins(self.bigwinCoins[i], i)
                        end),
                        cc.DelayTime:create(self.bigWinDtDiamond))))
                end
            end
        end
    end

end

function Footer:createNewCoin(coins,direction)
    if not self.cEffectConfig["coinMoveTime"] or not libUI.isValidNode(self.coinNode) then
        return
    end
    local file = self.ctl.theme:getWinEffectPath() .. "Winning_Gold"

    -- local _, skeleton = libUI.addSpineAnimation(self.coinNode, -1, file, cc.p(direction*math.random()*50, 0), "animation", nil, nil, nil, true, true) 
    local _, skeleton = libUI.addSpineAnimation(self.coinNode, -1, file, cc.p(direction*math.random()*200, 0), "animation", nil, nil, nil, true, true) 
    if libUI.isValidNode(skeleton) and coins then
        local moveTime = self.cEffectConfig["coinMoveTime"]*60
        skeleton.speedY = 2*self.cEffectConfig["coinDistance"]/moveTime
        skeleton.acc = -skeleton.speedY/moveTime
        if self.isPortrait then
            skeleton.speedX = direction*math.random()*8
        else
            skeleton.speedX = direction*math.random()*8
        end
        skeleton:setRotation(90*skeleton.speedX/3)
        skeleton.totalTime = 0
        skeleton:setScale(0.7)
        table.insert(coins,skeleton)
    end
end

function Footer:createBigWinCoin(coins, index)

    if not libUI.isValidNode(self.effectNode) then
        return 
    end

    local str = "Winning_Gold"
    if index then
        str = index == 2 and "Winning_Blue_Diamond" or str
        str = index == 3 and "Winning_Green_diamond" or str
        str = index == 4 and "Winning_Purple_Diamond" or str
        str = index == 5 and "Winning_Red_Diamond" or str
    end
    local file = self.ctl.theme:getWinEffectPath() .. str
    local _, skeleton = libUI.addSpineAnimation(self.effectNode, 5, file, cc.p(0, 0), "animation", nil, nil, nil, true, true)

    if libUI.isValidNode(skeleton) and coins then
        local direction_x = 1
        self.DirectionX[index] = self.DirectionX[index]*-1
        direction_x = self.DirectionX[index]
        local times = 1.5
        skeleton.acc = -0.5*times*times

        if self.isPortrait then
            skeleton.speedX = direction_x*(5+math.random()*7)
            skeleton.speedY = (8+math.random()*12)*times*times
            if libUI.isValidNode(skeleton) then
                skeleton:setOpacity(0)
                skeleton:runAction(cc.Sequence:create(
                    cc.DelayTime:create(0.1),
                    cc.FadeTo:create(0.1, 255)
                    ))
            end
        else
            skeleton.speedX = direction_x*(5+math.random()*7)*times
            skeleton.speedY = (8+math.random()*12)*times
            if libUI.isValidNode(skeleton) then
                skeleton:setOpacity(0)
                skeleton:runAction(cc.Sequence:create(
                    cc.DelayTime:create(0.2),
                    cc.FadeTo:create(0.2, 255)
                    ))
            end
        end

        skeleton:setRotation(360*math.random())
        skeleton.totalTime = 0
        skeleton:setScale((0.2+math.random()))

        table.insert(coins,skeleton)
    end
end

function Footer:AnimateCoin(coin)
    
    coin.totalTime = coin.totalTime + 1/60

    if coin:getPositionY() < -400 then  
        return true
    else
        local tempSpeed = coin.speedY+coin.acc
        local disY = (coin.speedY+tempSpeed)/2
        coin.speedY = tempSpeed
        coin:setScale(0.8+coin.totalTime*0.2)
        coin:setPosition(cc.p(coin:getPositionX()+coin.speedX, coin:getPositionY()+disY))   
    end
    return false
end

function Footer:AnimateBigCoin(coin, index)
    --zhf avoid online error ---
    -- if not coin.totalTime or not coin.totalTimeDiamondBlue or not coin.totalTimeDiamondPurple then
    --     return true
    -- end
    --zhf avoid online error end---
    local index = index or 1
    local big_win_dt = index == 1 and self.bigWinDtNormal or self.bigWinDtDiamond
    coin.totalTime = coin.totalTime + big_win_dt

    local dis = -FRAME_HEIGHT/2-100
    if self.isPortrait then
        dis = -FRAME_WIDTH/2-100
    end
    if coin:getPositionY() < dis then
        return true
    else
        if coin.needFadeOut then
            local opacity = coin:getOpacity() - 4
            if opacity < 0 then
                opacity = 0
            end
            coin:setOpacity(opacity)
        end
        local tempSpeed = coin.speedY+coin.acc
        local disY = (coin.speedY+tempSpeed)/2
        coin.speedY = tempSpeed
        coin:setPosition(cc.p(coin:getPositionX()+coin.speedX,coin:getPositionY()+disY))   

    end
    return false
end

function Footer:tryStopWinEffect( ... )
    if self.winParticle then
        self.winParticle:stopSystem()
    end
    -- if bole.isValidNode(self.effectNode) then
    --     self.effectNode:removeFromParent()
    -- end
end

function Footer:stopWinAction() -- 停止 WinEffect 和 rollUp 动画
    if self.isSamllWinpop then
        self:stopSmallWinEffect()
    elseif self.isNormalWinpop then
        self:stopNormalWinEffect()
    elseif self.isBigWinpop then
        self:stopBigWinEffect(true)
    end
end

function Footer:stopSmallWinEffect()
    if self.isSamllWinpop then
        self.isSamllWinpop = false
        self.touchLayer:setVisible(false)
        self.stopCoinEffect = true
        if self.winParticle then
            self.winParticle:stopSystem()
        end
        bole.cleanLabelNumRoll(self.labelWin)
        if self.labelWin.objString then 
            self:setWinCoinsString(self.labelWin.objString) 
        end
        self.winNode:stopAllActions()
        self.coinNode:stopAllActions()
        if self.cMuti then 
            self.ctl.theme:stopRollUpFunction(self.cMuti) 
        end
        self.showingWinEffect = false
        if self.winCallback then
            self.winCallback()
        end
        EventCenter:pushEvent(EVENTNAMES.THEME.STOP_WIN)
    end
end

function Footer:stopNormalWinEffect()
    if self.isNormalWinpop then
        self.isNormalWinpop = false
        self.touchLayer:setVisible(false)
        self.stopCoinEffect = true
        if self.winParticle then
            self.winParticle:stopSystem()
        end
        bole.cleanLabelNumRoll(self.labelWin)
        if self.labelWin.objString then 
            self:setWinCoinsString(self.labelWin.objString) 
        end
        self.winNode:stopAllActions()
        if self.cMuti then 
            self.ctl.theme:stopRollUpFunction(self.cMuti) 
        end
        self.labelWin:setOpacity(255)
        self.labelWin2:setOpacity(0)

        self:playSmallWinSpine()

        local moveBack = cc.MoveTo:create(0.3,cc.p(self.winNode.basePositionX,self.winNode.basePositionY))
        local scaleBack = cc.ScaleTo:create(0.3,self.winNode.baseScale)
        local moveDown = cc.Spawn:create(moveBack,scaleBack)
        local action = cc.Sequence:create(moveDown,cc.CallFunc:create(function()
            self.showingWinEffect = false
            if self.winCallback then
                self.winCallback()
            end
            EventCenter:pushEvent(EVENTNAMES.THEME.STOP_WIN)
        end))
        self.winNode:runAction(action)
    end
end

function Footer:stopBigWinEffect(force)
    if self.isBigWinpop and self.bigwinCoins then
        self.isBigWinpop = false
        self.stopCoinEffect = true
        self.touchLayer:setVisible(false)
        
        if self.cMuti then 
            self.ctl.theme:stopRollUpFunction(self.cMuti) 
        end

        for i = 1, #self.bigwinCoins do
            local temp_table = self.bigwinCoins[i]

            if temp_table and type(temp_table) == "table" then
                for key,coin in ipairs(temp_table) do
                    coin.needFadeOut = true
                end
            end

        end

        if libUI.isValidNode(self.lbBigwin) then
            bole.cleanLabelNumRoll(self.lbBigwin)
            self.lbBigwin:setString(FONTS.format(self.cCoins, true))
        end

        local delay = 1
        if force then
            delay = 0
        end
        self.effectNode:runAction(cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function()
                self.winParticle2:stopSystem()
                -- if libUI.isValidNode(self.lbBigwin) then
                --     self.lbBigwin:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1.2),cc.ScaleTo:create(0.3,0)))
                -- end
            end),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()

                if libUI.isValidNode(self.lbParent) then
                    self.lbParent:runAction(cc.ScaleTo:create(0.3,0))
                end

                self.winEffect2:runAction(cc.ScaleTo:create(0.3,0))
                self.winEffect1:runAction(cc.ScaleTo:create(0.3,0))
                self.labelWin:setOpacity(255)
                self.labelWin2:setOpacity(0)

                self:playSmallWinSpine()

                self.winMask:runAction(cc.FadeOut:create(0.3))
                self:updateWin(self.cCoins,self.cStartCoins,0.5,false)
            end),
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function()
                self.showingWinEffect = false
                if self.winCallback then
                    self.winCallback()
                end
                EventCenter:pushEvent(EVENTNAMES.THEME.STOP_BIG_WIN)
                EventCenter:pushEvent(EVENTNAMES.THEME.STOP_WIN)
            end),
            cc.DelayTime:create(1.5),
            cc.CallFunc:create(function ( ... )
                -- UserGuideControl:getInstance():showFacebookDialog({from_bw = true}, nil)
            end),
            cc.RemoveSelf:create()))
    end
end

function Footer:onExit()
    self:cancelEvent()
    self:tryStopWinEffect()
    ActivityThemeController:getInstance():onHide()
end

function Footer:changeLabelDescription(status, addCoins)
    --------------PD: 一直显示total win，是否需要这块功能有待商讨 (whj: -> hexoGems 主题的ways 数量是个假的)
    --[[
    local des1, des2 = true, false
    if status == "notFS_notWin" then
        local themeType = self.ctl.theme:getThemeType()
        local str = ""
        if themeType == "payLine" then
            str = self.ctl.featureMul > 0 and "Playing ".. self.ctl.maxLine .. " lines + Feature" or "Playing ".. self.ctl.maxLine .. " lines"
        elseif themeType == "ways" then
            str = "PLAYING ".. (self.ctl.theme.ways or "SOME") .. " WAYS"
        end
        self.labelWinDesc1:setString(str)
    elseif status == "FS_notWin" then
        self.labelWinDesc1:setString("TOTAL WIN")
    elseif status == "notFS_Win" then
        self.labelWinDesc1:setString("WIN")
    elseif status == "FS_Win" and addCoins then
        des1 = false
        des2 = true
        self.labelWinDesc2:setString("+ " .. bole.dealValueToRetString(addCoins))
    end
    self.labelWinDesc1:setVisible(des1)
    self.labelWinDesc2:setVisible(des2)
    ]]--
end
function Footer:adjustWinScale( theWinAdjustScale )
    self.labelWin:setScale(self.labelWin.baseScale * (theWinAdjustScale or 1))
end

-- 
function Footer:checkCleanCoinsAdd( )
    if self.labelWin.objString == 0 then return end 

    bole.cleanLabelNumRoll(self.labelWin)
    if self.labelWin.objString then 
        self:setWinCoinsString(self.labelWin.objString) 
    end
    self.labelWin.objString = 0
    local hideAction = cc.Sequence:create(cc.DelayTime:create(0.7), cc.FadeOut:create(0.3), cc.CallFunc:create(function()
        self:setWinCoinsString(0)
        self.labelWin:setOpacity(0)
        self.labelWin2:setOpacity(0)

        self:playSmallWinSpine()

    end))
    -- hideAction.tag = hideWinNodeActTag
    self.winNode:stopActionByTag(hideWinNodeActTag)
    self.winNode:runAction(hideAction)
    hideAction:setTag(hideWinNodeActTag)
end

function Footer:setWinCoinsString( number )
    self.labelWin:setString(FONTS.format(number,true))--(self:parserWinLabelFunc(number))
    local max_width = (self.isPortrait and 500 or 450)
    bole.shrinkLabel(self.labelWin, max_width, 1)
end

function Footer:reSetWinCoinsString(coins)
    if coins>0 then 
        self.labelWin:setString(FONTS.format(coins,true))
        local max_width = (self.isPortrait and 500 or 450)
        bole.shrinkLabel(self.labelWin, max_width, 1)
    else
        self.labelWin:setString("")
    end
    self.labelWin.objString = coins
end
-------------------------------------------------------------------
--
----------设置MaxBet和Add按钮的状态以及到达MaxBet时需要播放的动画效果-------
function Footer:setMaxBetBtnEnable( enable,  notCacheTag )
    if not notCacheTag then
        self.maxBetTag = enable
    end
    self.btnMaxBet:setTouchEnabled(enable)
    self.btnMaxBet:setBright(enable)
    --self.btnAddBet:setTouchEnabled(enable)
    --self.btnAddBet:setBright(enable) 
end

function Footer:setMaxBetState( isMaxBet )
    self.btnMaxBet:setMaxState(isMaxBet)
    if self.last_max_bet_state ~= isMaxBet then
        self:showMaxBetActivated(isMaxBet)
    end

    self.last_max_bet_state = isMaxBet

end

function Footer:canShowMaxBetRaiseTip()

    if not libUI.isValidNode(self) then
        return 
    end
    
    if self.last_max_bet_state == nil then
        
    else
        local cur_max = 0
        if self.ctl and self.ctl.getMaxBet then
            cur_max = self.ctl:getMaxBet() or 0
        end
        if self.old_max_bet and self.old_max_bet ~= cur_max and UserGuideControl:getInstance():getMaxBetTipFlag() == 0 then
            self:showMaxBetRaiseTip(true)
            UserGuideControl:getInstance():setMaxBetTipFlag(1)
        end
    end

    if self.ctl and self.ctl.getMaxBet then
        self.old_max_bet = self.ctl:getMaxBet() or 0
    else
        self.old_max_bet = 0
    end

end

function Footer:showMaxBetEffect()
    if self.maxBetSpine then
        local pos = (self.isPortrait == true and cc.p(-25,0)) or cc.p(0, 0)
        local function callback()
            if self.maxBetChoosedParticle then
                self.maxBetChoosedParticle:stopSystem()
            end
        end
        
        Theme:addSpineAnimation(self.Node_maxBetChoosedAnimation, nil, self.maxBetSpine, pos, "animation", callback, nil, nil, false, false, nil)
        if self.maxBetChoosedParticle then
            self.maxBetChoosedParticle:resetSystem()
        end

    end
end
-------------------------------------------------------------------
function Footer:setSpinButtonState( state ) -- true是锁住状态，false是可以点击状态
    self.spinNode:changeBtnState("ingore", "ingore", state)
end

function Footer:setSpinButtonNormal(  )
    self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, "ingore", true, true)
end

function Footer:setMinBetBtnEnable( enable, notCacheTag )
    -- if not notCacheTag then
    --     self.minBetTag = enable
    -- end    
    self.btnSubBet:setTouchEnabled(enable)
    self.btnSubBet:setBright(enable)
end

function Footer:setSubAndAddBetBtnEnable( enable, notCacheTag )
    if self.ctl:checkIsSingleBet() then 
        enable = false
    end

    self.btnAddBet:setTouchEnabled(enable) 
    self.btnAddBet:setBright(enable)
    self.btnSubBet:setTouchEnabled(enable)
    self.btnSubBet:setBright(enable)
end
---------------------设置Game Rule按钮的状态--------------------------
function Footer:setPaytableBtnEnable( enable )
    self.btnPaytable:setTouchEnabled(enable)
    self.btnPaytable:setBright(enable)    
end
--------------------------------------------------------------------
function Footer:enableOtherBtns( enable )
    if self:checkInFreeSpin() or self:checkInAutoSpin() then
        enable = false
    end
    if self.ctl.theme and  self.ctl.theme.checkInFeature and self.ctl.theme:checkInFeature() then -- whj 添加,用来控制特殊情况下不打开按钮的, 例如:在商店打开的时候
        enable = false
    end
    if self.ctl.theme and  self.ctl.theme.isBetLock and self.ctl.theme:isBetLock() then -- whj 添加,用来控制特殊情况下不打开按钮的, 例如:在社交主题的时候
        enable = false
    end
    -- self:setPaytableBtnEnable(enable)
    -- self.turboClose:setTouchEnabled(enable)
    -- self.turboClose:setBright(enable)
    -- self.turboOpen:setTouchEnabled(enable)
    -- self.turboOpen:setBright(enable)

    if self.ctl:checkIsSingleBet() then 
        enable = false
    end

    self.btnAddBet:setTouchEnabled(enable)
    self.btnAddBet:setBright(enable) 
    self.btnSubBet:setTouchEnabled(enable)
    self.btnSubBet:setBright(enable)

    if enable then
        self:setMaxBetBtnEnable(self.maxBetTag)
        --self:setMinBetBtnEnable(self.minBetTag)
    else
        self:setMaxBetBtnEnable(false, true)
        --self:setMinBetBtnEnable(false, true)
    end
end
--------------------------------------------------------------------
-- 
--------------------------------------------------------------------
function Footer:checkInFreeSpin( )
    return self.isFreeSpin
end
function Footer:checkInAutoSpin()
    if libUI.isValidNode(self) then
        return self.spinNode.curStatue == SPIN_STATUS_NAME.AUTO_SPIN
    end
    return false
end
function Footer:checkCanClickSpin( )
    return not self.spinNode.isForbid
end
--------------------------------------------------------------------
--------------------------------------------------------------------
function Footer:enableAuto( enable )
    if enable then
        G_THEME_FAST_TAG = true
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.AUTO_SPIN, "ingore", "ingore")
    else
        G_THEME_FAST_TAG = false
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, "ingore", "ingore")
    end
end
function Footer:onSpinStart( )
    self.hadDealHandle = 0
    self.spinNode:changeBtnState("ingore", false, true)
    self:enableOtherBtns(false)

    if self:checkInFreeSpin() or self.isRespinLayer then
        local delayAction = cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function (  )
            self:changeLabelDescription("FS_notWin")
        end))
        delayAction.tag = 456
        self.labelWin:stopActionByTag(delayAction.tag)
        self.labelWin:runAction(delayAction)
    else
        self:checkCleanCoinsAdd()
        self:changeLabelDescription("notFS_notWin")
    end

    -- if not self:checkInFreeSpin() and not self.isRespinLayer then
    --     self:checkCleanCoinsAdd()
    --     self:changeLabelDescription("notFS_notWin")
    -- else
    --     local delayAction = cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function (  )
    --         self:changeLabelDescription("FS_notWin")
    --     end))
    --     delayAction.tag = 456
    --     self.labelWin:stopActionByTag(delayAction.tag)
    --     self.labelWin:runAction(delayAction)
    -- end
    self.canSpin = false
    -- self:stopAllActions()
end
function Footer:setStopBtn( )
    self.spinNode:changeBtnState("ingore", true, false)
end
function Footer:isAutoSpinFast()
    local autoFast = false
    if (self.ctl.isAutoSpinFast and self.ctl:isAutoSpinFast()) then
        autoFast = true
    end
    return autoFast
end
function Footer:onFastStop( ... )
    if not self:isAutoSpinFast() then
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, false, true)
    end
end
function Footer:onAllReelStop( ... )
    -- self:runAction(cc.Sequence:create(cc.DelayTime:create(0.08), cc.CallFunc:create(function()
    --     if self.spinNode.isStop and not self.spinNode.isForbid then
    --         self.spinNode:changeBtnState("ingore", false, true)
    --     end
	-- end)))
end
function Footer:dealHandle( key )
    self.hadDealHandle = self.hadDealHandle + 1
    if self.hadDealHandle ~= 2 then return end
    self.spinNode:changeBtnState("ingore", false, true)
end

function Footer:onFinishSpin( ... )
    self.hadDealHandle = -1000
    if not self.islocked then
        self.spinNode:changeBtnState("ingore", false, false)
    end
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.25), cc.CallFunc:create(function()
        if not self.ctl.spinning then
            self:enableOtherBtns(true)
        end
	end)))
    self.canSpin = true
end
function Footer:onRespinStart( )
    self:onSpinStart()
end
function Footer:onRespinOver( )
    self:onFinishSpin()
end
function Footer:onRespinFastStop( )
    self:onFastStop()
end

function Footer:enterFreeSpin( )
    self.isFreeSpin = true    
    self.spinNode:changeBtnState("ingore", false, false)
    self:enableOtherBtns(true)
    self:changeLabelDescription("FS_notWin")    
end
function Footer:enterCollectFreeSpin()
    self.isFreeSpin = true  
    self.spinNode:changeBtnState("ingore", "ingore", true)
    self:enableOtherBtns(false)
    self:changeLabelDescription("FS_notWin")  
    self.islocked = true  
end
function Footer:setSpinStateOnFinishSpin(enable)
   self.islocked = enable
end
function Footer:exitFreeSpin( )
    self.isFreeSpin = false    
    self.spinNode:changeBtnState("ingore", false, false)
    self:enableOtherBtns(true)
    self:changeLabelDescription("notFS_notWin")  
    self:changeNormalLayout()
end
function Footer:onEnterFreeSpinDialog( )
    --self.btnFreeSpin:setTouchEnabled(false)
    --self.btnFreeSpin:setBright(false)
end

function Footer:hideWinNode()
    self.winNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.7), cc.FadeTo:create(0.2), cc.CallFunc:create(function()
        -- self.winNode:setVisible(false)
        self.winNode:setOpacity(0)
    end)))
end



function Footer:showWinNode()
    self.winNode:setOpacity(255)
end

function Footer:isCanSpin()
    return self.canSpin
end

function Footer:addMaxBetFlash()
    if not self.maxBetFlash and self.maxBetSpine then
        self.maxBetFlash = 0
        -- local file = "res/header_footer/style2/footer/spines/maxbet/spine"
        -- local skeleton = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
        -- skeleton:setAnimation(0, "animation", false) 
        local _, skeleton = Theme:addSpineAnimation(self.tipBet:getParent(), nil, self.maxBetSpine, cc.pAdd(bole.getPos(self.tipBet), cc.p(-1.4, 44)), "animation", nil, nil, nil, false, false, nil)
        skeleton:setScaleX(1.01)
        skeleton:setScaleY(1.02)
        skeleton:registerSpineEventHandler(function (event)
            skeleton:setVisible(false)
            self.maxBetFlash = skeleton
        end, sp.EventType.ANIMATION_COMPLETE)
        skeleton:setLocalZOrder(-1)
    else
        if libUI.isValidNode(self.maxBetFlash) and type(self.maxBetFlash) ~= "number" then
            self.maxBetFlash:setLocalZOrder(100)
            self.maxBetFlash:setVisible(true)
            self.maxBetFlash:setAnimation(0, "animation", false) 
        end
    end
end

function Footer:canToAutoSpin()
    return self.btnSpin.spin_l:isVisible() and not self.isFreeSpinLayer and not self.isSFreeSpinLayer and not (self.ctl.theme.checkNotToAutoSpin and self.ctl.theme:checkNotToAutoSpin())
end

function Footer:hideFooter( ... )
    if libUI.isValidNode(self.node) then
        self.node:setVisible(false)
    end
end

function Footer:showFooter( ... )
    if libUI.isValidNode(self.node) then
        self.node:setVisible(true)
    end 
end

function Footer:addActivityBNodeToThemeFooter(parent, footerConfig)
    SystemController:getInstance():addNodeToThemeFooterItem(parent, self.ctl, footerConfig, self.isPortrait,self)
    SystemController:getInstance():addNodeToThemeFooterList(self, footerConfig, self.isPortrait)
    -- EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.B_UPDATE, footerConfig)
end

function Footer:getWinWordPos( ... )
    return bole.getWorldPos(self.winNode)
end

function Footer:getFSCntWordPos( ... )
    return bole.getWorldPos(self.labelFSCnt)
end

------------------------------------------------------------------------------------------------------------

PaytableView = class("PaytableView", CCSNode)
---@param ctl
---@param page:指定打开某一页没有的话默认是1
function PaytableView:ctor( ctl, page )
    self.ctl        = ctl
    self.firstOpenPage = page
    self.cacheIndex = 0
    self.csb        = self.ctl.theme:getPic("csb/paytable.csb")
    CCSNode.ctor(self, self.csb)
    if PAD_TAG then
        self:setScale(0.9)
        self:setPositionY(0 - MARGIN_H/2 - 20)
    end
    self:initLayout()
end
function PaytableView:initLayout( ... )  -- 初始化各个节点
    self.root     = self.node:getChildByName("root")
    self.btnRoot   = self.root:getChildByName("btn_root")
    self.backNode  = self.btnRoot:getChildByName("node_back")
    self.btnBack   = self.backNode:getChildByName("btn_back")
    self.leftNode  = self.btnRoot:getChildByName("node_left")
    self.btnLeft   = self.leftNode:getChildByName("btn_left")
    self.rightNode = self.btnRoot:getChildByName("node_right")
    self.btnRight  = self.rightNode:getChildByName("btn_right")     
    self.spineNode = self.btnRoot:getChildByName("spine_node")
    self.index = 1
   if SHRINKSCALE_H < 1 then
        local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
        self.btnRoot:setScale(scale)
    end
    self.pageRoot  = self.root:getChildByName("page_root")
    self.pageList  = {}
    self.pageCnt   = 0
    self.curPage   = 1
    local pageWith = FRAME_WIDTH
    if not self.ctl.theme.isPortrait then
        local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
        if pageWith <1560*scale then
            pageWith = 1560*scale
        end
    end
    self.pageWidth = self.ctl.theme.isPortrait and 720 or pageWith

    local front_page = self.pageRoot:getChildByName("page_front_1")
    if ActivityCenterControl:getInstance():isMasterTheme(self.ctl.theme.themeid) and front_page then
        self.pageList[1] = front_page
        self.pageCnt   = 1
        if SHRINKSCALE_H < 1 then
            local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
            self.pageList[1]:setScale(scale)

            if self.ctl.theme.isPortrait then 
                local bg = self.pageList[1]:getChildByName("bg")
                bg:setScaleX(bg:getScaleX()/(scale))
            end
        end
        -- if not self.ctl.theme.isPortrait then 
            self.pageList[1]:setPositionX(0)
        -- end
        local desc_spine = front_page:getChildByName("desc_spine")
        if desc_spine and self.ctl.theme.gameRuleGMConfig and #self.ctl.theme.gameRuleGMConfig > 0  then
            desc_spine:removeAllChildren()
            for key,item in pairs( self.ctl.theme.gameRuleGMConfig) do
                local spineFile = self.ctl.theme:getPic(item)
                local _,s = bole.addSpineAnimation(desc_spine,nil,spineFile,cc.p(0,0),"animation",nil,nil,nil,true,true)
            end
        end
    elseif front_page then
        front_page:setVisible(false)
    end
    local startPageId = 0
    for i = 1, 100 do
        local temp_index = #self.pageList + 1
        startPageId = startPageId + 1
        self.pageList[#self.pageList + 1] = self.pageRoot:getChildByName("page_"..i)
        if not self.pageList[temp_index] then
            break
        elseif self.ctl.hideGameRuleList and self.ctl.hideGameRuleList[startPageId] then
            local pageNode = table.remove(self.pageList, #self.pageList)
            pageNode:setVisible(false)
        else
            self.pageCnt = self.pageCnt + 1

            if SHRINKSCALE_H < 1 then
                local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
                self.pageList[#self.pageList]:setScale(scale)

                if self.ctl.theme.isPortrait then 
                    local bg = self.pageList[#self.pageList]:getChildByName("bg")
                    if bole.isValidNode(bg) then 
                        bg:setScaleX(bg:getScaleX()/(scale))
                    end
                end
            end
            -- if not self.ctl.theme.isPortrait then 
                self.pageList[#self.pageList]:setPositionX((#self.pageList-1)*self.pageWidth) --   
            -- end

            -- 自动填充muti 的操作
            local muti_node = self.pageList[#self.pageList]:getChildByName("muti_node")
            if muti_node then 
                local value -- local value = ThemeMuti[self.ctl.theme.themeid]
                if self.ctl.getPayMulti then 
                    value = self.ctl:getPayMulti()
                end
                if not value then 
                    value = ThemeMuti[self.ctl.theme.themeid]
                end

                for k,v in pairs(muti_node:getChildren()) do
                    local key = v:getName()
                    if value and value[key] then
                        for k2,v2 in pairs(v:getChildren()) do 
                            if value[key][k2] then
                                v2:setString(value[key][k2])
                            end
                        end
                    end
                end
            end

        end
    end

    self.page_count = #self.pageList
    self.currentPage = self.pageList[1]
    self.isMoved = true 
    if #self.pageList >= 2 then
        self.nextPage = self.pageList[2]
    end
    if self.firstOpenPage then
        local showPage = self.firstOpenPage

            if ActivityCenterControl:getInstance():isMasterTheme(self.ctl.theme.themeid) and front_page then
                showPage = showPage +1
            end
        if showPage< self.page_count then
            self.index = showPage
            self.firstOpenPage = showPage
            self:updateFirstPage()
        end

    end

    self.labelsTable = nil
    if self.spineNode then
        local spinePath = self.ctl.theme:getPic("spine/paytable/spine/back_to_game01")
        local skeleton = sp.SkeletonAnimation:create(spinePath..".json", spinePath..".atlas", 1)
        skeleton:setAnimation(0, "animation", true)
        self.spineNode:addChild(skeleton, 1)
    end
end
function PaytableView:updateFirstPage()

    local firstPage = self.pageList[self.index]
    self.currentPage = firstPage
    for key = 1,self.page_count do
       local  posX = -self.pageWidth* (self.index- key)
        self.pageList[key]:setPositionX(posX)
    end
    if self.index< self.page_count then
        self.nextPage = self.pageList[self.index+1]
    else
        self.nextPage = self.pageList[1]
    end
end
function PaytableView:show( ... )
    self:showActions()

    if self.ctl.theme.isPortrait then
        self:setPosition(cc.p(FRAME_HEIGHT/2,FRAME_WIDTH/2))
    else
        self:setPosition(cc.p(FRAME_WIDTH/2,FRAME_HEIGHT/2))
    end
    bole.scene:addChild(self)

    -- self.ctl.curScene:addToTop(self) -- self.ctl.curScene:addToFooterHeader(self, 99999)
    self:setVisible(false)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
        self:setVisible(true)
        self:runTimeLine(0, 25, false)    
    end), cc.DelayTime:create(0.5), cc.CallFunc:create(function()
        self:initEvent()
    end)))
end
function PaytableView:moveFunc(index,pageWidth)
    if self.page_count < 2 then return end
    self.nextPage = self.pageList[index]
    self.nextPage:setPosition(cc.p(self.currentPage:getPositionX() - pageWidth, self.currentPage:getPositionY()))-- 下一张图片设置在当前图片的位置
    self.isMoved = false
    self.nextPage:runAction(cc.Sequence:create(
        cc.MoveBy:create(0.5, cc.p(pageWidth,0)), -- 花两秒时间，向右移动145个像素
        cc.CallFunc:create(function() self.isMoved = true end) -- 设置标志位，说明已经移动完成
        ))

    local pic = self.currentPage -- 保存下当前的图片
    pic:runAction(cc.MoveBy:create(0.5,cc.p(pageWidth,0)))
    self.currentPage = self.nextPage -- 保存已经替换的当前图片
    self.nextPage = pic
end
function PaytableView:initEvent( ... )
    local function moveLeft()
        if self.isMoved then
            bole.playMusic("info/info_page_scroll", nil, nil, "sounds/")
            self.index = self.index + 1
            if self.index == self.page_count+1 then 
                self.index = 1
            end
            if self.moveFunc then
                self:moveFunc(self.index,-self.pageWidth)
            end
        end
    end
    local function moveRight( ... )
        if self.isMoved then
            bole.playMusic("info/info_page_scroll", nil, nil, "sounds/")
            self.index = self.index - 1
            if self.index == 0 then
                self.index = self.page_count
            end
            if self.moveFunc then
                self:moveFunc(self.index,self.pageWidth)
            end
        end
    end
    self:addTouchEvent(self.btnLeft, moveRight, -1) -- 向右滑动
    self:addTouchEvent(self.btnRight, moveLeft, 1) -- 向左滑动
    local function exit( ... )
        bole.playMusic("info/info_page_close", nil, nil, "sounds/")
        self:hide()
    end
    self:addTouchEvent(self.btnBack, exit)
    bole.addKeyboardEvent(self, exit, true)
end
function PaytableView:hide( ... )
    if not self.isHiding then
        self.isHiding = true
        local duaration = 25/60
        self:runTimeLine(40,65,false)
        self:runAction( cc.Sequence:create( cc.DelayTime:create(duaration), cc.RemoveSelf:create(), cc.CallFunc:create(function ( ... )
            -- 卸载 paytable 的资源
            local theme = self.ctl.theme
            self.ctl.header.isPaytableViewShowing = false
            self:hideActions(true)
            local pngList = ThemePngs[theme.themeid] -- 之后需要要确定是否需要 
            if pngList then 

                local textureCache = cc.Director:getInstance():getTextureCache()

                for k,v in pairs(pngList) do
                    if string.find(v[2], "paytable/") then
                        textureCache:removeTextureForKey(theme:getPic(v[2]))
                    end
                end
               
            end
        end)))
    end
end
