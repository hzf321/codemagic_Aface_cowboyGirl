local function setmethods(target, controller, methods)
    for _, name in ipairs(methods) do
        local method = controller[name]
        target[name] = function(__, ...)
            return method(controller, ...)
        end
    end
end

local EXPORTED_CONTROLLER_METHODS = {"addController", "removeController", "getController", "getAllController",
                                     "removeAllController", "broadcastToAllController", "onAfterControllerAdded"}

local ControllerMix = class()

function ControllerMix:init_()
    self.target_ = nil
    self.__controllers = {}
    -- self.listeners_ = {}
    -- self.nextListenerHandleIndex_ = 0
end

function ControllerMix:attach(target)
    local controllerMix = self:new()
    target.__controllerMix = controllerMix
    controllerMix:bind(target)
end

function ControllerMix:bind(target)
    self:init_()
    setmethods(target, self, EXPORTED_CONTROLLER_METHODS)
    self.target_ = target
end

-- 有关 Controller 的 操作
function ControllerMix:addController(ctrlInfo, uiNode)

    local isSimpleConfig = (type(ctrlInfo) == "string")
    local ctrlName = isSimpleConfig and ctrlInfo or ctrlInfo.name
    local ctrlConfig = isSimpleConfig and {} or ctrlInfo.config
    
    local cpmtClass = require(ctrlName)
    if type(cpmtClass) ~= "table" then
        print(string.format("CtrlName <%s> not found", ctrlName))
        return nil
    end

    local controller = cpmtClass:create(uiNode, ctrlConfig, self.target_)
    if self.__controllers[ctrlName] then
        print("same controller found " .. ctrlName)
    else
        self.__controllers[ctrlName] = controller
    end

    return controller
end

function ControllerMix:removeController(name)
    -- print( "removed", name )
    local ctrl = self.__controllers[name]
    ctrl:dispose()
    self.__controllers[name] = nil

end

function ControllerMix:getController(name)
    -- 名称匹配 ( 完全匹配 )
    local c = self.__controllers[name]
    if c then
        return c
    end

    for k, v in pairs(self.__controllers) do
        local strs = bole.splitStr(k, "/")
        local subName = strs[#strs]
        if name == subName then
            return v
        end
    end
    --去除路径后的名字 **/**/name
    local strs = bole.splitStr(name, "/")
    name = strs[#strs]
    c = self.__controllers[name]
    if c then
        return c
    end
    return nil
end

function ControllerMix:getAllController()
    return self.__controllers
end

function ControllerMix:dumpControllers()
    print("dumpControllers < ： ")
    for name, ctrl in pairs(self.__controllers) do
        print("controller : ", name, tostring(ctrl))
    end
    print("dumpControllers > ")
end

function ControllerMix:removeAllController()

    local keys = table.keys(self.__controllers)
    for _, name in pairs(keys) do
        self:removeController(name)
    end
end

function ControllerMix:broadcastToAllController(evt)
    for _, ctrl in pairs(self.__controllers) do
        if ctrl.receiveBroadcast then
            ctrl:receiveBroadcast(evt)
        end
    end
end

function ControllerMix:onAfterControllerAdded()
    local evt = {
        name = "onAfterControllerAdded"
    }
    self:broadcastToAllController(evt)
end

function ControllerMix:update(...)
    for _, ctrl in pairs(self.__controllers) do
        -- print( ... )
        if ctrl.update then
            ctrl:update(...)
        end
    end

end

return ControllerMix
