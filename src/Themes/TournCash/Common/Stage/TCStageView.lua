---
--- @program src 
--- @description:  
--- @author: rwb 
---@create: : 2021/02/22 19:00:00
local cls = class("TCStageView")
function cls:ctor(ctl, parent, flyNode)
    self.ctl = ctl
    self.node = parent
end
function cls:initRoot()
    self.stageLabel = self.node:getChildByName("round")
    self.stageTime = self.node:getChildByName("time")
    self.stageTime.isHiding = true
end
function cls:setStartRound(stage)
    if stage == 3 then
        local str = "BONUS ROUND"
        self.stageTime:stopAllActions()
        self.stageLabel:setString(str)
        self.stageTime:setVisible(false)
        self.stageLabel:setPosition(cc.p(0, 3))
    else
        local str = "ROUND " .. stage .. ":"
        self.stageLabel:setString(str)
        self.stageLabel:setPosition(cc.p(-40, 3))
        self.stageTime:setVisible(true)
        self.stageTime:setString("03:00")
    end
end
function cls:resetStageTime(left)

    if left <= 0 then
        self.stageTime:setString("00:00")
    end
end
function cls:stageNumChange(left_time)
    local spine_node = self.node:getChildByName("spine_node")
    local data = {}
    data.file = self.ctl:getSpineFile("stage_bg")
    data.parent = spine_node
    bole.addAnimationSimple(data)
    self.ctl:playMusicByName("sound_num_10")
    self.ctl:playMusicByName("second_" .. left_time)

end
function cls:updateStageNode(stage)
    if stage < 3 and stage > 0 then
        self.stageTime:stopAllActions()
        self:configCountDownLabel(
                self.stageTime,
                function(...)
                    return self.ctl:getRoundLeftTime()
                end,
                function(...)
                    self.stageTime:stopAllActions()
                    self.stageTime:setString("00:00")
                    self.ctl:finishRoundSpin()
                end,
                function(...)
                    self.ctl:last10Second()
                end)
    end
end
function cls:configCountDownLabel(label, time_func, end_func, last10_fun)
    if not label or not time_func then
        return
    end
    local end_func_called = false
    local nextCount = time_func()
    label:stopAllActions()
    label:runAction(cc.RepeatForever:create(cc.Sequence:create(
            cc.CallFunc:create(function(...)
                local left_time = time_func()
                local useTime = left_time
                if useTime > self.ctl:getStageTime() then
                    useTime = self.ctl:getStageTime()
                elseif left_time > nextCount and nextCount > 0 then
                    useTime = nextCount
                else
                    useTime = left_time
                end
                if useTime > left_time then
                    useTime = left_time
                end
                nextCount = useTime - 1
                if useTime >= 0 then
                    local function getTimeString(num)
                        return ((num < 10 and "0") or "") .. num
                    end
                    local minute = getTimeString(math.floor(useTime % 3600 / 60))
                    local second = getTimeString(math.floor(useTime % 60))
                    label:setString(minute .. ":" .. second)
                    if useTime < 11 and useTime >= 0 then
                        if useTime > 0 then
                            self:stageNumChange(useTime)
                        end
                        label:setColor(cc.c3b(255, 0, 0))
                        label:runAction(
                                cc.Sequence:create(
                                        cc.ScaleTo:create(0.2, 1.1),
                                        cc.ScaleTo:create(0.2, 1)
                                )
                        )
                    else
                        label:setColor(cc.c3b(255, 255, 255))
                    end
                    if useTime <= 0 then
                        if end_func then
                            end_func_called = true
                            end_func()
                        end
                    end
                    if left_time < 11 then
                        if last10_fun then
                            last10_fun()
                        end
                    end
                else
                    if not end_func_called and end_func then
                        end_func_called = true
                        end_func()
                    end
                end

            end),
            cc.DelayTime:create(1))))
end
return cls





