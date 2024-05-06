
local TimeLine      = require("UI/CreatorUI/TimeLine")
local EventTimeLine = require("UI/CreatorUI/EventTimeLine")
local TimeLineGroup = require("UI/CreatorUI/TimeLineGroup")

local deepCopy = function(object)      
    local SearchTable = {}  

    local function Func(object)  
        if type(object) ~= "table" then  
            return object         
        end  
        local NewTable = {}  
        SearchTable[object] = NewTable  
        for k, v in pairs(object) do  
            NewTable[Func(k)] = Func(v)  
        end     

        return setmetatable(NewTable, getmetatable(object))      
    end    

    return Func(object)  
end

local Clip = class("Clip")

local __E_R = 32

Clip.E_WRAP_MODE = 
{
    Default         = 0, -- 向 Animation Component 或者 AnimationClip 查找 wrapMode
    -- 
    Normal          =       1, -- 动画只播放一遍
    Reverse         = __E_R+4, -- 从最后一帧或结束位置开始反向播放，到第一帧或开始位置停止
    
    Loop            =         2, -- 2  循环播放
    LoopReverse     = __E_R+4+2, -- 38 反向循环播放

    PingPong        =       16+4+2, --22  从最后一帧开始反向播放，其他同 PingPong    
    PingPongReverse = __E_R+16+4+2, --54
}

function Clip:ctor()
    self.__data    = nil
    -- 本节点的 时间轴信息
    self.__thisTLG = nil
    -- 子节点的 时间轴信息
    self.__chdTLGs = {}
    -- 
    self.__eventTL = nil
end

function Clip:create()
    return self:new()
end

function Clip:setLuaData( data, isCopy )
    isCopy = ((isCopy==nil)and{true}or{isCopy})[1]
    if isCopy then
        self.__data = deepCopy( data )
    else
        self.__data = data
    end
    self:_normalizeData()
end

function Clip:getEventTimeLine()
    return self.__eventTL
end

function Clip:parseNodeTimeLine()
end

function Clip:_normalizeData()
    --[[
        1. 提前判断数据类型
        2. 给数据类型 设定 运算 metatable
    --]]

    -- 建立 时间轴组对象

    local data = self.__data
    self.__sampleInv = 1 / data.sample
    local curveData = data.curveData
    if curveData then
        self.__thisTLG = TimeLineGroup:createWithData( curveData )
        if curveData.paths then
            for path, data in pairs(curveData.paths) do
                self.__chdTLGs[ path ] = TimeLineGroup:createWithData( data )
            end
        end
    end
    if data.events then
        self.__eventTL = EventTimeLine:createWithData( data.events )
    end
end



function Clip:getClipInnerName()
    if not self:isDataValid( "setSpeed" ) then
        return
    end
    return self.__data._name
end

function Clip:isDataValid( logTitle )
    if logTitle and self.__data==nil then
        -- print( logTitle, "data is not valid" )
    end
    return self.__data~=nil
end

function Clip:setSpeed( speed )
    if not self:isDataValid( "setSpeed" ) then
        return
    end
    self.__data.speed = speed
end

function Clip:getSpeed()
    return self.__data.speed or 0
end

function Clip:setWrapMode( mode )
    if not self:isDataValid( "setWrapMode" ) then
        return
    end
    self.__data.wrapMode = mode
end

function Clip:getWrapMode()
    if not self:isDataValid( "getWrapMode" ) then
        return Clip.E_WRAP_MODE.Normal
    end
    if self.__data.wrapMode then
        return tonumber(self.__data.wrapMode)
    else
        return Clip.E_WRAP_MODE.Normal
    end
end

-- 获取clip数量
function Clip:getClipCount()
    return self.__data._duration*self.__data.sample
end

-- 获取时间
function Clip:getDuration()
    return self.__data._duration
end

-- 设置帧率
function Clip:getSample()
    return self.__data.sample
end

function Clip:setSample( value )
    self.__data.sample = value
end

function Clip:getElapseValueFromClipIndex( c )
    return self.__sampleInv * c
end

function Clip:iterTimelines( func )
    self.__thisTLG:iter( func )
    for path, tlg in pairs(self.__chdTLGs) do
        tlg:iter(
            function( tl, propName, compName )
                func( tl, propName, compName, path )
            end 
        )
    end
end

function Clip:playEvent( ... )
    self.__eventTL:doEvent( ... )
end

return Clip
