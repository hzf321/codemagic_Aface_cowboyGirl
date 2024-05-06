---------
-- 事件管理器优化版
-- 该事件管理器旨在解耦合，模块间安全传递数据，并且可以对同一事件有多个观察者
-- by dudu
-- 带_的外部不要访问
---------
EventCenter = EventCenter or {};
EventCenter._events = EventCenter._events or {};
--[[
	根据节点分发事件，节点不存在则取消监听
]]
EventCenter._events_obj = EventCenter._events_obj or {};

-- 事件单元
local EventCell = class("EventCenter");
function EventCell:ctor( eventName, observerTag, fun, handler )
	self.eventName = eventName
	self.observerTag = observerTag
	self.fun = fun
	self.handler = handler
end

-- obj事件单元
local EventCellObj = class("EventCellObj");
function EventCellObj:ctor( eventName, fun, handler )
	self.eventName = eventName
	self.fun = fun
	self.handler = handler
end
function EventCellObj:onEvent( data )
	self.fun(self.handler, data)
end

-- 注册事件监听，可以对同一个eventname有多个观察者,分别为事件名，观察者标签，函数，函数所属对象
function EventCenter:registerEvent( eventName, observerTag, fun, handler )
	if not eventName or eventName == "" then
		-- print("EventCenter registerEvent error 事件名称不能为空")
		return
	end
	if not observerTag or observerTag == "" then
		-- print("EventCenter registerEvent error 监听类型不能为空")
		return
	end
	if not fun then
		-- print("EventCenter registerEvent error 监听回调不能为空")
		return
	end
	-- print("EventCenter registerEvent eventName", eventName,"observerTag",observerTag)
	self._events[eventName] = self._events[eventName] or {}
	self._events[eventName][observerTag] = EventCell.new(eventName,observerTag,fun,handler)
end

--[[
	注册事件监听，挂载到节点上，节点消失则取消事件
]]
function EventCenter:registerObjectEvent( eventName, fun, handler )
	if not eventName or eventName == "" then
		-- print("EventCenter registerEvent error 事件名称不能为空")
		return
	end
	if not handler or not libUI.isValidNode(handler) then
		-- print("EventCenter registerEvent error 监听对象不存在")
		return
	end
	if not fun then
		-- print("EventCenter registerEvent error 监听回调不能为空")
		return
	end
	-- print("EventCenter registerEvent eventName", eventName,"observerTag",observerTag)
	self._events_obj[eventName] = self._events_obj[eventName] or {}
	self._events_obj[eventName][handler] = EventCellObj.new(eventName,fun,handler)
end


-- 广播事件，对所有监听该事件的观察者进行广播
function EventCenter:pushEvent( eventName, data )
	-- print("EventCenter pushEvent eventName", eventName)
	-- libDebug.printTable("EventCenter pushEvent data", data)
	for observerTag, eventCell in pairs(self._events[eventName] or {}) do
		-- print("EventCenter pushEvent observerTag", observerTag)
		eventCell.fun(eventCell.handler, data)
	end

	if self._events_obj[eventName] then
		local invalid_handlers = {}
		for handler, eventCell in pairs(self._events_obj[eventName]) do
			if libUI.isValidNode(handler) then
				eventCell:onEvent(data)
			else
				invalid_handlers[#invalid_handlers + 1] = handler
			end
		end
		for i, handler in ipairs(invalid_handlers) do
			self._events_obj[eventName][handler] = nil
		end
	end
end

-- 删除自己的监听者
function EventCenter:removeEvent( eventName, observerTag )
	if not eventName or eventName == "" then
		-- print("EventCenter registerEvent error 事件名称不能为空")
		return
	end
	if not observerTag or observerTag == "" then
		-- print("EventCenter registerEvent error 监听类型不能为空")
		return
	end
	-- print("EventCenter removeEvent eventName", eventName,"observerTag",observerTag)
	if self._events[eventName] and self._events[eventName][observerTag] then
		self._events[eventName][observerTag] = nil
	end
end

-- 删除某种类型的所有监听
function EventCenter:removeTag( observerTag )
	for eventName, eventData in pairs(self._events) do
		if eventData[observerTag] then
			eventData[observerTag] = nil
		end
	end
end

function EventCenter:removeObject( handler )
	for eventName, eventData in pairs(self._events_obj) do
		if eventData[handler] then
			eventData[handler] = nil
		end
	end
end

--[[
	清理obj释放的事件监听
]]
function EventCenter:cleanObjectEvent( eventName )
	if self._events_obj[eventName] then
		local invalid_handlers = {}
		for handler, eventCell in pairs(self._events_obj[eventName]) do
			if not libUI.isValidNode(handler) then
				invalid_handlers[#invalid_handlers + 1] = handler
			end
		end
		for i, handler in ipairs(invalid_handlers) do
			self._events_obj[eventName][handler] = nil
		end
	end
end