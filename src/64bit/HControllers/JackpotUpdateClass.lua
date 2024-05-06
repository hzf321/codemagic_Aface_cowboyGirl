JackpotUpdateClass = {}

local ACTION_TAG_JP_NUM_ROLL = 11111111

--[[
-- 格式化jackpot数值
]]--
function JackpotUpdateClass:parserFunc(n)
	local last = ""
	self.allowK = self.allowK or false
	if self.allowK then
		n = n / 1000
		n = math.floor(n)
		last = "K"
	end
	return FONTS.format(n, true) .. last
end

-- 初始化
function JackpotUpdateClass:initial(allowK)
	-- jackpot显示值
	self.showValue = 0
	-- jackpot滚动目标值
	self.aimValue  = 0
	-- jackpot数值格式是否需要在末尾显示K
	self.allowK = allowK
	-- jackpot数据刷新间隔，最小1/25
	self.updateTime = 1/16
	-- jackpot步长，最小为1
	self.step = 1
	-- jackpot每隔多少次刷新一遍
	self.updateCount = 1
	-- jackpot每次roll循环的次数
	self.countPerRoll = 0
end

function JackpotUpdateClass:startRoll(jpData)
	-- 停止roll action
	self:stopRoll()
	-- 更新新一轮roll的数据
	self:updateRollData(jpData,true)

	local action = cc.RepeatForever:create(cc.Sequence:create(
		cc.DelayTime:create(self.updateTime), 
		cc.CallFunc:create(function ()
			if self.isPaused then
				return
			end
			self.jpData.increment = self.jpData.increment + self.jpData.increaseRate
			local tempValue = self.jpData.resetValue + self.jpData.increment
			-- 显示当前计算值
			self:setString(self:parserFunc(tempValue))
			if self.needUpdateScale or self.jpData.isUpdated then
				self.needUpdateScale = false
				self.jpData.isUpdated = false
				if self.jpData.aimIncrement then
					if self.jpData.aimIncrement > self.jpData.increment then
						self.jpData.increaseRate = self.baseIncreaseRate + (self.jpData.aimIncrement-self.jpData.increment)/30*self.updateTime
						-- print("zhf add increaseRate ",self.baseIncreaseRate, self.jpData.increaseRate)
					else
						self.jpData.increment = self.jpData.aimIncrement
						self.jpData.aimIncrement = nil
						self.jpData.increaseRate = self.baseIncreaseRate
						-- print("zhf resume increaseRate ",self.baseIncreaseRate, self.jpData.increaseRate)
					end
				end
				self:updateJackpotScale()
			end
	end)))

	action:setTag(ACTION_TAG_JP_NUM_ROLL)
	local tempValue = self.jpData.resetValue + self.jpData.increment
    self:setString(self:parserFunc(tempValue))
    self:updateJackpotScale()
	self:runAction(action)
end

function JackpotUpdateClass:updateRollData(jpData)
	-- print("zhf updateRollData maxWidth = ",self.baseScale,self.maxWidth,self,tool.lua_to_json(jpData))
	self.jpData = jpData
	self.baseIncreaseRate = self.jpData.increaseRate
	self.needUpdateScale = true
end

function JackpotUpdateClass:updateJackpotScale()
	local maxWidth = self.maxWidth
	local curValue = self:getString()
	-- self:setString(curValue)
	if maxWidth then
		local tempWidth = self:getContentSize().width
		-- print("zhf updateJackpotScale tempWidth = ",tempWidth)
		local scale = maxWidth/tempWidth
		local endScale = (scale > self.baseScale) and self.baseScale or scale
		self:setScale(endScale)
	end
end

function JackpotUpdateClass:stopRoll()
	if libUI.isValidNode(self) then
		self:stopActionByTag(ACTION_TAG_JP_NUM_ROLL)
	end
end

function JackpotUpdateClass:pauseRoll()
	self.isPaused = true
	self:updateJackpotScale()
end

function JackpotUpdateClass:resumeRoll()
	self.isPaused = false
	self:updateJackpotScale()
end

function JackpotUpdateClass:getShowValue()
	return self.showValue
end

function JackpotUpdateClass:getAimValue()
	return self.aimValue
end