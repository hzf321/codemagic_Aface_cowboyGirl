
ScreenShaker = class("ScreenShaker")--, cc.ActionInterval
INTERVAL = 0.01
function ScreenShaker:ctor(target, time,callback)
	self.init_x = 0       --[[初始位置x]]
	self.init_y = 0       --[[初始位置y]]
	self.diff_x = 0       --[[偏移量x]]
	self.diff_y = 0       --[[偏移量y]]
	self.diff_max = 8     --[[最大偏移量]]
	self.interval = 0.01  --[[震动频率]]
	self.totalTime = 0    --[[震动时间]]
	self.time = 0         --[[计时器]]
	self.diffTime = 0     --[[震动间隔]]
	self.target = target
	self.init_x = target:getPositionX()
	self.init_y = target:getPositionY()
	self.totalTime = time
	self.callback = callback
end

function ScreenShaker:setMaxAmplitude( diffMax )
	self.diff_max = diffMax or 8
end

function ScreenShaker:setMaxTime( diffTime )
	self.diffTime = diffTime or 0
end

function ScreenShaker:run()
	self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
    	self:shake(ft+self.diffTime)
    	end, 
    	self.diffTime,false)
end

function ScreenShaker:shake(ft)
	if not bole.isValidNode(self.target) then 
		self:stopRunScheduler()
		return 
	end

	if self.time >= self.totalTime then
		self:stop()
		return
	end
	self.time = self.time+ft
	self.diff_x = math.random(-self.diff_max, self.diff_max)*math.random()
	self.diff_y = math.random(-self.diff_max, self.diff_max)*math.random()

	self.target:setPosition(cc.p(self.init_x+self.diff_x, self.init_y+self.diff_y))
end

function ScreenShaker:stop()
	self.time = 0
	self:stopRunScheduler()
	-- if self.scheduler then
	-- 	-- print("ScreenShaker->self.scheduler-> 停止倒计时")
	-- 	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
	-- 	self.scheduler = nil
 	--    end
 	if not bole.isValidNode(self.target) then 
		return 
	end
	self.target:setPosition(cc.p(self.init_x, self.init_y))
	if self.callback then
		self.callback()
	end
end

function ScreenShaker:stopRunScheduler( )
	if self.scheduler then
		-- print("ScreenShaker->self.scheduler-> 停止倒计时")
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
		self.scheduler = nil
    end
end

-- return ScreenShaker