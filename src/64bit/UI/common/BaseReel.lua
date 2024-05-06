
--------------------
------1 控制转动方向通过 getMoveDis 方法来控制
BaseReel = class("BaseReel")

local RotatingState = {
    Ready        = 0,
    BounceUp     = 1,
    SpeedUp 	 = 2,
    MaxSpeed 	 = 3,
    SpeedDown 	 = 4,
    BottomStop   = 5,
    BounceDown 	 = 6,
    SpinOver	 = 7,
    Continue     = 8
}
local DirectionType = {
	horizontal   = 1, -- 横向
	vertical     = 2, -- 竖向
}

local Interval = 0

function BaseReel:ctor( theme, items, data,callFunc)
	self._theme            = theme
	self.Icons			   = items 
	self.IconCount         = data["itemCount"] or 5 -- 上下加一个 cell 之后的个数
	self.finshKey		   = data["key"]
    self.finshRollSumLength = data["finshRollSumLength"]
	self._cellSize         = data["cellSize"]
	self.DelayBeforeSpin   = data["delayBeforeSpin"] or 0.0    --开始旋转前的时间延迟
    self.UpBounce          = data["upBounce"] or 10     --开始滚动前，向上滚动距离
    self.UpBounceTime      = data["upBounceTime"] or 0.2    --开始滚动前，向上滚动时间
    self.SpeedUpTime       = data["speedUpTime"] or 0.5    --加速时间
    self.RotateTime        = data["rotateTime"] or 2.0    -- 匀速转动的时间之和
    self.MaxSpeed          = data["maxSpeed"] or 60     --每一秒滚动的距离
    self.DownBounce        = data["downBounce"] or 10.0   --滚动结束前，向下反弹距离  都为正数值
    self.SpeedDownTime     = data["speedDownTime"] or 0.25
    self.DownBounceTime    = data["downBounceTime"] or 0.25
    self.downStopTime      = data["downStopTime"] or 0  --滚到底部停止的时间
    -- 新加参数
    self.deltaType         = data["deltaType"] or 0  -- 控制多移动一点 有一种期待效果(参数不传没有效果) 
    self.addEndPos         = data["addEndPos"] -- 控制结果多向下移动的位置
    self.addStartPos       = data["addStartPos"] -- 控制开始显示的时候 多移动的位置(上下都可以 但是最好不要超过一个 格子 要不然 会穿帮)
    self.specailHorizontal = data["specailHorizontal"] --  横着多移动一点
	
	self._onSpinStoped	   = callFunc
	self._direction 	   = data["direction"] 



	self.isSpinning        = false 
	self.isStopping		   = false
	
	self:setCellSprite(data["startIndex"])
	self:resetFirstIconPosition()
    self:setStartPos()
end
function BaseReel:setStartPos()
    if self.addStartPos and self.addStartPos ~= 0 then 
        for k,icon in ipairs(self.Icons) do
            icon[2]:setPositionY(icon[2]:getPositionY()+self.addStartPos)
        end
        while self:_firstIcon():getPositionY() < self._firstP.y do
            self:moveToHead()
        end
    end
end
function BaseReel:setCellSprite(startIndex)
	local items = {}
	if self._direction == DirectionType.horizontal then
		local index = startIndex
		for i=0,#self.Icons-1 do 
			if index > #self.Icons then
				index = 1
			end
			self.Icons[index][2]:setPositionX((i-0.5)*self._cellSize.x)
			table.insert(items,self.Icons[index])
			index= index+1
		end
	elseif self._direction == DirectionType.vertical then
        local index = startIndex
		for i=0,#self.Icons-1 do 
			if index > #self.Icons then
				index = 1
			end
			self.Icons[index][2]:setPositionY((i-0.5)*(-self._cellSize.y))
			table.insert(items,self.Icons[index])
            index= index+1
		end		
	end

	self.Icons = items
end

function BaseReel:moveUpdate(dt)
	-- self.RotatingTime+=dt;
    if not bole.isValidNode(self:_firstIcon()) then
        AudioControl:stopAllEffects()
        if self.scheduler then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
        end
        return
    end
    if  self.isSpinning then

        local dis,leftTime = self:getMoveDis(dt);
        if self._direction == DirectionType.horizontal then
			for  k,icon in ipairs(self.Icons) do
                icon[2]:setPositionX(icon[2]:getPositionX()+dis)
	        end
	        if not self.isSpinning then
	            self:onSpinStoped();
	            return
	        end
	        while self:_firstIcon():getPositionX() > self._firstP.x do
	            self:moveToHead();
			end
        elseif self._direction == DirectionType.vertical then
			for  k,icon in ipairs(self.Icons) do
                icon[2]:setPositionY(icon[2]:getPositionY()-dis)
	        end
	        if not self.isSpinning then
	            self:onSpinStoped();
	            return
	        end
	        while self:_firstIcon():getPositionY() < self._firstP.y do
	            self:moveToHead();
			end
        end
        
		if leftTime then 
			if  leftTime>0 then 
				self:moveUpdate(leftTime)
			elseif leftTime == -1 then
    			self:doStopSpin()
			end

		end

    end
end

function BaseReel:startSpin()
    self._delayBeforeSpin = self.DelayBeforeSpin;
    self.isSpinning = true;
    self._rotateTime = 0;
    self.RotatingTime = 0.0;
    self.Speed = 0;
    self.CRotatingState = RotatingState.Ready;
    self._acceleration = self.MaxSpeed/self.SpeedUpTime;

    -- 打开update 
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
    	self:moveUpdate(ft)
    	end,Interval,false)
end
function BaseReel:doStopSpin()

    self.CRotatingState = RotatingState.SpeedDown;

    -- 需要移动的 cell 个数判断
    local finshCount = #self.Icons  
	local finshFirstKey = nil

    -- 需要方向判断 
    if self._direction == DirectionType.horizontal then -- 横屏
        	for k,v in ipairs(self.Icons) do 
    	    	if (not self.finshFirstKey) and v[1] == self.finshKey then -- 需要验证
                    finshFirstKey = (k - (self.IconCount-1)/2) % finshCount
    				finshCount = (finshCount - (finshFirstKey-1)) + (self.finshRollSumLength or #self.Icons*2)
                    break
    	    	end
      		end
        self.tempBounce = (finshCount*self._cellSize.x + (self._firstP.x - self:_firstIcon():getPositionX())) + self.DownBounce;--self:_firstIcon().node.y-self._firstP.y+self.DownBounce; -- 修改逻辑
	    if self.addEndPos and self.specailHorizontal then 
            self.tempBounce =  self.tempBounce + self.addEndPos 
        end
    else
        for k,v in ipairs(self.Icons) do  -- 使用遍历 可以从当前的进度开始
            if v[1] == self.finshKey then
                finshFirstKey = (k - (self.IconCount-1)/2) % finshCount
                finshCount = (finshCount - (finshFirstKey-1)) + (#self.Icons*(2 or self.finshRollSumLength))
                break
            end
        end
        
        self._deltaDis = 0
        if self.deltaType == 1 then 
            local a = math.random(0,1)
            if a>0.5 then 
                self._deltaDis = self._cellSize.y/2
            else
                self._deltaDis = -self._cellSize.y/2
            end
        elseif self.deltaType==2 then
            self._deltaDis = math.random(0,self._cellSize.y)-self._cellSize.y/2 -- 有随机性的感觉
        end
        -- print("whj: self._deltaDis ",self._deltaDis)
        -- print("whj: self.addEndPos ",self.addEndPos)
        -- 计算一个 绝对值！！！！！
		self.tempBounce =  finshCount*self._cellSize.y + (self:_firstIcon():getPositionY() - self._firstP.y) + self.DownBounce + self._deltaDis
        if self.addEndPos then 
            self.tempBounce =  self.tempBounce + self.addEndPos 
        end
	end
    -- whj 修改为 末速度为0 的计算 ，计算出 负的加速的 和新的 进入减速阶段的速度速度
    self._acceleration = -(2*self.tempBounce)/self.SpeedDownTime/self.SpeedDownTime
    self.Speed = math.abs(self._acceleration * self.SpeedDownTime)

    self.isStopping  = true
    self._rotateTime = 0;
end

function BaseReel:onSpinStoped( ... )
    self:stopScheduler()

    self:resetCellPos()
	self._onSpinStoped() -- 执行回调方法
end

function BaseReel:resetCellPos()
    if self._direction == DirectionType.horizontal then

    else  
        if self._deltaDis~=0 then 
            for k,v in pairs(self.Icons) do 
                local pos = cc.p(v[2]:getPosition())
                v[2]:runAction(cc.MoveTo:create(22/60,cc.p(pos.x,pos.y + (self._deltaDis or 0)))) 
            end
        end
    end

end
function BaseReel:moveToHead ()  -- 把最下面一个移动到最上面
	local newIcon =table.remove(self.Icons,#self.Icons)
	-- 更改item 的内容
	-- self._theme:setSpecialCellSprite(newIcon,self.isStopping)
	
	if self._direction == DirectionType.horizontal then
		newIcon[2]:setPosition(cc.p(self:_firstIcon():getPositionX()-self._cellSize.x, self._firstP.y));
	else
		newIcon[2]:setPosition(cc.p(self._firstP.x,self:_firstIcon():getPositionY()+self._cellSize.y));
	end
	
    table.insert(self.Icons,1,newIcon)
 --    if not newIcon then
 --        newIcon = self.RotateController.GetNextRandomIcon();
 --        if not newIcon then 
 --            SLog.error("newIcon = "+newIcon);
 --        end
	-- end
 --    self:addChild(newIcon.node,1);
 --    if not self:_firstIcon() then
 --        newIcon.node.setPosition(self._firstP);
 --    else
 --        newIcon.setPosition(cc.p(0,self:_firstIcon():getPositionY()+self._cellSize.y));
	-- end
end

function BaseReel:getMoveDis(dt) 
   
    self._rotateTime = self._rotateTime + dt;
    local dis = 0; 
    local leftTime = nil
    if self.CRotatingState == RotatingState.Continue then 
        dis = self.continueSpeed*dt
    elseif self.CRotatingState == RotatingState.Ready then -- 准备阶段 spin 之后的延迟时间
    	if self._rotateTime>self._delayBeforeSpin then
            self.CRotatingState = RotatingState.BounceUp;
            self._rotateTime = 0;
        end
    elseif self.CRotatingState == RotatingState.BounceUp then -- 上弹阶段
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
    	if self._rotateTime>self.RotateTime then
    		leftTime = -1
        end
        dis = self.MaxSpeed*dt;
        
    elseif self.CRotatingState == RotatingState.SpeedDown then -- 减速阶段
        if self._rotateTime>self.SpeedDownTime then
        	leftTime = (self._rotateTime - self.SpeedDownTime)
            dt = dt - leftTime;
            if self.downStopTime > 0 then
                self.CRotatingState = RotatingState.BottomStop;
            else
                self.CRotatingState = RotatingState.BounceDown;
            end
            self._rotateTime = 0;
        end
	    if self.SpeedDownTime == 0 then
            dis = 0;
        else
            local tempSpeed = self.Speed;
            self.Speed = self.Speed + self._acceleration * dt;
            dis =(self.Speed + tempSpeed)*dt/2;
		end
    elseif self.CRotatingState == RotatingState.BottomStop then -- 减速阶段
        if self._rotateTime>self.downStopTime then
            leftTime = (self._rotateTime - self.downStopTime)
            dt = dt - leftTime;
            self.CRotatingState = RotatingState.BounceDown;
            self._rotateTime = 0;
        end
        dis = 0
    elseif self.CRotatingState == RotatingState.BounceDown then -- 回弹阶段  
        if self._rotateTime>self.DownBounceTime then
        	self.isSpinning = false
            self.CRotatingState = RotatingState.Ready;
            leftTime = (self._rotateTime - self.DownBounceTime)
            dt = dt - leftTime;
            self._rotateTime = 0;
        end
        if self.DownBounceTime == 0 then
            dis = 0;
        else
            dis = -self.DownBounce*dt/self.DownBounceTime;
	    end
    else
    end

    return dis,leftTime;
end

function BaseReel:resetFirstIconPosition () 
	if self._direction == DirectionType.horizontal then
		self._firstP =  cc.p(-self._cellSize.x/2,(self._cellSize.y)/2); -- 横向
	elseif self._direction == DirectionType.vertical then
		self._firstP =  cc.p(0,(self._cellSize.y)/2) -- 竖向
	end
end
function BaseReel:_firstIcon ()
    return self.Icons[1][2];
end

function BaseReel:resetCurData(data,callFunc)
    if data then -- 其他参数 自行 测试
        -- if data.Icons then 
        --     self.Icons             = data["Icons"]
        -- end
        -- if data.WheelItemPos then 
        --     self.IconsPos          = data["WheelItemPos"]
        -- end
        -- if data.itemCount then 
        --     self.IconCount         = data["itemCount"]
        -- end
        if data.key then 
            self.finshKey          = data["key"]
        end
        if data.addEndPos then 
            self.addEndPos          = data["addEndPos"]
        end
        -- if data.delayBeforeSpin then 
        --     self.DelayBeforeSpin   = data["delayBeforeSpin"]
        -- end
        -- if data.upBounce then 
        --     self.UpBounce          = data["upBounce"]
        -- end
        -- if data.upBounceTime then 
        --     self.UpBounceTime      = data["upBounceTime"]
        -- end
        -- if data.speedUpTime then 
        --     self.SpeedUpTime       = data["speedUpTime"]
        -- end
        -- if data.rotateTime then 
        --     self.RotateTime        = data["rotateTime"]
        -- end
        -- if data.maxSpeed then 
        --     self.MaxSpeed          = data["maxSpeed"]
        -- end
        -- if data.downBounce then 
        --     self.DownBounce        = data["downBounce"]
        -- end
        -- if data.speedDownTime then 
        --     self.SpeedDownTime     = data["speedDownTime"]
        -- end

        -- if data.downBounceTime then 
        --     self.DownBounceTime    = data["downBounceTime"]
        -- end
        
        -- if data.direction then 
        --     self._direction        = data["direction"]
        -- end
    end
    if callFunc then 
        self._onSpinStoped     = callFunc
    end
    
    self.isSpinning        = false 
    self.isStopping        = false 
end

function BaseReel:stopScheduler( ... )
    if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
end

function BaseReel:playIdleAnim(_continueSpeed)
    self.CRotatingState = RotatingState.Continue
    self.continueSpeed = _continueSpeed
    
    self._rotateTime = 0
    self.isSpinning = true
    
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
        self:moveUpdate(ft)
        end,Interval,false)
end

function BaseReel:stopIdleAnim()
    self.CRotatingState = RotatingState.Continue
    self.continueSpeed = 0
    self.isSpinning = false
    self:stopScheduler()
end





