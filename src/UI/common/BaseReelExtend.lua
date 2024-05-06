
--------------------
------1 控制转动方向通过 getMoveDis 方法来控制
BaseReelExtend = class("BaseReelExtend")

local RotatingState = {
    Ready        = 0,
    BounceUp     = 1,
    SpeedUp 	 = 2,
    MaxSpeed 	 = 3,
    SpeedDown 	 = 4,
    BounceDown 	 = 5,
    SpinOver	 = 6,
    NormalRoll   = 7,

}
local DirectionType = {
	horizontal   = 1, -- 横向
	vertical     = 2, -- 竖向
}

local Interval = 0

function BaseReelExtend:ctor( theme, items, data,callFunc)
	self._theme            = theme
	self.Icons			   = items 
	self.IconCount         = data["itemCount"] or 5 -- 上下加一个 cell 之后的个数
	self.finshKey		   = data["key"]
    -- self.finshRollSumLength = data["finshRollSumLength"]
	self._cellSize         = data["cellSize"]
    self.normalSpeed       = data["normalSpeed"] or 0.0    --开始旋转前的时间延迟
	self.DelayBeforeSpin   = data["delayBeforeSpin"] or 0.0    --开始旋转前的时间延迟
    self.UpBounce          = data["upBounce"] or 10     --开始滚动前，向上滚动距离
    self.UpBounceTime      = data["upBounceTime"] or 0.2    --开始滚动前，向上滚动时间
    self.SpeedUpTime       = data["speedUpTime"] or 0.5    --加速时间
    self.RotateTime        = data["rotateTime"] or 2.0    -- 匀速转动的时间之和
    self.MaxSpeed          = data["maxSpeed"] or -200     --每一秒滚动的距离
    self.DownBounce        = data["downBounce"] or 0   --滚动结束前，向下反弹距离  都为正数值
    self.SpeedDownTime     = data["speedDownTime"] or 2
    self.DownBounceTime    = data["downBounceTime"] or 0.25

    -- 新加参数
    self.deltaType         = data["deltaType"] or 0  -- 控制多移动一点 有一种期待效果(参数不传没有效果) 
    self.addEndPos         = data["addEndPos"] -- 控制结果多向下移动的位置
    self.addStartPos       = data["addStartPos"] -- 控制开始显示的时候 多移动的位置(上下都可以 但是最好不要超过一个 格子 要不然 会穿帮)
	
	self._onSpinStoped	   = callFunc
	self._direction 	   = data["direction"] 
    self._lastP            = data["lastPosition"] 

    self.speedDownAcceleration  = data["speedDownAcceleration"] or 1125
    self.speedDownSpeed         = data["speedDownSpeed"] or -2251


	self.isSpinning        = false 
	self.isStopping		   = false
	-- self:setCellSprite(data["startIndex"])
	-- self:resetFirstIconPosition()
 --    self:setStartPos()
    self:initReel()
end
-- function BaseReelExtend:setStartPos()
--     if self.addStartPos and self.addStartPos ~= 0 then 
--         for k,icon in ipairs(self.Icons) do
--             icon[2]:setPositionY(icon[2]:getPositionY()+self.addStartPos)
--         end
--         while self:_lastIcon():getPositionY() < self._lastP.y do
--             self:moveToTail()
--         end
--     end
-- end
-- function BaseReelExtend:setCellSprite(startIndex)
-- 	local items = {}
-- 	if self._direction == DirectionType.horizontal then
-- 		local index = startIndex
-- 		for i=0,#self.Icons-1 do 
-- 			if index > #self.Icons then
-- 				index = 1
-- 			end
-- 			self.Icons[index][2]:setPositionX((i-0.5)*self._cellSize.x)
-- 			table.insert(items,self.Icons[index])
-- 			index= index+1
-- 		end
-- 	elseif self._direction == DirectionType.vertical then
--         local index = startIndex
-- 		for i=0,#self.Icons-1 do 
-- 			if index > #self.Icons then
-- 				index = 1
-- 			end
-- 			self.Icons[index][2]:setPositionY((i-0.5)*(-self._cellSize.y))
-- 			table.insert(items,self.Icons[index])
--             index= index+1
-- 		end		
-- 	end

-- 	self.Icons = items
-- end

function BaseReelExtend:moveUpdate(dt)
	-- self.RotatingTime+=dt;
    if  self.isSpinning then

        local dis,leftTime = self:getMoveDis(dt);
        if self._direction == DirectionType.horizontal then
			for k,icon in ipairs(self.Icons) do
                icon:setPositionX(icon:getPositionX()+dis)
	        end
	        if not self.isSpinning then
	            self:onSpinStoped();
	            return
	        end
	        while self:_lastIcon():getPositionX() < self._lastP.x do
	            self:moveToTail();
			end
        elseif self._direction == DirectionType.vertical then
			for  k,icon in ipairs(self.Icons) do
                icon:setPositionY(icon:getPositionY()-dis)
	        end
	        if not self.isSpinning then
	            self:onSpinStoped();
	            return
	        end
	        while self:_lastIcon():getPositionY() < self._lastP.y do
	            self:moveToTail();
			end
        end
        
		-- if leftTime then 
		-- 	if  leftTime>0 then 
		-- 		-- self:moveUpdate(leftTime)
		-- 	elseif leftTime == -1 then
  --   			self:doStopSpin()
		-- 	end

		-- end

    end
end

function BaseReelExtend:startSpin()
    -- self._delayBeforeSpin = self.DelayBeforeSpin;
    -- self.isSpinning = true;
    self._rotateTime = 0;
    -- self.RotatingTime = 0.0;
    self.Speed = self.normalSpeed;
    self._acceleration = (self.MaxSpeed - self.normalSpeed)/self.SpeedUpTime;
    -- print("zhf startSpin ",self._acceleration,self.Speed)
    if self.UpBounceTime ~= 0 then
        self.CRotatingState = RotatingState.BounceUp;
    else
        self.CRotatingState = RotatingState.SpeedUp;
    end

    self.spinTotalTime = 0
    

    -- 打开update 
    -- self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
    -- 	self:moveUpdate(ft)
    -- 	end,Interval,false)
end

function BaseReelExtend:initReel()
    self._delayBeforeSpin = self.DelayBeforeSpin;
    self.isSpinning = true;
    self._rotateTime = 0;
    self.RotatingTime = 0.0;
    self.Speed = 0;
    self.CRotatingState = RotatingState.Ready;
    

    -- 打开update 
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
        self:moveUpdate(ft)
    end,Interval,false)
end

function BaseReelExtend:doStopSpin(data)
    -- print("whj: data",tool.lua_to_json(data))
    local _curSpinTotalTime = self.spinTotalTime
    local _needMaxSpeedTime = 0
    if _curSpinTotalTime < 5 then 
        _needMaxSpeedTime = 5 - _curSpinTotalTime
    end
    -- print("whj: _needMaxSpeedTime",_needMaxSpeedTime)

    -- 需要移动的 cell 个数判断
    local finshCount = #self.Icons  
	local finshFirstKey = nil
    self.finshKey = data.index or 10

    local curFinshKeyPos = 0
    -- print("whj: self.finshKey")
    -- 需要方向判断 
    if self._direction == DirectionType.horizontal then -- 横屏
    	for k,v in ipairs(self.Icons) do 
	    	if (not finshFirstKey) and v.key == self.finshKey then -- 需要验证
                curFinshKeyPos = v:getPositionX()
    --             finshFirstKey = (k - (self.IconCount-1)/2) % finshCount
				-- finshCount = (finshCount - (finshFirstKey-1))
                break
	    	end
  		end
        self.tempBounce = (curFinshKeyPos + self.IconCount*self._cellSize.x) -- (finshCount*self._cellSize.x + (self._lastP.x - self:_lastIcon():getPositionX())) + self.DownBounce + self.IconCount*self._cellSize.x
        -- print("whj: curFinshKeyPos, , tempBounce", curFinshKeyPos, self.tempBounce)
	else
  --       for k,v in ipairs(self.Icons) do  -- 使用遍历 可以从当前的进度开始
  --           if v[1] == self.finshKey then
  --               finshFirstKey = (k - (self.IconCount-1)/2) % finshCount
  --               finshCount = (finshCount - (finshFirstKey-1)) + (#self.Icons*(2 or self.finshRollSumLength))
  --               break
  --           end
  --       end
        
  --       self._deltaDis = 0
  --       if self.deltaType == 1 then 
  --           local a = math.random(0,1)
  --           if a>0.5 then 
  --               self._deltaDis = self._cellSize.y/2
  --           else
  --               self._deltaDis = -self._cellSize.y/2
  --           end
  --       elseif self.deltaType==2 then
  --           self._deltaDis = math.random(0,self._cellSize.y)-self._cellSize.y/2 -- 有随机性的感觉
  --       end
  --       -- 计算一个 绝对值！！！！！
		-- self.tempBounce =  finshCount*self._cellSize.y + (self:_lastIcon():getPositionY() - self._lastP.y) + self.DownBounce + self._deltaDis
  --       if self.addEndPos then 
  --           self.tempBounce =  self.tempBounce + self.addEndPos 
  --       end
	end

    -- -- 计算出 剩余匀速时间
    local speedDownBonuce =  math.abs(self.SpeedDownTime *self.MaxSpeed/2)
    -- while self.tempBounce < speedDownBonuce do
    --     self.tempBounce = self.tempBounce+self.IconCount*self._cellSize.x
    -- end
    local overMaxBounce = self.tempBounce - speedDownBonuce
    -- print("whj: self.tempBounce overMaxBounce speedDownBonuce ",self.tempBounce,overMaxBounce,speedDownBonuce)
    local _overMaxTime = overMaxBounce/math.abs(self.MaxSpeed)
    while _overMaxTime < _needMaxSpeedTime do 
        overMaxBounce = overMaxBounce + self.IconCount*self._cellSize.x
        _overMaxTime = overMaxBounce/math.abs(self.MaxSpeed)
        
    end
    -- print("zhf _overMaxTime, speedDownBonuce ",_overMaxTime, speedDownBonuce)
    -- print("whj: _overMaxTime",_overMaxTime)
    self.CRotatingState = RotatingState.MaxSpeed
    self._rotateTime = 0
    self.RotateTime = _overMaxTime
   
    
    -- whj 修改为 末速度为0 的计算 ，计算出 负的加速的 和新的 进入减速阶段的速度速度
    -- self._acceleration = (2*self.tempBounce)/self.SpeedDownTime/self.SpeedDownTime
    -- self.Speed = -math.abs(self._acceleration * self.SpeedDownTime)
    -- print("whj: self._acceleration, self.Speed", self._acceleration, self.Speed)
    -- self.isStopping  = true
    -- self._rotateTime = 0;
end
function BaseReelExtend:onSpinStoped( ... )
	if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
    self:resetCellPos()
	self._onSpinStoped() -- 执行回调方法
end

function BaseReelExtend:resetCellPos()
    if self._direction == DirectionType.horizontal then

    else  
        if self._deltaDis~=0 then 
            for k,v in pairs(self.Icons) do 
                local pos = cc.p(v:getPosition())
                v:runAction(cc.MoveTo:create(22/60,cc.p(pos.x,pos.y + (self._deltaDis or 0)))) 
            end
        end
    end

end

function BaseReelExtend:moveToTail ()  -- 把第一个移动到最后面
    local newIcon =table.remove(self.Icons,1)
    
    if self._direction == DirectionType.horizontal then
        newIcon:setPosition(cc.p(self:_lastIcon():getPositionX()+self._cellSize.x, self._lastP.y));
    else
        newIcon:setPosition(cc.p(self._lastP.x,self:_lastIcon():getPositionY()+self._cellSize.y));
    end
    
    table.insert(self.Icons,newIcon)
end

function BaseReelExtend:getMoveDis(dt) 

    self._rotateTime = self._rotateTime + dt;
    local dis = 0; 
    local leftTime = 0
    if self.CRotatingState == RotatingState.Ready then -- 准备阶段 spin 之后的延迟时间
    	if self._rotateTime>self._delayBeforeSpin then
            self.CRotatingState = RotatingState.NormalRoll;
            self._rotateTime = 0;
        end
    elseif self.CRotatingState == RotatingState.NormalRoll then -- 慢速阶段
        dis = self.normalSpeed*dt; 
        self.Speed = self.normalSpeed
        -- print("zhf RotatingState.NormalRoll ",dis)
    elseif self.CRotatingState == RotatingState.BounceUp then -- 上弹阶段
    	if self._rotateTime>self.UpBounceTime then
            -- self.RotatingTime = 0;
            leftTime = (self._rotateTime - self.UpBounceTime)
            -- dt = dt - leftTime;
            self.CRotatingState = RotatingState.SpeedUp;
            self._rotateTime = 0;
        end
        if self.UpBounceTime == 0 then
            dis = 0
        else
            dis = -self.UpBounce*dt/self.UpBounceTime; -- 仅仅是 横向逻辑
            self.Speed = dis
        end
	elseif self.CRotatingState == RotatingState.SpeedUp then -- 加速阶段
        -- print("zhf SpeedUp self._rotateTime =",self._rotateTime,self.SpeedUpTime)
		if self._rotateTime>self.SpeedUpTime then
			leftTime = (self._rotateTime - self.SpeedUpTime)
		    -- dt = dt - leftTime;
        	self.CRotatingState = RotatingState.MaxSpeed;
            self._rotateTime = 0;
    	end
        -- print("tsc----------- speedup : before="..self.Speed.." acc="..self._acceleration.." dt="..dt)
        local tempSpeed = self.Speed;
        self.Speed = self.Speed+ self._acceleration * dt;
        dis =(self.Speed + tempSpeed)*dt/2;
    elseif self.CRotatingState == RotatingState.MaxSpeed then -- 匀速阶段
        -- print("zhf MaxSpeed self._rotateTime =",self._rotateTime,self.RotateTime)
    	if self._rotateTime>self.RotateTime then
            leftTime = (self._rotateTime - self.RotateTime)
            -- dt = dt - leftTime

            self.CRotatingState = RotatingState.SpeedDown
            self._rotateTime = 0
            self.isStopping  = true
            self._acceleration = -self.MaxSpeed/self.SpeedDownTime
            -- 修改成固定值
            -- self._acceleration = -self.MaxSpeed/self.SpeedDownTime
            -- print("whj;  self._acceleration, self.Speed",self._acceleration, self.Speed)
            -- self._acceleration = (2*self.tempBounce)/self.SpeedDownTime/self.SpeedDownTime
            -- self.Speed = -math.abs(self._acceleration * self.SpeedDownTime)
        end
        dis = self.MaxSpeed*dt;
        self.Speed = self.MaxSpeed
        -- print("whj MaxSpeed dis =",dis)
    elseif self.CRotatingState == RotatingState.SpeedDown then -- 减速阶段
        -- print("zhf SpeedDown self._rotateTime =",self._rotateTime,self.SpeedDownTime)
        if self._rotateTime>self.SpeedDownTime then
        	leftTime = (self._rotateTime - self.SpeedDownTime)
         --    dt = dt - leftTime;
            self.CRotatingState = RotatingState.BounceDown;
            self._rotateTime = 0
        end
	    if self.SpeedDownTime == 0 then
            dis = 0;
        else
            local tempSpeed = self.Speed;
            self.Speed = self.Speed + self._acceleration * dt;
            dis =(self.Speed + tempSpeed)*dt/2;
		end
        -- print("whj SpeedDown dis =",dis)
    elseif self.CRotatingState == RotatingState.BounceDown then -- 回弹阶段  
        if self._rotateTime>self.DownBounceTime then
        	self.isSpinning = false
            self.CRotatingState = RotatingState.Ready;
            leftTime = (self._rotateTime - self.DownBounceTime)
            -- dt = dt - leftTime;
            self._rotateTime = 0;
        end
        if self.DownBounceTime == 0 then
            dis = 0;
        else
            dis = -self.DownBounce*dt/self.DownBounceTime;
	    end
    else
    end
    if self.spinTotalTime then 
        self.spinTotalTime = self.spinTotalTime + dt 
        if leftTime>0 then 
            self.spinTotalTime = self.spinTotalTime - leftTime
        end
    end
    -- print("tsc-----------state : "..self.CRotatingState..", dis : "..dis..", speed : "..self.Speed)

    return dis,leftTime;
end

-- function BaseReelExtend:resetFirstIconPosition () 
-- 	if self._direction == DirectionType.horizontal then
-- 		self._lastP =  cc.p(-self._cellSize.x/2,(self._cellSize.y)/2); -- 横向
-- 	elseif self._direction == DirectionType.vertical then
-- 		self._lastP =  cc.p(0,(self._cellSize.y)/2) -- 竖向
-- 	end
-- end
function BaseReelExtend:_lastIcon()
    return self.Icons[#self.Icons];
end







