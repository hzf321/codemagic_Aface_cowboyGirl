
----------------------------------------------------------------------------------------------------------------------------
-- new_bonus_game
----------------------------------------------------------------------------------------------------------------------------
ThemeBaseBonusControl = class("ThemeBaseBonusControl")
local bBonusCtl = ThemeBaseBonusControl
function bBonusCtl:ctor( themeCtl, callback)
	self.themeCtl  = themeCtl	
	self.callback  = callback	
	self.theme 	   = themeCtl.theme
	self.themeid   = themeCtl.theme.themeid
	self.genPath   = themeCtl.theme:getPic("csb/")
	self:initBonusGame()
end

----------------------------------------------------------------------------------------------------------------------------
function bBonusCtl:enterBonusGame( data ,tryResume)
	local callback_copy = self.callback
	self.callback = function(...)
		--commonMusic: bonusGame返回游戏 
		--self.theme:dealMusic_ExitBonusGame()
		if self.theme.showFreeSpinBoard or self.themeCtl:isInFG() or self.theme.remainPointBet or (not self.themeCtl:noFeatureLeft()) then 
			--ss
		else
			self.theme:unlockLobbyBtn()
			self.themeCtl:removePointBet()
		end
		callback_copy(...)
	end
	self.data = {} 
	
	-- whj 添加 进行本地存储数据校验 字段存储
	if data and data.bonus_id then 
		self.theme:saveBonusCheckData(data)
		self.data.bonus_id = data.bonus_id -- todo whj 添加
	end
	----------- end 

	self.data.core_data = data
	self.dialog = self.BonusDialogList[self.themeid][1].new(self, self.theme, self.genPath, self.data, self.callback)	
	--commonMusic: 进入bonusGame 
	--self.theme:dealMusic_EnterBonusGame()
	self.dialog:enterBonusGame(tryResume)
	self.themeCtl.footer:setSpinButtonState(true) -- 设置按钮不可以点击
	self.theme:lockLobbyBtn()
end

function bBonusCtl:tryResumeBonusGame(data)
	local cacheData 			= LoginControl:getInstance():getBonus(self.themeid)

	-- whj 添加 进行本地存储数据校验
	if cacheData == nil or cacheData.bonus_id == nil or (data and cacheData and cacheData.bonus_id ~= data.bonus_id) then 
		self.theme:cleanBonusSaveData()
		if data and data.bonus_id then 
			self.theme:saveBonusCheckData(data)
		end
		cacheData = LoginControl:getInstance():getBonus(self.themeid)
	end
	----------- end 

	self.resumeBonusGameCoins 	= 0

	if cacheData == nil then
		-- 如果数据未保存就退出重连，按重新进入游戏处理
		self:enterBonusGame(data,true)
	else
		-- 如果数据保存，但bonus未结束
		if not cacheData["end_game"] then
			self.data 	= cacheData
			self.data.core_data = data

			local callback_copy = self.callback
			self.callback = function(...)
				--commonMusic: bonusGame返回游戏 
				self.theme:dealMusic_ExitBonusGame()
				if self.theme.showFreeSpinBoard or self.themeCtl:isInFG() or self.theme.remainPointBet or (not self.themeCtl:noFeatureLeft()) then -- remainPointBet 判断是否需要解锁主题锁定Bet及回大厅，如choose Bonus需要一直锁定Bet直到Respin或Free结束
					-- 
				else
					self.theme:unlockLobbyBtn()
					self.themeCtl:removePointBet()
				end
				callback_copy(...)
			end

			self.dialog = self.BonusDialogList[self.themeid][1].new(self, self.theme, self.genPath, self.data, self.callback)
			--commonMusic: 进入bonusGame 
			--self.theme:dealMusic_EnterBonusGame()
			self.dialog:enterBonusGame(true) -- 断线重连
			self.theme:lockLobbyBtn()
		else
			if self.callback then self.callback() end
			if self.theme.overBonusByEndGame then self.theme:overBonusByEndGame(data) end-- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面

			-- 收钱
			if self.theme.ctl.collectCoins then self.theme.ctl:collectCoins(1) end					
		end

	end
end

function bBonusCtl:directCollectResumeCoins( )
	if self.resumeBonusGameId and self.resumeBonusGameCoins then
		User:getInstance():addCoins(self.resumeBonusGameCoins)
	end
	if self.callback then
		self.callback()
	end
end
function bBonusCtl:onResumeDialogClick( index )
	if index == 1 then
		self.dialog = self.BonusDialogList[self.themeid][1].new(self, self.theme, self.genPath, self.data, self.callback)	
		self.dialog:resumeBonusGame()
	elseif index == 0 then
		self:directCollectResumeCoins()
	end
end
function bBonusCtl:onDialogClick( index, btn )
	-- todo
end
function bBonusCtl:startBonusScene( )
	-- todo
end
function bBonusCtl:onBonusGameFinished( data )
	-- todo
end
function bBonusCtl:exit( btn, noFlyCoins )
	-- todo
end


