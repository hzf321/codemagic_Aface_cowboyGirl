
CCSNode = class("CCSNode", function() return cc.Node:create() end)
function CCSNode:ctor( path )
	if not path then
		return
	end

	self:init(path)
end

function CCSNode:init( path )
	self:loadPlist()
	if path and cc.FileUtils:getInstance():isFileExist(path) then
		self.node = cc.CSLoader:createNode(path)
	else
		self.node = cc.Node:create()
	end
	self:addChild(self.node)
	self.csb = path
    self:loadControls()
	self:addCCSNodeEventListener()
end

function CCSNode:addCCSNodeEventListener( ... )
	local function  onTouchBegan( touch, event )
		-- print("CCSNode addCCSNodeEventListener", self.csb)
		return true
	end
	local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    -- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_ENDED )
   	-- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    self.nodeEventListener = listener
end

function CCSNode:showMask( isPortrait,duaration, target ,pos)
	duaration = duaration or 1/2
	target = target or 200
	pos = pos or cc.p(0,MARGIN_H)
	local mask = cc.LayerColor:create( cc.c4b(0, 0, 0, 0))
	mask:setAnchorPoint(cc.p(0.5,0.5))
	-- mask:setPosition(pos)
	mask:setLocalZOrder(-1)
	mask:runAction(cc.FadeTo:create(duaration, self.mask_to_opa or 255*0.9))
	-- 支持pad计，蒙版层加大一些，并不影响游戏 changed by dd.
	if isPortrait then
		mask:setContentSize( 3000, 4000 )
		-- mask:setContentSize( cc.size((DESIGN_HEIGHT + 50) /SCREEN_RATIO, DESIGN_WIDTH/SCREEN_RATIO) )
	else
		mask:setContentSize( 4000, 3000 )
		-- mask:setContentSize( cc.size(DESIGN_WIDTH/SCREEN_RATIO, (DESIGN_HEIGHT + 50) /SCREEN_RATIO) )
	end
	mask:setPosition(-1500,-1500)
	self:addChild(mask)
	self.CCSNodeMask = mask
end

function CCSNode:showMask2( isPortrait,duaration , opacity)
	duaration = duaration or 1/2
	local mask = cc.LayerColor:create( cc.c4b(0, 0, 0, 0))
	mask:setAnchorPoint(cc.p(0.5,0.5))
	mask:setLocalZOrder(-1)
	mask:runAction(cc.FadeTo:create(duaration, opacity or 255*0.85))
	-- 支持pad计，蒙版层加大一些，并不影响游戏 changed by dd.
	if isPortrait then
		mask:setContentSize( 3000, 4000 )
		-- mask:setContentSize( cc.size((DESIGN_HEIGHT + 50) /SCREEN_RATIO, DESIGN_WIDTH/SCREEN_RATIO) )
	else
		mask:setContentSize( 4000, 3000 )
		-- mask:setContentSize( cc.size(DESIGN_WIDTH/SCREEN_RATIO, (DESIGN_HEIGHT + 50) /SCREEN_RATIO) )
	end
	mask:setPosition(-1500,-1500)
	self:addChild(mask)
	self.CCSNodeMask = mask
end 

function CCSNode:showBiggerMask( duaration, target )
	self:showMask( duaration, target )
	self.CCSNodeMask:setContentSize( cc.size(DESIGN_WIDTH+50, DESIGN_HEIGHT+50) )
	self.CCSNodeMask:setPosition(cc.p(-25, -25))
end

function CCSNode:fadeMask( duration, target )
	if not duration or not target then return nil end
	if self.CCSNodeMask then
		self.CCSNodeMask:runAction(cc.FadeTo:create(duration, 0))
	end
end

function CCSNode:fadeMaskEase( duration , opacity)
	if not duration then return nil end
	if self.CCSNodeMask then
		self.CCSNodeMask:stopAllActions()
		local op = opacity or 255*0.85
		self.CCSNodeMask:runAction(cc.Sequence:create(cc.EaseCubicActionOut:create(cc.FadeTo:create(duration, op ))))
	end
end
function CCSNode:hideMask( duaration )
	if self.CCSNodeMask then
		duaration = duaration or 1/2
		self.CCSNodeMask:stopAllActions()
		self.CCSNodeMask:runAction(cc.FadeOut:create(duaration))
	end
end

function CCSNode:loadPlist( ... )
	
end

function CCSNode:loadControls( ... )
	
end

function CCSNode:hide()
	if self.data and self.data.event then
		self.data.event()
	end
	self:removeFromParent()
end

function CCSNode:addTouchEvent( btn, event, param )
	
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
        	if event then
        		event(param)
        	end
        end
    end
    btn:addTouchEventListener(btnEvent)
end

-- 该接口缺陷：
-- 缺陷一：默认点击区域为图片的中心部分区域（x方向为10%~75%，y方向为25%~82%）
-- 缺陷二：设置图片scale后，由于区域判断规则不兼容的原因，导致无法准确获取结果
function CCSNode:addTouchEventToPic( btnNode, callback, param )
	local function onTouchBegan( touch, event )
		local ret 	= bole.containsPointWithScale( touch, event, nil )
        return ret
    end
    local function onTouchEnded( touch, event )
        if bole.containsPointWithScale( touch, event, nil ) and callback then
        	callback(param)
        end
    end
    local function onTouchCancel( touch, event )
        -- todo
    end
	bole.addEventToNode( btnNode, onTouchBegan, onTouchEnded, onTouchCancel, nil ) 	
end
-- 修改一，取消默认点击区域为图片的中心部分区域
-- 修改二：修复设置图片scale后，由于区域判断规则不兼容的原因，导致无法准确获取结果
function CCSNode:addNormalTouchEventToPic( btnNode, callback, param )
	local function onTouchBegan( touch, event )
		local ret 	= bole.containsPoint( touch, event, nil )
        return ret
    end
    local function onTouchEnded( touch, event )
        if bole.containsPoint( touch, event, nil ) and callback then
        	callback(param)
        end
    end
    local function onTouchCancel( touch, event )
        -- todo
    end
	bole.addEventToNode( btnNode, onTouchBegan, onTouchEnded, onTouchCancel, nil ) 	
end

function CCSNode:runTimeLine( startFrame, endFrame, loop, speed )
	
	local action = cc.CSLoader:createTimeline(self.csb)
	if not action then
		bole.send_codeInfo(Splunk_Type.Error, {error = "empty", msg = "CCSNode:runTimeLine.action", csb = self.csb}, false)
		return
	end
	
	if libUI.isValidNode(self.node) then
		self.node:runAction(action)
	else
		bole.send_codeInfo(Splunk_Type.Error, {error = "empty", msg = "CCSNode:runTimeLine.node", csb = self.csb}, false)
	end
	loop = loop or false
	if endFrame then
		action:gotoFrameAndPlay(startFrame, endFrame, loop)
	else
		action:gotoFrameAndPause(startFrame)
	end
	if speed then
		action:setTimeSpeed(speed)
	end
	self.currentTimeLine = action
end

function CCSNode:pauseTimeLine( ... )
	if self.currentTimeLine then
		self.currentTimeLine:pause()
	end
end

----------------------------------------------------
-- 功能：
-- 1）show时冻结主题，hide时解冻主题；
-- 2）弹窗生命期内，不允许其它弹窗出现；
function CCSNode:showActions( ... )
    -- 开始弹窗, 不允许其它弹窗出现
	PopupController:getInstance():setShowKey(self.csb)
	PopupController:getInstance():showActions()
end

function CCSNode:hideActions(flag, csb)
    -- 关闭弹窗, 允许其它弹窗出现
    local csb = csb or self.csb
	PopupController:getInstance():setHideKey(csb)
    PopupController:getInstance():hideActions()
end

ActivityBaseDialogEx = class("ActivityBaseDialogEx" , CCSNode)

function ActivityBaseDialogEx:ctor(...) 
	CCSNode.ctor(self, ...) 
end
-- 是否弃用点击功能
function ActivityBaseDialogEx:enableButtons(enable) 
	local clickNodeList = self:getClickNodeList()
	for key, btn in pairs(clickNodeList) do 
		if libUI.isValidNode(btn) and btn.setTouchEnabled then
			if btn.call then
				btn:setTouchEnabled(btn.call(enable))
			else
				btn:setTouchEnabled(enable)
			end
		end
	end 
end
-- 添加可点击节点到操作集合中
function ActivityBaseDialogEx:appendClickNodeToList(btn , callback) 
	if not btn then return end
	btn.call = callback
	self._clickNodeList = self._clickNodeList or {}
	table.insert(self._clickNodeList , btn)
end
-- 获取可点击节点集合
function ActivityBaseDialogEx:getClickNodeList() 
	self._clickNodeList = self._clickNodeList or {}
	return self._clickNodeList
end
-- 移除可点击节点
function ActivityBaseDialogEx:removeClickNodeList(node)  
	local remove_index = 0
	for i, v in ipairs(self._clickNodeList or {}) do
		if v == node then
			remove_index = i
			break
		end
	end
	if remove_index ~= 0 then
		table.remove(self._clickNodeList or {} , remove_index)
	end
end