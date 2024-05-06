

local ThemeBaseWheelView = class("ThemeBaseWheelView")
local cls = ThemeBaseWheelView

function cls:ctor( vCtl, nodeList, data ) -- bonusParent, themeCtl, data, nodeList, callFunc
	self.vCtl 	= vCtl

	self.node = cc.Node:create()
	bole.scene:addToContentFooter(self.node)

    self.wheelData = data
    self.wheelCfg = self.wheelData.config
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
    local data = tool.tableClone(self.wheelCfg.roll_data)
    data.reelIcons  = {self.items}
    data.keylist    = {self.wheelData.result}
    data.startIndex = {math.random(1, #self.wheelCfg.wheel_reel)} -- self.wheelData.beginPos or 

    local callFunc = function ( delay )
        self:onMiniReelShowResult(delay)
    end
    
    self.miniReel = BaseReelWithSprite.new(self, data,callFunc)
end

function cls:addMiniReelIdleAnim( ... )

end

function cls:openWheelBtn( isClick )

    local clickEndFunc = function ( ... )
        self.vCtl:onMiniReelRoll()

        -- 开始调用滚动
        self.miniReel:startSpin()

        self:addWheelRollAnim()
    end

    if isClick then 
        clickEndFunc()
    else

        if bole.isValidNode( self.startBtn ) then 
            local clickEvent = function ( obj, eventType )
                if eventType == ccui.TouchEventType.ended then 
                    self.vCtl:playWheelClickMusic()
            
                    if bole.isValidNode(self.startBtn) then 
                        self.startBtn:setTouchEnabled(false)
                        self.startBtn:setBright(false)
                        self.startBtn:runAction(cc.FadeOut:create(0.3))
                    end

                    clickEndFunc()
                end
            end
            self.startBtn:addTouchEventListener(clickEvent)
        else
            clickEndFunc()
        end
    end
end

function cls:onMiniReelShowResult( delay )

    self:clearWheelRollAnim()

    self.node:runAction(cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function ( ... )
            self.vCtl:onMiniReelStop()
            
            self:showWinWheelResultAnim()
        end),
        cc.DelayTime:create(self.wheelCfg.win_anim_time),
        cc.CallFunc:create(function ( ... )
            self.vCtl:onOverWheelGame()
        end)
    ))
end


function cls:addWheelRollAnim( ... )
	
end

function cls:clearWheelRollAnim( ... )
	
end

function cls:showWinWheelResultAnim( ... )

end

function cls:clearWheelWinAnim( ... )

end

function cls:closeWheelNode( ... )
    self:clearWheelWinAnim()
    
    self.miniGame:runAction(cc.Sequence:create(
        cc.FadeOut:create(0.3),
        cc.CallFunc:create(function()
            self.vCtl:finshCallBack()
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
        self.miniReel = nil
    end
end

function cls:updateReelItem( cell,value ) -- 参考，如果需要动态更改 资源则需要参考实现重写方法
    -- local _wheelConfig = self.wheelCfg
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

return ThemeBaseWheelView
