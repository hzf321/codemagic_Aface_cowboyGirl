
local BLNode 			= require("UI/CreatorUI/BLNode")
local CreatorUITools 	= require("UI/CreatorUI/CreatorUITools")

local function getSpinePath(dir, name)
	return "activities/" .. dir .. "/spines/" .. name .. "/spine"
end

local HandlerType = {
    -- 1
    INIT = "enter",
    -- 4
    REMOVED = "exit",
    -- 2
    START = "enterTransitionFinish",
    -- 3
    REMOVE_START = "exitTransitionStart",
    -- 5
    DESTORY = "cleanup",
}

---@class CreatorNode
---@field node Node
CreatorNode = class("CreatorNode", BLNode)
function CreatorNode:ctor( path )
	if not path then
		return
	end
	BLNode.ctor(self)
	self:init(path)

	-- if libDebug.isDebugPopDelay() then
	-- 	libDebug.setNodeDebugPopDelay(self)
	-- end
end

function CreatorNode:init( path )
	-- print("ok in CreatorNode" .. path)
	if path and bole.isCreatorFileExist(path) then
		
		self.node = CreatorUITools:getInstance():createUi(path);
		self:addChild(self.node)
		if self.node.root then
			self.root = self.node.root
		end
	else
		local res_info = DownloadController:getInstance():getResInfoByResPath(bole.getCreatorFile(path))
		res_info.msg = "creator"
		res_info.err_type = 1
		libDebug.reportClientError(REPORT_CLIENT_ERROR.MISS_FILE, res_info)
		self.node = cc.Node:create()
	end
	self._showAction = false
	self._hideAction = false
	self.csb = path
    self:loadControls()
	self:addCreatorNodeEventListener()

	-- if bole.isMouseEventType() then
	-- 	if not self.mouseStopTag then
	-- 		SystemController:getInstance():setMouseEventNode(self)
	-- 	end
	-- end

	self:registerScriptHandler(function (event_type) 
        if event_type == HandlerType.INIT then
        elseif event_type == HandlerType.START then  
        elseif event_type == HandlerType.REMOVE_START then
        elseif event_type == HandlerType.REMOVED then
        elseif event_type == HandlerType.DESTORY then
			self:onDestory()
        end
    end)

end
--获取多语言特效
function CreatorNode:getSpinePathLanguage(dir, name)
    local down_key = dir
    local file_name = name
    local key = LanguageController:getInstance():getResAvailableLanguageKey(down_key)
    if key and key ~= LANGUAGE.ENGLISH then
    	local res_key = LanguageController:getInstance():_getLanguageResKey(key)
	    down_key = string.format("%s_%s", down_key, res_key)
	end
    return getSpinePath(down_key, file_name)
end
function CreatorNode:addCreatorNodeEventListener( ... )
	local function  onTouchBegan( touch, event )
		-- print("CreatorNode addCreatorNodeEventListener", self.csb)
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
function CreatorNode:setListenerSwallowTouchStatus(status)
	if not self.nodeEventListener then
		return 
	end
	self.nodeEventListener:setSwallowTouches(status)
end
function CreatorNode:showMask( isPortrait,duaration, target ,pos)
	duaration = duaration or 1/2
	target = target or 200
	pos = pos or cc.p(0,MARGIN_H)
	local mask = cc.LayerColor:create( cc.c4b(0, 0, 0, 0))
	mask:setAnchorPoint(cc.p(0.5,0.5))
	-- mask:setPosition(pos)
	mask:setLocalZOrder(-1)
	mask:runAction(cc.FadeTo:create(duaration, self.mask_to_opa or 255*0.8))
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
	self.CreatorNodeMask = mask
end

function CreatorNode:showMask2( isPortrait,duaration , opacity)
	duaration = duaration or 1/2
	local mask = cc.LayerColor:create( cc.c4b(0, 0, 0, 0))
	mask:setAnchorPoint(cc.p(0.5,0.5))
	mask:setLocalZOrder(-1)
	mask:runAction(cc.FadeTo:create(duaration, opacity or 255*0.8))
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
	self.CreatorNodeMask = mask
end 

function CreatorNode:showBiggerMask( duaration, target )
	self:showMask( duaration, target )
	self.CreatorNodeMask:setContentSize( cc.size(DESIGN_WIDTH+50, DESIGN_HEIGHT+50) )
	self.CreatorNodeMask:setPosition(cc.p(-25, -25))
end

function CreatorNode:fadeMask( duration, target )
	if not duration or not target then return nil end
	if self.CreatorNodeMask then
		self.CreatorNodeMask:runAction(cc.Sequence:create(
			cc.FadeTo:create(duration, 0),
		cc.Hide:create()))
	end
end

function CreatorNode:fadeMaskEase( duration , opacity)
	if not duration then return nil end
	if self.CreatorNodeMask then
		self.CreatorNodeMask:stopAllActions()
		local op = opacity or 255*0.85
		self.CreatorNodeMask:runAction(cc.Sequence:create(cc.EaseCubicActionOut:create(cc.FadeTo:create(duration, op ))))
	end
end
function CreatorNode:hideMask( duaration )
	if self.CreatorNodeMask then
		duaration = duaration or 1/2
		self.CreatorNodeMask:stopAllActions()
		self.CreatorNodeMask:runAction(cc.FadeOut:create(duaration))
	end
end

function CreatorNode:loadPlist( ... )
	
end

function CreatorNode:loadControls( ... )
	
end

function CreatorNode:hide()
	if self.data and self.data.event then
		self.data.event()
	end
	self:removeFromParent()
end

function CreatorNode:addTouchEvent( btn, event, param )
	
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
function CreatorNode:addTouchEventToPic( btnNode, callback, param )
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
function CreatorNode:addNormalTouchEventToPic( btnNode, callback, param )
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


function CreatorNode:runTimeLine( startFrame, endFrame, loop, speed )
	
	-- local action = cc.CSLoader:createTimeline(self.csb)
	local animationCtrl = nil;
	if self.getController ~= nil then
		animationCtrl = self:getController("Animation")
	end

	if not animationCtrl then
		return
	end
	local clip = nil
	if libUI.isValidNode(self.node) then
		-- self.node:runAction(action)
		clip = animationCtrl:playCurrent()
		local clipCtrl = animationCtrl:getCurrentClip();
		clip = clipCtrl:getClip()
	else
		libDebug.reportClientError(REPORT_CLIENT_ERROR.INVALID_NODE, {
			msg = "CreatorNode:runTimeLine.node", 
			csb = self.csb
		})
		return
	end
	if loop == true then
		loop = 2
	else
		loop = 1
	end
	local frameTime = 1/ 60
	if endFrame then
		animationCtrl:playByTimeToTime(startFrame * frameTime, endFrame * frameTime, 1)
        -- clip:(self.csb, action, startFrame, endFrame, loop)

	else
		-- libUI.safeGotoFrameAndPause(self.csb, action, startFrame)
		animationCtrl:playFromTime(startFrame * frameTime)
	end
	if speed then
		clip:setSpeed(speed)
	end
	-- self.currentTimeLine = action
end

function CreatorNode:pauseTimeLine( ... )
	if self.currentTimeLine then
		self.currentTimeLine:pause()
	end
end

----------------------------------------------------
-- 功能：
-- 1）show时冻结主题，hide时解冻主题；
-- 2）弹窗生命期内，不允许其它弹窗出现；
function CreatorNode:showActions( ... )
    -- 开始弹窗, 不允许其它弹窗出现
	self._showAction = true
	PopupController:getInstance():setShowKey(self.csb)
	PopupController:getInstance():showActions()
end

function CreatorNode:hideActions(flag, csb)
    -- 关闭弹窗, 允许其它弹窗出现
    local csb = csb or self.csb
	self._hideAction = true
	PopupController:getInstance():setHideKey(csb)
    PopupController:getInstance():hideActions()
end

-- 调用过showaction了
function CreatorNode:isShowdAction()
	return self._showAction
end
-- 调用过hideaction了
function CreatorNode:isHidedAction()
	return self._hideAction
end

-- 节点销毁时检查是否执行了hideAction。一般hideaction调用会优先节点生命周期onDestory的调用，但是hideaction方法并不确保一定会在节点销毁时调用，所以这里检查一下
function CreatorNode:onDestory()
	-- 如果已经调用了showactions，并且hideaction没有调用，则调用hideactions
	if self:isShowdAction() and not self:isHidedAction() then
		self:hideActions()
	end
end

--[[
	creator 专属点击监听事件,监听对象为self.node 下的按钮,
	对应的点击事件执行方法使用下划线转驼峰命名法
]]
function CreatorNode:initButtonList(is_grey)
    if self.node and self.node.uiTbl and self.node.uiTbl.buttonList then
        local btnList = self.node.uiTbl.buttonList;
        local node = nil;
        local name = "";
        local callback = nil
        for i = 1, #btnList do
            node = self.node:getItem(btnList[i].path);
            name = node.name;
			local btnName = bole.underscoreToCamel(name)
            callback = self["on"..btnName.."Clicked"]
            if node and callback then
				if is_grey then
                    bole.ctorUIComponent(node, UIComponent.CommonButton,UIComponent.CommonButton.Enum.ONLY_GRAY)
                end
                self:addTouchEvent(node, handler(self, callback), btnList[i].tag)
            end
        end
    end
end
