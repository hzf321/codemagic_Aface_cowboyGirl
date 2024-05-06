--- @program src
--- @description:  
--- @author: rwb 
---@create: : 2021/02/22 19:00:00
local cls = class("MultiView")
function cls:ctor(ctl, parent, flyNode)
    self.ctl = ctl
    self.node = parent
end
function cls:initRoot()
    self.node:setVisible(false)
    self.multiDesc = self.node:getChildByName("desc")
    self.multiLeftCnt = self.node:getChildByName("left_cnt")
    self.node.base_pos = cc.p(34, -245)
    self.node:setPosition(cc.p(34, -245))
end
function cls:hideMultiTipNode()
    self.multiTipNode:setVisible(false)
end
function cls:setMultiSpinLeftCount(count, multi)
    if count < 0 then
        self.node:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.3, 0),
                        cc.Hide:create()
                )
        )
        self.ctl:playMusicByName("doubletip_out")
    elseif count <= 1 then
        self.multiLeftCnt:setString(count)
        local str = self.ctl:getCommonConfig().multi_tip_config["tip_desc"]
        str = string.format(str, multi)
        self.multiDesc:setString(str)
    else
        self.multiLeftCnt:setString(count)
    end
end
function cls:showMultiSpinLeftCount(count, multi, isAni)
    self.multiLeftCnt:setString(count)
    local multi_tip_config = self.ctl:getCommonConfig().multi_tip_config
    local str
    if count > 1 then
        str = multi_tip_config["tip_desc1"]
    elseif count then
        str = multi_tip_config["tip_desc"]
    end
    str = string.format(str, multi)
    self.multiDesc:setString(str)
    self.node:setVisible(true)
    if isAni then
        self.node:setScale(0)
        self.node:runAction(
                cc.ScaleTo:create(0.3, 1)
        )
        self.ctl:playMusicByName("doubletip_in")
    else
        self.node:setScale(1)
    end
end
function cls:getMultiNodeWorldPos()
    return self.node:convertToWorldSpace(cc.p(0, 0))
end
return cls





