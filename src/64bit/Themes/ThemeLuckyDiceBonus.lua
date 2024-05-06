
local sequenceAction       = libUI.sequenceAction
local delayTimeAction      = libUI.delayTimeAction
local callFuncAction       = libUI.callFuncAction
local scaleToAction        = libUI.scaleToAction
local repeatAction         = libUI.repeatAction
local playSpineAnimation   = libUI.playSpineAnimation
local moveToAction         = libUI.moveToAction

-- Create class
local parentClass = Theme
ThemeLuckyDiceBonus = class("ThemeLuckyDiceBonus", parentClass)

local customizedTheme = ThemeLuckyDiceBonus

customizedTheme.csbList = 
{
	"csb/base.csb",
}

local dice_win_config = 
{
	1,2,5,10,15,20,50,100,500
}

function customizedTheme:ctor(themeid)
    local use_portrait_screen = false
	local ret = parentClass.ctor(self, themeid, use_portrait_screen)
    return ret
end

-- 配置场景
function customizedTheme:initScene(spinNode)

	self.csb = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(self.csb)
	self.shakyNode:addChild(self.mainThemeScene)

	bole.adaptScale(self.mainThemeScene,false)

	local background = self.mainThemeScene:getChildByName("background")
	self.jp_anim = background:getChildByName("jp_anim")
	self.board_anim = background:getChildByName("board_anim")

	self.dimmer = self.mainThemeScene:getChildByName("dimmer_node")
	self.dimmer:setVisible(false)

	self.reelRoot = self.mainThemeScene:getChildByName("Node_root_node")
	self.dice_root = self.reelRoot:getChildByName("dice_root")
	self.dice_table = self.dice_root:getChildren()
	self.anim_node = self.reelRoot:getChildByName("anim_node")

	self.JP_node = self.mainThemeScene:getChildByName("JP_node")
	self.jp_table = self.JP_node:getChildren()

	self.btnPlay = self.mainThemeScene:getChildByName("btn_play")
	self:ableBtnPlay()

	self.totalWin = self.mainThemeScene:getChildByName("top_message_node")
	self.label_win = self.totalWin:getChildByName("label_win")
	self.top_anim = self.totalWin:getChildByName("top_anim")
	self.before_node = self.totalWin:getChildByName("before_node")
	self.before_table = self.before_node:getChildren()
	inherit(self.label_win, LabelNumRoll)
	local function fontFormat1(num)
        return FONTS.format(num,true)
	end
	self.label_win:nrInit(0, 25, fontFormat1)

	self.collectNode = self.mainThemeScene:getChildByName("win_node")
	self.total_win = self.collectNode:getChildByName("label_win")
	self.btn_collect = self.collectNode:getChildByName("btn_collect")
	self.collectNode:setVisible(false)
	inherit(self.total_win, LabelNumRoll)
	local function fontFormat2(num)
        return FONTS.format(num,true)
	end
	self.total_win:nrInit(0, 25, fontFormat2)

	self.finishNode = self.mainThemeScene:getChildByName("finish_node")
	self.finishNode:setVisible(false)

	self.mul_anim = self.mainThemeScene:getChildByName("anim_node")

	self.ctl.footer:hideFooter()
    EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_QUIET)
	self.ctl.footer:displayDashboard(false)

end

function customizedTheme:ableBtnPlay()
	self.btnPlay:setBright(true)
	self.btnPlay:runAction(sequenceAction(
	scaleToAction(0.12, 0.0001),
	scaleToAction(0.17, 1.2),
	scaleToAction(0.07, 0.9),
	scaleToAction(0.07, 1),
	callFuncAction(function ( ... )
		self.btnPlay:setTouchEnabled(true)
	end)
	))
end

function customizedTheme:disableBtnPlay()
	self.btnPlay:setTouchEnabled(false)
	self.btnPlay:runAction(sequenceAction(
	delayTimeAction(0.2),
	scaleToAction(0.08, 1.2),
	scaleToAction(0.17, 0.001)))
end

function customizedTheme:onInitConfig()

end

function customizedTheme:initSpinLayer( )
	
end

function customizedTheme:refreshColCellsZOrder()

end

function customizedTheme:saveBonusCheckData(bonusData)
    -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
    local data = {}
    data["bonus_id"] = bonusData.bonus_id
    LoginControl:getInstance():saveBonus(self.themeid, data)
end

function customizedTheme:cleanBonusSaveData(data)
    -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
    LoginControl:getInstance():saveBonus(self.themeid, nil)
end

LuckyDiceBonusGame = class("LuckyDiceBonusGame")
local BSGame = LuckyDiceBonusGame

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.theme.bonus 	= self 
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.ctl 			= bonusControl.themeCtl
	self.niceTable      = {}

	-- 数据处理
	self.currentBet = self.data.core_data["bet"]
	self.middle_mul = self.data.core_data["multi"] or 1
	self.reSpinData = self.data.core_data["theme_respin_list"]
	self.centerData = self.data.core_data["center_dice_list"]
	self.endWinData = self.data.core_data["total_win_list"]

	-- self:setTestData() -- 测试数据

	self.coins_win = 0
	for i=1, #self.endWinData do
		self.coins_win = self.coins_win + self.endWinData[i]
	end 

	self:initBeforeLabel()

	self:saveBonus()

    self.jp_number = {} -- 存储各个JP的数值

    self:initDice() -- 初始化骰子的状态

    self:initBtnPlay()

    if self.data["pointer_row"] and self.data["pointer_col"] then
		self.pointer_row = self.data["pointer_row"]
		self.pointer_col = self.data["pointer_col"]
	else
		self.no_cache_data = true
		self.pointer_row = 1
		self.pointer_col = 2
    end

    self:initJPNode()

    self:reConnectionData() -- 处理断线重连的各种情况

    self:playBigJPAnim()

    self:playBoardAnim()


end

function BSGame:initBeforeLabel()
	self.theme.before_node:setVisible(false)
	for i=1, #self.endWinData - 1 do
		local label = self.theme.before_table[i]:getChildByName("before_label")
		label:setString(FONTS.format(self.endWinData[i], true))
		bole.shrinkLabel(label, 220, 0.44)
	end 
end

function BSGame:refreshBeforeWinNode()
	if not self.theme.before_node:isVisible() then
		self.theme.before_node:setVisible(true)
	end
	local node_pos = {-58, -78, -98}
	if self.pointer_row > 1 then
		self.theme.before_node:runAction(moveToAction(1, cc.p(self.theme.before_node:getPositionX(), node_pos[self.pointer_row - 1])))
	else
		self.theme.before_node:setVisible(false)
	end
end

function BSGame:saveBonus()
 	if self.pointer_row then
		self.data["pointer_row"] = self.pointer_row
	end
	if self.pointer_col then
		self.data["pointer_col"] = self.pointer_col
	end
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:initJPNode()
	for i=1, #self.theme.jp_table do
		local mul = self.theme.jp_table[i]:getChildByName("mul")
		local total = self.theme.jp_table[i]:getChildByName("total")
		mul:setString(i-1)
		self.jp_number[i] = dice_win_config[i] * self.currentBet
		total:setString(FONTS.format(self.jp_number[i], true))
		bole.shrinkLabel(total, 250, 1)
	end

	self:playJPItemAnim(0)

	self.theme.label_win:setString("")

end

function BSGame:initDice()
	self.niceTable      = {}
	for i=1, #self.theme.dice_table do
		self:playInitSpine(self.theme.dice_table[i])
	end
end

function BSGame:updataDice()
	local dice_data = self:getDiceData(self.pointer_row, self.pointer_col)
	self:isDiceHas(self.pointer_row, self.pointer_col)
	if dice_data then
		self.pointer_col = self.pointer_col + 1
		local number = 0
		local index = 1
		local scrollList = {}
		local tempIndex = 1
		for i = 1,8 do
			if dice_data[i] == 1 then
				number = number + 1
				if not self.niceTable[i] then
					scrollList[tempIndex] = i
					tempIndex = tempIndex + 1
					self.niceTable[i] = true
				end
			else
				scrollList[tempIndex] = i
				tempIndex = tempIndex + 1
			end
		end
		local temp_data = 0 
		local start_pos = 0
		local end_pos = 0
		for i =1, 8 do
			if self.niceTable[i] == true then
				start_pos = start_pos + 1
			end
		end
		self.theme:runAction(sequenceAction(
		callFuncAction(function ( ... )
			self.theme:playMusic(self.theme.audio_list.bonus_play_dice, false, true)
		end),

		delayTimeAction(0.5),
		repeatAction(sequenceAction(
			callFuncAction(function ( ... )
				local cIndex = scrollList[index]
				self:playRoundSpine(self.theme.dice_table[cIndex], 2-dice_data[cIndex], 1)
				index = index +1
			end),
			delayTimeAction(0.2)), #scrollList),
		callFuncAction(function ( ... )
			if self.jp_number and self.jp_number[number+1] then
				temp_data = temp_data + self.jp_number[number+1]
			end
			self.theme:stopMusic(self.theme.audio_list.bonus_play_dice)
		end),
		delayTimeAction(2.17),
		callFuncAction(function ( ... )
			self.middle_auto = false
			if self.reSpinData and self.reSpinData[self.pointer_row] and #self.reSpinData[self.pointer_row] < self.pointer_col and self.no_cache_data then

				self.theme:runAction(sequenceAction(
					callFuncAction(function ( ... )
						self:playTopWinAnim()	
					end),
					delayTimeAction(0.83),
					callFuncAction(function ( ... )
						if self.cWinAnimation then
							self.cWinAnimation:removeFromParent()
							self.cWinAnimation = nil
							self.cWinIndex = nil
						end
					end)))


				self.theme:playMusic(self.theme.audio_list.bonus_play_dice_end)	
				self.theme.label_win:setString(FONTS.format(temp_data))
				bole.shrinkLabel(self.theme.label_win, 235, 0.9)
				self.theme.label_win:setString("")
				self.theme.label_win:nrStartRoll(0,temp_data,2)
				self.middle_auto = true
			end

			for i =1, 8 do
				if self.niceTable[i] == true then
					end_pos = end_pos + 1
				end
			end

			self:playJPItemAnim(end_pos)


		end),
		delayTimeAction(2),
		callFuncAction(function ( ... )
			if self.middle_auto then
				self:isDiceHas(self.pointer_row, self.pointer_col)
				self:playMiddleDice()
			end
		end)
		))
	end
end

function BSGame:playMiddleDice(reconnection)

	if reconnection then
		local temp_data = self.endWinData[self.pointer_row]
		if self.hasDiceMul then
			temp_data = self.endWinData[self.pointer_row]/self.middle_mul
		end
		self.theme.label_win:setString(FONTS.format(temp_data, true))
		bole.shrinkLabel(self.theme.label_win, 235, 0.9)
	end

	if self.hasDiceMul then
		self.hasDiceMul = false

		local temp_data = 0
		local end_data = 0

		self.theme:runAction(sequenceAction(
		callFuncAction(function ( ... )
			self.theme:playMusic(self.theme.audio_list.bonus_play_dice)
			self:playMiddleSpine(self.theme.dice_table[9], 5, 1, false, false, true)
		end),
		delayTimeAction(2.17),
		callFuncAction(function ( ... )
			self:playMiddleSpine(self.theme.dice_table[9], 5, 2, true, false, true)
			local _, s = bole.addSpineAnimation(self.theme.dice_table[9], nil, self.theme:getPic("spine/dice_7/spine"), cc.p(0, 0), "animation1", nil, nil, nil, true, false, nil)
			self.middle_mul_light = s
			self:playMiddleSpine(self.theme.dice_table[9], 6, self.middle_mul, true, false, false)
			self.theme:playMusic(self.theme.audio_list.bonus_middle_res)	
		end),
		delayTimeAction(1),
		callFuncAction(function ( ... )

			bole.spChangeAnimation(self.middle_mul_light,"animation2",true)
			temp_data = self.endWinData[self.pointer_row]/self.middle_mul
			end_data = self.endWinData[self.pointer_row]

			self.pointer_row = self.pointer_row + 1
			self.pointer_col = 2

		end),
		delayTimeAction(1),
		callFuncAction(function ( ... )
			self:playMiddleSpine(self.theme.mul_anim, 8, "", false, false, false)
		end),
		delayTimeAction(1),
		callFuncAction(function ( ... )

			self.theme.label_win:setString(FONTS.format(end_data,true))
			bole.shrinkLabel(self.theme.label_win, 235, 0.9)
			self.theme.label_win:setString(FONTS.format(temp_data,true))
			self.theme.label_win:nrStartRoll(temp_data,end_data,2)

		end),
		delayTimeAction(2),
		callFuncAction(function ( ... )
			self:showCollectNode()
		end)
		))
	elseif self.again_number then

		self.theme:runAction(sequenceAction(
		callFuncAction(function ( ... )
			self.theme:playMusic(self.theme.audio_list.bonus_play_dice)
			self:playMiddleSpine(self.theme.dice_table[9], 3, 1, true, false, true)
		end),
		delayTimeAction(2.17),
		callFuncAction(function ( ... )
			self.theme:playMusic(self.theme.audio_list.bonus_middle_res)	
		end),
		delayTimeAction(1),
		callFuncAction(function ( ... )
			self:playMiddleSpine(self.theme.anim_node, 9, "", false, false, true)	
		end),
		delayTimeAction(0.4),
		callFuncAction(function ( ... )
			self:initDice()
			self:playJPItemAnim(0)
			self:refreshBeforeWinNode()
			self.theme.label_win:setString("")
			self.again_number = false
			self.theme:ableBtnPlay()
		end)
		))

		self.pointer_row = self.pointer_row + 1
		self.pointer_col = 2

	elseif self.blank_dice then
		self.hasDiceMul = false
		self.theme:playMusic(self.theme.audio_list.bonus_play_dice)
		self:playMiddleSpine(self.theme.dice_table[9], 4, 1, true, false, true)

		self.pointer_row = self.pointer_row + 1
		self.pointer_col = 2

		self.theme:runAction(sequenceAction(
		delayTimeAction(3),
		callFuncAction(function ( ... ) 
				self:showCollectNode()
		end)))

	end
end

function BSGame:initBtnPlay()
	local function playFunc()
		self.theme:disableBtnPlay()   

		self:saveBonus()
		self:updataDice()

		self.theme:runAction(sequenceAction(
			delayTimeAction(5),
			callFuncAction(function ( ... )
				if not self.middle_auto then
					self.theme:ableBtnPlay()
				end
			end)))
	end
	self.theme.btnPlay:addTouchEventListener(playFunc)
end

function BSGame:showCollectNode()
	self.theme.collectNode:setScale(0)
	self.theme.collectNode:setVisible(true)
	self.theme.dimmer:setOpacity(0)
	self.theme.dimmer:setVisible(true)
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function( ... )
			local rollupDuration = 2

			self.theme.total_win:setString(FONTS.format(self.coins_win, true))	
			bole.shrinkLabel(self.theme.total_win, 620, 0.6)
			self.theme.total_win:setString(FONTS.format(0, true))
			self.theme.total_win:nrStartRoll(0,self.coins_win,rollupDuration)	

			self.theme.collectNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.25,1.2,1.2),
				cc.ScaleTo:create(0.15,1,1)
			))		
			self.theme.dimmer:runAction(cc.FadeIn:create(0.3))	
			self.theme:stopAllLoopMusic()
			self.theme:playMusic(self.theme.audio_list.bonus_collect)	
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function( ... )
			self:initCollectAllEvent()
			-- 在此之后断电重连就不用恢复了
			self.data["end_game"] = true
			self:saveBonus()
			LoginControl:getInstance():saveBonus(self.theme.themeid, nil)

			-- 收钱
			self.theme.ctl:collectCoins(1)
		end)
	))

end

function BSGame:initCollectAllEvent()
	local function collectFunc()
		self.theme.btn_collect:setBright(false)
	    self.theme.btn_collect:setTouchEnabled(false)
	    self.theme.collectNode:setScale(1)
		self.theme.collectNode:setVisible(true)
		self.theme.dimmer:setOpacity(255)
		self.theme.dimmer:setVisible(true)
		self.theme.total_win:nrStopRoll()
		self.theme.total_win:setString(FONTS.format(self.coins_win, true))
		bole.shrinkLabel(self.theme.total_win, 620, 0.6)

		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function( ... )
				local user = User:getInstance()
		        user:addCoins(self.coins_win)
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function( ... )				
				self.theme.collectNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.15,1.5,1.5),
					cc.ScaleTo:create(0.25,0,0)
				))
				self.theme.dimmer:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function( ... )
				self.theme.finishNode:setOpacity(0)
				self.theme.finishNode:setVisible(true)
				self.theme.finishNode:runAction(cc.FadeIn:create(0.3))
			end),
			cc.DelayTime:create(2),
		    cc.CallFunc:create(function()
				ActivityBController:getInstance():exitMiniGame(ACTIVITY_B.BLAST)
		    end)
		))
	end
	self.theme.btn_collect:addTouchEventListener(collectFunc)
end

function BSGame:isDiceHas(row, col)
	if #self.reSpinData < row then
		return false
	end
	if #self.reSpinData[row] < col then
		if self.centerData[row] == 0 then
			self.blank_dice = true
		end
		if self.centerData[row] == 1 then
			self.again_number = true
		end
		if self.centerData[row] == 2 then
			self.hasDiceMul = true
		end
	end
	return true
end

function BSGame:getDiceData(row, col)
	if self.reSpinData and self.reSpinData[row] and self.reSpinData[row][col] then
		return self.reSpinData[row][col]
	end
	return nil
end

function BSGame:reConnectionData()
	if not self.no_cache_data then -- 如果有断线
    	self.no_cache_data = true
    	if self.reSpinData and self.reSpinData[self.pointer_row] and self.pointer_col <= #self.reSpinData[self.pointer_row] then -- 周围的八个骰子断线重连
	    	local dice_data = self:getDiceData(self.pointer_row, self.pointer_col)

	    	self.pointer_col = self.pointer_col + 1
			local number = 0
			for i=1, #self.theme.dice_table do
				if dice_data[i] == 1 then
					number = number + 1
					self:playRoundSpine(self.theme.dice_table[i], 1, 2)
					self.niceTable[i] = true
				else
					self:playRoundSpine(self.theme.dice_table[i], 2, 2)
				end
			end

			self:playJPItemAnim(number)

			self.theme.label_win:setString("")

			if self.pointer_col - 1 == #self.reSpinData[self.pointer_row] then
				self:refreshBeforeWinNode()
				self.theme:disableBtnPlay()
				self:isDiceHas(self.pointer_row, self.pointer_col)
				self:playMiddleDice(true)

				self.theme:runAction(sequenceAction(
				delayTimeAction(3),
				callFuncAction(function ( ... ) 
					if not self:isDiceHas(self.pointer_row, self.pointer_col - 1 ) then
						self:showCollectNode()
						return
					end
				end)))
			else
				self:refreshBeforeWinNode()
	    	end
	    else
			self.pointer_col = 2
			self.pointer_row = 1
	    end
	end
end

function BSGame:playInitSpine(node)
	if node then
		node:removeAllChildren()
		bole.addSpineAnimation(node, nil, self.theme:getPic("spine/dice_2/spine"), cc.p(0, 0), "animation2", nil, nil, nil, true, false, nil)
	end
end

function BSGame:playRoundSpine(node, index, anim_index)
	if node then
		node:removeAllChildren()
		bole.addSpineAnimation(node, nil, self.theme:getPic("spine/dice_" .. index .. "/spine"), cc.p(0, 0), "animation" .. anim_index, nil, nil, nil, true, false, nil)
	end
end

function BSGame:playMiddleSpine(node, index, anim_index, retain, loop, removeChild)
	if node then
		if removeChild then
			node:removeAllChildren()
		end
		bole.addSpineAnimation(node, nil, self.theme:getPic("spine/dice_" .. index .. "/spine"), cc.p(0, 0), "animation" .. anim_index, nil, nil, nil, retain, loop, nil)
	end
end

function BSGame:playBigJPAnim()
	if self.theme.jp_anim then
		bole.addSpineAnimation(self.theme.jp_anim, nil, self.theme:getPic("spine/board_2/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
	end
end

function BSGame:playBoardAnim()
	if self.theme.board_anim then
		bole.addSpineAnimation(self.theme.board_anim, nil, self.theme:getPic("spine/board_1/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
	end
end

function BSGame:playTopWinAnim()
	if self.theme.top_anim then
		bole.addSpineAnimation(self.theme.top_anim, nil, self.theme:getPic("spine/top_win/spine"), cc.p(0, 0), "animation", nil, nil, nil, false, false, nil)
	end
end

function BSGame:playJPItemAnim(end_pos)
	if not self.cWinIndex then
		self.cWinIndex = 0
		if not self.cWinAnimation then
			local jp_anim = self.theme.jp_table[end_pos+1]:getChildByName("jp_anim")
			local _,s = bole.addSpineAnimation(jp_anim, nil, self.theme:getPic("spine/jp_common/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
			self.cWinAnimation = s
		end
	end
	if self.cWinIndex ~= end_pos then
		if self.cWinAnimation then
			self.cWinAnimation:runAction(cc.Sequence:create(cc.FadeOut:create(0.3),cc.RemoveSelf:create()))
		end
		
		self.cWinIndex = end_pos
		local temp_node = self.theme.jp_table[end_pos+1]:getChildByName("jp_anim")
		if end_pos == 8 then
			local _,s = bole.addSpineAnimation(temp_node, nil, self.theme:getPic("spine/jp_big/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
			self.cWinAnimation = s
		else
			local _,s = bole.addSpineAnimation(temp_node, nil, self.theme:getPic("spine/jp_common/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
			self.cWinAnimation = s
		end
		self.theme:playMusic(self.theme.audio_list.bonus_jp_change)

	end
end

function BSGame:enterBonusGame()
	self.theme:playLoopMusic(self.theme.audio_list.bonus_background)
end

function BSGame:setTestData()

	-- 2
	-- self.centerData = {[1] = 2}

	-- self.currentBet = 1285000

	-- self.endWinData = {[1] = 5140000}

	-- self.reSpinData = {[1] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
	-- 						  [2] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
	-- 						  -- [3] = {[1] = 0,[2] = 0,[3] = 0,[4] = 1,[5] = 0,[6] = 0,[7] = 0,[8] = 0}
	-- 						 }
	-- 				  }


	-- 1 2
	self.centerData = {[1] = 1,[2] = 1,[3]=1,[4]=2}

	self.currentBet = 259925000

	self.endWinData = {[1] = 519850000,[2] = 25992500000,[3]=519850000,[4]=519850000}

	self.reSpinData = {[1] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [2] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [3] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0}
							 },
					   [2] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [2] = {[1] = 0,[2] = 1,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [3] = {[1] = 0,[2] = 1,[3] = 0,[4] = 0,[5] = 0,[6] = 1,[7] = 1,[8] = 0},
							  [4] = {[1] = 0,[2] = 1,[3] = 1,[4] = 0,[5] = 0,[6] = 1,[7] = 1,[8] = 0},
							  [5] = {[1] = 0,[2] = 1,[3] = 1,[4] = 0,[5] = 0,[6] = 1,[7] = 1,[8] = 1},
							  [6] = {[1] = 1,[2] = 1,[3] = 1,[4] = 0,[5] = 0,[6] = 1,[7] = 1,[8] = 1},
							  [7] = {[1] = 1,[2] = 1,[3] = 1,[4] = 0,[5] = 0,[6] = 1,[7] = 1,[8] = 1},
							 },
						[3] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [2] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [3] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0}
							 },
						[4] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [2] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
							  [3] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0}
							 },
					  }

	self.data["pointer_row"] = 2
	self.data["pointer_col"] = 8

	-- 1 0
	-- self.centerData = {[1] = 1,[2] = 0}

	-- self.currentBet = 1285000

	-- self.endWinData = {[1] = 2570000,[2] = 6425000}

	-- self.reSpinData = {[1] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
	-- 						  [2] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
	-- 						  [3] = {[1] = 1,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0}
	-- 						 },
	-- 				   [2] = {[1] = {[1] = 0,[2] = 0,[3] = 0,[4] = 0,[5] = 0,[6] = 0,[7] = 0,[8] = 0},
	-- 						  [2] = {[1] = 0,[2] = 0,[3] = 0,[4] = 1,[5] = 1,[6] = 0,[7] = 0,[8] = 0},
	-- 						  [3] = {[1] = 0,[2] = 0,[3] = 0,[4] = 1,[5] = 1,[6] = 0,[7] = 0,[8] = 0},
	-- 						 }
	-- 				  }


end

---------------------------声音相关----------------------------------------------

function customizedTheme:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	-- bonus
	self.audio_list.bonus_background      = "audio/bonus/bonus_bgm.mp3"
	self.audio_list.bonus_collect         = "audio/bonus/bonus_collect.mp3"	
	self.audio_list.bonus_jp_change       = "audio/bonus/bonus_jp_change.mp3"
	self.audio_list.bonus_middle_res      = "audio/bonus/bonus_middle_res.mp3"
	self.audio_list.bonus_play_dice_end   = "audio/bonus/bonus_play_dice_end.mp3"
	self.audio_list.bonus_play_dice       = "audio/bonus/bonus_play_dice.mp3"
	
end

function customizedTheme:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.bonus_background,  
		self.audio_list.bonus_collect,      
		self.audio_list.bonus_jp_change,    
		self.audio_list.bonus_middle_res,   
		self.audio_list.bonus_play_dice_end,
		self.audio_list.bonus_play_dice,    
	}
	return loadMuscList
end

---------------------------------断线重连相关-----------------------------------------

function customizedTheme:showBonusNode( )
	self.ctl:resetCurrentReels(false,true) -- 更改 bonus 的棋盘
end

function customizedTheme:hideBonusNode(free,bonus)
	self.ctl:resetCurrentReels(free,bonus) -- 更改 bonus 的棋盘
end

function customizedTheme:adjustEnterThemeRet(data)

	data.theme_reels = {
		["main_reel"] = {
			[1] = {0,0,21,22,0,23,25,0,21,29,0,21,30,0,21,0,34,21,0,0,36,0,21,21,0,0},
			[2] = {0,22,0,21,0,21,25,0,21,29,0,21,21,0,30,0,21,21,0,0,21,0,21,21,0,0},
			[3] = {24,0,22,21,0,23,21,0,30,21,0,25,0,21,22,0,21,24,0,0,22,0,21,38,0,0},
			[4] = {0,0,21,22,0,21,25,0,21,29,0,30,21,0,21,0,21,21,0,0,0,21,35,0,21,0},
			[5] = {0,0,21,22,0,23,21,0,21,29,0,21,21,0,0,21,23,21,0,0,23,0,21,23,0,0}
		},
		["bonus_reel"] = {
			[1] = {0,0,21,22,0,23,25,0,21,29,0,21,30,0,21,0,34,21,0,0,36,0,21,21,0,0},
			[2] = {0,22,0,21,0,21,25,0,21,29,0,21,21,0,30,0,21,21,0,0,21,0,21,21,0,0},
			[3] = {24,0,22,21,0,23,21,0,30,21,0,25,0,21,22,0,21,24,0,0,22,0,21,38,0,0},
			[4] = {0,0,21,22,0,21,25,0,21,29,0,30,21,0,21,0,21,21,0,0,0,21,35,0,21,0},
			[5] = {0,0,21,22,0,23,21,0,21,29,0,21,21,0,0,21,23,21,0,0,23,0,21,23,0,0}
		},		
	}

	return data
end

--断线重连
function customizedTheme:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

return ThemeLuckyDiceBonus
