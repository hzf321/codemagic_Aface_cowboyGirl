--- Created by rwb
--- DateTime: 2020-09-16 15:57
local fs_show_type = {
    start   = 1,
    more    = 2,
    collect = 3,
    choose  = 4,
}
local ThemeDialog = class("ThemeDialog", CCSNode)
local cls = ThemeDialog

function cls:ctor(pThemeCtr, pConfig, blackConfig)
    self.themeCtr = pThemeCtr
    self.theme = pThemeCtr.theme
    self.genPath = pConfig["gen_path"]
    self.csb = pConfig["csb_file"]
    self.frameConfig = pConfig["frame_config"]
    self.dialog_config = pConfig["dialog_config"]
    self.black_config = blackConfig
    self.sceneSize = bole.getSceneSize()
    self.centerPos = cc.p(self.sceneSize.width / 2, self.sceneSize.height / 2)
    CCSNode.ctor(self, self.csb)
end
function cls:loadControls()
    self.root = self.node:getChildByName("root")
    for k, v in pairs(self.root:getChildren()) do
        v:setVisible(false)
    end
    if self.black_config then
        self.commonBlack = self.node:getChildByName("common_black")
        if not self.commonBlack then
            self.commonBlack = self:addBlackMask()
        end
    end
    self.startRoot = self.root:getChildByName("node_start")
    if self.startRoot then
        self.startRoot.btnStart = bole.deepFind(self.startRoot, "btn_start")
        self.startRoot.labelCount = bole.deepFind(self.startRoot, "label_count")
        self.startRoot.ScaleNode = bole.deepFind(self.startRoot, "jump_wenzi") -- whj 添加用来播放jump动画
    end
    self.moreRoot = self.root:getChildByName("node_more")
    if self.moreRoot then
        self.moreRoot.labelCount = bole.deepFind(self.moreRoot, "label_count")
    end
    self.collectRoot = self.root:getChildByName("node_collect")
    if self.collectRoot then
        self.collectRoot.btnCollect = bole.deepFind(self.collectRoot, "btn_collect")
        self.collectRoot.labelWin = bole.deepFind(self.collectRoot, "label_coins")
        self.collectRoot.labelCount = bole.deepFind(self.collectRoot, "label_count")
    end

    ---@desc 针对于需要二选一的弹窗
    self.chooseRoot = self.root:getChildByName("node_choose")
    if self.chooseRoot then
        self.chooseRoot.btnLeft = bole.deepFind(self.chooseRoot, "btn_left")
        self.chooseRoot.btnRight = bole.deepFind(self.chooseRoot, "btn_right")
    end
    self.baseRoot = self.root:getChildByName("node_base") -- whj 添加 用来执行 操作 start more 或者 collect 共同存在的背景
end
function cls:addBlackMask()
    local mask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    mask:setAnchorPoint(cc.p(0.5, 0.5))
    mask:setContentSize(4000, 4000)
    mask:setPosition(-2000, -2000)
    self.node:addChild(mask, -1)
    return mask
end
function cls:show(initEventFunc, intLayoutFunc, parent)
    if parent then
        parent:addChild(self)
    else
        self.themeCtr.curScene:addToContentFooter(self)
    end
    self:_addDialogSpine(self.dialogType) -- todo
    self.node:setVisible(false)
    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(0.1),
                    cc.CallFunc:create(function()
                        self.node:setVisible(true)
                        if self.fsData["enter_event"] then
                            self.fsData["enter_event"]()
                        end
                    end),
                    cc.DelayTime:create(self.curFrameConfig[2]),
                    cc.CallFunc:create(function()
                        if initEventFunc then
                            initEventFunc()
                        end
                    end)))
    if intLayoutFunc then
        intLayoutFunc()
    end
end
function cls:hide()
    local action = cc.CSLoader:createTimeline(self.csb)
    self.node:runAction(action)
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                self:_removeDialogSpine(self.dialogType)
            end
            ),
            cc.DelayTime:create(self.curFrameConfig[4] or 0),
            cc.RemoveSelf:create()))
end
function cls:_addDialogSpine(dialogType)
    local parent = self.startRoot
    if dialogType == fs_show_type.start then
    elseif dialogType == fs_show_type.more then
        parent = self.moreRoot
    elseif dialogType == fs_show_type.collect then
        parent = self.collectRoot
    elseif dialogType == fs_show_type.choose then
        parent = self.chooseRoot
    end
    if self.dialog_config then
        self:_addSpineAction(parent, self.dialog_config)
    end
    if self.commonBlack then
        self:_addCommonBlackSpine(self.commonBlack, self.black_config.stepFade)
    end
end
function cls:_addSpineAction(parentNode, config)
    for key, item in pairs(config) do
        if key == "maxWidth" then
            --  不需要处理
        elseif key == "baseScale" then
            --  不需要处理
        elseif key == "btn" then
            local btnNode
            if self.dialogType == fs_show_type.start then
                btnNode = parentNode.btnStart
            elseif self.dialogType == fs_show_type.more then
                btnNode = nil
            else
                btnNode = parentNode.btnCollect
            end
            if btnNode then
                local aniName = item.aniName or "animation"
                local scalebtn = item.scaleBtn
                local size = btnNode:getContentSize()
                local _, s = bole.addSpineAnimation(btnNode, nil, self.theme:getSpineFile(item.name), cc.p(size.width / 2, size.height / 2), aniName, nil, nil, nil, true, true)
                if scalebtn then
                    s:setScale(scalebtn)
                end
            end
        else
            local childNode = bole.deepFind(parentNode, key)
            if childNode then
                local x, y = cc.p(0, 0)
                local myParent = childNode
                if item.isImg then
                    local img_name = item.name
                    if item.formatname then
                        img_name = string.format(img_name, self.fsData[key])
                    end
                    bole.updateSpriteWithFile(myParent, img_name)
                elseif item.isFont then
                    myParent:setString(self.fsData[key])
                    -- local font_name = item.
                elseif item.isAction then

                    local scaleAction = item.stepScale
                    local fadeAction = item.stepFade
                    local startPos = item.startPos
                    local posAction = item.stepPos
                    if startPos then
                        myParent:setPosition(startPos)
                    end
                    if item.changeNode and self.fsData[key] then
                        if self.fsData[key].pos then 
                            myParent:setPosition(self.fsData[key].pos)
                        end
                        -- 暂时没有用到, 如果有人使用的话, 再打开测试或者补充一下两个参数的情况
                        -- if self.fsData[key].scale then 
                        --     myParent:setScale(self.fsData[key].scale)
                        -- end
                    end
                    if scaleAction then
                        myParent:setScale(scaleAction[1][1])
                        local scaleList = {}
                        for key = 2, #scaleAction do
                            local info = scaleAction[key]
                            local a1 = cc.ScaleTo:create(info[1], info[2])
                            if info[3] then 
                                a1 = cc.ScaleTo:create(info[1], info[2], info[3])
                            end
                            table.insert(scaleList, a1)
                        end
                        myParent:runAction(cc.Sequence:create(unpack(scaleList)))
                    end
                    if fadeAction then
                        bole.setEnableRecursiveCascading(myParent, true)
                        myParent:setOpacity(fadeAction[1][1])
                        local fadeList = {}
                        for key = 2, #fadeAction do
                            local info = fadeAction[key]
                            local a1 = cc.FadeTo:create(info[1], info[2])
                            table.insert(fadeList, a1)
                        end
                        myParent:runAction(cc.Sequence:create(unpack(fadeList)))
                    end
                    if posAction then
                        myParent:setPosition(posAction[1][1])
                        local posList = {}
                        for key = 2, #posAction do
                            local info = posAction[key]
                            local a1 = cc.MoveTo:create(info[1], info[2])
                            table.insert(posList, a1)
                        end
                        myParent:runAction(cc.Sequence:create(unpack(posList)))
                    end

                elseif item.startAction then
                    local ani_name = item.startAction[1]
                    local isLoop = item.startAction[2]
                    local fileName = item.name
                    if item.formatname then
                        ani_name = string.format(ani_name, self.fsData[key])
                        fileName = string.format(fileName, self.fsData[key])
                    end
                    local _, s = bole.addSpineAnimation(myParent, item.zorder, self.theme:getSpineFile(fileName), cc.p(x, y), ani_name, nil, nil, nil, true, isLoop)
                    s:setName("spine")
                    if item.loopAction then
                        local ani_name2 = item.loopAction[1]
                        if item.formatname then
                            ani_name2 = string.format(ani_name2, self.fsData[key])
                        end
                        s:addAnimation(0, ani_name2, item.loopAction[2])
                        if item.endAction then
                            local ani_name3 = item.endAction[1]
                            if item.formatname then
                                ani_name3 = string.format(ani_name3, self.fsData[key])
                            end
                            s:setMix(ani_name2, ani_name3, 0.2)
                        end
                    end
                elseif item.isVisible then
                    local isVisible = item.isVisible
                    if isVisible then
                        myParent:setVisible(isVisible == 1)
                    end
                end
            end
        end
    end
end
function cls:_removeDialogSpine(dialogType)
    local parent = self.startRoot
    if dialogType == fs_show_type.start then
    elseif dialogType == fs_show_type.more then
        parent = self.moreRoot
    elseif dialogType == fs_show_type.collect then
        parent = self.collectRoot
    elseif dialogType == fs_show_type.choose then
        parent = self.chooseRoot
    end
    if self.dialog_config then
        self:_removeSpineAction(parent, self.dialog_config)
    end
    if self.commonBlack then
        self:_removeCommonBlackSpine(self.commonBlack, self.black_config.stepEndFade)
    end
end

function cls:_removeSpineAction(parentNode, config)
    for key, item in pairs(config) do
        if key == "maxWidth" then
            --  do nothing
        elseif key == "btn" then
            -- do nothing
        elseif item.isImg then
            -- do nothing
        else
            if item.isAction then
                if item.stepEndScale then
                    local myParent = bole.deepFind(parentNode, key)
                    --local myParent = childNode
                    if myParent then
                        local scaleAction = item.stepEndScale
                        myParent:setScale(scaleAction[1][1])
                        local scaleList = {}
                        for key = 2, #scaleAction do
                            local info = scaleAction[key]
                            local a1 = cc.ScaleTo:create(info[1], info[2])
                            table.insert(scaleList, a1)
                        end
                        myParent:runAction(cc.Sequence:create(unpack(scaleList)))
                    else
                        -- Error
                    end
                end
                if item.stepEndFade then
                    local myParent = bole.deepFind(parentNode, key)

                    local fadeAction = item.stepEndFade
                    bole.setEnableRecursiveCascading(myParent, true)
                    local fadeList = {}
                    myParent:setOpacity(fadeAction[1][1])
                    for key = 2, #fadeAction do
                        local info = fadeAction[key]
                        local a1 = cc.FadeTo:create(info[1], info[2])
                        table.insert(fadeList, a1)
                    end
                    myParent:runAction(cc.Sequence:create(unpack(fadeList)))
                end
            elseif item.endAction then
                local myParent = bole.deepFind(parentNode, key)
                local spineNode = myParent:getChildByName("spine")
                local ani_name = item.endAction[1]
                if item.formatname then
                    ani_name = string.format(ani_name, self.fsData[key])
                end
                if spineNode and bole.isValidNode(spineNode) then

                    spineNode:setAnimation(0, ani_name, item.endAction[2])
                end

            end
        end
    end
end
function cls:_addCommonBlackSpine(target, fadeAction)
    if fadeAction then
        bole.setEnableRecursiveCascading(target, true)
        target:setOpacity(fadeAction[1][1])
        target:setVisible(true)
        local fadeList = {}
        for key = 2, #fadeAction do
            local info = fadeAction[key]
            local a1 = cc.FadeTo:create(info[1], info[2])
            table.insert(fadeList, a1)
        end
        target:runAction(cc.Sequence:create(unpack(fadeList)))
    end
end
function cls:_removeCommonBlackSpine(target, fadeAction)
    self:_addCommonBlackSpine(target, fadeAction)
end

function cls:showStart(pFsData, pEndCallFunc, parent)
    self.dialogType = fs_show_type.start
    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["start"]
    local initEventFunc = function()
        self:_initStartEvent()
    end
    local intLayoutFunc = function()
        self:_initStartLayout()
    end
    self:show(initEventFunc, intLayoutFunc, parent)
end
function cls:_initStartLayout()
    self.startRoot:setVisible(true)
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end
    if self.startRoot.labelCount then
        self.startRoot.labelCount:setString(self.fsData["count"])
    end
end
function cls:_initStartEvent()
    self.isClick = false
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setEnabled(false)
            --self.theme:playMusic(self.theme.audio_list.common_click)
            self:clickStartBtn()
        end
    end
    if self.startRoot.btnStart then
        self.startRoot.btnStart:addTouchEventListener(btnEvent)
    end
end
function cls:clickStartBtn()
    if self.isClick then
        return
    end
    self.isClick = true
    self.startRoot.btnStart:setTouchEnabled(false)
    if self.fsData["click_event"] then
        self.fsData["click_event"]()
    end
    self:hide()
end
------------------------------------------------------------------------------------------------------------
function cls:showMore(pFsData, pEndCallFunc, parent)
    self.dialogType = fs_show_type.more
    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["more"]
    local intLayoutFunc = function()
        self:_initMoreLayout()
    end
    self:show(nil, intLayoutFunc, parent)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(self.curFrameConfig[2]), cc.CallFunc:create(function()
        if self.fsData["click_event"] then
            self.fsData["click_event"]()
        end
        self:hide()
    end)))
end
function cls:_initMoreLayout()
    self.moreRoot:setVisible(true)
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end
    if self.moreRoot.labelCount then
        self.moreRoot.labelCount:setString(self.fsData["count"])
    end
end
function cls:_setCollectScaleByValue(Value, maxWidth)
    if self.collectRoot.labelWin and maxWidth and Value then
        self.collectRoot.labelWin:setString(FONTS.format(Value, true))
        bole.shrinkLabel(self.collectRoot.labelWin, maxWidth, self.collectRoot.labelWin:getScale())
    end
end
function cls:showCollect(pFsData, pEndCallFunc, parent)
    self.dialogType = fs_show_type.collect
    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["collect"]
    self.isCollect = false
    local initEventFunc = function()
        self:_initCollectEvent()
    end
    local intLayoutFunc = function()
        self:_initCollectLayout()
    end
    self:show(initEventFunc, intLayoutFunc, parent)
end
function cls:_initCollectLayout()
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end
    self.collectRoot:setVisible(true)
    self.isRollEnd = false
    if self.collectRoot.labelWin then
        local function parseValue(num)
            return FONTS.format(num, true)
        end
        inherit(self.collectRoot.labelWin, LabelNumRoll)
        self.collectRoot.labelWin:nrInit(0, 24, parseValue)
        local rollTime = self.fsData["roll_time"] or 2
        self.collectRoot.labelWin:nrStartRoll(0, self.fsData["coins"], rollTime)
        self:dealMusic_playRollCoins()
        if self.dialog_config then
            local width = self.dialog_config.maxWidth
            self:_setCollectScaleByValue(self.fsData.coins, width)
        end
    end
end
function cls:rollCoinsAgain(startCoins, endCoins)
    if self.collectRoot.labelWin then
        self.fsData["coins"] = endCoins
        local rollTime = self.fsData["roll_time"] or 2
        if self.dialog_config then
            local width = self.dialog_config.maxWidth
            self:_setCollectScaleByValue(endCoins, width)
        end
        self.collectRoot.labelWin:nrStartRoll(startCoins, endCoins, rollTime)
        self:dealMusic_playRollCoins()
    end

end
function cls:_initCollectEvent()
    self.isClick = false
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setEnabled(false)
            self:dealMusic_stopRollCoins()
            --self.theme:playMusic(self.theme.audio_list.common_click)
            --if not self.isCollect then
            --    self.isCollect = true
            self:clickCollectBtn()
            --self:hide()
            --end
        end
    end
    if self.collectRoot.btnCollect then
        self.collectRoot.btnCollect:addTouchEventListener(btnEvent)
    end
end
function cls:clickCollectBtn()
    if self.isClick then
        return
    end
    self.isClick = true
    if self.collectRoot.btnCollect then
        self.collectRoot.btnCollect:setTouchEnabled(false)
    end
    if self.collectRoot.labelWin then
        if self.collectRoot.labelWin.nrOverRoll then
            self.collectRoot.labelWin:nrOverRoll()
        end
        self.collectRoot.labelWin:setString(FONTS.format(self.fsData["coins"], true))
    end
    if self.fsData["click_event"] then
        self.fsData["click_event"]()
    end
    self:hide()
end
------------------------ choose dialog start --------------------------------
function cls:showChoose(pFsData, pEndCallFunc, parent)
    self.dialogType = fs_show_type.choose
    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["choose"]
    local initEventFunc = function()
        self:_initChooseEvent()
    end
    local intLayoutFunc = function()
        self:_initChooseLayout()
    end
    self:show(initEventFunc, intLayoutFunc, parent)
end
function cls:_initChooseEvent()
    self.isClick = false
    local function btnLeftEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setEnabled(false)
            self:clickChooseBtn(1)
            --self:hide()
            --end
        end
    end
    if self.chooseRoot.btnLeft then
        self.chooseRoot.btnLeft:addTouchEventListener(btnLeftEvent)
    end
    local function btnRightEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setEnabled(false)
            self:clickChooseBtn(2)
        end
    end
    if self.chooseRoot.btnRight then
        self.chooseRoot.btnRight:addTouchEventListener(btnRightEvent)
    end
end
function cls:_initChooseLayout()
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end
    self.chooseRoot:setVisible(true)
end
function cls:clickChooseBtn(index)
    if self.isClick then
        return
    end
    self.isClick = true
    if self.chooseRoot.btnLeft then
        self.chooseRoot.btnLeft:setTouchEnabled(false)
    end
    if self.chooseRoot.btnRight then
        self.chooseRoot.btnRight:setTouchEnabled(false)
    end
    if index == 1 then
        if self.fsData["click_left"] then
            self.fsData["click_left"]()
        end
    else
        if self.fsData["click_right"] then
            self.fsData["click_right"]()
        end
    end
    if self.fsData["click_event"] then
        self.fsData["click_event"]()
    end
    self:hide()
end
------------------------ choose dialog end--------------------------------

function cls:dealMusic_playRollCoins()

    if self.theme.dealMusic_playRollCoins then
        self.theme:dealMusic_playRollCoins()
    end
end
function cls:dealMusic_stopRollCoins()

    if self.theme.dealMusic_stopRollCoins then
        self.theme:dealMusic_stopRollCoins()
    end
end
return ThemeDialog
