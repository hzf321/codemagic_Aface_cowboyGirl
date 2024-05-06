local TimeLine      = require("UI/CreatorUI/TimeLine")

local TimeLineGroup = class("TimeLineGroup")
function TimeLineGroup:ctor()
    self.__tl = {
        props = {},
        comps = {},
    }
end

function TimeLineGroup:createWithData( data )
    return self:new():setData( data )
end

function TimeLineGroup:setData( data )
    self.__data = data

    if data.props then
        for propName, data in pairs(data.props) do
            self.__tl.props[ propName ] = TimeLine:createWithData( data )
        end
    end
    if data.comps then
        for compName, compProps in pairs(data.comps) do
            local tbl = {}
            self.__tl.comps[ compName ] = tbl
            for propName, data in pairs(compProps) do
                tbl[propName] = TimeLine:createWithData( data )
            end
        end
    end
    return self
end

function TimeLineGroup:iter( func )

    for propName, tl in pairs(self.__tl.props) do
        func( tl, propName, nil )
    end
    for compName, compProps in pairs(self.__tl.comps) do
        for propName, tl in pairs(compProps) do
            func( tl, propName, compName )
        end        
    end
end
return TimeLineGroup