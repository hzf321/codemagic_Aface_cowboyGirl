local UIContainer = class("UIContainer")

local _ctrlMark = "#"
local function __getItem( parent, name )
    if string.sub(name,1,1)==_ctrlMark then
        name = string.sub( name, 2, string.len(name) )
        if parent.getController then
            local c = parent:getController( name )
            return c
        else
            print( "getController not found : ", name )
            return nil
        end
    else
        return parent[ name ]
    end
end

local function __getItemByPathList(root, pathList, errorOutput)

    local _root = root
    local _rRoot
    for _idx, name in ipairs(pathList) do
        _rRoot = __getItem(_root, name)
        if _rRoot == nil then
            return nil
        end
        _root = _rRoot
    end

    return _root
end

local function getItemByPath(root, path, errorOutput)
    local pathList = string.split(path, ".")
    return __getItemByPathList(root, pathList, errorOutput)
end

local function doItemByPath(root, path, ...)
    local pathList = string.split(path, ".")

    local fn = table.remove(pathList, #pathList)
    local item = __getItemByPathList(root, pathList, errorOutput)

    -- print( "fn name ", fn )
    -- dump( pathList, "pathList : " )

    if nil == item then
        return nil
    end

    if nil == item[fn] then
        return nil
    end

    return item[fn](item, ...)
end

function UIContainer:ctor()
end

function UIContainer:create()
    return self.new()
end

function UIContainer:haveUI(path)
    local node = self:getNode(path)
    return (node ~= nil)
end

function UIContainer:getItem(path, errorOutput)
    if self.__root then
        return getItemByPath(self.__root, path, errorOutput)
    end
    return getItemByPath(self, path)
end

function UIContainer:doItem(path, ...)
    if self.__root then
        return doItemByPath(self.__root, path, ...)
    end
    return doItemByPath(self, path, ...)
end

function UIContainer:setRoot(root)
    self.__root = root
end

-- 只是获取 __root  根节点
function UIContainer:getRoot()
    return self.__root
end

local BLComponentBase = class("BLComponentBase")

function BLComponentBase:create(uiNode, cfg, root)
    return self.new():init(uiNode, cfg, root)
end

function BLComponentBase:init(uiNode, cfg, root)

    self:setRoot(root)
    self:setUINode(uiNode)
    self:setConfig(cfg)

    -- self:initButton()
    self:initUI()
    self:updateUI()
    return self
end

function BLComponentBase:initUI()
end
function BLComponentBase:updateUI()
end

function BLComponentBase:ctor()
    self.eventDispatcher = nil
    self:clear()
    self:setHandler(nil)
end

function BLComponentBase:clear()
    self.ui = nil
    self.__listeners = nil
end

function BLComponentBase:dispose()
    self:clear()
end

function BLComponentBase:addTouchEvent( btn, event, param )
	
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
        	if event then
        		event(param)
        	end
        end
    end
    btn:addTouchEventListener(btnEvent)
end

function BLComponentBase:setRoot(rootNode)
    local ui = UIContainer:create()
    -- print( "setRoot, ", rootNode )
    ui:setRoot(rootNode)
    self.ui = ui
end

function BLComponentBase:getRoot()
    return self.ui:getRoot()
end

function BLComponentBase:setConfig(config)
    self.__config = config
end

function BLComponentBase:getConfig()
    return self.__config
end

function BLComponentBase:setUINode(uiNode)
    self.__uiNode = uiNode
end

function BLComponentBase:getUINode()
    return self.__uiNode
end

-- 默认的 handler
function BLComponentBase:setHandler(cb)
    self.__cb = cb
end

function BLComponentBase:getHandler()
    return self.__cb
end

function BLComponentBase:setData(data)
    self.__data = data
end

function BLComponentBase:getData()
    return self.__data
end

return BLComponentBase
