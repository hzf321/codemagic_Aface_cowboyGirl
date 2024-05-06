
-- 构造组件
bole.ctorComponent = function( object, componentClass, params )
	object.__component = object.__component or {}
	local componentName = componentClass.__cname
	if not componentName then
		print("error: no __cname")
		print(a.b)
		return
	end
	object.__component[componentName] = componentClass.new(unpack(params))

    local mt = getmetatable(object) or {}
    mt.__index = function (obj, key)
        if obj.class and obj.class[key] then
            return obj.class[key]
        elseif obj.__component then
            for componentName, componentObj in pairs(obj.__component) do
                if componentObj[key] then
                    if type(componentObj[key]) == "function" then
                        return function ( _self, ... )
                            return componentObj[key](componentObj, ...)
                        end
                    else
                        return componentObj[key]
                    end
                end
            end
        end
    end
    setmetatable(object, mt)
end

bole.hasComponent = function ( node, componentClass )
    if not componentClass then return end
    
    if not node.__component then return end

    local componentName = componentClass.__cname
    if not componentName then
        print("error: no __cname")
        print(a.b)
        return
    end
    return node.__component[componentName]
end

--[[
** brief: 有限状态机 fsm （内建版）
** params: 
** 		1.需要转态机管理的对象
** 		2.各个状态刷新函数
** 注意：直接实例化使用 不是通用形式
]]
FiniteStateMachineComponent = class("FiniteStateMachineComponent")

function FiniteStateMachineComponent:ctor(_obj, stateFuncList, commonRefresh)
	self._obj 			= _obj
	self.stateFuncList 	= stateFuncList or {}
	self.commonRefresh 	= commonRefresh
	return self
end
function FiniteStateMachineComponent:refreshByFSM()
	if not libUI.isValidNode(self._obj) then return end
	
	local FSMList = self.stateFuncList or {}

	if self.commonRefresh then
		self.commonRefresh(self._obj)
	end

	for k, stateFunc in pairs(FSMList) do
		if stateFunc(self._obj) then
			break
		end
	end
end

CtlComponent = {}

CtlComponent.RecvMessage = require("Systems/Component/CtlComponent_RecvMessage")
-- CtlComponent.InfoVideo = require("Systems/Component/CtlComponent_InfoVideo")
-- CtlComponent.LoadConfig = require("Systems/Component/CtlComponent_LoadConfig")
-- CtlComponent.LoadObject = require("Systems/Component/CtlComponent_LoadObject")
-- CtlComponent.DownloadResource = require("Systems/Component/CtlComponent_DownloadResource")
-- CtlComponent.ResourcePath = require("Systems/Component/CtlComponent_ResourcePath")
-- CtlComponent.Guide = require("Systems/Component/CtlComponent_Guide")
-- CtlComponent.ActivityTheme = require("Systems/Component/CtlComponent_ActivityTheme")
-- CtlComponent.LobbyEnter = require("Systems/Component/CtlComponent_LobbyEnter")

--[[
	需要等到b级活动都换一遍才能删除这个全局变量
]]
MessageComponent = CtlComponent.RecvMessage