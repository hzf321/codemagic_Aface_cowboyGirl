local BLNode      = require("UI/CreatorUI/BLNode")
local createNode  = function (parent, zOrder, pos)
	local node = cc.Node:create()
    if pos then
        node:setPosition(pos)
    end
	if parent then
		parent:addChild(node, zOrder)
	end
	return node
end

local hideWinNodeActTag = 123
local SPIN_STATUS_NAME = {
    NORMAL_SPIN = "normalspin",
    AUTO_SPIN   = "autospin",
    FREE_SPIN   = "freespin",
}

G_THEME_FAST_TAG = false

local fastBool = false;

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


local Footer_Node = class("Footer_Node", BLNode)

function Footer_Node:ctor(theCtl, isPortrait)
    self.ctl        = theCtl
    self.footerCtl  = HeaderFooterControl:getInstance()
    self.isPortrait = isPortrait
    self.csb        = string.format("ui/header_footer/%s", bole.isThemeScene() and "theme_footer" or "lobby_footer")
    self.node       = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:loadControls()
end

function Footer_Node:loadControls()
    self.root = self.node.root
    
    if  bole.isThemeScene() then 
        self:initTotalbet()
        self:initTotalwin()
        self:initMaxbet()
        self:initSpin()
    else
        self:lobbyBtnlistenEvent()
    end

end

---------------------------------  大厅  --------------------------------- 

-- 大厅按钮监听
function Footer_Node:lobbyBtnlistenEvent()
    local index = 0
    local warehouse_node = self.root.warehouse_node
    if warehouse_node then
        for _, btn in pairs(warehouse_node:getChildren()) do
            index = index + 1
            local num = index
            local posX, posY = btn:getPosition()
            local function onShowTip()
                bole.playSounds("click")
                if num == 1 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_1_lobby)
                elseif num == 2 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_2_lobby)
                elseif num == 3 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_3_lobby)
                elseif num == 4 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_4_lobby)
                elseif num == 5 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_5_lobby)
                elseif num == 6 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_6_lobby)
                else
                    HttpManager:getInstance():doReport(ReportConfig.btn_bottom_7_lobby)
                end
                
                if libUI.isValidNode(self) and libUI.isValidNode(btn) then
                    self:showTip(posX, posY, num)
                end
            end
            bole.ctorUIComponent(btn, UIComponent.CommonButton, UIComponent.CommonButton.Enum.ONLY_GRAY)
            self:addTouchEvent(btn, onShowTip)
        end
    end
    local tip_node = self.root.tip_node
	if tip_node then
		tip_node:setVisible(false)
    end
end

-- 弹窗气泡窗
function Footer_Node:showTip(posX, posY, index)
	local tip_node = self.root.tip_node
    local unlockArr = {500,600,650,700,750,800,900,950,1000}
	if tip_node then
        local label_diamonds = tip_node.label_diamonds
        label_diamonds:setString(unlockArr[index])

		tip_node:setVisible(true)
		tip_node:stopAllActions()
		tip_node:setOpacity(0)
		tip_node:setScale(0)
        tip_node:setPosition(posX, posY + 10)
		tip_node:runAction(
			cc.Sequence:create(
				cc.Spawn:create(cc.FadeIn:create(0.2), cc.ScaleTo:create(0.2, 1)),
				cc.DelayTime:create(1.5),
				cc.Spawn:create(cc.FadeOut:create(0.2), cc.ScaleTo:create(0.2, 0)),
				cc.CallFunc:create(function ()
					tip_node:setVisible(false)
				end)
			)
		)
	end
	bole.playSounds("click")
end

-- 入场动画
function Footer_Node:enterAction(isFromTheme)
    -- if isFromTheme then return end

    local posGap = 200
    self.node:setPositionY(self.node:getPositionY() - posGap);
    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.MoveBy:create(0.4, cc.p(0, posGap))
        )
    )
end



---------------------------------  机台  ---------------------------------

----------------  Totalbet Start  -----------------

-- 初始化下注区域
function Footer_Node:initTotalbet()
    local totalbet_node = self.root.totalbet_node
    if not totalbet_node then return end
    self.totalbetNode = totalbet_node

    self.maxBetSpine = "header_footer/spines/maxbet/spine"

    self.betBg1 = totalbet_node.totalbet_bg
    self.betBg2 = totalbet_node.small_bg
    if self.betBg2 then
        self.betBg2:setVisible(false)
    end

    self.Node_maxBetChoosedAnimation = totalbet_node.max_bet_choosed
    self.maxBetChoosedParticle = totalbet_node.max_bet_particle

    -- 加注按钮
    local btn_addbet = totalbet_node.btn_addbet
    if btn_addbet then
        local touchUpBet = function (...)
            HttpManager:getInstance():doReport(ReportConfig.btn_addbet_play)
            bole.playSounds("click")
            self.ctl:changeToUpBet()
            local isMaxBet = self.ctl:checkIsMaxBet()
            if isMaxBet == true then
                self:showMaxBetEffect()
            end
            self:displayAutoplayInterface(false)
            EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_ADDBET)
        end
        self:addTouchEvent(btn_addbet, touchUpBet)
        self.btnAddBet = btn_addbet
    end

    -- 减注按钮
    local btn_subbet = totalbet_node.btn_subbet
    if btn_subbet then
        local touchDownBet = function (...)
            HttpManager:getInstance():doReport(ReportConfig.btn_reducebet_play)
            bole.playSounds("click")
            self.ctl:changeToDownBet()
            local isMaxBet = self.ctl:checkIsMaxBet()
            if isMaxBet == true then
                self:showMaxBetEffect()
            end
            self:displayAutoplayInterface(false)
            EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_SUBBET)
        end
        self:addTouchEvent(btn_subbet, touchDownBet)
        self.btnSubBet = btn_subbet
    end
    
    self.labelTotalBet = totalbet_node.label_totalbet
    if self.labelTotalBet then
        self.labelTotalBet.normalPos   = cc.p(0, 5)
        self.labelTotalBet.normalScale = 1
        self.labelTotalBet.normalWidth = 199
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

function Footer_Node:setBetInfo( bet, curBetMul, total, isFree )  
    total = total or bet*curBetMul

    if libUI.isValidNode(self.labelTotalBet) then
        if isFree and self.labelTotalBet.freeScale and self.labelTotalBet.freeWidth then
            self.labelTotalBet:setString(self:isFree_totalbet(total))
            bole.shrinkLabel(self.labelTotalBet, self.labelTotalBet.freeWidth, self.labelTotalBet.freeScale)
        elseif self.labelTotalBet.normalScale and self.labelTotalBet.normalWidth then
            self.labelTotalBet:setString(FONTS.format(total,true))
            bole.shrinkLabel(self.labelTotalBet, self.labelTotalBet.normalWidth, self.labelTotalBet.normalScale)
        end
    end
end
function Footer_Node:setSubAndAddBetBtnEnable( enable, notCacheTag )
    if self.ctl:checkIsSingleBet() then 
        enable = false
    end
    if  self.btnAddBet then
        self.btnAddBet:setTouchEnabled(enable) 
        self.btnAddBet:setBright(enable)
    end
    if  self.btnSubBet then
        self.btnSubBet:setTouchEnabled(enable)
        self.btnSubBet:setBright(enable)
    end
  
end

---@desc is used for hideing the bet in bonus -- added by whj
function Footer_Node:isShowTotalBetLayout(isShow,notShowLoungeTip)
    self.totalbetNode.isShowTotalBet(isShow,notShowLoungeTip)
end
----------------  Totalbet End  -----------------


----------------  Totalwin Start  -----------------
function Footer_Node:initTotalwin()
    local totalwinNode = self.root.totalwin_node
    if not totalwinNode then return end

    totalwinNode:setLocalZOrder(4)
    self.totalwinNode = totalwinNode

    self.winParticle = totalwinNode.win_particle
    if self.winParticle then
        self.winParticle:stopSystem()
        self.winParticle:setVisible(false)
    end

    self.coinNode = totalwinNode.coin_node
    if self.coinNode then
        self.coinNode:setLocalZOrder(2)
    end

    self.winNode = totalwinNode.win_node
    if self.winNode then
        self.winNode:setLocalZOrder(3)
        self.winNode:setCascadeOpacityEnabled(true)
        
        self.labelWin = self.winNode.label_win
        if self.labelWin then
            self.labelWin:setLocalZOrder(2)
            self.labelWin.objString = 0
            self.labelWin:setOpacity(0)
            self.labelWin.baseScale = self.labelWin:getScale()
            inherit(self.labelWin, LabelNumRoll)
            local parserFunc    = function(mm)
                return self:parserWinLabelFunc(mm)
            end
            self.labelWin:nrInit(0, 24, parserFunc)
        end
        self.labelWin2 = self.winNode.label_win2
        if self.labelWin2 then
            self.labelWin2:setLocalZOrder(2)

            inherit(self.labelWin2, LabelNumRoll)
            local parserFunc    = function(mm)
                return self:parserWinLabelFunc(mm)
            end
            self.labelWin2:nrInit(0, 24, parserFunc)
            self.labelWin2:setVisible(true)
            self.labelWin2:setOpacity(0)
        end

        self.smallWinSpineName1 = "header_footer/spines/small_win/spine"
        self.smallWinSpineName2 = "header_footer/spines/small_win1/spine"    
        self:playSmallWinSpine()

        self.winNode.baseScale     = self.winNode:getScale()
        self.winNode.basePositionY = self.winNode:getPositionY()
        self.winNode.basePositionX = self.winNode:getPositionX()
    end
end

function Footer_Node:playSmallWinSpine(show)

    if self.smallWinSpineName1 then
        if show and libUI.isValidNode(self.winNode) then
            local _, s = libUI.addSpineAnimation(self.winNode, nil, self.smallWinSpineName1, cc.p(0, 110), "animation", nil, nil, nil, true, true, nil)
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
            local _, s = libUI.addSpineAnimation(self.winNode, nil, self.smallWinSpineName2, cc.p(0, 0), "animation2", nil, nil, nil, true, true, nil)
            s:setAnimation(0, "animation1", false)
            s:addAnimation(0, "animation2", true)
            self.smallWinSpine2 = s
            if libUI.isValidNode(self.labelWin2) then
                local base_scale = self.labelWin2:getScale()
                
                self.labelWin2:setScale(0.2*base_scale)
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

function Footer_Node:setWinCoinsString( number )
    self.labelWin:setString(FONTS.format(number,true))--(self:parserWinLabelFunc(number))
    local max_width = (self.isPortrait and 500 or 450)
    bole.shrinkLabel(self.labelWin, max_width, 1)
end

function Footer_Node:reSetWinCoinsString(coins)
    if coins>0 then 
        self.labelWin:setString(FONTS.format(coins,true))
        local max_width = (self.isPortrait and 500 or 450)
        bole.shrinkLabel(self.labelWin, max_width, 1)
    else
        self.labelWin:setString("")
    end
    self.labelWin.objString = coins
end

function Footer_Node:showWinNode()
    self.winNode:setOpacity(255)
end

----------------  Totalwin End  -----------------


----------------  Maxbet Start  -----------------
function Footer_Node:initMaxbet ()
    local maxbet_node = self.root.maxbet_node
    if not maxbet_node then return end

    self.maxbetNode = maxbet_node

    self.btnMaxBet = maxbet_node.btn_maxbet
    if self.btnMaxBet then
        local touchFunc = function (...)
           HttpManager:getInstance():doReport(ReportConfig.btn_maxbet_play)
           bole.playSounds("click")
           self.ctl:changeToMaxBet()
           self:showMaxBetEffect()
           self:displayAutoplayInterface(false)
           EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_MAXBET)
       end
       self:addTouchEvent(self.btnMaxBet, touchFunc)
    end

end

function Footer_Node:addMaxBetFlash()
    if not self.maxBetFlash and self.maxBetSpine then
        self.maxBetFlash = 0
        -- local file = "res/header_footer/style2/footer/spines/maxbet/spine"
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

function Footer_Node:showMaxBetEffect()
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

function Footer_Node:setMaxBetState( isMaxBet )
end
----------设置MaxBet和Add按钮的状态以及到达MaxBet时需要播放的动画效果-------
function Footer_Node:setMaxBetBtnEnable( enable,  notCacheTag )
    if not notCacheTag then
        self.maxBetTag = enable
    end
    if  self.btnMaxBet then
        self.btnMaxBet:setTouchEnabled(enable)
        self.btnMaxBet:setBright(enable)
    end
    
end

function Footer_Node:showMaxBetActivated(activated)
end
----------------  Maxbet End  -----------------


----------------  Spin Start  -----------------
function Footer_Node:initSpin()
    local spin_node = self.root.spin_node 
    if not spin_node then return end

    self.spinNode = spin_node
    self.spinNode:setLocalZOrder(4)

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
    self.autoSpinNode = spin_node.auto_node
    if self.autoSpinNode then
        self.autoSpinNode:setVisible(false)

        local onAutoTouch = function( autoCount )
            self:displayAutoplayInterface(false)
            self.ctl:setAutoSpinCount(autoCount)
            self.ctl:enableAuto(true)
            if autoCount == "fast" then
                fastBool = true
                self.ctl:setAutoSpinFast(false)
                self.btnStop.label_normal:setVisible(false)
            end
        end

        local btnTags = {"fast", 500, 100, 50, 20, 10}
        for index = 1, #btnTags do
            local tag  = btnTags[index]
           
            local name = "btnAuto"..(index == 1 and "Fast" or tag)
            self[name] = self.autoSpinNode["btn_" .. tag]
            local touchAuto = function (...)
                bole.playSounds("click")
                onAutoTouch(tag)
                if index == 1 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_auto_fast_play)
                elseif index == 2 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_auto_500_play)
                elseif index == 3 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_auto_100_play)
                elseif index == 4 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_auto_50_play)
                elseif index == 5 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_auto_20_play)
                else
                    HttpManager:getInstance():doReport(ReportConfig.btn_auto_10_play)
                end
            end
            self:addTouchEvent(self[name], touchAuto)
        end

        self.disappear_btn = self.autoSpinNode.btn_disappear
        if self.disappear_btn then
            local disappear_touch = function ()
                bole.playSounds("click")
                self:displayAutoplayInterface(false) -- 点击spin 使autospin 小弹窗消失
            end
            self:addTouchEvent(self.disappear_btn, disappear_touch)
        end

    end
    
    ---------------autostop按钮--------------
    self.btnStop = spin_node.btn_autostop
    if self.btnStop then
        local touchAutoStop = function (...)
            -- bole.playSounds("click")
            fastBool = false
            self.ctl:setAutoSpinCount(0)
            self.ctl:enableAuto(false)
        end
        self:addTouchEvent(self.btnStop, touchAutoStop)

        self.btnStop.stop = self.btnStop.label_stop
        self.btnStop.stop_fast = self.btnStop.label_stopfast
        self.btnStop.stopPoY = self.btnStop.stop:getPositionY()

        local function stopBtnEvent(sender, eventType)
            -- bole.playSounds("click")
            if eventType == ccui.TouchEventType.began then
                bole.updateSpriteWithFile(self.btnStop.stop, "#STOP02.png")
                self.btnStop.stop:setPositionY(self.btnStop.stopPoY - 5)
                self.btnStop.stop_fast:setPositionY(self.btnStop.stopPoY - 12)
                self.btnStop.label_normal:setVisible(false)
                self.btnStop.label_pressed:setVisible(true)
            elseif eventType == ccui.TouchEventType.moved then
                local point = sender:getTouchMovePosition()
                point = self.btnStop:convertToNodeSpace(point)
                if point.x < 0 or point.x > self.btnStop:getContentSize().width or point.y < 0 or point.y > self.btnStop:getContentSize().height then
                    -- 移出按钮
                    bole.updateSpriteWithFile(self.btnStop.stop, "#STOP.png")
                    self.btnStop.stop:setPositionY(self.btnStop.stopPoY)
                    self.btnStop.stop_fast:setPositionY(self.btnStop.stopPoY-7)
                    self.btnStop.label_normal:setVisible(true)
                    self.btnStop.label_pressed:setVisible(false)
                else
                    bole.updateSpriteWithFile(self.btnStop.stop, "#STOP02.png")
                    self.btnStop.stop:setPositionY(self.btnStop.stopPoY - 5)
                    self.btnStop.stop_fast:setPositionY(self.btnStop.stopPoY - 12)
                    self.btnStop.label_normal:setVisible(false)
                    self.btnStop.label_pressed:setVisible(true)
                end
            elseif eventType == ccui.TouchEventType.ended then
                bole.updateSpriteWithFile(self.btnStop.stop, "#STOP.png")
                self.btnStop.stop:setPositionY(self.btnStop.stopPoY)
                self.btnStop.stop_fast:setPositionY(self.btnStop.stopPoY-7)
                self.btnStop.label_normal:setVisible(true)
                self.btnStop.label_pressed:setVisible(false)
                touchAutoStop()
            elseif eventType == ccui.TouchEventType.canceled then
                bole.updateSpriteWithFile(self.btnStop.stop, "#STOP.png")
                self.btnStop.stop:setPositionY(self.btnStop.stopPoY)
                self.btnStop.stop_fast:setPositionY(self.btnStop.stopPoY-7)
                self.btnStop.label_normal:setVisible(true)
                self.btnStop.label_pressed:setVisible(false)
            end
        end
        self.btnStop:addTouchEventListener(stopBtnEvent)
    end
 
    ---------------spin按钮--------------

    self.btnSpin = spin_node.btn_spin
    if self.btnSpin then
        local function btnSpinState(enabled, isNormal)
            if enabled then
                bole.updateSpriteWithFile(self.btnSpin.spin_l, "#SPIN.png")
                bole.updateSpriteWithFile(self.btnSpin.hold_l, "#HOLDFORAUTO.png")
                bole.updateSpriteWithFile(self.btnSpin.stop_l, "#STOP.png")
                self.btnSpin.spin_l:setPositionY(self.btnSpin.spinPosY)
                self.btnSpin.hold_l:setPositionY(self.btnSpin.holdPosY)
                self.btnSpin.stop_l:setPositionY(self.btnSpin.stopPosY)
            else
                bole.updateSpriteWithFile(self.btnSpin.spin_l, "#SPIN02.png")
                bole.updateSpriteWithFile(self.btnSpin.hold_l, "#HOLDFORAUTO02.png")
                bole.updateSpriteWithFile(self.btnSpin.stop_l, "#STOP02.png")
                self.btnSpin.spin_l:setPositionY(self.btnSpin.spinPosY - 5)
                self.btnSpin.hold_l:setPositionY(self.btnSpin.holdPosY - 5)
                self.btnSpin.stop_l:setPositionY(self.btnSpin.stopPosY - 3) 
            end
            self.btnStop.label_normal:setVisible(isNormal)
            self.btnStop.label_pressed:setVisible(not isNormal)
        end

        local function spinEvent(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                btnSpinState(false, false)

                self.isAutoNodeVisible = self.autoSpinNode:isVisible()
                local isBreakSpin = self.ctl:touchSpinCheckDealAutoSpin()
                if not isBreakSpin and not self.isAutoNodeVisible and self:checkCanClickSpin() then
                    self.ctl:touchSpinBtnBegan( self.btnSpin )                
                end
                self:showMaxBetActivated(false)
                return false
            elseif eventType == ccui.TouchEventType.moved then
                local point = sender:getTouchMovePosition()
                point = self.btnSpin:convertToNodeSpace(point)
                if point.x < 0 or point.x > self.btnSpin:getContentSize().width or point.y < 0 or point.y > self.btnSpin:getContentSize().height then
                    -- 移出按钮
                    btnSpinState(true, true)
                else
                    btnSpinState(false, false)
                end
            elseif eventType == ccui.TouchEventType.ended then
                btnSpinState(true, true)
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
                bole.playSounds("click")
                HttpManager:getInstance():doReport(ReportConfig.btn_spine_play)
                EventCenter:pushEvent(EVENTNAMES.THEME.CLICK_SPIN)
                self:hideSpinChargeSpine()
    
            elseif eventType == ccui.TouchEventType.canceled then
                btnSpinState(true, true)
                self.ctl:touchSpinBtnCanceled( self.btnSpin )
            end
        end

        self.btnSpin:addTouchEventListener(spinEvent)

        self.btnSpin.spin_l = self.btnSpin.label_spin
        self.btnSpin.hold_l = self.btnSpin.label_hold
        self.btnSpin.stop_l = self.btnSpin.label_stop
        self.btnSpin.spinPosY = self.btnSpin.label_spin:getPositionY()
        self.btnSpin.holdPosY = self.btnSpin.label_hold:getPositionY()
        self.btnSpin.stopPosY = self.btnSpin.label_stop:getPositionY()
        self.btnSpin.spin_l._baseScaleX = self.btnSpin.spin_l:getScaleX()
        self.btnSpin.spin_l._baseScaleY = self.btnSpin.spin_l:getScaleY()
        self.btnSpin.hold_l._baseScaleX = self.btnSpin.hold_l:getScaleX()
        self.btnSpin.hold_l._baseScaleY = self.btnSpin.hold_l:getScaleY()

        self.spinNode.changeSpinLabel = function (disable)
            bole.updateSpriteWithFile(self.btnSpin.spin_l, disable and "#SPIN_disable.png" or "#SPIN.png")
            bole.updateSpriteWithFile(self.btnSpin.hold_l, disable and "#HOLDFORAUTO_disable.png" or "#HOLDFORAUTO.png")
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
                bole.updateSpriteWithFile(self.btnSpin.spin_l, "#SPIN_disable.png")
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
                    if fastBool then
                        self.btnStop.stop_fast:setVisible(true)
                        self.btnStop.stop:setVisible(false)
                    else
                        self.btnStop.stop_fast:setVisible(false)
                        self.btnStop.stop:setVisible(true)
                    end
              
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
                bole.updateSpriteWithFile(self.btnSpin.spin_l, "#SPIN.png")
            else
                bole.updateSpriteWithFile(self.btnSpin.stop_l, "#STOP03.png")
            end
        end

        self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, false, false)
        self.canSpin = true

        self.copyBtnEvent = function ( ... )
            if self.btnSpin:isVisible() and self.btnSpin:isTouchEnabled() then
                spinEvent(nil,ccui.TouchEventType.began)
                spinEvent(nil,ccui.TouchEventType.ended)
            elseif self.btnStop:isVisible() and self.btnStop:isTouchEnabled() then
                stopBtnEvent(nil,ccui.TouchEventType.began)
                stopBtnEvent(nil,ccui.TouchEventType.ended)
            end
        end

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

function Footer_Node:hideSpinChargeSpine()
    if libUI.isValidNode(self.spinChargeSpine) then
        self.spinChargeSpine:removeFromParent()
        self.spinChargeSpine = nil
    end
end

function Footer_Node:stopWinAction() -- 停止 WinEffect 和 rollUp 动画
    if self.isSamllWinpop then
        self:stopSmallWinEffect()
    elseif self.isNormalWinpop then
        self:stopNormalWinEffect()
    elseif self.isBigWinpop then
        self:stopBigWinEffect(true)
    end
end

--------------------配置Auto Play相关--------------------------------
function Footer_Node:displayAutoplayInterface(show)
    self.autoSpinNode:setVisible(show)
    --self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, "ingore", "ingore")
end   

function Footer_Node:checkCanClickSpin( )
    return not self.spinNode.isForbid
end

function Footer_Node:isAutoSpinFast()
    local autoFast = false
    if (self.ctl.isAutoSpinFast and self.ctl:isAutoSpinFast()) then
        autoFast = true
    end
    return autoFast
end

function Footer_Node:setAutoplayRemaining(count)
    if self:isAutoSpinFast() then
        count = ""
    end
    self.btnStop.label_normal:setString(tostring(count))
    self.btnStop.label_pressed:setString(tostring(count))
end 

function Footer_Node:checkInAutoSpin()
    if libUI.isValidNode(self) then
        return self.spinNode.curStatue == SPIN_STATUS_NAME.AUTO_SPIN
    end
    return false
end

function Footer_Node:setSpinBtnEnableCallback(callback)
    self.spinBtnEnableCallback = callback
end

function Footer_Node:playSpinChargeSpine()
    if not libUI.isValidNode(self.spinNode) then 
        return 
    end
    local path = "header_footer/spines/charge/spine"
    local _, s = libUI.addSpineAnimation(self.spinNode, 4, path, cc.p(0, 0), "animation", nil, nil, nil, true, false, nil)
    self.spinChargeSpine = s
end

function Footer_Node:_changeDialogTouch(data)
    local data = data or {}
    self.keySpaceDialogFunc = data.touch_func
end

function Footer_Node:onSpinStart( )
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
    self.canSpin = false
end

function Footer_Node:enableOtherBtns( enable )
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
    if self.btnAddBet then
        self.btnAddBet:setTouchEnabled(enable)
        self.btnAddBet:setBright(enable) 
    end
    if self.btnSubBet then
        self.btnSubBet:setTouchEnabled(enable)
        self.btnSubBet:setBright(enable)
    end
 
 

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
function Footer_Node:checkInFreeSpin( )
    return self.isFreeSpin
end
function Footer_Node:checkInAutoSpin()
    if libUI.isValidNode(self) then
        return self.spinNode.curStatue == SPIN_STATUS_NAME.AUTO_SPIN
    end
    return false
end
function Footer_Node:checkCanClickSpin( )
    return not self.spinNode.isForbid
end
--------------------------------------------------------------------
--------------------------------------------------------------------

function Footer_Node:changeLabelDescription(status, addCoins)
end

function Footer_Node:checkCleanCoinsAdd( )
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




----------------------   setWinCoinsEffect   --------------------------
function Footer_Node:setWinCoins( coins , start, tb)  -- tb:totalBet
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

function Footer_Node:_getEffectConfig(muti)
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
function Footer_Node:setWinCoinsEffect( coins , start, tb, endCallFunc)  -- tb:totalBet
    coins = coins or 0
    if(coins>0) then
        self.winCallback = endCallFunc
        local muti = coins/tb
        self:realSetWinCoinsEffect(coins , start, muti)
    elseif endCallFunc then
        endCallFunc()
    end
end

function Footer_Node:setWinCoinsEffectByMuti(coins, start, endCallFunc,muti)
    if(coins>0) then
        self.winCallback = endCallFunc
        local muti = muti
        self:realSetWinCoinsEffect(coins, start, muti)
    elseif endCallFunc then
        endCallFunc()
    end
end

function Footer_Node:realSetWinCoinsEffect(coins , start, muti)
    if self.showingWinEffect then
        return
    end
    -- muti = 5 
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


function Footer_Node:updateWin(coins , start, interval,isup)
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

function Footer_Node:showWinEffect()
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

function Footer_Node:showBigWinEffect(coins)
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

function Footer_Node:createNewCoin(coins,direction)
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

function Footer_Node:createBigWinCoin(coins, index)

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

function Footer_Node:AnimateCoin(coin)
    
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

function Footer_Node:AnimateBigCoin(coin, index)
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

function Footer_Node:tryStopWinEffect( ... )
    if self.winParticle then
        self.winParticle:stopSystem()
    end
    -- if bole.isValidNode(self.effectNode) then
    --     self.effectNode:removeFromParent()
    -- end
end

function Footer_Node:stopWinAction() -- 停止 WinEffect 和 rollUp 动画
    if self.isSamllWinpop then
        self:stopSmallWinEffect()
    elseif self.isNormalWinpop then
        self:stopNormalWinEffect()
    elseif self.isBigWinpop then
        self:stopBigWinEffect(true)
    end
end

function Footer_Node:stopSmallWinEffect()
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

function Footer_Node:stopNormalWinEffect()
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

function Footer_Node:stopBigWinEffect(force)
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

function Footer_Node:copySpinBtnEvent()
    if self.copyBtnEvent then
        self.copyBtnEvent()
    end
end

function Footer_Node:parserWinLabelFunc(num)
    return bole.dealValueToRetString(num, -1, nil, false)--'$' ..
end


function Footer_Node:onFinishSpin( ... )
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

function Footer_Node:onFastStop( ... )
    if not self:isAutoSpinFast() then
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, false, true)
    end
end

function Footer_Node:onRespinStart( )
    self:onSpinStart()
end
function Footer_Node:onRespinOver( )
    self:onFinishSpin()
end
function Footer_Node:onRespinFastStop( )
    self:onFastStop()
end
function Footer_Node:setSpinStateOnFinishSpin(enable)
    self.islocked = enable
 end
 function Footer_Node:enableAuto( enable )
    if enable then
        G_THEME_FAST_TAG = true
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.AUTO_SPIN, "ingore", "ingore")
    else
        G_THEME_FAST_TAG = false
        self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, "ingore", "ingore")
    end
end

-- 打开所有活动节点( B 和 C 级 同时控制)
function Footer_Node:showActivitysNode( ... )
    EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_SHOW_ACTION)
end
-- 隐藏所有活动节点( B 和 C 级 同时控制)
function Footer_Node:hideActivitysNode( ... )
    EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION)
end

function Footer_Node:setSpinButtonState( state ) -- true是锁住状态，false是可以点击状态
    self.spinNode:changeBtnState("ingore", "ingore", state)
end

function Footer_Node:setSpinButtonNormal(  )
    self.spinNode:changeBtnState(SPIN_STATUS_NAME.NORMAL_SPIN, "ingore", true, true)
end


function Footer_Node:canToAutoSpin()
    return false
end

function Footer_Node:hideBoosterDimmer(hideInfo)
   
end


function Footer_Node:showSpinNodeClickSpine(show)
 
end

function Footer_Node:getTurboStatus( ... )
    return false
end

return Footer_Node