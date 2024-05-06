JackpotWheel = class("JackpotWheel", CCSNode)

local picpath = "jackpot/"

function JackpotWheel:ctor (ctl, data)
    self.ctl = ctl
    self.data = data
    bole.stopMusic()

    -- mockup datas
    self.data = {}
    self.data.index = 3
    self.data.jackpot = "mega"
    self.data.value = nil
    self.data.data_list = {}
    self.data.data_list.wheel1 = {}
    self.data.data_list.wheel2 = {}
    self.data.data_list.wheel3 = {}
    self.data.jackpot_index = 5
    self.data.jackpot_list = { 1333000, 1888000, 6000000, 7000000, 88000000}

    self.super.ctor(self, picpath.."jackpot_wheel.csb")

    self:initDatas()
end

function JackpotWheel:loadControls()
    self.root   = self.node:getChildByName("root")
    self.panel_wheel = self.root:getChildByName("panel_wheel")
    self.statusbar   = self.root:getChildByName("statusbar")
    -- 屏幕适配 iPad
    local screenSize = bole.getSceneSize()
    if PAD_TAG then
        self.root:setPosition(cc.p(screenSize.height * 0.5, screenSize * 0.5))
    end
    self.pointer   = self.root:getChildByName("wheel_top_1")

    -- 是否设置初始旋转角度
    -- self.pointer:setRotation(-10)
    -- remember to remove
    self.pointer:setScaleY(0.87)

    self.guidehand = self.root:getChildByName("icon_hand")
    self.guidehand:setVisible(false)

    self.title_getready = self.root:getChildByName("title_1")
    self.title_getready:setOpacity(0)
    self.title_goodluck = self.root:getChildByName("title_2")
    self.title_goodluck:setOpacity(0)

    self.wheel1 = self.panel_wheel:getChildByName("wheel_1")
    self.wheel1:setRotation(6)
    self.wheel2 = self.panel_wheel:getChildByName("wheel_2")
    self.wheel2:setRotation(3)
    self.wheel3 = self.panel_wheel:getChildByName("wheel_3")
    self.wheel3:setRotation(12)

    self.wheel1_shadow = self.panel_wheel:getChildByName("wheel_shadow_1")
    self.wheel2_shadow = self.panel_wheel:getChildByName("wheel_shadow_2")

    self.wheel_margin = self.panel_wheel:getChildByName("bg_wheel_1")
    self.wheel_icon = self.panel_wheel:getChildByName("icon_turntable")
end

-- 配置整理 JackpotWheel 的子节点
function JackpotWheel:initDatas()
    -- Configure statusbar data
    local titles = {'minor', 'major', 'super', 'grand', 'mega'}
    self.jackpots = {}
    for k,v in ipairs(titles) do
        table.insert(self.jackpots, self.statusbar:getChildByName("root"):getChildByName('label_' .. v))
    end
    self.jackpot_titles = {}
    for k,v in ipairs(titles) do
        table.insert(self.jackpot_titles, self.statusbar:getChildByName("root"):getChildByName('title_' .. v))
    end
    for i = 1, self.data.jackpot_index do
        self.jackpots[i]:setString(FONTS.format(self.data.jackpot_list[i], true))
    end
    for i = self.data.jackpot_index + 1, 5 do
        self.jackpot_titles[i]:setColor(cc.c3b(120,120,120))
    end

    self.wheel_index = 1
    -- Wheel1
    self.wheel1_key_list = {}
    self.wheel1_key_angle_list = {}
    self.wheel1_val_list = {}
    self.wheel1_val_angle_list = {}
    for i = 1, 10 do
        table.insert(self.wheel1_key_list, self.wheel1:getChildByName("root"):getChildByName("icon_jackpot_key_"..i))
    end
    for i = 1, 20 do
        table.insert(self.wheel1_val_list, self.wheel1:getChildByName("root"):getChildByName("BitmapFontLabel_"..i))
    end

    -- Wheel2
    self.wheel2_key_list = {}
    self.wheel2_key_fans_list = {3, 8, 12, 18}
    self.wheel2_minor_list = {}
    self.wheel2_minor_angle_list = {}
    self.wheel2_val_list = {}
    self.wheel2_val_angle_list = {}
    for i = 1, 4 do
        table.insert(self.wheel2_key_list, self.wheel2:getChildByName("root"):getChildByName("icon_jackpot_key_"..i))
    end
    for i = 1, 4 do
        table.insert(self.wheel2_minor_list, self.wheel2:getChildByName("root"):getChildByName("icon_jackpot_minor_"..i))
    end
    for i = 1, 12 do
        table.insert(self.wheel2_val_list, self.wheel2:getChildByName("root"):getChildByName("BitmapFontLabel_"..i))
    end

    -- Wheel3
    self.wheel3_val_list = {}
    self.wheel3_val_angle_list = {}
    self.wheel3_jackpot_fans_map = {}
    for i = 1, 11 do
        table.insert(self.wheel3_val_list, self.wheel3:getChildByName("root"):getChildByName("BitmapFontLabel_"..i))
    end

    self.wheel3_jackpot_fans_map["major"] = 14
    self.wheel3_jackpot_fans_map["super"] = 11
    self.wheel3_jackpot_fans_map["grand"] = 8
    self.wheel3_jackpot_fans_map["mega"]  = 3

    -- Fake to be spining, so can ignore the touch
    self.spining = true

    -- 转盘扇叶列表和转盘列表
    -- 4, 6, 8
    self.fans_list  = {30, 20, 15}
    self.wheel_list = {self.wheel1, self.wheel2, self.wheel3}

    self.wheel_margin:setVisible(false)
    local wheel        = self.wheel_list[self.wheel_index]
    local wheel_margin = cc.Sprite:createWithTexture(self.wheel_margin:getTexture())
    wheel:addChild(wheel_margin)
end

function JackpotWheel:show()
    bole.scene:addChild(self)
    -- show spin tips
    local function spinHand( ... )
        self.spining = false -- touch to make spin take effect
        self.guidehand:setVisible(true)
        self.guidehand:setPosition(self.guidehand:getPositionX() + 20 + 60, self.guidehand:getPositionY() - 40)
        self.guidehand:runAction(cc.RepeatForever:create(
                            cc.Sequence:create(
                                cc.MoveBy:create(0.5, cc.p(-60, 0)),
                                cc.DelayTime:create(1),
                                cc.MoveBy:create(0.5, cc.p(60, 0)),
                                cc.DelayTime:create(0.1)
                            )))
    end
    -- show the good luck title
    local function goodLuck( ... )
        local action = cc.Sequence:create(cc.FadeIn:create(0.15),
                    cc.FadeOut:create(0.75),
                    cc.CallFunc:create(spinHand))
        self.title_goodluck:runAction(action)
    end
    -- show the get ready title
    local function getReady( ... )
        local action = cc.Sequence:create(cc.FadeIn:create(0.3),
                            cc.ScaleTo:create(0.2, 0.5),
                            cc.ScaleTo:create(0.2, 1.5),
                            cc.ScaleTo:create(0.2, 1),
                            cc.FadeOut:create(0.3),
                            cc.CallFunc:create(goodLuck))
        self.title_getready:runAction(action)
    end
    self:runAction(cc.CallFunc:create(getReady))
end

-- fans to be spinned
function JackpotWheel:getSpinFans()
    if self.wheel_index == 1 then
        if self.data.index > 1 then
            return 1 + 3 * math.random(0, 9)
        end
    elseif self.wheel_index == 2 then
        if self.data.index > 2 then
            return self.wheel2_key_fans_list[math.random(1, #self.wheel2_key_fans_list)]
        end
    else
        if self.data.jackpot == "mega" then
            return self.wheel3_jackpot_fans_map[self.data.jackpot]
        end
    end
end

function JackpotWheel:spin()

    self.guidehand:cleanup()
    self.guidehand:runAction(cc.Sequence:create(cc.FadeOut:create(0.2), cc.Hide:create()))

    self.spining = true

    -- 转轴旋转一周所需要的时间
    local duration    = 4.5

    local fans = self.fans_list[self.wheel_index]
    local fan_angle = 360 / fans

    local pointer = self.pointer
    local wheel   = self.wheel_list[self.wheel_index]

    --指针 tick 时候旋转的角度
    local pointerAngle = -26

    local littlefans  =  fans * 3
    local littleFanAngle = fan_angle / 3
    local littleFanTime  = duration / littlefans

    -- divide the spins into startup spins and slowdown spins
    local rotatefans = 1 * fans + self:getSpinFans()
    local rotateLittlefans = rotatefans * 3
    local startup_littlefans = math.ceil(rotateLittlefans * 0.87)
    local slowdown_littlefans = rotateLittlefans - startup_littlefans

    local function finish_spin()
        -- set spining state to false to enable spin
        local function enableSpinning()
            self.spining = false
        end
        if true and self.wheel_index < self.data.index then
            if self.wheel_index == 1 then
                self.wheel1:setVisible(false)
                self.wheel2:runAction(cc.ScaleTo:create(0.6, 1))
                self.wheel3:runAction(cc.ScaleTo:create(0.6, 0.66))

                -- 解决轮盘放大后, 阴影被覆盖的问题
                self.wheel1_shadow:setLocalZOrder(10)
                self.wheel1_shadow:setOpacity(0)
                self.wheel1_shadow:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.FadeIn:create(0.1), cc.CallFunc:create(enableSpinning)))
                self.wheel3:setLocalZOrder(11)
                self.wheel_icon:setLocalZOrder(12)

                self.wheel_index = 2
            elseif self.wheel_index == 2 then
                self.wheel2:setVisible(false)
                self.wheel3:runAction(cc.Sequence:create(cc.ScaleTo:create(1, 1), cc.CallFunc:create(enableSpinning)))

                self.wheel_index = 3
            end

            -- 给新的转轮添加齿轮边框
            wheel = self.wheel_list[self.wheel_index]
            local wheel_margin = nil
            if self.wheel_index == 2 then
                local wheel_margin_texture = "jackpot/bg_wheel_1_2.png"
                wheel_margin = cc.Sprite:create(wheel_margin_texture)
            elseif self.wheel_index == 3 then
                local wheel_margin_texture = "jackpot/bg_wheel_1_3.png"
                wheel_margin = cc.Sprite:create(wheel_margin_texture)
                wheel_margin:setRotation(12)
            end

            wheel:addChild(wheel_margin)
        else
            self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                self:removeFromParent()
            end)))
        end
    end

    local function slowdown_spins()
        local function tick()
            pointer:cleanup()
            pointer:setRotation(0)
            local action = cc.Sequence:create(cc.CallFunc:create(function () bole.playMusic("wheel/wheel_tick") end),
                cc.RotateTo:create(0.225, pointerAngle), cc.RotateTo:create(0.05, 0))
            pointer:runAction(action)
        end
        wheel:cleanup()
        pointer:cleanup()
        local actions = {}
        local lastlittlefansTime
        for i = 1, slowdown_littlefans * 2 do
            local j = 1 + i * 0.2
            lastlittlefansTime = littleFanTime * j
            local isFirstHalf = i % 2 == 1
            local partRatio = isFirstHalf and 0.5 or 1 - 0.5 -- part before touch pointer, time is shorter
            table.insert(actions, cc.RotateBy:create(lastlittlefansTime * partRatio, littleFanAngle * partRatio))

            if isFirstHalf then
                table.insert(actions, cc.CallFunc:create(tick))
            end
        end

        --The random part of spin
        local function last_tick()
            pointer:cleanup()
            pointer:setRotation(0)
            local action = cc.Sequence:create(cc.CallFunc:create(function () bole.playMusic("wheel/wheel_tick") end),
                cc.RotateTo:create(0.25, pointerAngle * 0.3), cc.RotateTo:create(0.3, 0))
            pointer:runAction(action)
        end
        local extra = math.random(0, 99) < 81 or true
        if extra then
            table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.5 * 2, littleFanAngle * 0.55))
            table.insert(actions, cc.CallFunc:create(last_tick))
            -- random 限定在 0.1~0.8 之前
            local random = math.random()
            if random < 0.2 then
                random = random + 0.2
            elseif random > 0.8 then
                random = random - 0.2
            end
            table.insert(actions, cc.RotateBy:create(lastlittlefansTime * random * 4, -littleFanAngle * random))
            -- table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.5, littleFanAngle*0.5))
            -- table.insert(actions, cc.CallFunc:create(tickLast))
            -- table.insert(actions, cc.RotateBy:create(lastlittlefansTime, littleFanAngle))
            -- table.insert(actions, cc.CallFunc:create(tickLast))
            -- table.insert(actions, cc.RotateBy:create(lastlittlefansTime, -littleFanAngle))
            -- table.insert(actions, cc.CallFunc:create(tickLast2))
            -- table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.5, -littleFanAngle*0.5))
        end

        table.insert(actions, cc.DelayTime:create(1.5))
        table.insert(actions, cc.CallFunc:create(finish_spin))

        local action = cc.Sequence:create(actions)
        wheel:runAction(action)
    end

    local function startup_spins()
        local function tick()
            pointer:cleanup()
            pointer:setRotation(pointerAngle * 0.75)
            local action = cc.Sequence:create(cc.CallFunc:create(function () bole.playMusic("wheel/wheel_tick") end),
                            cc.RotateTo:create(0.225, pointerAngle * 1.2), cc.RotateTo:create(0.1, pointerAngle * 0))
            pointer:runAction(action)
        end
        wheel:cleanup()
        pointer:cleanup()
        local actions = {}
        for i = 1, startup_littlefans * 2 do
            local isFirstHalf = i % 2 == 1
            table.insert(actions, cc.RotateBy:create(littleFanTime * 0.5, littleFanAngle * 0.5))
            if isFirstHalf then
                table.insert(actions, cc.CallFunc:create(tick))
            end
        end
        table.insert(actions, cc.CallFunc:create(slowdown_spins))
        wheel:runAction(cc.Sequence:create(actions))
    end
    -- spin starts
    startup_spins()
end

function JackpotWheel:addCCSNodeEventListener()
    local function containsPoint( touch, event )
        local target = event:getCurrentTarget()
        log.i("name: ", target:getName())
        local location = touch:getLocation()
        local locationInNode = target:convertToNodeSpace(location)
        local s = target:getContentSize()
        local rect = cc.rect(0,0,s.width*target:getScaleX(),s.height*target:getScaleY())
        return cc.rectContainsPoint(rect, locationInNode)
    end
    local function onTouchBegan(touch, event)
        if not containsPoint(touch, event) then
            return false
        end
        return true
    end
    local function onTouchEnded(touch, event)
        if not self.spining then
            self:spin()
        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self.panel_wheel:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.panel_wheel)
    self.nodeEventListener = listener
end

function JackpotWheel:hide()
    self:removeFromParent()
end
