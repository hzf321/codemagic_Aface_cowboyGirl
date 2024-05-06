--Author:xiongmeng
--2019年6月17日 11:00
--Using:主题 138

ThemeMightyCash = class("ThemeMightyCash", Theme)
local cls = ThemeMightyCash

-- 资源异步加载相关
cls.plistAnimate = {
	"image/plist/symbol",
	"image/plist/base",
}

cls.csbList = {
	"csb/base.csb",
}

local transitionDelay = {
	["free"] 	= {["onCover"] = 12/30,["onEnd"] = 72/30},
	["respin"]  = {["onCover"] = 21/30,["onEnd"] = 72/30}
}

local SpinBoardType = {
	Normal 		= 1,
	FreeSpin 	= 2,
	ReSpin      = 3,
	-- Bonus 		= 3,
}

local RespinDialogType = {
	start = 1,
	extra = 2
}

local FreeSpinType = {
	normal = 0,
	mega   = 1,
	super  = 2
}

local BonusGameType = { -- type1对应repsin type2对应 deal game type3对应 level
	["ReSpin"] 	= 1,
	["MegaBonus"] 	= 2,
	["SuperBonus"] 	= 3,
}

local ReSpinStep = {
	OFF = 1,
	Start = 2,
	Reset = 3,
	Over = 4,
	Playing = 5,	
}

local Jsize = {
	["width"] = 195,
	["height"] = 170,
	["height1"] = 153,
}

local Symbolsize = {
	["width"] = 193,
	["height"] = 143
}

local FloorBgPng = {
	['normal'] = '#theme138_base_bg1.png',
	['inRespin'] = '#theme138_base_bg2.png'
}

local fontScale = 1

local PoolMuls2 = {
	[0] = 3000, [1] = 1000, [2] = 400, [3] = 20, [4] = 10 --25 -- 50
}

local featureBonuPos = {cc.p(-390, 190), cc.p(-343, 190), cc.p(-296, 190), cc.p(-174, 190), cc.p(-127, 190), cc.p(-80, 190), 
	cc.p(40, 190), cc.p(85, 190), cc.p(131, 190), cc.p(178, 190), cc.p(223, 190), cc.p(270, 190), cc.p(315, 190), 
}

local superBonusPos = {cc.p(-235, 190), cc.p(-21, 190), cc.p(376, 190)}
local superBonusSet = {4,8,16}

local moveWildTime = 1
local changeToWildTime = 24/30
local changeToBaseTime = 21/30
local moveStartDelay = 6/30

local FreshTime = 0.3

local specialSymbol = {["jackpot"] = {['key'] = 14, ['value'] = 20}, ["triger"] = 11, ["wild"] = 13}

local jackpotBet = {
[20]=0.5, [21]=1, [22]=2, [23]=3, [24]=4, [25]=5, [26]=6, [27]=7, [28]=8, [29]=9, [30]=10, [31]=15, [32]=20, [33]=30, [34]=40, [35]=60,
[36]=100, [39] = 0, [40] = 'grand', [41] = 'maxi', [42] = 'major', [43] = 'minor', [44] = 'mini'
}

local bonus2Type = {39, 15}

local rowCnt = 5
cls.spinTimeConfig = { -- spin 时间控制
		[1] = 81/60,
		[2] = 181/ 60,
		["base"] = 20/60, -- 数据返回前 进行滚动的时间
		[0] = 40/60,
		["spinMinCD"] = 50/60,  -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}

cls.parseValue = function(num)
    local ss = FONTS.format(num, false, false)
    if num < 1000 then
        ss = FONTS.format(ss, true)
    else
        local len = string.len(string.match(ss, "%d+"))
        if len == 3 then
            ss = string.match(ss, "%d+") .. string.match(ss, "[^$0-9%.]")
        elseif len == 2 then
            if string.match(ss, "%.") then
                ss = string.match(ss, "%d+..") .. string.match(ss, "[^$0-9%.]")
            else
                ss = string.match(ss, "%d+") .. string.match(ss, "[^$0-9%.]")
            end
        elseif len == 1 then
            if string.match(ss, "%.") then
                ss = string.match(ss, "%d+..") .. string.match(ss, "[^$0-9%.]")
            else
                ss = string.match(ss, "%d+") .. string.match(ss, "[^$0-9%.]")
            end
        end
    end
    return ss
end

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	local borderConfig = self.ThemeConfig["boardConfig"]
	local reelConfig = borderConfig[2]["reelConfig"]
	local newConfig = {}
	for i=0, 14 do
		local oneConfig = {}
		oneConfig["base_pos"] = cc.p((i%5)*reelConfig["cellWidth"]+reelConfig["base_pos"].x + (i%5)*reelConfig["lineWidth"],math.floor((14-i)/5)*reelConfig["cellHeight"]+reelConfig["base_pos"].y)
 		oneConfig["cellWidth"] = reelConfig["cellWidth"]
		oneConfig["cellHeight"] = reelConfig["cellHeight"]
		oneConfig["symbolCount"] = reelConfig["symbolCount"]
		oneConfig['lineWidth'] = reelConfig['lineWidth']
		table.insert(newConfig,oneConfig)
	end
	borderConfig[2]["rowReelCnt"] = rowCnt
	borderConfig[2]["reelConfig"] = newConfig
	self.boardConfigList = borderConfig
	return borderConfig
end

function cls:initBoardNodes(pBoardConfigList)
	local boardRoot 	  = self.boardRoot
	local boardConfigList = pBoardConfigList or self.boardConfigList or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	-- 棋盘初始化
	for boardIndex, theConfig in ipairs(boardConfigList) do
		local theBoardNode 	= nil
		local reelNodes = {}
		if theConfig["row_single"] then -- 一行使用一个裁剪区域 等距才可以
			theBoardNode = cc.Node:create()
			boardRoot:addChild(theBoardNode)
			local rowReelCnt = theConfig["rowReelCnt"]
   			local index = 0
   			local clipNode = nil
   			local reelNode = nil
   	   		for reelIndex,config in ipairs(theConfig["reelConfig"]) do
	   			 
   	   			if (reelIndex-1)%rowReelCnt == 0 then 
   	   				reelNode = cc.Node:create()
   	   				reelNode:setLocalZOrder(reelZorder)
   	   				
					local vex = {
						config["base_pos"], -- 第一个轴的左下角  下左边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt + config['lineWidth'] * (rowReelCnt - 1), 0)),  -- 下右边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt + config['lineWidth'] * (rowReelCnt - 1), config["cellHeight"])),-- 上右边界
						cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
					}
		   		    local stencil = cc.DrawNode:create()
		   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		   		    local clipAreaNode = cc.Node:create()
		   		    clipAreaNode:addChild(stencil)
		   		    clipNode = cc.ClippingNode:create(clipAreaNode)
		   		   
					theBoardNode:addChild(clipNode)	
					clipNode:addChild(reelNode)
   	   			end
				reelNodes[reelIndex] = reelNode
   		    end
		elseif theConfig["single"] then
			theBoardNode = cc.Node:create()
			-- theBoardNode:setPosition(theConfig["base_pos"])
			boardRoot:addChild(theBoardNode)
			
   		    for reelIndex,config in ipairs(theConfig["reelConfig"]) do
				local reelNode = cc.Node:create()
				reelNode:setLocalZOrder(reelZorder)
				local vex = {
					config["base_pos"], -- 第一个轴的左下角  下左边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"])),-- 上右边界
					cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
				}
	   		    local stencil = cc.DrawNode:create()
	   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

	   		    local clipAreaNode = cc.Node:create()
	   		    clipAreaNode:addChild(stencil)
	   		    local clipNode = cc.ClippingNode:create(clipAreaNode)
	   		    clipNode:addChild(reelNode)
				theBoardNode:addChild(clipNode)	
				reelNodes[reelIndex] = reelNode
   		    end
		else
			self.clipData["normal"] = {}
			local reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			theBoardNode = cc.Node:create()
			-- theBoardNode:setPosition(theConfig["base_pos"])
			boardRoot:addChild(theBoardNode)
			local clipAreaNode = cc.Node:create()

   		    for reelIndex,config in ipairs(theConfig["reelConfig"]) do
				local vex = {
					config["base_pos"], -- 第一个轴的左下角  下左边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"]*config["symbolCount"])),-- 上右边界
					cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
				}
				if theConfig["allow_over_range"] then
					vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
					vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

					vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
					vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
				end
	   		    local stencil = cc.DrawNode:create()
	   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
	   		    clipAreaNode:addChild(stencil)
				reelNodes[reelIndex] = reelNode

				self.clipData["normal"][reelIndex] = {}
				self.clipData["normal"][reelIndex]["vex"] = vex
				self.clipData["normal"][reelIndex]["stencil"] = stencil
   		    end
			local clipNode = cc.ClippingNode:create(clipAreaNode)

			theBoardNode:addChild(clipNode)	
			clipNode:addChild(reelNode)
		end		
	
		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		pBoardNodeList[boardIndex] = theBoardNode
	end
	return pBoardNodeList
end

function cls:ctor(themeid)
	math.randomseed(os.time())
  	self.spinActionConfig = {
		["start_index"] = 10,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	}
	self.ThemeConfig = {
		["theme_symbol_coinfig"]    = {
			["symbol_zorder_list"]  = {
	            [specialSymbol.triger] 	= 600,
	            [specialSymbol.wild] = 400
			},
			["normal_symbol_list"]  = {
				1, 2, 3, 4, 5, 6, 7, 8, 9, 10   -- 12是bonus2  14是bonus1
			},
			["special_symbol_list"] = {
				specialSymbol.triger, specialSymbol['jackpot']['key'], specialSymbol.wild
			},
			["no_roll_symbol_list"] = {
				'nil', 'bonus2'-- nil用来确保某些图片用空

				-- specialSymbol.blank,longSymbol.l1,longSymbol.l2,longSymbol.l3,longSymbol.l4,specialSymbol.kong
			},
			["roll_symbol_inFree_list"] = {
				1,2,3,4,5,11,13,14
			},
			["special_symbol_config"] = {
				[specialSymbol.triger] = {
					["min_cnt"] = 3,
					["type"]	= G_THEME_SYMBOL_TYPE.NUMBER,
					["col_set"] = {
						[1] = 1,
						[2] = 1, 
						[3] = 1,
						[4] = 1,
						[5] = 1,
					},
				},
			},
		},
		["theme_round_light_index"] = 1,
		["theme_type"] = "ways",
		["theme_type_config"] = {
			-- ["line_index"] = "Mania",
			-- ["line_cnt"]   = 10,
			["ways_cnt"]   = 243
		},
		["boardConfig"] = {
			{ -- 3x5
				["allow_over_range"] = true,
				["reelConfig"] = {
					{
						["base_pos"] 	= cc.p(172,102),
						["cellWidth"] 	= 183,
						["cellHeight"] 	= 143,
						["symbolCount"] = 3
					},
					{
						["base_pos"] 	= cc.p(360,102),
						["cellWidth"] 	= 183,
						["cellHeight"] 	= 143,
						["symbolCount"] = 3
					},
					{
						["base_pos"] 	= cc.p(548,102),
						["cellWidth"] 	= 183,
						["cellHeight"] 	= 143,
						["symbolCount"] = 3
					},
					{
						["base_pos"] 	= cc.p(736,102),
						["cellWidth"] 	= 183,
						["cellHeight"] 	= 143,
						["symbolCount"] = 3
					},
					{
						["base_pos"] 	= cc.p(924,102),
						["cellWidth"] 	= 183,
						["cellHeight"] 	= 143,
						["symbolCount"] = 3
					},
				}
			},
			{	
				-- ["allow_over_range"] = true,
				["row_single"] = true, -- 每 行 reel单独一个空间，不共用一个clipnode。例如用于lockrespin
				["reelConfig"] = {
					["base_pos"] = cc.p(172,102),
					["cellWidth"] = 183,
					["cellHeight"] = 143,
					["symbolCount"] = 1,
					['lineWidth'] = 5,
				}
			}
		}
	}
	self.baseBet = 10000
	self.DelayStopTime = 0
	-- self.UnderPressure = 1 -- 下压上 控制
	-- local use_portrait_screen = false
	local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 143
local delay = 0  -- 3/60 -- 各个 滚轴开始滚动的 间隔时间
local upBounce = G_cellHeight*2/3   -- G_cellHeight*2/3 -- 上弹位移
local upBounceMaxSpeed = 6 * 60  -- 上弹的最大速度
local upBounceTime = 0   -- 滚轴滚动开始上弹时间
local speedUpTime = 12/60  -- 开始滚动时候的 加速时间
local rotateTime = 5/60	 -- 匀速滚动时间 
-- local maxSpeed = -30*60
local maxSpeed = -30*60  -- 最大速度
local normalSpeed = -30*60  -- not Turbo 最大速度
local fastSpeed = -30*60 - 300  -- Turbo 最大速度

local stopDelay = 20/60  -- 滚轴停止的 延迟时间（两个轴 中间的间隔）
local speedDownTime = 60/60   -- 减速时间
local downBounce = G_cellHeight*2/3  -- 下砸位移
local downBounceMaxSpeed = 6*60	 -- 下砸的最大速度
local downBounceTime = 21/60	-- 下砸时间
local specialAniTime =  22/30  --160/60 	-- 特殊feature 的延迟时间
local extraReelTime = 120/60  --120/60	-- anticipation 时间
local spinMinCD = 0.5 -- 最短出现 stop按钮的时间

function cls:getSpinColStartAction( pCol, reelCol )
	if self.isTurbo then
		maxSpeed = fastSpeed
	else 
		maxSpeed = normalSpeed
	end
	local spinAction = {}
	spinAction.delay = delay*(pCol-1)
	spinAction.upBounce = upBounce
	spinAction.upBounceMaxSpeed = upBounceMaxSpeed
	spinAction.upBounceTime = upBounceTime
	spinAction.speedUpTime = speedUpTime
	spinAction.maxSpeed = maxSpeed

	if self.showReSpinBoard and self.HoldLayer._added[reelCol] then
		spinAction.locked = true
	end

	return spinAction
end
 
function cls:getSpinColStopAction(themeInfo, pCol, interval)
	local checkNotifyTag   = self:checkNeedNotify(pCol)

	if checkNotifyTag then
		self.DelayStopTime = self.DelayStopTime + extraReelTime
	end

	local specialType = nil
	if not self.showReSpinBoard then 
		specialType= themeInfo and themeInfo["special_type"]
	end
	local function onSpecialBegain( pcol)
		if pcol == 1 then 
			self:addSpecialSpeed(specialType)
		end
	end


	local spinAction = {}
	spinAction.actions = {}
	local temp = interval - speedUpTime - upBounceTime
	-- local temp = interval - speedUpTime - upBounceTime - (pCol-1)*delay
	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
	if specialType then
		table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})

		spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + specialAniTime + self.DelayStopTime
		self.ExtraStopCD = spinAction.stopDelay
		self.canFastStop = true
		spinAction.ClearAction = true
	else
		spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime
		self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0	
	end

	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = spinAction.speedDownTime - 20/60
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = downBounceTime
	spinAction.stopType = 1
	return spinAction
end

function cls:checkNeedNotify(pCol)
	-- if self.showReSpinBoard then -- self.showFreeSpinBoard or  whj 修改
	-- 	return false
	-- end
	return Theme.checkNeedNotify(self, pCol)
end

function cls:initScene(spinNode)
	local path = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	self.down_node 		= self.mainThemeScene:getChildByName("down_child")
	bole.adaptScale(self.mainThemeScene,false)
	-- bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
	self.down_child 	= self.down_node:getChildByName("down_child")

	self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	self.baseBg 		= self.bgRoot:getChildByName("bg_base")
	self.freeBg 		= self.bgRoot:getChildByName("bg_free")
	self.bonusBg        = self.bgRoot:getChildByName("bg_bonus")	
	self.baseBg:setVisible(true)
	self.curBg = self.baseBg
	self.freeBg:setVisible(false)
	self.bonusBg:setVisible(false)
	
	self.reelRoot 		= self.down_child:getChildByName("reel_root_node")
	self.boardRoot 		= self.down_child:getChildByName("board_root")
	self.animateNode 	= self.down_child:getChildByName("anim_panel"):getChildByName("animate_node")
	self.specailAnimationNode = self.down_child:getChildByName("specail_panel"):getChildByName("animate_node") -- 特殊的激励动画
	self.scatterAnimNode = self.down_child:getChildByName("scatter_anim_node")

	self.down_child:getChildByName("anim_panel"):setTouchEnabled(false)
	self.down_child:getChildByName("specail_panel"):setTouchEnabled(false)

	self.reelRootNode = self.down_child:getChildByName('reel_root_node')
	self.themeFloorNode = self.reelRootNode:getChildByName('theme_floor_5')
	--  初始化 freegame stickyWild
	self.stickyAnimate 	= self.down_child:getChildByName("sticky_animate")
	self.randAnimate  	= self.down_child:getChildByName("rand_animate")
	self.stickyMask 	= self.down_child:getChildByName("wild_mask_node")
	self.stickyMask:setOpacity(0)

	-- self.bonusRespinNode = 

	-- 初始化jackpot
	self.progressiveRoot = self.down_child:getChildByName("progressive")
	local progressive_nodes = self.progressiveRoot:getChildByName("jackpots_labels")-- 初始化jackpot
	self.jackpotLabels = {}
	for i=1,5 do	
		self.jackpotLabels[i] = progressive_nodes:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	end
	self:initialJackpotNode()
	-- base 背景 动画
	self.HoldLayer 	= self.down_child:getChildByName("hold_node")


	-- 广告牌
	self.tipNode = self.down_child:getChildByName('tip_node')

	self.tipNode_5 = self.tipNode:getChildByName('node_5')
	self.tipNode_6 = self.tipNode:getChildByName('node_6')

	local _, s = self:addSpineAnimation(self.tipNode, nil, self:getPic("spine/adTip/spine"), cc.p(0,0), 'animation3', nil, nil, nil, true)
	self.tipNodeSpine = s
	self.tipNodeFive = true

	-- 初始化 feature_node
	self.featureNode 	= self.down_child:getChildByName("feature_node")
	self.superCntNodes 	= self.featureNode:getChildByName("bg_gree")
	self.superMan       = self.featureNode:getChildByName('super_man')
	self.featureAnimation = self.featureNode:getChildByName('animation')
	self.featureTipNode = self.down_child:getChildByName("feature_tip")
	self.featureTipBtn 	= self.down_child:getChildByName("feature_btn")
	self.featureTipNode:setVisible(false)
	self.superMan:setVisible(false)



	local _, s = self:addSpineAnimation(self.superMan, nil, self:getPic("spine/man/spine"), cc.p(0,0), 'animation3', nil, nil, nil, true)
	self.superManSpine = s




	self:initTipEvent() -- 不需要 提示功能
	self:initFeatureMan()
	self:initFeatureFloor()

	self.lockFeatureNode = self.down_child:getChildByName('lock_feature_node')
	local _, s = self:addSpineAnimation(self.lockFeatureNode, nil, self:getPic("spine/jiesuo/spine"), cc.p(-5,204), "animation2", nil, nil, nil, true)
	self.lockSuperSpine = s
	self.isLockFeature 	= true

	self.lockTopNode = self.down_child:getChildByName('lockTop_node')
	

	-- fg 中特别展示的图片
	self.fgInfoNode = self.down_child:getChildByName('super_fg')
	self.megaInfoNode = self.fgInfoNode:getChildByName('megainfo')
	self.superInfoNode = self.fgInfoNode:getChildByName('superinfo')
	self.fgInfoNode:setVisible(false)
	
	-- spin 计数  有效
	self.respinCntNode = self.down_child:getChildByName("spin_cnt_node")
	self.respinCurLabel = self.respinCntNode:getChildByName("spin_cnt")
	self.respinSumLabel = self.respinCntNode:getChildByName('spin_sum')
	self.respinCntNode:setVisible(false)

	-- respin 总金额  有效
	self.startPrizeNode = self.mainThemeScene:getChildByName('start_prize')
	self.startPrizeNum  = self.startPrizeNode:getChildByName('jp_label')
	local function parseValue( num)
		return FONTS.format(num, true)
	end
	inherit(self.startPrizeNum, LabelNumRoll)
	-- 对num做出限制

	self.startPrizeNum:nrInit(0, 24, parseValue)
	self.startPrizeNum:setString('')
	self.startPrizeNode:setVisible(false)
	self.startPrizeNum:setLocalZOrder(10)

	local _, s = self:addSpineAnimation(self.startPrizeNode, 2, self:getPic("spine/banzi/spine"), cc.p(0,0), "animation2", nil, nil, nil, true)
	self.startPrizeSpine = s

	self.shakyNode:addChild(self.mainThemeScene)
end

function cls:getJPLabelMaxWidth(index)
	local jackpotLabelMaxWidth = {230,150,150,150, 150}
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:initSpinLayerBg( )
	Theme.initSpinLayerBg(self)
	self:checkLockFeature()
	self:updateFeatureCnt()
	self:setTip()
	--
end

function cls:setTip( )
	local bet = self.ctl:getCurTotalBet()
	if not self.tipNodeSpine then return end

	if bet>=self.featureEnableBetList[2] and not self.tipNodeFive then
		self.tipNodeFive = true

		bole.spChangeAnimation(self.tipNodeSpine,"animation2",false)
		self.tipNodeSpine:stopAllActions()
		self.tipNodeSpine:runAction(cc.Sequence:create(
		cc.DelayTime:create(21/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(self.tipNodeSpine,"animation3",true)
		end)))

		self:playMusic(self.audio_list.change)
	elseif bet<self.featureEnableBetList[2] and self.tipNodeFive then 
		self.tipNodeFive = false

		bole.spChangeAnimation(self.tipNodeSpine,"animation1",false)
		self.tipNodeSpine:stopAllActions()
		self.tipNodeSpine:runAction(cc.Sequence:create(
		cc.DelayTime:create(21/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(self.tipNodeSpine,"animation4",true)
		end)))

		self:playMusic(self.audio_list.change)
	end
	
end

function cls:checkLockFeature( ) -- 1是循环, 2是解锁, 3是锁上; 屏幕中心; 解锁26帧, 锁上10帧 
	
	if not self.featureEnableBetList[1] or not self.lockSuperSpine then return end
	local bet = bet or self.ctl:getCurTotalBet()
	if self.showFreeSpinBoard then return end

	if bet >= self.featureEnableBetList[1] and self.isLockFeature then -- 播放解锁动画
		self.isLockFeature = false
		self:playMusic(self.audio_list.unlock)
		self.lockSuperSpine:stopAllActions()
		bole.spChangeAnimation(self.lockSuperSpine,"animation1",false)
	elseif bet < self.featureEnableBetList[1] and not self.isLockFeature then -- 播放锁定动画
		self.isLockFeature = true
		self:playMusic(self.audio_list.lock)
		bole.spChangeAnimation(self.lockSuperSpine,"animation2",false)
		self.lockSuperSpine:stopAllActions()
		self.lockSuperSpine:runAction(cc.Sequence:create(
		cc.DelayTime:create(15/30),
		cc.CallFunc:create(function ( ... )
		-- 	bole.spChangeAnimation(self.lockSuperSpine,"animation3",true)
		end)))
	end
end

function cls:initSpinLayer( )
	self.spinLayerList = {}
	for index,cofig in ipairs(self.boardNodeList) do
		self.initBoardIndex = index
		local boardNode = self.boardNodeList[index]
		local layer = SpinLayer.new(self, self.ctl,boardNode.reelConfig,boardNode)
		layer:DeActive()
		self.shakyNode:addChild(layer,-1)
		table.insert(self.spinLayerList,layer)
	end
	self.initBoardIndex = nil
	self.spinLayer = self.spinLayerList[1]
	self.spinLayer:Active()
end

function cls:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"grand", "maxi", "major", "minor", "mini"},
		allowK = {[138] = false, [638] = false, [1138] = false}
	}
	return jackpot_config_list
end

function cls:initTipEvent()
	-- 点击按钮
	local function onTouch(obj, eventType)
		if not self.showBaseSpinBoard then return end
		if eventType == ccui.TouchEventType.ended then
		 	self:tipBtnOnTouch()
		end
	end
	-- 设置按钮
	self.featureTipBtn:addTouchEventListener(onTouch)
end

function cls:tipBtnOnTouch(toClose)
	if self.isLockFeature then
		self:setBet()
		self:checkLockFeature()
	else
		if (not self.curTipShow) and (not toClose) then 
 			self.featureTipNode:stopAllActions()
 			self.featureTipNode:runAction(cc.Sequence:create(
 				cc.CallFunc:create(function ( ... )
	 				self.featureTipNode:setVisible(true)
	 				self.featureTipNode:setOpacity(0)
	 			end),
	 			cc.DelayTime:create(0),
	 			cc.FadeTo:create(0.5,255),
	 			cc.DelayTime:create(5),
	 			cc.FadeTo:create(0.5,0),
 				cc.CallFunc:create(function ( ... )
	 				self.featureTipNode:setVisible(false)
	 				self.curTipShow = false
	 			end)))
 			self.curTipShow = true
 		else
 			self.featureTipNode:stopAllActions()
 			self.featureTipNode:runAction(cc.Sequence:create(
 				cc.FadeTo:create(0.5,0),
 				cc.CallFunc:create(function ( ... )
		 			self.featureTipNode:setVisible(false)
		 		end)))
 			self.curTipShow = false
 		end	
	end
end

function cls:initFeatureMan()
	if self.superInfoData and self.superInfoData.super_level > 0 then 
		local pos = self:getSuperManPos()
		self.superMan:setVisible(true)
		self.superMan:setPosition(cc.p(pos.x, 206))
	else
		self.superMan:setVisible(false)
		self.superMan:setPosition(cc.p(featureBonuPos[1].x, 206))	
	end
end

function cls:getCurrentLevel( ... )
	local level = 0
	if self.superInfoData and self.superInfoData.super_level > 0 then 
		level = self.superInfoData.super_level
	end
	return level
end

function cls:getSuperManPos( ... )
	local _level = self.superInfoData.super_level
	local remainder = _level > 8 and 2 or math.floor(_level/4)
	remainder = _level == 16 and 3 or remainder

	if superBonusSet[remainder] and superBonusSet[remainder] == _level then
		pos = cc.p(superBonusPos[remainder].x, 206)
	else
		pos = cc.p(featureBonuPos[_level - remainder].x, 206)
	end
	return pos
end

function cls:initFeatureFloor()
	if self.superCntNodes then
		for k = 1, 13 do
			local greenPng = bole.createSpriteWithFile("#theme138_base_green.png")
			self.superCntNodes:addChild(greenPng)
			greenPng:setPosition(featureBonuPos[k])
		end
		self.superCntNodesChild = self.superCntNodes:getChildren()
	end
end

local addSuperSpineData = {
	[1] = {
		['pos'] = cc.p(-245, 212), 
		-- ['pos'] = cc.p(-235 + 15, 202 + 5), 
		['animateName'] = 'animation1',
		['musicName'] = 'man_hill',
		['path'] = 'spine/jinshan/js',
		['delay'] = 30/30,
	},
	[2] = {
		['pos'] = cc.p(-31, 212),
		['animateName'] = 'animation1',
		['musicName'] = 'man_hill',
		['path'] = 'spine/jinshan/js',
		['delay'] = 30/30,
	},
	[3] = {
		['pos'] = cc.p(366, 214),
		['animateName'] = 'animation2',
		['musicName'] = 'man_hill',
		['path'] = 'spine/jinshan/js',
		['delay'] = 30/30,
	},
	[4] = {
		['pos'] = cc.p(-8, 245),
		['animateName'] = 'animation',
		['musicName'] = 'man_full',
		['path'] = 'spine/full/spine',
		['delay'] = 60/30,
	},
}

function cls:updateFeatureCnt(needAnimate)
	if not (self.superInfoData and self.superInfoData.super_level) then return end
	if self.curFeatureLevel and self.curFeatureLevel == self.superInfoData.super_level then return end
	if not self.superCntNodesChild then return end

	local theCellFile = '#theme138_base_red.png'
	local greenFile   = '#theme138_base_green.png'
	local _level = self.superInfoData.super_level

	local delay = needAnimate and 0.5 or 0

	if needAnimate then
		local nowPos = self.superMan:getPositionX()
		local endPos = self:getSuperManPos()
		local moveSize = endPos.x - nowPos

		self.superMan:setVisible(true)
		self.superMan:runAction(cc.MoveBy:create(delay, cc.p(moveSize, 0)))	
		-- cc.MoveBy:create(1, cc.p(moveSize,0)),

		if _level == 1 then
			self:playMusic(self.audio_list.man_show)	
			-- self.superManSpine
			bole.spChangeAnimation(self.superManSpine,"animation1",false)
		else
			self:playMusic(self.audio_list.man_move)	
			bole.spChangeAnimation(self.superManSpine,"animation2",false)
		end

		self.superManSpine:runAction(cc.Sequence:create(
		cc.DelayTime:create(15/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(self.superManSpine,"animation3",true)
		end)))

	else
		self:initFeatureMan()		
	end

	local remainder = _level > 8 and 3 or math.floor(_level/4)
	local level = _level - remainder

	self:laterCallBack(delay,function ( ... )
		for k,v in pairs(self.superCntNodesChild) do 
			--  需要判断当前是不是超过4个
			if k <= level then
				bole.updateSpriteWithFile(v, theCellFile)
			else
				bole.updateSpriteWithFile(v, greenFile)
			end
		end
	end)

	if needAnimate and superBonusSet[remainder] and superBonusSet[remainder] == _level and self.featureAnimation then
		local data = addSuperSpineData[remainder] or nil
		local delay = 0
		self.featureAnimation:removeAllChildren()
		if data then
			self:playMusic(data.musicName)
			local _,s = self:addSpineAnimation(self.featureAnimation, 20, self:getPic(data.path), data.pos, data.animateName, nil, nil, nil, true)
			self.featureAnimation:runAction(
				cc.Sequence:create(
					cc.DelayTime:create(data.delay),
					cc.CallFunc:create(function ( ... )
						if remainder == 3 then
							self.featureAnimation:removeAllChildren()
							data = addSuperSpineData[4]
							delay = data.delay
							self:addSpineAnimation(self.featureAnimation, 20, self:getPic(data.path), data.pos, data.animateName, nil, nil, nil, true)
						end
					end),	
					cc.DelayTime:create(delay+1),
					cc.CallFunc:create(function ( ... )
						self.featureAnimation:removeAllChildren()
					end)))
		end
	end
	self.curFeatureLevel = self.superInfoData.super_level -- 刷新计数
end

function cls:playCellRoundEffect(parent, ...) -- 播放中奖连线框
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function cls:enterFreeSpin( isResume ) -- 更改背景图片 和棋盘
	if isResume then  -- 断线重连的逻辑
		self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐

		self:setStickyWildSymbol(self.enterThemeSWPos,isResume)
		self.enterThemeSWPos = nil
	end
	self:showAllItem()
	self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:showFreeSpinNode( count, sumCount, first)
	Theme.showFreeSpinNode(self,count, sumCount, first)
	self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类型

	self.featureNode:setVisible(false)
	-- self:dealMusic_PlayFreeSpinLoopMusic()
end

function cls:hideFreeSpinNode( ... ) -- 逻辑是个啥

	if self.isSuper then
		self.isSuper = false
		self.superBet = nil
		self.superInfoData = self.superInfoData or {}
		if self.superInfoData.super_level == superBonusSet[3] then 
			self.superInfoData.super_level = 0
			self:updateFeatureCnt()
		end
		self.ctl.footer:changeNormalLayout2()
	end
	
	self.curStickyWildList = nil
	self.stickyWildSList = nil

	self.stickyAnimate:removeAllChildren()

	self.featureNode:setVisible(true)

	-- self:checkLockFeature()
	self:lockTopBar()

	self:changeSpinBoard(SpinBoardType.Normal)

	Theme.hideFreeSpinNode(self, ...)
end

function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
	if theCellNode.symbolTipAnim then 
		if (not tolua.isnull(theCellNode.symbolTipAnim)) then 
			theCellNode.symbolTipAnim:removeFromParent()
		end
		theCellNode.symbolTipAnim = nil 
	end
end


function cls:newJackpotLabel(isBonus2) -- 第一个参数：用来判断否是刷新倍数的，第二个参数用来判断是否显示的是高级的颜色，第一个参数的优先级高
	local file = self:getPic("font/theme138_fg_n.fnt")
	if isBonus2 then
		file = self:getPic("font/theme138_fg_nz.fnt")
	end
	local fntLabel = NumberFont.new(file, nil, true)
	function fntLabel:setString(n)
        -- 控制显示文字 带k,m 同时保留3位有效数字
        if n == "" then
            self.font:setString("")
        elseif type(n) == "number" then
            local ss = FONTS.format(n, false, false)
            if n < 1000 then
                ss = FONTS.format(n, true)
            else
                local len = string.len(string.match(ss, "%d+"))
                if len == 3 then
                    ss = string.match(ss, "%d+") .. string.match(ss, "[^$0-9%.]")
                elseif len == 2 then
                    if string.match(ss, "%.") then
                        ss = string.match(ss, "%d+..") .. string.match(ss, "[^$0-9%.]")
                    else
                        ss = string.match(ss, "%d+") .. string.match(ss, "[^$0-9%.]")
                    end
                elseif len == 1 then
                    if string.match(ss, "%.") then
                        ss = string.match(ss, "%d+..") .. string.match(ss, "[^$0-9%.]")
                    else
                        ss = string.match(ss, "%d+") .. string.match(ss, "[^$0-9%.]")
                    end
                end
            end
            self.font:setString(ss)
        else
            ss = n
            self.font:setString(n)
        end
        return ss
    end
    return fntLabel
end

function cls:getJackpotNum(key) 
	if jackpotBet[key] and key <= 36 then --24 H
		if self.isSuper then
			return self.superBet and self.superBet*jackpotBet[key] or self.ctl:getCurTotalBet()*jackpotBet[key]
		else
			return self.ctl:getCurTotalBet()*jackpotBet[key]	
		end
	elseif key == 39 or key == 'bonus2' then
		return self.poolCoin or 0
	end
end

function cls:createCellSprite(key, col, rowIndex)

	if key == 'bonus2' then
		key = math.random(2,5)
	end

	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key

	self.initialPics = self.initialPics or {}
	if self.specialItemConfig[key] then
		local colSet = self.specialItemConfig[key]["col_set"] or {}
		if colSet[col] then
			if colSet[col] == 0 then
				key = self:getNormalKey(col)
			elseif colSet[col] == 1 then
				if self.initialPics[col] then
					key = self:getNormalKey(col)
				else
					self.initialPics[col] = true
				end
			end
		end
	end
	------------------------------------------------------------
	local theCellFile = self.pics[key]


	if jackpotBet[key] then
		theCellFile = self.pics[14]
	end

	local theCellNode   = cc.Node:create()
	

	local theCellSprite = bole.createSpriteWithFile(theCellFile)

	theCellNode:addChild(theCellSprite)

	-- 在respin 中处理成黑色的symbol
	if self.initBoardIndex == 2 and not jackpotBet[key] then
		key = math.floor(math.random(1,10))  
		theCellFile = self.pics[key]
		theCellSprite:setColor(cc.c3b(80,80,80))
	end

	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0
	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	end

	local ret = theCellNode 
	if jackpotBet[key] then
		local num = nil
		num = math.random(20,36)
		ret.font = self:newJackpotLabel(false,true)
		ret:addChild(ret.font, 100)
		ret.font:setPosition(cc.p(0,0)) 
		ret.font:setString(self:getJackpotNum(key))
		ret.font:setScale(fontScale)
	end


	ret.jackpot = cc.Sprite:create()
	local cellSize = self.spinLayer:getCellSize(col)
	ret.jackpot:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
	ret.sprite:addChild(ret.jackpot)

	return ret
end

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
	if key == 'bonus2' or key == 39 then
		key = self.showReSpinBoard and 39 or math.random(2,5)
	end
	
	if theCellNode.font and bole.isValidNode(theCellNode.font) then
		theCellNode.font:removeFromParent()
		theCellNode.font = nil
	end

	-- 特殊symbol添加金币
	local jackpotNum = 0
	theCellNode.jackpot:setTexture("commonpics/kong.png")
	theCellNode.jackpot.key = nil
	theCellNode.jackpot:removeAllChildren() -- 作用删除掉 cell 上面X2 X3 的 图

	
	if jackpotBet[key] then
		local mul = jackpotBet[key]
		if type(mul) == 'string' then
			bole.updateSpriteWithFile(theCellNode.jackpot,"#theme108_m"..(key-40)..".png")
			theCellNode.jackpot.key = key
		else
			theCellNode.font = self:newJackpotLabel()
		  	theCellNode:addChild(theCellNode.font, 100)
		  	theCellNode.font:setPosition(cc.p(0,0)) -- 171 145 是圆盘尺寸的大小
		  	jackpotNum = self:getJackpotNum(key)
		  	theCellNode.font:setString(jackpotNum)
		  	theCellNode.font:setScale(fontScale)
		  	-- theCellNode.font:setScale(0.6)
		end
		if (theCellNode.font and self.showReSpinBoard and key == 39) or (self.lockedReels and self.lockedReels[col] and theCellNode.font) then
			theCellNode.font:setVisible(false)
		end

		if self.lockedReels and self.lockedReels[col] and theCellNode.jackpot and type(mul) == 'string' then
			theCellNode.jackpot.key = nil
			theCellNode.jackpot:setTexture("commonpics/kong.png")
		end
	end

	local theCellFile = self.pics[key]

	if self.showReSpinBoard then  -- respin 的情况下除jp外的其他的symbol全部为黑色
		if not jackpotBet[key] then 
			theCellNode.sprite:setColor(cc.c3b(80,80,80))
			-- 随机设置图片
			if self.showFreeSpinBoard then
				key = math.floor(math.random(1,5))  
			else
				key = math.floor(math.random(1,10))  	
			end
			theCellFile = self.pics[key]
		elseif self.lockedReels and self.lockedReels[col] then
			theCellFile = self.pics['nil']
		elseif jackpotBet[key] then
			theCellFile = key == 39 and self.pics['bonus2'] or self.pics[14]
			theCellNode.sprite:setColor(cc.c3b(255,255,255))
		end
	else
		theCellNode.sprite:setColor(cc.c3b(255,255,255))
		if jackpotBet[key] then
			theCellFile = self.pics[14]
		end	
	end

	if key == 0 then
		key = math.floor(math.random(1, 5)) 
		theCellFile = self.pics[key]
	end
	
	
	if not theCellFile then 
	end

	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
end



function cls:adjustEnterThemeRet(data)
	data.theme_reels = {
		["main_reel"] = {
			[1] = {8,2,4,9,21,2,3,5,7,6,5,10,4,5,9,8,10,9,5,10,9,4,5,9,22,6,7,10,8,1,4,2,7,1,8,11,6,23,7,8,5,3,4,5,9,8,1,7,10,24,8,11,7,6,8,1,2,3,3,7,9,25,3,9,7,4,5,6,2,5,1,2,26,4,5,6,7,6,11,1,27},
			[2] = {9,2,21,2,3,9,2,7,13,9,10,4,5,6,10,7,1,3,4,8,4,5,4,7,22,1,3,9,23,10,4,8,9,24,11,4,5,9,7,13,10,6,1,2,3,11,6,10,8,25,5,6,6,10,1,1,2,3,10,5,7,4,5,8,9,3,4,5,9,26,13,4,10,5,4,5,11,9,27,6,8,4,5},
			[3] = {11,5,9,8,21,2,3,9,4,13,6,10,2,1,22,3,10,1,9,1,7,23,4,5,2,7,2,8,9,7,3,5,24,7,10,2,8,4,25,9,7,13,8,10,4,5,8,11,2,9,26,4,5,5,9,1,27,1,2,3,7,1,6,5,2,6,10,4,5,6,3,13,4,11,10,9,4,5,10,9,6,6,2,7},
			[4] = {9,13,8,7,10,21,2,3,9,5,11,8,9,4,5,7,23,8,6,1,9,6,4,5,6,3,22,8,4,9,3,10,24,7,6,13,2,7,4,25,10,8,13,26,9,4,5,5,1,9,27,4,4,5,6,8,2,10,1,2,3,9,10,7,5,6,11,10,4,5,10,8,1,11,10,5,4,5,10,7,6,1,8,7,7,6,9,2,10,6},
			[5] = {9,10,6,21,2,3,9,7,6,1,10,4,5,23,6,7,4,5,10,5,24,5,8,5,1,6,11,9,22,4,3,8,1,9,4,4,25,10,7,4,8,5,10,7,6,6,8,5,4,5,7,9,11,6,1,2,3,2,3,10,4,5,6,8,11,7},
		},
		["free_reel"] = {
			[1] = {5,4,21,2,1,5,22,3,1,4,5,23,5,4,1,1,3,2,2,3,2,5,3,4,1,5,5,11,1,2,2},
			[2] = {4,21,2,5,3,4,4,1,5,3,1,22,3,1,3,4,2,4,5,2,1,5,2,11,23,13,5,4,4,5,3},
			[3] = {11,21,2,4,3,1,4,2,5,3,1,22,2,1,3,2,5,4,5,5,2,23,1,5,2,13,2,4,3,4,1,2},
			[4] = {3,21,2,2,3,5,4,2,5,11,1,1,4,5,22,1,5,3,4,3,2,1,5,5,1,13,2,4,2,23,1},
			[5] = {5,21,2,2,5,3,4,3,4,5,1,5,1,5,22,2,1,3,5,4,4,5,11,23},
		},
	}

	self.featureEnableBetList = data.bonus_level

	if data.theme_info.super_info then -- "theme_info": { "super_level": 1 } -- "super_info": { "wager_count": 25, "wager": 250000, "super_level": 1 }
		self.superInfoData = data.theme_info.super_info
	end

	if data.theme_info and data.theme_info.wild_pos then
		self.enterThemeSWPos = data.theme_info.wild_pos and tool.tableClone(data.theme_info.wild_pos) or {}
	end
	 


	if data["map_info"] then
	  	self.mapPoints = data["map_info"]["map_points"]
	    self.mapLevel = data["map_info"]["map_level"]

	    self.map_avg_bet = data["map_info"]["avg_bet"]

	end

	if data["free_game"] then
		self.freeSpinType = data["free_game"]['super_type']
		self.isSuper      = self.freeSpinType > 0 and true or false
		self.superBet     = self.superInfoData and self.superInfoData.super_bet
	end

	if data["free_game"] then
		-- if data.fg_wild_pos then -- free 断线重连数据 控制
		-- 	self.fgWildPos = tool.tableClone(data.fg_wild_pos) -- "final_wild_pos": [ [ 4, 2 ], [ 3, 3 ], [ 5, 3 ] ]
		-- end
		if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
    		self.freeType = data["free_game"]["fg_type"]
    		self.wildCount = data["free_game"]["wild_count"]
		   	if data["bonus_game"] and data["bonus_game"]["type"] and data["bonus_game"]["type"] == BonusGameType.wheel then 
    			data["first_free_game"] = {}

    			data["first_free_game"]["free_spins"] 		= data["free_game"]["free_spins"]
 				data["first_free_game"]["free_spin_total"] 	= data["free_game"]["free_spin_total"]
 				data["first_free_game"]["base_win"] 		= data["free_game"]["base_win"]
 				data["first_free_game"]["total_win"] 		= data["free_game"]["total_win"]
 				data["first_free_game"]["bet"] 				= data["free_game"]["bet"]
 				data["first_free_game"]["item_list"] 		= data["free_game"]["item_list"]
 				data["first_free_game"]["fg_type"] 			= data["free_game"]["fg_type"]
				data["first_free_game"]["wild_count"]		= data["free_game"]["wild_count"]
				
 				data["free_game"] = nil
    		end
		end
    end

	return data
end

function cls:adjustTheme(data)
	if data.free_spins then
		self:changeSpinBoard(SpinBoardType.FreeSpin) 
		self.ctl.freeItem = table.copy(self.recvItemList)
	elseif data.bonus_game then 
		self.dontR0 = true
		-- self:changeSpinBoard(SpinBoardType.ReSpin)
		local data = LoginControl:getInstance():getBonus(self.themeid) or {}-- 获得 bonus 本地数据 进行判断是否要显示 respin 场景
		if not data.end_game then
			self:changeSpinBoard(SpinBoardType.ReSpin)
		else
			self:changeSpinBoard(SpinBoardType.Normal)
		end
	else
		self:changeSpinBoard(SpinBoardType.Normal)
	end

end

---------------------------

---------------------------------- spin cnt 相关 ----------------------------------
function cls:topFresh(cntData, addNum, needAnim)
	
end

function cls:setBet() 
	if self.featureEnableBetList and self.featureEnableBetList[1] then
		local set_Bet = self.featureEnableBetList[1]
		self.ctl:setCurBet(set_Bet)
	end
end

function cls:changeWildPos(list, getAnimPos, isChangeBet)
	
end

function cls:refreshDiskData(data)
	
end

function cls:getCurDiskData(Bet)
	
end


-- 修改 floor 背景 --
function cls:changeFloorBg( inRespin )
	-- 修改背景
	if not self.themeFloorNode then return end
	local allChild = self.themeFloorNode:getChildren()

	if inRespin then
		for key, val in ipairs(allChild) do
			bole.updateSpriteWithFile(val, FloorBgPng.inRespin)
		end
	else
		for key, val in ipairs(allChild) do
			bole.updateSpriteWithFile(val, FloorBgPng.normal)
		end
	end

end

-- 锁住 top 栏 --
function cls:lockTopBar( flag )
	if not self.lockSuperSpine then return end
	if flag then
		bole.spChangeAnimation(self.lockSuperSpine,"animation4",true)
	else
		if self.isLockFeature then
			bole.spChangeAnimation(self.lockSuperSpine,"animation2",false)
		else
			bole.spChangeAnimation(self.lockSuperSpine,"animation1",false)	
		end	
	end

end

--------------------------------------------------------------------------------
function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
	self:clearAnimate()
	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		self:changeFloorBg()
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = true
		self.showReSpinBoard = false

		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end
		-- self.collectFeatureNode:setVisible(true)
		-- self.freeNode:setVisible(false)
		self:lockTopBar()
		-- self.featureTipBtn:setTouchEnabled(true)
		self:enableFeaturetipBtn(true)

		self.randAnimate:setVisible(false)
		self.stickyAnimate:setVisible(false)
		self.fgInfoNode:setVisible(false)

		if self.curBg ~= self.baseBg then 
			self.curBg:setVisible(false)
			self.baseBg:setVisible(true)
			self.curBg = self.baseBg
		end
	elseif pType == SpinBoardType.FreeSpin then
		self:changeFloorBg()
		self.showFreeSpinBoard = true
		self.showBaseSpinBoard = false
		self.showReSpinBoard = false

		self:lockTopBar(true)
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end
		-- self.collectFeatureNode:setVisible(false)
		-- self.featureTipBtn:setTouchEnabled(false)
		self.fgInfoNode:setVisible(false)

		if self.isSuper then
			local _level = self:getCurrentLevel()
			self.fgInfoNode:setVisible(true)
			self.megaInfoNode:setVisible(_level == superBonusSet[1] or _level == superBonusSet[2])
			self.superInfoNode:setVisible( _level == superBonusSet[3])

			self.randAnimate:setVisible(true)
			self.stickyAnimate:setVisible(true)
			if self.superBet then 
				self.ctl:setPointBet(self.superBet)-- 更改 锁定的bet
			end
			self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet 
		else

			self.ctl.footer:changeFreeSpinLayout()	
		end

		if self.curBg ~= self.freeBg then 
			self.curBg:setVisible(false)
			self.freeBg:setVisible(true)
			self.curBg = self.freeBg
		end
	elseif pType == SpinBoardType.ReSpin then
		if self.showReSpinBoard then return end
		self.lockedReels = {}
		self.HoldLayer._added = {}
		self.fgInfoNode:setVisible(false)

		self:lockTopBar(true)

		self.showReSpinBoard = true
		-- 将所有的都隐藏
		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[2]
		self.spinLayer:Active()
	end
	-- self:playReelNotifyEffect(3)
end

---------------------------------- spin 相关 ----------------s--------
function cls:addSpecialSpeed(specialTag)
	
	local themetype = 1
	-- 播放龙的动画 暂时放在动画层上面 播放
	local size = self.specailAnimationNode:getContentSize()
	local pos = cc.p(640, 360)-- 位置需要调整
	local spineFile   = self:getPic("spine/special/spine")

	-- self:changeWildShow(false)
	self:playMusic(self.audio_list.special_luck)

	local _, s1 = self:addSpineAnimation(self.specailAnimationNode, 200, spineFile, pos, "animation")	-- -1

	-- self:laterCallBack(42/30, function ( ... )
	-- 	self:playMusic(self.audio_list.special_luck)
	-- end)

	-- 关闭
end

function cls:changeWildShow(flag)
	if self.randAnimate then
		self.randAnimate:setVisible(flag)
	end
	
	if self.stickyAnimate then
		self.stickyAnimate:setVisible(flag)
	end
end

-- @ Featuretip是否可以点击
function cls:enableFeaturetipBtn( enable )
	self.featureTipBtn:setTouchEnabled( enable )
end

function cls:onSpinStart()
	self.DelayStopTime = 0
	-- if self.showBaseSpinBoard then
	-- 	if self.isLocked then
	-- 		self.btn_unLock:setTouchEnabled(false)
	-- 	end
	-- end
	self:enableFeaturetipBtn(false)
	Theme.onSpinStart(self)
end

function cls:onSpinStop(ret)
	if ret.free_spins and (not self.ctl.freewin) then
		if ret.free_game then 
			self.wildCount = ret.free_game.wild_count
			self.freeType = ret.free_game.fg_type
		end
	end
	self:fixRet(ret)
	Theme.onSpinStop(self, ret)
end

function cls:onRespinStart()
	self.DelayStopTime = 0
	self.bonus:onRespinStart()
	
	Theme.onRespinStart(self)
	self:cleanSpecialSymbolState()

	local newCount = bole.getTableCount(self.HoldLayer._added)
end

function cls:onRespinStop(ret)
	self.dontR0 = false
	self:fixRet(ret)

	if #ret["theme_respin"] == 0 then
		self.respinStep = ReSpinStep.Over
		ret.theme_deal_show = true
		
	end
	Theme.onRespinStop(self, ret)
end

function cls:theme_deal_show(ret)
	ret.theme_deal_show = nil
	if self.respinStep == ReSpinStep.Over then
		self.respinToSymbol = self.respinToSymbol or {}
		local specailNum = (#self.respinToSymbol > 0) and #self.respinToSymbol or 0
		local delay = specailNum * 51/60
		if specailNum > 0 then
			self:addCoinToSymbol()
		end

		self:laterCallBack(delay, function ( ... )
			self.bonus:onRespinStop(ret)
		end)

	end
end

function cls:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果
	-- if self.respinStep == ReSpinStep.Start then
	-- 	ret.theme_deal_show = true
	-- end

	if self.respinStep == ReSpinStep.Playing then 
		self.ctl.resultCache = {}	-- ret["reelItem_list"] = {} -- 添加

		local itemsList = table.copy(ret.item_list)

		for i=0,14 do -- 横向拆分 和 棋盘一致
			ret.item_list[1+i] = {itemsList[1+(i%5)][1+math.floor(i/5)]}
			-- 在每一轴 拼接结果数据
			self.ctl.resultCache[1+i] = {math.random(1,10),itemsList[1+(i%5)][1+math.floor(i/5)]} --向上插入一个值 {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}-- ret["reelItem_list"][1+i] = {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}
			local col = 1+ (i-1)%5
			local symbols = self.ctl.currentReels[col] -- 获得 1-5 轴的 滚轴数据
			
			local key = math.random(2,#symbols)
			local extraCount = 6
			if self.isTurbo then
				extraCount = 3
			end
			for k = 1,extraCount do -- 向下插入 六个 值
				key = 1 + (key + k - 1)%#symbols
				table.insert(self.ctl.resultCache[1+i],symbols[key])
			end
		end
	end

	self.recvItemList = ret.item_list

	self.JHint = {}
end

--------------------------Start--------------------------
-----------------------多棋盘 相关属性----------------------

function cls:stopControl( stopRet, stopCallFun )
	if stopRet["bonus_level"] then
		self.featureEnableBetList = stopRet["bonus_level"]
		-- self.lockFeatrueData = tool.tableClone(stopRet.bonus_level)
	end 

	if stopRet["theme_info"] and stopRet["theme_info"]["wild_pos"] and FreeSpinType.super == self.freeSpinType then --进行添加小wild的操作 
		self:setStickyWildSymbol(stopRet["theme_info"]["wild_pos"])
	end
	if stopRet["theme_info"] and stopRet["theme_info"]["wild_pos"] and FreeSpinType.mega == self.freeSpinType then --进行添加小wild的操作 
		self:setRandWildSymbol(stopRet["theme_info"]["wild_pos"])
	end

	if self.haveSpecialdelay then 
		self:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(self.speicalDelay),
				cc.CallFunc:create(function ( ... )
					stopCallFun()
				end)))
	else
		stopCallFun()
	end
end

function cls:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function cls:getSpinConfig( spinTag )
	local spinConfig = {}
	if self.showReSpinBoard then
		for i=0, 14 do
			local col = i+1
			local tempCol = i%5+1
			local theStartAction = self:getSpinColStartAction(tempCol,col)
			local theReelConfig = {
				["col"]     = col,
				["action"]  = theStartAction,
			}
			table.insert(spinConfig, theReelConfig)
		end		
		return spinConfig
	else
		for col,_ in pairs(self.spinLayer.spins) do
			local theStartAction = self:getSpinColStartAction(col)
			local theReelConfig = {
				["col"]     = col,
				["action"]  = theStartAction,
			}
			table.insert(spinConfig, theReelConfig)
		end	
		return spinConfig
	end
end

function cls:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}
	if self.showReSpinBoard then
		for i=0, 14 do
			local col = i+1
			local tempCol = i%5+1
			local theAction = self:getSpinColStopAction(ret["theme_info"], tempCol,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	else 
		local stopColOrderList = {}
		for i=1, 5 do
			table.insert(stopColOrderList, i)
		end	
		for index,col in pairs(stopColOrderList) do
			local theAction = self:getSpinColStopAction(ret["theme_info"], col,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	end
	return stopConfig
end


function cls:genSpecials( pWinPosList )
	local specials 	 = {[specialSymbol["triger"]]={}}
	local itemList   = self.ctl:getRetMatrix()
	local winPosList = pWinPosList or self.ctl:getWinPosList()
	local winTagList = {}
	for _,crPos in pairs(winPosList) do
		winTagList[crPos[1]]    	   = winTagList[crPos[1]] or {}
		winTagList[crPos[1]][crPos[2]] = true
	end
	if itemList and winPosList then
		for col,colItemList in pairs(itemList) do
			for row,theKey in pairs(colItemList) do
				if theKey==specialSymbol["triger"] then
					specials[theKey][col] 	   	= specials[theKey][col] or {}
					specials[theKey][col][row] 	= true
				end
			end
		end
	end
	self.ctl.specials = specials	
end

function cls:genSpecialSymbolState( rets )
	rets = rets or self.ctl.rets -- 复制 通用逻辑
	if not self.checkItemsState then
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置

		self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter、bonus

	end
end

function cls:genSpecialSymbolStateInNormal(rets)

	local cItemList   = rets.item_list

	if self.showReSpinBoard then 
		for col=1, #self.spinLayer.spins do -- 遍历每一列
			local colItemList = cItemList[col]
			if(colItemList) then
				for row, theItem in pairs(colItemList) do
					-- 添加 jackpot 加速处理 计算当前列中有几个 jackpot symbol
					if type(theItem) == "number" and theItem >= specialSymbol["jackpot"]["value"] then
						local realCol = 1 + (col-1) % 5
						self.notifyState[realCol] = self.notifyState[realCol] or {}
						self.notifyState[realCol][specialSymbol["jackpot"]["key"]] = self.notifyState[realCol][specialSymbol["jackpot"]["key"]] or {}
						table.insert(self.notifyState[realCol][specialSymbol["jackpot"]["key"]], {col, row})
					end
				end
			end
		end
	else
	    local checkConfig = self.specialItemConfig
	  	for itemKey,theItemConfig in pairs(checkConfig) do
			local itemType     = theItemConfig["type"]
			local itemCnt  	   = 0
			local isBreak 	   = false
			if itemType then
				for col=1, #self.spinLayer.spins do
					local colItemList  = cItemList[col]
					local colRowCnt    = self.spinLayer.spins[col].row -- self.colRowList[col]
					local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
					-- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
					local isGetFeature = false
					if itemCnt >= theItemConfig["min_cnt"] then
						isGetFeature = true
					end
					-- 判断是否可能中feature或者更大的feature   一般用于滚轴加速
					local willGetFeatureInCol = false
					if not isBreak and curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
						willGetFeatureInCol = true
						self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
						self.speedUpState[col][itemKey] = true
					end
					-- 判断当前列加上之后所有列是否有可能中feature
					local willGetFeatureInAfterCols = false
					if not isBreak then
						local sumCnt = 0
						for tempCol=col, #self.spinLayer.spins do
							sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
						end
						if sumCnt>0 and (itemCnt+sumCnt)>= theItemConfig["min_cnt"] then
							willGetFeatureInAfterCols = true				
						end
					end
					
					self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
					if not isBreak and curColMaxCnt>0 and willGetFeatureInAfterCols then
						for row, theItem in pairs(colItemList) do
							if theItem == specialSymbol['triger'] then
								self.notifyState[col][theItem] = self.notifyState[col][theItem] or {}
								table.insert(self.notifyState[col][theItem], {col, row})
							-- elseif theItem >= specialSymbol['jackpot']['value'] then
							-- 	self.notifyState[col][specialSymbol["jackpot"]["key"]] = self.notifyState[col][specialSymbol["jackpot"]["key"]] or {}
							-- 	table.insert(self.notifyState[col][specialSymbol["jackpot"]["key"]], {col, row})
							end
						end
					end

					for row, theItem in pairs(colItemList) do
						if theItem == itemKey then
							itemCnt = itemCnt + 1
						end
						if theItem >= specialSymbol['jackpot']['value'] then
							self.notifyState[col] = self.notifyState[col] or {}
							self.notifyState[col][specialSymbol["jackpot"]["key"]] = self.notifyState[col][specialSymbol["jackpot"]["key"]] or {}
							table.insert(self.notifyState[col][specialSymbol["jackpot"]["key"]], {col, row})
						end
					end

				end
			end
	    end		
	end
end

function cls:checkSpeedUp(checkCol) -- 控制出现特殊的龙 虎 预示好事发生的动画的时候 取消单个轴的 加速操作
	local isNeedSpeedUp = false
	if not self.ctl.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol])>0 then
		isNeedSpeedUp = true
	end
	return isNeedSpeedUp
end

function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效
	self:playMusic(self.audio_list.reel_notify, true, false)
	self.playR1Col = pCol
end
function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end

	self.playR1Col = nil
	self:stopMusic(self.audio_list.reel_notify,true)
end

function cls:checkPlaySymbolNotifyEffect( pCol ) 
	self:dealMusic_StopReelNotifyMusic(pCol)
	-- local pCol2 = 1 + (pCol-1)%5
	self.notifyState = self.notifyState or {}
	local reelSymbolState = self.notifyState[pCol]
	-- local reelSymbolState = self.notifyState[pCol2]
	if not self.fastStopMusicTag and reelSymbolState and bole.getTableCount(reelSymbolState)>0 then -- 判断是否播放特殊symbol的动画
		self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
		return true
	else
		self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
		return false
	end

end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的	
 	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
 	local pos 	= cc.pAdd(self:getCellPos(pCol,3),cc.p(0,G_cellHeight))
 	local _,s1 = self:addSpineAnimation(self.animateNode, 20, self:getPic("spine/base/lzjs_01"), pos, "animation",nil,nil,nil,true,true)
 	self.reelNotifyEffectList[pCol] = s1
end

function cls:stopReelNotifyEffect(pCol)
	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
	if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
		self.reelNotifyEffectList[pCol]:removeFromParent()
	end
	self.reelNotifyEffectList[pCol] = nil
end

--------------------------Start--------------------------
-------------------------Re Spin-------------------------
function cls:showAllItem(showState)
	Theme.showAllItem(self, showState)
end

-- 滚轴滚到底部
function cls:onReelFallBottom( pCol )
	-- 标志位
	self.reelStopMusicTagList[pCol] = true	
	-- 列停音效，提示动画相关
	if not self:checkPlaySymbolNotifyEffect(pCol) then
		self:dealMusic_PlayReelStopMusic(pCol)
	end
	self:stopReelNotifyEffect(pCol)
	-- 确定下一轴是否进行Notify
	if self:checkSpeedUp(pCol + 1) then
		self:onReelNotifyStopBeg(pCol +1)
	end
end

function Theme:onReelFastFallBottom( pCol )
	self.reelStopMusicTagList[pCol] = true
	-- 列停音效，提示动画相关
	if not self.fastStopMusicTag then
		local hasNotify = false
		for col=pCol,#self.spinLayer.spins do
			local reelSymbolState = self.notifyState[col]
			if reelSymbolState and bole.getTableCount(reelSymbolState)>0 then
				hasNotify = true
				break
			end
		end
		if not hasNotify then
			-- self:dealMusic_PlayReelStopMusic(pCol)
			if pCol == 1 then 
				self:playMusic(self.audio_list.reel_stop)
			end
		end	
		
	end
	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	self:checkPlaySymbolNotifyEffect(pCol)
	self:stopReelNotifyEffect(pCol)
	-- self:asHintTime(pCol)
end


function cls:asHintTime(col) -- 显示jackpot 的框圈动画
	if self.lockedReels and self.lockedReels[col] then return end
	self.runedCell = self.runedCell or {}
	if self.recvItemList[col] then 
		for row,v in pairs(self.recvItemList[col]) do
			if jackpotBet[v] then
				
				local layer 	  = self.spinLayer.spins[col]:getRetCell(row)
				local pos 		  = cc.p(0, 0)
				local parentNode  = self:addAnimateNode()

				layer:addChild(parentNode)
				local spineFile   = self:getPic("spine/jackpot/hint/spine")
				local _, s1 	  = bole.addSpineAnimation(parentNode, 20, spineFile, pos, "animation", nil, nil, nil, true, true)
		
				layer.sprite:runHintAction()
				table.insert(self.runedCell, layer.sprite)
				if not self.JHint[col] then
					self.JHint[col] = true
				end
			end
		end	
	end
end

function cls:onReelStop( col, firstLook, isOverRespin )

	local delay = 0

	if self.showReSpinBoard then
		if not self.lockedReels then return end 
		if self.lockedReels[col] then return end 
		local item_List = self.recvItemList
		local key = item_List[col][1]

		if jackpotBet[key] then

			self.lockedReels[col] = true
			self:laterCallBack(delay, function ()
				if not self.showReSpinBoard then
					return
				end
				local pos = self:getCellPos(col, 1)
				local pic = key == 39 and self.pics['bonus2'] or self.pics[14]  

				local holdSp = bole.createSpriteWithFile(pic)
				holdSp:setPosition(pos)

				self.HoldLayer:addChild(holdSp, 100-col)

				self.HoldLayer._added[col] = holdSp

				local num = 0
				local mul = jackpotBet[key]

				if type(mul) == "string" then  -- xmtodo 用来确定是不是mini 还是

					local up = bole.createSpriteWithFile("#theme108_m"..(key-40)..".png") -- cc.Sprite:create(self:getPic("image/theme103_m"..(key-30)..".png"))--H  key-23 .."2"
					up:setPosition(cc.p(Jsize.width/2,Jsize.height/2))--170/2, 167/2
					holdSp:addChild(up, 3)

					-- 获取得到jpwin的值
					local tb = self.ctl:getCurTotalBet()
					num = self.bonus and self.bonus:getJpWin(key - 40) or PoolMuls2[key-40]*tb 
				elseif key == 39 then
					num = self:getStartPrizeNum()
					local numLabel = self:newJackpotLabel(true)
					numLabel:setScale(fontScale)
					holdSp:addChild(numLabel, 3)
					numLabel:setString(num)
					numLabel:setPosition(cc.p(Jsize.width/2,Jsize.height1/2))--190/2, 177/2-6
					holdSp.string = numLabel

					if not firstLook then
						self.respinToSymbol = self.respinToSymbol or {}
						numLabel:setVisible(false)
						local info = {
							['num'] = num, 
							['col'] = col,
							['node'] = holdSp,
							['numLabel'] = numLabel
						}
						table.insert(self.respinToSymbol, info)
					end					
				else
					num = self:getJackpotNum(key)
					local numLabel = nil
					numLabel = self:newJackpotLabel()

					holdSp:addChild(numLabel, 3)
					numLabel:setString(num)
					numLabel:setPosition(cc.p(Jsize.width/2,Jsize.height/2))--190/2, 177/2-6
					holdSp.string = numLabel
					numLabel:setScale(fontScale)
				end

				

				holdSp.num = num
				holdSp.key = key
				-- -- whj 添加特效光圈
				local cellSize = self.spinLayer:getCellSize(col)
				
				self:addHoldSpine(holdSp, key, spineFile, animation, true)

				local cell = self.spinLayer.spins[col]:getRetCell(1)
				self:updateCellSprite(cell, key, col, 1)
			end)
		end
	end

	Theme.onReelStop(self, col)
end

function cls:addHoldSpine(node, key)
	if not node then return end
	local spineFile = (key == 39) and self:getPic("spine/item/bonus2/spine") or self:getPic("spine/item/14/spine")
	local animation = (key == 39) and 'animation' or 'animation1'
	local pos = (key == 39) and cc.p(Jsize.width/2,Jsize.height1/2) or cc.p(Jsize.width/2,Jsize.height/2) 
	if node.spine then
		node.spine:removeFromParent()
		node.spine = nil
	end

	local _, s1 = bole.addSpineAnimation(node, 2, spineFile ,pos, animation, nil, nil, nil, true, true, nil)	-- -1
	node.spine = s1

end

function cls:getStartPrizeNum()
	return self.poolCoin or 0
end

function cls:addCoinToSymbolDetail(respinToSymbol, doNext)
	-- 具体执行的操作
	if not respinToSymbol then return end
	local num = respinToSymbol.num
	local numLabel = respinToSymbol.numLabel
	local idx = respinToSymbol.col
	local holdSp = respinToSymbol.node

	if not self.flyParent then
		self.flyParent = cc.Node:create()
		bole.scene:addToTop(self.flyParent)
		self.flyParent:setPosition(0,0)	
	end

	if not bole.isValidNode(holdSp) or not bole.isValidNode(numLabel) then
		return
	end

	local animationScale = 1
	local endPos   = bole.getWorldPos(holdSp)
	local startPos = bole.getWorldPos(self.startPrizeNode)

	local startNPos = bole.getNodePos(self.flyParent, startPos)
	local endNPos = bole.getNodePos(self.flyParent, endPos)

	local endLength = math.sqrt(math.pow((endNPos.y-startNPos.y),2)+math.pow((endNPos.x-startNPos.x),2))

	local endLength_have = 400 -- 动画的实际长度
	animationScale = endLength / endLength_have

	local angle = -(90 + math.atan2((endNPos.y - startNPos.y), (endNPos.x - startNPos.x)) * 180 / math.pi)

	if not self.FlyliziNode then
		local path 	=  self:getPic("spine/respin/xiangxializi2")
		local _, s = self:addSpineAnimation(self.flyParent, 10, path, cc.p(0, 0), "animation", nil, nil, nil, true, nil, nil)	--"animation"..idx
		self.FlyliziNode = s
	else
		bole.spChangeAnimation(self.FlyliziNode,"animation", false)
	end

	self.FlyliziNode:setRotation(angle)
	self.FlyliziNode:setPosition(startNPos)
	self.FlyliziNode:setScale(animationScale)

	local function parseValue( num)
		return FONTS.format(num, true)
	end

	self:playMusic(self.audio_list.start_down)  
	local addNum = function ( ... )
		if flySpine then
			flySpine:removeFromParent()
		end

		if numLabel then
			numLabel:setScale(0.1)
			numLabel:setVisible(true)
			numLabel:setString(num)
			numLabel:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, fontScale)))
		end

		self:laterCallBack(25/60, doNext) 

	end
	self:laterCallBack(25/60, addNum) 

end

function cls:addCoinToSymbol(num, idx, holdSp, numLabel)

	local _respinToSymbol = {}
	local doNext = nil


	for key,val in ipairs(self.respinToSymbol) do
		table.insert(_respinToSymbol, val)
	end
	doNext = function ( ... )
 		if #_respinToSymbol == 0 then
 			self.respinToSymbol = {}
 			return
		else
			local respinToSymbol = table.remove(_respinToSymbol, 1)
			self:addCoinToSymbolDetail(respinToSymbol, doNext)
		end
 	end
 		
 	doNext()

end

function cls:deleteAnimateAdd(num, idx, holdSp, numLabel)
	-- 去除添加的节点

	if bole.isValidNode(self.flyParent) then
		self.flyParent:removeFromParent()
	end

	if bole.isValidNode(self.targetNode) then
		self.targetNode:removeFromParent()
	end

	if bole.isValidNode(self.FlyliziNode) then
		self.FlyliziNode:removeFromParent()
	end

	self.flyParent = nil
	self.targetNode = nil
	self.FlyliziNode = nil

end

function cls:getJpState( key )
	-- 判断当前的类型是bonus2 还是37，38特殊的， 还是普通的需要添加钱数的
	-- 1 是普通类型 2是mini或者minor 3是bonus2
	if jackpotBet[key] and key < 37 then
		return 1
	elseif key >= 40 then
		return 2
	elseif key == 39 or key == 'bonus2' then
		return 3
	end
end

function cls:fresh_board_Jbet2(Multiple) -- 在respin 里面刷新牌面的显示操作
	for i=1,15 do
		self:laterCallBack(i*FreshTime,function ( ... )
			local cell = self.HoldLayer._added[i]
			-- 刷新特效
			local path 	=  self:getPic("spine/respin/fanbei")
			local _, spineNode = Theme:addSpineAnimation(self.HoldLayer, 200, path, cc.p(cell:getPosition()), "animation")

			self:playMusic(self.audio_list.mul)
			local key = self:getJpState(cell.key)
			if key == 1 or key == 3 then
				local newLabel = (key == 1) and self:newJackpotLabel() or self:newJackpotLabel(true)

				newLabel:setString(self:getJackpotNum(self.recvItemList[i][1]) * Multiple)
				newLabel:setPosition(cc.p(Jsize.width/2, Jsize.height/2))
				if key == 3 then
					newLabel:setPosition(cc.p(Jsize.width/2, Jsize.height1/2))
				end
				
				newLabel:setScale(fontScale)
				cell.string:removeFromParent()
				cell:addChild(newLabel, 3)
				
				cell.string = newLabel
			elseif key == 2 then
				-- 添加 x2 x3 图片显示 
				local labelsp = bole.createSpriteWithFile("#theme108_mult_2.png") -- cc.Sprite:create(self:getPic("image/theme103_mult_"..Multiple..".png"))--H  key-23 .."2"
				-- local size = cell:getContentSize()
				labelsp:setPosition(Jsize.width/2, Jsize.height/2-48)
				cell:addChild(labelsp,5)
			end

			if key ~= 2 then
				cell.num = cell.num * Multiple
			end
			
		end)
		
	end
end

--- freegame中随机出现wild以及固定住的wild
-- local showSWTime = 21/30 + 0.5 -- 移动到指定位置的时间
local showSWTime = 21/30 -- 移动到指定位置的时间
local getSWDelay = 0.2 -- 150/30 -- 出现wild 之前的操作 时间
local baseAnimPos = cc.p(360,195)

function cls:setStickyWildSymbol(newStickyWildPos,isResume)
	local _curSWList = tool.tableClone(self.curStickyWildList) or {}
 	if not self.showFreeSpinBoard or not newStickyWildPos or #newStickyWildPos == #_curSWList then return end
 	
 	self.stickyWildSList = self.stickyWildSList or {}
 	local file = self:getPic("spine/item/13/spine") -- 金币 动画
 	if isResume then 
 		for _,posData in pairs(newStickyWildPos) do -- {"hans":[[0,4],[1,0],[3,5],[1,5],[1,3]]}
	 		if not self.stickyWildSList or not self.stickyWildSList[posData[1]] or not self.stickyWildSList[posData[1]][posData[2]] then
		 		local pos = self:getCellPos(posData[1],posData[2])
		 		local _,s = self:addSpineAnimation(self.stickyAnimate, 40, file, pos, "animation3", nil, nil, nil, true)-- 添加 wild symbol 动画 静止动画
		 		self.stickyWildSList[posData[1]] = self.stickyWildSList[posData[1]] or {}
		 		self.stickyWildSList[posData[1]][posData[2]] = s
		 	end
	 	end
	else
	 	self.haveSpecialdelay = true
	 	local _startDelay = self.speicalDelay or 0
	 	self.speicalDelay = (self.speicalDelay or 0) + getSWDelay*2 + (#newStickyWildPos - #_curSWList)*showSWTime
	 	local delay2 = (#newStickyWildPos - #_curSWList)*showSWTime
	 	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
	 	self.stickyMask:setOpacity(0)
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(_startDelay),
			cc.CallFunc:create(function ( ... )
				self.stickyMask:runAction(cc.FadeTo:create(getSWDelay,170))
			end),
			cc.DelayTime:create(getSWDelay),
			cc.CallFunc:create(function ( ... )
				local delay = 0
				for k = (#_curSWList+1),#newStickyWildPos do -- {"hans":[[0,4],[1,0],[3,5],[1,5],[1,3]]}
			 		local posData = newStickyWildPos[k]
			 		if posData and (not self.stickyWildSList[posData[1]] or not self.stickyWildSList[posData[1]][posData[2]]) then
			 			self:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function ( ... )
			 				self:playMusic(self.audio_list.free_wild_land)
			 				local pos = self:getCellPos(posData[1],posData[2])
			 				local _,s = self:addSpineAnimation(self.stickyAnimate, 40, file, pos, "animation1", nil, nil, nil, true)-- 添加 wild symbol 出现动画
					 		self.stickyWildSList[posData[1]] = self.stickyWildSList[posData[1]] or {}
					 		self.stickyWildSList[posData[1]][posData[2]] = s
			 			end)))
			 			delay = delay+showSWTime
				 	end
			 	end
			end),
			cc.DelayTime:create(delay2),
			cc.CallFunc:create(function ( ... )
				self.stickyMask:runAction(cc.FadeTo:create(getSWDelay,0))
				self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
			end)))
	end
	self.curStickyWildList = tool.tableClone(newStickyWildPos)
end 

function cls:setRandWildSymbol(newRandWildPos)
 	if not self.showFreeSpinBoard or not newRandWildPos or #newRandWildPos ==0 then return end
 	local file = self:getPic("spine/item/13/spine") -- 金币 动画

 	self.haveSpecialdelay = true
 	local _startDelay = self.speicalDelay or 0
 	self.speicalDelay = (self.speicalDelay or 0) + getSWDelay*2 + #newRandWildPos*showSWTime
 	self.randWildSList = {}
 	local delay2 = #newRandWildPos*showSWTime
 	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
 	self.stickyMask:setOpacity(0)
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(_startDelay),
		cc.CallFunc:create(function ( ... )
			self.stickyMask:runAction(cc.FadeTo:create(getSWDelay,170))
		end),
		cc.DelayTime:create(getSWDelay),
		cc.CallFunc:create(function ( ... )

			local delay = 0
		 	for k,posData in pairs(newRandWildPos) do -- {"hans":[[0,4],[1,0],[3,5],[1,5],[1,3]]}

		 		-- {"super_item_list":[[22,4,4],[3,4,21],[4,2,1],[5,3,2],[1,1,1]

		 		if posData then
		 			self:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function ( ... )
		 				self:playMusic(self.audio_list.free_wild_land)
		 				local pos = self:getCellPos(posData[1],posData[2])
				 		local _,s = self:addSpineAnimation(self.randAnimate, 40, file, pos, "animation1", nil, nil, nil, true)-- 添加 wild symbol 动画 静止动画
				 		self.randWildSList[posData[1]] = self.randWildSList[posData[1]] or {}
				 		self.randWildSList[posData[1]][posData[2]] = s
		 			end)))
		 			delay = delay+showSWTime
			 	end
		 	end
		end),
		cc.DelayTime:create(delay2),
		cc.CallFunc:create(function ( ... )
			self.stickyMask:runAction(cc.FadeTo:create(getSWDelay,0))
			self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
		end)))
end

function cls:onThemeInfo(ret,callFunc)

	local themeInfo = ret["theme_info"]

	if themeInfo.super_info then 
		self.superInfoData = themeInfo.super_info
	else
		self.superInfoData = {}
	end

	if ret.free_game then
		self.freeSpinType = ret["free_game"]['super_type']
		self.isSuper      = self.freeSpinType > 0 and true or false
		self.superBet     = self.superInfoData and self.superInfoData.super_bet
	end


	if self.showBaseSpinBoard then 
		local themeInfoAnimList = {}

		if themeInfo then 
			-- self:refreshDiskData(themeInfo)
			-- self:themeInfoChangeDiskData(themeInfo, themeInfoAnimList)
		end
		
		if #themeInfoAnimList>0 then 
			self.ctl.footer:setSpinButtonState(true)
			local l3 = cc.CallFunc:create(function ( ... )
				self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)-- 恢复背景音乐
			end)
			table.insert(themeInfoAnimList, l3)
			local l4 = cc.DelayTime:create(0.1)
			table.insert(themeInfoAnimList, l4)
			local l5 = cc.CallFunc:create(function ( ... )
				callFunc()
			end)
			table.insert(themeInfoAnimList, l5)
			-- 降低背景音乐
			self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
			self:runAction(cc.Sequence:create(bole.unpack(themeInfoAnimList)))
		else
			callFunc()
		end
	else
		callFunc()
	end
end

function cls:showWildFeature( callFunc )
	if self.stickWildSpine and bole.getTableCount(self.stickWildSpine)>0 then 
		self:playMusic(self.audio_list.wild_change)
		for col,rowList in pairs(self.stickWildSpine) do 
			for row, temp in pairs(rowList) do
				bole.spChangeAnimation(temp,"animation2")
			end
		end
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(changeToWildTime),
			cc.CallFunc:create(callFunc)))
	else
		callFunc()
	end
end


-------------------------- 断线重连 ----------------------------
function cls:setFreeGameRecoverState(data)
	if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
		self.isFreeGameRecoverState = true
	end
end

function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl.isProcessing  = true
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:overBonusByEndGame(data) -- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面
	if data.total_win then 
		self.ctl.totalWin = data.total_win
	end
	if data.jp_win then
		for k,v in pairs(data.jp_win) do 
			if v.jp_win then 
				self.ctl.totalWin = self.ctl.totalWin +  v.jp_win
			end
		end
	end
	self.ctl.isProcessing  = false
	if self.showFreeSpinBoard or self.ctl.freewin then
		self.ctl.totalWin = self.ctl.freewin + self.ctl.totalWin
		self.ctl.freewin = self.ctl.totalWin
		self.ctl:updateFooterCoin()

	else
		self:unlockLobbyBtn()
		self.ctl:removePointBet()
		self.ctl:updateFooterCoin()
		self.ctl:addCoinsToHeader()
	end
end

function cls:saveBonusData()
	if self.ctl.rets then
		self.ctl.bonusItem 	= tool.tableClone(self.ctl.rets.item_list)
		self.ctl.bonusRet 	= self.ctl.rets
		self.bonusSpeical = self.ctl.specials
	end	
end

function cls:outBonusStage()
	if self.bonusSpeical then 
		self.ctl.specials = self.bonusSpeical
	end
	if self.ctl.bonusItem then
		self.ctl:resetBoardCellsSpriteOverBonus(self.ctl.bonusItem) -- 刷新牌面 + 动画播放
	end
	self.ctl.bonusItem    = nil	
	self.ctl.bonusRet     = nil
end

function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	ret["free_spins"]		= theFreeSpinData.free_spins
	ret["free_spin_total"]  = theFreeSpinData.free_spin_total

	self.freeType 			= theFreeSpinData.fg_type
	self.wildCount 			= theFreeSpinData.wild_count
	-- self.ctl.isProcessing  	= false
	self.ctl:free_spins(ret)
end

------------------------------------------------------------

function cls:theme_respin( rets )

	self.respinToSymbol = self.respinToSymbol or {}
	local specailNum = (#self.respinToSymbol > 0) and #self.respinToSymbol or 0
	local delay = specailNum * 5/6
	if specailNum > 0 then
		self:addCoinToSymbol()
	end

	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5 + delay), cc.CallFunc:create(function()
		local respinList = rets["theme_respin"]
		if respinList and #respinList>0 then
			rets["item_list"] = table.remove(respinList, 1)
			local respinStopDelay = 1
			local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
			self:stopDrawAnimate()
			respinStopDelay = respinStopDelay + delay
			-- 判断当前是不是有额外的次数领取
			local addSpin = rets["add_spins"]
			local allRespin = rets["theme_respin_count"]

			local hasAdd = self.bonus.data['over_add_spins']

			if addSpin > 0 and (allRespin == self.bonus.respinTimes) and not hasAdd then
				self.bonus:showRespinLayer(RespinDialogType.extra, respinStopDelay, endCallFunc, function ( ... )
					self.ctl:respin(respinStopDelay, endCallFunc) 
				end)
			else
				self.ctl:respin(respinStopDelay, endCallFunc)  
			end
			       
		else
			rets["theme_respin"] = nil
		end	
	end)))
end

function cls:dealAboutBetChange(bet,isPointBet)
	self:checkLockFeature()
	self:setTip()
end

function cls:onAllReelStop()
	Theme.onAllReelStop(self)
end

function cls:finshSpin( )
	if self.ctl.autoSpin then
		self:enableFeaturetipBtn(false)
	else
		self:enableFeaturetipBtn(true)
	end
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	self.haveSpecialdelay = false
	self.speicalDelay = 0

	if self.stickyWildSList then 
		for col,list in pairs(self.stickyWildSList) do 
			for row,item in pairs(list) do 
				bole.changeSpineNormal(item,"animation3",false)
			end
		end
	end

	Theme.stopDrawAnimate(self)
	self.scatterAnimNode:removeAllChildren()
	self.animNodeList = nil
end

function cls:cleanStatus( stillEffect )
	self.stickWildSpine = nil
	self.randAnimate:removeAllChildren()
	self.randWildSList = nil
	
	Theme.cleanStatus(self, stillEffect)
end

---------------------------------- freeSpin --------------------------------------------
function cls:resetPointBet() -- 仅仅在断线的时候 被调用了
	if self.isSuper then 
		if self.superBet then 
			self.ctl:setPointBet(self.superBet)-- 更改 锁定的bet
		end
		self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet 
	end
end

local fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}

local fg_animation_pos = {
	normalStart = cc.p(0, -185),
	normalTitle = cc.p(8, 196),
	normalCollect = cc.p(4, -123),
	superStart  = cc.p(7, -185),
	superTitle  = cc.p(4, 200),
}


function cls:showFreeSpinDialog(theData, sType)
	local config = {}

	config["gen_path"] = self:getPic("csb/")
	-- 判断当前的类型
	if FreeSpinType.super == self.freeSpinType then
		config["csb_file"] = config["gen_path"].."super_spin.csb"
	elseif FreeSpinType.mega == self.freeSpinType then
		config["csb_file"] = config["gen_path"].."mega_spin.csb"
	else
		config["csb_file"] = config["gen_path"].."free_spin.csb"	
	end

	config["frame_config"] = {
		-- start: 第二个参数 注册点击事件的方法; 第四个参数 .theme:onCollectFreeClick 回调(可以 理解为 点击事件立马就会被调用了,跟第四个参数没有关系); 第六个参数 回调endEvent方法(一般在 endEvent里面场景切换回调) 最后一个参数 是 延迟删除的时间
		["start"] 		 = {{0, 30}, 0.5, {60, 90}, 0, 0, (transitionDelay.free.onCover + 0.3), 0.5},
		["more"] 		 = {{0, 30},2.7,  {60, 90},0.3,0,0,0.5},
		["collect"] 	 = {{0, 30}, 1, {60, 90}, 0, transitionDelay.free.onCover, (transitionDelay.free.onEnd - transitionDelay.free.onCover), 0},-- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
	}
	self.freeSpinConfig = config 

	local addBgAnimation = function ( node )
		local bg_spine = node.baseRoot:getChildByName('spine_node')
		if not bg_spine then return end
		bg_spine:removeAllChildren()
		if self.freeSpinType == FreeSpinType.normal then
			if sType == fs_show_type.collect then
				self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/changanniu"), fg_animation_pos.normalCollect, "animation", nil, nil, nil, true,true)
			elseif sType == fs_show_type.start then
				self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/anniu"), fg_animation_pos.normalStart, "animation", nil, nil, nil, true,true)
			end
			self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/congrzi"), fg_animation_pos.normalTitle, "animation", nil, nil, nil, true,true)
			self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/maozixianrenzhang"), cc.p(0,0), "animation", nil, nil, nil, true,true)
		elseif self.freeSpinType == FreeSpinType.mega then
			local pathBg = self:getPic("spine/dialog/deng")
			local pathTitle = self:getPic("spine/dialog/megazi")
			local titlePos = fg_animation_pos.superTitle
			if sType == fs_show_type.collect then
				pathBg = self:getPic("spine/dialog/maozixianrenzhang")
				pathTitle = self:getPic("spine/dialog/congrzi")
				titlePos = fg_animation_pos.normalTitle
				self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/changanniu"), fg_animation_pos.normalCollect, "animation", nil, nil, nil, true,true)
			elseif sType == fs_show_type.start then
				self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/anniu"), fg_animation_pos.superStart, "animation", nil, nil, nil, true,true)
			end
			self:addSpineAnimation(bg_spine, nil, pathBg, cc.p(0,0), "animation", nil, nil, nil, true,true)
			self:addSpineAnimation(bg_spine, nil, pathTitle, titlePos, "animation", nil, nil, nil, true,true)

		elseif self.freeSpinType == FreeSpinType.super then
			local pathBg = self:getPic("spine/dialog/deng")
			local pathTitle = self:getPic("spine/dialog/superzi")
			local titlePos = fg_animation_pos.superTitle
			if sType == fs_show_type.collect then
				pathBg = self:getPic("spine/dialog/maozixianrenzhang")
				pathTitle = self:getPic("spine/dialog/congrzi")
				titlePos = fg_animation_pos.normalTitle
				self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/changanniu"), fg_animation_pos.normalCollect, "animation", nil, nil, nil, true,true)
			elseif sType == fs_show_type.start then
				self:addSpineAnimation(bg_spine, nil, self:getPic("spine/dialog/anniu"), fg_animation_pos.superStart, "animation", nil, nil, nil, true,true)
			end
			self:addSpineAnimation(bg_spine, nil, pathBg, cc.p(0,0), "animation", nil, nil, nil, true,true)
			self:addSpineAnimation(bg_spine, nil, pathTitle, titlePos, "animation", nil, nil, nil, true,true)
		end
	end


	-- local addLizi = function (node) -- 添加粒子特效 和 spine 动画的入口

	-- 	-- if sType == fs_show_type.start then
	-- 	-- 	addBgAnimation(node)
	-- 	-- 	-- self:addSpineAnimation(node.moreRoot, nil, self:getPic("spine/dialog/yuanxingtiao2"), cc.p(-15,72), "animation", nil, nil, nil, true,true)
	-- 	-- elseif sType == fs_show_type.more then
	-- 	-- 	addBgAnimation(node)
	-- 	-- elseif sType == fs_show_type.collect then
	-- 	-- 	addBgAnimation(node)
	-- 	-- 	-- self:addSpineAnimation(node.collectRoot.btnCollect,nil, self:getPic("spine/dialog/anniuliuguang_01"), cc.p(size.width/2,size.height/2), "animation2", nil, nil, nil, true, true)-- 添加特效
	-- 	-- end
	-- end
	local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
	if sType == fs_show_type.start then
		theDialog:showStart(theData)
		self:stopMusic(self.audio_list.retrigger_bell, true)
		-- addLizi(theDialog)
		addBgAnimation(theDialog)
	elseif sType == fs_show_type.more then
		theDialog:showMore(theData)
		self:stopMusic(self.audio_list.retrigger_bell, true)
		-- addLizi(theDialog)
		addBgAnimation(theDialog)
	elseif sType == fs_show_type.collect then
		theDialog:setCollectScaleByValue(theData.coins,518)
		theDialog:showCollect(theData)
		-- addLizi(theDialog)
		addBgAnimation(theDialog)
	end
end

function cls:initMapFreeCollect( theDialog )
	local boosterRoot = theDialog.baseRoot:getChildByName("booster_root")
	if boosterRoot then
		boosterRoot:setPositionY(-31)
	end
end
function cls:setDealFreeCollectState()
    self.ctl.spin_processing = true
    self.ctl.isProcessing  = true
end
function cls:playStartFreeSpinDialog( theData )
	local enterEvent = theData.enter_event
	theData.enter_event = function ( ... )
		enterEvent()
		self:playMusic(self.audio_list.free_dialog_start_show)
	end
	
	local endEvent = theData.end_event
	theData.end_event = nil

	-- theData.end_event = function ( ... )
	-- 	-- endEvent()
	-- 	-- self:dealMusic_PlayFreeSpinLoopMusic()
	-- end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		
		self:playMusic(self.audio_list.bison_down)
		-- bole.spChangeAnimation(self.logoSpine,"animation2")
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function ( ... )
				self:playMusic(self.audio_list.transition_free)-- 播放转场声音
				self:playTransition(nil,"free")-- 转场动画

			end),
			cc.DelayTime:create(20 / 30),
			cc.CallFunc:create(function()
				if bole.isValidNode(self.scatterAnimNode) then
					self.scatterAnimNode:removeAllChildren()
				end
            end),
			cc.DelayTime:create(40 / 30),
			cc.CallFunc:create(function()
				if endEvent then
                    endEvent()
                end
            end),
			cc.DelayTime:create(30 / 60),
			cc.CallFunc:create(function()
                self:dealMusic_PlayFreeSpinLoopMusic()
            end)))
	end

	self:showFreeSpinDialog(theData, fs_show_type.start)
end

function cls:freeStartClicked( callFunc )
	self:laterCallBack(0.5, function ( ... )
		callFunc()
		return
	end)
end


function cls:playMoreFreeSpinDialog( theData )
	self:showFreeSpinDialog(theData, fs_show_type.more)
end

function cls:playCollectFreeSpinDialog( theData )
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		self:playMusic(self.audio_list.transition_free)-- 播放转场声音
		self:playTransition(nil,"free")-- 转场动画
	end
	self:showFreeSpinDialog(theData, fs_show_type.collect)
end

---------------------- symbol 动画相关 ----------------------
function cls:playBackBaseGameSpecialAnimation( theSpecials ,enterType)
	self:playFreeSpinItemAnimation(theSpecials ,enterType)
end

function cls:playFreeSpinItemAnimation( theSpecials ,enterType)
	local delay = 0
	local _updateFeatureCntTime = 0.5
	local superTime = 1
	if enterType and enterType == "free_spin" or enterType == "more_free_spin" then
		delay = 0.5
		if enterType == 'free_spin' and not self.isLockFeature then
			_updateFeatureCntTime = _updateFeatureCntTime + 0.5
		end
		if self.isSuper then
			delay = delay + superTime
			_updateFeatureCntTime = _updateFeatureCntTime + superTime
		end
		delay = delay + _updateFeatureCntTime
	else
		delay = 2	
	end


	local playAnimation = function ( ... )
		for col, rowTagList in pairs(theSpecials[specialSymbol["triger"]]) do
			for row, tagValue in pairs(rowTagList) do
				self:addItemSpine(specialSymbol["triger"], col, row, 'animation2')
			end
		end
	end
	
	if enterType == 'free_spin' then
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... ) -- "fg_pos":[[3,3]],
				if not self.isLockFeature then 
					self:updateFeatureCnt(true)
				end
			end),
			cc.DelayTime:create(_updateFeatureCntTime - 2),
			cc.CallFunc:create(function ( ... )
				self:playMusic(self.audio_list.retrigger_bell)
				playAnimation()
			end)))
	elseif enterType == 'more_free_spin' then	
		delay = 2
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... ) -- "fg_pos":[[3,3]],
				self:playMusic(self.audio_list.retrigger_bell)
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function ( ... )
				playAnimation()
			end)))
	else
		playAnimation()
	end

	return delay
end

-- function cls:playScatterEffect()
-- 	self:playMusic(self.audio_list.symbol_scatter,true,true)
-- end

function cls:stopScatterEffect( )
	self:stopMusic(self.audio_list.symbol_scatter)
end	

-- local animateMusic = { [specialSymbol["triger"]]= self.audio_list.symbol_scatter} --wild = "t1_w", xw = "t1_w", -- 
function cls:addItemSpine(item, col, row, animName)
	local layer			= self.scatterAnimNode
	local animName		= animName or "animation"
	local pos			= self:getCellPos(col, row)
	local spineFile		= self:getPic("spine/item/"..item.."/spine")

	-- local cell = self.spinLayer.spins[col]:getRetCell(row)
	-- cell:setVisible(false)
	-- if cell.itemSpine then
	-- 	cell.itemSpine:removeFromParent()
	-- end
	local _, s1 = self:addSpineAnimation(layer, 100, spineFile, pos, animName, nil, nil, nil, true, true)
	-- cell.itemSpine = s1
end

function cls:playBonusOpenAnimate( item, col, row, animName )
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local spineFile		= self:getPic("spine/item/14/spine")
	local animName		= animName or "animation"
	local _,s = self:addSpineAnimation(cell, 22, spineFile, cc.p(0,0), animName , nil,nil,nil,true)
	cell.sprite:setVisible(false)
	cell.symbolTipAnim = s
end


function cls:playBonusItemAnimate( itemList )
	local itemList = itemList or (self.ctl.rets.item_list or {})
	for col,list in pairs(itemList) do 
		for row,key in pairs(list) do 
			if key == specialSymbol.triger then 
				-- self:addItemSpine(specialSymbol.triger,col,row,"animation")-- 播放symbol 动画
			elseif (type(key) == 'number' and key >= specialSymbol["jackpot"]["value"]) or (key == 'bonus2') then
				-- self:addItemSpine(specialSymbol['jackpot']['key'] ,col,row,"animation2")-- 播放symbol 动画
				self:playBonusOpenAnimate(specialSymbol['jackpot']['key'] ,col,row,"animation2")
			end
		end
	end
end

function cls:playBonusAnimate(theGameData) -- 播放 bonus symbol 动画  同时 播放 开始弹窗

	local itemList = self.ctl.rets.item_list or {}
	local doNext = nil
	local doList = {}

	local delay  = 2 -- respin 结束后再停留2s
	local upTime = 35/30

	local wild_pos = tool.tableClone(self.curStickyWildList) or {}

	if self.flyParent then
 		self.flyParent:removeFromParent()
 	end

 	self.flyParent = cc.Node:create()
	bole.scene:addToTop(self.flyParent)
	self.flyParent:setPosition(-640,-360)

	-- 当前的动画
	local addSpine = function ( ... )
		bole.spChangeAnimation(self.lockSuperSpine,"animation3",false)
		self:freshStartPrize(true, 0)
		if self.megaInfoNode then
			self.megaInfoNode:setVisible(false)
		end
		if self.superInfoNode then
			self.superInfoNode:setVisible(false)
		end
		
		bole.spChangeAnimation(self.startPrizeSpine,"animation1",false)
		self:playMusic(self.audio_list.banzi_down)
		self.startPrizeNum:setVisible(true)
	end

	for col,list in pairs(itemList) do 
		for row,key in pairs(list) do
			local index = {['col'] = col, ['row'] = row}
			if self.stickyWildSList and self.stickyWildSList[col] and self.stickyWildSList[col][row] and key >= specialSymbol['jackpot']['value'] then
				self.stickyWildSList[col][row]:setVisible(false)
				local cell = self.spinLayer.spins[index.col]:getRetCell(index.row)
				self:updateCellSprite(cell, key, col)
			end

			if self.randWildSList and self.randWildSList[col] and self.randWildSList[col][row] and key >= specialSymbol['jackpot']['value'] then
				self.randWildSList[col][row]:setVisible(false)
				local cell = self.spinLayer.spins[index.col]:getRetCell(index.row)
				self:updateCellSprite(cell, key, col)
			end


			if key >= specialSymbol['jackpot']['value'] then
				table.insert(doList, index)
				delay = delay + upTime
			end
			local cell = self.spinLayer.spins[index.col]:getRetCell(index.row)
			cell.sprite:setVisible(true)
		end
 	end

 	addSpine()



 	local addToStartPrize = function ( ... )
 		self:laterCallBack(15/30, function ( ... )
		-- self.startPrizeNum:setVisible(true)
		bole.spChangeAnimation(self.lockSuperSpine,"animation4",true)
		bole.spChangeAnimation(self.startPrizeSpine,"animation2",true)
 		doNext = function ( ... )
 			if #doList == 0 then
 				self.ctl.footer:setSpinButtonState(true)
				-- self:playMusic(self.audio_list.trigger_bell)
				-- self:playMusic(self.audio_list.trigger_bell)
				self:playBonusItemAnimate()
				self:stopAllLoopMusic()
				self:playMusic(self.audio_list.trigger)

			else
				local index = table.remove(doList, 1)
				self:addJackpotToFooter(index, doNext)
			end
 		end
 			doNext()
 		end)
 	end  

 	self:laterCallBack(0.3, function ( ... )

 		if self.animateNode then
			self.animateNode:removeAllChildren()
		end

 		for col,list in pairs(itemList) do 
			for row,key in pairs(list) do
				local cell = self.spinLayer.spins[col]:getRetCell(row)
				cell.sprite:setVisible(true)
				cell:setVisible(true)
			end
 		end

 		addToStartPrize()
 	end)

	
	self.ctl.footer:setSpinButtonState(true)
	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
	-- self:playBonusItemAnimate()
	return delay 
end

---------------- 收集金币 -------------------



function cls:addJackpotToFooter(index ,doNext, toFooter, isBonus)
	if not index then
		return 
	end
	local flyParent = function ( ... )
		if not self.flyParent then
			self.flyParent = cc.Node:create()
			bole.scene:addToTop(self.flyParent)
			self.flyParent:setPosition(0,0)
		end
	end

	flyParent()

	local animationScale = 1

	local targetPath = toFooter and self:getPic("spine/respin/footerjieshou") or self:getPic("spine/respin/tiaojieshou")
	local liziPath   = toFooter and self:getPic("spine/respin/footerjiesuan2") or self:getPic("spine/respin/xiangshanglizi2")
	

	local startPos = toFooter and bole.getWorldPos(self.HoldLayer._added[index]) or bole.getWorldPos(self.spinLayer.spins[index.col]:getRetCell(index.row))
	local endPos =	toFooter and bole.getWorldPos(self.ctl.footer.winNode) or bole.getWorldPos(self.startPrizeNode)
	local target = toFooter and self.ctl.footer.winNode or self.startPrizeNode

	local startNPos = bole.getNodePos(self.flyParent, startPos)
	local endNPos = bole.getNodePos(self.flyParent, endPos)

	local endLength = math.sqrt(math.pow((endNPos.y-startNPos.y),2)+math.pow((endNPos.x-startNPos.x),2))

	local endLength_have = toFooter and 350 or 400 -- 动画的实际长度
	animationScale = endLength / endLength_have

	local angle = -(90 + math.atan2((endNPos.y - startNPos.y), (endNPos.x - startNPos.x)) * 180 / math.pi)
	-- 全部都在中心点
	if not self.FlyliziNode then
		local path 	=  self:getPic("spine/respin/footerjiesuan2")
		local _, s = self:addSpineAnimation(self.flyParent, 10, liziPath, cc.p(0, 0), "animation", nil, nil, nil, true, nil, nil)	--"animation"..idx
		self.FlyliziNode = s
	else
		bole.spChangeAnimation(self.FlyliziNode,"animation", false)
	end
	self.FlyliziNode:setRotation(angle)
	self.FlyliziNode:setPosition(startNPos)
	self.FlyliziNode:setScale(animationScale)

	local targetLizi = function ( ... )
		if not self.targetNode then
			flyParent()
			local _, s = self:addSpineAnimation(self.flyParent, 10, targetPath, endNPos, "animation", nil, nil, nil, true, nil, nil)	--"animation"..idx
			self.targetNode = s
		else
			if self.targetNode then
				bole.spChangeAnimation(self.targetNode,"animation", false)
			end
		end
		-- self.targetNode:setPosition(endNPos)
	end

	-- local cell = self.HoldLayer._added[index]
	local cell = toFooter and self.HoldLayer._added[index] or self.spinLayer.spins[index.col]:getRetCell(index.row)
	local key  = cell and cell.key or 0
	-- local theNum = cell and cell.num or 0
	local theNum = toFooter and cell.num or self:getJackpotNum(key)

	self:playMusic(self.audio_list.collect_down)  -- 播放飞的音乐
	local addNum = function ()
		if toFooter then
			self.ctl.footer:setWinCoins(theNum, self.bonus.respinWin, 0)
			self.bonus.respinWin = self.bonus.respinWin + theNum
			-- 处理
			if cell and cell.spine then
				cell.spine:removeFromParent()
				cell.spine = nil
			end
		else
			self:setStartPrizeLabel(theNum)	
			targetLizi()
		end
		
		self:laterCallBack(15/30, doNext)
	end
	
	self:laterCallBack(15/30, addNum)
end

---------------- 收集金币 End---------------------

function cls:playSAllAnimation(item ,col)
	if col > 5 then return end

	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.ScaleTo:create(26/fs,1.185),
		cc.DelayTime:create(2/fs),		
		cc.ScaleTo:create(26/fs,1),
		cc.DelayTime:create(2/fs))
	return cc.Sequence:create(animate, animate:clone())
end

function cls:playSHalfAnimation(item ,col)
	if col > 5 then return end

	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.ScaleTo:create(26/fs,1.185),
		cc.DelayTime:create(2/fs),		
		cc.ScaleTo:create(26/fs,1),
		cc.DelayTime:create(2/fs))
	return cc.Sequence:create(animate)
end

function cls:getSingleItemAnimate(item)
	local animate = cc.Sequence:create(
		-- cc.DelayTime:create(7/60),
		cc.FadeTo:create(0.01, 0),
		cc.DelayTime:create(0.5), 
		cc.FadeTo:create(0.01, 255),
		cc.DelayTime:create(0.5))
	return animate
end

function cls:getItemAnimate(item, col, row, effectStatus,parent) -- 重新给 parent  节点 不在使用draw
	
	local spineItemsSet = Set({specialSymbol["wild"],1, 2, 3, 4, 5})

	if self.showFreeSpinBoard and self.stickyWildSList and self.stickyWildSList[col] and self.stickyWildSList[col][row] then
		local item = self.stickyWildSList[col][row]
		bole.spChangeAnimation(item,"animation2",false)
	elseif self.showFreeSpinBoard and self.randWildSList and self.randWildSList[col] and self.randWildSList[col][row] then
		local item = self.randWildSList[col][row]
		bole.spChangeAnimation(item,"animation2",false)
	elseif spineItemsSet[item] then 
		if effectStatus == 'all_first' then
			self:playItemAnimation(item, col, row)
		else
			self:playOldAnimation(col,row)
		end
		return nil
	elseif (effectStatus=="all_first" or effectStatus=="all") then
		return self:playSAllAnimation(item ,col)
	else
		return self:playSHalfAnimation(item,col)	
	end
end

function cls:playItemAnimation(item, col, row) -- 修改这个方法，让有动画的symbol 在animationNode上面播放动画
	local animateName = "animation"
	local fileName = item
	if item == specialSymbol.wild then 
		fileName = specialSymbol.wild
		animateName = "animation2"
	end
	
	------------------------------------------------------------------
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos		= self:getCellPos(col,row)
	local spineFile = self:getPic("spine/item/" .. fileName .. "/spine")
	local _, s1	= self:addSpineAnimation(self.animateNode, nil, spineFile, pos, animateName, nil, nil, nil, true)

	self.animNodeList = self.animNodeList or {}
	 
	self.animNodeList[col.."_"..row] = {}
	self.animNodeList[col.."_"..row][1] = s1 
	self.animNodeList[col.."_"..row][2] = animateName
	cell:setVisible(false)
end


function cls:playOldAnimation(col,row)
	self.animNodeList = self.animNodeList or {}
	if self.animNodeList[col.."_"..row] then 
		node = self.animNodeList[col.."_"..row][1]
		animationName = self.animNodeList[col.."_"..row][2]

		if bole.isValidNode(node) and animationName then 
			bole.spChangeAnimation(node,animationName,false)
		end
	end
end

function cls:drawWaysThemeAnimate( lines, layer, rets, specials)
	local timeList = {2,2}
	Theme.drawWaysThemeAnimate(self, lines, layer, rets, specials,timeList)
end

function cls:playSymbolNotifyEffect( pCol, reelSymbolState ) 
	for  key , list in pairs(self.notifyState[pCol]) do

		for _, crPos in pairs(list) do
			local cell = nil
			if self.fastStopMusicTag then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+2)
			end
			if cell and key == specialSymbol['triger'] then 
				local animateName = "animation1"
				local fileName = key
				
				local spineFile		= self:getPic("spine/item/"..fileName.."/spine")

				local _,s = self:addSpineAnimation(cell, 22, spineFile, cc.p(0,0), animateName,nil,nil,nil,true)
				cell.sprite:setVisible(false)
				cell.symbolTipAnim = s
			end	
		end
	end
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )

	local basepCol = pCol
	local pCol = 1 + (pCol-1)%5

	self.notifyState = self.notifyState or {}
	if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then 
		return false
	end
	local ColNotifyState = self.notifyState[pCol]

	local haveSymbolLevel = 4
 	if ColNotifyState[specialSymbol["triger"]] then -- scatter
		if haveSymbolLevel >1 then
			haveSymbolLevel = 1
		end
		self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效
	elseif ColNotifyState[specialSymbol["jackpot"]["key"]] then 
		if self.showReSpinBoard then 
			local NotifyList = ColNotifyState[specialSymbol["jackpot"]["key"]]
			for k,v in pairs(NotifyList) do 
				if v[1] == basepCol then
					haveSymbolLevel = 2
					if specialSymbol["jackpot"]["key"] == 'bonus2' or specialSymbol["jackpot"]["key"] == 39 then
						haveSymbolLevel = 3
					end
					self.notifyState[pCol] = {}
				end
			end
		else
			haveSymbolLevel = 2

			if specialSymbol["jackpot"]["key"] == 'bonus2' or specialSymbol["jackpot"]["key"] == 39 then
				haveSymbolLevel = 3
			end
			-- self:playSymbolNotifyEffect(pCol)
		end

	end	

	if haveSymbolLevel<4 then 
		-- self:playMusic(self.audio_list["anticipation" .. haveSymbolLevel])
		self:playEffectWithInterval(self.audio_list["anticipation" .. haveSymbolLevel],0.1,false)
		self.notifyState[pCol] = {}
		return true
	end
end

function cls:updateCellForRespinToBase(theCellNode, key, col, row,multiple) -- respin返回base 有 multiple 的问题修改
	self:updateCellSprite(theCellNode, key, col, row)
end




---------------------------------- 声音相关 ---------------------------------------------

function cls:configAudioList( )
	Theme.configAudioList(self)

	self.audio_list = self.audio_list or {}
	-- base
	self.audio_list.common_click 	= "audio/base/btn_click.mp3" 	-- 通用点击

	self.audio_list.anticipation1  = "audio/base/symbol_scatter.mp3"    -- scatter 特殊下砸声音
	self.audio_list.anticipation2	= "audio/base/symbol_bonus1.mp3"     -- bonus1 下砸
	self.audio_list.anticipation3	= "audio/base/symbol_bonus2.mp3"     -- bonus2 下砸
	self.audio_list.free_wild_land 	= "audio/base/wild_show.mp3"	        -- wild_show


	self.audio_list.trigger         = "audio/base/trigger.mp3"  -- 收集前中的时候播放的音效
	self.audio_list.reel_notify     = "audio/base/anticipation.mp3"     -- 就是anticipation, reel_stop此音效也必须存在
	self.audio_list.special_luck    = "audio/base/jili.mp3" 	

	self.audio_list.man_show        = "audio/base/man_show.mp3"
	self.audio_list.man_move        = "audio/base/man_move.mp3"
	self.audio_list.man_hill        = "audio/base/man_hill.mp3"
	self.audio_list.man_full        = "audio/base/man_full.mp3"

	self.audio_list.change        	= "audio/base/change.mp3"
	self.audio_list.banzi_down    = "audio/base/collect_down.mp3"

	self.audio_list.unlock        	= "audio/base/unlock.mp3"
	self.audio_list.lock        	= "audio/base/lock.mp3"

	self.audio_list.transition_free 	= "audio/base/transition1.mp3"
	self.audio_list.transition_bonus   = "audio/base/transition2.mp3"
	self.audio_list.popup_out       = "audio/base/popup_out.mp3"

	--  free
	self.audio_list.free_dialog_start_show      = "audio/base/popup_in1.mp3"
	self.audio_list.free_dialog_collect_show    = "audio/base/popup_in2.mp3"
	self.audio_list.free_dialog_more_show    = "audio/base/popup_in1.mp3"
	self.audio_list.free_dialog_start_close    = "audio/base/popup_out.mp3"
	self.audio_list.free_dialog_more_close    = "audio/base/popup_out.mp3"
	self.audio_list.free_dialog_collect_click = "audio/base/btn_click.mp3"
	self.audio_list.free_dialog_collect_close    = "audio/base/popup_out.mp3"
	self.audio_list.retrigger_bell	 		= "audio/base/fg_bell.mp3"
	
	--

	-- respin
	self.audio_list.bonus_start_show      = "audio/base/popup_in3.mp3"
	self.audio_list.collect_up      = "audio/bonus/collect_up.mp3"
	self.audio_list.start_down      = "audio/bonus/start_down.mp3"
	self.audio_list.collect_down    = "audio/bonus/collect_footer.mp3"
	self.audio_list.mul             = "audio/bonus/mul.mp3"
	self.audio_list.popup_choose      = "audio/bonus/popup_choose.mp3"
	self.audio_list.num      = "audio/bonus/num.mp3"
	self.audio_list.extra_click      = "audio/bonus/click.mp3"
	-- self.audio_list.extra_show      = "audio/bonus/show.mp3"
	self.audio_list.bonus_end      = "audio/bonus/end.mp3"

	self.audio_list.full      = "audio/bonus/full.mp3"
	self.audio_list.mul_show      = "audio/bonus/mul_show.mp3"



end

function cls:getLoadMusicList()
	local loadMuscList = {
	
		self.audio_list.common_click,
		self.audio_list.anticipation1,
		self.audio_list.anticipation2,
		self.audio_list.anticipation3,
		self.audio_list.free_wild_land,

		self.audio_list.trigger ,
		self.audio_list.reel_notify,
		self.audio_list.special_luck,

		self.audio_list.banzi_down,

		self.audio_list.man_show ,
		self.audio_list.man_move ,
		self.audio_list.man_hill ,
		self.audio_list.man_full ,

		self.audio_list.change ,
		self.audio_list.collect_down ,
		self.audio_list.unlock,
		self.audio_list.lock ,
		self.audio_list.popup_out,

		self.audio_list.transition_free,
		self.audio_list.transition_bonus,

		self.audio_list.free_dialog_start_show ,
		self.audio_list.free_dialog_collect_show,
		self.audio_list.free_dialog_more_show ,
		self.audio_list.free_dialog_start_close ,
		self.audio_list.free_dialog_collect_click ,
		self.audio_list.free_dialog_collect_close ,
		self.audio_list.retrigger_bell,

		self.audio_list.bonus_start_show,
		self.audio_list.collect_up,
		self.audio_list.collect_down,
		self.audio_list.start_down ,
		self.audio_list.mul   ,
		self.audio_list.popup_choose,
		self.audio_list.num,
		self.audio_list.extra_click,
		-- self.audio_list.extra_show,
		self.audio_list.bonus_end,
		self.audio_list.full,
		self.audio_list.mul_show,
		

	}
	return loadMuscList
end


-- -- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:stopScatterEffect()
	self:playMusic(self.audio_list.free_dialog_more_show)
end	

-- 播放bonus game的背景音乐
function cls:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.bonus_background)
	AudioControl:volumeGroupAudio(1)
end

function cls:dealMusic_PlayBonusEnterMusic( )
	self:stopScatterEffect()
	self:playMusic(self.audio_list.bonus_start_show)
end

function cls:dealMusic_PlayBonusOutMusic( )
	self:stopMusic(self.audio_list.bonus_start_show)
	self:playMusic(self.audio_list.popup_choose)
end

-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack,tType)
	local function delayAction()
		local transition = MightyCashTransition.new(self,endCallBack)
		transition:play(tType)
	end	
	delayAction()
end

MightyCashTransition = class("MightyCashTransition", CCSNode)
local GameTransition = MightyCashTransition

function GameTransition:ctor(theme, endCallBack)
	self.spine = nil
	self.theme = theme
	self.endFunc = endCallBack
end

function GameTransition:play(tType)


	local spineFile = self.theme:getPic("spine/base/qieping01") -- 默认显示 Free transition
	-- if self.theme.showReSpinBoard then 
	-- 	self.theme:getPic("spine/base/qieping02") 
	-- elseif self.theme.showFreeSpinBoard then
	-- 	self.theme:getPic("spine/base/qieping01") 
	-- end
	if tType == 'free' then 
		spineFile = self.theme:getPic("spine/base/qieping01") 
	elseif tType == 'respin' then
		spineFile = self.theme:getPic("spine/base/qieping02") 
	end

	local pos = cc.p(0,0)
	local delay1 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间

	self.theme.curScene:addToContentFooter(self)
	bole.adaptTransition(self,true,true)
    self:setVisible(false) 
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    	self:setVisible(true)
    	self.theme:addSpineAnimation(self, nil, spineFile, pos, "animation")
    end),
    cc.DelayTime:create(delay1), -- 切屏动画完成时间
    cc.CallFunc:create(function ( ... )
    	if self.endFunc then 
    		self.endFunc()
    	end
    end),
    cc.RemoveSelf:create()))
end
-------------------------------Transition 结束--------------------------------------

-------------------------------Transition bonus --------------------------------------
function cls:playTransitionBonus()
	self:playMusic(self.audio_list.transition_bonus)
	self:playTransition(nil,"respin")-- 转场动画
end

function cls:playTransitionFree()
	self:playMusic(self.audio_list.transition_free)
	self:playTransition(nil,"free")-- 转场动画
end


-------------------------------Transition 结束--------------------------------------



function cls:onExit( )

	if self.bonus then
		self.bonus:onExit()
	end

	if self.shaker then
		self.shaker:stop()
	end
	Theme.onExit(self)
end

---------------------------- bonus -> respin  相关逻辑  start -------------------

MightyCashBonusGame = class("MightyCashBonusGame")
local bonusGame = MightyCashBonusGame

function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.oldCallBack 	= callback
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl

	self:saveBonus()
end

function bonusGame:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function bonusGame:enterBonusGame( tryResume )
	self.ctl.cacheSpinRet = self.ctl.cacheSpinRet or self.ctl.rets
	self.theme.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
	self.theme.allStartPrizeCoin = 0
	self.ctl.rets["oldItemList"] = tool.tableClone(self.ctl.rets["item_list"])
	-- 将startBonus设置一下
	self.theme:freshStartPrize(nil, 0)

	self:fixData(self.ctl.rets)
	-- 避免两个棋盘图片不一致导致视觉错乱
	for k,reel in ipairs(self.theme.spinLayerList[2].spins) do
		local key = self.theme.recvItemList[k][1]
		local cell = reel:currentCell()
		self.theme:updateCellSprite(cell, key, k, 1) --  修改图片
	end

	self.theme:changeSpinBoard(SpinBoardType.ReSpin)
	self.ctl.footer.isRespinLayer = true 
	

	-- self.flyParent = cc.Node:create()
	-- bole.scene:addToTop(self.flyParent)
	-- self.flyParent:setPosition(-640,-360)


	self.respinWin 	= self.ctl.totalWin
	self.ctl.totalWin = 0
	self.jackpotWinCoins = self.ctl.rets["total_win"] - self.ctl.rets["base_win"]  --  这个金币是普通的bonus的累计
	self.ctl.rets["win_type"] = nil
	self.ctl.rets["total_win"] = 0

	self.theme.winDouble = self.data.core_data["win_full"] > 0 and 2 or 1

	if self.ctl.rets.jp_win then
		self.jpwin = 0
		for k,v in pairs(self.ctl.rets.jp_win) do 
			if v and v.jp_win then
				-- local jp_win = v.jp_win * winDouble
				self.jpwin = self.jpwin + v.jp_win
			end
		end
		self.jackpotWinCoins = self.jackpotWinCoins + self.jpwin
	end

	if self.data.core_data['tree_coin'] then
		self.theme.poolCoin = self.data.core_data['tree_coin']
	end

	self.theme.runReelStopTime = 0
	for i= 1,15 do --6, 20
		self.theme:onReelStop(i, true)   -- 用来记录当前的锁定位置
	end 
	self.theme.runReelStopTime = 0.2

	self.theme:deleteAnimateAdd()

	local enterBonus = function ( ... )
		self.theme:stopDrawAnimate()
		self.bonusType = 1
	
		local respinIndex = self.data["have_respin_index"]
		local hasAdd = self.data['over_add_spins']
		--
		self.respinSum = hasAdd and self.data.core_data["theme_respin_count"] + self.data.core_data["add_spins"] or self.data.core_data["theme_respin_count"]
		-- self.ctl.rets['add_spins'] = 0
		self.respinTimes = respinIndex or 0
		-- self.theme.allStartPrizeCoin = self.data["have_prize"] or 0
	
		if respinIndex and respinIndex>0 then
			for i=1,respinIndex do
				if #self.ctl.rets.theme_respin <= 0 then
					break
				end
				self.ctl.rets.item_list = table.remove(self.ctl.rets.theme_respin,1)
			end 
		end
		self:enterRespinBonus(tryResume)
	end

	self.theme:freshStartPrize(true, self.theme.poolCoin)
	enterBonus()

end

function bonusGame:enterRespinBonus( tryResume )
	local function playIntro()
		self:addData("over_add_spins", false)  --用来判断有没有额外的spin次数
		self:addData("have_respin_index", 0)
		self:addData("have_prize", 1)  --

		self.ctl.rets["theme_respin"] 		= tool.tableClone(self.data.core_data["theme_respin"])
    	self.ctl.rets["theme_respin_count"] = tool.tableClone(self.data.core_data["theme_respin_count"])
    	self.ctl.rets["win_full"] 		    = tool.tableClone(self.data.core_data["win_full"]) 

    	self.ctl.rets["progressive_list"] 	= tool.tableClone(self.data.core_data["progressive_list"])
    	self.ctl.rets["tree_coin"]          = tool.tableClone(self.data.core_data["tree_coin"])  -- startprize的总数
    	-- self.ctl.rets['add_spins']          = 1
    	self.ctl.rets['add_spins']          = tool.tableClone(self.data.core_data["add_spins"]) or 1
    	-- self.ctl.rets['old_item_list']      = tool.tableClone(self.data.core_data["item_list"])
    	
    	-- self.theme.curReelLevel = 0
    	-- self.theme.holdCount = 0

		self:showRespinScene()
	end

	local function snapIntro() -- 重连进入
		-- 断线重连的 回调方法
		-- 暂时的方式
		local function startSpin( )
			-- 通过判断来进行操作是继续respin 还是进行收集操作
			if #self.ctl.rets.theme_respin >0 then 
				self.theme:theme_respin(self.ctl.rets)
			else 
				self.theme.respinStep = ReSpinStep.Over 
				self:onRespinStop(self.ctl.rets)
				-- self.ctl:handleResult()
			end
		end

		self.callback = function ( ... )
			-- self.ctl:handleResult()
			-- self.oldCallBack()
			local endCallFunc2 = function ( ... )
 				if self.oldCallBack then
 					self.oldCallBack()
 				end
				 if self.ctl:noFeatureLeft() then 
					self.theme.ctl.footer:setSpinButtonState(false)-- 禁掉spin按钮
	        		-- self.theme:enableAllFooterBtns(false)
	        	end
	        	self.ctl.isProcessing = false
 			end
 			endCallFunc2()
		end
		
		-- 断线重连回来默认显示 最大的声音
		-- self.theme.curReelLevel = 5
  		-- self.theme.holdCount = 15
  		self.theme.stickyAnimate:setVisible(false)
  		self.theme.randAnimate:setVisible(false)

  		self.theme:changeFloorBg(true)
  		if self.theme.curBg ~= self.theme.bonusBg then 
			self.theme.curBg:setVisible(false)
			self.theme.bonusBg:setVisible(true)
			self.theme.curBg = self.theme.bonusBg
		end

    	self:updateAllCell()
		self.ctl.footer:setWinCoins(self.respinWin,0, 0)
		startSpin()
		self.theme:dealMusic_EnterBonusGame()
	end

	if tryResume then
		snapIntro()
		self.ctl.isProcessing = true
	else
		playIntro()
	end

end

function bonusGame:updateAllCell( ... )
	for k,reel in ipairs(self.theme.spinLayer.spins) do
		local key = self.theme.recvItemList[k][1]
		local cell = reel:currentCell()
		self.theme:updateCellSprite(cell, key, k, 1) --  修改图片
	end
end

function bonusGame:showRespinScene( notInitEvent )
	self:showRespinLayer(RespinDialogType.start)
	-- self.theme.playMusic(self.theme.audio_list.bonus_start_show)\
	-- self.theme:dealMusic_PlayBonusEnterMusic()
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()	
			-- 添加过场动画
			-- self.theme:playMusic(self.theme.audio_list.transition_bonus)
			-- self.theme:playTransition(nil,"respin")-- 转场动画	
			self.theme:playTransitionBonus()
			
		end),
		cc.DelayTime:create(41/30),
		cc.CallFunc:create(function()	
			self:updateAllCell()
			self.theme.stickyAnimate:setVisible(false)
  			self.theme.randAnimate:setVisible(false)

  			-- 文字消失掉
  			self.theme.megaInfoNode:setVisible(false)
  			self.theme.superInfoNode:setVisible(false)

			self.theme:changeFloorBg(true)

			if self.theme.curBg ~= self.theme.bonusBg then 
				self.theme.curBg:setVisible(false)
				self.theme.bonusBg:setVisible(true)
				self.theme.curBg = self.theme.bonusBg
			end
	  		-- self.ctl:handleResult()
	  		-- self.theme:stopMusic(self.theme.audio_list.transition_bonus, true)
	  		self.theme:dealMusic_EnterBonusGame()
		end),

		cc.DelayTime:create(30/30),
		cc.CallFunc:create(function()	
	  		self.ctl:handleResult()
	  		-- self.theme:stopMusic(self.theme.audio_list.transition_bonus)
		end)
	))
end


function bonusGame:showRespinLayer(pType ,delay, endcallback, callback)

	callback = callback or function () end
	-- self.lock_respin_callback = callback
	if self.respinNode and bole.isValidNode(self.respinNode) then
		self.respinNode:removeFromParent()
		self.respinNode = nil
	end

	
	self.respinCsbPath 	= self.theme:getPic("csb/respin_dialog.csb")
	self.respinNode = cc.CSLoader:createNode(self.respinCsbPath)
	self.theme.curScene:addToContentFooter(self.respinNode)
	
	self.respin_root = self.respinNode:getChildByName('root')
	self.respin_start = self.respin_root:getChildByName('respin_start')
	self.respin_start:setVisible(false)

	self.start_spineNode = self.respin_start:getChildByName('spine_node')
	self.extra_respin = self.respin_root:getChildByName('extra_respin')
	self.respin_bg   = self.extra_respin:getChildByName('bg')
	self.spine_node  = self.respin_bg:getChildByName('spine_node')
	self.extraSpineDeng = self.extra_respin:getChildByName('bg_spine')
	self.startNode   = self.extra_respin:getChildByName('start')
	self.endNode     = self.extra_respin:getChildByName('end')
	self.clickNode   = self.extra_respin:getChildByName('click')

	self.spineAllNode = self.extra_respin:getChildByName('spineNode')

	self.extra_respin:setVisible(false)

	self.title_all   = {}
	self.click_all   = {}

	local pos = {-214, 4, 220}

	if self.endNode then
		for key = 1, 3 do
			local node = self.endNode:getChildByName("title"..key)
			table.insert(self.title_all, node)
		end
		self.endNode:setVisible(false)
	end

	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(self.respinCsbPath)
		self.respinNode:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end

	local updateExtraNum = function ( index, num )
		local bonus_num = 0
		local oldItemList = self.ctl.rets['oldItemList'] or {}
		if oldItemList and #oldItemList >0 then
			for col = 1, 5 do
				for row = 1, 3 do
					if oldItemList[col][row] >= 21 then
						bonus_num = bonus_num + 1
					end
				end
			end
		end

		local random = bonus_num > 7 and {2, 3, 4} or {1, 2, 3} -- 不同bonus个数展示不一致
		local ran    = 1  
		for key, val in ipairs(random) do
			if val == num then
				table.remove(random, key)
				break
			end
		end

		for key = 1, 4 do
			if not self.title_all[key] then
				return
			end
			if index == key then
				self.title_all[key]:setString(num)
			else
				self.title_all[key]:setString(random[ran])	
				ran = ran + 1
				self.title_all[key]:setColor(cc.c3b(95,95,95))
			end
			self.title_all[key]:setScale(0.1)
		end
	end

	local clickFun = function ( sender, eventType )
		if not self.canTouch then return end
		if eventType == ccui.TouchEventType.ended then
			self:playExtraNopopSpine()
	

			self.theme:playMusic(self.theme.audio_list.extra_click)
			local index = sender.index
			self.canTouch = false
			self.spine_node:setPositionX(pos[index])

			if self.spine_node then  -- 选中的效果
				self.spine_node:removeAllChildren()
				local path2 =  self.theme:getPic("spine/respin/shuzibeijing")
				self.theme:addSpineAnimation(self.spine_node, 10, path2, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)	
			end

			-- 将剩余的次数什么的增加
			local add_count = self.ctl.rets['add_spins']
			updateExtraNum(index , add_count)
			self.ctl.rets["theme_respin_count"] = self.ctl.rets["theme_respin_count"] + add_count
			self.ctl.rets['add_spins'] = 0
			self:addData("over_add_spins", true) 
			self.title_all[index]:setString(add_count)
			self.respinSum = self.ctl.rets["theme_respin_count"]

			self:playExtrapopSpine(index)
			self.startNode:setVisible(false)

			-- self.startNode:setVisible(false)
			-- self.endNode:setScale(1)
			-- for key, val

			-- self.theme:playMusic(self.theme.audio_list.extra_show)

			-- 添加
			self.endNode:runAction(cc.Sequence:create(
				-- cc.DelayTime:create(0.1),
				cc.CallFunc:create(function ( ... )
					self.endNode:setVisible(true)
					for key,val in ipairs(self.title_all) do
						val:runAction(cc.ScaleTo:create(0.3, 1))
					end
				end)))
			
			-- self:freshRespinNum(self.respinTimes,self.respinSum) 

			self.respinNode:runAction(cc.Sequence:create(
				cc.DelayTime:create(2.3),
				cc.CallFunc:create(function ( ... )
					playLine(60, 90)
					self.theme:dealMusic_PlayBonusOutMusic()
				end),
				cc.DelayTime:create(1),
				cc.CallFunc:create(function ( ... )
					self.theme:playMusic(self.theme.audio_list.num)
					-- 播放栗子效果
					self:freshRespinNum(self.respinTimes,self.respinSum) 
					self:playNumSpine()
				end),
				cc.DelayTime:create(1.5),
				cc.CallFunc:create(function ( ... )
					callback(delay, endcallback)
				end),
				cc.RemoveSelf:create()
				))
		end
	end

	if self.clickNode then
		for key = 1, 3 do
			local node = self.clickNode:getChildByName("click"..key)
			node.index = key
			node:addTouchEventListener(clickFun)
			table.insert(self.click_all, node)
		end
	end

	if pType == 1 then
		-- xmtodo 添加特效
		self.theme:dealMusic_PlayBonusEnterMusic()
		self.respin_start:setVisible(true)
		self.respinNode:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				playLine(0, 30)
				-- 添加动画
				local path2 = self.theme:getPic('spine/dialog/winzi')
				if self.start_spineNode then
					self.start_spineNode:removeAllChildren()
					self.theme:addSpineAnimation(self.start_spineNode, 10, path2, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
				end
				-- self.theme:dealMusic_PlayBonusOutMusic()
			end),
			cc.DelayTime:create(2),
			cc.RemoveSelf:create()
			))

	elseif pType == 2 then  -- 这个是额外的弹窗
		-- self.theme:playMusic(self.theme.popup_choose)
		self.theme:dealMusic_PlayBonusOutMusic()

		self.extra_respin:setVisible(true)
		self.respinNode:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				playLine(0, 30)
				local path2 = self.theme:getPic('spine/dialog/deng')
				if self.extraSpineDeng then
					self.extraSpineDeng:setLocalZOrder(10)
					self.extraSpineDeng:removeAllChildren()
					self.theme:addSpineAnimation(self.extraSpineDeng, 10, path2, cc.p(0, 0), "animation2", nil, nil, nil, true, true, nil)
				end
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self:playExtraNopopSpine(true)
				self.canTouch = true
		end)))
	end
end

function bonusGame:getJpWin(type1)
	local num = 0
	for key, val in ipairs(self.ctl.rets.jp_win) do
		if type1 == val.jp_win_type and not val.notUsed then
			-- if not val.notUsed
			val.notUsed = 1
			return val.jp_win
		end
	end
	return 0
end

function bonusGame:respinOver(ret)
	

	self.jackpotWinCoins = 0
	self.respinWin = 0

	local bonusEndDelay = 60/30
	local animationDelay = 70/30
	local animationChange = 41/30
	local animationLeft = animationDelay - animationChange

	local changeFun = function ( ... )
		if self.theme and self.theme.HoldLayer then self.theme.HoldLayer:removeAllChildren() end
		if self.theme.showFreeSpinBoard then
			self.theme:changeSpinBoard(SpinBoardType.FreeSpin) 
	
			self.theme.enterThemeSWPos = self.ctl.rets.theme_info and self.ctl.rets.theme_info.wild_pos or nil
			

			if self.theme.enterThemeSWPos then
				if FreeSpinType.mega == self.theme.freeSpinType then
					self.theme.randAnimate:setVisible(true)
					self.theme.megaInfoNode:setVisible(true)
					self.theme.randAnimate:removeAllChildren()
					-- self.theme:setRandWildSymbol(self.theme.enterThemeSWPos,true)
				else
					self.theme.stickyAnimate:setVisible(true)
					self.theme.stickyAnimate:removeAllChildren()
					self.theme.superInfoNode:setVisible(true)
					self.theme.curStickyWildList = nil
					self.theme.stickyWildSList = nil
					self.theme:setStickyWildSymbol(self.theme.enterThemeSWPos,true)
				end
			end
			self.theme.enterThemeSWPos = nil
		else
			self.theme:changeSpinBoard(SpinBoardType.Normal) 
		end
		local _itemList = table.copy(self.ctl.rets.oldItemList)
		self.theme.recvItemList = {}
	
		for col=1, 5 do
			self.theme.recvItemList[col] = {}
			for row=1,3 do
				local cell 	= self.theme.spinLayer.spins[col]:getRetCell(row)
				local key 	= _itemList[col][row]
				self.theme.recvItemList[col][row] = key
				self.theme:updateCellForRespinToBase(cell,key,col,row)
			end
		end
		self.theme:freshStartPrize(false) -- startprize 不展示

		self.theme:showAllItem()
		self.ctl:onRespinOver()
	
		self.ctl.rets["theme_respin"] = nil

	end

	local bonusEndFun = function ( ... )
		if self.theme.showFreeSpinBoard then
			self.theme:dealMusic_PlayFreeSpinLoopMusic()
		else
			self.theme:dealMusic_PlayNormalLoopMusic()
		end
		self:callback()
	end

	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(bonusEndDelay),
		cc.CallFunc:create(function ( ... )
			self.theme:deleteAnimateAdd()
			self.theme:playTransitionBonus()
		end),
		cc.DelayTime:create(animationChange),
		cc.CallFunc:create(function ( ... )
			changeFun()
		end),
		cc.DelayTime:create(animationLeft),
		cc.CallFunc:create(function ( ... )
			bonusEndFun()
		end)))

end

function bonusGame:fixData(ret)
	self.ctl.resultCache = {}	
	local respinIndex = self.data["have_respin_index"] or 0
	local now_item    = (respinIndex > 0) and self.ctl.rets['theme_respin'][respinIndex] or {}

	local itemsList = table.copy(ret.item_list)
	for i=0,14 do -- 横向拆分 和 棋盘一致
		ret.item_list[1+i] = {itemsList[1+(i%5)][1+math.floor(i/5)]}
		if #now_item > 0 and now_item[1+(i%5)][1+math.floor(i/5)] >= specialSymbol['jackpot']['value'] then
			ret.item_list[1+i] = {now_item[1+(i%5)][1+math.floor(i/5)]}
		end
 
		-- 在每一轴 拼接结果数据
		self.ctl.resultCache[1+i] = {math.random(1,10),itemsList[1+(i%5)][1+math.floor(i/5)]} --向上插入一个值 {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}-- ret["reelItem_list"][1+i] = {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}
		local col = 1+ (i-1)%5
		local symbols = self.ctl.currentReels[col] -- 获得 1-5 轴的 滚轴数据
		
		local key = math.random(1,#symbols) -- self.ctl.currentReelsIndex[1+i]%#symbols + 1
		-- local nextIndex = self.ctl.currentReelsIndex[col]
		for k = 1,6 do -- 向下插入 六个 值
			key = 1 + (key + k - 1)%#symbols
			table.insert(self.ctl.resultCache[1+i],symbols[key])
		end
	end
	self.theme.recvItemList = ret.item_list
end

function bonusGame:onRespinStart(  )
	self.theme.respinStep = ReSpinStep.Playing  -- 用来更改 不在 Start 状态
	self.respinTimes = self.respinTimes + 1
	self:addData("have_respin_index", self.respinTimes)
	self:freshRespinNum(self.respinTimes,self.respinSum) -- 更新计数
end

function bonusGame:setRespinLabel( cur,sum )
	self.theme.respinCurLabel:setString(cur)
	self.theme.respinSumLabel:setString(sum)
end

function bonusGame:freshRespinNum(cur, sum )
	-- 更新计数
	if cur <= 0 then
		-- self.theme.respinCntNode:runAction(cc.FadeTo:create(1,0))
		self.theme.respinCntNode:setVisible(false)
		self.respinSum = nil
	else
		if not self.theme.respinCntNode:isVisible() then 
			-- self.theme.respinCntNode:setOpacity(0)
			self.theme.respinCntNode:setVisible(true)
			-- self.theme.respinCntNode:runAction(cc.FadeTo:create(1,255))
		end
		self:setRespinLabel(cur,sum or self.respinSum)
	end
end

function bonusGame:playNumSpine()
	local path 	=  self.theme:getPic("spine/respin/shuzilizi")
	self.theme:addSpineAnimation(self.theme.respinSumLabel, 10, path, cc.p(16, 16), "animation", nil, nil, nil, true, nil, nil)
end

function bonusGame:playExtraNopopSpine(flag)
	if not self.spineAllNode then return end
	local allChild = self.spineAllNode:getChildren()
	local path 	=  self.theme:getPic("spine/respin/wenhaodaidianji")
	if flag then
		for key,val in ipairs(allChild) do
			val:removeAllChildren()
			self.theme:addSpineAnimation(val, 10, path, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
		end	
	else
		for key,val in ipairs(allChild) do
			val:removeAllChildren()
		end	
	end
end

function bonusGame:playExtrapopSpine(index)
	if not self.spineAllNode then return end
	local allChild = self.spineAllNode:getChildren()
	local path1 =  self.theme:getPic("spine/dialog/xuanzhongguang")
	
	for key,val in ipairs(allChild) do
		val:removeAllChildren()
		if key == index then
			self.theme:addSpineAnimation(val, 10, path1, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
		end
	end
end


function cls:freshStartPrize(flag, num)
	-- 更新所有的startPrize
	flag = flag or false
	self.startPrizeNode:setVisible(flag)
	if num then
		if num == 0 then
			self.startPrizeNum:setString('')
		else
			self.startPrizeNum:setString(FONTS.format(num,true))	
		end
	end
	bole.shrinkLabel(self.startPrizeNum, 200, 1)
end

function cls:setStartPrizeLabel( num )
	self.allStartPrizeCoin = self.allStartPrizeCoin or 0
	local winNum = self.allStartPrizeCoin
	self.startPrizeNum:nrStopRoll()-- 停止滚动
	num = num and num or 0
	self.allStartPrizeCoin = self.allStartPrizeCoin + num
	self.startPrizeNum:setString(FONTS.format(self.allStartPrizeCoin,true))
	bole.shrinkLabel(self.startPrizeNum, 200, 1)
	self.startPrizeNum:nrStartRoll(winNum, self.allStartPrizeCoin, 0.5)
end

function bonusGame:setRespinLabel( cur,sum )
	self.theme.respinCurLabel:setString(cur)
	self.theme.respinSumLabel:setString(sum)
end

function bonusGame:onRespinStop(ret)
	if self.theme.respinStep == ReSpinStep.Over then
		self.ctl.footer:setSpinButtonState(true) -- 禁用 spin 按钮
		self.ctl.footer.isRespinLayer = false
		
		local doList = {}
		local doNext = nil

		self.theme:deleteAnimateAdd()

		local parent = self.ctl.footer.labelWin:getParent()
		self:freshRespinNum(-1)
		-- self.theme:playMusic(self.theme.audio_list.bonus_end)
		self.theme:laterCallBack(1, function ( ... )
			
			for col= 1,5 do 
				for row= 1,3 do
					local index = (row-1)*5+col
					local key = self.theme.recvItemList[index][1]
					if jackpotBet[key] and self.theme.HoldLayer._added[index]then
						table.insert(doList, index)
					end
				end
			end

			doNext = function ()
				if #doList == 0 then
					self:collectOverFunc(ret)
				else
					local index = table.remove(doList, 1)
					self.theme:addJackpotToFooter(index,doNext, true, true)
				end
			end

			self.theme:playMusic(self.theme.audio_list.bonus_end)
			self.theme:stopAllLoopMusic()

			self.theme:laterCallBack(2, function ()
				if ret["win_full"] > 0 then
					-- 全部展示成两倍的数据
					self:playFullSpine()
					
					self.theme:laterCallBack(2, function ()
						local path 	=  self.theme:getPic("spine/respin/x2zi")
						self.theme:playMusic(self.theme.audio_list.mul_show)
						local pos 	=  cc.p(640,360) 
						local _, spineNode = Theme:addSpineAnimation(self.theme.HoldLayer, 100, path, pos, "animation", nil, nil, nil, true, nil, nil)
					end)
	
					self.theme:laterCallBack(3, function ()
						self.theme:fresh_board_Jbet2(2)
						self.theme:laterCallBack(1+FreshTime*15, function() 
							doNext()
						end)
					end)
				else
					
					doNext()
					
				end
			end)
			-- local isOverMuti = LoginControl:getInstance():getBonus(self.theme.themeid)["over_win_full"] or false
		end)
	end

end

function bonusGame:playFullSpine( ret )
	-- 播放集满的效果
	local path 	=  self.theme:getPic("spine/respin/jm_blz_01")
	local pos 	=  cc.p(640,360) 
	local _, spineNode = Theme:addSpineAnimation(self.theme.HoldLayer, 100, path, pos, "animation", nil, nil, nil, true, nil, nil)
	self.theme:playMusic(self.theme.audio_list.full)
end

function bonusGame:collectOverFunc( ret )
	self.theme:laterCallBack(0.5, function()   

		self.theme.lockedReels = nil
		
		if self.theme.showFreeSpinBoard or ret["free_spins"] then
			self.ctl.footer:changeLabelDescription("FS_Win")
		else
			-- 直接收集钱的操作 给用户加钱 播放动画 主要原因是因为 self.saveWin 设置的原因
			self.ctl.footer.isFreeSpin = false
			self.ctl.footer:changeLabelDescription("notFS_Win")
			self.saveWin = false
		end
	
		-- 在此之后断电重连就不用恢复了
		self.data["end_game"] = true
		self:saveBonus()
	
		-- 收钱
		self.theme.ctl:collectCoins(1)
	
		self.showReSpinBoard = false
		-- 这样做的原因是 respin 结束的时候 庆祝的是respin赢钱总金额 从base 或者free 的基础上进行 滚动
		self.ctl.totalWin = self.respinWin - self.jackpotWinCoins 
	
		local overFunc = function ( ... )
			self:respinOver(ret)
		end
		self.ctl:startRollup(self.jackpotWinCoins, overFunc)
		-- self.ctl:startRollup(self.jackpotWinCoins, overFunc)

	end)

end


function bonusGame:onExit( ... )
	
end

return ThemeMightyCash
