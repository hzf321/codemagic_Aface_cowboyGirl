
-- local parentClass = ThemeBaseViewControlDelegate
local ThemeBasePickViewControl = class("ThemeBasePickViewControl", parentClass)
local cls = ThemeBasePickViewControl

function cls:ctor(bonusParent, themeCtl, data, nodeList, callFunc)
    self.themeCtl = themeCtl
    self.bonusParent = bonusParent
    -- self.csb = self.themeCtl:getCsbPath(data.csb)
    
    self.callback = callFunc
    self.node = cc.Node:create()
    bole.scene:addToContentFooter(self.node)

    self:initPickData(data)

    self:initLayout(nodeList)


    -- parentClass.ctor(themeCtl)
end

function cls:initPickData( data )
    self.pickData = data
    self.pickConfig = data.config
end

function cls:initLayout(nodesList)
    -- self._view = ThemeBasePickView.new(self, nodesList,  self.pickConfig)
end

function cls:getItemPosList( count )
    return self.pickConfig.pos_list or {}
end


function cls:getPickItemState()
    -- return state_list
end

function cls:checkInFinshPick()
    return false
end

function cls:enterFeatureGame()
    self:initPickItems()
    
    self:showPickNode()
end

function cls:initPickItems( )
    local count = self.pickData.count
    local pos_list = self:getItemPosList(self.pickData.count)
    local state_list = self:getItemPosList()
    self._view:initPickNode(count, pos_list, state_list)
end

function cls:showPickNode( ... )
    local delay = self._view:showPickScreen() or 0.5

    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function ( ... )
                self:openPickGame()
            end)))
end

function cls:openPickGame( ... )
    if self.haveLeft > 0 then 
        self._view:showPickGameTipAnim(true)
        self._view:initPickEvent()

        self:setTouchPickItem(true)
    else
        self:pickAllItemOver()
    end
end

function cls:pickAllItemOver(  )
    self._view:updateAllItem()
end

function cls:openOnePickItem( index )
    self._view:openOnePickItem( index )
end

function cls:canTouchPickItem()
    return self.canClickItem and self.haveLeft > 0
end
function cls:setTouchPickItem(status)
    self.canClickItem = status
end
function cls:setPickLeft(count)
    self.haveLeft = count
end
function cls:getPickLeft()
    return self.haveLeft
end

-- themeCtl 方法
function cls:getSpineFile(file_name)
    return self.themeCtl:getSpineFile(file_name)
end


function cls:getParticleFile(file_name)
    return self.themeCtl:getParticleFile(file_name)
end

function cls:getFntFilePath(file_name)
    return self.themeCtl:getFntFilePath(file_name)
end


function cls:playMusicByName(name, singleton, loop)
    self.themeCtl:playMusicByName(name, singleton, loop)
end


return ThemeBasePickViewControl