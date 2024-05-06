--  可以改变滚轴图片的 reel 

--------------------
------1 控制转动方向通过 getMoveDis 方法来控制
--- @ 需要控制界面 itemList parent 在mask 的底部
BaseReelWithSprite = class("BaseReelWithSprite")
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
	horizontal   = 1, -- 横向
	vertical     = 2, -- 竖向
}

local Interval = 0

function BaseReelWithSprite:ctor( theme,data,callFunc)
	self._theme            = theme
	self.reelIconsList	   = data["reelIcons"]
    self.colCount          = data["colCount"] -- 列
	self.rowCountList      = data["rowCountList"]    
	self.finshKeyList	   = data["keylist"]
	self.cellSizeList      = data["cellSize"]
    self.startIndexList    = data["startIndex"]
	self.rollReelList      = data["rollReelList"]
    self.reelBasePosList   = data["reelBasePos"]
	self._onSpinStoped	   = callFunc

    self.pathList          = data["spritePath"] or {}
    self.fontValueList     = data["fontValues"] or {}
    self.font_all          = data["font_all"] or false  -- FONTS.format的all/decimal/bRound参数， 默认按照配置 12.35M 这样显示
    self.font_decimal      = data["font_decimal"] or false
    self.font_bRound       = data["font_bRound"] or nil
    self.currentBet        = data["currentBet"] or 0
    self.fontDigits        = data["fontDigits"] or 0
	self.spriteScale       = data["spriteScale"]
    self.deltaType         = data["deltaType"] or 1 
    self.resetDelayList    = data["reset_delay"] or {} -- 新增字段, 复位之前的延迟时间
    self.reels = {}

    for i=1,self.colCount do 
        data["reelBasePos"] = self.reelBasePosList[i]
        data["reelIcons"]   = self.reelIconsList[i]
        data["cellSize"]    = self.cellSizeList[i]
        data["finshKey"]    = self.finshKeyList[i]
        data["startIndex"]  = self.startIndexList[i]
        data["rollReel"]    = self.rollReelList[i]
        data["rowCount"]    = self.rowCountList[i]
        data["reset_delay"] = self.resetDelayList[i]
        local _reel = Reelpcol.new(self,data,i)
        table.insert( self.reels,_reel)
    end

end

function BaseReelWithSprite:startSpin()
    -- 打开update 
    for k,v in pairs(self.reels) do 
        v:startSpin()
    end

    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
        for k,v in pairs(self.reels) do 
            v:moveUpdate(ft)
        end
    	end,Interval,false)
end

function BaseReelWithSprite:onSpinStoped(reelIndex, delay)
    if reelIndex == self.colCount then 
        if self.scheduler then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
        end


        local delay = delay or 0
        self._onSpinStoped(delay) -- 执行回调方法

    end
end

function BaseReelWithSprite:changeSpecialCellSprite(newIcon,key)
    if self._theme.updateReelItem then -- todo whj 添加可以适应不同的修改该显示
        self._theme:updateReelItem( newIcon, key )
    end

    local path = self.pathList[key]
    local theCellSprite = newIcon.sp
    if theCellSprite and path then

        bole.updateSpriteWithFile(theCellSprite, path)
        if self.spriteScale and self.spriteScale[key] then 
            theCellSprite:setScale(self.spriteScale[key])
        else
            --theCellSprite:setScale(1)
            --保留Cocos中设置的大小，用于大小不变以及长宽比例不一样的情况--by wy
        end
    end

    local path2 = self.pathList[key.."bg"]
    local theCellBg = newIcon.bg
    if theCellBg and path2 then
        bole.updateSpriteWithFile(theCellBg, path2)
    end

    local theCellFont = newIcon.font
    if theCellFont then
        if self.fontValueList and #self.fontValueList > 0 then
            if self.fontValueList[key] and self.fontValueList[key] > 0 then
                if self.currentBet > 0 then
                    local fontValue = self.fontValueList[key] * self.currentBet
                    theCellFont:setString(FONTS.formatByCount4 (fontValue, self.fontDigits, true)) 
                else
                    theCellFont:setString(FONTS.formatByCount4 (self.fontValueList[key], self.fontDigits, true)) 
                end
            else
                theCellFont:setString("")
            end
        end
    end
end
function BaseReelWithSprite:stopScheduler( ... )
    if self.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
    end
end
Reelpcol = class("Reelpcol")

function Reelpcol:ctor(baseReel,data,reelIndex)


    self.DelayBeforeSpin   = data["delayBeforeSpin"] or 0.0    --开始旋转前的时间延迟
    self.UpBounce          = data["upBounce"] or 10     --开始滚动前，向上滚动距离
    self.UpBounceTime      = data["upBounceTime"] or 0.2    --开始滚动前，向上滚动时间
    self.SpeedUpTime       = data["speedUpTime"] or 0.5    --加速时间
    self.RotateTime        = data["rotateTime"] or 2.0    -- 匀速转动的时间之和
    self.MaxSpeed          = data["maxSpeed"] or 60     --每一秒滚动的距离
    self.DownBounce        = data["downBounce"] or 10.0   --滚动结束前，向下反弹距离  都为正数值
    self.SpeedDownTime     = data["speedDownTime"] or 0.25
    self.DownBounceTime    = data["downBounceTime"] or 0.25
    self.IconCount         = data["rowCount"] -- 行的 itemCount 上下加一个 cell 之后的个数
    self._direction        = data["direction"] 
    self.finshKey          = data["finshKey"]
    self._cellSize         = data["cellSize"]
    self.Icons             = data["reelIcons"]
    self.localPos          = data["reelBasePos"]
    self.mainReel          = data["rollReel"]

    self.lastResetDelay    = data["reset_delay"] or 0 -- 结束时转动的圈
    self.fishRollCount     = data["rollCount"] or 2 -- 结束时转动的圈
    self.reelIndex         = reelIndex
    self.baseReel          = baseReel

    self.isSpinning        = false 
    self.isStopping        = false

    self:setCellSprite(data["startIndex"])
    self:resetFirstIconPosition();
end

function Reelpcol:setCellSprite(startIndex)
    local items = {}
    if self._direction == DirectionType.horizontal then-- 横向
        self.curKey = startIndex
        for k,v in pairs(self.Icons) do 

            v:setPositionX((self.localPos.x or 0) + (k-1.5)*self._cellSize.x)  -- v:setPositionX((self.IconCount-k-0.5)*self._cellSize.y) 
            if startIndex > #self.mainReel then -- #self.Icons
                startIndex = 1
            end
            self.baseReel:changeSpecialCellSprite(v, self.mainReel[startIndex])
            table.insert(items,v)
            startIndex = startIndex +1
        end  
    elseif self._direction == DirectionType.vertical then
        self.curKey = startIndex
        for k,v in pairs(self.Icons) do 

            v:setPositionY((self.IconCount-k-0.5)*self._cellSize.y) 
            if startIndex > #self.mainReel then -- #self.Icons
                startIndex = 1
            end
            self.baseReel:changeSpecialCellSprite(v, self.mainReel[startIndex])
            table.insert(items,v)
            startIndex = startIndex +1
        end     
    end

    self.Icons = items
end

function Reelpcol:startSpin( ... )
    self._delayBeforeSpin = self.DelayBeforeSpin;
    
    self._rotateTime = 0;
    self.RotatingTime = 0.0;
    self.Speed = 0;
    self.CRotatingState = RotatingState.Ready;
    self._acceleration = self.MaxSpeed/self.SpeedUpTime;
    self.isSpinning = true;

end

function Reelpcol:moveUpdate(dt)
    -- self.RotatingTime+=dt;
    if  self.isSpinning then

        local dis,leftTime = self:getMoveDis(dt);
        if self._direction == DirectionType.horizontal then
            for  k,icon in ipairs(self.Icons) do
                icon:setPositionX(icon:getPositionX()+dis)
            end
            if not self.isSpinning then
                self:onSpinStoped()
                return
            end
            while self:_firstIcon():getPositionX() > self._firstP.x do
                self:moveToHead()
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

function Reelpcol:doStopSpin()

    self.CRotatingState = RotatingState.SpeedDown;

    -- 需要移动的 cell 个数判断
    local finshCount = #self.mainReel  
    local finshFirstKey = nil

    -- 需要方向判断 
    if self._direction == DirectionType.horizontal then -- 横屏
        local finshKeyPos = {}
        for k,v in ipairs(self.mainReel) do 
            if v == self.finshKey then
                finshFirstKey = 1+ (k - (self.IconCount-1)/2 -1 ) % finshCount -- zui后一个cell 的 图片资源样式
                table.insert(finshKeyPos,finshFirstKey)   
            end
        end

        local randomPos = finshKeyPos[math.random(1,#finshKeyPos)] --  or 1

        finshCount = (finshCount - self.curKey)+ randomPos + #self.mainReel* self.fishRollCount

        self._deltaDis = 0
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

        self.tempBounce =  finshCount*self._cellSize.x + (self._firstP.x - self:_firstIcon():getPositionX()) + self.DownBounce + self._deltaDis
    else
        local finshKeyPos = {}
        for k,v in ipairs(self.mainReel) do 
            if v == self.finshKey then
                finshFirstKey = 1+ (k - (self.IconCount-1)/2 -1 ) % finshCount -- zui后一个cell 的 图片资源样式
                table.insert(finshKeyPos,finshFirstKey)   
            end
        end

        local randomPos = finshKeyPos[math.random(1,#finshKeyPos)]
        -- print("whj:   randomPos",randomPos)
        finshCount = (finshCount - self.curKey)+ randomPos + #self.mainReel* self.fishRollCount-- 直接按当前的已经移动下去的整数个计算 self.curKey -> self.curKey -1 +1
        -- print("whj: self.curKey",self.curKey)
        -- print("whj: finshCount: ",(#self.mainReel - self.curKey)+ randomPos) 
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

        -- print("whj: self._deltaDis",self._deltaDis)
        self.tempBounce =  finshCount*self._cellSize.y + (self:_firstIcon():getPositionY() - self._firstP.y) + self.DownBounce + self._deltaDis;
    end
    -- whj 修改为 末速度为0 的计算 ，计算出 负的加速的 和新的 进入减速阶段的速度速度
    self._acceleration = -(2*self.tempBounce)/self.SpeedDownTime/self.SpeedDownTime
    self.Speed = math.abs(self._acceleration * self.SpeedDownTime)

    self.isStopping  = true
    self._rotateTime = 0;
end

function Reelpcol:onSpinStoped( ... )
    local delay = self:ResetCellPos()
    
    self.baseReel:onSpinStoped(self.reelIndex, delay)    
end

function Reelpcol:getMoveDis(dt) 
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

function Reelpcol:ResetCellPos( ... )
    local delay = 0
    if self._direction == DirectionType.horizontal then
        local moveTime = 22/60
        delay = (self.lastResetDelay or 0) + moveTime

        for k,v in pairs(self.Icons) do 
            local pos = cc.p(v:getPosition())
            
            v:runAction(cc.Sequence:create(
                cc.DelayTime:create(self.lastResetDelay or 0),
                cc.MoveTo:create(moveTime, cc.p(pos.x + (-self._deltaDis or 0), pos.y ) )
            )) 
        end
    else  
        local moveTime = 22/60
        delay = (self.lastResetDelay or 0) + moveTime
        for k,v in pairs(self.Icons) do 
            local pos = cc.p(v:getPosition())
            -- v:setPosition(cc.p(pos.x,pos.y + (self._deltaDis or 0)))
            v:runAction(cc.Sequence:create(
                cc.DelayTime:create(self.lastResetDelay or 0),
                cc.MoveTo:create(moveTime,cc.p(pos.x,pos.y + (self._deltaDis or 0)))
            )) 
        end
    end
    return delay
end

function Reelpcol:resetFirstIconPosition () --最上面一个
    if self._direction == DirectionType.horizontal then
        self._firstP =  cc.p(self.localPos.x-self._cellSize.x/2,self.Icons[1]:getPositionY()); -- 横向
    elseif self._direction == DirectionType.vertical then
        self._firstP = cc.p(self.Icons[1]:getPositionX(),self.localPos.x + (self._cellSize.y)*(self.IconCount-1-0.5)); -- 竖向
    end
end
function Reelpcol:_firstIcon () -- 最上面的一个
    return self.Icons[1]
end

function Reelpcol:moveToHead ()  -- 把最下面一个移动到最上面
    local newIcon =table.remove(self.Icons,#self.Icons)
    -- 更改item 的内容

    if self._direction == DirectionType.horizontal then
        newIcon:setPosition(cc.p(self:_firstIcon():getPositionX()-self._cellSize.x, self._firstP.y));
        local key = 1+ ((self.curKey + self.IconCount) - 1) % #self.mainReel

        self.baseReel:changeSpecialCellSprite(newIcon,self.mainReel[key])
        self.curKey = self.curKey +1
        if self.curKey > #self.mainReel then 
            self.curKey = 1 
        end
    else
        
        newIcon:setPosition(cc.p(self._firstP.x,self:_firstIcon():getPositionY()+self._cellSize.y));
        local key = 1+ ((self.curKey + self.IconCount) - 1) % #self.mainReel

        self.baseReel:changeSpecialCellSprite(newIcon,self.mainReel[key])
        self.curKey = self.curKey +1
        if self.curKey > #self.mainReel then 
            self.curKey = 1 
        end
    end
    
    table.insert(self.Icons,1,newIcon)
end


