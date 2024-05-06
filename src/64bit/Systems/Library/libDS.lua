
-------------------------------队列(先进先出)-----------------------------
BoleQueueStack = class("BoleQueueStack")

function BoleQueueStack:ctor( ... )
	self.size       = 0
	self.first      = nil
	self.last       = nil
	self.searchFunc = function (a, b) return a == b end
end

function BoleQueueStack:clear( ... )
	self.size = 0
	self.first = nil
	self.last = nil
end

function BoleQueueStack:setSearchFunc(func)
	if func then
		self.searchFunc = func
	end
end

function BoleQueueStack:isEmpty()
	return (self.size == 0 and self.first == nil and self.last == nil)
end

function BoleQueueStack:getSize( ... )
	return self.size
end

-- 将数据加入队头
function BoleQueueStack:push(data)
	local lst = {}
	lst.pre   = nil
	lst.value = data
	lst.next  = nil

	if self.size == 0 then
		self.first = lst
		self.last  = lst
	else
		self.first.pre = lst
		lst.next       = self.first
		self.first     = lst
	end

	self.size = self.size + 1
end

-- 将队尾数据取出
function BoleQueueStack:pop()
	if self:isEmpty() then
		return
	end

	local element = self.last
	self.last    = element.pre

	if self.last == nil then
		self.first = nil
	else
		self.last.next = nil
	end

	self.size = self.size - 1

	return element.value
end

-- 查找元素是否存在
function BoleQueueStack:searchElement(data)
	local current      = self.first
	local current_data = nil
	while current do
		current_data = current.value
		if self.searchFunc(data, current_data) then
			return current
		end

		current = current.next
	end
end

-- 将数据加入队尾
function BoleQueueStack:enQueue(data)
	local lst = {}
	lst.pre   = nil
	lst.value = data
	lst.next  = nil

	if self.size == 0 then
		self.first = lst
		self.last  = lst
	else
		self.last.next = lst
		lst.pre        = self.last
		self.last      = lst
	end

	self.size = self.size + 1
end

-- 将队头数据取出
function BoleQueueStack:deQueue()
	if self:isEmpty() then
		return
	end

	local element = self.first
	self.first    = element.next

	if self.first == nil then
		self.last = nil
	else
		self.first.pre = nil
	end

	self.size = self.size - 1

	return element.value
end

-- 将队列转换为表
function BoleQueueStack:convertToTable()
	local list = {}
	if not self:isEmpty() then
		local start = self.first
		while start ~= nil do
			list[#list + 1] = start.value
			start = start.next
		end
	end
	return list
end