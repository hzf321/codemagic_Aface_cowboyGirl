
-- RollingDigit = class("RollingLabel", function () return cc.Node:create() end)
-- function RollingDigit:ctor( font, number, scale, x, y )
    
--     self.left = nil
--     self.right = nil
--     self.size = 22
--     self.x = x
--     self.y = y
--     for i = 1, 11 do
--         local label = FONTS.new(font, tostring((i - 2) % 10))
--         label:setScale(scale)
--         label:setPosition(cc.p(0, (1-i) * self.size))
--         self:addChild(label)
--     end
--     self:setNumber(number)
-- end

-- function RollingDigit:getPos( n )
    
--     n = n or self.number
--     return cc.p(self.x, (n + 1) * self.size + self.y)
-- end

-- function RollingDigit:setLeftDigit( left )
    
--     self.left = left
--     if self.left then
--         self.left.right = self
--     end
-- end

-- function RollingDigit:setNumber( number )
--     self.number = number
--     self:reset()
-- end

-- function RollingDigit:reset( ... )
--     self:cleanup()
--     self:setPosition(self:getPos())
-- end

-- function RollingDigit:destroySelf( ... ) -- 后续可能需要修改 $
--     if self.right then
--         self.right:setLeftDigit( nil )
--     end
--     local suffix = self:getParent():getChildByName("$")
--     if suffix then
--         suffix:setPosition(cc.p(self.x, self.y))
--     end
--     self:removeFromParent()
-- end

-- function RollingDigit:roll( duration )
--     self:reset()
--     local a = self.number - 1
--     if a == -1 then
--         if self.left then
--             self.left:roll( duration )
--         end
--     end
--     if a == 0 and not self.left then
--         self:destroySelf()
--         return
--     end
--     self.number = a

--     local action = cc.MoveTo:create(duration, self:getPos())
--     if self.number == -1 then
--         self.number = 9
--     end
--     action = cc.Sequence:create(action, cc.DelayTime:create(duration), cc.CallFunc:create( function() self:reset() end ))
--     self:runAction(action)
-- end

-- function RollingDigit:rollForever( duration )
--     -- self.number = 0
--     local action = cc.CallFunc:create( function() self:setPosition(self:getPos(9)) end )
--     action = cc.Sequence:create( action, cc.MoveTo:create(duration * 9, self:getPos(0)) )
--     action = cc.RepeatForever:create(action)
--     self:runAction(action)
-- end

-- function RollingDigit:stopRoll( ... )
    
--     self:reset()   
-- end

-- RollingLabel = class("RollingLabel", function () return cc.ClippingNode:create() end)
-- function RollingLabel:ctor( font, number, scale, offset, rightDigitDuration)
    
--     local formerDigit = nil
--     local index = 1
--     repeat
--         local d = RollingDigit.new(font, number % 10, scale, -index*scale*offset , 0)
--         self:addChild(d, 0, index)
--         if formerDigit then
--             formerDigit:setLeftDigit(d)
--         elseif rightDigitDuration and rightDigitDuration > 0 then
--             d:rollForever(rightDigitDuration)
--         end
--         formerDigit = d
--         index = index + 1
--         number = math.floor(number / 10)
--     until number == 0
--     local d = FONTS.new(font,"", scale) --  "$"
--     d:setScale(scale)
--     d:setPosition(cc.p(-index*scale*offset, 0))
--     d:setName("$")
--     self:addChild(d)
-- end

-- function RollingLabel:setNumber( number )
    
--     local a = self:getChildByTag(1)
--     while a do
--         a:setNumber(number % 10)
--         if a.left then
--             a = a.left
--             number = math.floor(number / 10)
--         else
--             if number % 10 == 0 then
--                 a:destroySelf()
--             end
--             a = nil
--         end
--     end
-- end

-- function RollingLabel:roll( duration, startIndex)
    
--     self:getChildByTag(startIndex):roll(duration)
--     self.isRolling = 1
-- end

-- function RollingLabel:stopRoll()
    
--     self:cleanup()
--     local digit = self:getChildByTag(1)
--     while(digit) do
--         digit:stopRoll()
--         digit = digit.left
--     end
-- end
