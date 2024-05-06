local BLNode      = require("UI/CreatorUI/BLNode")

local Coin_Node = class("Coin_Node", BLNode)

function Coin_Node:ctor(isPortrait)
    self.isPortrait  = isPortrait
    self.start_scale = 0.95
    self.width       = 179
    self.nPos        =  cc.p(-330, -28) 
    self.csb         = "ui/header_footer/coin_node"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:loadControls()
end

function Coin_Node:loadControls()
    self.root = self.node.root

    self.coin_node = self.root
    self.coin_node:setPosition(self.nPos)

    self.sp_coin   = self.root.sp_coin

    self.label_coins = self.root.label_coins
    local coin = User:getInstance():getCoins()
    self.label_coins:setString(FONTS.format(coin, true))

    inherit(self.label_coins, LabelNumRoll)
    local parserFunc = function (n)
        return FONTS.format(n, true)
    end
    self.label_coins:nrInit(coin, 25, parserFunc)


	local starAnim = self.root.starAnim
	if starAnim then
		local forever =  cc.RepeatForever:create( cc.Sequence:create(
			cc.DelayTime:create(5), cc.CallFunc:create(function ()
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


function Coin_Node: getRandomNum(num1, num2)
    math.randomseed(os.time()) -- 设置随机数种子
    local random_num = math.random(num1, num2) -- 生成1到10之间的随机整数 
    return random_num
end


return Coin_Node