local Ad_Reward_Node = require (bole.getDesktopFilePath("AdReward/Ad_Reward_Node"))
local Coin_Node      = require (bole.getDesktopFilePath("HeaderFooter/Coin_Node"))
local Diamond_Node   = require (bole.getDesktopFilePath("HeaderFooter/Diamond_Node"))
local BLNode         = require("UI/CreatorUI/BLNode")

local Header_Node = class("Header_Node", BLNode)

function Header_Node:ctor(theCtl, isPortrait)
    self.themeCtl   = theCtl
    self.isPortrait = isPortrait
    self.ctl        = HeaderFooterControl:getInstance()
    self.csb        = string.format("ui/header_footer/%s",  "lobby_header")
    self.node       = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self:loadControls()
    -- self:initFaceBook()
	local isGame = bole.isThemeScene()
	local player_head = self.root.player_head
	local zhuye = self.root.btn_zhuye

    local bg_node = self.root.bg_node
	local gameBg = self.root.gameBg

	local btn_setting_hall = self.root.btn_settinghall
    local btn_setting = self.root.btn_setting

	if isGame then
		bg_node: setVisible(false)
        player_head: setVisible(false)
		zhuye:setVisible(true)
        gameBg:setVisible(true)
        btn_setting_hall:setVisible(false)
		btn_setting:setVisible(true)
	else
		player_head:setVisible(true)
		zhuye:setVisible(false)
        bg_node:setVisible(true)
		gameBg:setVisible(false)
        btn_setting_hall:setVisible(true)
		btn_setting:setVisible(false)
	end
end

function Header_Node:loadControls()
    self.root = self.node.root
    
    self:configCoinNode()
    self:configDiamondNode()
    -- self:addAdRewardNode()

    local tip_node = self.root.tip_node
	if tip_node then
		tip_node:setVisible(false)
    end

    
	local starAnim = self.root.starAnim
	if starAnim then
		local forever =  cc.RepeatForever:create( cc.Sequence:create(
			cc.DelayTime:create(8), cc.CallFunc:create(function ()
                starAnim:setVisible(true)
				local num = self:getRandomNum(1,2)
				local animName = ""
				if num == 1 then
					animName = "animation"
				else
					animName = "animation2"
				end
				starAnim:setAnimation(0, animName, false)
			end)
		))
		starAnim:runAction(forever)
	end

end


function Header_Node: getRandomNum(num1, num2)
    math.randomseed(os.time()) -- 设置随机数种子
    local random_num = math.random(num1, num2) -- 生成1到10之间的随机整数 
    return random_num
end


function Header_Node: initFaceBook()
    local state = User:getInstance():isloginFB()
    local facebook_node = self.root.facebook_node
    if facebook_node then
        facebook_node:setVisible(true)
        if state then
            facebook_node:setVisible(false)
         else
            facebook_node:setVisible(true)
         end
    end
  
end

function Header_Node:getDiamondNode()
    return self.diamond_node
end

-- 配置金币
function Header_Node:configCoinNode()
    self.coin_node = self:createHeaderCoinNode()
end

-- 创建金币节点
function Header_Node:createHeaderCoinNode(is_self)
    if is_self and self.coin_node then
        return self.coin_node
    end

    local ui_coin = Coin_Node.new(self.isPortrait)
    self.ui_coins   = self.ui_coins or {}
    self.ui_coins[#self.ui_coins + 1] = ui_coin
    self.root:addChild(ui_coin)

    return ui_coin
end

--[[
* 名称：addCoins
* 功能：1s将金币加到金币栏
* 参数：
	- start：金币初始值
	- off：金币增加值 
* 返回值：无
]]--
function Header_Node:addCoins(start, off)
    local dur 			= 1
    self:setCoinsScale(start, start + off)

    if self.ui_coins then
        for k, ui in pairs(self.ui_coins) do
            if ui and libUI.isValidNode(ui.label_coins) then
                ui.label_coins:nrStartRoll(nil, start + off, dur, nil)
            end
        end
    end
end

function Header_Node:setCoinsScale(before, after)
    if self.ui_coins then
        for k, coin_node in pairs(self.ui_coins) do
            if libUI.isValidNode(coin_node) then
                coin_node.label_coins:setString(self.ctl:formatCoin(after))
                bole.shrinkLabel(coin_node.label_coins, coin_node.width, coin_node.start_scale)
                coin_node.label_coins:setString(self.ctl:formatCoin(before))
            end
        end
    end
end

--[[
* 名称：addChips
* 功能：1s将金币加到金币栏
* 参数：
	- start：金币初始值
	- off：金币增加值
* 返回值：无
]]--
function Header_Node:addChips(start, off)
    local dur 			= 1
    self:setChipsScale(start, start + off)

    if self.ui_diamonds then
        for k, ui in pairs(self.ui_diamonds) do
            if ui and libUI.isValidNode(ui.label_diamonds) then
                ui.label_diamonds:nrStartRoll(nil, start + off, dur, nil)
            end
        end
    end
end

function Header_Node:setChipsScale(before, after)
    if self.ui_diamonds then
        for k, Diamond_Node in pairs(self.ui_diamonds) do
            if libUI.isValidNode(Diamond_Node) then
                Diamond_Node.label_diamonds:setString(self.ctl:formatCoin(after))
                bole.shrinkLabel(Diamond_Node.label_diamonds, Diamond_Node.width, Diamond_Node.start_scale)
                Diamond_Node.label_diamonds:setString(self.ctl:formatCoin(before))
            end
        end
    end
end


-- 配置钻石
function Header_Node:configDiamondNode()
    if self.isPortrait then return end
    self.diamond_node = self:createHeaderDiamondNode()
end

-- 创建钻石节点
function Header_Node:createHeaderDiamondNode(is_self)
    if is_self and self.diamond_node then
        return self.diamond_node
    end

    local ui_diamond = Diamond_Node.new()
    self.ui_diamonds = self.ui_diamonds or {}
    self.ui_diamonds[#self.ui_diamonds + 1] = ui_diamond
    self.root:addChild(ui_diamond)

    return ui_diamond
end

-- 添加广告奖励
function Header_Node:addAdRewardNode()
    local pos = self.isPortrait and cc.p(-56, -50) or cc.p(130, -37)
    local ad_node = Ad_Reward_Node.new(pos, self.isPortrait)
    self.root:addChild(ad_node)
end

-- 入场动画
function Header_Node:enterAction(isFromTheme)
    if isFromTheme then return end
    
    local posGap = 200
    self.node:setPositionY(self.node:getPositionY() + posGap);
    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.MoveBy:create(0.8, cc.p(0, -posGap))
        )
    )

end


function Header_Node:LobbyBtnState()
end

-- 返回大厅
function Header_Node:onBtnLobbyClicked()
    self.themeCtl:unregisterPotpCmds()
	self.themeCtl.theme:unloadThemeMusics()

	local screenCtl = ScreenControl:getInstance()
    screenCtl:setScreenOrientation(false)
    bole.playSounds("click")
    HttpManager:getInstance():doReport(ReportConfig.btn_backlobby_play)
    local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
    local scene = Lobby_Scene.new("Play")
    scene:run()
end

function Header_Node:onBtnCloseClicked()
    
end



-- 弹窗气泡窗
function Header_Node:showTip(posX, posY, index)
	local tip_node = self.root.tip_node
    local unlockArr = {500,600,650,700,750,800,900,950,1000}
	if tip_node then
        local label_diamonds = tip_node.label_diamonds
        label_diamonds:setString(unlockArr[index])

		tip_node:setVisible(true)
		tip_node:stopAllActions()
		tip_node:setOpacity(0)
		tip_node:setScale(0)
        tip_node:setPosition(posX, posY - 160)
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


-- 打开送金币
function Header_Node:onBtnGetcoinClicked()
    bole.playSounds("click")
    PopupController:getInstance():popupDialogDirectly("freecoins")
end

-- 打开设置弹窗
function Header_Node:onBtnSettingClicked()
	bole.playSounds("click")
    local wPos = bole.getWorldPos(self.root.btn_setting)
    PopupController:getInstance():popupDialogDirectly("setting", {pos = wPos})
end

-- 打开设置弹窗
function Header_Node:onBtnSettinghallClicked()
	bole.playSounds("click")
    local wPos = bole.getWorldPos(self.root.btn_setting)
    PopupController:getInstance():popupDialogDirectly("setting", {pos = wPos})
end


 -- 打开ad
function Header_Node:onBtnAdClicked()
    bole.playSounds("click")
    PopupController:getInstance():popupDialogDirectly("inspect_ad")  --ad_reward inspect_ad
end

function Header_Node:onBtnCollectClicked()
    local pos = cc.p(self.root.btn_collect:getPosition())
    self:showTip(pos.x, pos.y, 1)
    HttpManager:getInstance():doReport(ReportConfig.btn_top_1_lobby)
end

function Header_Node:onBtnFriendClicked()
    local pos = cc.p(self.root.btn_friend:getPosition())
    self:showTip(pos.x, pos.y, 2)
    HttpManager:getInstance():doReport(ReportConfig.btn_top_2_lobby)
end

function Header_Node:onBtnZhuyeClicked()
    self.themeCtl:unregisterPotpCmds()
	self.themeCtl.theme:unloadThemeMusics()

	local screenCtl = ScreenControl:getInstance()
    screenCtl:setScreenOrientation(false)
    bole.playSounds("click")
    local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
    local scene = Lobby_Scene.new("Play")
    scene:run()
    HttpManager:getInstance():doReport(ReportConfig.btn_backlobby_play)
end

return Header_Node