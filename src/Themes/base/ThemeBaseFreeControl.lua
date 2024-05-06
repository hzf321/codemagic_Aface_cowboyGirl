

ThemeBaseFreeControl = class("ThemeBaseFreeControl", ThemeBaseViewControlDelegate)
local cls = ThemeBaseFreeControl

function cls:ctor(_mainViewCtl)
	self._mainViewCtl = _mainViewCtl

	self.node = cc.Node:create()
	self._mainViewCtl:getCurScene():addToContent(self.node)
	
	self.audioCtl = self._mainViewCtl:getAudioCtl()

	self.gameConfig = self:getGameConfig()

	self.freewin 		= nil
	self.freespin 		= nil
	self.freeItem 		= nil 
	self.freeSpeical 	= nil
end

function cls:initLayout( nodesList )
	-- self._view = ThemeLuckyBee_CollectFreeCntView.new(self, nodesList)
end

function cls:freeStopCtl( stopRet ) -- stopRet 数据解析
	self:checkStopCtlSpecialFreeData(stopRet)
	
	if stopRet.free_spins and stopRet.free_game and (not self:isInFG()) then
		if stopRet.free_game.free_random_pick then 
			stopRet.free_random_pick = tool.tableClone(stopRet.free_game.free_random_pick)
			stopRet.free_spins = nil
		end
	end
end

function cls:checkStopCtlSpecialFreeData( stopRet )

end

function cls:checkDealSpecialFreeData( data )

end

function cls:dealFreeGameResumeRet( data )
	if data["free_game"] then 
		self.fgType = data["free_game"]["fg_type"]
		self:checkDealSpecialFreeData(data)
		if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
			if data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then 
				data["first_free_game"] = tool.tableClone(data["free_game"])

				data["free_game"] = nil
			elseif data["free_game"]["item_list"] then 
				local realItemList = data["free_game"]["item_list"]
				data["free_game"]["item_list"] = tool.tableClone(realItemList)
				self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
			end
		end
	end
end

-- function cls:checkHasAvgBet( ... )
--     return self.fgAvgBet
-- end

function cls:getFreeType()
	return self.fgType
end

-- function cls:enterPickGame() -- 需要free pick的主题，自己进行方法的重写
	
-- end

function cls:updateFreeCntCacheBySpin( )
	if self.freewin then
		self.free_spins_cache_cnt = self.free_spins_cache_cnt or 0
		self.free_spins_cache_cnt = self.free_spins_cache_cnt + 1
	else
		self.free_spins_cache_cnt = 0
	end
end

function cls:updateFreeSpinCntBySpin( ... )
	self.freespin = self.freespin - 1
end

function cls:updateFreeWin( win, isAdd )
	if self.freewin then 
		if isAdd then 
			self.freewin = (self.freewin or 0) + win
		else	
			self.freewin = win
		end
	end
end

function cls:isFGEnd( ... )
	return not self.freespin or self.freespin < 1
end

function cls:hasFGCnt( ... )
	return self:isInFG() and self.freespin and self.freespin > 0
end

function cls:getFGCnt( ... )
	return self.freespin
end

function cls:isInFG()
	return self.freewin
end

function cls:updateScatterWin( winCoins )
	self.scatter_spin_winCoins = self.scatter_spin_winCoins or 0
	self.scatter_spin_winCoins = self.scatter_spin_winCoins + winCoins
end

function cls:getResumeData( ... )
	return self.freeRet, self.freeSpeical
end


-- function cls:getFreeSpeicalData( ... )
-- 	return self.freeSpeical
-- end

------ free 弹窗
function cls:playStartFreeSpinDialog( theData )
	
	self._mainViewCtl:stopAllLoopMusic()
	if self._mainViewCtl.setFeatureState then 
		self._mainViewCtl:setFeatureState(self.gameConfig.FeatureName.Free, true)
	end

	if theData.enter_event then 
		theData.enter_event()
	end

	if theData.click_event then 
		theData.click_event()
	end

	if theData.changeLayer_event then 
		theData.changeLayer_event()
	end

	if theData.end_event then 
		theData.end_event()
	end

end

function cls:playMoreFreeSpinDialog( theData )

	if theData.enter_event then 
		theData.enter_event()
	end

	if theData.click_event then 
		theData.click_event()
	end

	if theData.end_event then 
		theData.end_event()
	end
end

function cls:playCollectFreeSpinDialog( theData )
	
	self:hideActivitysNode()
	self._mainViewCtl:stopAllLoopMusic()
	
	if theData.enter_event then 
		theData.enter_event()
	end

	if theData.click_event then 
		theData.click_event()
	end

	if theData.changeLayer_event then 
		theData.changeLayer_event()
	end

	if theData.end_event then 
		theData.end_event()
	end

end

-- free 断线重连
function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	if ret == nil then ret = {} end
	self.isProcessing  = true
	self:setFooterBtnsEnable(false)
	self._mainViewCtl:lockLobbyBtn()
	if theFreeSpinData.item_list then
		local realItemList = theFreeSpinData.item_list

		self._mainViewCtl:resetBoardCellsByItemList(realItemList)

		self.freeItem = tool.tableClone(realItemList)
		-- self._mainViewCtl.specials = self._mainViewCtl:getSpecialTryResume(realItemList)
		self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
	end

	if theFreeSpinData.free_random_pick then 
		
		ret.free_random_pick = tool.tableClone(theFreeSpinData.free_random_pick)
		ret.free_random_pick.tryResume 	= true

		self._mainViewCtl:free_random_pick(ret)

	else
		ret["free_spins"]		= theFreeSpinData.free_spins
		self._mainViewCtl:free_spins(ret)
	end
end

function cls:dealFirstFreeSpinData( theFreeSpinData )
	-- 恢复total bet
	local freeSpinBet = theFreeSpinData["bet"]
	if freeSpinBet then self._mainViewCtl:setPointBet(freeSpinBet) end

	-- 恢复total win
	local _totalWin = self._mainViewCtl:getTotalWin()
	if (not _totalWin) or _totalWin == 0 then 
		self._mainViewCtl:setTotalWin(theFreeSpinData["total_win"])
	end
	self._mainViewCtl:updateFooterCoin()

	self.freeItem 		= theFreeSpinData.item_list

	-- 禁掉footer上的按钮
	self:setFooterBtnsEnable(false)

	local endCallFunc = function()
		self._mainViewCtl:dealEnterProcessAndEnterTheme()
	end

	if self.enterThemeByFirstFreeSpin then self:enterThemeByFirstFreeSpin(self._mainViewCtl:getFreeRetForFreeSpin(), theFreeSpinData, endCallFunc) end
end

function cls:dealFreeGameData( theFreeGameData ) -- 进入

	-- 恢复X of Y
	local freeSpinCnt = theFreeGameData["free_spins"] or 0
	if freeSpinCnt < 0 then
		local freeSpinBet = theFreeGameData["bet"]
		if freeSpinBet then
			self._mainViewCtl:setPointBet(freeSpinBet)
		end

		-- 收钱协议 后端
		self._mainViewCtl:collectCoins(0)
		-- rollup结束后把钱加到header上
		self._mainViewCtl:updateFooterCoin()
		self._mainViewCtl:addCoinsToHeader()

		self._mainViewCtl:removePointBet() -- 解除bet 锁定
		self._mainViewCtl:updateEnterThemeDealList("free_game", nil)
		self._mainViewCtl:dealEnterProcessAndEnterTheme()

	elseif freeSpinCnt == 0 then -- 恢复FreeCollect 弹板
       
		self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
		self.freespin   	= freeSpinCnt
		self.freewin 		= self._mainViewCtl:getTotalWin() or 0 -- 0
		self.freeItem 		= theFreeGameData.item_list

		-- 恢复free spin场景
		self._mainViewCtl:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
		self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
		self._mainViewCtl:runFreeCollectSpinStage()
		 -- 禁掉footer上的按钮
	    self:setFooterBtnsEnable(false)
		self:adjustWithFreeSpin()

		local freeSpinBet = theFreeGameData["bet"]
		if freeSpinBet then
			self._mainViewCtl:setPointBet(freeSpinBet)
		end

		if self._mainViewCtl.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
			self._mainViewCtl:resetPointBet()
		end
		self._mainViewCtl:updateEnterThemeDealList("free_game", nil)
		self._mainViewCtl:dealEnterProcessAndEnterTheme()		
	else
		self.sumFreeSpinCnt = theFreeGameData["free_spin_total"] or 0
		self.freespin   	= freeSpinCnt
		self.freewin 		= self._mainViewCtl:getTotalWin() or 0 -- 0
		self.freeItem 		= theFreeGameData.item_list

		-- 恢复free spin场景
		self._mainViewCtl:showFreeSpinNode(freeSpinCnt,self.sumFreeSpinCnt)
		self:enterFreeSpinStage(true) -- 新添加 断线重连的标志位
		self._mainViewCtl:runFreeSpinStage()
		self:adjustWithFreeSpin()

		local freeSpinBet = theFreeGameData["bet"]
		if freeSpinBet then
			self._mainViewCtl:setPointBet(freeSpinBet)
		end

		if self._mainViewCtl.resetPointBet then -- 用来 执行 在 所有 断线操作完成之后 需要 更新 pointBet 的 方法 eg: 美人鱼主题 superBonus 断线需要 设置superBet
			self._mainViewCtl:resetPointBet()
		end
		self._mainViewCtl:updateEnterThemeDealList("free_game", nil)
		self._mainViewCtl:dealEnterProcessAndEnterTheme()
	end
end


function cls:dealFreeSpinData( theFreeSpinData )

	local delay = self._mainViewCtl:getThemeResourceId() == 101 and 1.6 or 1.7
	self:laterCallBack(delay, function ()
		self._mainViewCtl:toSpin()
		self._mainViewCtl:dealEnterProcessAndEnterTheme()
	end)
	
end

function cls:dealFreeCollectData(rets)
	local ret = {}

	self._mainViewCtl.footer:setSpinStateOnFinishSpin(true)
	self._mainViewCtl:finshSpinByHandle(ret)
end

-- 正常触发
function cls:free_spins( ret )

	local theSpecials 	= self._mainViewCtl:getFreeSpecialData()
	
	local enterType     = "free_spin"
	if self.freewin then
		enterType = "more_free_spin"
	end
	local enterDelay 	= self._mainViewCtl:playFreeSpinItemAnimation(theSpecials, enterType) or 0 -- 进入freespin 的延迟时间
	------------------------------------------------------------------------------------	
	local spins 		= ret["free_spins"] -- freespin 次数 当前结果中
	ret["free_spins"] 	= nil
	------------------------------------------------------------------------------------
	self.freespin = self.freespin or 0
	self.freespin = self.freespin + spins -- freespin 剩余次数
	local more = nil
	if not self:isInFG() then
		self.sumFreeSpinCnt = 0
		self.sumFreeSpinCnt = self.sumFreeSpinCnt + spins -- 总共 freespin 的次数
		self.freewin  = self._mainViewCtl:getTotalWin() or 0
		self._mainViewCtl:changeScreenAwakeState(true)
	else
		self.sumFreeSpinCnt = self.sumFreeSpinCnt + spins
		more = true
	end
	------------------------------------------
	local function delayAction()
		self.isDealFSBegClick = false
		self.isDealFSBegEnd   = false		
		local function startClickCallFunc( ) -- 点击按钮的时候 或者 倒计时结束的时候被调用
			if self.isDealFSBegClick then return end
			self.isDealFSBegClick = true
			-- 场景切换
			if not more then
				self._mainViewCtl:setPointBet(self._mainViewCtl:getCurBet())

				--commonMusic: 关闭弹出startFreeSpin音效
				self:dealMusic_StopFSEnterMusic()
				self:dealMusic_PlayFSEnterClickMusic()
			else
				--commonMusic: 关闭弹出moreFreeSpin音效
				self:dealMusic_StopFSMoreMusic()
				self:dealMusic_PlayFSMoreClickMusic()
			end
		end
		local function changeLayer()
			
		end
		local function endCallFunc( ) -- 弹窗结束的时候被调用
			if self.isDealFSBegEnd then return end
			self.isDealFSBegEnd = true	
			local function startSpin()
				self._mainViewCtl:handleResult()
			end	
			if more then
				self._mainViewCtl:freeStartClicked(startSpin,true)
			else
				
				self._mainViewCtl:showFreeSpinNode(self.freespin, self.sumFreeSpinCnt, not self.freeItem)
				self._mainViewCtl:runFreeSpinStage()
				self._mainViewCtl:freeStartClicked(startSpin,false)
			end

		end
		if more then
			local function enterCallFunc( ) -- 显示弹窗的时候被调用
				-- self.footer:onEnterFreeSpinDialog()
				self:setFooterBtnsEnable(false) -- self.footer:setSpinButtonState(true) -- 禁用spin 按钮
				self:dealMusic_PlayFSMoreMusic()
			end
			 -- enter_event 显示弹窗的时候的回调方法 click_event 点击弹窗之后的 回调方法 end_event 关闭弹窗之后的回调方法
			local theData = {["count"]=spins, ["enter_event"]=enterCallFunc, ["click_event"]=startClickCallFunc, ["end_event"]=endCallFunc, ["theme_info"] = ret["theme_info"],["free_game"] =ret["free_game"] }
			self:adjustFreeSpinMoreData(theData) -- 目前没有操作
			self:playMoreFreeSpinDialog(theData) -- 显示 获得 更多 freespin 弹窗
		else
			local function enterCallFunc( ) -- 显示弹窗的时候被调用
				-- self.footer:onEnterFreeSpinDialog() -- footer 显示 freespin 按钮
				self:setFooterBtnsEnable(false) -- self.footer:setSpinButtonState(true) -- 禁用spin 按钮
				--commonMusic: 弹出startFreeSpin
				self:dealMusic_PlayFSEnterMusic()
				self:enterFreeSpinStage()
			end
			local theData = {["count"]=spins, ["enter_event"]=enterCallFunc, ["click_event"]=startClickCallFunc,["changeLayer_event"]=changeLayer, ["end_event"]=endCallFunc}
			self._mainViewCtl.isFirstFreeGame = true
			self:playStartFreeSpinDialog(theData) -- 显示 获得 freespin 弹窗
		end
	end
	self.node:runAction(cc.Sequence:create(cc.DelayTime:create(enterDelay),cc.CallFunc:create(function()
		delayAction()
	end)))
end

function cls:collectFreeSpin( pEndCallfunc )
	local collectDelay = 1 -- 0.1
	local function delayAction()
		self.isDealFSCollectClick = false
		self.isDealFSCollectEnd   = false
		--显示FreeEnd弹窗时候的回掉
		local function enterCallFunc()
			self:setFooterBtnsEnable(false) -- 禁用spin 按钮
			--commonMusic	
			self._mainViewCtl:dealMusic_FadeLoopMusic(0.3, 1, 0.1)
			self:dealMusic_PlayFSCollectMusic()			
		end
		--点击FreeEnd弹窗时候回掉
		local function collectClick() -- 可以添加音效
			
			-- 点击收集的时候向服务器发送收钱的请求,服务器 给用户加钱
			self._mainViewCtl:collectCoins(0)

			if self.isDealFSCollectClick then return end 

			self.isDealFSCollectClick = true
			--commonMusic
			self:dealMusic_StopFSCollectMusic()
			self:dealMusic_PlayFSCollectClickMusic()
		end
		local function changeLayer()
			self:dealMusic_PlayFSCollectEndMusic()
			if self.isDealFSCollectEnd then return end
			self.isDealFSCollectEnd = true
			self.freespin = nil
			self._mainViewCtl:removePointBet()
			self:outFreeSpinStage()
		end
		--FreeEnd弹窗消失的回掉
		local function endCallFunc()
			local freeWin = self.freewin
			local function onRollEnd( ... )

				EventCenter:pushEvent(EVENTNAMES.THEME.IS_OUT_FREE)
				self._mainViewCtl:dealMusic_FadeLoopMusic(0.3, 0.1, 1)
				local user = User:getInstance() 
				user:addCoins(freeWin)
				self._mainViewCtl:playRateUs()
				
				if pEndCallfunc then
					pEndCallfunc()
				end
				-- 处理freeSpin collect收钱庆祝完成之后，需要有特殊feature的情况
				-- 例如: 为了给RoyalPuppies 主题的 商店中奖Free情况下 Free庆祝完成之后，重新打开商店
				if self._mainViewCtl.collectFreeRollEnd then 
					self._mainViewCtl:collectFreeRollEnd() 
				end
			end
			self._mainViewCtl:dealMusic_PlayNormalLoopMusic()
			self._mainViewCtl:dealMusic_SetLoopMusic(0.1)
			self:laterCallBack(0.5, function ()
				self._mainViewCtl:setFooterWinCoinsEffect(freeWin, 0 ,self._mainViewCtl:getCurBet(), onRollEnd)
				self.freewin = nil
			end)
		end
		local freeSpinSumCount = self.sumFreeSpinCnt or self.free_spins_cache_cnt
		local theData = {["coins"] = self.freewin, ["sum_count"]=freeSpinSumCount, ["enter_event"]=enterCallFunc, ["click_event"]=collectClick, ["changeLayer_event"]=changeLayer, ["end_event"]=endCallFunc}
		self:playCollectFreeSpinDialog(theData) -- 显示 collect freespin的 弹窗
	end
	self.node:runAction(cc.Sequence:create(cc.DelayTime:create(collectDelay),cc.CallFunc:create(function()
		delayAction()
	end)))
end
----------------------------------------------------------------------------------------------------------------
-- 相关方法
function cls:adjustFreeSpinMoreData( ... )
	
end
function cls:updateFreeSpinCount(retrigger, count)
	if not retrigger then
		self.freespin = 0
		self.freespin = self.freespin + count -- 剩余free spin的次数
		self.sumFreeSpinCnt = 0
		self.sumFreeSpinCnt = self.sumFreeSpinCnt + count -- 总共 freespin 的次数
		self.freewin  = self.scatter_spin_winCoins or 0
		self.scatter_spin_winCoins = nil
	else
		self.freespin = (self.freespin or 0) + count -- 剩余free spin的次数
		self.sumFreeSpinCnt = (self.sumFreeSpinCnt or 0) + count -- 总共 freespin 的次数
	end
end

-- function cls:getFreeSpinPlayCnt( ) -- 暂时未用到
-- 	return self.free_spins_cache_cnt or 0
-- end

function cls:enterFreeSpinStage(isResume )
	self:changeFreeBack(true)
	self._mainViewCtl:enterFreeSpin(isResume)	
	if not self.freeItem then
		self.freeItem    = self._mainViewCtl:getItemListForFreeSpin()
		self.freeRet  = self._mainViewCtl:getFreeRetForFreeSpin()
		self.freeSpeical = self._mainViewCtl:getFreeSpecialData()
	end
end

function cls:outFreeSpinStage( )
	self._mainViewCtl:hideFreeSpinNode() -- 隐藏 freespin 的 相关节点显示
	self._mainViewCtl:runOutFreeSpinState() -- 对 footer 的 按钮进行控制
	self:changeFreeBack(false) -- 更新使用的假滚轴
	if self.freeItem then
		self:changeFreeItemSpecial()
		self._mainViewCtl:refreshWithTheItemList(self.freeItem) -- 刷新牌面 + 动画播放
	end
	self._mainViewCtl:enterBaseGameStage()

	self.freeItem    = nil	
	self.freeRet     = nil
	self.freeSpeical = nil
end

function cls:getTriggerItemList()
	return self.freeItem
end
function cls:setTriggerItemList(item_list)
	 self.freeItem = item_list
end
function cls:changeFreeItemSpecial( )
	
end

function cls:changeFreeBack( isFree )
	self._mainViewCtl:resetCurrentReels(isFree)
end

function cls:adjustWithFreeSpin()
	self._mainViewCtl:updatedFreeSpinCount(self.freespin, self.sumFreeSpinCnt)
end

-----------------free 音效相关-------------------
-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
	self.audioCtl:dealMusic_PlayGameLoopMusic(self._mainViewCtl:getAudioFile("free_background"))
end

-- freespin音效相关
function cls:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	self:playMusicByName("free_dialog_start_show")
end
function cls:dealMusic_StopFSEnterMusic( )
	self:stopMusicByName("free_dialog_start_show")
end
function cls:dealMusic_PlayFSEnterClickMusic( )
	self:playMusicByName("free_dialog_start_close")
end

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusicByName("free_dialog_more_show")
end

function cls:dealMusic_StopFSMoreMusic( )
end

function cls:dealMusic_PlayFSMoreClickMusic( )
	self:playMusicByName("free_dialog_more_close")
end

--Free Game 收集音乐
function cls:dealMusic_PlayFSCollectMusic( )
	self:playMusicByName("free_dialog_collect_show")
end
function cls:dealMusic_StopFSCollectMusic( )
	self:stopMusicByName("free_dialog_collect_show")
end
function cls:dealMusic_PlayFSCollectClickMusic()
	self:playMusicByName("free_dialog_collect_click")
end
function cls:dealMusic_PlayFSCollectEndMusic( )
	self:playMusicByName("free_dialog_collect_close")
end


