
local ThemeBasePickView = class("ThemeBasePickView")
local cls = ThemeBasePickView

function cls:ctor( vCtl, nodesList, config )
    self.vCtl = vCtl
    self.pickConfig = config
    self:_initLayout(nodesList)
end

function cls:_initLayout( nodeList )
    self.parent = nodeList[1]

    self.node = cc.Node:create()

    if self.node and self.pickConfig and self.pickConfig.csb then 
        self.csb = self.vCtl:getCsbPath(self.pickConfig.csb)
        self.pickRoot = cc.CSLoader:createNode(path)
        self.node:addChild(self.node)
    end

    self:loadControls()
end

function cls:loadControls()

end

function cls:initPickNode(count, pos_list, state_list)
    self.pickItemList = {}

    state_list = state_list or {}
    for i = 1, count do 
        self:_addPickItem(i, pos_list[i], state_list[i])
    end
end

function cls:showPickScreen()
    
    self.node:runAction(cc.FadeIn:create(0.2))
end

function cls:changePickGameTipState(isShow)
    self:setTipTextState(isShow)
    self:playLoopPickItems(isShow)
end

function cls:setTipTextState( isShow )
    
end

function cls:playLoopPickItems(isShow)
    -- if isShow then 
    --     self.loopIndex = 0
    --     local a1 = function()
    --         for key, node in ipairs(self.pickItemList) do
    --             if key % 3 == self.loopIndex then
    --                 node:playLoopAni(self.loopIndex)
    --             end
    --         end
    --         self.loopIndex = self.loopIndex + 1
    --         if self.loopIndex == 3 then
    --             self.loopIndex = 0
    --         end
    --     end
    --     self.node:runAction(
    --         cc.RepeatForever:create(
    --             cc.Sequence:create(
    --                 cc.CallFunc:create(a1),
    --                 cc.DelayTime:create(self.loopDelay)
    --             )
    --         )
    --     )
    -- else
    --     self.node:stopAllAction()
    -- end

end

function cls:_addPickItem(index, pos)

end

function cls:closePickScreen()
    self.node:runAction(cc.Sequence:create(
        cc.FadeOut:create(0.2),
        cc.removeSelf:create()))
end

function cls:pickOverItem(index, dataInfo, isOpenAni)
    self.pickItemList[index]:openPickItem(dataInfo, isOpenAni)
end

function cls:updateAllItem(pick_item_info, win_type)
    -- for key = 1, #self.pickItemList do
    --     self.pickItemList[key]:openPickItem(pick_item_info[key], false, pick_item_info[key] ~= win_type)
    -- end
end

function cls:initPickEvent()
    for key = 1, #self.pickItemList do
        local pickItem = self.pickItemList[key]
        pickItem:setTouchStatus(true)
    end
end

return ThemeBasePickView
