
--------------------
------1 控制转动方向通过 getMoveDis 方法来控制
BaseWheelExtendI = class("BaseWheelExtendI")

local RotatingState = {
    Ready        = 0,
    BounceUp     = 1,
    SpeedUp 	 = 2,
    MaxSpeed 	 = 3,
    SpeedDown 	 = 4,
    SlowDown     = 5,
    BounceDown 	 = 6,
    SpinOver	 = 7,
    Idle         = 8,
    FinishStop   = 9

}
local DirectionType = {
	clockwise      = 1, -- 顺时针
	anticlockwise  = -1, -- 逆时针

}

local Interval = 0

function BaseWheelExtendI:ctor( theme, wheelNode,pointer, data,callFunc)
	self._theme            = theme -- pickGame
    self.WheelNode         = wheelNode
    self.pointer = pointer
	-- self.Icons			   = data["WheelItems"] 
 --    self.IconsPos          = data["WheelItemPos"] -- 用来随机产生位置的
    self.downAngle         = data["downangle"] or 0
    self.downAngleTime     = data["downAngleTime"] or 0
    self.endAngle          = data["endAngle"] - self.downAngle -- 结束角度
    self.ItemCount         = data["itemCount"] or 12
    self.finshPos          = data["finshPos"] -- 最终停下的位置(有最终位置 就不需要 随机产生位置了 适用于 wheel 上面没有重复选择的 或者重复选择比较少的)
	-- self._cellAngle        = data["cellAngle"]
	self.DelayBeforeSpin   = data["delayBeforeSpin"] or 0.0    --开始旋转前的时间延迟
    self.UpBounce          = data["upBounce"] or 10     --开始滚动前，向上滚动距离
    self.UpBounceTime      = data["upBounceTime"] or 0.2    --开始滚动前，向上滚动时间
    self.SpeedUpTime       = data["speedUpTime"] or 0.5    --加速时间
    self.RotateTime        = data["rotateTime"] or 2.0    -- 匀速转动的时间之和
    self.MaxSpeed          = data["maxSpeed"] or 60    --每一秒滚动的距离
    self.DownBounce        = data["downBounce"] or 10.0   --滚动结束前，向下反弹距离  都为正数值
    self.SpeedDownTime     = data["speedDownTime"] or 0.25
    self.DownBounceTime    = data["downBounceTime"] or 0.25
    self.bounceSpeed       = data["bounceSpeed"] or 1  -- 转盘需要回弹的时候，回弹开始前转盘的速度
    self.pointerMaxRotation   = data["pointerMaxRotation"] or 25  -- 转盘指针最大的旋转角度
    self.pointerStart     = data["pointerStart"] or 5     -- 转盘指针开始动的位置
    self.pointerEnd     = data["pointerEnd"] or 10        -- 转盘指针开始回弹的位置
    self.pointerResumeTime = data["pointerResumeTime"] or 0.2   -- 回弹所用的时间
    self.finishSpeed       = data["finishSpeed"] or nil
	
	self._onEndCallback	   = callFunc
	self._direction 	   = data["direction"] 
    self.itemDis = 360/self.ItemCount

    if self.pointer then
        self.pointerTorque = self.pointerEnd - self.pointerStart
    end

    self.needBounce = false

	self.isSpinning        = false 
	self.isStopping		   = false
    
end

function BaseWheelExtendI:moveUpdate(dt)
    if not bole.isValidNode(self.WheelNode) then
        if self.scheduler then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
        end
        return
    end
    if self.isSpinning and self.WheelNode and bole.isValidNode(self.WheelNode)then
        local angle,leftTime = self:getMoveDis(dt);
        if self.CRotatingState == RotatingState.FinishStop then
            self.WheelNode:setRotation(self.WheelNode:getRotation()+angle)
	        self:onRotateStoped();
	        return
        elseif self._direction == DirectionType.clockwise then
            self.WheelNode:setRotation(self.WheelNode:getRotation()+angle)
            self:updatePointer(angle<0)
	        if not self.isSpinning then
	            self:onRotateStoped();
	            return
	        end
        elseif self._direction == DirectionType.anticlockwise then
			 self.WheelNode:setRotation(self.WheelNode:getRotation()-angle)
	         if not self.isSpinning then
	             self:onRotateStoped();
	             return
	         end
        end
        
		if leftTime then 
			if leftTime>0 then 
				self:moveUpdate(leftTime)
			elseif leftTime == -1 then
    			self:fixStop()
			end
		end
    end
end

function BaseWheelExtendI:updatePointer(isback)
    if self.pointer then
        local angle = self.WheelNode:getRotation()
        local curAngleDis = angle%self.itemDis
        if curAngleDis > self.pointerStart and curAngleDis <= self.pointerEnd then
            self.reachMax = false
            if self.pointAction then
                self.pointer:stopAction(self.pointAction)
                self.pointAction = nil
            end
            local pointerR = -self.pointerMaxRotation*(curAngleDis-self.pointerStart)/self.pointerTorque
            self.pointer:setRotation(pointerR)

        else
            if not isback and not self.reachMax then
                self.pointer:setRotation(-self.pointerMaxRotation+math.random(0, 5))
                self.reachMax = true
            else
                if not self.pointAction then
                    self.pointAction = self.pointer:runAction(cc.RotateTo:create(self.pointerResumeTime, 0))
                end
            end
        end
    end
end

function BaseWheelExtendI:start()
    self._delayBeforeSpin = self.DelayBeforeSpin;
    self.isSpinning = true;
    self._rotateTime = 0;
    self.RotatingTime = 0.0;
    self.Speed = 0;
    self.allSlowDown = 0
    self.CRotatingState = RotatingState.Ready;
    self._acceleration = self.MaxSpeed/self.SpeedUpTime;
    self.needFixTime = true
    self.reachMax = true
    -- 打开update 
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
    	self:moveUpdate(ft)
    end,Interval,false)
end

function BaseWheelExtendI:fixStop( ... )
    if math.random(0, 50) < 25 then
        self.needBounce = true
    end

    local curAngle = self.WheelNode:getRotation()%360
    local endSpeed = 0
    local extraBounce = 0
    self.bounceTime = 0
    if self.needBounce then
        endSpeed = self.bounceSpeed
        extraBounce = self.DownBounce
        self.bounceTime = self.DownBounceTime
    end

    local moveDis = (self.MaxSpeed + endSpeed)*self.SpeedDownTime/2

    local curDis = self.endAngle + extraBounce - curAngle
    if self._direction == DirectionType.anticlockwise then
        curDis = 360 - curDis
    end
    while curDis < moveDis do
        curDis = curDis+360
    end
    self._rotateTime  = 0
    self.RotateTime = (curDis-moveDis)/self.MaxSpeed
    -- self.RotateTime = self.RotateTime + (curDis-moveDis)/self.MaxSpeed
    self._acceleration = (endSpeed - self.MaxSpeed)/self.SpeedDownTime

    self._downacceleration = self.downAngle/(self.downAngleTime * 30)

end

function BaseWheelExtendI:onRotateStoped( ... )
	if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
    if self._onEndCallback then 
        self._onEndCallback(self.delayBonus) -- 执行回调方法
    end
end

function BaseWheelExtendI:stop(data)
    self.endAngle          = data["endAngle"] -- 结束角度
    self.RotateTime        = data["RotateTime"] -- 结束角度
end

function BaseWheelExtendI:getMoveDis(dt) 
    self._rotateTime = self._rotateTime + dt;
    local dis = 0; 
    local leftTime = nil
    if self.CRotatingState == RotatingState.Idle then
        dis = dt * self.idleSpeed
    elseif self.CRotatingState == RotatingState.Ready then -- 准备阶段 spin 之后的延迟时间
        -- print("zhf RotatingState.Ready")
    	if self._rotateTime>self._delayBeforeSpin then
            self.CRotatingState = RotatingState.BounceUp;
            self._rotateTime = 0;
        end
    elseif self.CRotatingState == RotatingState.BounceUp then -- 上弹阶段
        -- print("zhf RotatingState.BounceUp self._rotateTime = ",self._rotateTime)
    	if self._rotateTime>self.UpBounceTime then
            -- self.RotatingTime = 0;
            leftTime = (self._rotateTime - self.UpBounceTime)
            dt = dt - leftTime;
            self.CRotatingState = RotatingState.SpeedUp;
            self._rotateTime = 0;
        end
        if self.UpBounceTime == 0 then
            dis = 0
        else
            dis = -self.UpBounce*dt/self.UpBounceTime; -- 仅仅是 横向逻辑
        end
	elseif self.CRotatingState == RotatingState.SpeedUp then -- 加速阶段
        -- print("zhf RotatingState.SpeedUp self._rotateTime = ",self._rotateTime)
		if self._rotateTime>self.SpeedUpTime then
			leftTime = (self._rotateTime - self.SpeedUpTime)
		    dt = dt - leftTime;
        	self.CRotatingState = RotatingState.MaxSpeed;
            self._rotateTime = 0;
    	end
        local tempSpeed = self.Speed;
        self.Speed = self.Speed+ self._acceleration * dt;
        dis =(self.Speed + tempSpeed)*dt/2;
    elseif self.CRotatingState == RotatingState.MaxSpeed then -- 匀速阶段
        -- print("zhf RotatingState.MaxSpeed self._rotateTime = ",self._rotateTime)
    	if self._rotateTime>self.RotateTime then
            if self.needFixTime then
                self.needFixTime = false
                leftTime = -1
            else
                self.CRotatingState = RotatingState.SpeedDown;
                leftTime = (self._rotateTime - self.RotateTime)
                dt = dt - leftTime;
                self.isStopping  = true
                self._rotateTime = 0;
            end
        end
        dis = self.MaxSpeed*dt;
        -- if self.maxSpeedDis then
        --     self.maxSpeedDis = self.maxSpeedDis + dis
        --     self.maxSpeedTime = self.maxSpeedTime + dt
        --     -- print("zhf maxSpeedDis = ".. self.maxSpeedDis .. " dis = " .. dis .. " time = " .. self.maxSpeedTime .. " RotateTime = " .. self.RotateTime .. " _rotateTime = ",self._rotateTime)
        -- end
    elseif self.CRotatingState == RotatingState.SpeedDown then -- 减速阶段
        -- print("zhf RotatingState.SpeedDown self._rotateTime = ",self._rotateTime)
        if self._rotateTime>self.SpeedDownTime then
        	leftTime = (self._rotateTime - self.SpeedDownTime)
            dt = dt - leftTime;
            self.CRotatingState = RotatingState.SlowDown;
            self._rotateTime = 0;
        end
	    if self.SpeedDownTime == 0 then
            dis = 0;
        else
            local tempSpeed = self.Speed;
            self.Speed = self.Speed + self._acceleration * dt;
            dis =(self.Speed + tempSpeed)*dt/2;
            self.speedDownAngle = dis
		end
        if self.finishSpeed and self.Speed < self.finishSpeed then 
            self.CRotatingState = RotatingState.FinishStop
        end
    elseif self.CRotatingState == RotatingState.SlowDown then -- 缓慢的减速
        dis = 0 
        if self.allSlowDown < self.downAngle then
            if self._downacceleration < 0 then
                self._downacceleration = 0.2
            end
            dis = self._downacceleration 
            self.allSlowDown = self.allSlowDown + dis
        else
           self.CRotatingState = RotatingState.BounceDown     
        end
         
    elseif self.CRotatingState == RotatingState.BounceDown then -- 回弹阶段 
        self.bounce = true 
        if self._rotateTime>self.bounceTime then
        	self.isSpinning = false
            self.CRotatingState = RotatingState.Ready;
            leftTime = (self._rotateTime - self.bounceTime)
            dt = dt - leftTime;
            self._rotateTime = 0;
        end
        if self.bounceTime == 0 then
            dis = 0;
        else
            dis = -self.DownBounce*dt/self.bounceTime;
	    end
    else
    end
    return dis,leftTime;
end

function BaseWheelExtendI:resetCurDetalAngle () -- 获取当前位置 转动多久之后会回到角度为0 
    local curAngel = self.WheelNode:getRotation()

    self._DetalAngle = 360 - curAngel%360
end

function BaseWheelExtendI:updateWheelData( data )
    if data.endAngle then 
        self.endAngle = data.endAngle
    end
    if data.rotateTime then -- 必须更新时间, 否则 没有 匀速时间
        self.RotateTime = data.rotateTime
    end
end

function BaseWheelExtendI:isResetWheelState()
    self.isSpinning        = false 
    self.isStopping        = false 
end

function BaseWheelExtendI:stopScheduler( ... )
    if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
end

function BaseWheelExtendI:playIdleAnim(_continueSpeed)
    self.CRotatingState = RotatingState.Idle
    self.idleSpeed = _continueSpeed or 0.2
    
    self._rotateTime = 0
    
    self.isSpinning = true
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
        self:moveUpdate(ft)
        end,Interval,false)
end

function BaseWheelExtendI:stopIdleAnim()
    self.CRotatingState = RotatingState.Idle
    self.continueSpeed = self.continueSpeed or 0.2
    self.isSpinning = false
    self:stopScheduler()
end







