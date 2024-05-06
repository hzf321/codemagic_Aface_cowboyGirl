

ThemeBaseWheelGame = class("ThemeBaseWheelGame")
local cls = ThemeBaseWheelGame

function cls:ctor( bonusParent, themeCtl, data, nodeList, callFunc )
	self.bonusParent 	= bonusParent
	self.themeCtl 		= themeCtl
	
    self.callback = callFunc

    self.audioCtl = self.themeCtl:getAudioCtl()
    self.gameConfig = self.themeCtl:getGameConfig()

	self.node = cc.Node:create()
	bole.scene:addToContentFooter(self.node)

    self.wheelData = data
    self.wheelGameConfig = self.wheelData.config
    self.cellSize = self.wheelGameConfig.cellSize
end

function cls:enterFeatureGame()
    self:onStartTrasitionCoverEvent()
    self:onStartTrasitionEndEvent( true )

end

function cls:onStartTrasitionCoverEvent(  )
    self:initAndShowWheelNode()
    self:createMiniReel(self.itemParent)
end

function cls:onStartTrasitionEndEvent( isClick )
    self:openWheelBtn(isClick) -- 默认直接滚动
end

function cls:initAndShowWheelNode( )

    --  添加 miniGame
    self.miniGame = cc.CSLoader:createNode(self.wheelData.csbPath)
    self.node:addChild(self.miniGame,2)

    local dimmer   = self.miniGame:getChildByName("common_black")
    dimmer:setOpacity(150)

    local rootNode   = self.miniGame:getChildByName("root")
    local panel = rootNode:getChildByName("panel")
    self.itemParent  = panel:getChildByName("item_list")

    self.startBtn = rootNode:getChildByName("btn_start")

    self.items= {}
    for _, item in pairs(self.itemParent:getChildren()) do 
        item.sp = item:getChildByName("sp")
        item.bg = item:getChildByName("bg")
        item.lb = item:getChildByName("lb")
        item.spine = item:getChildByName("spine")
        table.insert(self.items, item) -- key 和相应的 item 从0 开始
    end

    self:addMiniReelIdleAnim()
end

function cls:createMiniReel( )

    ---------- 滚轴数据
    local height = self.cellSize.h
    local width  = self.cellSize.w

    local data= {
        ["reelIcons"]      = {self.items},
        ["colCount"]       = 1,-- 列
        ["keylist"]        = {self.wheelData.result},
        ["cellSize"]       = {cc.p(width,height)},
        ["startIndex"]     = {math.random(1, #self.wheelData.wheelReel)}, -- , -- 随机的是 index 格子的 而不是 key
        ["rowCountList"]   = {self.wheelGameConfig.cnt},-- 行的 itemCount 上下加一个 cell 之后的个数
        ["delayBeforeSpin"] = 0.0,   --开始旋转前的时间延迟
        ["upBounce"]        = 0,    --开始滚动前，向上滚动距离
        ["upBounceTime"]    = 0,   --开始滚动前，向上滚动时间
        ["speedUpTime"]     = 0.5,   --加速时间
        ["rotateTime"]      = 2.0,   -- 匀速转动的时间之和
        ["maxSpeed"]        = 1/6*height*60,    --每一秒滚动的距离
        ["downBounce"]      = 0,  --滚动结束前，向下反弹距离  都为正数值
        ["speedDownTime"]   = 4, -- 4
        ["downBounceTime"]  = 0,
        
        ["direction"]       = 2,
        ["rollReelList"]    = {self.wheelData.wheelReel},
        ["reelBasePos"]     = {cc.p(0,0)},
        ["rollCount"]       = 1,  -- 结束的时候转动的圈数
        ["deltaType"]       = 2,
    }

    local callFunc = function ( delay )
        self:onMiniReelStop(delay)
    end
    self.miniReel = BaseReelWithSprite.new(self, data,callFunc)
end

function cls:addMiniReelIdleAnim( ... )

end


function cls:openWheelBtn( isClick )

    local clickEndFunc = function ( ... )
        if bole.isValidNode(self.startBtn) then 
            self.startBtn:setTouchEnabled(false)
            self.startBtn:setBright(false)
            self.startBtn:runAction(cc.FadeOut:create(0.3))
        end

        if self.bonusParent and self.bonusParent.saveDataByType then 
            self.bonusParent:saveDataByType("reelStart")
        end

        -- 开始调用滚动
        self.miniReel:startSpin()
        -- 播放滚动音效 
        

        self.themeCtl:playMusicByName("wheel_roll")

        self.audioCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3)

        self:addWheelRollAnim()
    end

    if isClick then 
        clickEndFunc()
    else

        if bole.isValidNode( self.startBtn ) then 
            local clickEvent = function ( obj, eventType )
                if eventType == ccui.TouchEventType.ended then 
                    self.themeCtl:playMusicByName("wheel_click")
                    clickEndFunc()
                end
            end
            self.startBtn:addTouchEventListener(clickEvent)
        else
            clickEndFunc()
        end
    end
end

function cls:onMiniReelStop( delay )

    self:clearWheelRollAnim()

    self.node:runAction(cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function ( ... )
            if self.bonusParent and self.bonusParent.saveDataByOverWheel then 
                self.bonusParent:saveDataByOverWheel()
            end
            
            self:showWinWheelResultAnim()
        end),
        cc.DelayTime:create(2),
        cc.CallFunc:create(function ( ... )
            self:onOverWheelGame()
        end)
    ))
end


function cls:addWheelRollAnim( ... )
	
end

function cls:clearWheelRollAnim( ... )
	
end

function cls:showWinWheelResultAnim( ... )

end

function cls:onOverWheelGame( )

    self:closeWheelNode()
    
end

function cls:closeWheelNode( ... )
    self.miniGame:runAction(cc.Sequence:create(
        cc.FadeOut:create(0.3),
        cc.CallFunc:create(function()
            if self.callback then 
                self.callback()
            end
        end),
        cc.RemoveSelf:create()
    ))
end

function cls:onExit( ... )
    if self.miniReel then 
        if self.miniReel.scheduler then 
            local scheduler = cc.Director:getInstance():getScheduler()
            scheduler:unscheduleScriptEntry(self.miniReel.scheduler)
            self.miniReel.scheduler = nil
        end
    end
end

function cls:updateReelItem( cell,value ) -- 参考，如果需要动态更改 资源则需要参考实现重写方法
    -- local _wheelConfig = self.wheelGameConfig
    -- local itemConfig =  _wheelConfig.itemFile[value]
    -- if bole.isValidNode(cell:getChildByName("bg")) and itemConfig["bg"] then 
    --     bole.updateSpriteWithFile(cell:getChildByName("bg"), itemConfig["bg"])
    -- end

    -- local sp = cell:getChildByName("sp")
    -- if bole.isValidNode(sp) then 
    --     if itemConfig["sp"] then 
    --         bole.updateSpriteWithFile(cell:getChildByName("sp"), itemConfig["sp"])
    --         sp:setVisible(true)
    --     else
    --         sp:setVisible(false)
    --     end
    -- end

    -- local lb = cell:getChildByName("lb")
    -- if bole.isValidNode(lb) then 
    --     if itemConfig["lb"] then 
    --         lb:setFntFile(self.themeCtl:getPic(itemConfig["lb"]))
    --     end

    --     local str = ""
    --     if _wheelConfig.multiValue[value] then 
    --         str = FONTS.formatByCount4(_wheelConfig.multiValue[value] * self.curBaseBet, 7, true)
    --     end
    --     lb:setString(str)
    --     if itemConfig.lbscale then 
    --         lb:setScale(itemConfig.lbscale)
    --     end

    -- end
end

