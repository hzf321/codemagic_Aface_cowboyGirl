local getParticle = function (name)
	return ("commonEffect/header/coins/particles/" .. name ..".plist")
end

local getSpine = function (name)
	return ("commonEffect/header/coins/spines/" .. name .."/spine")
end

local getDiamondParticle = function (name)
	return ("commonEffect/header/chips/particles/" .. name ..".plist")
end

local getDiamondSpine = function (name)
	return ("commonEffect/header/chips/spines/" .. name .."/spine")
end



HeaderFooterControl = class("HeaderFooterControl")

function HeaderFooterControl:ctor()
	self:reset()
end

function HeaderFooterControl:reset()
    self.callback_event = {}
end

function HeaderFooterControl:getInstance( ... )
	if not self._instance then
		self._instance = HeaderFooterControl.new()
	end
	return self._instance
end

--[[
* 名称：flyCoins
* 功能：飞金币到金币栏
* 参数：
    - startPosition：开始位置
    - earlierCoins：金币初始值
    - coins：增加的金币值
    - parent：父节点
    - playAnimate：是否需要飞金币动画
    - notAddCoins：是否需要将金币roll到金币栏
    - scale：金币缩放值
    - numCoins：飞行中的金币个数
    - duration：飞行时长
    - interval: 飞行时长开关
* 返回值：飞行时间
]]--
function HeaderFooterControl:flyCoins( startPosition, earlierCoins, coins, parent, data)

    local header = User:getInstance().header

	parent = parent or header
    local coin_node = header:createHeaderCoinNode(parent == header)
                              
    local coinPos = cc.p(0, 0)
	local delay = 3.5
    if libUI.isValidNode(coin_node.sp_coin) and libUI.isValidNode(parent) and libUI.isValidNode(coin_node) then
        bole.playSounds("coins") -- 播放飞金币音乐

        coinPos = cc.p(coin_node.sp_coin:getPosition())

        local startNode = parent:convertToNodeSpace(startPosition)
        local end_pos   = coin_node.sp_coin:getParent():convertToWorldSpace(coinPos)
        local endNode   = parent:convertToNodeSpace(end_pos)
        local scale     = 0.55

        if parent ~= header then -- 飞金币之前的准备工作，如果是自身飞，则不用变换parent

            local pos = bole.toNodePos(parent, coin_node)
            coin_node:setPosition(pos)
            coin_node:setVisible(true)

            coin_node.start_parent = coin_node:getParent()

            local temp_scale = 1
            local temp_parent = parent
            for i = 1, 10 do
                if libUI.isValidNode(temp_parent) then
                    temp_scale  = temp_scale*temp_parent:getScaleX()
                    if temp_parent == bole.scene then
                        break
                    end
                    temp_parent = temp_parent:getParent()
                end
            end
            bole.changeParent(coin_node, parent)

            bole.setEnableRecursiveCascading(coin_node, true)
            coin_node:setOpacity(0)
            coin_node:runAction(cc.FadeTo:create(0.5, 255))
        else
            scale = 0.4
        end

        local function addCoinsFlySpine(parent, index)
            self:addCoinsFlySpine(parent, index)
        end

        self:addCoinsStartSpine({parent = parent, pos = startNode, play = true, coins_ui = coin_node}) -- 开始的地方飞粒子
        local temp_end = endNode
        -- if ui.endWordP then
        --     temp_end = cc.p(endNode.x - 105, endNode.y)
        -- end
        delay = ANIMATE.bezierForNewCoins(parent, startNode, temp_end, 24, 0.8, nil, "commonEffect/newcoins/theme" .. THEME_DESKTOP_ID .. "/%d.png", scale, 0.12, nil, addCoinsFlySpine) + 0.2
                                                                         
        local function callfunc()

            if libUI.isValidNode(self) then
                self:playCoinsFlyGet(false, coin_node) -- 结束的地方特效消失
            end

            if libUI.isValidNode(coin_node) and libUI.isValidNode(coin_node.start_parent) then
                coin_node:runAction(cc.Sequence:create(
                    cc.FadeTo:create(0.1, 0),
                    cc.CallFunc:create(function ()
                        if libUI.isValidNode(coin_node) and libUI.isValidNode(coin_node.start_parent) then
                            coin_node:setVisible(false)
                            coin_node:removeFromParent()
                            coin_nodee = nil
                        end
                    end)
                ))
            end
        end
        TimerCallFunc:getInstance():addCallFunc(callfunc, delay - 0.01) -- delay - 0.1秒以后，节点渐隐

        local function stopCoinsStartSpine() -- 最后一个金币飞完，开始地方的特效粒子消失
            if libUI.isValidNode(self) then
                self:addCoinsStartSpine({coins_ui = coin_node})
            end
        end
        TimerCallFunc:getInstance():addCallFunc(stopCoinsStartSpine, delay - 0.8) 

        local function callfunc() -- 加金币操作，等第一个金币飞到金币栏，开始滚金币
            self:playCoinsFlyGet(true, coin_node)
            coins = coins or 0
            header:setCoinsScale(earlierCoins, earlierCoins + coins)
            if header.ui_coins then
                for k, ui in pairs(header.ui_coins) do
                    if ui and libUI.isValidNode(ui.label_coins)  then
                        if coin_node == ui then
                            ui.label_coins:nrStartRoll(earlierCoins, earlierCoins+coins, delay - 1) -- 滚动delay - 0.8秒                        
                        else
                            ui.label_coins:setString(self:formatCoin(earlierCoins + coins))
                        end
                    end
                end
            end
        end
        TimerCallFunc:getInstance():addCallFunc(callfunc, 0.8) -- 用timer是因为主题内会pause action，所以不能用action
	end

	return delay
end

-- 金币粒子效果
function HeaderFooterControl:addCoinsFlySpine(parent, index)
    if libUI.isValidNode(parent) and index then
        local fly_particle  = getParticle("jinbilizi_1")
        if index%2 == 0 and fly_particle and cc.FileUtils:getInstance():isFileExist(fly_particle) then
            local temp_particle = cc.ParticleSystemQuad:create(fly_particle)
            parent:addChild(temp_particle)
        end
        local fly_particle2 = getParticle("jb_lzbj_01_1")
        if fly_particle2 and cc.FileUtils:getInstance():isFileExist(fly_particle2) then
            local temp_particle = cc.ParticleSystemQuad:create(fly_particle2)
            parent:addChild(temp_particle)
        end
    end
end

-- 金币飞行结束效果
function HeaderFooterControl:playCoinsFlyGet(show, coin_node)

    local get_spine = getSpine("coins_fly_get")
    if libUI.isValidNode(coin_node.sp_coin) and get_spine then
        if show then
            local pos  = cc.p(23.5,22.5)
            local _, s = bole.addSpineAnimation(coin_node.sp_coin, nil, get_spine, pos, "animation", nil, nil, nil, false, false, nil)
            coin_node.spine_get = s
        else
            if libUI.isValidNode(coin_node.spine_get) then
                coin_node.spine_get:removeFromParent()
                coin_node.spine_get = nil
            end
        end
    end

end

-- 金币飞行开始效果
function HeaderFooterControl:addCoinsStartSpine(data)
    local data      = data or {}
    local parent    = data.parent
    local pos       = data.pos or cc.p(0, 0)
    local play      = data.play
    local coin_node = data.coins_ui

    local start_spine =  getSpine("coins_fly_start")
    if start_spine then
        if libUI.isValidNode(coin_node.start_spine) and not play then
            coin_node.start_spine:runAction(cc.Sequence:create(
                cc.FadeTo:create(0.1, 0),
                cc.CallFunc:create(function ()
                    if libUI.isValidNode(coin_node.start_spine) then
                        coin_node.start_spine:removeFromParent()
                        coin_node.start_spine = nil
                    end
                end)
            ))

        elseif play and libUI.isValidNode(parent) then
            local _, s = bole.addSpineAnimation(parent, nil, start_spine, pos, "animation", nil, nil, nil, false, false, nil)
            coin_node.start_spine = s
        end
    end
end

function HeaderFooterControl:formatCoin(n)
    local last = ""
    if self.isAllowKB == true then
        if not ScreenControl:getInstance().isPortrait then
            if n > 999999999999999999999 then
                n = n / 1000000000
                n = math.floor(n)
                last = "B"
                return FONTS.format(n, true) .. last
            elseif n > 999999999999999999 then
                n = n / 1000000
                n = math.floor(n)
                last = "M"
                return FONTS.format(n, true) .. last
            elseif n > 999999999999999 then
                n = n / 1000
                n = math.floor(n)
                last = "K"
                return FONTS.format(n, true) .. last
            end
        else
            return FONTS.format(n, true) .. last
        end
    end 

    return FONTS.format(n, true)
end



--------------------------------------------------------------------------------------------------------
--[[
* flyChips
* 功能：飞金币到金币栏
* 参数：
    - startPosition：开始位置
    - earlierCoins：金币初始值
    - coins：增加的金币值
    - parent：父节点
    - playAnimate：是否需要飞金币动画
    - notAddCoins：是否需要将金币roll到金币栏
    - scale：金币缩放值
    - numCoins：飞行中的金币个数
    - duration：飞行时长
    - interval: 飞行时长开关
* 返回值：飞行时间
]]--
function HeaderFooterControl:flyChips( startPosition, earlierCoins, coins, parent, data)

    local header = User:getInstance().header

	parent = parent or header
    local diamonds_node = header:createHeaderDiamondNode(parent == header)
                              
    local diamondsPos = cc.p(0, 0)
	local delay = 3.5
    if libUI.isValidNode(diamonds_node.sp_diamond) and libUI.isValidNode(parent) and libUI.isValidNode(diamonds_node) then
        bole.playSounds("coins") -- 播放飞金币音乐

        diamondsPos = cc.p(diamonds_node.sp_diamond:getPosition())

        local startNode = parent:convertToNodeSpace(startPosition)
        local end_pos   = diamonds_node.sp_diamond:getParent():convertToWorldSpace(diamondsPos)
        local endNode   = parent:convertToNodeSpace(end_pos)
        local scale     = 0.55

        if parent ~= header then -- 飞金币之前的准备工作，如果是自身飞，则不用变换parent

            local pos = bole.toNodePos(parent, diamonds_node)
            diamonds_node:setPosition(pos)
            diamonds_node:setVisible(true)

            diamonds_node.start_parent = diamonds_node:getParent()

            local temp_scale = 1
            local temp_parent = parent
            for i = 1, 10 do
                if libUI.isValidNode(temp_parent) then
                    temp_scale  = temp_scale*temp_parent:getScaleX()
                    if temp_parent == bole.scene then
                        break
                    end
                    temp_parent = temp_parent:getParent()
                end
            end
            bole.changeParent(diamonds_node, parent)

            bole.setEnableRecursiveCascading(diamonds_node, true)
            diamonds_node:setOpacity(0)
            diamonds_node:runAction(cc.FadeTo:create(0.5, 255))
        else
            scale = 0.4
        end

        local function addChipsFlySpine(parent, index)
            self:addChipsFlySpine(parent, index)
        end

        self:addChipsStartSpine({parent = parent, pos = startNode, play = true, coins_ui = diamonds_node}) -- 开始的地方飞粒子
        local temp_end = endNode
        -- if ui.endWordP then
        --     temp_end = cc.p(endNode.x - 105, endNode.y)
        -- end
        delay = ANIMATE.bezierForNewCoins(parent, startNode, temp_end, 24, 0.8, nil, "commonEffect/newchips/theme" .. THEME_DESKTOP_ID .. "/%d.png",scale, 0.12, nil, addChipsFlySpine) + 0.2

        local function callfunc()

            if libUI.isValidNode(self) then
                self:playChipsFlyGet(false, diamonds_node) -- 结束的地方特效消失
            end

            if libUI.isValidNode(diamonds_node) and libUI.isValidNode(diamonds_node.start_parent) then
                diamonds_node:runAction(cc.Sequence:create(
                    cc.FadeTo:create(0.1, 0),
                    cc.CallFunc:create(function ()
                        if libUI.isValidNode(diamonds_node) and libUI.isValidNode(diamonds_node.start_parent) then
                            diamonds_node:setVisible(false)
                            diamonds_node:removeFromParent()
                            diamonds_node = nil
                        end
                    end)
                ))
            end
        end
        TimerCallFunc:getInstance():addCallFunc(callfunc, delay - 0.01) -- delay - 0.1秒以后，节点渐隐

        local function stopCoinsStartSpine() -- 最后一个金币飞完，开始地方的特效粒子消失
            if libUI.isValidNode(self) then
                self:addChipsStartSpine({coins_ui = diamonds_node})
            end
        end
        TimerCallFunc:getInstance():addCallFunc(stopCoinsStartSpine, delay - 0.8) 

        local function callfunc() -- 加金币操作，等第一个金币飞到金币栏，开始滚金币
            self:playChipsFlyGet(true, diamonds_node)
            coins = coins or 0
            header:setChipsScale(earlierCoins, earlierCoins + coins)
            if header.ui_diamonds then
                for k, ui in pairs(header.ui_diamonds) do
                    if ui and libUI.isValidNode(ui.label_diamonds)  then
                        if diamonds_node == ui then
                            ui.label_diamonds:nrStartRoll(earlierCoins, earlierCoins+coins, delay - 1) -- 滚动delay - 0.8秒                        
                        else
                            ui.label_diamonds:setString(self:formatCoin(earlierCoins + coins))
                        end
                    end
                end
            end
        end
        TimerCallFunc:getInstance():addCallFunc(callfunc, 0.8) -- 用timer是因为主题内会pause action，所以不能用action
	end

	return delay
end

-- 金币粒子效果
function HeaderFooterControl:addChipsFlySpine(parent, index)
    if libUI.isValidNode(parent) and index then
        local fly_particle  = getDiamondParticle("baoshilizi_1")
        if index%2 == 0 and fly_particle and cc.FileUtils:getInstance():isFileExist(fly_particle) then
            local temp_particle = cc.ParticleSystemQuad:create(fly_particle)
            parent:addChild(temp_particle)
        end
        local fly_particle2 = getDiamondParticle("bs_lz_01_1")
        if fly_particle2 and cc.FileUtils:getInstance():isFileExist(fly_particle2) then
            local temp_particle = cc.ParticleSystemQuad:create(fly_particle2)
            parent:addChild(temp_particle)
        end
    end
end

-- 金币飞行结束效果
function HeaderFooterControl:playChipsFlyGet(show, diamonds_node)

    local get_spine = getDiamondSpine("coins_fly_get")
    if libUI.isValidNode(diamonds_node.sp_diamond) and get_spine then
        if show then
            local pos  = cc.p(23.5,22.5)
            local _, s = bole.addSpineAnimation(diamonds_node.sp_diamond, nil, get_spine, pos, "animation", nil, nil, nil, false, false, nil)
            diamonds_node.spine_get = s
        else
            if libUI.isValidNode(diamonds_node.spine_get) then
                diamonds_node.spine_get:removeFromParent()
                diamonds_node.spine_get = nil
            end
        end
    end

end

-- 金币飞行开始效果
function HeaderFooterControl:addChipsStartSpine(data)
    local data      = data or {}
    local parent    = data.parent
    local pos       = data.pos or cc.p(0, 0)
    local play      = data.play
    local diamonds_node = data.coins_ui

    local start_spine =  getDiamondSpine("coins_fly_start")
    if start_spine then
        if libUI.isValidNode(diamonds_node.start_spine) and not play then
            diamonds_node.start_spine:runAction(cc.Sequence:create(
                cc.FadeTo:create(0.1, 0),
                cc.CallFunc:create(function ()
                    if libUI.isValidNode(diamonds_node.start_spine) then
                        diamonds_node.start_spine:removeFromParent()
                        diamonds_node.start_spine = nil
                    end
                end)
            ))

        elseif play and libUI.isValidNode(parent) then
            local _, s = bole.addSpineAnimation(parent, nil, start_spine, pos, "animation", nil, nil, nil, false, false, nil)
            diamonds_node.start_spine = s
        end
    end
end