local CreatorUtils = class("CreatorUtils")

local _ctrlMark = "#"
function CreatorUtils.__getItem( parent, name )
    if string.sub(name,1,1)==_ctrlMark then
        name = string.sub( name, 2, string.len(name) )
        if parent.getController then
            local c = parent:getController( name )
            return c
        else
            print( "getController not found : " .. name )
            return nil
        end
    else
        return parent[ name ]
    end
end

function CreatorUtils.__getItemByPathList(root, pathList, errorOutput)
    local _root = root
    local _rRoot
    for _idx, name in ipairs(pathList) do
        _rRoot = CreatorUtils.__getItem(_root, name)
        if _rRoot == nil then
            return nil
        end
        _root = _rRoot
    end

    return _root
end

function CreatorUtils.getItemByPath(root, path, errorOutput)
    local pathList = string.split(path, ".")
    return CreatorUtils.__getItemByPathList(root, pathList, errorOutput)
end

return CreatorUtils
