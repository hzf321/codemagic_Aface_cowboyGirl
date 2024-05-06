--author by mtt
--如果某个节点继承了此table表 此节点被删除的时候需要删除当前节点注册的事件（onExit方法）

--继承此类 	inherit(class, EventWrapper)

--派发事件
-- local data = {coins = 1000, vipPoint = 10000}
-- self:dispatchEvent("evt_bonus_collect", data)

--监听事件并处理
-- local function onEventCollect(event)
--    local data = event.data
--    self:collectBonus(data)
-- end
-- self:addEventListener("evt_bonus_collect", onEventCollect)

local EventWrapper = {}
EventWrapper.listenersMap = {}
EventWrapper.eventDispatcher = cc.Director:getInstance():getEventDispatcher()
 
function EventWrapper:dispatchEvent(eventName, data)
	local event = cc.EventCustom:new(eventName)
	if data then
		 event.data = data
	end
    self.eventDispatcher:dispatchEvent(event)
end

function EventWrapper:addEventListener(eventName, func)
	self:removeEventListenerbyName(eventName)
    local listener = cc.EventListenerCustom:create(eventName, func)
    self.listenersMap[eventName] = listener
    self.eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
end

function EventWrapper:removeEventListenerbyName(eventName)
	if self.listenersMap[eventName] then
		self.eventDispatcher:removeEventListener(self.listenersMap[eventName])
	end
	self.listenersMap[eventName] = nil
end

function EventWrapper:removeAllEventListeners()
	if not self.listenersMap then return end 
	for key, value in pairs(self.listenersMap) do
		self:removeEventListenerbyName(key)
	end
end

return EventWrapper