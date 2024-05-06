local BaseFreespinDialog = class("BaseFreespinDialog", CCSNode)
--------------------------------------------------------------------------------------------------------------------------------
--  dialog code
--  config_ej:
		-- pConfig = {
		-- 	["gen_path"] = "theme_dialog/freespin/",
		-- 	["csb_file"] = "freespin.csb",
		-- 	["frame_config"] = {
		-- 		["start"] 		 = {{0,20},0.5,{65,85},0.4},
		-- 		["more"] 		 = {{0,20},0.5,{65,85},0.4,2},
		-- 		["collect"] 	 = {{0,20},0.5,{65,85},0.4},
		-- 		["game_collect"] = {{0,20},0.5,{65,85},0.4},
		-- 	},
		-- }
--------------------------------------------------------------------------------------------------------------------------------
function BaseFreespinDialog:ctor( pThemeCtr, pConfig)
	self.themeCtr 	   = pThemeCtr
	self.theme 	   	   = pThemeCtr.theme 
	self.genPath       = pConfig["gen_path"]
	self.csb 		   = pConfig["csb_file"]
	self.frameConfig   = pConfig["frame_config"]
	self.sharePos      = pConfig["share_pos"]
	self.sceneSize 	   = bole.getSceneSize()
	self.centerPos 	   = cc.p(self.sceneSize.width/2, self.sceneSize.height/2)
	CCSNode.ctor(self, self.csb)
end
function BaseFreespinDialog:loadControls( ) 
	self.root 			 = self.node:getChildByName("root")
	for k,v in pairs(self.root:getChildren()) do
		v:setVisible(false)
	end
	self.startRoot 		 = self.root:getChildByName("node_start")
	if self.startRoot then
		self.startRoot.btnStart   	= bole.deepFind(self.startRoot, "btn_start")
		self.startRoot.labelCount 	= bole.deepFind(self.startRoot, "label_count")
		self.startRoot.ScaleNode    = bole.deepFind(self.startRoot, "jump_wenzi") -- whj 添加用来播放jump动画
	end
	self.moreRoot   	 = self.root:getChildByName("node_more")
	if self.moreRoot then
		self.moreRoot.labelCount  	= bole.deepFind(self.moreRoot, "label_count")
	end
	self.collectRoot 	 = self.root:getChildByName("node_collect")
	if self.collectRoot then
		self.collectRoot.btnCollect = bole.deepFind(self.collectRoot, "btn_collect")
		self.collectRoot.labelWin   = bole.deepFind(self.collectRoot, "label_coins")
		self.collectRoot.labelDesc  = bole.deepFind(self.collectRoot, "label_desc")
		self.collectRoot.labelCount = bole.deepFind(self.collectRoot, "label_count")
		self.collectRoot.collectNode    = bole.deepFind(self.collectRoot, "collect")
		self.collectRoot.noCollectNode  = bole.deepFind(self.collectRoot, "no_collect")
		self.collectRoot.noCollectBtn  = bole.deepFind(self.collectRoot, "btn_collect2") -- whj 添加 没有 赢钱的collect 关闭按钮
	end
	self.gameCollectRoot = self.root:getChildByName("node_game_collect")
	if self.gameCollectRoot then
		self.gameCollectRoot.labelGameWin 	= bole.deepFind(self.gameCollectRoot, "label_value_1")
		self.gameCollectRoot.labelBonusWin 	= bole.deepFind(self.gameCollectRoot, "label_value_2")
		self.gameCollectRoot.labelTotalWin 	= bole.deepFind(self.gameCollectRoot, "label_value_3")
		self.gameCollectRoot.btnCollect 	= bole.deepFind(self.gameCollectRoot, "btn_collect")
	end	
	self.baseRoot = self.root:getChildByName("node_base") -- whj 添加 用来执行 操作 start more 或者 collect 共同存在的背景

end
function BaseFreespinDialog:show( initEventFunc, intLayoutFunc ,parent)
	if parent then
		parent:addChild(self)
	else
    	self.themeCtr.curScene:addToContentFooter(self)
    end
    self.node:setVisible(false)    
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    	self.node:setVisible(true)
		if self.fsData["enter_event"] then
			self.fsData["enter_event"]()
		end
		local action = cc.CSLoader:createTimeline(self.csb)    
		self.node:runAction(action)
		
		if self.startRoot and self.startRoot.ScaleNode then  -- whj 添加特殊 跳动逻辑
			if self.curFrameConfig["jump"] then
				local jumpData = self.curFrameConfig["jump"]
				self.startRoot.ScaleNode:setScale(jumpData["startScale"][1],jumpData["startScale"][2])
				self.startRoot.ScaleNode:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(jumpData[1][1],jumpData[1][2],jumpData[1][3]),cc.ScaleTo:create(jumpData[2][1],jumpData[2][2],jumpData[2][3]))))
			else
				self.startRoot.ScaleNode:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(20/60,1.10,1.05),cc.ScaleTo:create(40/60,1))))
			end
		end
		if self.curFrameConfig[1] then -- whj 添加, 代码控制动画的时候, 可以帧动画时间传空值
        	action:gotoFrameAndPlay(self.curFrameConfig[1][1], self.curFrameConfig[1][2], false)
        end
    end), cc.DelayTime:create(self.curFrameConfig[2]), cc.CallFunc:create(function()
    	if initEventFunc then initEventFunc() end
    end)))
    if intLayoutFunc then intLayoutFunc() end
end
function BaseFreespinDialog:hide( )
    local action = cc.CSLoader:createTimeline(self.csb)    
    self.node:runAction(action)
    self:runAction(cc.Sequence:create(
    	cc.DelayTime:create(0.1), 
    	cc.CallFunc:create(function()
    		if self.curFrameConfig[3] then -- whj 添加, 代码控制动画的时候, 可以帧动画时间传空值
        		action:gotoFrameAndPlay(self.curFrameConfig[3][1], self.curFrameConfig[3][2], false)
        	end
    	end), 
    	cc.DelayTime:create(self.curFrameConfig[4] or 0),
    	cc.CallFunc:create(function()
			self.theme:onCollectFreeClick()
		end),
    	cc.DelayTime:create(self.curFrameConfig[5] or 0),
    	cc.CallFunc:create(function()
			if self.fsData["changeLayer_event"] then
				self.fsData["changeLayer_event"]()
			end
		end), 
		cc.DelayTime:create(self.curFrameConfig[6] or 0), 
    	cc.CallFunc:create(function()
			if self.endCallFunc then
				self.endCallFunc()
			end
			if self.fsData["end_event"] then
				self.fsData["end_event"]()
			end
		end), 
		cc.DelayTime:create(self.curFrameConfig[7] or 0),
	 	cc.RemoveSelf:create()))
end

function BaseFreespinDialog:hideByInboxFreeSpin( )

end
function BaseFreespinDialog:directOut( )
	if self.fsData["enter_event"] then
		self.fsData["enter_event"]()
	end
	if self.fsData["click_event"] then
		self.fsData["click_event"]()
	end
	if self.endCallFunc then
		self.endCallFunc()
	end	
	if self.fsData["changeLayer_event"] then
		self.fsData["changeLayer_event"]()
	end	
	if self.fsData["end_event"] then
		self.fsData["end_event"]()
	end		
end
------------------------------------------------------------------------------------------------------------
-- start
------------------------------------------------------------------------------------------------------------
function BaseFreespinDialog:showStart( pFsData, pEndCallFunc ,parent)	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["start"]
	if not self.startRoot then
		self:directOut()
		return nil
	end    
    local initEventFunc = function()
    	self:initStartEvent()
    end
    local intLayoutFunc = function()
    	self:initStartLayout()
    end    
    self:show(initEventFunc, intLayoutFunc,parent)
end
function BaseFreespinDialog:initStartLayout()
	self.startRoot:setVisible(true)	
	if self.baseRoot then 
		self.baseRoot:setVisible(true)
	end
	if self.startRoot.labelCount then
		self.startRoot.labelCount:setString(self.fsData["count"])
	end
end
function BaseFreespinDialog:initStartEvent( )
	self.isClick = false
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then	
			sender:setEnabled(false)    	
	    	self:startFreespin()
        end
    end
    self.startRoot.btnStart:addTouchEventListener(btnEvent)
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(10), cc.CallFunc:create(function()
	-- 	self:startFreespin()
	-- end)))

	self:addFlash(self.startRoot.btnStart, "btnStartFile")
end
function BaseFreespinDialog:startFreespin()
	if self.isClick then return end
	self.isClick = true
	self.startRoot.btnStart:setTouchEnabled(false)
	if self.fsData["click_event"] then
		self.fsData["click_event"]()
	end
	self:hide()
end

------------------------------------------------------------------------------------------------------------
-- more
------------------------------------------------------------------------------------------------------------
function BaseFreespinDialog:showMore( pFsData, pEndCallFunc ,parent)	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["more"]
	if not self.moreRoot then
		self:directOut()
		return nil
	end    
    local intLayoutFunc = function()
    	self:initMoreLayout()
    end    
    self:show(nil, intLayoutFunc,parent)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(self.curFrameConfig[2]), cc.CallFunc:create(function()
		if self.fsData["click_event"] then
			self.fsData["click_event"]()
		end 
		self:hide() 	
    end)))
end
function BaseFreespinDialog:initMoreLayout()
	self.moreRoot:setVisible(true)	
	if self.baseRoot then 
		self.baseRoot:setVisible(true)
	end
	if self.moreRoot.labelCount then
		self.moreRoot.labelCount:setString(self.fsData["count"])
	end
end
------------------------------------------------------------------------------------------------------------
-- collect
------------------------------------------------------------------------------------------------------------
function BaseFreespinDialog:showCollect( pFsData, pEndCallFunc ,parent)	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["collect"]
    self.isCollect      = false
	if not self.collectRoot then
		self:directOut()
		return nil
	end
    local initEventFunc = function()
    	self:initCollectEvent()
    end
    local intLayoutFunc = function()
    	self:initCollectLayout()
    end    
    self:show(initEventFunc, intLayoutFunc,parent)

	--new fb share
	-- local btn = self.collectRoot.btnCollect
	-- local btnSize = btn:getContentSize()
	-- local shareNode = FbShareNode.new()
	-- btn:getParent():addChild(shareNode, 999)
	-- btn.shareFunc = function ()
	-- 	shareNode:share()
	-- end

	-- if self.sharePos then
	-- 	shareNode:setPosition(cc.pAdd(bole.getPos(btn), self.sharePos))
	-- else
	-- 	-- shareNode:setPosition(cc.pAdd(bole.getPos(btn), cc.p(-100, -btnSize.height/2 - 6)))
	-- 	shareNode:setPosition(cc.pAdd(bole.getPos(btn), cc.p(btnSize.width/2 + 30, 0 )))
	-- end
	-- shareNode:setOpacity(0)
	-- local allTime = self.curFrameConfig[1][2]/60.0
	-- shareNode:runAction(cc.Sequence:create(cc.DelayTime:create(allTime - 0.5), cc.FadeTo:create(0.5, 255)))
end
function BaseFreespinDialog:initCollectLayout()
	if self.baseRoot then 
		self.baseRoot:setVisible(true)
	end

	self.collectRoot:setVisible(true)

	-- 收集弹窗控制都不显示
	if self.collectRoot.noCollectNode then
		self.collectRoot.noCollectNode:setVisible(false)
	end
	if self.collectRoot.collectNode then
		self.collectRoot.collectNode:setVisible(false)
	end

	self.isRollEnd = false

	-- 控制 如果没有赢钱 直接显示没有的
	if(not self.fsData["coins"] or self.fsData["coins"]==0) and self.collectRoot.noCollectNode then
		if self.collectRoot.noCollectNode then
			self.collectRoot.noCollectNode:setVisible(true)
		end
		if self.collectRoot.labelWin then 
			self.collectRoot.labelWin:setString(self.fsData["coins"])
		end
		
	else
		if self.collectRoot.collectNode then
			self.collectRoot.collectNode:setVisible(true)
		end

		if self.collectRoot.labelWin then
			local function parseValue( num)
				return FONTS.format(num, true)
			end
			inherit(self.collectRoot.labelWin, LabelNumRoll)
			self.collectRoot.labelWin:nrInit(0, 24, parseValue)
			-- print("whj: coins",jackpot_list[1].jp_win)
			self.collectRoot.labelWin:nrStartRoll(0, self.fsData["coins"], 3)
			self:dealMusic_playRollCoins()
		end

		if self.collectRoot.labelDesc then
			self.collectRoot.labelDesc:setString("IN "..self.fsData["sum_count"].." FREE GAMES")
		end
		if self.collectRoot.labelCount then
			self.collectRoot.labelCount:setString(self.fsData["sum_count"])
		end
	end
	-- self:addFlash(self.collectRoot.btnCollect, "btnCollectFile")
end
function BaseFreespinDialog:initCollectEvent( )
	self.isClick = false
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then	    	
			sender:setEnabled(false)
			self:dealMusic_stopRollCoins()
			if not self.isCollect then 
				self.isCollect      = true
				self:collectFreespin()
				
				if sender.shareFunc then  -- _= sender.shareFunc and sender.shareFunc()
					sender.shareFunc()
				end
				
				self:hide()
				-- if self.fsData["coins"] == 0 then
				-- 	func()
				-- else
				-- 	-- local user = User:getInstance()
				-- 	-- user:addCoins(self.fsData["coins"])
				-- 	func()
				-- 	-- 取消掉飞金币操作 直接加钱
				-- 	-- local delay = 1
				-- 	-- --  local delay = bole.flyCoinsOnButton(sender, self.fsData["coins"])
				-- 	-- local user 		 = User:getInstance()
				-- 	-- user:addCoins(self.fsData["coins"], 1)
				-- 	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(func)))--cc.DelayTime:create(delay), 
				-- end
			end
        end
    end
    if self.collectRoot.btnCollect then 
    	self.collectRoot.btnCollect:addTouchEventListener(btnEvent)
    	self:addFlash(self.collectRoot.btnCollect, "btnCollectFile")
    end
    if self.collectRoot.noCollectBtn then 
    	self.collectRoot.noCollectBtn:addTouchEventListener(btnEvent)
    end
end
function BaseFreespinDialog:collectFreespin()
	if self.isClick then return end
	self.isClick = true
	if self.collectRoot.btnCollect then 
		self.collectRoot.btnCollect:setTouchEnabled(false)
	end
	if self.collectRoot.noCollectBtn then 
		self.collectRoot.noCollectBtn:setTouchEnabled(false)
	end
	if self.collectRoot.labelWin then
		if self.collectRoot.labelWin.nrOverRoll then
			self.collectRoot.labelWin:nrOverRoll()
		end
		self.collectRoot.labelWin:setString( FONTS.format(self.fsData["coins"],true))
	end
	if self.fsData["click_event"] then
		self.fsData["click_event"]()
	end
end
------------------------------------------------------------------------------------------------------------
-- collect
------------------------------------------------------------------------------------------------------------
function BaseFreespinDialog:showGameCollect( pFsData, pEndCallFunc ,parent)	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["game_collect"]
	if not self.gameCollectRoot then
		self:directOut()
		return nil
	end    
    local initEventFunc = function()
    	self:initGameCollectEvent()
    end
    local intLayoutFunc = function()
    	self:initGameCollectLayout()
    end    
    self:show(initEventFunc, intLayoutFunc,parent)
end
function BaseFreespinDialog:initGameCollectLayout()
	self.gameCollectRoot:setVisible(true)
	if self.gameCollectRoot.labelGameWin then
		self.gameCollectRoot.labelGameWin:setString(bole.dealValueToRetString(self.fsData["game_coins"]))
	end
	if self.gameCollectRoot.labelBonusWin then
		self.gameCollectRoot.labelBonusWin:setString(bole.dealValueToRetString(self.fsData["bonus_coins"]))
	end
	if self.gameCollectRoot.labelTotalWin then
		self.gameCollectRoot.labelTotalWin:setString(bole.dealValueToRetString(self.fsData["coins"]))
	end
end
function BaseFreespinDialog:initGameCollectEvent( )
	self.isClick = false
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then	
			sender:setEnabled(false)       	
	    	bole.playMusic("game2")
	    	self:collectGameFreespin()
        end
    end
    self.gameCollectRoot.btnCollect:addTouchEventListener(btnEvent)
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(20), cc.CallFunc:create(function()
	-- 	self:collectFreespin()
	-- end)))
end
function BaseFreespinDialog:collectGameFreespin()
	if self.isClick then return end
	self.isClick = true
	self.gameCollectRoot.btnCollect:setTouchEnabled(false)
	if self.fsData["click_event"] then
		self.fsData["click_event"]()
	end
	self:hide()
end

------------------------------------------------------------------------------------------------------------
-- others
------------------------------------------------------------------------------------------------------------
function BaseFreespinDialog:showOther( pFsData, pEndCallFunc, key, nodeName, tbArgs,parent)	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig[key]
	
	local initEventFunc
	if key == "start" then
		self.startRoot:setName("nil")
		self.otherNode = self.root:getChildByName(nodeName)
		self.otherNode:setName("node_start")
		initEventFunc = function()  self:initStartEvent()  end
		intLayoutFunc = function()  self:initStartLayout()  end
	elseif key == "collect" then
		self.collectRoot:setName("nil")
		self.otherNode = self.root:getChildByName(nodeName)
		self.otherNode:setName("node_collect")
		initEventFunc = function()  self:initCollectEvent()  end
		intLayoutFunc = function()  self:initCollectLayout()  end
	else
		
	end
	self:loadControls()
	if tbArgs.label then
		for k,v in pairs(tbArgs.label) do
			local node = bole.deepFind(self.otherNode, k)
			if node then
				node:setString(v)
			end
		end
	end
    self:show(initEventFunc, intLayoutFunc,parent)
end

function BaseFreespinDialog:addFlash(btn, key)	
	local info = self.theme:getBtnFlashInfo()
	if info[key] and info["flashFile"] then
		local sf, clipPic = bole.addBtnFlash(btn, info[key], info["flashFile"])
		if info.scale then
			clipPic:setScaleX(info.scale[1])
			clipPic:setScaleY(info.scale[2])
		end
	end
end

function BaseFreespinDialog:setCollectScaleByValue(Value,maxWidth)
	if self.collectRoot.labelWin and maxWidth and Value then 
		self.collectRoot.labelWin:setString(FONTS.format(Value,true))
		bole.shrinkLabel(self.collectRoot.labelWin,maxWidth,self.collectRoot.labelWin:getScale())
	end
end

function BaseFreespinDialog:dealMusic_playRollCoins()

	if self.theme.dealMusic_playRollCoins then
		self.theme:dealMusic_playRollCoins()
	end
end
function BaseFreespinDialog:dealMusic_stopRollCoins()

	if self.theme.dealMusic_stopRollCoins then
		self.theme:dealMusic_stopRollCoins()
	end
end
return BaseFreespinDialog
