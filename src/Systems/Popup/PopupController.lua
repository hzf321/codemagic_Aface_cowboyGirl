local PopupConfig               = require("Systems/Popup/PopupConfig")
local popup_dialog_config       = PopupConfig.popupDialogConfig

--这些弹窗不能被清掉，场景切换后也需要弹出来
local unclearPop = {
    -- ["booster_choose"] = 1,
}
-- 创建popup controller类来管理弹窗弹出逻辑
-- 逻辑1: 若弹窗不需要盖在其它弹窗上，加到队列的头或尾部，待当前弹窗关闭后再弹出；
-- 逻辑2: 若弹窗需要盖在其它弹窗上，直接弹出；
PopupController = class("PopupController")
function PopupController:ctor()
    self.popupList = BoleQueueStack.new()
    local function equal(a, b)
        if a and a.key and b and b.key then
            return (a.key == b.key)
        end

        return false
    end
    self.popupList:setSearchFunc(equal)
    self:reset()
end
function PopupController:reset()
    self.allowPopup    = false
    self.dialogCount   = 0
    self.dialogShow    = {}
    self.isProcessing  = false
    self.openNew       = false
end

function PopupController:getInstance( ... )
    if not self._instance then
        self._instance = PopupController.new()
    end
    return self._instance
end

---------------------弹窗数据处理-----------------------

-- 设置标志位，true：允许popup；false：不允许popup；
function PopupController:setPopupState(status)
    -- print("zhf ",debug.traceback())
    self.allowPopup = status
    if self.allowPopup then
        self:showPopupDialog()
    end
    
end

function PopupController:isAllowPopup( ... )
    return self.allowPopup
end

function PopupController:clear( ... )
    self:clearPopupList()
    self:setPopupState(false)
end

function PopupController:clearPopupList(clear_count)
    local tempData = {}
    if self.popupList then
        local cData = self.popupList:deQueue()
        while cData do
            if unclearPop[cData.key] then
                table.insert(tempData, cData)
            end
            cData = self.popupList:deQueue()
        end
        self.popupList:clear()
        if clear_count then
            self.dialogCount = 0
            self.dialogShow = {}
        end
        for _,data in pairs(tempData) do 
            self.popupList:push(data)
        end
    end
end

function PopupController:isPopupProcessing( ... )
    return (self.dialogCount > 0)
end

function PopupController:setDialog(key, dialog)
    if key and popup_dialog_config and popup_dialog_config[key] then
        popup_dialog_config[key].dialog = dialog
    end
end

function PopupController:showActions()
    -- 开始弹窗，引用计数+1
    self.dialogCount = self.dialogCount or 0
    self.dialogCount = self.dialogCount + 1

    if self.dialogCount == 1 then
        -- 暂停主题
        bole.pauseTheme()
    end

end

function PopupController:hideActions()
    -- 关闭弹窗，引用计数-1
    self.dialogCount = self.dialogCount or 0
    self.dialogCount = self.dialogCount - 1

    if self.dialogCount < 0 then
        self.dialogCount = 0
    end

    if self.dialogCount == 0 then
        if bole.__isWeb__ then
            if not self.showLoading then
                self.alreadyPauseTag = false
            end
        end

        -- 恢复主题
        bole.resumeTheme()

        -- 弹popup队列中未弹的弹窗
        self:showPopupDialog()

        -- if bole.inTheme() and self.dialogCount == 0 then
        --     -- 弹窗都关闭，恢复主题
        --     EventCenter:pushEvent(EVENTNAMES.THEME.RESUME_THEME)
        -- end
    end

end

function PopupController:addDialogToFront(popup_data)
    if self.popupList == nil then return end

    self.popupList:push(popup_data)
    self:showPopupDialog()
end

function PopupController:addDialogToRear(popup_data)
    if self.popupList == nil then return end

    self.popupList:enQueue(popup_data)

    self:showPopupDialog()
end

function PopupController:showPopupDialog( ... )
    -- print("zhf showPopupDialog ",self.allowPopup,self.dialogCount,self.popupList:isEmpty())
    if not self.allowPopup or self.dialogCount > 0 or self.popupList == nil or self.popupList:isEmpty() then return end
    local function callback( ... )
        
    end
    
    local popup_data = self.popupList:deQueue()
    print("showPopupDialog====",popup_data.key)

    local function realShowPopupDialog()
        local dialog = self:getPopupDialog(popup_data, nil)
        if dialog then
            local delay
            if popup_data.data and type(popup_data.data) == "table" and popup_data.data.delay then
                delay = popup_data.data.delay
            end
            self:setDialog(popup_data.key, dialog)
            dialog:show(delay)
        else
            if bole.__isWeb__ and self.alreadyPauseTag then
                self.alreadyPauseTag = false
                bole.resumeTheme()
            end

            self:showPopupDialog()
        end
    end

    if bole.__isWeb__ then
        self:checkWebResPreload(popup_data, function ()
            realShowPopupDialog()
        end)
    else
        realShowPopupDialog()
    end
end

-- 不考虑下载，需要确保list里的弹窗都是已下载的
function PopupController:getPopupDialog(popup_data, callback)
    if popup_data and popup_data.key and popup_dialog_config and popup_dialog_config[popup_data.key] and popup_dialog_config[popup_data.key].create_func then
        local function new_callback( ... )
            if popup_data.callback then
                popup_data.callback(...)
            end

            if callback then
                callback(...)
            end
        end
        return popup_dialog_config[popup_data.key].create_func(popup_data.key, popup_data.data, new_callback)
    end
    
end

function PopupController:getActivityData(popup_name)
    if popup_dialog_config and popup_dialog_config[popup_name] then
        local activityName = popup_dialog_config[popup_name].activity_name
        if activityName then
            return ActivityCenterControl:getInstance():getActivityDataByName(activityName)
        end
    end
    return nil
end

function PopupController:openPopupDialog(key, data, callback, isfront, show_func, onSuccess, onProgress, onError, force)
    key = key or "" 
    print("openPopupDialog====",key)
    if popup_dialog_config and popup_dialog_config[key] then
        local dialog_config = popup_dialog_config[key]
        local popup_data =
        {
            key           = key,
            download_type = dialog_config.download_type,
            download_key  = dialog_config.download_key,
            data          = data,
            callback      = callback,
        }

        -- 不需要下载弹窗
        if not self:downloadPopupDialog(popup_data, onSuccess, onProgress, onError, force) then
            -- 弹窗已打开
            if not libUI.isValidNode(dialog_config.dialog)
            or key == "byd_vault"
            or key == "byd_vault_open"
            or key == "byd_wild_depot"
            or key == "stamps_collect1"
            or key == "stamps_collect2"
            or key == "frenzy_vault_get"
            or key == "around_the_world_wildbag_dialog"
            or key == "store_blast_deluxe_stamp_wheel"
            or key == "store_blast_deluxe_byd_wheel"
            or key == "store_blast_deluxe_wheel"
            or key == "purchase_blast_deluxe_res"
            or key == "stamp_purchase_blast_deluxe_res"
            or key == "purchase_blast_deluxe_byd_res"
            or key == "frenzy_vault_collect_new_icon"
            or key == "purchase_blast_deluxe_atw_res" then
                if show_func then
                    local dialog = self:getPopupDialog(popup_data, nil)
                    if dialog then
                        self:setDialog(key, dialog)
                        show_func(dialog, true)
                        return
                    end

                    if bole.__isWeb__ then
                        if self.alreadyPauseTag then
                            self.alreadyPauseTag = false
                        end
                    end
                else
                    if key == "byd_vault"
                    or key == "byd_vault_open"
                    or key == "byd_wild_depot"
                    or key == "stamps_collect1"
                    or key == "stamps_collect2"
                    or self.popupList:searchElement(popup_data) == nil
                    or key == "frenzy_vault_get"
                    or key == "around_the_world_wildbag_dialog"
                    or key == "store_blast_deluxe_stamp_wheel"
                    or key == "store_blast_deluxe_byd_wheel"
                    or key == "store_blast_deluxe_wheel"
                    or key == "purchase_blast_deluxe_res"
                    or key == "stamp_purchase_blast_deluxe_res" 
                    or key == "purchase_blast_deluxe_byd_res" 
                    or key == "purchase_blast_deluxe_atw_res" then
                        if isfront then
                            self:addDialogToFront(popup_data)
                        else
                            self:addDialogToRear(popup_data)
                        end
                        return
                    end
                    
                end

            -- 调用已打开的弹窗
            else
                if show_func then
                    show_func(dialog_config.dialog, false)
                end
            end
        end
    end

    -- 若弹窗不存在（包括待下载）
    if callback then
        callback()
    end
    
end

function PopupController:downloadPopupDialog(popup_data, onSuccess, onProgress, onError, force)
    if popup_data and popup_data.download_type and popup_data.download_key then
        local download_controller = DownloadController:getInstance()
        local download_type       = popup_data.download_type
        local download_key        = popup_data.download_key
        if download_key == "theme" then
            download_key = popup_data.data.download_key
        end
        if download_key == "game_master" then
            local theme_id = ActivityCenterControl:getInstance():getActivityThemeID("game_master")
            if theme_id then
                download_key = download_key .. theme_id
            end
        end
        if download_key == "game_master_deal" then
            local theme_id = ActivityCenterControl:getInstance():getActivityThemeID("game_master_deal")
            if theme_id then
                download_key = download_key .. theme_id
            end
        end
        if download_key == "badge_challenge_new_game" or download_key == "badge_challenge_reward_new_game_popup" then
            local theme_id = ActivityCenterControl:getInstance():getActivityThemeID("badge_challenge_new_game")
            if theme_id then
                download_key = download_key .. theme_id
            end
        end
        if download_key == "tourn_cash_display"
        or download_key == "tourn_cash_final_day" then
            local theme_id = ActivityCenterControl:getInstance():getActivityThemeID("tourn_cash_display")
            if theme_id then
                download_key = download_key .. theme_id
            end
        end
        if download_type == DOWNLOAD_TYPE.HTTPRES then
            local activityData = self:getActivityData(popup_data.key)
            if download_controller:needDownloadVideo(activityData.videoUrl) then
                HttpRequest:getInstance():downloadVideo(activityData.videoUrl, onSuccess, false)
                return true
            end
        else
            if download_controller:needDownload(download_type, download_key) then
                -- 下载
                download_controller:download(download_type, download_key, onSuccess, onProgress, onError, force)
                return true
            end
        end
    end
    return false
end

-- 将弹窗加入popup队列队首
function PopupController:addDialogToPopupFront(key, data, callback)
    key = key or ""
    if popup_dialog_config and popup_dialog_config[key] and popup_dialog_config[key].add_front_func then
        popup_dialog_config[key].add_front_func(key, data, callback)
    else
        local function onSuccess( ... )
            PopupController:getInstance():openPopupDialog(key, data, callback, true, nil, nil, nil, nil, nil)
        end
        self:openPopupDialog(key, data, callback, true, nil, onSuccess, nil, nil, nil)
    end
end

-- 将弹窗加入popup队列队尾
function PopupController:addDialogToPopupTail(key, data, callback)
    key = key or ""
    if popup_dialog_config and popup_dialog_config[key] and popup_dialog_config[key].add_tail_func then
        popup_dialog_config[key].add_tail_func(key, data, callback)
    else
        local function onSuccess( ... )
            PopupController:getInstance():openPopupDialog(key, data, callback, false, nil, nil, nil, nil, nil)
        end
        self:openPopupDialog(key, data, callback, false, nil, onSuccess, nil, nil, nil)
    end
end

-- 直接弹弹窗，不管当前有没有其它弹窗
function PopupController:popupDialogDirectly(key, data, callback)
    key = key or ""
    print("popupDialogDirectly====",key)
    local function real_popupDialogDirectly()
        if popup_dialog_config and popup_dialog_config[key] and popup_dialog_config[key].popup_func then
            popup_dialog_config[key].popup_func(key, data, callback)
        else
            local delay = 0
            if data and data.delay then
                delay = data.delay
            end
            local function show_func(dialog, is_new)
                if libUI.isValidNode(dialog) then
                    if is_new then
                        dialog:show(delay)
                    end
                    
                end
            end
    
            local function onSuccess( ... )
                PopupController:getInstance():openPopupDialog(key, data, callback, false, show_func, nil, nil, nil, nil)
            end
    
            self:openPopupDialog(key, data, callback, false, show_func, onSuccess, nil, nil, nil)
        end
    end

    if bole.__isWeb__ then
        self:checkWebResPreload(PopupConfig.popupDialogConfig[key], function ()
            real_popupDialogDirectly()
        end)
    else
        real_popupDialogDirectly()
    end
end

function PopupController:checkWebResPreload(popupConfig, callback)
    if not bole.__isWeb__ then
        callback()
        return
    end
    
    popupConfig = popupConfig or {}

    local download_key = popupConfig['download_key']
    if download_key then
        self.showLoading = true
        if self.dialogCount == 0 then
            bole.pauseTheme()
        end

        -- self.alreadyPauseTag = true

        cc.LoadingLayer:create(download_key, function ()
            self.showLoading = false
            callback()
        end)
    end
end

function PopupController:getDialog(key)
   if popup_dialog_config and popup_dialog_config[key] and popup_dialog_config[key].dialog then
        return popup_dialog_config[key].dialog
    end
end

function PopupController:resetDialog(key)
   if popup_dialog_config and popup_dialog_config[key] and popup_dialog_config[key].dialog then
        popup_dialog_config[key].dialog = nil
    end
end

function PopupController:changeDownloadKey(key,downloadKey)
    if key and downloadKey then
        if popup_dialog_config and popup_dialog_config[key] and popup_dialog_config[key].download_key and popup_dialog_config[key].download_key == downloadKey then
            return 
        end
        popup_dialog_config[key].download_key = downloadKey
    end
end

function PopupController:setShowKey( key )
    self.lastShowKey = key
    self.dialogShow[key] = (self.dialogShow[key] or 0) + 1
end
function PopupController:setHideKey( key )
    self.lastHideKey = key
    if self.dialogShow[key] and self.dialogShow[key] > 0 then
        self.dialogShow[key] = self.dialogShow[key] - 1
        if self.dialogShow[key] <= 0 then
            self.dialogShow[key] = nil
        end
    end
end
function PopupController:checkListEmpty( tag )
    if self.dialogCount == 0 then
        return true
    else
        local showingCsb = nil
        local showingCount = 0
        local showingUserguide = false
        for k, v in pairs(self.dialogShow) do
            if v > 0 then
                if k == "userguide" then
                    showingUserguide = true
                else
                    showingCsb = k
                    showingCount = v
                end
            end
        end
        local data = {
            msg = "pop_not_empty",
            error = "pop_not_empty",
            tag = tostring(tag),
            dialogCount = tostring(self.dialogCount),
            dialogShow = tostring(table.nums(self.dialogShow)),
            showingCsb = tostring(showingCsb),
            showingCount = tostring(showingCount),
            showingUserguide = tostring(showingUserguide),
            lastShow = tostring(self.lastShowKey),
            lastHide = tostring(self.lastHideKey),
            hotV = HOTUPDATE_VERSION,
        }
        if showingCsb then
            if appDebugMode then
                bole.send_codeInfo(Splunk_Type.Error, data, false)
                libDebug.printTable("error checkListEmpty", data)
                libDebug.printTable("error checkListEmpty dialogShow", self.dialogShow)
                if a then
                    print(a.b)
                end
            else
                bole.send_codeInfo(Splunk_Type.Error, data, false)
            end
        end
        return false
    end
end

function PopupController:getDialogCount()
    local ret = self.dialogCount or 0
    return ret
end 

-- 动态添加popup弹窗配置，解决popupconfig文件过大问题
function PopupController:mergePopupConfig( configs )
    if popup_dialog_config and configs then
        for key, config in pairs(configs) do
            popup_dialog_config[key] = config
        end
    end
end

-- 弹窗配置分模块
function PopupController:reloadPopConfig( configs ) 
    popup_dialog_config = configs
end