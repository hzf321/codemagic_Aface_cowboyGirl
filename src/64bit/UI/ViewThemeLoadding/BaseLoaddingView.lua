local BaseLoaddingView = class("BaseLoaddingView", CCSNode)

local ThemeLoadingConfig = require "Systems/Lobby/ThemeLoadingConfig"
local loadingLogoConfig  = ThemeLoadingConfig.loading_logo_config
local loadingBarConfig   = ThemeLoadingConfig.loading_bar_config

local v_bar_config = {
    width      = 511,
    height     = 30,
    pos_bar    = cc.p(0, -508),
    --pos_bar_bg = cc.p(0, -507.5),
    img_bar    = "theme_loading/image/loading2_com/v_loading_bar01.png",
    img_bar_bg = "theme_loading/image/loading2_com/v_loading_bar02.png",
}
local h_bar_config = {
    width      = 752,
    height     = 30,
    pos_bar    = cc.p(0, -284),
    --pos_bar_bg = cc.p(0, -282.5),
    img_bar    = "theme_loading/image/loading2_com/h_loading_bar01.png",
    img_bar_bg = "theme_loading/image/loading2_com/h_loading_bar02.png",
}
function BaseLoaddingView:ctor(theme, csb)
    self.theme = theme
    local resourceId = THEME_LIST[self.theme.themeid]['resourceId']
    local loadingId = THEME_LIST[self.theme.themeid]['loadingId']
    self.portrait = THEME_LIST[self.theme.themeid]['portrait']
    self.csb = csb or "theme_loading/theme" .. resourceId .. "/loading2/theme" .. loadingId .. "_loading.csb"
    CCSNode.ctor(self, self.csb)
    self.root = self.node:getChildByName("root")
    self.labelNode = self.root:getChildByName("labels")
    self.config = h_bar_config
    if self.portrait == 1 then
        self.config = v_bar_config
    end
    local bg = self.node:getChildByName("bg")
    if SHRINKSCALE_H < 1 then
        self.root:setScale(SHRINKSCALE_H)
    else
        if self.portrait == 1 then
            bg:setScaleY(bg:getScaleY() * FRAME_WIDTH / DESIGN_WIDTH)
        else
            bg:setScaleX(bg:getScaleX() * FRAME_WIDTH / DESIGN_WIDTH)
        end
    end

    -- 单机机台进度条特殊处理
    local loading_bg = self.root:getChildByName("loading_bg")
    if loading_bg then
        self.progress = loading_bg:getChildByName("loading_bar")
        self.progress:setPercent(10)
        if not self.progress.setPercentage then
            self.progress.setPercentage = function(obj, progress)
                obj:setPercent(progress)
            end
        end

        local config = loadingBarConfig[self.theme.themeid]
        if config and config.bar_spine then
            local _, _spine = bole.addSpineAnimation(loading_bg, nil, config.bar_spine, cc.p(0, 24), "animation", nil, nil, nil, true, true, nil)
            self.bar_spine = _spine
        end
    else
        self:initProgressBar()
    end
    -- self:initlbProcess()
    -- self:initLogoAnim()

    self.fadeOutDuration = 0.75
    -- self:initLabels() -- 特殊描述

end

function BaseLoaddingView:initProgressBar()

    
    local posBar
    local posBarBg
    local LoadingBar = self.root:getChildByName("LoadingBar")
    local LoadingBarBg = self.root:getChildByName("Image_1")
    if not LoadingBarBg then
        LoadingBarBg = self.root:getChildByName("Image_2")
    end
    if LoadingBarBg then
        LoadingBarBg:removeFromParent()
    end
    if LoadingBar then
        posBar = bole.getPos(LoadingBar)
        LoadingBar:removeFromParent()
    else
        if self.theme.getLoading2BarPos then
            posBar = self.theme:getLoading2BarPos()
        else
            posBar = self.config.pos_bar
        end
    end
    self.barPos = posBar
    if self.portrait == 1 then
        posBarBg = cc.pAdd(self.barPos, cc.p(0, 0.5))
    else
        posBarBg = cc.pAdd(self.barPos, cc.p(0, 1.5))
    end

    local bg = bole.createSpriteWithFile(self.config.img_bar_bg)
    self.root:addChild(bg, 1)
    bg:setPosition(posBarBg)

    local node = cc.Node:create()
    self.barNode = node
    self.barNode:setPosition(self.barPos)
    self.root:addChild(self.barNode, 2)

    local node =  libUI.createProgressBar(self.config.img_bar)
    self.progress = node
    self.barNode:addChild(self.progress)
    bole.setEnableRecursiveCascading(self.barNode, true)

end

function BaseLoaddingView:initLogoAnim( ... )
    -- if 
    if loadingLogoConfig and loadingLogoConfig[self.theme.themeid] then 
        for name, n_data in pairs(loadingLogoConfig[self.theme.themeid]) do
            if n_data.n_type == "spine" then 
                local node = bole.deepFind(self.root, name)

                local logo_node = self.root:getChildByName("logo_node")
                if bole.isValidNode(logo_node) then
                    logo_node:removeAllChildren()
                end

                local data = {}
                data.file = n_data.path
                data.parent = logo_node or node
                data.isLoop = true

                local _, s1 = bole.addAnimationSimple(data)
                
                if type(n_data.anim) == "table" then 
                    for i, name in pairs(n_data.anim) do 
                        if i == 1 then 
                            s1:setAnimation(0, name, i == table.nums(n_data.anim))
                        else
                            s1:addAnimation(0, name, i == table.nums(n_data.anim))
                        end
                    end
                end
            elseif n_data.n_type == "image" then
            end
        end

        
    end
end

function BaseLoaddingView:setPercentage(p)
    if p > 100 then
        p = 100
    end
    if self.beforePercentage and self.beforePercentage >p then
        p = self.beforePercentage
    end
    self.beforePercentage = p or 0
    -- self.progress:setPercentage(p)

    EventCenter:pushEvent(EVENTNAMES.THEME.UPDATE_LOADDING_PROGRESS, {percent = p})
end

--自动加载
function BaseLoaddingView:autoLoading(callback)
    local delay = 2
    if self.progress then
        local count = 10
        self.progress:setPercentage(10)
        self.progress:runAction(
            cc.RepeatForever:create(
                cc.Sequence:create(
                    cc.DelayTime:create(0.01),
                    cc.CallFunc:create(function()
                        count = count + 0.75
                        if count >= 100 then
                            count = 100
                        end
                        self.progress:setPercentage(count)
                    end)
                )
            )
        )
        self.progress:runAction(cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function()
                if callback then callback() end
            end)
        ))
        local width = self.progress:getContentSize().width
        if self.bar_spine then
            self.bar_spine:setPositionX(0.1 * width)
            self.bar_spine:runAction(cc.MoveBy:create(delay, cc.p(0.9 * width, 0)))
        end
    end

end

function BaseLoaddingView:checkAndAddCloseLoadingBtn(...)
    if self.theme and not bole.isBaseThemeId(self.theme.themeid) then -- self.theme and self.theme.themeid and self.theme.themeid > 2000
        return
    end
    local download_controller = DownloadController:getInstance()
    local resourceId = tostring(THEME_LIST[self.theme.themeid]['resourceId'])

    if download_controller:needDownload(DOWNLOAD_TYPE.THEME, resourceId) then
        local backBtnFile1 = "commonImages/activity_close.png"
        local backBtnFile2 = "commonImages/activity_close_press.png"
        local addClosePos = THEME_LIST[self.theme.themeid]['addClosePos']
        -- parent, touchFunc, file1, file2, file3, pos, zOrder, scale
        local btnPos = cc.p(FRAME_WIDTH / 2 - 80, DESIGN_HEIGHT / 2 - 80)
        if self.portrait == 1 then
            btnPos = cc.p(DESIGN_HEIGHT / 2 - 80, FRAME_WIDTH / 2 - 100)
        end
        if addClosePos then
            btnPos = cc.pAdd(btnPos, addClosePos)
        end


        local function onTouch(obj, eventType)
            if eventType == ccui.TouchEventType.ended then
                if self.theme:getHeader() then
                    local tid = self.theme.themeid
                    if tid then
                        bole.send_codeInfo(Splunk_Type.ACTION, { current = "stop_enter_theme", tid = tid }, false)
                    end
                    self.backLobbyBtn:setTouchEnabled(false)
                    local data = {
                        from = "lobby",
                    }
                    EventCenter:pushEvent(EVENTNAMES.THEME.ALLOW_QUIT_THEME, data) -- self.header:onTouchLobbyBtn()
                    -- libMM.setIntegerForKey("clickLobbyTheme", 0)
                end
            end
        end

        self.backLobbyBtn = libUI.createButton(
                self.node,
                onTouch,
                backBtnFile1,
                backBtnFile2,
                backBtnFile2,
                btnPos,
                100
        )
    end
end

function BaseLoaddingView:setBackLobbyBtnState(state, isHide)
    if bole.isValidNode(self.backLobbyBtn) then
        self.backLobbyBtn:setTouchEnabled(state)
    end
end

function BaseLoaddingView:initLabels()
    if self.labelNode and LoadingLabelDesc[self.theme.themeid] then
        local labels = self.labelNode:getChildren()
        if LoadingLabelDesc[self.theme.themeid].type == 1 then
            local index = cc.UserDefault:getInstance():getIntegerForKey("chooseBetIndex", 1)

            local des = LoadingLabelDesc[self.theme.themeid]["value"][index]
            for k, v in pairs(labels) do
                v:setString(des)
            end
        end
    end
end

function BaseLoaddingView:getEndTime(...)
    return 0
end
function BaseLoaddingView:hideOnTime(endTime)
    -- self.progress:setPercent(100, endTime)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(endTime), cc.CallFunc:create(function()
        self:hide()
    end)))
end
function BaseLoaddingView:hide()
    local duration = 0
    for _, v in pairs(self:getParent():getChildren()) do
        v:setVisible(true)
    end
    self:setCascadeOpacityEnabled(true)
    self:runAction(cc.Sequence:create(cc.FadeOut:create(self.fadeOutDuration), cc.CallFunc:create(function()
        self:removeFromParent()
        EventCenter:pushEvent(EVENTNAMES.THEME.ENTER_LOADING_HIDE)
    end)))
end

function BaseLoaddingView:setPercent(real_v)

    self:setPercentage(real_v)

    if self.totalKb and self.totalKb > 0 then
        local current
        local endPercent = 100

        if real_v >= endPercent then
            current = "Loading Game Resources ( " .. self.totalKb .. " / " .. self.totalKb .. " KB )"
        else
            local cur_Kb = math.floor(real_v * self.totalKb / 100)
            if self.curKb >= cur_Kb then
                if self.curKb < self.totalKb - 300 then
                    self.curKb = self.curKb + math.random(20)
                elseif self.curKb < self.totalKb - 5 then
                    self.curKb = self.curKb + math.random(2)
                end
            elseif cur_Kb > self.curKb then
                self.curKb = cur_Kb
            end
            current = "Loading Game Resources ( " .. self.curKb .. " / " .. self.totalKb .. " KB )"
        end

        self.lbProcess:setString(current)
    end
end

function BaseLoaddingView:initlbProcess(...)
    self.lbProcess = FONTS.new("theme_loading/image/loading2_com/theme_loading_fnt01.fnt", "Loading Game Resources ...")

    local pos = cc.p(self.barPos.x, self.barPos.y - 45)
    self.lbProcess:setString("Loading Game Resources . . .")
    local pos2 = cc.pSub(pos, cc.p(self.lbProcess:getContentSize().width / 2, 0))
    self.lbProcess:setPosition(pos2)
    self.lbProcess:setString("")

    self.lbProcess:setAnchorPoint(0, 0.5)
    self.lbProcess:stopAllActions()
    self.lbProcess:setOpacity(255)
    self.lbProcess:setVisible(true)
    self.lbProcess:setScaleX(1 / self.progress:getScaleX())
    self.curKb = 0
    self.totalKb = 0

    local fs = 60 / 60
    self.lbProcess:runAction(
            cc.RepeatForever:create(
                    cc.Sequence:create(
                            cc.CallFunc:create(function(...)
                                self.lbProcess:setString("Loading Game Resources ")
                            end),
                            cc.DelayTime:create(fs / 3),
                            cc.CallFunc:create(function(...)
                                self.lbProcess:setString("Loading Game Resources .")
                            end),
                            cc.DelayTime:create(fs / 3),
                            cc.CallFunc:create(function(...)
                                self.lbProcess:setString("Loading Game Resources . .")
                            end),
                            cc.DelayTime:create(fs / 3),
                            cc.CallFunc:create(function(...)
                                self.lbProcess:setString("Loading Game Resources . . .")
                            end),
                            cc.DelayTime:create(fs / 3)
                    )
            )
    )
    self.root:addChild(self.lbProcess, 2)
end

function BaseLoaddingView:addTotalByte(byte)
    self.lbProcess:stopAllActions()
    self.totalKb = self.totalKb + math.floor(byte / 1000)

    local pos = cc.p(self.barPos.x, self.barPos.y - 45)
    self.lbProcess:setString("Loading Game Resources ( " .. self.totalKb .. " / " .. self.totalKb .. " KB )")
    local pos2 = cc.pSub(pos, cc.p(self.lbProcess:getContentSize().width / 2, 0))
    self.lbProcess:setPosition(pos2)
    self.lbProcess:setString("")

    local current = "Loading Game Resources ( " .. self.curKb .. " / " .. self.totalKb .. " KB )"
    self.lbProcess:setString(current)
end

return BaseLoaddingView