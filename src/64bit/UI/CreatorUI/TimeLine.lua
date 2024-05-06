local EaseHelper = require("UI/CreatorUI/EaseHelper")
local MotionPath = require("UI/CreatorUI/AnimeMotion")

local TimeLine = class("TimeLine")

TimeLine.E_V_TYPE = {
    EVENT = -1,
    UNKNOWN = 0,
    VEC_2 = 1,
    VEC_2XY = 11,
    NUM = 2,
    UUID = 3,
    BOOLEAN = 4,
    COLOR_RGBA = 301
}

local E_V_TYPE = TimeLine.E_V_TYPE

function TimeLine:ctor()
    self.__valueType = nil
    self.__haveMotionPath = false
end

function TimeLine:createWithData(data)
    local tl = self:new()
    tl:setData(data)
    return tl
end

function TimeLine:checkAndInitMotionPath(list)

    local isMP = false
    for idx, item in ipairs(list) do
        if item.motionPath then
            isMP = true
            break
        end
    end

    if not isMP then
        return
    end

    self.__haveMotionPath = true
    self.__motionPaths = {}
    for idx, curr in ipairs(list) do
        local mp
        local next = list[idx + 1]
        -- 数据有效并且存在
        if next and curr.motionPath and #curr.motionPath > 0 then
            mp = MotionPath.new()
            mp:setData(curr.motionPath, curr.value, next.value)
            -- end
        else

        end
        self.__motionPaths[idx] = mp

    end

    return
end

function TimeLine:setData(data)
    self.__data = data

    local tp1 = data[1]

    if nil == tp1 then
        return
    end

    local tp1V = tp1.value
    local tp1VType = type(tp1V)

    self:checkAndInitMotionPath(data)

    if tp1.func then
        self.__valueType = E_V_TYPE.EVENT
    else
        if tp1VType == "number" then
            self.__valueType = E_V_TYPE.NUM
        elseif tp1VType == "boolean" then
            self.__valueType = E_V_TYPE.BOOLEAN
        elseif tp1VType == "table" then
            if tp1V[1] and tp1V[2] then
                self.__valueType = E_V_TYPE.VEC_2
            elseif tp1V.x and tp1V.y then
                self.__valueType = E_V_TYPE.VEC_2XY
            elseif tp1V.__uuid__ then
                self.__valueType = E_V_TYPE.UUID
            elseif tp1V.r and tp1V.g and tp1V.b and tp1V.a then
                self.__valueType = E_V_TYPE.COLOR_RGBA
            end
        else
            self.__valueType = E_V_TYPE.UNKNOWN
        end
    end
end

function TimeLine:getTimePointData(_frame)
    local data = self.__data
    for idx = #data, 1, -1 do
        local clip = data[idx]
        if _frame >= clip.frame then
            return clip, idx
        end
    end
    return data[1], 1
end

function TimeLine:getInterPolatedValue(_frame)

    local clip1, idx1 = self:getTimePointData(_frame)
    local idx2 = idx1 + 1
    local clip2 = self.__data[idx2]
    if nil == clip1 then
        return nil
    end

    if nil == clip2 then
        -- 最后一段
        return clip1.value
    end

    local total = clip2.frame - clip1.frame
    local elapse = _frame - clip1.frame

    -- 先尝试 使用 motionPath  差值
    -- 如果 没有找到 相关信息， 使用 后面的 一般差值方法
    if self.__haveMotionPath then
        local mp = self.__motionPaths[idx1]
        if mp then
            -- 时间差值
            local v = EaseHelper:interp(clip1.curve, 0, 1, 1, elapse)
            -- 求最终差值
            return mp.__curve:getValue(_frame, 0, v, total)
        end
    end

    if self.__valueType == E_V_TYPE.NUM then
        return EaseHelper:interp(clip1.curve, clip1.value, clip2.value, total, elapse)

    elseif self.__valueType == E_V_TYPE.VEC_2 then
        return {
            [1] = EaseHelper:interp(clip1.curve, clip1.value[1], clip2.value[1], total, elapse),
            [2] = EaseHelper:interp(clip1.curve, clip1.value[2], clip2.value[2], total, elapse)
        }

    elseif self.__valueType == E_V_TYPE.VEC_2XY then
        return {
            x = EaseHelper:interp(clip1.curve, clip1.value.x, clip2.value.x, total, elapse),
            y = EaseHelper:interp(clip1.curve, clip1.value.y, clip2.value.y, total, elapse)
        }

    elseif self.__valueType == E_V_TYPE.BOOLEAN then
        return clip1.value

    elseif self.__valueType == E_V_TYPE.UUID then
        return clip1.value

    elseif self.__valueType == E_V_TYPE.COLOR_RGBA then
        return {
            r = EaseHelper:interp(clip1.curve, clip1.value.r, clip2.value.r, total, elapse),
            g = EaseHelper:interp(clip1.curve, clip1.value.g, clip2.value.g, total, elapse),
            b = EaseHelper:interp(clip1.curve, clip1.value.b, clip2.value.b, total, elapse),
            a = EaseHelper:interp(clip1.curve, clip1.value.a, clip2.value.a, total, elapse)
        }
    end

    return clip1.value
end

function TimeLine:dumpInfo()
    if self.__valueType == E_V_TYPE.EVENT then
        print("timeline valueType  E_V_TYPE.EVENT   ")
    elseif self.__valueType == E_V_TYPE.UNKNOWN then
        print("timeline valueType  E_V_TYPE.UNKNOWN ")
    elseif self.__valueType == E_V_TYPE.VEC_2 then
        print("timeline valueType  E_V_TYPE.VEC_2   ")
    elseif self.__valueType == E_V_TYPE.NUM then
        print("timeline valueType  E_V_TYPE.NUM     ")
    elseif self.__valueType == E_V_TYPE.UUID then
        print("timeline valueType  E_V_TYPE.UUID    ")
    elseif self.__valueType == E_V_TYPE.BOOLEAN then
        print("timeline valueType  E_V_TYPE.BOOLEAN ")
    else
        print("timeline valueType  INVALID    ")
    end
end

return TimeLine
