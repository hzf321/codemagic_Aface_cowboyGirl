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

    -- 整理相关数据
    self:initDatas()
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
    self.wheel2_key_angle_list = {54}
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
    self.wheel3_jackpot_angle_map = {}
    for i = 1, 11 do
        table.insert(self.wheel3_val_list, self.wheel3:getChildByName("root"):getChildByName("BitmapFontLabel_"..i))
    end

    self.wheel3_jackpot_angle_map["major"] = 354
    self.wheel3_jackpot_angle_map["super"] = 276
    self.wheel3_jackpot_angle_map["grand"] = 204
    self.wheel3_jackpot_angle_map["mega"]  = 72

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
                    -- cc.ScaleTo:create(0.2, 0.5),
                    -- cc.ScaleTo:create(0.2, 1.5),
                    -- cc.ScaleTo:create(0.2, 1),
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

-- return total angle to spin based on self.data
function JackpotWheel:getDestinedAngle()
    if self.wheel_index == 1 then
        if self.data.index > 1 then
            return (1 + 3 * math.random(0, 9)) * 360 / self.fans_list[self.wheel_index]
        end
    elseif self.wheel_index == 2 then
        if self.data.index > 2 then
            return self.wheel2_key_angle_list[math.random(1, #self.wheel2_key_angle_list)]
        end
    else
        if self.data.jackpot == "mega" then
            return self.wheel3_jackpot_angle_map[self.data.jackpot]
        end
    end
end

function JackpotWheel:spin()
    -- hide the guidehand
    self.guidehand:cleanup()
    self.guidehand:runAction(cc.Sequence:create(cc.FadeOut:create(0.2), cc.Hide:create()))

    self.spining = true

    -- 转轴旋转一周所需要的时间
    local duration    = 3.6

    -- 此次 spins 的转盘扇数和角度,注意每个 fan 也可以分为三个 little_fan
    local fans = self.fans_list[self.wheel_index]
    local fan_angle = 360 / fans

    local singleTime  = duration / fans
    local rotateAngle = 360 * 2 + self:getDestinedAngle() -- 此次旋转的总角度

    local wheel       = self.wheel_list[self.wheel_index]
    local pointer     = self.pointer

    --指针 tick 时候旋转的角度
    local pointerAngle = -24

    local littleFanAngle = fan_angle / 3
    local littleFanTime  = duration / (fans * 3)

    -- 最后几次 spin 经历过的little fan
    local littlefans_times = 3 * 3

    -- 完成 Spin 之后
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
            --A utility to exit the Jackpot Game
            self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                self:removeFromParent()
            end)))
        end
    end

    -- 实现指针旋转和音效效果
    local function tick()
        pointer:cleanup()
        pointer:setRotation(0)
        local action = cc.Sequence:create(cc.CallFunc:create(function () bole.playMusic("wheel/wheel_tick") end),
                        cc.RotateTo:create(0.35, pointerAngle), cc.RotateTo:create(0.15, 0))
        pointer:runAction(action)
    end

    -- spin 中指针的最后几次 spin, mock转半圈180度15个fan
    local function last_spins()
        -- 最后几次tick回转的角度, 实现减速过程中指针 tick 的音效效果
        -- local function tick()
        --     pointer:cleanup()
        --     pointer:setRotation(0)
        --     local action = cc.Sequence:create(cc.CallFunc:create(function () bole.playMusic("wheel/wheel_tick") end),
        --                     cc.RotateTo:create(0.14, pointerAngle), cc.RotateTo:create(0.07, 0))
        --     pointer:runAction(action)
        -- end

        local function tickLast (...)
            self.pointer:cleanup()
            self.pointer:setRotation(0)
            local action = cc.Sequence:create(cc.RotateTo:create(0.2, -20), cc.RotateTo:create(0.1, 0))
            self.pointer:runAction(action)
        end

        -- 指针相反角度旋转
        local function tickLast2(...)
            self.pointer:cleanup()
            self.pointer:setRotation(0)
            local action = cc.Sequence:create(cc.RotateTo:create(0.3, 20), cc.RotateTo:create(0.15, 0))
            self.pointer:runAction(action)
        end

        wheel:cleanup()
        -- wheel:setRotation(rotateAngle - 180)
        pointer:cleanup()

        local actions = {}
        local lastlittlefansTime
        for i = 1, littlefans_times * 2 do
            local j = i + 1
            lastlittlefansTime = littleFanTime * j
            local isFirstHalf = i % 2 == 1
            local partRatio = isFirstHalf and 0.5 or 1 - 0.5 -- part before touch pointer, time is shorter
            table.insert(actions, cc.RotateBy:create(lastlittlefansTime * partRatio, littleFanAngle * partRatio))

            if isFirstHalf then
                table.insert(actions, cc.CallFunc:create(tick))
            end
        end

        -- TODO
        -- 轮盘最后转动的一下,用来制作随机效果
        -- local extra = (math.random(0, 99) < 100) and self.wheel_index ~=2
        -- if extra then
        --     -- the first wheel
        --     if self.wheel_index == 1 then
        --         local extraRatio = 0.7
        --         table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.5, littleFanAngle*0.5))
        --         table.insert(actions, cc.CallFunc:create(tickLast))
        --         table.insert(actions, cc.RotateBy:create(lastlittlefansTime, littleFanAngle))
        --         -- table.insert(actions, cc.CallFunc:create(tickLast))
        --         table.insert(actions, cc.RotateBy:create(lastlittlefansTime, -littleFanAngle))
        --         table.insert(actions, cc.CallFunc:create(tickLast2))
        --         table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.5, -littleFanAngle*0.5))
        --     elseif self.wheel_index == 3 then
        --         table.insert(actions, cc.CallFunc:create(tickLast))
        --         table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.2 * 2,  fan_angle * 0.2))
        --         table.insert(actions, cc.RotateBy:create(lastlittlefansTime * 0.2 * 2, -fan_angle * 0.2))
        --     end
        -- end

        table.insert(actions, cc.DelayTime:create(1.5))
        table.insert(actions, cc.CallFunc:create(finish_spin))

        local action = cc.Sequence:create(actions)
        wheel:runAction(action)
    end

    -- The pointer in start velocity
    -- local function start_pointer()
    --     local action = cc.Sequence:create(cc.RotateTo:create(0.01, 1.3 * pointerAngle), cc.RotateTo:create(0.005, pointerAngle * 1), cc.CallFunc:create(function()
    --         bole.playMusic("wheel/wheel_tick")
    --     end))
    --     pointer:runAction(cc.RepeatForever:create(action))
    -- end

    -- The pointer in uniform velocity
    local function uniform_pointer( ... )
        pointer:cleanup()
        local action = cc.Sequence:create(cc.RotateTo:create(littleFanTime * 0.45, 1.2 * pointerAngle), cc.RotateTo:create(littleFanTime * 0.55, pointerAngle * 0.8), cc.CallFunc:create(function()
            bole.playMusic("wheel/wheel_tick")
        end))
        pointer:runAction(cc.RepeatForever:create(action))
    end

    -- The pointer in slow speed
    local function slowdown_pointer()
        pointer:cleanup()
        local action = cc.Sequence:create(cc.CallFunc:create(function() bole.playMusic("wheel/wheel_tick") end), cc.RotateTo:create(littleFanTime * 2 * 0.45, 1.2 * pointerAngle),
                                            cc.RotateTo:create(littleFanTime * 2 * 0.55, pointerAngle * 0.8))
        action = cc.RepeatForever:create(action)
        pointer:runAction(action)
    end

    -- 使用 RotateTo 和 RotateBy 来模拟轮盘转动
    local actions = {}
    -- 加速Spin 前4个fan(4*3littlefan)
    -- table.insert(actions, cc.RotateBy:create(singleTime * 4, fan_angle))
    -- table.insert(actions, cc.RotateBy:create(singleTime * 3, fan_angle))
    -- table.insert(actions, cc.RotateBy:create(singleTime * 2, fan_angle))
    -- table.insert(actions, cc.RotateBy:create(singleTime * 1, fan_angle))

    -- 开始Spin阶段旋转的扇叶数目
    local startspin_fans = 0
    for i = 1, startspin_fans do
        local startLittleFanTime = littleFanTime * (5 - i)
        local function tick()
            pointer:cleanup()
            pointer:setRotation(0)
            local action = cc.Sequence:create(cc.CallFunc:create(function () bole.playMusic("wheel/wheel_tick") end),
                        cc.RotateTo:create(startLittleFanTime * 0.35, pointerAngle), cc.RotateTo:create(startLittleFanTime * 0.2, pointerAngle * 0.7))
            pointer:runAction(action)
        end
        table.insert(actions, cc.CallFunc:create(tick))
        table.insert(actions, cc.RotateBy:create(startLittleFanTime, littleFanAngle))
    end

    -- 匀速Spin
    table.insert(actions, cc.CallFunc:create(uniform_pointer))
    table.insert(actions, cc.RotateBy:create(duration / 360 * (rotateAngle - 360 - startspin_fans * littleFanAngle), rotateAngle - 360 - startspin_fans * littleFanAngle))

    -- 减速Spin
    table.insert(actions, cc.CallFunc:create(slowdown_pointer))
    table.insert(actions, cc.RotateBy:create(duration / 360 * 90 * 1.2, 90))
    table.insert(actions, cc.RotateBy:create(duration / 360 * 90 * 1.5, 90))
    table.insert(actions, cc.RotateBy:create(duration / 360 * 60 * 1.8, 60))

    -- table.insert(actions, cc.RotateBy:create(duration / 6 * 2.0, 60))
    if self.wheel_index ~= 3 then
        table.insert(actions, cc.RotateBy:create(duration / 360 * 30 * 1.9, 30))
        if self.wheel_index == 1 then
            table.insert(actions, cc.RotateBy:create(duration / 360 * 30 * 2.0, 30))
        end
    end

    table.insert(actions, cc.CallFunc:create(last_spins))
    wheel:runAction(cc.Sequence:create(actions))
end

function JackpotWheel:addCCSNodeEventListener( ... )
    -- 用来确定点击生效的位置, 用来对点击进行精确判断
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
