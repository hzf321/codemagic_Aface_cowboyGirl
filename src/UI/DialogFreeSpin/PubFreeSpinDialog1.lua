local PubFreespinDialog = class("PubFreespinDialog", CCSNode)
--------------------------------------------------------------------------------------------------------------------------------
--  dialog code
--------------------------------------------------------------------------------------------------------------------------------
function PubFreespinDialog:ctor( pThemeCtr )
	self.themeCtr 	   = pThemeCtr
	self.genPath       = "theme_dialog/freespin/"
	self.csb 		   = self.genPath.."freespin.csb"
	self.frameConfig   = {
		["start"] 		 = {{0,20},0.5,{65,85},0.4},
		["more"] 		 = {{0,20},0.5,{65,85},0.4,2},
		["collect"] 	 = {{0,20},0.5,{65,85},0.4},
		["game_collect"] = {{0,20},0.5,{65,85},0.4},
	}
	self.sceneSize 	   = bole.getSceneSize()
	self.centerPos 	   = cc.p(self.sceneSize.width/2, self.sceneSize.height/2)
	CCSNode.ctor(self, self.csb)
end
function PubFreespinDialog:loadControls( )
	self.root 			 = self.node:getChildByName("root")
	self.startRoot 		 = self.root:getChildByName("node_start")
	self.startRoot.btnStart   	= self.startRoot:getChildByName("btn_start")
	self.startRoot.labelCount 	= self.startRoot:getChildByName("label_count")
	self.moreRoot   	 = self.root:getChildByName("node_more")
	self.moreRoot.labelCount  	= self.moreRoot:getChildByName("label_count")
	self.collectRoot 	 = self.root:getChildByName("node_collect")
	self.collectRoot.btnCollect = self.collectRoot:getChildByName("btn_collect")
	self.collectRoot.labelWin   = self.collectRoot:getChildByName("label_coins")
	self.collectRoot.labelDesc  = self.collectRoot:getChildByName("label_desc")
	self.gameCollectRoot = self.root:getChildByName("node_game_collect")
	self.gameCollectRoot.labelGameWin 	= self.gameCollectRoot:getChildByName("label_value_1")
	self.gameCollectRoot.labelBonusWin 	= self.gameCollectRoot:getChildByName("label_value_2")
	self.gameCollectRoot.labelTotalWin 	= self.gameCollectRoot:getChildByName("label_value_3")
	self.gameCollectRoot.btnCollect 	= self.gameCollectRoot:getChildByName("btn_collect")
	self.startRoot:setVisible(false)
	self.moreRoot:setVisible(false)
	self.collectRoot:setVisible(false)
	self.gameCollectRoot:setVisible(false)
end
function PubFreespinDialog:show( initEventFunc, intLayoutFunc )
    local action = cc.CSLoader:createTimeline(self.csb)    
    self.themeCtr.curScene:addToTop(self)
    self.node:runAction(action)
    self.node:setVisible(false)    
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    	self.node:setVisible(true)
		if self.fsData["enter_event"] then
			self.fsData["enter_event"]()
		end
        action:gotoFrameAndPlay(self.curFrameConfig[1][1], self.curFrameConfig[1][2], false)
    end), cc.DelayTime:create(self.curFrameConfig[2]), cc.CallFunc:create(function()
    	if initEventFunc then initEventFunc() end
    end)))
    if intLayoutFunc then intLayoutFunc() end
end
function PubFreespinDialog:hide( )
    local action = cc.CSLoader:createTimeline(self.csb)    
    self.node:runAction(action)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
        action:gotoFrameAndPlay(self.curFrameConfig[3][1], self.curFrameConfig[3][2], false)
    end), cc.DelayTime:create(self.curFrameConfig[4]), cc.CallFunc:create(function()
		if self.endCallFunc then
			self.endCallFunc()
		end
		if self.fsData["end_event"] then
			self.fsData["end_event"]()
		end
	end), cc.RemoveSelf:create()))
end
------------------------------------------------------------------------------------------------------------
-- start
------------------------------------------------------------------------------------------------------------
function PubFreespinDialog:showStart( pFsData, pEndCallFunc )	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["start"]
    local initEventFunc = function()
    	self:initStartEvent()
    end
    local intLayoutFunc = function()
    	self:initStartLayout()
    end    
    self:show(initEventFunc, intLayoutFunc)
end
function PubFreespinDialog:initStartLayout()
	self.startRoot:setVisible(true)	
	self.startRoot.labelCount:setString(self.fsData["count"])
end
function PubFreespinDialog:initStartEvent( )
	self.isClick = false
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then	    	
	    	bole.playMusic("game2")
	    	self:startFreespin()
        end
    end
    self.startRoot.btnStart:addTouchEventListener(btnEvent)
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
	-- 	self:startFreespin()
	-- end)))
end
function PubFreespinDialog:startFreespin()
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
function PubFreespinDialog:showMore( pFsData, pEndCallFunc )	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["more"]
    local intLayoutFunc = function()
    	self:initMoreLayout()
    end    
    self:show(nil, intLayoutFunc)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(self.curFrameConfig[5]), cc.CallFunc:create(function()
		if self.fsData["click_event"] then
			self.fsData["click_event"]()
		end 
		self:hide() 	
    end)))
end
function PubFreespinDialog:initMoreLayout()
	self.moreRoot:setVisible(true)	
	self.moreRoot.labelCount:setString(self.fsData["count"])
end
------------------------------------------------------------------------------------------------------------
-- collect
------------------------------------------------------------------------------------------------------------
function PubFreespinDialog:showCollect( pFsData, pEndCallFunc )	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["collect"]
    local initEventFunc = function()
    	self:initCollectEvent()
    end
    local intLayoutFunc = function()
    	self:initCollectLayout()
    end    
    self:show(initEventFunc, intLayoutFunc)
end
function PubFreespinDialog:initCollectLayout()
	self.collectRoot:setVisible(true)
	self.collectRoot.labelWin:setString(FONTS.format(self.fsData["coins"],true))--"$"..
	self.collectRoot.labelDesc:setString("IN "..self.fsData["sum_count"].." FREE GAMES")
end
function PubFreespinDialog:initCollectEvent( )
	self.isClick = false
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then	    	
	    	bole.playMusic("game2")
	    	
			self:collectFreespin()
			local delay = bole.flyCoinsOnButton(sender, self.fsData["coins"])
			self:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
				_= sender.shareFunc and sender.shareFunc()
				self:hide()
			end)))
        end
    end
    self.collectRoot.btnCollect:addTouchEventListener(btnEvent)
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
	-- 	self:collectFreespin()
	-- end)))
end
function PubFreespinDialog:collectFreespin()
	if self.isClick then return end
	self.isClick = true
	self.collectRoot.btnCollect:setTouchEnabled(false)
	if self.fsData["click_event"] then
		self.fsData["click_event"]()
	end
end
------------------------------------------------------------------------------------------------------------
-- collect
------------------------------------------------------------------------------------------------------------
function PubFreespinDialog:showGameCollect( pFsData, pEndCallFunc )	
    self.fsData 		= pFsData
    self.endCallFunc    = pEndCallFunc
    self.curFrameConfig = self.frameConfig["game_collect"]
    local initEventFunc = function()
    	self:initGameCollectEvent()
    end
    local intLayoutFunc = function()
    	self:initGameCollectLayout()
    end    
    self:show(initEventFunc, intLayoutFunc)
end
function PubFreespinDialog:initGameCollectLayout()
	self.gameCollectRoot:setVisible(true)
	self.gameCollectRoot.labelGameWin:setString(FONTS.format(self.fsData["game_coins"],true))-- "$"..
	self.gameCollectRoot.labelBonusWin:setString(FONTS.format(self.fsData["bonus_coins"],true))-- "$"..
	self.gameCollectRoot.labelTotalWin:setString(FONTS.format(self.fsData["coins"],true))-- "$"..
end
function PubFreespinDialog:initGameCollectEvent( )
	self.isClick = false
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then	    	
	    	bole.playMusic("game2")
	    	self:collectGameFreespin()
        end
    end
    self.gameCollectRoot.btnCollect:addTouchEventListener(btnEvent)
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(function()
	-- 	self:collectFreespin()
	-- end)))
end
function PubFreespinDialog:collectGameFreespin()
	if self.isClick then return end
	self.isClick = true
	self.gameCollectRoot.btnCollect:setTouchEnabled(false)
	if self.fsData["click_event"] then
		self.fsData["click_event"]()
	end
	self:hide()
end
return PubFreespinDialog