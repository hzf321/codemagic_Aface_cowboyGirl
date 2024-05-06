--  可以改变滚轴图片的 reel 
--------------------
------1 控制转动方向通过 getMoveDis 方法来控制


--- todo  好像有点问题？ 
BaseReelWithUpdateCell = class("BaseReelWithUpdateCell")
local RotatingState = {
    Ready        = 0,
    BounceUp     = 1,
    SpeedUp 	 = 2,
    MaxSpeed 	 = 3,
    SpeedDown 	 = 4,
    BounceDown 	 = 5,
    SpinOver	 = 6,
    
    Continue     = 7, -- 持续动作
    Force        = 8, -- 强制移动 到某个位置
}
local DirectionType = {
	horizontal   = 1, -- 横向
	vertical     = 2, -- 竖向
}

local Interval = 0

function BaseReelWithUpdateCell:ctor( theme,data,callFunc, singleCallFunc)
	self._theme            = theme
	self.reelIconsList	   = data["reelIcons"]
    self.colCount          = data["colCount"] -- 列
	self.rowCountList      = data["rowCountList"]    
	self.finshKeyList	   = data["keylist"] or {}
    self.finshKeyPos       = data["finshPosList"] or {}
	self.cellSizeList      = data["cellSize"]
    self.startIndexList    = data["startIndex"]
	self.rollReelList      = data["rollReelList"]
    self.reelBasePosList   = data["reelBasePos"]
    self._onSpinStoped     = callFunc
	self._singleStopCallFunc = singleCallFunc

    self.deltaType         = data["deltaType"] or 1 
    self.baseDeltaDis      = data["baseDeltaDis"] or 0

    self.reels = {}
    for i=1,self.colCount do 
        data["reelBasePos"] = self.reelBasePosList[i]
        data["reelIcons"]   = self.reelIconsList[i]
        data["cellSize"]    = self.cellSizeList[i]
        data["finshKey"]    = self.finshKeyList[i]
        data["startIndex"]  = self.startIndexList[i]
        data["rollReel"]    = self.rollReelList[i]
        data["rowCount"]    = self.rowCountList[i]
        local _reel = BaseReelpCol.new(self,data,i)
        table.insert( self.reels,_reel)
    end
end

function BaseReelWithUpdateCell:startSpin()
    -- 打开update 
    for k,v in pairs(self.reels) do 
        v:startSpin()
    end

    if not self.scheduler then 
        self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
            for k,v in pairs(self.reels) do 
                v:moveUpdate(ft)
            end
        	end,Interval,false)
    end
end

function BaseReelWithUpdateCell:onSpinStoped(reelIndex)
    if self._singleStopCallFunc then 
        self._singleStopCallFunc(reelIndex)
    end
    if reelIndex == self.colCount then 
        if self.scheduler then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
            self.scheduler = nil
        end
        self._onSpinStoped() -- 执行回调方法
    end
end

function BaseReelWithUpdateCell:startContinueAction()
    for k,v in pairs(self.reels) do 
        v:startContinueAction()
    end
    if not self.scheduler then 
        self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
            for k,v in pairs(self.reels) do 
                v:moveUpdate(ft)
            end
        end,Interval,false)
    end
end

function BaseReelWithUpdateCell:startFindItemByKey()
    local delayTime = 0
    for k,v in pairs(self.reels) do 
        delayTime = v:doForceKey()
    end
    return delayTime
end

function BaseReelWithUpdateCell:changeSpecialCellSprite(newIcon,value,index) -- 每个主题自行 进行控制
    if self._theme.updateReelItem then 
        self._theme:updateReelItem(newIcon,value,index)
    end
end

function BaseReelWithUpdateCell:resetReelData(data,endFunc)
    self.reelIconsList     = data["reelIcons"] or self.reelIconsList
    self.colCount          = data["colCount"] or self.colCount -- 列
    self.rowCountList      = data["rowCountList"] or self.rowCountList   
    self.finshKeyList      = data["keylist"] or self.finshKeyList
    self.finshKeyPos       = data["finshPosList"] or self.finshKeyPos
    self.cellSizeList      = data["cellSize"] or self.cellSizeList
    self.startIndexList    = data["startIndex"] or self.startIndexList
    self.rollReelList      = data["rollReelList"] or self.rollReelList
    self.reelBasePosList   = data["reelBasePos"] or self.reelBasePosList
    self._onSpinStoped     = endFunc or self._onSpinStoped
    for i=1,self.colCount do 
        data["reelBasePos"] = self.reelBasePosList[i]
        data["reelIcons"]   = self.reelIconsList[i]
        data["cellSize"]    = self.cellSizeList[i]
        data["finshKey"]    = self.finshKeyList[i]
        data["finshPos"]    = self.finshKeyPos[i]
        data["startIndex"]  = self.startIndexList[i]
        data["rollReel"]    = self.rollReelList[i]
        data["rowCount"]    = self.rowCountList[i]
        self.reels[i]:resetReelPcolData(data)
    end
end

function BaseReelWithUpdateCell:resetReelCell(multi) -- 更改 显示内容
    for i=1,self.colCount do 
        self.reels[i]:resetReelpColCell()
    end
end

function BaseReelWithUpdateCell:setCellSpriteByIndex(startIndexList)
    for i=1,self.colCount do 
        self.reels[i]:setCellSprite(startIndexList[i])
    end 
end

function BaseReelWithUpdateCell:onExit( ... )
    if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
        self.scheduler = nil
    end
end

BaseReelpCol = class("BaseReelpCol")

function BaseReelpCol:ctor(baseReel,data,reelIndex)


    self.DelayBeforeSpin   = data["delayBeforeSpin"] or 0.0    --开始旋转前的时间延迟
    self.UpBounce          = data["upBounce"] or 10     --开始滚动前，向上滚动距离
    self.UpBounceTime      = data["upBounceTime"] or 0.2    --开始滚动前，向上滚动时间
    self.SpeedUpTime       = data["speedUpTime"] or 0.5    --加速时间
    self.RotateTime        = data["rotateTime"] or 2.0    -- 匀速转动的时间之和
    self.MaxSpeed          = data["maxSpeed"] or 60     --每一秒滚动的距离
    self.DownBounce        = data["downBounce"] or 10.0   --滚动结束前，向下反弹距离  都为正数值
    self.SpeedDownTime     = data["speedDownTime"] or 0.25
    self.DownBounceTime    = data["downBounceTime"] or 0.25
    self.ContinueSpeed     = data["continueSpeed"] or 10
    self.ForceTime         = data["forceTime"] or 1

    self.IconCount         = data["rowCount"] -- 行的 itemCount 上下加一个 cell 之后的个数
    self._direction        = data["direction"] 
    self.finshKey          = data["finshKey"]
    self.finshPos          = data["finshPos"]
    self._cellSize         = data["cellSize"]
    self.Icons             = data["reelIcons"]
    self.localPos          = data["reelBasePos"]
    self.mainReel          = data["rollReel"]

    self.fishRollCount     = data["rollCount"] or 2 -- 结束时转动的圈
    self.reelIndex         = reelIndex
    self.baseReel          = baseReel

    self.isSpinning        = false 
    self.isStopping        = false

    self._moveTotalDis = 0
    self:setCellSprite(data["startIndex"])
    self:resetFirstIconPosition();
end

function BaseReelpCol:setCellSprite(startIndex) -- 右边第一个位置
    local items = {}
    if self._direction == DirectionType.horizontal then-- 横向
        self.curKey = startIndex -- 右边第一个的位置
        startIndex = startIndex + #self.Icons -1
        for k,v in pairs(self.Icons) do 
            v:setPositionX((k-1.5)*self._cellSize.x) -- 位置从左到右

            startIndex = 1+(startIndex - 1)% #self.mainReel
            self.baseReel:changeSpecialCellSprite(v,self.mainReel[startIndex],startIndex)
            table.insert(items,v)
            startIndex = startIndex -1
        end   
    elseif self._direction == DirectionType.vertical then
        self.curKey = startIndex -- 第一个的位置
        for k,v in pairs(self.Icons) do 

            v:setPositionY((-k + 1.5)*self._cellSize.y)
            if startIndex > #self.mainReel then
                startIndex = 1
            end
            self.baseReel:changeSpecialCellSprite(v,self.mainReel[startIndex],startIndex)
            table.insert(items,v)
            startIndex = startIndex +1
        end     
    end
    self.Icons = items
end

function BaseReelpCol:startSpin( ... )
    self._delayBeforeSpin = self.DelayBeforeSpin
    
    self._rotateTime = 0;
    self.RotatingTime = 0.0;
    self.Speed = 0;
    self.CRotatingState = RotatingState.Ready;
    self._acceleration = self.MaxSpeed/self.SpeedUpTime;
    self.isSpinning = true;

end

function BaseReelpCol:startContinueAction()
    self._rotateTime = 0;
    self.CRotatingState = RotatingState.Continue
    self.isSpinning = true;
end
function BaseReelpCol:moveUpdate(dt)
    if self.isSpinning then
        local dis,leftTime = self:getMoveDis(dt)
        self._moveTotalDis = self._moveTotalDis + dis
        if self._direction == DirectionType.horizontal then -- 横向
            for k,icon in ipairs(self.Icons) do
                icon:setPositionX(icon:getPositionX()+dis)
            end
            if not self.isSpinning then
                self:onSpinStoped()
                return
            end
            while self:_firstIcon():getPositionX() > self._firstP.x do
                self:moveToHead();
            end
        elseif self._direction == DirectionType.vertical then
            for  k,icon in ipairs(self.Icons) do
                icon:setPositionY(icon:getPositionY()-dis)
            end
            if not self.isSpinning then
                self:onSpinStoped()
                return
            end
            while self:_firstIcon():getPositionY() < self._firstP.y do
                self:moveToHead()
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

function BaseReelpCol:doForceKey() --修改 逻辑 当前 方法中只进行 数据的计算
    -- self.CRotatingState = RotatingState.Force; -- 暂时不需要
    -- 需要移动的 cell 个数判断
    self._delayBeforeSpin = self.DelayBeforeSpin
    self.CRotatingState = RotatingState.Ready;
    self.isForceShow = true
    self._moveTotalDis = 0
    local finshCount = #self.mainReel  
    if self._direction == DirectionType.horizontal then -- 横屏
        local finshKeyPos = {}
        for k,v in ipairs(self.mainReel) do 
            if v == self.finshKey then
                finshFirstKey = 1+ (k - math.floor((self.IconCount)/2) -1 ) % finshCount -- zui后一个cell 的 图片资源样式
                table.insert(finshKeyPos,finshFirstKey)   
            end
        end
        local randomPos = finshKeyPos[math.random(1,#finshKeyPos)]
        finshCount = (finshCount - self.curKey)+ randomPos + #self.mainReel* self.fishRollCount
        if (self.IconCount)%2 == 0 then 
            finshCount = finshCount+0.5
        end

        self.Speed = self.ContinueSpeed
        self._acceleration = (self.MaxSpeed-self.Speed)/self.SpeedUpTime;

        self._deltaDis = 0
        self.totalBonus = (finshCount*self._cellSize.x + (self._firstP.x - self:_firstIcon():getPositionX())+ self.DownBounce+ self._deltaDis )
        self.MaxSpeedBonuce = self.totalBonus - ((self.MaxSpeed+self.Speed)/2)*self.SpeedUpTime - (self.MaxSpeed*self.SpeedDownTime)/2
        self.RotateTime = self.MaxSpeedBonuce/self.MaxSpeed
    else
        local finshKeyPos = {}
        for k,v in ipairs(self.mainReel) do 
            if v == self.finshKey then
                finshFirstKey = 1+ (k - (self.IconCount-1)/2 -1 ) % finshCount -- zui后一个cell 的 图片资源样式
                table.insert(finshKeyPos,finshFirstKey)   
            end
        end

        local randomPos = finshKeyPos[math.random(1,#finshKeyPos)]
        finshCount = (finshCount - self.curKey)+ randomPos + #self.mainReel* self.fishRollCount-- 直接按当前的已经移动下去的整数个计算 self.curKey -> self.curKey -1 +1
        if self.baseReel.deltaType == 1 then 
            local a = math.random(0,1)
            if a>0.5 then 
                self._deltaDis = self._cellSize.y/2
            else
                self._deltaDis = -self._cellSize.y/2
            end
        elseif self.baseReel.deltaType==2 then
            self._deltaDis = math.random(0,self._cellSize.y)-self._cellSize.y/2 -- 有随机性的感觉
        end
        self.tempBounce =  finshCount*self._cellSize.y + (self:_firstIcon():getPositionY() - self._firstP.y) + self.DownBounce + self._deltaDis;
    end
    -- whj 修改为 末速度为0 的计算 ，计算出 负的加速的 和新的 进入减速阶段的速度速度
    self._rotateTime = 0
    self.isSpinning = true
    return (self.RotateTime + self.SpeedUpTime + self.SpeedDownTime)
end

function BaseReelpCol:isOverForce()
    self.baseReel:onSpinStoped(self.reelIndex)
    -- self.CRotatingState = RotatingState.Continue
    -- self:startContinueAction()
end
function BaseReelpCol:doStopSpin()
    self.CRotatingState = RotatingState.SpeedDown;

    -- 需要移动的 cell 个数判断
    local finshCount = #self.mainReel  
    local finshFirstKey = nil

    if self.isForceShow then 
        self._acceleration = -self.MaxSpeed/self.SpeedDownTime
        self.Speed = self.MaxSpeed
    else
        -- 需要方向判断 
        if self._direction == DirectionType.horizontal then -- 横屏

            if self.finshPos then 
                finshFirstKey = 1+ (self.finshPos - (self.IconCount-1)/2 -1 ) % finshCount -- 通过 格子 算出 有结果时候zui后一个cell 的 图片资源样式
                finshCount = (finshCount - self.curKey)+ finshFirstKey + #self.mainReel* self.fishRollCount

                if (self.IconCount)%2 == 0 then 
                    finshCount = finshCount+0.5
                end
                if self.baseReel.deltaType == 1 then 
                    local a = math.random(0,1)
                    if a>0.5 then 
                        self._deltaDis = self._cellSize.x/2
                    else
                        self._deltaDis = -self._cellSize.x/2
                    end
                elseif self.baseReel.deltaType==2 then
                    self._deltaDis = math.random(0,self._cellSize.x)-self._cellSize.x/2 -- 有随机性的感觉
                end
                self.tempBounce = (finshCount*self._cellSize.x + (self._firstP.x - self:_firstIcon():getPositionX())+ self.DownBounce + self._deltaDis)
            end
        else
            local finshKeyPos = {}
            for k,v in ipairs(self.mainReel) do 
                if v == self.finshKey then
                    finshFirstKey = 1+ (k - (self.IconCount-1)/2 -1 ) % finshCount -- zui后一个cell 的 图片资源样式
                    table.insert(finshKeyPos,finshFirstKey)   
                end
            end

            local randomPos = finshKeyPos[math.random(1,#finshKeyPos)]
            finshCount = (finshCount - self.curKey)+ randomPos + #self.mainReel* self.fishRollCount-- 直接按当前的已经移动下去的整数个计算 self.curKey -> self.curKey -1 +1
            if self.baseReel.deltaType == 1 then 
                local a = math.random(0,1)
                if a>0.5 then 
                    self._deltaDis = self._cellSize.y/2
                else
                    self._deltaDis = -self._cellSize.y/2
                end
            elseif self.baseReel.deltaType==2 then
                self._deltaDis = math.random(0,self._cellSize.y)-self._cellSize.y/2 -- 有随机性的感觉
            elseif self.baseReel.deltaType== 3 then
                self._deltaDis = math.random(-1, 1) * self.baseReel.baseDeltaDis -- 有随机性的感觉
            end

            self.tempBounce =  finshCount*self._cellSize.y + (self:_firstIcon():getPositionY() - self._firstP.y) + self.DownBounce + self._deltaDis
        end
        -- whj 修改为 末速度为0 的计算 ，计算出 负的加速的 和新的 进入减速阶段的速度速度
        self._acceleration = -(2*self.tempBounce)/self.SpeedDownTime/self.SpeedDownTime
        self.Speed = math.abs(self._acceleration * self.SpeedDownTime)
    end

    self.isStopping  = true
    self._rotateTime = 0
        --     for k,v in ipairs(self.Icons) do  -- 使用遍历 可以从当前的进度开始
        --         if v[1] == self.finshKey then
        --             finshFirstKey = (k - (self.IconCount-1)/2) % finshCount
        --             finshCount = (finshCount - (finshFirstKey-1)) + (#self.Icons*(2 or self.finshRollSumLength))
        --             break
        --         end
        --     end
            
        --     self._deltaDis = 0
        --     if self.deltaType == 1 then 
        --         local a = math.random(0,1)
        --         if a>0.5 then 
        --             self._deltaDis = self._cellSize.y/2
        --         else
        --             self._deltaDis = -self._cellSize.y/2
        --         end
        --     elseif self.deltaType==2 then
        --         self._deltaDis = math.random(0,self._cellSize.y)-self._cellSize.y/2 -- 有随机性的感觉
        --     end
        --     -- print("whj: self._deltaDis ",self._deltaDis)
        --     -- print("whj: self.addEndPos ",self.addEndPos)
        --     -- 计算一个 绝对值！！！！！
        --     self.tempBounce =  finshCount*self._cellSize.y + (self:_firstIcon():getPositionY() - self._firstP.y) + self.DownBounce + self._deltaDis
        --     if self.addEndPos then 
        --         self.tempBounce =  self.tempBounce + self.addEndPos 
        --     end
        -- end
end

function BaseReelpCol:onSpinStoped( ... )
    self.isForceShow = false
    self:ResetCellPos()
    self.baseReel:onSpinStoped(self.reelIndex)
end

function BaseReelpCol:getMoveDis(dt) 
    self._rotateTime = self._rotateTime + dt;
    local dis = 0; 
    local leftTime = nil
    if self.CRotatingState == RotatingState.Ready then -- 准备阶段 spin 之后的延迟时间
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
            dt = dt - leftTime
            self.CRotatingState = RotatingState.MaxSpeed;
            self._rotateTime = 0;
        end
        local tempSpeed = self.Speed;
        self.Speed = self.Speed+ self._acceleration * dt;
        dis =(self.Speed + tempSpeed)*dt/2;
    elseif self.CRotatingState == RotatingState.MaxSpeed then -- 匀速阶段
        if self._rotateTime>self.RotateTime then
            leftTime = -1
            dt = dt - (self._rotateTime - self.RotateTime)
        end
        dis = self.MaxSpeed*dt
        
    elseif self.CRotatingState == RotatingState.SpeedDown then -- 减速阶段
        if self._rotateTime>self.SpeedDownTime then
            leftTime = (self._rotateTime - self.SpeedDownTime)
            dt = dt - leftTime
            self.CRotatingState = RotatingState.BounceDown;
            self._rotateTime = 0
        end
        if self.SpeedDownTime == 0 then
            dis = 0;
        else
            local tempSpeed = self.Speed
            self.Speed = self.Speed + self._acceleration * dt
            dis =(self.Speed + tempSpeed)*dt/2;
        end
    elseif self.CRotatingState == RotatingState.BounceDown then -- 回弹阶段  
        if self._rotateTime>self.DownBounceTime then
            self.isSpinning = false
            self.CRotatingState = RotatingState.Ready;
            leftTime = (self._rotateTime - self.DownBounceTime)
            dt = dt - leftTime
            self._rotateTime = 0
        end
        if self.DownBounceTime == 0 then
            dis = 0;
        else
            dis = -self.DownBounce*dt/self.DownBounceTime;
        end
    elseif self.CRotatingState == RotatingState.Continue then
        dis = self.ContinueSpeed*dt
    elseif self.CRotatingState == RotatingState.Force then 
        if self._rotateTime>self.ForceTime then
            dt = dt - (self._rotateTime - self.ForceTime)
            self:isOverForce()
            self._rotateTime = 0
        end
        
        local tempSpeed = self.Speed
        self.Speed = self.Speed + self._acceleration * dt
        dis =(self.Speed + tempSpeed)*dt/2;
    end
    return dis,leftTime;
end

function BaseReelpCol:ResetCellPos( ... )
    if self._direction == DirectionType.horizontal then -- 横向
        for k,v in pairs(self.Icons) do 
            local pos = cc.p(v:getPosition())
            v:runAction(cc.MoveTo:create(5/60,cc.p(pos.x - (self._deltaDis or 0),pos.y))) 
        end
    else  
        for k,v in pairs(self.Icons) do 
            local pos = cc.p(v:getPosition())
            -- v:setPosition(cc.p(pos.x,pos.y + (self._deltaDis or 0)))
            v:runAction(cc.MoveTo:create(5/60,cc.p(pos.x,pos.y + (self._deltaDis or 0)))) 
        end
    end

end

function BaseReelpCol:resetFirstIconPosition () --最上面一个
    if self._direction == DirectionType.horizontal then
        self._firstP = cc.p(-self._cellSize.x/2,self.Icons[1]:getPositionY()); -- 横向 左边第一个位置
    elseif self._direction == DirectionType.vertical then
        self._firstP = cc.p(self.Icons[1]:getPositionX(),(self._cellSize.y)/2); -- 竖向
    end
end
function BaseReelpCol:_firstIcon () -- 最上面的一个
    return self.Icons[1]
end

function BaseReelpCol:moveToHead ()  -- 把最下面一个移动到最上面

    local newIcon =table.remove(self.Icons,#self.Icons)
    -- 更改item 的内容

    if self._direction == DirectionType.horizontal then
        newIcon:setPosition(cc.p(self:_firstIcon():getPositionX()-self._cellSize.x, self._firstP.y));
        local key = 1+ ((self.curKey + self.IconCount) - 1) % #self.mainReel

        self.baseReel:changeSpecialCellSprite(newIcon,self.mainReel[key],key)
        self.curKey = self.curKey +1
        if self.curKey > #self.mainReel then 
            self.curKey = 1 
        end
    else
        newIcon:setPosition(cc.p(self._firstP.x,self:_firstIcon():getPositionY()+self._cellSize.y));
        local key = 1+ ((self.curKey + self.IconCount) - 1) % #self.mainReel

        self.baseReel:changeSpecialCellSprite(newIcon,self.mainReel[key],key)
        self.curKey = self.curKey +1
        if self.curKey > #self.mainReel then 
            self.curKey = 1 
        end
    end
    
    table.insert(self.Icons,1,newIcon)
end

function BaseReelpCol:resetReelPcolData(data)
    self.IconCount      = data["rowCount"] or self.IconCount -- 行的 itemCount 上下加一个 cell 之后的个数
    self._direction     = data["direction"] or self._direction
    self.finshKey       = data["finshKey"] or self.finshKey
    self._cellSize      = data["cellSize"] or self._cellSize
    self.Icons          = data["reelIcons"] or self.Icons
    self.localPos       = data["reelBasePos"] or self.localPos
    self.mainReel       = data["rollReel"] or self.mainReel
    self.finshPos       = data["finshPos"] or self.finshPos
    self.fishRollCount  = data["rollCount"] or 2 -- 结束时转动的圈
    self.ContinueSpeed  = data["continueSpeed"] or self.ContinueSpeed
    self.ForceTime      = data["forceTime"] or self.ForceTime
 
    self.SpeedUpTime    = data["speedUpTime"] or self.SpeedUpTime
    self.MaxSpeed       = data["maxSpeed"] or self.SpeedUpTime
    self.SpeedDownTime  = data["speedDownTime"] or self.SpeedUpTime
end

function BaseReelpCol:resetReelpColCell()
    for k,v in pairs(self.Icons) do 
        self.baseReel:changeSpecialCellSprite(v,v.key)
    end
end




