local TimeLine = require("UI/CreatorUI/TimeLine")
local EventTimeLine = class("EventTimeLine", TimeLine)

local safeCb = function (cb)
    if type(cb) == "function" then
        return cb
    else
        return defaultSafeCb
    end
end

function EventTimeLine:ctor()
    self.__eventNameList = {}
end

function EventTimeLine:getInterPolatedValue(_frame)
    return 0
end

function EventTimeLine:setData(data)
    TimeLine.setData(self, data)
    for k, item in ipairs(self.__data) do
        self.__eventNameList[item.func] = item
    end
end

function EventTimeLine:getDataByName(name)
    return self.__eventNameList[name]
end

function EventTimeLine:checkSegR(f, t)

end

function EventTimeLine:checkSeg(f, t, onHit)
    local data = self.__data

    local sIdx
    for idx = #data, 1, -1 do
        local item = data[idx]

        if f <= item.frame then -- 找到 起点
            sIdx = idx
        end
    end

    if nil == sIdx then
        return
    end
    for idx = sIdx, #data do
        local item = data[idx]
        -- print( sIdx, item.func, item.frame )
        if item.frame <= t then
            onHit(item)
        end
    end
end

-- 只对跨越的 一个 event 做出处理
function EventTimeLine:doEventSimpleVerion(func, now, last, dir, loopedCount)

    if nil == self.__data or #self.__data <= 0 then
        return
    end

    local onHit = safeCb(func)
    local d = self.__data[#self.__data].frame
    if now and last and loopedCount then
        local eL = loopedCount > 1 and (loopedCount - 1) or 0
        if dir == 1 then
            if eL > 0 then
                print("loopedCount : ", eL)
                -- 存在 跨越 一个 循环的情况
                self:checkSeg(last, d, onHit)
                for idx = 1, eL do
                    self:checkSeg(0, d, onHit)
                end
                self:checkSeg(0, now, onHit)
            else
                if now < last then
                    -- 跨越 右边界
                    -- check last->d  0->now
                    self:checkSeg(last, d, onHit)
                    self:checkSeg(0, now, onHit)
                else
                    -- 没有跨越边界
                    -- check last->now
                    self:checkSeg(last, now, onHit)
                end
            end
        else
            if eL > 0 then
                print("loopedCount : ", eL)
                -- 存在 跨越 一个 循环的情况
                self:checkSeg(last, 0, onHit)
                for idx = 1, eL do
                    self:checkSeg(d, 0, onHit)
                end
                self:checkSeg(d, now, onHit)

            else
                if now > last then
                    self:checkSegR(last, 0, onHit)
                    self:checkSegR(d, now, onHit)

                else
                    self:checkSegR(last, now, onHit)
                end
            end
        end
    end
end

function EventTimeLine:doEvent(func, _frame, _lastFrame, dir, loopdCount)

    self:doEventSimpleVerion(func, _frame, _lastFrame, dir, loopdCount)
    do
        return
    end

    local data = self.__data
    local max = #data
    local function nextIdx(idx)
        if (idx + 1) > max then
            return 1, true
        end
        return idx + 1
    end

    local function prevIdx(idx)
        if (idx - 1) < 1 then
            return max, true
        end
        return idx - 1
    end

    if _lastFrame and _frame and loopdCount then
        -- 向右侧遍历
        local data = self.__data
        if dir == 1 then
            local _, idx = self:getTimePointData(_lastFrame)
            while true do
                local nIdx, passed = nextIdx(idx)
                if passed then
                    loopdCount = loopdCount - 1
                end
                idx = nIdx
                if loopdCount == 0 then

                    for __idx = idx, #data do
                        if data[idx].frame <= _frame then
                            -- 触发事件
                            dump(data[__idx], "trigger event:")
                        else
                            break
                        end
                    end
                    break
                else
                    dump(data[idx], "trigger event:")
                end
            end
        end

    end
end

return EventTimeLine
