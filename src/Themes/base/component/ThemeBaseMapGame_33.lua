ThemeBaseMapGame_33 = class("ThemeBaseMapGame_33", CCSNode)
local MapGame = ThemeBaseMapGame_33

function MapGame:ctor(vCtl, csbPath, data, mapConfig) -- vCtl 可以传进来相应的 control
    self.vCtl = vCtl
    self.csbPath = csbPath
    self.csb = csbPath .. "map.csb"
    self.data = data
    self.mapConfig = mapConfig
    
    self.mapLevel = data.mapLevel
    if data.mapPoints >= self.mapConfig.maxMapPoints and self.mapLevel == 0 then
        self.mapLevel = self.mapConfig.maxMapLevel
    end

    CCSNode.ctor(self, self.csb)
end

function MapGame:loadControls()
    self.dimmer = self.node:getChildByName("dimmer_node")
    self.dimmer:setVisible(false)

    self.root = self.node:getChildByName("root")
    self.root_child = self.root:getChildByName("root_child")
    local mapPanel = self.root_child:getChildByName("bg_panel")
    mapPanel:setScrollBarEnabled(false)
    self.mapContainerNode = mapPanel
    local tempNumber = 1000 * (1 - FRAME_WIDTH / DESIGN_WIDTH)
    self.mapContainerNode:setContentSize(cc.size(self.mapContainerNode:getContentSize().width, self.mapContainerNode:getContentSize().height - tempNumber))

    self.mapBG = mapPanel:getChildByName("map_bg")
    self.mapNode = mapPanel:getChildByName("map_node")
    self.mapBaseNpde = self.mapNode:getChildByName("base_node")

    self.mapTopNode = self.root_child:getChildByName("kuang_node")

    self.buttonNode = self.root_child:getChildByName("btn_node")
    self.btn_back = self.buttonNode:getChildByName("btn")
    self.buttonNode:setScale(0)
    self.buttonNode:setVisible(false)

    self.mapSpineNode = self.mapNode:getChildByName("spine_node")
    local _, usp = bole.addSpineAnimation(self.mapSpineNode, nil, self.vCtl:getPic(self.mapConfig.mapSpineConfig["map_user"]), cc.p(0, 0), "animation1", nil, nil, nil, true, true)
    self.userIcon = usp

    self.stepList = {}

    local big_index = 1

    for i = 1, self.mapConfig.maxMapLevel do
        self.stepList[i] = {}
        if self.mapConfig.buildingLevel[i] then
            self.stepList[i].node = bole.deepFind(self.mapBaseNpde, "step_" .. i .. "_big")

            local aniNode = cc.Node:create()
            self.stepList[i].node:addChild(aniNode)
            self.stepList[i].aniNode = aniNode
            local ani = self.mapConfig.mapBigAnim.loop
            local _, s = bole.addSpineAnimation(aniNode, nil, self.vCtl:getPic(self.mapConfig.mapSpineConfig["map_big"..big_index]), cc.p(0, 0), ani, nil, nil, nil, true, true)
            self.stepList[i].aniSpine = s
            s.index = big_index

            big_index = big_index + 1
        else
            self.stepList[i].node = bole.deepFind(self.mapBaseNpde, "step_" .. i)
            self.stepList[i].dim = self.stepList[i].node:getChildByName("dim")
            local ani_node = cc.Node:create()
            self.stepList[i].node:addChild(ani_node)
            self.stepList[i].aniNode = ani_node

            self:addSmallNodeAnim(i)
        end
    end
end

function MapGame:getContainerPosY(step_index)
    local step_index = step_index or 1
    local offset = 0

    local baseBuildNodePos = self.mapConfig.baseBuildePosY or 0
    local addExtraBig = self.mapConfig.addBigY or 0
    local posYInContainerScale = self.mapConfig.posYInContainerScale or 1/2 -- 人物头像在地图的位置，从下算的比例

    if self.stepList[step_index] and bole.isValidNode(self.stepList[step_index].node) then
        local sizex = self.mapContainerNode:getContentSize().height - self.mapContainerNode:getInnerContainerSize().height
        offset = self.mapContainerNode:getContentSize().height * posYInContainerScale - (self.stepList[step_index].node:getPositionY() + baseBuildNodePos)
        if self.mapConfig.buildingLevel[step_index] then 
            offset = offset - addExtraBig
        end

        if offset > 0 then
            offset = 0
        elseif offset < sizex then
            offset = sizex
        end
    end

    return offset
end

function MapGame:setMapPosition(step_index)
    step_index = step_index > 0 and step_index or 1
    local posy = self:getContainerPosY(step_index)
    local container_node = self.mapContainerNode:getInnerContainer()
    local posx = container_node:getPositionX()
    container_node:setPosition(cc.p(posx, posy))
end

function MapGame:showMapForwardPosition(next_index)
    if next_index == 0 or next_index - 1 == 0 then
        return
    end
    local mapIndex = next_index - 1
    local container_node = self.mapContainerNode:getInnerContainer()
    self:setMapPosition(next_index - 1)
    local posY = self:getContainerPosY(next_index)
    local posX = container_node:getPositionX()

    container_node:runAction(cc.MoveTo:create(0.2, cc.p(posX, posY)))
end

function MapGame:setUserIconPosition(index)
	local pos = self.mapConfig.userStartPos
	if index > 0 then 
		pos = cc.p(self.stepList[index].node:getPosition())
	end
	-- if index+1 <= self.mapConfig.maxMapLevel and self.stepList[index+1] and bole.isValidNode(self.stepList[index+1].node) then 
	-- 	if pos.x > self.stepList[index+1].node:getPositionX() then 
	-- 		self.userIcon:setScaleX(-1)
	-- 	end
	-- end
	self.userIcon:setPosition(pos)
end

function MapGame:showUserIconForwardPosition(next_index)
	local start_pos = (next_index - 1) == 0 and self.mapConfig.userStartPos or cc.p(self.stepList[next_index-1].node:getPosition())
	local pos = cc.p(self.stepList[next_index].node:getPosition())
	self.userIcon:setPosition(start_pos)

	-- if start_pos.x > pos.x then 
	-- 	self.userIcon:setScaleX(-1)
	-- end
    self.vCtl:playMusicByName("icon_move")
	local animName = self.mapConfig.buildingLevel[next_index] and "animation3" or "animation2"
	bole.spChangeAnimation(self.userIcon, animName)
	self.userIcon:runAction(cc.Sequence:create(
		cc.MoveTo:create(10/30, pos),
		cc.DelayTime:create(10/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(self.userIcon, "animation1")
		end)))

end


function MapGame:showMapScene(isAnimate, exitEvent)
    --self.vCtl.isShowMap = true
    -- 隐藏B级活动栏
    self.vCtl:hideActivitysNode()
    self.vCtl.isOpenStoreNode = true

    local duration1 = 0.15
    local duration2 = 0.35
    local showBtnDelay = 0.35

    if isAnimate then
        showBtnDelay = 0
        self:setMapPosition(self.mapLevel - 1)
        self:setUserIconPosition(self.mapLevel-1)
    else
        -- 暂停主题
        --bole.pauseTheme()
        self.vCtl:setFooterBtnsEnable(false)
        self:showIdleAnimation()
        self:setMapPosition(self.mapLevel)
        self:setUserIconPosition(self.mapLevel)
    end

    self.vCtl:getCurScene():addToContentFooter(self, 999)
    if HEADER_FOOTER_SCALE_H < 1 then
        bole.adaptBackground(self.root)
    end
    bole.adaptReelBoard(self.root)
    
    self.mapContainerNode:setPosition(self.mapConfig.mapHidePos)
    
    if bole.isValidNode(mapTopNode) then 
        self.mapTopNode:setPosition(self.mapConfig.mapTopHidePos)
    end


    self:setData(self.mapLevel, isAnimate)

    local function initBackBtnEvent(...)
        -- 点击按钮
        local pressFunc = function(obj)
            self.btn_back:setTouchEnabled(false)
            self.btn_back:setBright(false)
            -- 播放点击音乐
            self.vCtl:playMusicByName("common_click")

            self:exitMapScene()

        end

        local function onTouch(obj, eventType)
            if eventType == ccui.TouchEventType.ended then
                pressFunc(obj)
            end
        end

        -- 设置按钮
        self.btn_back:addTouchEventListener(onTouch)
    end
    local function showBackGameBtn()
        self.buttonNode:setScale(0)
        self.buttonNode:setVisible(true)
        self.buttonNode:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.2, 1.5, 1.5),
                cc.ScaleTo:create(0.15, 1, 1)
        ))
    end

    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self.dimmer:setOpacity(0)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeIn:create(0.3))
                self.vCtl:playMusicByName("map_open")
            end),
            cc.DelayTime:create(duration1 + 0.1),
            cc.CallFunc:create(function(...)
                self.mapContainerNode:runAction(cc.MoveTo:create(duration2, self.mapConfig.mapShowPos))

                if bole.isValidNode(mapTopNode) then 
                    self.mapTopNode:runAction(cc.MoveTo:create(duration2, self.mapConfig.mapTopShowPos))
                end

            end),
            cc.DelayTime:create(duration2 + 0.1),
            cc.CallFunc:create(function(...)
                self.mapContainerNode:setPosition(self.mapConfig.mapShowPos)
                if not isAnimate then
                    showBackGameBtn()
                end
            end),
            cc.DelayTime:create(showBtnDelay),
            cc.CallFunc:create(function()
                if isAnimate then
                    self:showIncreaseAnimation(exitEvent)
                else
                    self.btn_back:setTouchEnabled(true)
                    initBackBtnEvent()
                end
            end)
    ))
end

function MapGame:showIncreaseAnimation( exitEvent )
    local bgAniDelay = 0.2
    if self.mapLevel >= 1 then
        bgAniDelay = 20 / 30
        -- if self.mapConfig.buildingLevel[self.mapLevel] then
        --     self.vCtl:playMusicByName("map_node")
        -- end
        -- if not self.mapConfig.buildingLevel[self.mapLevel] then
        --     self.vCtl:playMusicByName("map_move")
        -- end
    end

    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function(...)
            	self:showUserIconForwardPosition(self.mapLevel)
                self:showMapForwardPosition(self.mapLevel)
            end),
            cc.DelayTime:create(bgAniDelay),
            cc.CallFunc:create(function()

                if self.mapConfig.buildingLevel[self.mapLevel] then
                    self:lightingBigBuild(self.mapLevel)
                    self.vCtl:playMusicByName("arrive_big")
                end

                if not self.mapConfig.buildingLevel[self.mapLevel] then
                    self:lightingSmallHeart(self.mapLevel)
                    self.vCtl:playMusicByName("arrive_small")
                end
            end),
            -- cc.DelayTime:create(0.5),
            -- cc.CallFunc:create(function()
            --     if not self.mapConfig.buildingLevel[self.mapLevel] then
            --         self:lightingSmallHeart(self.mapLevel)
            --     end
            -- end),
            cc.DelayTime:create(1),
            cc.CallFunc:create(function()
                self:exitMapScene(true, exitEvent)
            end)
    ))
end
function MapGame:lightingBigBuild(level)
	-- local aniNode = self.stepList[level].aniNode
	-- bole.addSpineAnimation(aniNode, nil, self.vCtl:getPic(self.mapConfig.mapSpineConfig.moveToBig), cc.p(0, -120), "animation")

    local aniSpine = self.stepList[level].aniSpine
    local aniName1 = self.mapConfig.mapBigAnim.win
    bole.spChangeAnimation(aniSpine, aniName1, true)
end
function MapGame:lightingSmallHeart(level)
    local aniNode = self.stepList[level].aniNode
    
    self:updateWinSmallNodeSp(level)

    local aniName1 = "animation1"
    local aniName2 = "animation2"
    local _, s2 = bole.addSpineAnimation(aniNode, nil, self.vCtl:getPic(self.mapConfig.mapSpineConfig.map_small), cc.p(0, 0), aniName1, nil, nil, nil, true, false)
    local aniSpine = s2
    aniSpine:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(
			function()
				bole.spChangeAnimation(aniSpine, aniName2, true)
			end
		)))
end
function MapGame:showIdleAnimation(...)

    if self.mapLevel == 0 then
        return
    end
    if self.mapConfig.buildingLevel[self.mapLevel] then
        self:showIdleBig()
    else
        self:showIdleSmall()
    end
end
function MapGame:showIdleSmall()
    local aniName = "animation2"
    local parent = self.stepList[self.mapLevel].aniNode
    local file = self.vCtl:getPic(self.mapConfig.mapSpineConfig.map_small)
    local _, s = bole.addSpineAnimation(parent, nil, file, cc.p(0, 0), aniName, nil, nil, nil, true, true, nil)

    self:updateWinSmallNodeSp(self.mapLevel)
end
function MapGame:showIdleBig()
    local aniSpine = self.stepList[self.mapLevel].aniSpine
    local aniName1 = self.mapConfig.mapBigAnim.loop
    bole.spChangeAnimation(aniSpine, aniName1, true)
end
function MapGame:setData(level, isAnimate)
    if isAnimate then
        level = level - 1
    end

    if level < 0 then
        level = 0
    end

    if level > 0 then
        for i = 1, level do
            if i < level then -- or isAnimate
                if self.mapConfig.buildingLevel[i] then
                    local aniSpine = self.stepList[i].aniSpine
                    local aniName1 = self.mapConfig.mapBigAnim.over
                    bole.spChangeAnimation(aniSpine, aniName1, false)
                else
                    self:updateWinSmallNodeSp(i)
                    
                end
            end
        end
    end
end

function MapGame:updateWinSmallNodeSp( level )
    local spFile = self.mapConfig.mapSp.small

    if spFile then 
        bole.updateSpriteWithFile(self.stepList[level].dim, spFile)
    end
end

function MapGame:addSmallNodeAnim( level )
    
end

function MapGame:exitMapScene(isAnimate, exitEvent)
    --self.vCtl.isShowMap = false

    self.vCtl.isOpenStoreNode = false

    -- 恢复主题
    --bole.resumeTheme()
    local duration1 = 0.15
    local duration2 = 0.35
    local hideBtnDelay = 0.3

    if isAnimate then
        hideBtnDelay = 0
        self.mapContainerNode:stopAutoScroll()
    else
        self.vCtl:showActivitysNode()
        self.vCtl:setFooterBtnsEnable(true)
    end

    local function hideBackGameBtn()
        self.buttonNode:setScale(1)
        self.buttonNode:setVisible(true)
        self.buttonNode:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.15, 1.5, 1.5),
                cc.ScaleTo:create(0.2, 0, 0)
        ))
    end

    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function(...)
                if not isAnimate then
                    hideBackGameBtn()
                end
            end),
            cc.DelayTime:create(hideBtnDelay),
            cc.CallFunc:create(function(...)
                self.vCtl:playMusicByName("map_close")
                self.mapContainerNode:runAction(cc.MoveTo:create(duration2, self.mapConfig.mapHidePos))

                if bole.isValidNode(mapTopNode) then 
                    self.mapTopNode:runAction(cc.MoveTo:create(duration2, self.mapConfig.mapTopHidePos))
                end

            end),
            cc.DelayTime:create(duration2),
            cc.CallFunc:create(function(...)
                self.dimmer:setOpacity(255)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeOut:create(duration1))
            end),
            cc.DelayTime:create(duration1),
            cc.CallFunc:create(function(...)
                if isAnimate then
                    if self.mapConfig.buildingLevel[self.mapLevel] then
                    else
                        if exitEvent then
                            exitEvent()
                        end

                    end
                else
                    -- self.vCtl:enableMapInfoBtn(true)
                end
                self.vCtl:closeStoreNode()
            end),
            cc.RemoveSelf:create()
    ))
end