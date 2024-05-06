Slider = class("Slider", function () return cc.ClippingNode:create() end)

-- @params: 
-- float speed means how many seconds needed to move for 100 pixels
-- int offset mean how many pixel blank to put on the left and right of label
function Slider:ctor( child, width, speed, offset)
    
    self.child = child
    self.width = width
    self.speed = speed
    self.offset = offset or 20
    local a = child:getContentSize()
    self.childWidth = a.width
    self:addChild(child)
    self.child:setPosition(cc.p(self.offset, 0))
    self.child:setAnchorPoint(cc.p(0, 0))
    local vex = {cc.p(0,0), cc.p(width,0), cc.p(width, a.height), cc.p(0, a.height)}
    local stencil = cc.DrawNode:create()
    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
    self:setStencil(stencil)
    self:roll()
end


function Slider:roll( duration, startIndex)
    
    local len = math.abs(self.width - self.childWidth) + self.offset * 2
    local action = cc.MoveTo:create(self.speed * len / 100, cc.p(self.width - self.childWidth - self.offset, 0))
    local action1 = cc.MoveTo:create(self.speed * len / 1000, cc.p(self.offset, 0))
    action = cc.Sequence:create(action, action1)
    action = cc.RepeatForever:create(action)
    self.child:runAction(action)
end

function Slider:stop()
    
    self:cleanup()
    self.child:setPosition(cc.p(0, 0))
end
