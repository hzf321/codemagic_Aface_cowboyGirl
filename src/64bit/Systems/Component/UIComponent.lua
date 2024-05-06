-- 构造ui组件
--[[
    node如果是userdata类型的，会共享一个metatable，修改之后所有的cocos原生节点类型都会变化，谨慎使用
]]
bole.ctorUIComponent = function( node, uiComponentClass, params )
    if not uiComponentClass then return end
    
    node.__ui_component = node.__ui_component or {}
    local componentName = uiComponentClass.__cname
    if not componentName then
        print("error: no __cname")
        print(a.b)
        return
    end
    node.__ui_component[componentName] = uiComponentClass.new(node, params)

    local mt = getmetatable(node) or {}
    -- 这里用rawget不直接用mt.__index_ori 是因为嵌套UIComponent时会出问题，在一个组件中使用另一个组件
    if not rawget(mt, "__index_ori") then
        -- 初始化
        rawset(mt, "__index_ori", mt.__index)
        rawset(mt, "__index", function (obj, key)
            if key == "__ui_component" then
                -- 获取__ui_component
                return mt.__index_ori(obj, key)
            elseif obj.__ui_component then
                for componentName, componentObj in pairs(obj.__ui_component) do
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
                -- 没有对应函数
                return mt.__index_ori(obj, key)
            else
                return mt.__index_ori(obj, key)
            end
        end)
    end
end

bole.hasUIComponent = function ( node, uiComponentClass )
    if not uiComponentClass then return end
    
    if not node.__ui_component then return end

    local componentName = uiComponentClass.__cname
    if not componentName then
        print("error: no __cname")
        print(a.b)
        return
    end
    return node.__ui_component[componentName]
end

UIComponent = {}
UIComponent.CommonButton  = require("Systems/Component/UIComponent_Button")
