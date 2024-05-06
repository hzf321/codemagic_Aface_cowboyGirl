
local commonHide = function(node) 
	-- local action_out = cc.EaseBackIn:create(cc.MoveBy:create(0.5, cc.p(0, 200)))
	local action_out = cc.EaseSineIn:create(cc.MoveBy:create(0.35, cc.p(0, 200)))

	node:runAction(cc.Sequence:create(
		action_out,
		cc.RemoveSelf:create()
		)
	)
end 

THEME_TIP_POS = cc.p((1280 - 274)*SCREEN_RATIO, 720 - 160)
if PAD_TAG then
	THEME_TIP_POS = cc.p((1280 - 274)*SCREEN_RATIO, 720 - 160 + MARGIN_H/2 + 15)
end

------------------------Jackpot Notification Dialog------------------------
--  jackpot tips 
ThemeJackpotTip = class("ThemeJackpotTip",CCSNode)

function ThemeJackpotTip:ctor(name , pic, theme_id, coins, callback)
	local screenCtl  = ScreenControl:getInstance()
	self.isPortrait  = screenCtl.isPortrait
	self.nameStr     = name
	self.fbpic       = pic
	self.themeName   = THEME_LIST[theme_id]['name']
	self.coins       = coins
	self.callback    = callback
 	CCSNode.ctor(self,"themetips/jackpotnotification/jackpotnotification.csb")
 	self.nodeEventListener:setSwallowTouches(false)

end

function ThemeJackpotTip:loadControls( )
	self.root        = self.node:getChildByName("root")
	self.bg_anim    = self.root:getChildByName("bg_anim")
	self.userIcon    = self.root:getChildByName("icon")
	self.labelPlayer = self.root:getChildByName("label_player")
	self.labelPlayer:setString(self.nameStr)
	bole.shrinkLabel(self.labelPlayer, 225, 1)
	self.labelTheme  = self.root:getChildByName("label_theme")
	self.labelTheme:setString(self.themeName)
	self.labelWon    = self.root:getChildByName("label_won")
	self.labelWon:setString(FONTS.format(self.coins, true))
	bole.shrinkLabel(self.labelWon, 225, 1)
	bole.shrinkLabel(self.labelTheme, 194, 1)

	if self.userIcon then

		local temp_plist = "themetips/jackpotnotification/plist/plist.plist"
		if cc.FileUtils:getInstance():isFileExist(temp_plist) then
			cc.SpriteFrameCache:getInstance():addSpriteFrames(temp_plist)
		end

		local icon_path = "#themetips/jackpotnotification/texture/notification_frame04.png"
		if icon_path and cc.SpriteFrameCache:getInstance():getSpriteFrame(string.sub(icon_path, 2)) then
			local mask = cc.Sprite:createWithSpriteFrameName(string.sub(icon_path, 2))
			self.clipParent = cc.ClippingNode:create(mask)
			libUI.createSprite(self.clipParent, "commonpics/icon_common_noavatar.png", nil, nil, nil, 0.55)
	        self.userIcon:addChild(self.clipParent, 0)
	        self.clipParent:setAlphaThreshold(0.8)
	        if self.fbpic then
		        local statue = LazySprite.new(self.fbpic, cc.size(126, 126), nil)
		        self.clipParent:addChild(statue, 2)
		    end
	    end

	end
end

function ThemeJackpotTip:show( parent )
	parent = parent or bole.scene
	parent:addChild(self)

	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT+500, FRAME_WIDTH-150)
	else
		self:setPosition(FRAME_WIDTH+500, FRAME_HEIGHT-100)
	end
	
	local function closeAction()
		self:hide()
	end

	bole.addSpineAnimation(self.bg_anim, nil, "themetips/jackpotnotification/spine/spine", cc.p(0,0), "animation", nil, nil, nil, true, true, nil)

	local duration = 0.5
	self:runAction(cc.Sequence:create(
		cc.MoveBy:create(duration,cc.p(-500,0)),
		cc.DelayTime:create(3),
		cc.MoveBy:create(duration,cc.p(500,0)),
		cc.CallFunc:create(closeAction)))
end

function ThemeJackpotTip:hide()
	if self.callback then self.callback() end

	if self then
		self:removeFromParent()
	end
end

------------------------Frenzy Game Tips ------------------------ 
ThemeFrenzyGameTip = class("ThemeFrenzyGameTip",CCSNode)
function ThemeFrenzyGameTip:ctor()
	local screenCtl  = ScreenControl:getInstance()
	self.isPortrait  = screenCtl.isPortrait
 	CCSNode.ctor(self,"themetips/frenzygame/frenzy_game.csb")
 	self.nodeEventListener:setSwallowTouches(false)
end

function ThemeFrenzyGameTip:loadControls( )
	self.root = self.node:getChildByName("root")
	self.root:setPositionX(self.root:getPositionX() - 500)
	self.root:setOpacity(0)
end

function ThemeFrenzyGameTip:show( parent )
	parent = parent or bole.scene
	parent:addChild(self)

	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT+400, FRAME_WIDTH-110)
		self:setScale(0.8)
	else
		self:setPosition(FRAME_WIDTH+500, FRAME_HEIGHT-80)
	end
	
	local function closeAction()
		self:hide()
	end

	local duration = 0.5
	self.root:runAction(cc.Sequence:create(
		cc.FadeTo:create(duration, 255),
		cc.DelayTime:create(5),
		cc.FadeTo:create(duration, 0),
		cc.CallFunc:create(closeAction)))
end

function ThemeFrenzyGameTip:hide()
	if self.callback then self.callback() end

	if self then
		self:removeFromParent()
	end
end

-- ------------------------BC Words Game Tips ------------------------ 
-- ThemeBCWordsGameTip = class("ThemeBCWordsGameTip",CCSNode)
-- function ThemeBCWordsGameTip:ctor()
-- 	local screenCtl  = ScreenControl:getInstance()
-- 	self.isPortrait  = screenCtl.isPortrait
-- 	CCSNode.ctor(self,"themetips/bc_words_game/bc_words_game.csb") -- 获取要弹出的csb
--  	self.nodeEventListener:setSwallowTouches(false)
-- end

-- function ThemeBCWordsGameTip:loadControls( )
-- 	self.root = self.node:getChildByName("root")
-- 	self.root:setPositionX(self.root:getPositionX() - 500)
-- 	self.root:setOpacity(0)
-- end

-- function ThemeBCWordsGameTip:show( parent )
-- 	parent = parent or bole.scene
-- 	parent:addChild(self)

-- 	if self.isPortrait then
-- 		self:setPosition(FRAME_HEIGHT+400, FRAME_WIDTH-110)
-- 		self:setScale(0.8)
-- 	else
-- 		self:setPosition(FRAME_WIDTH+500, FRAME_HEIGHT-80)
-- 	end
	
-- 	local function closeAction()
-- 		self:hide()
-- 	end

-- 	local duration = 0.5
-- 	self.root:runAction(cc.Sequence:create(
-- 		cc.FadeTo:create(duration, 255),
-- 		cc.DelayTime:create(5),
-- 		cc.FadeTo:create(duration, 0),
-- 		cc.CallFunc:create(closeAction)))
-- end

-- function ThemeBCWordsGameTip:hide()
-- 	if self.callback then self.callback() end

-- 	if self then
-- 		self:removeFromParent()
-- 	end
-- end

local function getLevelUpCsbPath(name) 
    return "themetips/levelup2/" .. name .. ".csb"
end

local function getLevelUpSpinePath(name) 
    return "themetips/levelup2/spines/" .. name .. "/spine"
end

------------------------Level up tips Dialog------------------------
-- 升级奖励信息 
ThemeLevelUpTip = class("ThemeLevelUpTip", CCSNode) 
function ThemeLevelUpTip:ctor(data) 
	self.level         = data.level or 1
	self.rewardCoins   = data.coin_reward or 0
	self.boosterMul    = data.booster_mul or 0
	self.maxBet        = data.max_bet or 0
	self.turboReward   = data.turbo_reward or 0
	self.dailyReward   = data.daily_reward or 0
	self.vipPoints     = data.status_point or 0
	self.isPortrait    = data.isPortrait
	self.loungePoints  = data.lounge_points or 0
	self.isVipBooster  = ActivityCenterControl:getInstance():canShowPart("levelup", "vip")
	self.isDoubleBlast = ActivityCenterControl:getInstance():canShowPart("levelup", "double_blast")
	self.isBooster     = (StoreControl:getInstance():getLevelBurstLeftTime() > 0)
	self.csb 		   = getLevelUpCsbPath("levelup")
	self.themeCtl      = data.themeCtl
	self.showUserGuide = (UserGuideControl:getInstance():isNewUser() and self.level == 5)

	CCSNode.ctor(self, self.csb)
	self.nodeEventListener:setSwallowTouches(false)
end

function ThemeLevelUpTip:loadControls()
	local rootNode = self.node:getChildByName("node")
	local root = rootNode:getChildByName("root")
	local node_mul = root:getChildByName("node_mul")
	local node_head = node_mul:getChildByName("node_head")
	local node_win = node_mul:getChildByName("node_win")
	local node_booster = node_mul:getChildByName("node_booster")
	local node_col = node_mul:getChildByName("node_col")

	self.root = root
    -- 配置等级
    local label_level = node_head:getChildByName("label_level")
	if label_level then
		label_level:setString(self.level)
	end

    -- 配置奖金
    local label_win = node_win:getChildByName("label_win")
	if label_win then
		label_win:setString(FONTS.formatByCount(self.rewardCoins, 12))
		self.labelReward = label_win
	end

    -- 配置booster
	local label_mul = node_booster:getChildByName("label_mul")
	if self.boosterMul and self.boosterMul > 1 and label_mul then
		label_mul:setString("x" .. self.boosterMul)
		node_booster:setVisible(true)
	else
		node_booster:setVisible(false)
	end

	local maxBetMultiplier = node_win:getChildByName("max_bet_multiplier")
    local lounge_points = node_win:getChildByName("lounge_points")
    local dailyReward = node_win:getChildByName("daily_reward")
    local vipPoint = node_win:getChildByName("status_point")
	self:setNodeWinPos(maxBetMultiplier, lounge_points, dailyReward, vipPoint)

    -- 配置MaxBet multiplier
	maxBetMultiplier:setVisible(self.maxBet > 0)
    local labelMaxBet = maxBetMultiplier:getChildByName("label_amount")
    labelMaxBet:setString(FONTS.format(self.maxBet, true))

    -- 配置Lounge Points
	lounge_points:setVisible(self.loungePoints > 0)
    local labelLounge = lounge_points:getChildByName("label_amount")
    labelLounge:setString(FONTS.format(self.loungePoints, true))

    -- 配置Daily Reward 
	dailyReward:setVisible(self.dailyReward > 0)
    local labelDaily = dailyReward:getChildByName("label_amount")
    labelDaily:setString(FONTS.format(self.dailyReward, true))

    -- 配置VIP point 
	vipPoint:setVisible(self.vipPoints > 0)
    local labelVipPoint = vipPoint:getChildByName("label_amount")
	labelVipPoint:setString(FONTS.format(self.vipPoints, true))

	-- 更新VIP图标
    local vipIcon = vipPoint:getChildByName("levelup_icon")
    local multi_node = BirthdayVipMultiNode.new()
    if multi_node then
        multi_node:addSelftToLevelUpItem(vipIcon)
    end

    -- 更新VIP图标
	local user    = User:getInstance()
	self.vipLevel = user.vip_level
	if vipIcon and self.vipLevel then
		vipIcon:setTexture('commonpics/card' .. self.vipLevel .. '_vip_3.png')

		vipIcon:setScale(0.7)
	end

	self.canShowAds = ADSControl:getInstance():canShowAds(ADType.REWARDVIDEO);
	self.isCollected  = false

	-- 配置 看广告 的按钮
	self.btn_collect_ad = node_col:getChildByName("btn_collect_ad")
	self.btn_collect_ad:setVisible(self.canShowAds)

	--配置Collect按钮
	self.btn_collect  = node_col:getChildByName("btn_collect")
	self.btn_collect2 = node_col:getChildByName("btn_collect2")
	local label_name  = self.btn_collect2:getChildByName("label_name")
	if label_name then
		bole.ctorUIComponent(label_name, UIComponent.LanguageLabel)
		label_name:setTTFStroke(cc.c3b(0, 111, 0), 2)
		label_name:setOriginLineHeight(28)
		label_name:setOriginOffset(-1, 6)
		label_name:setStringConfig({
			string_type = LANGUAGE_STRING_TYPE.KEY,
			string_key  = "COMMON_BUTTON.claim"
		})
	end

	self.btn_collect:setVisible(not self.canShowAds)
	self.btn_collect2:setVisible(self.canShowAds)

	local function collectFunc()
		self:collect()
	end

	local function showADFunc()
		self:showAD()
	end

	self:addTouchEvent(self.btn_collect2, collectFunc)
	self:addTouchEvent(self.btn_collect_ad, showADFunc)
	self:addTouchEvent(self.btn_collect, collectFunc)

	self:updateButtonState(true)
end

--调整node_win下节点位置
function ThemeLevelUpTip:setNodeWinPos(maxBetMultiplier, lounge_points, dailyReward, vipPoint) 
	local nodes = {}
	
	if self.maxBet > 0 then
		table.insert(nodes, maxBetMultiplier)
	end
	if self.dailyReward > 0 then
		table.insert(nodes, dailyReward)
	end
	if self.vipPoints > 0 then
		table.insert(nodes, vipPoint)
	end
	if self.loungePoints > 0 then
		table.insert(nodes, lounge_points)
	end

	local gap = 65
	local count = #nodes - 1
	local startX = -(count * gap)
	if #nodes > 0 then
		for key, node in ipairs(nodes) do
			node:setPositionX(startX)
			startX = startX + (gap * 2)
		end 
	end
end

function ThemeLevelUpTip:updateButtonState(unEnable)
	if unEnable then
		self.btn_collect2:setTouchEnabled(false)
		self.btn_collect_ad:setTouchEnabled(false)
		self.btn_collect:setTouchEnabled(false)
	else
		self.btn_collect2:setTouchEnabled(self.canShowAds)
		self.btn_collect_ad:setTouchEnabled(self.canShowAds)
		self.btn_collect:setTouchEnabled(not self.canShowAds)
	end
end

function ThemeLevelUpTip:collect()
	if not self.isCollected then
		self.isCollected = true

		local btnCollect = nil
		if self.canShowAds then
			self.btn_collect2:setTouchEnabled(false)
			self.btn_collect_ad:setTouchEnabled(false)
			btnCollect = self.btn_collect2
		else
			self.btn_collect:setTouchEnabled(false)
			btnCollect = self.btn_collect
		end

		if self.showUserGuide then
			UserGuideControl:getInstance():hideOutside()
		end

		local user = User:getInstance()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()	
				local parent = btnCollect:getParent()
				local pos = parent:convertToWorldSpace(cc.p(btnCollect:getPosition()))
				user.header:flyCoins(pos, user.coins, (self.rewardDouble and self.rewardCoins*2 or self.rewardCoins), parent)
				AudioControl:playEffect("sounds/game3.mp3",false)
			end), 
			cc.DelayTime:create(0.8), 
			cc.CallFunc:create(function()
				user:addCoins((self.rewardDouble and self.rewardCoins*2 or self.rewardCoins), 1)
			end),
			cc.DelayTime:create(2), 
			-- cc.CallFunc:create(function()
			-- 	--弹窗出场
			-- 	self:runTimeLine(260, 290, false)
			-- end),
			-- cc.DelayTime:create(0.5), 
			cc.CallFunc:create(function()
				UserGuideControl:getInstance():playLevelupEffect(self.level)
				self:hide()
				user.header.levelUpFinished_bigger = true
			end)))
	end
end

function ThemeLevelUpTip:showAD( ... )
	if not bole.isValidNode(self) then return end
	if not self.isShowAD then
		self.isShowAD = true
		self.btn_collect2:setTouchEnabled(false)
		self.btn_collect_ad:setTouchEnabled(false)

		bole.playMusic("02_chooseBet")
		bole.send_codeInfo("record", {pid = PID.ad_level_up_click}, false)
		ADSControl:getInstance():showAds(ADType.REWARDVIDEO,ADSource.LevelUp)
	end
end

function ThemeLevelUpTip:showADClose(  ) -- 广告没有播放完，玩家手动关闭广告
	self.canShowAds = false
	self.btn_collect:setVisible(true)
	self.btn_collect2:setVisible(false)
	self.btn_collect_ad:setVisible(false)
	self.btn_collect:setTouchEnabled(true)
end

function ThemeLevelUpTip:showADError(  ) -- 广告没有播放完，玩家手动关闭广告
	self.canShowAds = false
	self.btn_collect:setVisible(true)
	self.btn_collect2:setVisible(false)
	self.btn_collect_ad:setVisible(false)
	self.btn_collect:setTouchEnabled(true)
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(4),
		cc.CallFunc:create(function()
			if not self.showUserGuide then
				self:collect()
			end
		end)))
end

function ThemeLevelUpTip:showADSuccess() -- 广告播放完，显示点击按钮 
	self.rewardDouble = true
	
	local parseValue = function ( value )
		return FONTS.format(value, true) .. " COINS"
	end
	inherit(self.labelReward, LabelNumRoll)
	self.labelReward:nrInit(0, 24, parseValue)

	self.labelReward:setString(FONTS.format(self.rewardCoins*2))
	bole.shrinkLabel(self.labelReward, 415, 1)
	self.labelReward:setString("")
	self.labelReward:nrStartRoll(self.rewardCoins, self.rewardCoins*2, 1)-- 播放numberRoll

	self.btn_collect:setVisible(true)
	self.btn_collect2:setVisible(false)
	self.btn_collect_ad:setVisible(false)
	self.btn_collect2:setTouchEnabled(false)
	self.btn_collect_ad:setTouchEnabled(false)

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )
			self.labelReward:nrOverRoll()-- 停止滚动
			self.btn_collect:setTouchEnabled(true)
		end),
		cc.DelayTime:create(4),
		cc.CallFunc:create(function()
			if not self.showUserGuide then
				self:collect()
			end
		end)))
end

function ThemeLevelUpTip:playBackgroundMusic(play)
	local volume = (play and 1) or 0.3
	AudioControl:volumeGroupAudio(volume)
end

function ThemeLevelUpTip:show()
	-- local scale = bole.getAdaptScale(self.isPortrait)

	if self.isPortrait then
		self.node:setScale(SHRINKSCALE_H)
 		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
 	else
 		self.node:setScale(SHRINKSCALE_H)
 		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
 	end
	
	-- self:playBackgroundMusic(false) -- 关掉背景音乐
	self:showActions()
	bole.scene:addChild(self)

	local show_btn_delay = self.canShowAds and 0.8 or 0
	local delay_for_btn = (self.showUserGuide and 1 or 0) + show_btn_delay
	if ADSControl:getInstance():getUserType() == ADUserType.LL then
		bole.send_codeInfo("record", {pid = PID.ad_Level_UP_Tips_show}, false)
	end

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()	
			bole.playMusic("levelup", nil, nil, "sounds/LevelUp_Sounds/")
			--弹窗入场
			self:runTimeLine(0, 140, false)
		end),
		cc.DelayTime:create(0.3),
		cc.DelayTime:create(show_btn_delay), -- 显示 collect 按钮的 时间
		cc.DelayTime:create(0.6),
		cc.CallFunc:create(function ( ... )
			if self.showUserGuide then
				UserGuideControl:getInstance():showUserGuideDirectly("levelup", self.root)
			end
		end),
		cc.DelayTime:create(delay_for_btn),
		cc.CallFunc:create(function ( ... )
			self:updateButtonState()
		end),
		cc.DelayTime:create(8),
		cc.CallFunc:create(function()
			if not self.showUserGuide and not self.isShowAD then
				self:collect()
			end
		end)))
end

function ThemeLevelUpTip:hide()
	--commonHide(self)
	self:hideActions()
	if self.themeCtl then
		self.themeCtl.theme:dealMusic_FadeOutLoopMusic()
	else
		self:playBackgroundMusic(true) 
	end

	EventCenter:pushEvent("THEMECONTROL.THEMECONTROL_LEVELUP_ENDED")
	-- 开启背景音乐
	-- self:removeFromParent()
	if User:getInstance().header.tip_lvup then
		User:getInstance().header.tip_lvup = nil
	end

	RecordControl:getInstance().isLevelUp = false
	bole.playMusic("LevelUp_Menu_Up_Animation", nil, nil, "sounds/LevelUp_Sounds/")

	bole.closeDialog(self, function()
		self:playLeaveSpine()
		return 1
	end)

end

function ThemeLevelUpTip:playLeaveSpine() 
	local _ , s = libUI.addSpineAnimation(self.node, nil, getLevelUpSpinePath("close"), cc.p(0 , 0), "animation", nil, nil, nil, true, false, 1)
	local _slot = libSpine.getNodeForSlot(s, "reward1")
	if _slot then
		local view = ccui.Layout:create()
		view:setContentSize(cc.size(FRAME_WIDTH, FRAME_HEIGHT))
		view:setAnchorPoint(cc.p(0.5, 0.5))
		view:setClippingEnabled(true)
		_slot:addChild(view)

		self.root:retain()
		self.root:removeFromParent()
		self.root:setPosition(cc.p(FRAME_WIDTH/2, FRAME_HEIGHT/2 - 20))
		view:addChild(self.root)
		self.root:release()

		local rootNode = self.node:getChildByName("node")
		local mask = rootNode:getChildByName("mask")
		if mask then
			mask:setVisible(false)
		end

		local expNode = User:getInstance().header.expNode
		if bole.isValidNode(expNode) then
			local wpos = expNode:getParent():convertToWorldSpace(cc.p(expNode:getPosition()))
			local npos = s:getParent():convertToNodeSpace(wpos)
			local bezier = {
				cc.p(npos.x * 0 , - npos.y * 0.0),
				cc.p(npos.x, 0),
				npos,
			}
			s:runAction(cc.Sequence:create(
				cc.EaseIn:create(cc.MoveTo:create(8 / 60 , bezier[1]), 4),
				-- cc.EaseOut:create(cc.BezierTo:create(20 / 60 , bezier) , 3)
				cc.JumpTo:create(14 / 60, npos, 0, 1)
			))
			local hotDayNodeSize = expNode:getContentSize()
			libUI.addSpineAnimation(expNode, 100, getLevelUpSpinePath("close_collect"), cc.p(hotDayNodeSize.width / 2  , hotDayNodeSize.height / 2 - 5), "animation", nil, nil, nil, false, false, 1)
		end
	end
end

------------------------Level Up small Dialog------------------------
-- 升级面板简化模式
HeaderLevelUpSmall = class("HeaderLevelUpSmall",CCSNode)
function HeaderLevelUpSmall:ctor(data)
	-- self.config_topic = 
	-- {
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font02.fnt", 
	-- 		["topic"] = "LEVEL UP REWARD:",
	-- 		["data"]  = data.coin_reward or 0,
	-- 		["type"]  = 1
	-- 	},
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font.fnt",
	-- 		["topic"] = "VIP POINTS:",
	-- 		["data"]  = data.status_point or 0,
	-- 		["type"]  = 2
	-- 	},
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font.fnt",
	-- 		["topic"] = "MAX BET:",
	-- 		["data"]  = data.real_max_bet or 0,
	-- 		["type"]  = 3
	-- 	},
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font.fnt",
	-- 		["topic"] = "DAILY REWARD:",
	-- 		["data"]  = data.daily_reward or 0,
	-- 		["type"]  = 4
	-- 	},
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font.fnt",
	-- 		["topic"] = "TURBO REWARD:",
	-- 		["data"]  = data.turbo_reward or 0,
	-- 		["type"]  = 5
	-- 	},
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font.fnt",
	-- 		["topic"] = "INSTANT REWARD:",
	-- 		["data"]  = data.instant_reward or 0,
	-- 		["type"]  = 6
	-- 	},
	-- 	{
	-- 		["font"]  = "themetips/level_up_small/levelup_min_font02.fnt",
	-- 		["topic"] = "LOUNGE POINTS:",
	-- 		["data"]  = data.lounge_points or 0,
	-- 		["type"]  = 7
	-- 	}

	-- }
    self.level         = data.level
	self.rewardCoins   = data.coin_reward
	self.vipPoints     = data.status_point
	self.lounge_points = data.lounge_points
	self.boosterMul    = data.booster_mul
	-- self.maxBet        = data.real_max_bet
	-- self.turboReward   = data.turbo_reward
	-- self.dailyReward   = data.daily_reward
	-- self.instantReward = data.instant_reward
	self.isPortrait    = data.isPortrait
	self.isVipBooster  = ActivityCenterControl:getInstance():canShowPart("levelup", "vip")
	self.isDoubleBlast = ActivityCenterControl:getInstance():canShowPart("levelup", "double_blast")
	self.isBooster     = (StoreControl:getInstance():getLevelBurstLeftTime() > 0)
	self.csb 		   = "themetips/level_up_small/" .. (self.boosterMul > 1 and "level_up_small_booster" or "level_up_small") .. ".csb"

	CCSNode.ctor(self, self.csb)
	self.nodeEventListener:setSwallowTouches(false)
end

function HeaderLevelUpSmall:loadControls()

	self.root = self.node:getChildByName("root")
	self.topic_node = self.root:getChildByName("topic_node")
	self.level_up_small_bg = self.root:getChildByName("level_up_small_bg")
	self.level_number = self.topic_node:getChildByName("level_number")
	if self.level_number then
		if not bole.hasUIComponent(self.level_number, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(self.level_number, UIComponent.LanguageLabel)
			self.level_number:setOriginLineHeight(24)
			self.level_number:setOriginOffset(0, 6)
		end
		if self.boosterMul > 1 then
			self.level_number:setTTFStroke(cc.c3b(141, 49, 0), 3)
		else
			self.level_number:setTTFStroke(cc.c3b(0, 17, 141), 3)
		end
	end

	-- local topic = self.root:getChildByName("topic")
	-- local topic_data = self.root:getChildByName("topic_data")
	-- self.topic_node = topic:getChildren()
	-- self.topic_data_node = topic_data:getChildren()
	-- self.level_reward = self.root:getChildByName("level_reward")
	-- self.status_points = self.root:getChildByName("status_points")
	-- self.max_bet = self.root:getChildByName("max_bet")
	-- self.daily_reward = self.root:getChildByName("daily_reward")
	-- self.turbo_reward = self.root:getChildByName("turbo_reward")
	-- self.instant_reward = self.root:getChildByName("instant_reward")

	self.boosterNode = self.root:getChildByName("mul_node")

	-- if self.boosterMul > 1 then
	--     local mul_list   = {2, 4, 5, 7, 30, 35}
	--     for i=1, 6 do
	--     	local mul_label = self.boosterNode:getChildByName("booster_node"):getChildByName("label" .. i)
	-- 		mul_label:setVisible(self.boosterMul == mul_list[i])
	--     end
	-- else
	self.boosterNode:setVisible(false)
	-- end


	self.isCollected = false
	self:setNumber()
	self.user = User:getInstance()
end

function HeaderLevelUpSmall:setNumber()

	if libUI.isValidNode(self.level_number) and self.level then
		self.level_number:setStringConfig({
			string_type  = LANGUAGE_STRING_TYPE.VALUE,
			string_key   = "LOBBY.level",
			string_value = {self.level} 
		})
		-- self.level_number:setString("LEVEL " .. self.level)
	end

	-- local topic_item_list = {1, 2, 3, 4, 5, 6}
	-- if self.level % 5 == 0 then
	-- 	topic_item_list = {1, 7, 2, 3, 4, 5}
	-- end
	self.data_1   = self.topic_node:getChildByName("data_1")
	self.data_2_1 = self.topic_node:getChildByName("data_2_1")
	self.data_2_2 = self.topic_node:getChildByName("data_2_2")
	self.data_3   = self.topic_node:getChildByName("data_3")

	self.label_coins  = self.data_1:getChildByName("label_coins")
	self.label_lounge = self.data_2_1:getChildByName("label_lounge")
	self.label_vip2   = self.data_2_2:getChildByName("label_vip2")
	self.label_vip3   = self.data_3:getChildByName("label_vip3")
	self.icon02   = self.data_2_2:getChildByName("levelup_popup_icon03")
	self.icon03   = self.data_3:getChildByName("levelup_popup_icon03")
	
	if self.label_coins then 
		self.label_coins:setString(FONTS.format(self.rewardCoins, false))
	end
	if self.label_lounge then 
		self.label_lounge:setString(self.lounge_points or 0)   
	end
	if self.label_vip2 then 
		self.label_vip2:setString(self.vipPoints or 0)   
	end
	if self.label_vip3 then 
		self.label_vip3:setString(self.vipPoints or 0)   
	end
	local path = "themetips/level_up_small/levelup_popup_icon04.png"
	if self.icon02 then 
		self.icon02:setTexture(path)
	end
	if self.icon03 then 
		self.icon03:setTexture(path)
	end

	if self.data_2_1 and self.data_2_2 and self.data_3 then
		local flag = self.level >= 20 and self.level % 5 == 0
		self.data_2_1:setVisible(flag)
		self.data_2_2:setVisible(not flag)
		self.data_3:setVisible(flag)
		local x1,y1 = self.level_up_small_bg:getPosition()
		local x2,y2 = self.topic_node:getPosition()
		if self.isPortrait then
			y1 = y1 + 20
			y2 = y2 + 20
		end
		y1 = y1 + 30
		y2 = y2 + 30
		if not ActivityCenterControl:getInstance():getDengGuanIndex() then
			y1 = y1 + 20
			y2 = y2 + 20
		end
		self.level_up_small_bg:setPosition(cc.p(x1, flag and y1 or y1 + 40))
		self.topic_node:setPosition(cc.p(x2, y2))
	end

	-- for i = 1, #self.topic_node do
	-- 	local item_number = topic_item_list[i]
	-- 	local item_config = self.config_topic[item_number]
	-- 	self.topic_node[i]:setFntFile(item_config.font)
	-- 	self.topic_data_node[i]:setFntFile(item_config.font)
	-- 	self.topic_node[i]:setString(item_config.topic)
	-- 	if item_config.type == 1 then
	-- 		self.level_reward = self.topic_data_node[i]
	-- 	end
	-- 	self.topic_data_node[i]:setString(FONTS.format(item_config.data, false))
	-- end

	-- if libUI.isValidNode(self.level_reward) and self.rewardCoins then
	-- 	self.level_reward:setString(FONTS.format(self.rewardCoins, false))
	-- end

	-- if libUI.isValidNode(self.status_points) and self.vipPoints then
	-- 	self.status_points:setString(self.vipPoints)
	-- end

	-- if libUI.isValidNode(self.max_bet) and self.maxBet then
	-- 	self.max_bet:setString(FONTS.format(self.maxBet, false))
	-- end

	-- if libUI.isValidNode(self.daily_reward) and self.dailyReward then
	-- 	self.daily_reward:setString(FONTS.format(self.dailyReward, false))
	-- end

	-- if libUI.isValidNode(self.turbo_reward) and self.turboReward then
	-- 	self.turbo_reward:setString(FONTS.format(self.turboReward, false))
	-- end

	-- if libUI.isValidNode(self.instant_reward) and self.instantReward then
	-- 	self.instant_reward:setString(FONTS.format(self.instantReward, false))
	-- end

end

function HeaderLevelUpSmall:show()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()	
			-- 弹窗入场
			local endPos = cc.p(self.root:getPositionX(), 0)
			self.root:runAction(cc.MoveTo:create(0.5,endPos))
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self:collect()
		end)))
end

function HeaderLevelUpSmall:collect()
	if not self.isCollected then
		self.isCollected = true
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()	
				local parent = self.label_coins:getParent()
				local pos = parent:convertToWorldSpace(cc.p(self.label_coins:getPosition()))
				self.user.header:flyCoins(pos, self.user.coins, self.rewardCoins)
			end), 
			cc.DelayTime:create(0.8), 
			cc.CallFunc:create(function()
				self.user:addCoins(self.rewardCoins, 1)
			end),
			cc.DelayTime:create(1.7), 
			cc.CallFunc:create(function()
				self.root:runAction(cc.FadeOut:create(0.5))
			end),
			cc.DelayTime:create(0.5), 
			cc.CallFunc:create(function()
				UserGuideControl:getInstance():playLevelupEffect(self.level)
				self:hide()
			end)))
	end
end

function HeaderLevelUpSmall:hide()
	EventCenter:pushEvent("THEMECONTROL.THEMECONTROL_LEVELUP_ENDED")
	self:removeFromParent()
	if self.user.header.tip_lvup then
		self.user.header.tip_lvup = nil
	end
	self.user.header.levelUpFinished = true
	RecordControl:getInstance().isLevelUp = false
	-- if self.user.header.levelUpQueue:getSize() <= 0 then
	-- 	self.user.header.level_ing = false
	-- end
end

------------------------Level tips Dialog------------------------
-- 升级到下一级的信息
HeaderLevelTips = class("HeaderLevelTips",CCSNode)
function HeaderLevelTips:ctor (exp, rewardCoins, maxBet, isBooster, header_style)
	self.needExp     = exp
 	self.rewardCoins = rewardCoins
	self.maxBet      = maxBet
    self.isPortrait  = ScreenControl:getInstance().isPortrait
	self.isDoubleBlast = ActivityCenterControl:getInstance():canPlay("double_blast")
	self.isBooster   = (StoreControl:getInstance():getLevelBurstLeftTime() > 0)
	self.isLounge    = LobbyControl:getInstance():isLoungeAvailable()
	self.isDoubleXP  = (StoreControl:getInstance():getDoubleXpLeftTime() > 0)
	self.multiplier  = self:getLevelBonusMultiplier()
    self.headerStyle = header_style
    local csb_name   = (self.multiplier > 1 and "leveltipsbooster" or "leveltipsnormal")
    if self.headerStyle == 3 or self.headerStyle == 5 then
    	csb_name = csb_name .. "_theme" or csb_name
    elseif self.headerStyle == 2 or self.headerStyle == 7 or self.headerStyle == 8 then
    	csb_name = csb_name .. "_diamond" or csb_name
    end
	self.csbName     = csb_name
    self.csb         = "themetips/leveltips/" .. csb_name .. ".csb"
	CCSNode.ctor(self,self.csb)
	self.nodeEventListener:setSwallowTouches(false)
end

function HeaderLevelTips:loadControls ()
	self.root = self.node:getChildByName("root")
	local is_special = (self.isDoubleBlast or self.isBooster or User:getInstance():displayBooster(1) or self.isDoubleXP or self.isLounge)
 	local scale = self.isPortrait and 0.7 or 1
	self.root:setScale(scale)
	local pos_y = is_special and -50 or -20
 	self.root:setPosition(cc.p(0, pos_y))

    if self.isBooster then
        Splunk:getInstance():send_codeInfo("levelburst_clicklevel")
    end

	self.infoBack = self.root:getChildByName("background")

	self.eventMask = cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
	local sz = bole.getSceneSize()
	self.eventMask:setPosition(-sz.width, -sz.height)
	self.eventMask:setScale(2)
	self.eventMask:setOpacity(0)
	self.infoBack:addChild(self.eventMask)

    local content_node = self.infoBack:getChildByName("content_node")
	self.expLabel      = content_node:getChildByName("label_exp")
	self.coinsLabel    = content_node:getChildByName("label_pre_coins")
    self.coinsLine     = self.coinsLabel:getChildByName("line")
    self.boosterLabel  = content_node:getChildByName("label_coins")

    local label_title = content_node:getChildByName("label_title")
    if label_title then
		if not bole.hasUIComponent(label_title, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(label_title, UIComponent.LanguageLabel)
			self:setBoosterConfigToCsbName(label_title)
		end
		local key = "LEVEL_UP."
    	if self.isBooster then
			key = key .. "booster_gives"
    	else
			key = key .. "today_only"
    	end
		label_title:setStringConfig({
			string_type = LANGUAGE_STRING_TYPE.KEY,
			string_key = key
		})
    end

	local label_line1 = content_node:getChildByName("label_line1")
	if label_line1 then
		if not bole.hasUIComponent(label_line1, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(label_line1, UIComponent.LanguageLabel)
			self:setCommonConfigToCsbName(label_line1)
		end
		local key = "LEVEL_UP."
    	if self.multiplier > 1 then
			key = key .. "next_reward"
    	else
			key = key .. "more_xp"
    	end
		label_line1:setStringConfig({
			string_type = LANGUAGE_STRING_TYPE.KEY,
			string_key = key
		})
	end
 
	local label_line3 = content_node:getChildByName("label_line3")
	if label_line3 then
		if not bole.hasUIComponent(label_line3, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(label_line3, UIComponent.LanguageLabel)
			self:setCommonConfigToCsbName(label_line3)
		end
		local key = "LEVEL_UP.next_reward"
		label_line3:setStringConfig({
			string_type = LANGUAGE_STRING_TYPE.KEY,
			string_key = key
		})
	end

	local label_line4 = content_node:getChildByName("label_line4")
	if label_line4 then
		if not bole.hasUIComponent(label_line4, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(label_line4, UIComponent.LanguageLabel)
			self:setCommonConfigToCsbName(label_line4)
		end
		local key = "LEVEL_UP.more_xp"
		label_line4:setStringConfig({
			string_type = LANGUAGE_STRING_TYPE.KEY,
			string_key = key
		})
	end
	

    local double_xp_node = content_node:getChildByName("double_xp_node")
    if double_xp_node then
    	local label_today_only = double_xp_node:getChildByName("label_today_only")
    	local label1           = double_xp_node:getChildByName("label1")
    	if label_today_only and label1 then

			local key, todayKey, labelKey = "LEVEL_UP.", "", ""
			if self.isDoubleXP then
				todayKey = key .. "level_up_exp"
				labelKey = key .. "x2_xp"
			else
				todayKey = key .. "lounge_special"
				labelKey = key .. "level_up_faster"
			end

			if not bole.hasUIComponent(label_today_only, UIComponent.LanguageLabel) then
				bole.ctorUIComponent(label_today_only, UIComponent.LanguageLabel)
				if self.multiplier > 1 then 
					self:setBoosterConfigToCsbName(label_today_only)
				else
					self:setCommonConfigToCsbName(label_today_only)
				end
			end
			label_today_only:setStringConfig({
				string_type = LANGUAGE_STRING_TYPE.KEY,
				string_key = todayKey
			})

			if not bole.hasUIComponent(label1, UIComponent.LanguageLabel) then
				bole.ctorUIComponent(label1, UIComponent.LanguageLabel)
				self:setCommonConfigToCsbName(label1)
			end
			label1:setStringConfig({
				string_type = LANGUAGE_STRING_TYPE.KEY,
				string_key = labelKey
			})

    		bole.shrinkLabel(label1, 320, 1)
    	end
    end

	if self.expLabel then
		self.expLabel:setString(self.needExp)
	end

	local precoins = FONTS.format(self.rewardCoins, true)
	if self.coinsLabel then
		if not bole.hasUIComponent(self.coinsLabel, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(self.coinsLabel, UIComponent.LanguageLabel)
			self:setCommonConfigToCsbName(self.coinsLabel)
		end
		self.coinsLabel:setStringConfig({
			string_type  = LANGUAGE_STRING_TYPE.VALUE,
			string_key   = "COMMON.x_coins",
			string_value = {precoins} 
		})
	end

    if self.coinsLine then
        self.coinsLine:setVisible(self.multiplier > 1)
        local line_len = 105 + 10 * string.len(precoins)
        self.coinsLine:setContentSize(cc.size(line_len, 2))
		self.coinsLine:setPosition(cc.p(-5.00 - line_len / 2, 0))
		self.coinsLine:setLocalZOrder(5)
    end
    if self.boosterLabel and (self.multiplier > 1) then
		if not bole.hasUIComponent(self.boosterLabel, UIComponent.LanguageLabel) then
			bole.ctorUIComponent(self.boosterLabel, UIComponent.LanguageLabel)
			self:setBoosterConfigToCsbName(self.boosterLabel)
		end
		self.boosterLabel:setStringConfig({
			string_type  = LANGUAGE_STRING_TYPE.VALUE,
			string_key   = "COMMON.x_coins",
			string_value = {FONTS.format(self.rewardCoins * self.multiplier, true)} 
		})
    end

    local frame = ((self.isDoubleXP or self.isLounge) and 20 or 0)
	self:runTimeLine(frame)
	
	local isBoosterNode = self.multiplier > 1
	local bg = self.infoBack:getChildByName("background")
	if bg then
		local bgWidth = bg:getContentSize().width
		local bgHeight = 0
		if isBoosterNode then
			bgHeight = 290
		else
			bgHeight = 210
		end
		bg:setContentSize(cc.size(bgWidth, bgHeight))
	end

end

function HeaderLevelTips:setCommonConfigToCsbName(label)
	
    if self.headerStyle == 3 or self.headerStyle == 5 then
		label:setOriginLineHeight(20)
		label:setOriginFntColor(cc.c3b(255, 243, 255))
		label:setTTFStroke(cc.c3b(68, 1, 163), 2)
	elseif self.headerStyle == 2 or self.headerStyle == 7 or self.headerStyle == 8 then
		label:setOriginLineHeight(20)
		label:setOriginFntColor(cc.c3b(247, 232, 186))
		label:setTTFStroke(cc.c3b(169, 30, 2), 2)
    else
		label:setOriginLineHeight(20)
		label:setOriginFntColor(cc.c3b(232, 254, 255))
		label:setTTFStroke(cc.c3b(3, 13, 136), 2)
	end
	label:setOriginOffset(0, 2)

end

function HeaderLevelTips:setBoosterConfigToCsbName(label)
	
    if self.headerStyle == 3 or self.headerStyle == 5 then
		label:setOriginLineHeight(20)
		label:setOriginFntColor(cc.c3b(253, 234, 175))
		label:setTTFStroke(cc.c3b(128, 21, 29), 2)
	elseif self.headerStyle == 2 or self.headerStyle == 7 or self.headerStyle == 8 then
		label:setOriginLineHeight(20)
		label:setOriginFntColor(cc.c3b(29, 246, 130))
		label:setTTFStroke(cc.c3b(28, 70, 45), 2)
    else
		label:setOriginLineHeight(20)
		label:setOriginFntColor(cc.c3b(255, 250, 162))
		label:setTTFStroke(cc.c3b(134, 63, 0), 2)
	end
	label:setOriginOffset(0, 2)

end

function HeaderLevelTips:getLevelBonusMultiplier( ... )
	local level = User:getInstance().level
    local double_blast_mul = 0
    local level_burst_mul = 0

	if self.isDoubleBlast then
    	if level % 5 == 4 then
    		double_blast_mul = 5
    	elseif level % 2 == 1 then
    		double_blast_mul = 2
    	end
    end

    if self.isBooster then
    	level_burst_mul = (level%10==9 and 25 or 2.5)
    end

    local multiplier = double_blast_mul + level_burst_mul
    if multiplier == 0 then multiplier = 1 end

    return multiplier
end

function HeaderLevelTips:initEvent (endCallback)
	local function onTouchBegan (touch, event)
        return true
    end

    local function onTouchEnded (touch, event)
    	bole.playMusic("game2")
    	endCallback()
    end

    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener1:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener1, self.eventMask)
end

-- function HeaderLevelTips:onTouchParty( btn )
-- 	LevelUpPartyController:getInstance():showActivityPop()
-- end

------------------------Theme Unlock Dialog------------------------

--解锁主题
ThemeUnlockTip = class("ThemeUnlockTip", CCSNode)

function ThemeUnlockTip:ctor( header, theme_list_tip, isPortrait )
	self.theme_list = theme_list_tip or {}
	self.isPortrait = isPortrait
	self.header     = header
	self.csbName    = #self.theme_list == 4 and "theme_unlock_big" or "theme_unlock"
	CCSNode.ctor(self, "themetips/themeunlock/" ..self.csbName .. ".csb")
	self.nodeEventListener:setSwallowTouches(false)
	EventCenter:registerEvent(EVENTNAMES.THEME.ALLOW_QUIT_THEME, "theme_unlock_tip", self.onAllowQuitTheme, self)

end

function ThemeUnlockTip:onAllowQuitTheme(data)
	data = data or {}
	if data.from ~= "unlock_theme" then return end

	if #self.theme_list == 1 then
		LobbyThemeControl:getInstance():setEnterThemeData(self.theme_list[1])
	end
	if #self.theme_list == 4 then
		local pos_x = ActivityCenterControl:getInstance():calculateSlideDistance(tonumber(self.theme_list[1])) or nil
		LobbyThemeControl:getInstance():saveUnlockThemePos(pos_x)
	end
	self.header:toLobbyScene()
	self:hide()
end
function ThemeUnlockTip:loadControls()

	-- theme_list[1] = 600表示解锁Highlimit Root
	self.showTheme     = (self.theme_list[1] ~= 600)
	self.isQuest       = ActivityThemeController:getInstance():getQuestInTask()
	self.iconThemeList = {}

	self.root           = self.node:getChildByName("root")
	self.theme_node     = self.root:getChildByName("theme_node")
	if self.theme_node then
		for i = 1, #self.theme_list do
			self.iconThemeList[i] = self.theme_node:getChildByName("icon_theme_"..i)
		end
		self.labelTheme     = self.theme_node:getChildByName("label_theme")
		if self.labelTheme then
			self.labelTheme:setVisible(not self.isQuest)
		end
		self.labelQuest    = self.theme_node:getChildByName("label_quest")
		if self.labelQuest then
			self.labelQuest:setVisible(self.isQuest)
		end

		local isMovePos = (#self.theme_list == 4 and self.isQuest)
		if self.showTheme then
			for i = 1, #self.theme_list do
				local logo_pic = string.format("theme_loading/theme%d/logo/smalllogo.png", THEME_LIST[tonumber(self.theme_list[i])]['resourceId'])
				if cc.FileUtils:getInstance():isFileExist(logo_pic) then
					if libUI.isValidNode(self.iconThemeList[i]) then
						self.iconThemeList[i]:setTexture(logo_pic)
						if isMovePos then
							self.iconThemeList[i]:setPosition(cc.p(-250.5 + (106 * i), 24.5))
						end
					end					
				end
			end
		end
		
		self.theme_node:setVisible(self.showTheme)
	end

	self.highlimit_node = self.root:getChildByName("highlimit_node")
	if self.highlimit_node then
		self.highlimit_node:setVisible(not self.showTheme)
	end

	self.btnPlay        = self.root:getChildByName("btn_play")
	if self.btnPlay then
		if self.isQuest then
			self.btnPlay:setVisible(false)
		else
			local function play( ... )

				if self.theme_list and #self.theme_list == 4 then
					local level = User:getInstance().level or 1
					local theme_id = self.header.theme_id or 101
					bole.send_codeInfo(Splunk_Type.RECORD, {pid = PID.theme_unlock_tip, bid = BID.play, lv = level, tid = theme_id}, false)
				end
	
				self.btnPlay:setTouchEnabled(false)
				if bole.isSocialThemeID(self.header.theme_id) then
					-- 需要主题允许才能退出
					EventCenter:pushEvent(EVENTNAMES.THEME.ASK_QUIT_THEME, {
						from = "unlock_theme",
					})
				else
					self:onAllowQuitTheme({
						from = "unlock_theme",
					})
				end
			end
			self:addTouchEvent(self.btnPlay, play)
		end
	end
end

function ThemeUnlockTip:show(parent, zOrder, duration)
	-- parent = parent or bole.scene
	
	bole.scene:addChild(self)
	self.root:setOpacity(0)
	if self.isPortrait then
		self.node:setPosition(FRAME_HEIGHT, FRAME_WIDTH-120)
		self.node:setScale(0.8)
	else
		self.node:setPosition(FRAME_WIDTH, FRAME_HEIGHT-80)
	end

	if self.theme_list and #self.theme_list == 4 then
		bole.send_codeInfo(Splunk_Type.RECORD, {pid = PID.theme_unlock_tip}, false)
	end
	
	-- if self.isPortrait then
	-- 	self.root:setPosition(cc.p(510,-100))
	-- 	self.root:setScale(0.8)
	-- else
	-- 	self.root:setPosition(cc.p(1013, -100))
	-- end

	duration = duration or 6
	self.root:runAction(cc.Sequence:create(
		cc.FadeTo:create(0.5, 255), 
		cc.DelayTime:create(duration - 1),
		cc.CallFunc:create(function ( ... )
			self:hide()
		end)))
end

function ThemeUnlockTip:hide()
	EventCenter:removeEvent(EVENTNAMES.THEME.ALLOW_QUIT_THEME, "theme_unlock_tip")
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self.root:runAction(cc.FadeTo:create(0.5, 0))
		end),
		cc.DelayTime:create(0.5),
		cc.RemoveSelf:create()))
end


------------------------Theme Mega77 Dialog------------------------

ThemeMegaSSWin = class("ThemeMegaSSWin", CCSNode)

function ThemeMegaSSWin:ctor( )
	self.isPortrait = ScreenControl:getInstance().isPortrait
	local csbFile = self.isPortrait and "themetips/mega77/mega77_v.csb" or "themetips/mega77/mega77.csb"
	CCSNode.ctor(self, csbFile)
end

function ThemeMegaSSWin:loadControls()
	self.root       = self.node:getChildByName("root")
	self.btnCollect = self.root:getChildByName("btn_collect")
	self.btnClose   = self.root:getChildByName("btn_close")
	local spine_1   = self.root:getChildByName("spine_1")

	self.bgSpine = nil
	if spine_1 then
		if self.isPortrait then 
			local _, s = libUI.addSpineAnimation(spine_1, nil, "themetips/mega77/spines/bg_v/spine", cc.p(0, 0), "animation1", nil, nil, nil, true, true, nil)
			self.bgSpine = s
		else
			local _, s = libUI.addSpineAnimation(spine_1, nil, "themetips/mega77/spines/bg/spine", cc.p(0, 0), "animation1", nil, nil, nil, true, true, nil)
			self.bgSpine = s
		end
	end

	if bole.isValidNode(self.btnCollect) then
		local btnSize = self.btnCollect:getContentSize()
		libUI.addSpineAnimation(self.btnCollect, nil, "themetips/mega77/spines/btn/spine", cc.p(btnSize.width/2, btnSize.height/2), "animation", nil, nil, nil, true, true, nil)
	end

	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end

	if self.btnCollect then
		local function collect( ... )
			local header = User:getInstance().header
			if header.themeCtl then
				LobbyThemeControl:getInstance():setEnterThemeData(10001)

				header:toLobbyScene()
			end

			self:hide()
		end

		self:addTouchEvent(self.btnCollect, collect)
	end
end

function ThemeMegaSSWin:show()

	-- if self.isPortrait then
 -- 		scale = 0.7
 -- 		self.node:setPosition(-275, 285)
 -- 	else
 -- 		scale = 1
 -- 		self.node:setPosition(0, 0)
 -- 	end

	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H) --  * 0.8
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
	end
	local scale = 1

	if bole.isValidNode(self.bgSpine) then 
		self.bgSpine:setAnimation(0, "animation1", false)
		self.bgSpine:addAnimation(0, "animation2", true)
	end

 	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.playMusic("game7")
			-- bole.popWin_4(self.root, nil, 0.36, scale)
			self:showMask(self.isPortrait, 0.2)
		end)
		))
	if bole.isValidNode(self.btnClose) then 
		self.btnClose:setScale(0)
		self.btnClose:runAction(cc.Sequence:create(
			cc.DelayTime:create(15/30),
			cc.ScaleTo:create(0.3, 1.2),
			cc.ScaleTo:create(0.2, 1)
			))
	end
	if bole.isValidNode(self.btnCollect) then 
		self.btnCollect:setScale(0)
		self.btnCollect:runAction(cc.Sequence:create(
			cc.DelayTime:create(20/30),
			cc.ScaleTo:create(0.3, 1.2),
			cc.ScaleTo:create(0.2, 1)
			))
	end
end

function ThemeMegaSSWin:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end

	if bole.isValidNode(self.bgSpine) then 
		self.bgSpine:setAnimation(0, "animation3", false)
	end

	self:hideActions(true)
	-- bole.closeDialog(self, bole.popExitWin)

	if bole.isValidNode(self.bgSpine) then 
		self.bgSpine:setAnimation(0, "animation3", false)
	end

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(25/30),
		cc.CallFunc:create(function ( ... )
			self:hideMask(10/30)
		end),
		cc.RemoveSelf:create()
		))

	if bole.isValidNode(self.btnClose) then 
		self.btnClose:setScale(1)
		self.btnClose:runAction(cc.Sequence:create(
			cc.DelayTime:create(15/30),
			cc.ScaleTo:create(5/30, 1.2),
			cc.ScaleTo:create(10/30, 0)
			))
	end
	if bole.isValidNode(self.btnCollect) then 
		self.btnCollect:setScale(1)
		self.btnCollect:runAction(cc.Sequence:create(
			cc.DelayTime:create(15/30),
			cc.ScaleTo:create(5/30, 1.2),
			cc.ScaleTo:create(10/30, 0)
			))
	end

end

------------------Theme Double Mega77 Dialog---------------------

-- ThemeDoubleMegaSSWin = class("ThemeDoubleMegaSSWin", CCSNode)

-- function ThemeDoubleMegaSSWin:ctor( )
-- 	self.isPortrait = ScreenControl:getInstance().isPortrait
-- 	CCSNode.ctor(self, "themetips/double_mega77/double_mega77.csb")
-- end

-- function ThemeDoubleMegaSSWin:loadControls()
-- 	self.root           = self.node:getChildByName("root")
-- 	self.btnCollect     = self.root:getChildByName("btn_collect")
-- 	self.btnClose       = self.root:getChildByName("btn_close")


-- 	if self.btnClose then
-- 		local function close( ... )
-- 			self:hide()
-- 		end
-- 		self:addTouchEvent(self.btnClose, close)
-- 		bole.addKeyboardEvent(self, close, true)
-- 	end

-- 	if self.btnCollect then
-- 		local function collect( ... )
-- 			local header = User:getInstance().header
-- 			if header.themeCtl then
-- 				LobbyThemeControl:getInstance():setEnterThemeData(10001)

-- 				header:toLobbyScene()
-- 			end

-- 			self:hide()
-- 		end

-- 		self:addTouchEvent(self.btnCollect, collect)
-- 	end
-- end

-- function ThemeDoubleMegaSSWin:show()

-- 	-- if self.isPortrait then
--  -- 		scale = 0.7
--  -- 		self.node:setPosition(-275, 285)
--  -- 	else
--  -- 		scale = 1
--  -- 		self.node:setPosition(0, 0)
--  -- 	end

-- 	if self.isPortrait then
-- 		self:runTimeLine(40, 60, false)
-- 		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
-- 		self.node:setScale(SHRINKSCALE_H)
-- 	else
-- 		self:runTimeLine(0, 20, false)
-- 		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
-- 		self.node:setScale(SHRINKSCALE_H)
-- 	end
-- 	local scale = 1

--  	self:showActions()

-- 	bole.scene:addChild(self)
-- 	self:setVisible(false)

-- 	self:runAction(cc.Sequence:create(
-- 		cc.CallFunc:create(function ( ... )
-- 			self:setVisible(true)
-- 			bole.popWin_4(self.root, nil, 0.36, scale)
-- 				self:showMask(self.isPortrait, 0.2)
-- 		end)))
-- end

-- function ThemeDoubleMegaSSWin:hide()
-- 	if self.isHiding then return end

-- 	if self.callback then self.callback() end
-- 	self:hideActions(true)
-- 	bole.closeDialog(self, bole.popExitWin)
-- end

------------------Theme challenge 115 Dialog---------------------

ThemeChallengeOneWin = class("ThemeChallengeOneWin", CCSNode)

function ThemeChallengeOneWin:ctor( )
	self.isPortrait = ScreenControl:getInstance().isPortrait
	CCSNode.ctor(self, "activities/challenge_theme115/challenge_115.csb")
end

function ThemeChallengeOneWin:loadControls()
	self.root           = self.node:getChildByName("root")
	self.btnCollect     = self.root:getChildByName("btn_play")

	if self.btnCollect then
		local function collect( ... )

			local header = User:getInstance().header
			if header.themeCtl then
				LobbyThemeControl:getInstance():setEnterThemeData(10001)

				header:toLobbyScene()
			end

			self:hide()
		end

		self:addTouchEvent(self.btnCollect, collect)
	end
end

function ThemeChallengeOneWin:show()

	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
	end
	local scale = 1

 	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))
end

function ThemeChallengeOneWin:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end

------------------------Theme Super7 Dialog------------------------

ThemeSuperSWin = class("ThemeSuperSWin", CCSNode)

function ThemeSuperSWin:ctor( )
	self.isPortrait = ScreenControl:getInstance().isPortrait
	CCSNode.ctor(self, "activities/super7/theme_super7.csb")
end

function ThemeSuperSWin:loadControls()
	self.root           = self.node:getChildByName("root")
	self.btnCollect     = self.root:getChildByName("btn_collect")
	self.btnClose       = self.root:getChildByName("btn_close")


	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end

	if self.btnCollect then
		local function collect( ... )
			local header = User:getInstance().header
			if header.themeCtl then
				LobbyThemeControl:getInstance():setEnterThemeData(10001)

				header:toLobbyScene()
			end

			self:hide()
		end

		self:addTouchEvent(self.btnCollect, collect)
	end
end

function ThemeSuperSWin:show()

	if self.isPortrait then
 		scale = 0.7
 		self.node:setPosition(360, 640)
 	else
 		scale = 1
 		self.node:setPosition(0, 0)
 	end

 	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))
end

function ThemeSuperSWin:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end

------------------------Theme RepeatWin Dialog------------------------

ThemeRepeatWinPlus = class("ThemeRepeatWinPlus", CCSNode)

function ThemeRepeatWinPlus:ctor( coins, limit )
	self.coins      = coins or 0
	self.limit      = limit or 0
	self.isPortrait = ScreenControl:getInstance().isPortrait
	CCSNode.ctor(self, "activities/repeat_win_plus/theme_repeat_win_plus" .. (self.isPortrait and "_v" or "") .. ".csb")
end

function ThemeRepeatWinPlus:loadControls()
	self.root           = self.node:getChildByName("root")
	-- self.labelWin       = self.root:getChildByName("label_win")
	-- self.labelLimit     = self.root:getChildByName("label_limit")
	self.btnClose       = self.root:getChildByName("btn_close")
	-- self.labelTime      = self.root:getChildByName("label_remaining")

	self.show_action_tbl = {}
	local title_node = self.root:getChildByName("title_node")
	if title_node then
		self.show_action_tbl[#self.show_action_tbl + 1] = title_node
		libUI.addSpineAnimation(title_node, nil, "activities/repeat_win_plus/spines/" .. (self.isPortrait and "prize_title_v" or "prize_title") .. "/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
	end

	local coin_node = self.root:getChildByName("coin_node")
	if coin_node then
		self.show_action_tbl[#self.show_action_tbl + 1] = coin_node
		self.labelWin = coin_node:getChildByName("label_win")
		if self.labelWin then
			self.labelWin:setString(FONTS.format(self.coins, true))
			if self.isPortrait then
				libUI.adjustLabelByWidth(self.labelWin, 435, 1)
			else	
				libUI.adjustLabelByWidth(self.labelWin, 520, 1)
			end
		end
	end

	local node_limit = self.root:getChildByName("node_limit")
	if node_limit then
		self.show_action_tbl[#self.show_action_tbl + 1] = node_limit
		self.labelLimit = node_limit:getChildByName("label_limit")
		local coin = node_limit:getChildByName("coin")
		if self.labelLimit then
			self.labelLimit:setString(FONTS.format(self.limit, true))
			if self.isPortrait then
				libUI.adjustLabelByWidth(self.labelLimit, 416, 1)
				if coin then
					local scale = self.labelLimit:getScaleX() or 1
					coin:setScale(scale)
					local imageWidth = 89 * scale
					local labelWidth = self.labelLimit:getContentSize().width * scale
					local middle_width = 2
					
					coin:setPositionX(imageWidth / 2 - (imageWidth + labelWidth) / 2 - middle_width)
					self.labelLimit:setPositionX((imageWidth + labelWidth) / 2 - labelWidth / 2 + middle_width)
				end
			else	
				libUI.adjustLabelByWidth(self.labelLimit, 238, 1)
			end
		end
	end

	local node_time = self.root:getChildByName("node_time")
	if node_time then
		self.show_action_tbl[#self.show_action_tbl + 1] = node_time
		self.labelTime = node_time:getChildByName("label_remaining")
		if self.labelTime then
			libUI.configCountDownLabel(
				self.labelTime, 
				function ( ... )
					return ActivityCenterControl:getInstance():getActivityLeftTime("repeat_win_plus")
				end, 
				function ( ... )
					if libUI.isValidNode(self.labelTime) then
						self.labelTime:setString("00:00:00")
					end
					if self.hide then
						self:hide()
					end
				end, 
				{nil, nil}, 
				true, 
				{"", " DAYS", " DAY"})
		end
	end

	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end
end

-- function ThemeRepeatWinPlus:refreshTime( ... )
-- 	local time_left = ActivityCenterControl:getInstance():getActivityLeftTime("repeat_win_plus")
-- 	if time_left > 0 then
-- 		local function getTimeString(num)
-- 			return ((num < 10 and "0") or "") .. num
-- 		end

-- 		-- day暂时不需要
-- 		local hour   = getTimeString(math.floor(time_left / 3600))
-- 		local minute = getTimeString(math.floor(time_left % 3600 / 60))
-- 		local second = getTimeString(math.floor(time_left % 60))
-- 		if self.labelTime then
-- 			self.labelTime:setString("Promotion Ends In: " .. hour .. ":" .. minute .. ":" .. second)
-- 		end
-- 	else
-- 		if self.hide then
-- 			self:hide()
-- 		end
-- 	end
-- end

function ThemeRepeatWinPlus:playShowActions(delay)
	local delay_time = delay or 0.3
	local temp = self.show_action_tbl or {}

	local total_time = libUI.popupSuccessively(temp, {}, delay_time, {10 / 60})

	if libUI.isValidNode(self.btnClose) then
		self.btnClose:setOpacity(0)
		self.btnClose:runAction(cc.Sequence:create(
			cc.DelayTime:create(total_time - 10 / 60),
			cc.FadeTo:create(10 / 60, 255)
		))
	end
end

function ThemeRepeatWinPlus:show(delay)
	local delay_time = delay or 0

 	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H)
		-- self:runTimeLine(40)
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
		-- self:runTimeLine(0)
	end
	local scale = 1

	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay_time),
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
			self:showMask(self.isPortrait, 0.2)
			self:playShowActions(0.3)
		end)
	))

	-- self:runAction(cc.RepeatForever:create(cc.Sequence:create(
	-- 	        cc.CallFunc:create(function ( ... )
	-- 	            self:refreshTime()
	-- 	        end),
	-- 	        cc.DelayTime:create(1))))
end

function ThemeRepeatWinPlus:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end

	self:hideActions(true)

	bole.closeDialog(self, bole.popExitWin)
end

------------------------Theme Jackpot Again Dialog------------------------

ThemeJackpotAgain = class("ThemeJackpotAgain", CCSNode)

function ThemeJackpotAgain:ctor( coins, limit )
	self.coins      = coins or 0
	self.limit      = limit or 0
	self.isPortrait = ScreenControl:getInstance().isPortrait
	local csbFile = self.isPortrait and "activities/jackpot_again/theme_jackpot_again_v.csb" or "activities/jackpot_again/theme_jackpot_again.csb"
	CCSNode.ctor(self, csbFile)
end

function ThemeJackpotAgain:loadControls()
	self.root           = self.node:getChildByName("root")
	local label_node    = self.root:getChildByName('label_node')
	if label_node then
		self.labelWin       = label_node:getChildByName("label_win")
	end
	local limit_node    = self.root:getChildByName("limit_node")
	if limit_node then
		self.labelLimit = limit_node:getChildByName("label_limit")
	end
	self.btnClose  = self.root:getChildByName("btn_close")
	self.labelTime = self.root:getChildByName("label_remaining")
	self.btnGet    = self.root:getChildByName('btn_get')  -- 进入store中再次购买
	self.limitTip  = self.root:getChildByName('limit_tip')
	self.noLimit   = self.root:getChildByName('nolimit')
	if self.noLimit then
		local no_limit_spine = self.noLimit:getChildByName('no_limit_spine')
		if no_limit_spine then
			if self.isPortrait then
				no_limit_spine:setScale(0.88)
			end
			libUI.addSpineAnimation(no_limit_spine, nil, "activities/jackpot_again/spines/no_limit/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
		end
	end

	local spine_1  = self.root:getChildByName("spine_1")
	if spine_1 then
		if self.isPortrait then
			libUI.addSpineAnimation(spine_1, nil, "activities/jackpot_again/spines/theme_bg_v/spine", cc.p(0, 20), "animation2", nil, nil, nil, true, true, nil)
		else
			libUI.addSpineAnimation(spine_1, nil, "activities/jackpot_again/spines/theme_bg/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
		end
	end

	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end

	if self.btnGet then
		local function openStore( ... )
			StoreControl:getInstance():showStoreDialog({is_coins = true, delay = 0.5, from="jp_again"}, nil, false)
			self:hide()
		end
		self:addTouchEvent(self.btnGet, openStore)
	end

	if self.labelWin then
		self.labelWin:setString(FONTS.format(self.coins, true))
		bole.shrinkLabel(self.labelWin, self.isPortrait and 540 or 710, self.isPortrait and 0.8 or 1)
		-- if self.isPortrait then
		-- 	libUI.adjustLabelByWidth(self.labelWin, 280, 0.6) -- 280
		-- else	
		-- 	libUI.adjustLabelByWidth(self.labelWin, 480, 1) -- 480
		-- end
	end

	if self.labelLimit then
		self.labelLimit:setVisible(self.limit >= 0)
		self.labelLimit:setString(FONTS.format(self.limit, true))
		bole.shrinkLabel(self.labelLimit, self.isPortrait and 340 or 290, 1)
	end

	if self.noLimit then
		self.noLimit:setVisible(self.limit < 0)
	end

	if self.limitTip then
		self.limitTip:setVisible(self.limit >= 0)
	end

end

function ThemeJackpotAgain:refreshTime( ... )
	local time_left = ActivityCenterControl:getInstance():getActivityLeftTime("jackpot_again")
	if time_left > 0 then
		local function getTimeString(num)
			return ((num < 10 and "0") or "") .. num
		end

		-- day暂时不需要
		local hour   = getTimeString(math.floor(time_left / 3600))
		local minute = getTimeString(math.floor(time_left % 3600 / 60))
		local second = getTimeString(math.floor(time_left % 60))
		if self.labelTime then
			self.labelTime:setString(" " .. hour .. ":" .. minute .. ":" .. second)
		end
	else
		if self.hide then
			self:hide()
		end
	end
end

function ThemeJackpotAgain:show()
 	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H)
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
	end
	local scale = 1

	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))

	self:runAction(cc.RepeatForever:create(cc.Sequence:create(
		        cc.CallFunc:create(function ( ... )
		            self:refreshTime()
		        end),
		        cc.DelayTime:create(1))))
end

function ThemeJackpotAgain:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end

------------------------Theme Boosted Wins Dialog------------------------

ThemeBoostedWins = class("ThemeBoostedWins", CCSNode)

function ThemeBoostedWins:ctor( data)
	data            = data or {}
	self.coins      = data.win or 0
	self.ratio      = data.ratio or 0.5
	self.isPortrait = ScreenControl:getInstance().isPortrait
	CCSNode.ctor(self, "activities/boosted_wins/theme_boosted_wins.csb")
end

function ThemeBoostedWins:loadControls()
	self.root           = self.node:getChildByName("root")
	self.labelWin       = self.root:getChildByName("label_win")
	self.labelRatio     = self.root:getChildByName("label_ratio")
	self.btnClose       = self.root:getChildByName("btn_close")
	self.labelTime      = self.root:getChildByName("label_remaining")

	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end

	if self.labelWin then
		self.labelWin:setString(FONTS.format(self.coins, true))
	end

	if self.labelRatio then
		self.labelRatio:setString("" .. self.ratio .. "%")
	end
end

function ThemeBoostedWins:refreshTime( ... )
	local time_left = ActivityCenterControl:getInstance():getActivityLeftTime("boosted_wins")
	if time_left > 0 then
		local function getTimeString(num)
			return ((num < 10 and "0") or "") .. num
		end

		-- day暂时不需要
		local hour   = getTimeString(math.floor(time_left / 3600))
		local minute = getTimeString(math.floor(time_left % 3600 / 60))
		local second = getTimeString(math.floor(time_left % 60))
		if self.labelTime then
			self.labelTime:setString("Promotion Ends In: " .. hour .. ":" .. minute .. ":" .. second)
		end
	else
		if self.hide then
			self:hide()
		end
	end
end

function ThemeBoostedWins:show()
 	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H)
		self:runTimeLine(20)
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
		self:runTimeLine(0)
	end
	local scale = 1

	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))

	self:runAction(cc.RepeatForever:create(cc.Sequence:create(
		        cc.CallFunc:create(function ( ... )
		            self:refreshTime()
		        end),
		        cc.DelayTime:create(1))))
end

function ThemeBoostedWins:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end

------------------------Theme Delete Cache Dialog------------------------

ThemeDeleteCache = class("ThemeDeleteCache", CCSNode)

function ThemeDeleteCache:ctor( data)
	self.themeId = data.themeId
	self.isPortrait = ScreenControl:getInstance().isPortrait
	CCSNode.ctor(self, "themetips/delete_cache/delete_cache.csb")
end

function ThemeDeleteCache:loadControls()
	self.root       = self.node:getChildByName("root")
	self.btn_close  = self.root:getChildByName("btn_close")
	self.btn_delete = self.root:getChildByName("btn_delete")
	self.theme_name = self.root:getChildByName("theme_name")

	local name = "BitmapFontLabel_2"
	for index = 1, 3 do
		if index > 1 then
			name = name .. "_Copy"
		end
		local font_label = self.root:getChildByName(name)
		if font_label then
			bole.ctorUIComponent(font_label, UIComponent.LanguageLabel)
			if index == 1 then
				font_label:setOriginFntColor(cc.c3b(253, 235, 0))
			end
			font_label:setTTFStroke(cc.c3b(165, 50, 0), 2)
			font_label:setStringConfig({
				string_type  = LANGUAGE_STRING_TYPE.VALUE,
				string_key   = "COMMON.delete_theme",
				string_value = {index}
			})
		end
	end

	if self.btn_close then
		local function btn_close_func()
			self:enableButton()
			self:hide()
		end
		self:addTouchEvent(self.btn_close,btn_close_func)
	end
	if self.btn_delete and self.themeId then
		local function btn_delete_func()
			self:enableButton()
			LobbyThemeControl:getInstance():removeThemeResouces(THEME_LIST[self.themeId].resourceId) -- 删除对应主题的缓存	
			self:hide()
		end
		self:addTouchEvent(self.btn_delete,btn_delete_func)
	end
	-- if self.theme_name and self.themeId then
	-- 	self.theme_name:setString(THEME_LIST[self.themeId].name) -- 对应的主题的名字
	-- 	bole.shrinkLabel(self.theme_name, 801, 1)
	-- end

	if self.theme_name and self.themeId then
		local key = "THEME_NAME.theme_name_" ..  bole.getNormalThemeId(self.themeId)
		libUI.setSystemPopTitle(self.theme_name, {
            config = {
                string_type = LANGUAGE_STRING_TYPE.KEY,
                string_key = key,
            },
			ignore_scale = true,
        })
		-- self.theme_name:setOriginMaxWidth(580)
	end

end

function ThemeDeleteCache:enableButton()
	self.btn_close:setTouchEnabled(false)
	self.btn_delete:setTouchEnabled(false)
end

function ThemeDeleteCache:show()
	self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
	self.node:setScale(SHRINKSCALE_H)
	local scale = 1

	-- self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))
end

function ThemeDeleteCache:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	-- self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end

------------------------Theme Rocket Up Dialog------------------------

ThemeRocketUp = class("ThemeRocketUp", CCSNode)

function ThemeRocketUp:ctor(data)
	data            = data or {}
	self.coins      = data.win or 0
	self.limit      = data.limit or 0
	self.ratio      = data.multi or 0
	self.isPortrait = ScreenControl:getInstance().isPortrait
	local csbFile = self.isPortrait and "activities/rocket_up/theme_rocket_up_v.csb" or "activities/rocket_up/theme_rocket_up.csb"
	CCSNode.ctor(self, csbFile)
end

function ThemeRocketUp:loadControls()
	self.root             = self.node:getChildByName("root")
	self.labelWin         = self.root:getChildByName("label_coins")
	-- self.labelOriginalWin = self.root:getChildByName("label_original_coins")
	-- self.line             = self.labelOriginalWin:getChildByName("line")
	self.notReached       = self.root:getChildByName("not_reached")
	self.reached          = self.root:getChildByName("reached")
	self.label_notre      = self.notReached:getChildByName("label_notre")
	self.labelLimit       = self.notReached:getChildByName("label_limit")
	self.labelRatio       = self.root:getChildByName("label_ratio")
	self.btnPlay          = self.root:getChildByName("btn_play")
	self.btnClose         = self.root:getChildByName("btn_close")
	self.labelTime        = self.root:getChildByName("label_remaining")

	if self.reached then
		libUI.addSpineAnimation(self.reached, nil, "activities/rocket_up/spines/no_limit/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
	end

	self.spine_bg  = self.root:getChildByName("spine_bg")
	if self.spine_bg then
		if self.isPortrait then
			libUI.addSpineAnimation(self.spine_bg, nil, "activities/rocket_up/spines/theme_bg_v/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
		else
			libUI.addSpineAnimation(self.spine_bg, nil, "activities/rocket_up/spines/theme_bg/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
		end
	end

	if self.btnPlay then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnPlay, close)
		bole.addKeyboardEvent(self, close, true)
	end

	if self.btnClose then
		local function close( ... )
			bole.playMusic("05_layer_close")
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end

	if self.labelWin and self.coins then
		self.labelWin:setString(FONTS.format(self.coins, true))
		if self.isPortrait then
			bole.shrinkLabel(self.labelWin, 550, 0.75)
		else
			bole.shrinkLabel(self.labelWin, 670, 1)
		end
	end


	if self.labelLimit then
		self.labelLimit:setString(FONTS.format(self.limit, true))
	end

	if self.reached then
		self.reached:setVisible(self.coins >= self.limit)
		if self.isPortrait then
			self.reached:setScale(0.9)
		end
	end
	if self.notReached then
		self.notReached:setVisible(self.coins < self.limit)
	end

	if self.ratio <= 0 then
		self.ratioNode:setVisible(false)
	else
		if self.labelRatio then
			self.labelRatio:setString(self.ratio * 5 .. "%")
			bole.breathingShake(self.labelRatio)
		end
	end

	if self.notReached and self.labelLimit and self.label_notre then
		local l1 = self.label_notre:getContentSize().width
		local l2 = self.labelLimit:getContentSize().width
		self.label_notre:setPositionX(-1 * l2 / 2)
		self.labelLimit:setPositionX(l1 / 2)
		if self.isPortrait then
			if self.labelLimit:getContentSize().width >= 230 then
				self.notReached:setScale(0.93)
			end
			if self.labelLimit:getContentSize().width >= 290 then
				self.notReached:setScale(0.85)
			end
		end
	end
end

function ThemeRocketUp:refreshTime( ... )
	local time_left = ActivityCenterControl:getInstance():getActivityLeftTime("rocket_up")
	if time_left > 0 then
		local function getTimeString(num)
			return ((num < 10 and "0") or "") .. num
		end

		-- day暂时不需要
		local hour   = getTimeString(math.floor(time_left / 3600))
		local minute = getTimeString(math.floor(time_left % 3600 / 60))
		local second = getTimeString(math.floor(time_left % 60))
		if self.labelTime then
			self.labelTime:setString("" .. hour .. ":" .. minute .. ":" .. second)
		end
	else
		if self.hide then
			self:hide()
		end
	end
end

function ThemeRocketUp:show()
 	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H)
		-- self:runTimeLine(20)
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
		self:runTimeLine(0)
	end
	local scale = 1

	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))

	self:runAction(cc.RepeatForever:create(cc.Sequence:create(
		        cc.CallFunc:create(function ( ... )
		            self:refreshTime()
		        end),
		        cc.DelayTime:create(1))))
end

function ThemeRocketUp:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end


------------------------theme prize pool -> theme------------------------

rafflePrizePoolWin = class("rafflePrizePoolWin", CCSNode)

function rafflePrizePoolWin:ctor( data )
	self.showData = data
	
	self.isPortrait = ScreenControl:getInstance().isPortrait
	local csbFile = self.isPortrait and "themetips/raffle_prize_pool/raffle_prize_pool_v.csb" or "themetips/raffle_prize_pool/raffle_prize_pool.csb"
	CCSNode.ctor(self, csbFile)
end

function rafflePrizePoolWin:loadControls()
	self.root       	= self.node:getChildByName("root")
	self.btnClose   	= self.root:getChildByName("btn_close")
	self.lbTicketsCur   = self.root:getChildByName("lb_tickets_cur")
	self.lbTicketsTotal = self.root:getChildByName("lb_tickets_total")
	
	if self.showData then 
		if self.showData.delta_tickets then 
			self.lbTicketsCur:setString(self.showData.delta_tickets > 1 and self.showData.delta_tickets or "A" )
		end

		self.lbTicketsTotal:setString(self.showData.tickets or "")
	end


	local spine_1   = self.root:getChildByName("spine1")
	if spine_1 then
		local animName = self.isPortrait and "animation2" or "animation"
		libUI.addSpineAnimation(spine_1, nil, "themetips/raffle_prize_pool/spines/bg1/spine", cc.p(0, 0), animName, nil, nil, nil, true, true, nil)
	end

	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end
end

function rafflePrizePoolWin:show()
	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H) -- SHRINKSCALE_V
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
	end
	local scale = 1

 	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.playMusic("game7")
			bole.popWin_4(self.root, nil, 0.36, scale)
				self:showMask(self.isPortrait, 0.2)
		end)))
end

function rafflePrizePoolWin:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end



------------------------out of coins sale dialog------------------------

outOfCoinsSaleDialog = class("outOfCoinsSaleDialog", CCSNode)

function outOfCoinsSaleDialog:ctor(data, callback)
	self.callback       = callback
	self.isPortrait     = ScreenControl:getInstance().isPortrait
	self.hasPortraitRes = true
	local csbFile = "out_of_coins_sale/out_of_coins_sale" .. (self.isPortrait and "_v" or "") .. ".csb"
	CCSNode.ctor(self, csbFile)
end

function outOfCoinsSaleDialog:loadControls()
	self.root       	= self.node:getChildByName("root")
	self.btnClose   	= self.root:getChildByName("btn_close")
	
	local title = self.root:getChildByName("title")
	if title then
		local title2 = title:getChildByName("title2")
		if title2 then
			libUI.popupSuccessively({title2}, nil, 0.36, {10/60})
		end
	end

	self.data = StoreControl:getInstance():getOutOfCoinsData() or {}
	for i = 1, 3 do
		local prize_node = self.root:getChildByName("prize_node" .. i)
		if prize_node and self.data and self.data[i] then
			local bg = prize_node:getChildByName("bg")
			if bg then
				local coin_light = bg:getChildByName("coin_light")
				if coin_light then
					libUI.addSpineAnimation(coin_light, nil, "out_of_coins_sale/spines/coin_light/spine", cc.p(0, 0), "animation" .. i, nil, nil, nil, true, true)
				end
			end
			local gift = prize_node:getChildByName("gift")
			if gift then
				local bg_light = gift:getChildByName("bg_light")
				if bg_light then
					bg_light:setScale(0.8)
					libUI.addSpineAnimation(bg_light, nil, "out_of_coins_sale/spines/bg_light/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true)
				end
			end
			local percent_node = prize_node:getChildByName("percent_node")
			if percent_node then
				percent_node:setOpacity(0)
				percent_node:setScaleY(0)
				percent_node:runAction(cc.Sequence:create(
					cc.DelayTime:create(0.36 + 10/30),
					cc.Spawn:create(
						cc.ScaleTo:create(0.2, 1, 1),
						cc.FadeIn:create(0.2)
					),
					cc.ScaleTo:create(0.12, 1, 0.95),
					cc.ScaleTo:create(0.13, 1, 1)
				))
				local percent_label = percent_node:getChildByName("percent_label")
				if percent_label then
					local label_more = percent_label:getChildByName("label_more")
					bole.ctorUIComponent(label_more, UIComponent.LanguageLabel)
					label_more:setTTFStroke(cc.c3b(255, 0, 0), 3)
					label_more:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.KEY,
						string_key = "STORE.more",
					})
					local label_ratio = percent_label:getChildByName("label_ratio")
					local percent = self.data[i].ratio or 0
					if label_more and label_ratio and percent then
						label_ratio:setString(percent .. "%")
						if percent < 100 then
							label_ratio:setPositionX(label_ratio:getPositionX() + 4)
							label_more:setPositionX(label_more:getPositionX() - 4)
						elseif percent > 1000 then
							label_ratio:setPositionX(label_ratio:getPositionX() - 2)
							label_more:setPositionX(label_more:getPositionX() + 9)
							percent_label:setScale(0.92)
						end
						local data = {
							["node"] = percent_label,
							["filePath"] = "out_of_coins_sale",
							["down_key"] = "out_of_coins_sale",
							["down_type"] = DOWNLOAD_TYPE.SYSTEM,
						}
						bole.updateLanguage(data)
					end
					local baseScale = percent_label:getScaleX()
					percent_label:setScale(0)
					percent_label:runAction(cc.Sequence:create(
						cc.DelayTime:create(0.36 + 10/30 + 0.33),
						cc.ScaleTo:create(10/30, 1.2 * baseScale),
						cc.ScaleTo:create(4/30, 0.95 * baseScale),
						cc.ScaleTo:create(4/30, 1 * baseScale),
						cc.DelayTime:create(1),
						cc.CallFunc:create(function ()
							-- bole.breathingShake(percent_label)
							local action = cc.RepeatForever:create(cc.Sequence:create(
								cc.ScaleTo:create(0.5,baseScale+0.4*baseScale),
								cc.ScaleTo:create(0.5,baseScale),
								cc.ScaleTo:create(0.5,baseScale+0.4*baseScale),
								cc.ScaleTo:create(0.5,baseScale),
								cc.DelayTime:create(1)
								))
							action:setTag(100)
							percent_label:runAction(action)
						end)
					))
				end
			end	
			local coin_node = prize_node:getChildByName("coin_node")
			if coin_node then
				local label_original = coin_node:getChildByName("label_original")
				local original_coins = self.data[i].original_coins or 0
				if label_original and original_coins then
					--label_original:setString("WAS " .. FONTS.format(original_coins, true))
					bole.ctorUIComponent(label_original, UIComponent.LanguageLabel)
					label_original:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.VALUE,
						string_key = "STORE.was",
						string_value = {FONTS.format(original_coins, true)},
					})
					bole.shrinkLabel(label_original, self.isPortrait and 170 or 150, 1)
					local line = label_original:getChildByName("line")
					if line then
						line:setContentSize(label_original:getContentSize().width, 2)
					end
				end
				local label_coins = coin_node:getChildByName("label_coins")
				local credits = self.data[i].credits or 0
				if label_coins and credits then
					label_coins:setString(FONTS.format(credits, true))
					bole.shrinkLabel(label_coins, self.isPortrait and 250 or 218, 1)
				end
			end
			local btn_node = prize_node:getChildByName("btn_node")
			if btn_node then
				local btn_buy = btn_node:getChildByName("btn_buy")
				if btn_buy then
					local function getFunc()
						bole.playMusic("04_shop_open")
						local storeInfo = STORE_ITEMS[self.data[i].item_id]
						self.data[i].item = PURCHASE_ITEM_PREFIX .. storeInfo[2]
						self:startPurchase(self.data[i].item, self.data[i].item_id)
					end
					self:addTouchEvent(btn_buy, getFunc)
					local label_price = btn_buy:getChildByName("label_price")
					if label_price and self.data[i].price then
						--label_price:setString("ONLY " .. bole.convertPrice(self.data[i].price))
						bole.ctorUIComponent(label_price, UIComponent.LanguageLabel)
						label_price:setTTFStroke(cc.c3b(9,55, 14), 3)
						label_price:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.VALUE,
						string_key = "STORE.only",
						string_value = {bole.convertPrice(self.data[i].price)},
					})
					end
				end
				local spine_btn = btn_node:getChildByName("spine_btn")
				if spine_btn then
					libUI.addSpineAnimation(spine_btn, nil, "out_of_coins_sale/spines/btn/spine", cc.p(0, 0), "animation", nil, nil, nil, true, true)
				end
				local btnBenefits = btn_node:getChildByName("btn_benefits")
				if btnBenefits then
					local function benefitsFunc()
						bole.playMusic("game2")
						local dialog = PurchaseBenefitsDialog.new(self.data[i], nil)
						dialog:show()
					end
					self:addTouchEvent(btnBenefits, benefitsFunc)
				end
			end
		end
	end


	-- local spine_1   = self.root:getChildByName("spine1")
	-- if spine_1 then
	-- 	local animName = self.isPortrait and "animation2" or "animation"
	-- 	libUI.addSpineAnimation(spine_1, nil, "themetips/raffle_prize_pool/spines/bg1/spine", cc.p(0, 0), animName, nil, nil, nil, true, true, nil)
	-- end

	if self.btnClose then
		local function close( ... )
			self:hide()
		end
		self:addTouchEvent(self.btnClose, close)
		bole.addKeyboardEvent(self, close, true)
	end
end

function outOfCoinsSaleDialog:startPurchase(storeKey, itemId)
	local function callback( ... )
		if self and self.hide then
			self:hide(true)
		end
	end
	PurchaseControl:getInstance():buy(storeKey, itemId, callback, nil, TAG_BUY_BLAST)
end

function outOfCoinsSaleDialog:show()
	bole.send_codeInfo("record", {pid = PID.out_of_coins_sale}, false)

	if self.isPortrait then
		self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		self.node:setScale(SHRINKSCALE_H) -- SHRINKSCALE_V
	else
		self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		self.node:setScale(SHRINKSCALE_H)
	end
	local scale = 1

 	self:showActions()

	bole.scene:addChild(self)
	self:setVisible(false)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:setVisible(true)
			bole.popWin_4(self.root, nil, 0.36, scale)
			self:showMask(self.isPortrait, 0.2)
		end)))
end

function outOfCoinsSaleDialog:hide()
	if self.isHiding then return end

	if self.callback then self.callback() end
	self:hideActions(true)
	bole.closeDialog(self, bole.popExitWin)
end
