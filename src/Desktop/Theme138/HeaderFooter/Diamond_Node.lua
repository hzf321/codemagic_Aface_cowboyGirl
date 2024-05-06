local BLNode      = require("UI/CreatorUI/BLNode")

local Diamond_Node = class("Coin_Node", BLNode)

function Diamond_Node:ctor(isPortrait)
    self.isPortrait  = isPortrait
    self.start_scale = 0.95
    self.width       = 179
    self.nPos        =  cc.p(-70, -28) 
    self.csb         = "ui/header_footer/diamond_node"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:loadControls()
end

function Diamond_Node:loadControls()
    self.root = self.node.root

    self.diamond_node = self.root
    self.diamond_node:setPosition(self.nPos)

    self.sp_diamond   = self.root.sp_diamond

    self.label_diamonds = self.root.label_diamonds
    local diamonds = User:getInstance():getDiamonds()
    self.label_diamonds:setString(FONTS.format(diamonds, true))

    inherit(self.label_diamonds, LabelNumRoll)
    local parserFunc = function (n)
        return FONTS.format(n, true)
    end
    self.label_diamonds:nrInit(diamonds, 25, parserFunc)

    
    local starAnim = self.root.starAnim
	if starAnim then
		local forever =  cc.RepeatForever:create( cc.Sequence:create(
			cc.DelayTime:create(5.5), cc.CallFunc:create(function ()
                starAnim:setVisible(true)
				local num = self:getRandomNum(1,2)
				local animName = ""
				if num == 1 then
					animName = "animation"
				else
					animName = "animation2"
				end
				starAnim:setAnimation(0, animName, false)
			end)
		))
		starAnim:runAction(forever)
	end

end


function Diamond_Node: getRandomNum(num1, num2)
    math.randomseed(os.time()) -- 设置随机数种子   
    local random_num = math.random(num1, num2) -- 生成1到10之间的随机整数
    return random_num
end


return Diamond_Node