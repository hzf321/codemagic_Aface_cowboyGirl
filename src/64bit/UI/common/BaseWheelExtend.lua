
--------------------
------1 控制转动方向通过 getMoveDis 方法来控制
BaseWheelExtend = class("BaseWheelExtend")

local RotatingState = {
    Ready        = 0,
    BounceUp     = 1,
    SpeedUp 	 = 2,
    MaxSpeed 	 = 3,
    SpeedDown 	 = 4,
    BounceDown 	 = 5,
    SpinOver	 = 6,

}
local DirectionType = {
	clockwise      = 1, -- 顺时针
	anticlockwise  = -1, -- 逆时针
}

local Interval = 0

function BaseWheelExtend:ctor( theme, wheelNode,pointer, data,callFunc)
	self._theme            = theme -- pickGame
    self.WheelNode         = wheelNode
    self.pointer = pointer
	-- self.Icons			   = data["WheelItems"] 
 --    self.IconsPos          = data["WheelItemPos"] -- 用来随机产生位置的
    self.endAngle          = data["endAngle"] -- 结束角度
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
	
	self._onEndCallback	   = callFunc
	self._direction 	   = data["direction"] 
    self.itemDis = 360/self.ItemCount

    if self.pointer then
        self.pointerTorque = self.pointerEnd - self.pointerStart
        -- print("zhf self.pointerTorque = ",self.pointerTorque)
    end

    self.needBounce = false

	self.isSpinning        = false 
	self.isStopping		   = false
    
end

function BaseWheelExtend:moveUpdate(dt)
    if not bole.isValidNode(self.WheelNode) then
        if self.scheduler then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
        end
        return
    end
    if self.isSpinning and self.WheelNode and bole.isValidNode(self.WheelNode)then
        local angle,leftTime = self:getMoveDis(dt);
        -- print("zhf moveDis = ",angle)
        if self._direction == DirectionType.clockwise then
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

function BaseWheelExtend:updatePointer(isback)
    -- print("zhf movedAngle = ",movedAngle)
    if self.pointer then
        -- if movedAngle > self.itemDis then
        --     print("zhf repeatAction")
        --     if self.pointAction then
        --         self.pointer:stopAction(self.pointAction)
        --         self.pointAction = nil
        --     end
        --     if not self.repeatAction then 
        --         self.repeatAction = self.pointer:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.RotateTo:create(0.2, self.pointerMaxRotation),cc.RotateTo:create(0.2, self.pointerMaxRotation-5))))
        --     end
        -- else
        -- if self.repeatAction then
        --     self.pointer:stopAction(self.repeatAction)
        --     self.repeatAction = nil
        -- end
        local angle = self.WheelNode:getRotation()
        local curAngleDis = angle%self.itemDis
        if curAngleDis > self.pointerStart and curAngleDis <= self.pointerEnd then
            self.reachMax = false
            if self.pointAction then
                self.pointer:stopAction(self.pointAction)
                self.pointAction = nil
            end
            local pointerR = -self.pointerMaxRotation*(curAngleDis-self.pointerStart)/self.pointerTorque
            -- print("zhf current angle = " .. self.pointer:getRotation() .. " setRotation =  " .. pointerR)
            self.pointer:setRotation(pointerR)

            -- self.pointAction = self.pointer:runAction(cc.RotateTo:create(0.1, pointerR))
            -- print("zhf current pointerR = ",pointerR)
        -- elseif curAngleDis > self.pointerEnd and curAngleDis < self.itemDis then
        --     print("zhf resume pointer")
        --     self.pointer:runAction(cc.RotateTo:create(self.pointerResumeTime, 0))

        else
            if not isback and not self.reachMax then
                -- print("zhf pointerMaxRotation")
                self.pointer:setRotation(-self.pointerMaxRotation+math.random(0, 5))
                -- self.pointAction = self.pointer:runAction(cc.RotateTo:create(dt, -self.pointerMaxRotation))
                self.reachMax = true
            else
                -- print("zhf resume pointer")
                if not self.pointAction then
                    self.pointAction = self.pointer:runAction(cc.RotateTo:create(self.pointerResumeTime, 0))
                end
            end
            -- print("zhf resume pointer")
            -- if not self.pointAction then
                -- print("zhf real resume pointer")
                
            -- end
        end
        -- end

        
    end
end

function BaseWheelExtend:start()
    self._delayBeforeSpin = self.DelayBeforeSpin;
    self.isSpinning = true;
    self._rotateTime = 0;
    self.RotatingTime = 0.0;
    self.Speed = 0;
    self.CRotatingState = RotatingState.Ready;
    self._acceleration = self.MaxSpeed/self.SpeedUpTime;
    self.needFixTime = true
    self.reachMax = true
    -- 打开update 
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
    	self:moveUpdate(ft)
    end,Interval,false)
end

function BaseWheelExtend:fixStop( ... )
    if self.hasNearMiss then  
        self.needBounce = true
    else
        if math.random(0, 50) < 25 then
            self.needBounce = true
        end
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
        curDis = 360 - (self.endAngle - extraBounce - curAngle)--360 - curDis
    end
    while curDis < moveDis do
        curDis = curDis+360
    end
    self._rotateTime  = 0
    self.RotateTime = (curDis-moveDis)/self.MaxSpeed
    -- self.RotateTime = self.RotateTime + (curDis-moveDis)/self.MaxSpeed
    self._acceleration = (endSpeed - self.MaxSpeed)/self.SpeedDownTime
end

function BaseWheelExtend:onRotateStoped( ... )
	if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
    if self._onEndCallback then
        self._onEndCallback(self.delayBonus) -- 执行回调方法
    end
end

function BaseWheelExtend:stop(data)
    self.endAngle          = data["endAngle"] -- 结束角度
    self.RotateTime        = data["RotateTime"] -- 结束角度
end

function BaseWheelExtend:getMoveDis(dt) 
    self._rotateTime = self._rotateTime + dt;
    local dis = 0; 
    local leftTime = nil
    if self.CRotatingState == RotatingState.Ready then -- 准备阶段 spin 之后的延迟时间
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
            self.CRotatingState = RotatingState.BounceDown;
            self._rotateTime = 0;
        end
	    if self.SpeedDownTime == 0 then
            dis = 0;
        else
            local tempSpeed = self.Speed;
            self.Speed = self.Speed + self._acceleration * dt;
            dis =(self.Speed + tempSpeed)*dt/2;
		end
        -- if self.speedDownDis then
        --     self.speedDownDis = self.speedDownDis + dis
        --     print("zhf speedDownDis = ",self.speedDownDis)
        -- end
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

function BaseWheelExtend:resetCurDetalAngle () -- 获取当前位置 转动多久之后会回到角度为0 
    local curAngel = self.WheelNode:getRotation()

    self._DetalAngle = 360 - curAngel%360
end

function BaseWheelExtend:updateWheelData( data )
    if data.endAngle then 
        self.endAngle = data.endAngle
    end
    if data.rotateTime then -- 必须更新时间, 否则 没有 匀速时间
        self.RotateTime = data.rotateTime
    end

    if data.nearMiss then -- 必须更新时间, 否则 没有 匀速时间
        self.hasNearMiss = data.nearMiss
    end
    if data.DownBounce then -- 必须更新时间, 否则 没有 匀速时间
        self.DownBounce = data.DownBounce
    end
    if data.DownBounceTime then -- 必须更新时间, 否则 没有 匀速时间
        self.DownBounceTime = data.DownBounceTime
    end
end

function BaseWheelExtend:isResetWheelState()
    self.isSpinning        = false 
    self.isStopping        = false 
end
function BaseWheelExtend:stopScheduler()
    if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
end







