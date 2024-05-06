
-- require "Systems/Lobby/LobbyLoading"

local LobbyThemeConfig            = require "Systems/Lobby/LobbyThemeConfig"
local theme_attributes            = LobbyThemeConfig.themeAttributes
local theme_config                = LobbyThemeConfig.themeConfig

local loungeStartId = 600
local normalStartId = 100
local lobbyPageColCnt = 4
local lobbyPageRowCnt = 2

local EVENT_KEY_EXIT_THEME = "lobby_theme_controller"
LobbyThemeControl = class("LobbyThemeControl")

function LobbyThemeControl:ctor()
	self.currentThemeId       = -1
	self.rets =
	{
	}
	self:resetThemeData()
	self:reset()
	EventCenter:registerEvent(EVENTNAMES.THEME.ALLOW_QUIT_THEME,EVENT_KEY_EXIT_THEME, self.onAllowEnterTheme, self)
end
function LobbyThemeControl:reset()
	self.currentThemeId = -1

    self.normalThemeList = nil
    self.themeInfoIndex = nil
    -- self.highThemes = nil

    self.pressTime = nil
    self.advertiseNodeList = nil
    self.showGiftTips = nil
    -- self.highThemeList = nil
    -- self.ui = nil
    self.lockedTheme = nil
    self.themeInfo = nil
    self.storeGameThemeID = nil
    self.preloadSpineList = nil
    self.touchThemeId = nil
    self.highUnlockList = nil
	self.curThemeList	= nil
	self.dealListConfig = nil
	self.lobbyAdvInfoCount = 0
end

function LobbyThemeControl:canPlayLoungeMode()
	if(LobbyControl:getInstance():isLoungeLobby()) then
		return true
	else
		return false
	end
end

function LobbyThemeControl:getInstance( ... )
	if not self._instance then
		self._instance = LobbyThemeControl.new()
	end
	return self._instance
end

function LobbyThemeControl:canPlay(status,themeid)
	if status == nil or (status and (status == theme_attributes.NewTheme or status == theme_attributes.Normal or status == theme_attributes.Hot or (status == theme_attributes.NeedUpdate and not self:isNeedAppUpdate(themeid)))) then
		return true
	end
	if status ~= nil and status == theme_attributes.Recommend then
		return true
	end
	return false
end

function LobbyThemeControl:canPlayByID(themeid)
	if themeid then
		local theme_data = self:getThemeData(themeid)
		return self:canPlay(theme_data.attribute, themeid)
	end
	return false
end


-- function LobbyThemeControl:setUpdateThemeInfoTag(tag)
-- 	self.update_theme_info_tag = tag
-- end

-- function LobbyThemeControl:getUpdateThemeInfoTag()
-- 	return self.update_theme_info_tag
-- end

function LobbyThemeControl:onEnterLobby(data)

	-- 是否开放所有theme
	if data['is_total_open_to_all'] == 1 then
		TOTAL_OPEN_TO_ALL = true
	end
	TOTAL_OPEN_TO_ALL = true
	if data.theme_info then
		-- local themes = {}
		-- for k, v in ipairs(data.theme_info.normal) do
		-- 	table.insert(themes, v.theme_id)
		-- end
		self:updateThemeInfo(data.theme_info)
		-- self:setUpdateThemeInfoTag(1)
		self:refreshLobbyThemeView(true)
	end

	self.currentThemeId = -1
	if data["jp_data"] then
		JackpotControl:getInstance():setJackpotData(data["jp_data"])
		JackpotControl:getInstance():resetPreJackpotData()
	end
	if data and data.ft_need_level then
		self:setFavoriteNeedLevel(data.ft_need_level)
	end
end

function LobbyThemeControl:onLogin(data)
	self:setFavoriteData(data)
	self:setGameOpenToAllFlag(data)
end

-- about favorite
function LobbyThemeControl:setFavoriteData(data)
	if data and data.favourite_theme then
		if data.favourite_theme and data.favourite_theme.most_play then
			self:setMostPlayData(data.favourite_theme.most_play)
		end
		if data.favourite_theme and data.favourite_theme.near_bonus then
			self:setNearBonusData(data.favourite_theme.near_bonus)
		end
	end
end

function LobbyThemeControl:setMostPlayData(data)
	self.most_play_data = data
end

function LobbyThemeControl:getMostPlayData()
	return self.most_play_data
end

function LobbyThemeControl:setNearBonusData(data)
	self.near_bonus_data = data
end

function LobbyThemeControl:getNearBonusData()
	return self.near_bonus_data
end

function LobbyThemeControl:setFavoriteNeedLevel(data)
	self.ft_need_level = data
end

function LobbyThemeControl:getFavoriteNeedLevel()
	return self.ft_need_level or 50
end

function LobbyThemeControl:canFavoriteShow()
	return User:getInstance().level >= self:getFavoriteNeedLevel() and not UserGuideControl:getInstance():isNewUser()
end

function LobbyThemeControl:getFavoriteNum()
	local num = 0
	if not IS_CHECK and self:canFavoriteShow() and self:getMostPlayData() and self:getNearBonusData() and self.themeData and self.themeData.themeIDs and #self.themeData.themeIDs > 0 then
		num = 2
	end
	return num
end

-- 侧边栏相关
function LobbyThemeControl:getSiderBarThemeList(index)
	if not index then return end

	-- return THEME_FEATURE_CLASS[index] or {}
	local sider_bar_list = {}
	if self.themeData and self.themeData.themeIDs then
		local tag_list = THEME_FEATURE_CLASS[index] or {}
		for i, theme_id in pairs(self.themeData.themeIDs) do
			if not self:isValueExist(sider_bar_list, theme_id) and self:isValueExist(tag_list, theme_id) then
				if theme_id < loungeStartId and self:canPlayLoungeMode() then 
					theme_id = theme_id + loungeStartId - normalStartId 
				end
				sider_bar_list[#sider_bar_list + 1] = theme_id
			end
		end
	end

	return sider_bar_list

	-- local tag_name_list = {
	-- 	[1] = "main_list",
	-- 	[2] = FEATURE_CLASS.ULTRA_RESPIN,
	-- 	[3] = FEATURE_CLASS.EPIC_LINK,
	-- 	[4] = FEATURE_CLASS.RAPID_PAY,
	-- 	[5] = FEATURE_CLASS.LUCKY_PUZZLE,
	-- 	-- [6] = FEATURE_CLASS.LUCKY_PUZZLE2,
	-- 	[6] = FEATURE_CLASS.SUPER_BONUS,
	-- }

	-- local bar_tag = tag_name_list[index] or ""

	-- local sider_bar_list = {}

	-- if self.themeData and self.themeData.themeIDs then
	-- 	for i, theme_id in pairs(self.themeData.themeIDs) do
	-- 		local theme_config = self:getLobbyThemeConfigList(theme_id) or {}
	-- 		if theme_config.feature_classes then
	-- 			if self:isValueExist(theme_config.feature_classes, bar_tag) then
	-- 				if not self:isValueExist(sider_bar_list, theme_id) then
	-- 					if theme_id < loungeStartId and self:canPlayLoungeMode() then 
	-- 						theme_id = theme_id + loungeStartId - normalStartId 
	-- 					end
	-- 					sider_bar_list[#sider_bar_list + 1] = theme_id
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- return sider_bar_list
end

function LobbyThemeControl:isValueExist(table, value)
	if table and value then
		for i, v in pairs(table) do
			if v == value then
				return true
			end
		end
	end

	return false
end

function LobbyThemeControl:showCurrentClass(index)
	if bole.isValidNode(self.ui) then
		self.ui:showCurrentClass(index)
	end
end

function LobbyThemeControl:setGameOpenToAllFlag(data)
	if data.game_open_to_all then
		if data.game_open_to_all == 1 then
			TOTAL_OPEN_TO_ALL = true
		else
			TOTAL_OPEN_TO_ALL = false
		end
	end
end

function LobbyThemeControl:getLobbyPageColCnt()
	return lobbyPageColCnt
end

function LobbyThemeControl:getLoungeStartId()
	return loungeStartId
end

function LobbyThemeControl:getNormalStartId()
	return normalStartId
end

function LobbyThemeControl:isHighlimitTheme(themeid)
	if themeid > 2000 then
		return false
	end
	return themeid > loungeStartId
end

function LobbyThemeControl:getNormalThemeIDbyID(themeid) -- 通过高级房主题ID获得普通房主题id
	if themeid then
		themeid = tonumber(themeid)
		if appDebugMode and themeid > 2000 then
			return themeid
		end
		if themeid > loungeStartId then
			return themeid - loungeStartId + normalStartId
		else
			return themeid
		end
	end
end

-- 重新排序机台列表，将广告主题id机台插入到第二位,解锁等级设置为1
function LobbyThemeControl:sortThemeInfo()
	local ad_theme_id = User:getInstance().ad_theme_id

	local sortCall = function(theme_list)
		for k, v in pairs(theme_list) do
			if v.theme_id == ad_theme_id and k > 2 then
				local temp = table.remove(theme_list, k)
				if temp.need_level then
					temp.need_level = 1
				end
				table.insert(theme_list, 2, temp)
				break
			end
		end
	end

	if ad_theme_id ~= 0 then
		sortCall(self.normalThemeList)
		sortCall(self.highThemeList)
	end
end

function LobbyThemeControl:updateThemeInfo(data)
	self.themeInfoIndex  = self.themeInfoIndex or 0
	self.themeInfoIndex  = self.themeInfoIndex + 1
	self.highThemeList   = data.high or {}
	self.normalThemeList = data.normal or {}
	self:sortThemeInfo()

	self.highThemes      = {}
	self.highUnlockList  = {}
	local user_level     = User:getInstance().level or 1

	for i=1, #self.highThemeList do
		local theme_data = self.highThemeList[i]
		local need_level = theme_data.need_level or 1
		self.highThemes[theme_data.theme_id] = theme_data

		if TOTAL_OPEN_TO_ALL or self:canPlayLoungeMode() and self:canPlay(theme_data.attribute,theme_data.theme_id) then
			self.highUnlockList[#self.highUnlockList + 1] = theme_data.theme_id
		end
	end

	self:updateThemeData()
end

function LobbyThemeControl:getThemeInfoIndex( ... )
	return self.themeInfoIndex or 0
end

function LobbyThemeControl:initLockedThemes( info )
	self.lockedTheme = {}
	for k,v in pairs(info) do 
		if v.need_level > User:getInstance().level then
			table.insert(self.lockedTheme, {id = v.theme_id, lv = v.need_level})
		end
	end
	table.sort(self.lockedTheme, function(a, b)
		return a.lv < b.lv
	end)
end

--获取已解锁的机台
function LobbyThemeControl:getUnLockedThemes()
	local unlockedThemes = {}

	local bet, tid = UserGuideControl:getInstance():getCurrentThemeData()

	for i = 1, #self:getCellThemeIdData() * 4 do
		local themeId = self:getCellThemeID(i) 
		for j = 1, #themeId do
			local theme_id           = themeId[j]
			local isComingSoon       = self:isComingSoon(theme_id)
			local isUnderMaintenance = self:isUnderMaintenance(theme_id)
			local isNaturalThemeOpen = self:isNaturalThemeOpen(theme_id)
			local need_level         = self:getNeedLevel(theme_id)
			if need_level <= User:getInstance().level and not (isComingSoon or isUnderMaintenance) and not isNaturalThemeOpen then
				--当前新手任务的机台，不加入到锦标赛机台列表里去
				theme_id = LobbyThemeControl:getInstance():getNormalThemeIDbyID(theme_id)
				if theme_id ~= tid then
					table.insert(unlockedThemes, theme_id)
				end
			end
		end
	end

	-- for k,v in pairs(self.themeInfo) do 
	-- 	local isComingSoon = self:isComingSoon(v.theme_id)
	-- 	local isUnderMaintenance = self:isUnderMaintenance(v.theme_id)
	-- 	local isNaturalThemeOpen = self:isNaturalThemeOpen(v.theme_id)
	-- 	if v.need_level <= User:getInstance().level and not (isComingSoon or isUnderMaintenance) and not isNaturalThemeOpen then
	-- 		table.insert(unlockedThemes, v.theme_id)
	-- 	end
	-- end
	return unlockedThemes
end

function LobbyThemeControl:getJackpotConfigList(tid)
	if theme_config and theme_config[tid] and theme_config[tid].jpLoading then
		return theme_config[tid].jpLoading
	end
end

function LobbyThemeControl:getLobbyThemeConfigList(tid)
	if theme_config and theme_config[tid] and theme_config[tid].lobbyConfig then
		return theme_config[tid].lobbyConfig
	end
end

function LobbyThemeControl:needDownloadTheme(themeid, is_big)
	local needDownloadList = self:getNeedDownloadThemeList(themeid, is_big)
	local len = #needDownloadList
	return len > 0 
end

function LobbyThemeControl:getNeedDownloadThemeList(themeid, is_big)
	local downloadList   = {}
	local downKey        = tostring(themeid)
	local down_type_enum = DOWNLOAD_TYPE.THEMELOADING
	local downloadCtl    = DownloadController:getInstance()
	local _priority_data

	if downloadCtl:needDownload(down_type_enum, downKey) then
		downloadList[#downloadList + 1] = {
			down_type_enum = down_type_enum, 
			down_key = downKey,
			priority_data = _priority_data
		}
	end

	local languageCtl = LanguageController:getInstance()
	local language_key = languageCtl:getLanguageKey()
	local languageDownKey = nil
	-- 手动切换多语言 不考虑多语言下载逻辑
	-- 没有手动切换多语言 则说明登录就是多语言 需要考虑多语言下载情况
	local addLanguageDownKey = not languageCtl:isChangedLanguage()
    if language_key ~= LANGUAGE.ENGLISH and addLanguageDownKey then
		local res_key = languageCtl:_getLanguageResKey(language_key)
		local down_key = string.format("%s_%s", downKey, res_key)
		if downloadCtl:needDownload(down_type_enum, down_key) then
			languageDownKey = {
				down_type_enum = down_type_enum, 
				down_key = down_key,
				priority_data = {
					priority = DOWNLOAD_PRIORITY.NORMAL, -- 将多语言下载优先级提高
					order = 0,
				}
			}
			downloadList[#downloadList + 1] = languageDownKey
		end
	end
	return downloadList
end

function LobbyThemeControl:downloadThemeLoadingRes(themeid, config)
	local downloadList = self:getNeedDownloadThemeList(themeid, config.isBig)
	local downloadListLen = #downloadList
	local finish_count = 0
	local function onSuccess()
		finish_count = finish_count + 1
		if finish_count == downloadListLen then
			if config.onSuccess then
				config.onSuccess()
			end
		end
	end

	for index, downloadMsg in pairs(downloadList) do 
		DownloadController:getInstance():downloadRes({
			resType = downloadMsg.down_type_enum,
			resKey = downloadMsg.down_key,
			onSuccess = onSuccess,
			cbKey = config.cbKey,
			priority_data = downloadMsg.priority_data,
		})
	end

end

function LobbyThemeControl:needPreload(themeid)
	themeid = themeid or 0
	self.preloadSpineList = self.preloadSpineList or {}
	return not self.preloadSpineList[themeid]
end

function LobbyThemeControl:preloadLogoSpine(themeid, png, callback)
	self.preloadSpineList = self.preloadSpineList or {}
	if themeid then
		if png == nil then
			self.preloadSpineList[themeid] = true
		else
			if not self.preloadSpineList[themeid] then

				local function call_func( ... )
					self.preloadSpineList = self.preloadSpineList or {}
					self.preloadSpineList[themeid] = true
					if callback then
						callback()
					end
				end
				libMM.loadTextureAsync(png, call_func)
				libMM.loadTextureAsync(string.format("theme_loading/theme%d/logo/logo.png", themeid), nil)

			end
		end
	end	
end

------------------LobbyMain相关接口-------------------------

function LobbyThemeControl:setUI(ui)
	self.ui = ui
end

function LobbyThemeControl:closeUI()
	if self.ui then
		self.ui = nil
	end
end

function LobbyThemeControl:clearAdvertiseNode( ... )
	if self.advertiseNodeList then
		self.advertiseNodeList = nil
	end
end

function LobbyThemeControl:loadUI(enter_theme)
	local callback = function ()
		self:saveLobbyViewPos()
		
		self.ui:loadTheme(enter_theme)
	end
	performWithDelay(self.ui, callback, 0)
end

function LobbyThemeControl:refreshActivityView( ... )
	if bole.isValidNode(self.ui) then
		self.ui:refreshActivityView()
	end
end

function LobbyThemeControl:refreshLobbyThemeView(is_theme)
	if bole.isValidNode(self.ui) then
		self.ui:updateTableView(is_theme)
	end
end

function LobbyThemeControl:reSetPosLobbyThemeView(pos_x, action_tag)
	if bole.isValidNode(self.ui) then
		self.ui:saveTableViewOffset(pos_x)
		self.ui:updateTableViewOffset(action_tag)
	end
end

function LobbyThemeControl:saveLobbyViewPos()
	if bole.isValidNode(self.ui) then
		self.ui:saveTableViewOffset()
	end
end

function LobbyThemeControl:saveUnlockThemePos(pos_x)
	if not pos_x then return end

	local is_lounge = LobbyControl:getInstance():isLoungeAvailable()
	if is_lounge then
		SAVED_LOUNGE_OFFSET = pos_x
	else
		SAVED_LOBBY_OFFSET = pos_x
	end
end

function LobbyThemeControl:enableScreenTouches(enable)
	if bole.isValidNode(self.ui) then
		self.ui:enableScreenTouches(enable)
	end
end

---------------------Theme数据相关接口-----------------------

function LobbyThemeControl:resetThemeData()
	-- 存放theme数据：self.themeData[1]——lobby数据，self.themeData[2]——favorite数据，self.themeData[3]——VIP数据
	self.themeData = {}
	self.themeData.themes = {}
	self.themeData.themeIDs = {}
	self.themeData.cellIDs = {}
	self.themeData.unlockThemeIDs = {}

	self.themeData.cellBigIDs = {}
end

function LobbyThemeControl:getHighlimitThemeList() -- 暂时弃用  lobbyPageColCnt

	local highList = {}

	for k = 1, #self.highThemeList do
		local list_count = #highList
		local config2 = highList[list_count] and highList[list_count][lobbyPageColCnt] and highList[list_count][lobbyPageColCnt][lobbyPageRowCnt] -- 上一个table是否被填满

		if list_count == 0 or config2 then -- 是否需要创建一个新的table
			highList[list_count + 1] = {}
			for i = 1, lobbyPageColCnt do
				highList[list_count + 1][i] = {}
			end
			highList[list_count + 1][1][1] = self.highThemeList[k]
		elseif highList[list_count] then
			for i = 1, lobbyPageRowCnt do
				local hasRoom = false
				for j = 1, lobbyPageColCnt do
					if not highList[list_count][j][i] then
						highList[list_count][j][i] = self.highThemeList[k]

						hasRoom = true
						break
					end
				end
				if hasRoom then
					break
				end
			end
		end
	end
	return highList
end

function LobbyThemeControl:updateThemeData()

	self:resetThemeData()

	self.themeInfo = {}

	self.normalThemeList = self.normalThemeList or {}
	for i=1, #self.normalThemeList do
		self.themeInfo[#self.themeInfo + 1] = self.normalThemeList[i]
	end

	if self:canPlayLoungeMode() then
		for k,v in pairs(self.highThemeList) do
			self.themeInfo[#self.themeInfo + 1] = v
		end
	end

	self.themeInfo = self.themeInfo or {}
	for k, v in pairs(self.themeInfo) do
		self:setThemeData(k, v)
		if self:isRecommend(v) and not IS_CHECK then -- DES_BIG_THEME
			if bole.isNormalThemeId(v.theme_id) then
				self:setLobbyBigThemeData(k, v)
			end
		else
			if v.theme_id < loungeStartId and v.theme_id > normalStartId then
				self:setLobbyThemeData(v)
			end
			if appDebugMode and  v.theme_id> 2000 then
				self:setLobbyThemeData(v)
			end
		end
	end
end

function LobbyThemeControl:setThemeData(index, data)
	if index == nil or data == nil or data.theme_id == nil then return end
	
	-- 存储theme data和ID
	local id = data.theme_id
	self.themeData.themeIDs[index] = id
	self.themeData.themes[id] = data
	if id > loungeStartId then
		local normalid =id
		if id < 2000 then
			 normalid = id - loungeStartId + normalStartId
		end
		if(self.themeData.themes[id] and self.themeData.themes[normalid]) then
			self.themeData.themes[id].attribute = self.themeData.themes[normalid].attribute
			self.themeData.themes[id].need_level = self.themeData.themes[normalid].need_level
		end

	end

end

function LobbyThemeControl:setLobbyThemeData(data)
	local id = data.theme_id
	if data.theme_id < 2000 then
		 id = self:canPlayLoungeMode() and (data.theme_id + loungeStartId - normalStartId) or data.theme_id
	end
	-- 存储解锁的theme ID
	local unlockIndex = #self.themeData.unlockThemeIDs
	local user_level = User:getInstance().level or 1
	local need_level = data.need_level or 1

	if TOTAL_OPEN_TO_ALL or user_level >= need_level or ActivityCenterControl:getInstance():isGameMasterDealTheme(id) or WeekendTournamentController:getInstance():isWeekTourTheme(id) then
		if self:canPlay(data.attribute,data.theme_id) then
			self.themeData.unlockThemeIDs[unlockIndex+1] = id
		end
	end

	local lastIndex = #self.themeData.cellIDs -- 6个一组的数组
	local isLastCellFull = self.themeData.cellIDs[lastIndex] and self.themeData.cellIDs[lastIndex][lobbyPageColCnt] and  self.themeData.cellIDs[lastIndex][lobbyPageColCnt][lobbyPageRowCnt] -- 上一个table是否被填满
	if not(self.themeData.cellIDs[lastIndex]) or isLastCellFull then
		self.themeData.cellIDs[lastIndex + 1] = {}
		for i = 1, lobbyPageColCnt do
			self.themeData.cellIDs[lastIndex + 1][i] = {}
		end
		self.themeData.cellIDs[lastIndex + 1][1][1] = id
	elseif self.themeData.cellIDs[lastIndex] then
		for i = 1, lobbyPageRowCnt do 
			local hasRoom = false
			for j = 1, lobbyPageColCnt do 
				if not self.themeData.cellIDs[lastIndex][j][i] then
					self.themeData.cellIDs[lastIndex][j][i] = id
					hasRoom = true
					break
				end
			end
			if hasRoom then
				break
			end
		end
	end
end

function LobbyThemeControl:getBetGroupData(themeid, index)
	return self.themeData.themes[themeid].bet_group[index]
end

function LobbyThemeControl:getThemeData(themeid)
	if themeid and self.themeData and self.themeData.themes and self.themeData.themes[themeid] then
		return self.themeData.themes[themeid]
	end
	return {}
end

function LobbyThemeControl:getHighThemeData(themeid)
	return (self.highThemes or {})[themeid]
end

function LobbyThemeControl:getCellThemeID(index)

	if self.themeData.cellBigIDs and self.themeData.cellBigIDs[index] then -- DES_BIG_THEME
		return self.themeData.cellBigIDs[index]
	else
		local big_num = self:getBigNumByIndex(index) -- DES_BIG_THEME
		local temp_index_1 = math.ceil((index - big_num) / lobbyPageColCnt) -- DES_BIG_THEME
		local temp_index_2 = (index - big_num) % lobbyPageColCnt -- DES_BIG_THEME
		if temp_index_2 == 0 then
			temp_index_2 = lobbyPageColCnt
		end
		return ((self.themeData.cellIDs or {})[temp_index_1] or {})[temp_index_2]
	end
end

function LobbyThemeControl:getCellThemeIdData()
	return self.themeData.cellIDs
end

function LobbyThemeControl:updateThemeUnlockData(data)
	if not data then return end

	local user_level = User:getInstance().level or 0
	local min_level = ActivityCenterControl:getInstance():getNewUserThemeAcMinLv()
	local max_level = ActivityCenterControl:getInstance():getNewUserThemeAcMaxLv()
	local tbl_num = #data or 0
	if user_level >= min_level and user_level <= max_level and tbl_num == 4 then
		ActivityCenterControl:getInstance():setNewUserThemeAc(data)
	end
end

function LobbyThemeControl:isInTheTheme(theme_id, enter_id)
	local tag = false
	if theme_id and enter_id then
		local lounge_theme_id = theme_id + loungeStartId - normalStartId
		if theme_id == enter_id or lounge_theme_id == enter_id then
			tag = true
		end
	end
	return tag
end

-- function LobbyThemeControl:getThemeStyle(themeid )
-- 	return self.themeData.themes[themeid].theme_style
-- end

function  LobbyThemeControl:getThemeCount()
	return #self.themeData.themeIDs
end

function LobbyThemeControl:getThemeId(index)
	return self.themeData.themeIDs[index]
end

-- function LobbyThemeControl:getThemeDataByIdx(index)
-- 	local themeId = self:getThemeId(index)
-- 	return self:getThemeData(themeId)
-- end

function LobbyThemeControl:getNeedJackpot (themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	return ((data.jackpot or -1) == 1)
end

function LobbyThemeControl:getNeedLevel(themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return 99999999 end
	return data.need_level or 99999999
end

-- function LobbyThemeControl:isHighlimit(themeId)
-- 	local data = self:getThemeData(themeId)
-- 	if not data then data = self:getHighThemeData(themeId) end
-- 	if not data then return false end
-- 	if not data.high_limit then return false end
-- 	return (data.high_limit == 1)
-- end

function LobbyThemeControl:isNewGame(themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.NewTheme)
end

function LobbyThemeControl:isComingSoon(themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.ComingSoon)
end

function LobbyThemeControl:isHotGame(themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.Hot)
end

function LobbyThemeControl:isOnlyInQuest (themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.OnlyInQuest)
end

function LobbyThemeControl:isUnderMaintenance (themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.Maintainess)
end

function LobbyThemeControl:isNeedUpdate (themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.NeedUpdate)
end

function LobbyThemeControl:isNeedAppUpdate(themeId)
	local data = self:getThemeData(themeId)
	if not data then data = self:getHighThemeData(themeId) end
	if not data then return false end
	if not data.attribute then return false end
	if data.attribute == theme_attributes.NeedUpdate then
		if LoginControl:getInstance():needUpdate() then
			return true
		end
		return false
	else
		return false
	end
end

function LobbyThemeControl:isRecommend(data)
	if not data then return false end
	if not data.attribute then return false end
	return (data.attribute == theme_attributes.Recommend)
end

function LobbyThemeControl:isThemeOpen(themeId)
	local theme = self:getThemeData(themeId)
	if not theme then return false end
	if TOTAL_OPEN_TO_ALL then return true end
	if theme.enable then return true end -- force enable, when in first page

	if ActivityCenterControl:getInstance():isGameMasterDealTheme(themeId) and not IS_CHECK then
		return true
	end

	if WeekendTournamentController:getInstance():isWeekTourTheme(themeId) and not IS_CHECK then
		return true
	end

	return User:getInstance().level >= self:getNeedLevel(themeId)

end

function LobbyThemeControl:isNaturalThemeOpen(themeId)
	local theme = self:getThemeData(themeId)
	if not theme then return false end

	if theme.nu_visible then
		return IS_CHECK and theme.nu_visible ~= 1
	else
		return IS_CHECK
	end
end

function LobbyThemeControl:downloadSuccessful(themeId)
	local data = self:getThemeData(themeId)
	if not data then return end

	data.resource_version = nil
end

function LobbyThemeControl:getThemeIds()
	if self.themeData and self.themeData.themeIDs then
		return self.themeData.themeIDs
	end
end

--------------------Theme下载删除相关接口---------------------

function LobbyThemeControl:removeThemeResouces (themeid)
	local tempRoot = cc.FileUtils:getInstance():getWritablePath()..Config.cachedir.."/"
    local picRoot = tempRoot.."theme_resource/theme"..themeid
   	if cc.FileUtils:getInstance():isDirectoryExist(picRoot) then
    	local download_controller = DownloadController:getInstance()
        download_controller:clearMD5(3, tostring(THEME_LIST[themeid]['resourceId']))
        cc.FileUtils:getInstance():removeDirectory(picRoot)
    end
end

function LobbyThemeControl:loadPlayedThemes()
	-- LoginControl:getInstance():clearPlayedThemes()
	if not self.playedThemeList then
		self.UpdatedThemeList = {}
		self.playedThemeList = {}
		local items = LoginControl:getInstance():loadPlayedThemes() or {}
		local tempList = {}
		local itemsLen = #items
		for i=itemsLen, 1, -1 do
			local item = items[i]
			if item then
				if not tempList[item.themeId] then
					tempList[item.themeId] = 1
					table.insert(self.playedThemeList,1,item)
				end
			end
		end
		-- self.playedThemeList = LoginControl:getInstance():loadPlayedThemes() or {}
		-- print("zhf loadPlayedThemes  ",tool.lua_to_json(self.playedThemeList))
		-- print("zhf tempList  ",tool.lua_to_json(tempList))
	end
end

function LobbyThemeControl:savePlayedTheme(themeId)
	if self.playedThemeList then
		local current_time = bole.getServerTime()
		themeId = THEME_LIST[themeId]['resourceId']
		-- print("zhf current_time ", themeId, current_time)
		local newItem = {["themeId"] = themeId,["time"] = current_time}
		self.UpdatedThemeList[themeId] = current_time
		local item = self.playedThemeList[1]
		if not item then
			-- print("zhf has no item ")
		else
			local lastInTime = item.time
			local lastThemeId = item.themeId
			local lastIndex = 1
			-- print("zhf lastThemeId ",lastThemeId)

			if lastThemeId == themeId then
				table.remove(self.playedThemeList,lastIndex)
			else
				-- 7*24*3600*1000 =  
				if current_time - lastInTime > 604800000 then
					table.remove(self.playedThemeList,lastIndex)
					if not self.UpdatedThemeList[lastThemeId] then
						self:removeThemeResouces(lastThemeId)
					end
				end
			end

		end
		table.insert(self.playedThemeList,newItem)
		LoginControl:getInstance():SavePlayedThemes(self.playedThemeList)
		-- print("zhf loadPlayedThemes  ",tool.lua_to_json(self.playedThemeList))
	end
end

function LobbyThemeControl:removeNotPlayThemes()
    local theme_list = THEME_LIST
    local current_time = math.floor(bole.getServerTime() / 1000)
    for i, v in pairs(theme_list) do
    	if i and v and v.resourceId then
    		local theme_last_time = libMM.getIntegerForKey("playing_theme_time_" .. i, current_time)
    		local diff = (current_time - theme_last_time) / 3600 / 24 / 20
    		if theme_last_time and diff > 1 then
    			self:removeThemeResouces(v.resourceId)
    		end
    	end
    end
end


--------------------屏幕点击相关接口-------------------------
function LobbyThemeControl:setSiderBarNodeIndex(index)
	self.siderBarNodeIndex = index
end

function LobbyThemeControl:getSiderBarNodeIndex()
	return self.siderBarNodeIndex
end

function LobbyThemeControl:setSiderBarListIndex(index)
	self.siderBarListIndex = index
end

function LobbyThemeControl:getSiderBarListIndex()
	return self.siderBarListIndex
end

function LobbyThemeControl:getThemeLoadingList()
	local theme_list = self.themeData.unlockThemeIDs or {}
	local choose_list = {}

	local siderBarNodeIndex = self:getSiderBarNodeIndex()
	if siderBarNodeIndex then
		local index = self:getSiderBarListIndex()
		local total_choose_list = self:getSiderBarThemeList(index) or {}

		for i, v in pairs(total_choose_list) do
			if self:isValueExist(theme_list, v) then
				choose_list[#choose_list + 1] = v
			end
		end
	else
		choose_list = theme_list
	end

	return choose_list
end

function LobbyThemeControl:clickLobbyTheme(themeid, from_lounge, from, is_near_bonus_low)

	LoginControl:getInstance():checkIsRestrictUser()
	
	local unlock_list = self:getThemeLoadingList()

	if themeid < loungeStartId and self:canPlayLoungeMode() then themeid = themeid + loungeStartId - normalStartId  end

	local hasTheme = false
	for k,v in pairs(unlock_list) do
		if v == themeid then
			hasTheme = true
			break
		end
	end
	if hasTheme then
		from = from or "unknow"
		PopupController:getInstance():popupDialogDirectly("theme_loading", {node = self, themeid = themeid, theme_data = unlock_list,from = from, is_near_bonus_low = is_near_bonus_low}, nil)
	end
end

function LobbyThemeControl:touchThemeBegan (themeid)
	self.touchThemeId = themeid
	self.pressTime = 0
end

function LobbyThemeControl:touchThemeMoved()
	-- self.pressTime = 0
	self.touchThemeId = nil
end

function LobbyThemeControl:touchThemeCancelled (themeid)
	self.touchThemeId = nil
	self.pressTime = 0
end

function LobbyThemeControl:touchThemeEnded(themeid)
	self.touchThemeId = nil
	self.pressTime = 0
end

function LobbyThemeControl:enterTheme(themeid, from, bet, is_quest, is_mansion, is_mansion_tournament)
	-- 如果当前机台正在新手任务当中，则进入新手任务
	local function doEnterTheme()
		if is_quest ~= 1 and is_mansion ~= 1 and is_mansion_tournament ~= 1 and UserGuideControl:getInstance():isUGQAvailable() then
			local bet, tid = UserGuideControl:getInstance():getCurrentThemeData()
			if themeid == tid then
				UserGuideControl:getInstance():enterTheme()
				return
			end
		end

	local data = {}
	data.from = EVENT_KEY_EXIT_THEME
	data.info = {}
	data.info.themeid = themeid
	data.info.from = from
	data.info.bet = bet
	data.info.is_quest = is_quest
	data.info.is_mansion = is_mansion
	data.info.is_mansion_tournament = is_mansion_tournament
	if self:isNeedCheckThemeID() then
		EventCenter:pushEvent(EVENTNAMES.THEME.ASK_QUIT_THEME, data)
	else
		self:onAllowEnterTheme(data)
	end

		PopupController:getInstance():clearPopupList()
	end

	if bole.__isWeb__ then
		-- 加载主题代码
		local function loadThemeCode ()
			cc.loader.loadJs('', cc.g_themeCodes, function ()
				-- 进入主题
				doEnterTheme()
			end)
		end

		-- 资源id
		local resourceId = THEME_LIST[themeid]['resourceId']
		-- ThemeResource.js路径
		local jsThemeResource = "theme_loading/theme" .. resourceId .. "/src/ThemeResource.js"
		-- 资源json路径
		local resJson = "theme_loading/theme" .. resourceId .. "/_res_json.txt"

		-- 加入新手预加载列表
		-- if self:getIsGameMasterThemeId(themeid) and UserGuideControl:getInstance():getNewUserGmGuideIndex() <= 5 then
		-- 	table.insert(cc.themePreloadList, "userguide_gm/_res_json.txt")
		-- end

		-- web主题资源列表
		local webThemeSideResList = ActivityThemeController:getInstance():getWebThemeSideResList(themeid)
		-- table.merge(webThemeSideResList, {"common_theme/paytable/ui/paytable_v.js", "common_theme/paytable/ui/page_v.js"})

		-- 加载界面
		cc.showScreenLoading("theme")

		-- 将 webThemeSideResList 加入到 g_resourcesThemeDymic
		cc.loadThemeSideRes(webThemeSideResList, cc.g_resourcesThemeDymic)

		-- 加载资源
		cc.loadBaseRes(cc.themePreloadList, cc.g_resourcesThemeDymic, function ()
			cc.loader:loadJs("", jsThemeResource, function ()
				-- ThemeResource.js 中会初始化 g_themeLoadingSceneResList 变量
				if cc.g_themeLoadingSceneResList then
					-- 有则使用 g_themeLoadingSceneResList
					cc.loader.load(cc.g_themeLoadingSceneResList, function() end, function()
						-- 加载主题代码
                        loadThemeCode()
                    end)
				else
					-- 若没有，则使用 _res_json.txt
					cc.loader.loadResJsonTxt(resJson, function (resUrls)
						-- 更新 cc.g_themeLoadingSceneResList，方便后续访问
						cc.update_resourcesThemeFromLua(resUrls)
						
						cc.loader.load(resUrls, function() end, function (err, result)
							-- 加载主题代码
							loadThemeCode()
						end)
					end)
				end
			end)
		end)

		cc.hideWebsiteBox()
	else
		doEnterTheme()
	end
end
function LobbyThemeControl:isNeedCheckThemeID()
	local header = User:getInstance().header
	if header and header.themeCtl  and header.themeCtl.theme then

		local themeid = header.themeCtl.theme.themeid
		if bole.isSocialThemeID(themeid) then
			return true
		end
	end
	return false
end
function LobbyThemeControl:onAllowEnterTheme(data)
	data = data or {}
	if data.from ~= EVENT_KEY_EXIT_THEME then return end
	self:saveLobbyViewPos()
	self:_enterTheme(data.info.themeid, data.info.from, data.info.bet, data.info.is_quest, data.info.is_mansion, data.info.is_mansion_tournament)
end
function LobbyThemeControl:_enterTheme (themeid, from, bet, is_quest, is_mansion, is_mansion_tournament)

	UserGuideControl:getInstance():setMapFlag(false)

	bole.needlevel = self:getNeedLevel(themeid)

    self.ui = nil
    -- 关闭大厅背景音乐
    bole.stopMusic()

	-- 进主题前清除大厅主题预加载标记
	self.preloadSpineList = nil

	local gift_data = nil -- a number
	local play = PlayScene.new(themeid, from, gift_data, nil, is_quest, is_mansion, is_mansion_tournament)
	bole.scene = play
	play:setJackpotBet(bet)
    play:run()
    play:setName("PlayScene")
end

function LobbyThemeControl:backToLobby(header, condition, themeid, func)
	if header == nil then
		-- 在大厅中
		if func then
			func()
		end
	else
		-- 在主题中
		if condition then
			self:setEnterThemeData(themeid)
		end
		header:toLobbyScene()
	end
end

---------------------------- 进入大厅拉开帷幕后的处理流程 ----------------------------

function LobbyThemeControl:getHandleProcess( ... )
	return {
			-- {"lobby_quest",		    self.lobby_quest}, -- 只在从主题回大厅用，login没用
			{"package_update",		self.package_update}, -- 强制玩家更新大包的
			{"last_purchase",       self.last_purchase}, -- 购买的断线重连
			{"lucky_charm",       self.lucky_charm}, -- 购买的断线重连
			{"deeplink_gift",       self.deeplink_gift}, -- 点击链接进游戏
			{"golden_wheel",		    self.golden_wheel}, --已付费/已看完广告，未spin

			{"single_combat",		    self.single_combat},

			{"cash_club",		    self.cash_club},
			{"week_tour",		    self.week_tour},
			{"week_tour_turntable",	self.week_tour_turntable},
			{"exchange_tip",		self.exchange_tip},

			
			-- {"spin_wheel", 	        self.spin_wheel},
			{"cumulative_purchase",	self.cumulative_purchase},
			-- {"coin_bonanza",		self.coin_bonanza},
			{"store_blast",			self.store_blast},
			{"store_blast_deluxe",	self.store_blast_deluxe},
			{"purchase_blast_deluxe",self.purchase_blast_deluxe},
			{"purchase_blast", self.purchase_blast},
			{"mb_challenge",		self.mb_challenge},
			{"badge_pick",			self.badge_pick},
			
			-- {"login_reward",		self.login_reward}, --Android 用户不能购买加的功能，注释 zhf
			-- {"welcome_back", 	    self.welcome_back}, -- 七天领取奖励 不弹出改为30天奖励 注视qsj
			{"new_user_prize",		self.new_user_prize},
			{"daily_prize",			self.daily_prize},
			{"inbox_voucher",		self.inbox_voucher},
			{"exclusive_gift",      self.exclusive_gift},
			{"lounge_benefits",     self.lounge_benefits}, -- lounge benefits dialog
			{"birthday", 	        self.birthday}, -- 定制化生日coupon奖励
			{"lounge_end",          self.lounge_end},
			{"newuser_stimulate_info",			self.newuser_stimulate_info}, -- 新手基金购买
			-- {"userguide_login", 	self.userguide_login},
			{"pick_bonus",			self.pick_bonus},
			{"newyear_bonus",		self.newyear_bonus},
			{"repeat_win_deluxe",	self.repeat_win_deluxe},
			{"new_cbo",				self.new_cbo},
			{"level_rush", 	self.level_rush},
			{"atw_wild_game",  	    self.atw_wild_game},	--23009
			{"hot_today", 	        self.hot_today},
			{"gift_tips",           self.gift_tips},
			{"broadcast_gift",      self.gift_reward}, --推送的奖励
			{"rank_prize",			self.rank_prize},	-- b级活动排行榜奖励
			{"share_goto",			self.share_goto},	-- 分享之后跳转
			{"enter_theme", 	    self.enter_theme},
			{"userguide_promotion", self.userguide_promotion}, -- 新手首次回到大厅要弹4小时promotion
			{"tourn_cash",			self.tourn_cash}, 
			{"ad_login_pop", 	    self.ad_login_pop}, --广告--登录弹窗
			{"fb_login_free_coins", self.fb_login_free_coins}, -- fb success
			{"user_guide",          self.user_guide},
			{"money_bank_maximum",  self.money_bank_maximum},
			{"newuser_booster",  	self.newuser_booster},	--43004
			-- {"improve_ad_experience",  	self.improve_ad_experience},	--43004
			{"lup_challenge",  	    self.lup_challenge},	--43004
			{"play_luck_pinball",  	    self.play_luck_pinball}, --弹珠游戏
			{"pick_party",  	    self.pick_party}, --pick小游戏
			{"ad_marquee",  	    	self.ad_marquee}, -- 广告抽奖
		} 
end

function LobbyThemeControl:handleEnterLobby()
	if not self.rets then return end

	local process = self:getHandleProcess()
	for i=1,#process do
		local aa = process[i]
		if self.rets[aa[1]] and aa[2] then
			aa[2](aa[3] or self, self.rets)
			return
		end
	end

	ActivityCenterControl:getInstance():checkPopBadgeWinnerReward()
	ActivityCenterControl:getInstance():checkPopBadgeChallengeReward()
	-- ActivityCenterControl:getInstance():checkPopBadgeChallengeNewGameReward()
	ActivityCenterControl:getInstance():checkPopRubTheBadgeReward()

    -- 播放footer megaball出现动画
	local daily_bonus_controller = DailyBonusController:getInstance()
    if daily_bonus_controller:isWheelAvailable() then
        LobbyFooterControl:getInstance():showDailyBonus(1)
    elseif daily_bonus_controller:isMegaballAvailable() then
        LobbyFooterControl:getInstance():showDailyBonus(3)
    else
        LobbyFooterControl:getInstance():showDailyBonus(2)
    end

    -- 弹出小猪活动提示
	-- LobbyFooterControl:getInstance():showPigTips()
	
	-- black friday弹出小猪活动提示
	-- LobbyFooterControl:getInstance():showPigBBlackFridayTips()

	-- boxing sale day 弹出小猪活动提示
	-- LobbyFooterControl:getInstance():showBoxingDaySaleTips()
	-- christmas弹出小猪活动提示
	-- LobbyFooterControl:getInstance():showPigChristmasTips()

    -- 弹出未收集的邮票奖励弹窗
    AmazingStampController:getInstance():showStampPrizeDialog()
end

function LobbyThemeControl:last_purchase(data)
	local purchase_data = self.rets["last_purchase"]
	self.rets["last_purchase"] = nil
	purchase_data.collect_type = 0
	
	local dialog
	local new_pay_resend = (purchase_data.buy_msg and true or false)
	-- type: store special promotion spinup piggy cash_back level_burst booster_bundle golden_wheel
	-- stamp_count vip_points_delta last_purchase spinup_item buy_coins 
	-- 恢复商城、spinup、blast、打折和单品
	if purchase_data.type == "store" or purchase_data.type == "special" or purchase_data.type == "promotion" or purchase_data.type == "spinup" or purchase_data.type == "blast" or 
		purchase_data.type == "rocket_stage_promotion" or purchase_data.type == "quest_booster" or purchase_data.type == "dreamy_deals" or purchase_data.type == "treasure_help" or purchase_data.type == "bingo_stage_promotion" or 
		purchase_data.type == "treasure_new_item"  or purchase_data.type == "silver_smash" or purchase_data.type == "silver_smash_multi" or purchase_data.type == "gold_smash" or purchase_data.type == "gold_smash_multi" or 
		purchase_data.type == "journey_stage_promotion" or purchase_data.type == "cooking_stage_promotion" or purchase_data.type == "archer_stage_promotion" or purchase_data.type == "blazing_challenge_stage_promotion" or 
		purchase_data.type == "gof_stage_promotion" or purchase_data.type == "quest_game_master" or purchase_data.type == "mission_pass_promotion_plus" or  purchase_data.type == "sail_stage_promotion" or 
		purchase_data.type == "spin_reward" or purchase_data.type == "recoup" or purchase_data.type == "chips" or purchase_data.type == "journey_super_dice" or purchase_data.type == "journey_booster2" or 
		purchase_data.type == "journey_booster1" or purchase_data.type == "rocket_booster1" or purchase_data.type == "rocket_super_spins" or purchase_data.type == "rocket_booster2" or 
		purchase_data.type == "quest_stage_promotion" or purchase_data.type == "cooking_booster1" or purchase_data.type == "cooking_booster2" or purchase_data.type == "cooking_wild_token" or
		purchase_data.type == "blast_booster1" or purchase_data.type == "blast_booster2" or purchase_data.type == "blast_booster3" or
		purchase_data.type == "bingo_booster1" or purchase_data.type == "bingo_booster2" or purchase_data.type == "bingo_super_ball" or 
		purchase_data.type == "archer_booster1" or purchase_data.type == "archer_booster2" or purchase_data.type == "archer_booster3"or purchase_data.type == "gold_card_bonus" or purchase_data.type == "sg_chips" or 
		purchase_data.type == "silver_sg" or purchase_data.type == "gold_sg" or purchase_data.type == "quest_prize_booster" or purchase_data.type == "quest_booster1" or purchase_data.type == "quest_booster2" or
		purchase_data.type == "gof_booster1" or purchase_data.type == "gof_booster2" or purchase_data.type == "gof_booster3" or purchase_data.type == "choose_one" or
		purchase_data.type == "tournament_booster" or purchase_data.type == "tournament_offer" or 
		purchase_data.type == "cbo_deluxe" or purchase_data.type == "mow_booster1" or purchase_data.type == "mow_booster2"or purchase_data.type == "mow_no_puzzle"or purchase_data.type == "mow_super_wand" or
		purchase_data.type == "bingo_wild_ball" or purchase_data.type == "sp_store" or purchase_data.type == "sp_piggy" or purchase_data.type == "atw_booster" or purchase_data.type == "pinball" or purchase_data.type == "choose_one_of_three" or
		purchase_data.type == "level_up_party_challenge_plus" or purchase_data.type == "new_user_store" or purchase_data.type == "golden_spin_deal" or purchase_data.type == "first_store_ooc" or 
		purchase_data.type == "newuser_fund"
		then 

		local purchase_state = StoreControl:getInstance():getPurchaseStateData()
		purchase_data.purchase_state = purchase_state
		if purchase_data.spinup_item and (purchase_state == 0 or purchase_state == 1) then
			if purchase_data.buy_msg then
				PurchaseControl:getInstance():recoverPurchase()
			else
				-- 需要进入spinup
				StoreControl:getInstance():showSpinupDialog(purchase_data, nil, 2)
			end
		elseif purchase_state == 2 then
			-- purchase Successful弹窗
			purchase_data.from_spinup = false
			if purchase_data.type == "dreamy_deals" then
				ActivityCenterControl:getInstance():showCboDialog(purchase_data, false, true, true)
			elseif purchase_data.type == "cbo_deluxe" then
				ActivityCenterControl:getInstance():showAtwCboScratchDialog(purchase_data)
			elseif purchase_data.type == "quest_game_master" then
				purchase_data.purchase_type = purchase_data.type
				StoreControl:getInstance():showFinishBuyBoosterDialog(purchase_data, nil, true)
			else
				StoreControl:getInstance():showFinishBuyDialog(purchase_data, nil)
			end

		-- elseif purchase_state == 3 then
		-- 	-- 恢复lucky charms收集界面
		-- 	local lucky_charms_data = purchase_data.lucky_charms_data
		-- 	-- 显示LuckyCharms弹窗
		-- 	lucky_charms_data.purchase_type = purchase_data.type
		-- 	lucky_charms_data.collect_type  = 0
        -- 	StoreControl:getInstance():showLuckyCharmsDialog(lucky_charms_data, nil)

		else
			-- purchase Successful弹窗
			purchase_data.from_spinup = false
			if purchase_data.type == "dreamy_deals" then
				ActivityCenterControl:getInstance():showCboDialog(purchase_data, false, true, true)
			elseif purchase_data.type == "quest_game_master" then
				purchase_data.purchase_type = purchase_data.type
				StoreControl:getInstance():showFinishBuyBoosterDialog(purchase_data, nil, true)
			elseif purchase_data.type == "cbo_deluxe" then
				ActivityCenterControl:getInstance():showAtwCboScratchDialog(purchase_data) 
			else
				StoreControl:getInstance():showFinishBuyDialog(purchase_data, nil)
			end
		end

	elseif purchase_data.type == "slot_blast" or purchase_data.type == "level_burst" or purchase_data.type == "booster_bundle" then
		purchase_data.purchase_type = purchase_data.type
		StoreControl:getInstance():showFinishBuyBoosterDialog(purchase_data, nil, true)

    elseif purchase_data.type == "golden_wheel" then
    	
    	DailyBonusController:getInstance():showLoadingWheelDialog({show_state = 2, is_after_login = true, is_click_reward = false, purchase_data = purchase_data})

    elseif purchase_data.type == "piggy" then
    	StoreControl:getInstance():showPiggyDialog(false, purchase_data, nil, nil, "last_purchase")

	elseif purchase_data.type == "megaball" then
		
		DailyBonusController:getInstance():showBoQingGeDialogs({show_state = 2, collect_type = 0, purchase_data = purchase_data}, true)
	elseif purchase_data.type == "candle_challenge_upgrade" then
		StoreControl:getInstance():showFinishBuyDialog(purchase_data, function ()
			-- PopupController:getInstance():popupDialogDirectly("new_year_challenge_buy_successful_popup", purchase_data)
		end)

	elseif purchase_data.type == "mission_pass_lv" or purchase_data.type == "mission_pass_upgrade" or purchase_data.type == "mission_pass_stage_promotion" then
		MissionPassController:getInstance():onPaySuccess(purchase_data)
    	StoreControl:getInstance():showFinishBuyDialog(purchase_data, function ()
		end)
    elseif purchase_data.type == "prize_hunt" then
    	if purchase_data.prize_hunt and purchase_data.prize_hunt.pull_prize then -- 当前是正常购买流程
	    	ActivityCenterControl:getInstance():showStampGiftPackDialog(purchase_data.prize_hunt)
		else -- 进入短线重连 直接发送collect_store协议
	    	ActivityCenterControl:getInstance():sendCollectStorePrizeHunt()
    	end
	elseif purchase_data.type == "tourn_cash_promotion1"
	or purchase_data.type == "tourn_cash_promotion2"
	or purchase_data.type == "tourn_cash_promotion3"
	or purchase_data.type == "tourn_cash_promotion4"
	or purchase_data.type == "tourn_cash_promotion5"
	or purchase_data.type == "tourn_cash_out_of_coin" then
    	StoreControl:getInstance():showFinishBuyDialog(purchase_data, nil)
	else
		if purchase_data.buy_msg then
			PurchaseControl:getInstance():recoverPurchase()
		end
	end
end

function LobbyThemeControl:golden_wheel(data)
	-- local prizeData = self.rets["lucky_charm"]
	self.rets["golden_wheel"] = nil

	DailyBonusController:getInstance():showLoadingWheelDialog({show_state = 2, is_after_login = true, is_click_reward = false, purchase_data = data})

	self:handleEnterLobby()
end


function LobbyThemeControl:lucky_charm()
	-- local prizeData = self.rets["lucky_charm"]
	self.rets["lucky_charm"] = nil

	local lucky_charms_data = StoreControl:getInstance():getLuckyCharmsData()
	if lucky_charms_data and lucky_charms_data.stamp_count >= 4 then
		lucky_charms_data.stamp_count = lucky_charms_data.stamp_count - 4
		StoreControl:getInstance():showLuckyCharmsDialog(lucky_charms_data, nil)
	end
	self:handleEnterLobby()
end

function LobbyThemeControl:rank_prize( ... )
	local prizeData = self.rets["rank_prize"]
	self.rets["rank_prize"] = nil
	
	ActivityBController:getInstance():checkRankPrize(prizeData, function ( ... )
		self:handleEnterLobby()
	end)
end

function LobbyThemeControl:lounge_benefits()
	local prizeData = self.rets["lounge_benefits"]
	self.rets["lounge_benefits"] = nil
	PopupController:getInstance():addDialogToPopupFront("lounge", {delay = 0, is_benefit = true}, nil)
	self:handleEnterLobby()
end

function LobbyThemeControl:userguide_promotion()
	self.rets["userguide_promotion"] = nil

	UserGuideControl:getInstance():showPromotionDialog()

	self:handleEnterLobby()
end

function LobbyThemeControl:money_bank_maximum()
	self.rets["money_bank_maximum"] = nil

	UserGuideControl:getInstance():showUserGuide("money_bank_maximum")

	self:handleEnterLobby()
end

function LobbyThemeControl:fb_login_free_coins()
	self.rets["fb_login_free_coins"] = nil
    local firstReward = cc.UserDefault:getInstance():getIntegerForKey(BOLE_FIRST_FB_LOGIN_REWARD, 0)
    if firstReward > 0 then
        cc.UserDefault:getInstance():setIntegerForKey(BOLE_FIRST_FB_LOGIN_REWARD, 0)
        PopupController:getInstance():addDialogToPopupFront("fb_success", firstReward)
    end  
    self:handleEnterLobby()     
end

function LobbyThemeControl:user_guide( ... )
	self.rets["user_guide"] = nil

	-------------- 20级前新手引导 -------------
	-- 大厅首次登陆领奖
	UserGuideControl:getInstance():showUserGuide("first_login")

	-- 大厅首次进入游戏
	UserGuideControl:getInstance():showUserGuide("start_game")
	
	-------------- 20级后引导 -------------
	-- mb black_friday
	-- UserGuideControl:getInstance():showUserGuide("black_friday")

	-- 大厅no club引导
	UserGuideControl:getInstance():showUserGuide("cash_club_no_club")

	-- 大厅header活动中心引导
	UserGuideControl:getInstance():showUserGuide("event_and_offer_tip")

	-- 大厅footer blast引导
	UserGuideControl:getInstance():showUserGuide("blast_lobby")

	-- 大厅footer rocket引导
	UserGuideControl:getInstance():showUserGuide("rocket_lobby")

	-- 大厅footer bingo引导
	UserGuideControl:getInstance():showUserGuide("bingo_lobby")

	-- 大厅footer quest引导
	UserGuideControl:getInstance():showUserGuide("quest_lobby")

	-- 大厅footer archer引导
	UserGuideControl:getInstance():showUserGuide("archer_lobby")

	-- 大厅footer journey引导
	UserGuideControl:getInstance():showUserGuide("journey_lobby")

	-- 大厅footer gof引导
	UserGuideControl:getInstance():showUserGuide("gof_lobby")

	-- 大厅cooking frenzy引导   
	UserGuideControl:getInstance():showUserGuide("cooking_frenzy")

	-- moneybanks day引导 活动号12
	UserGuideControl:getInstance():showUserGuide("moneybanks_day")

	-- 21009
	UserGuideControl:getInstance():showUserGuide("pig_christmas_sale")
	
	-- 21010
	UserGuideControl:getInstance():showUserGuide("boxing_day_sale")

	-- 大厅footer dashboard引导
	-- UserGuideControl:getInstance():showUserGuide("dashboard_lobby")

	-- 大厅mission pass chest challenge
	UserGuideControl:getInstance():showUserGuide("mission_pass_chest_challenge")

	-- mission pass 新手引导
	UserGuideControl:getInstance():showUserGuide("mission_pass_guide")

	-- 大厅footer smashDay最后一天引导
	UserGuideControl:getInstance():showUserGuide("smash_day")

	-- 邮票解锁
	UserGuideControl:getInstance():showUserGuide("stamp_unlock_tip")

	-- 大厅footer byd引导
	UserGuideControl:getInstance():showUserGuide("byd_lobby")

	-- 大厅footer lounge引导
	UserGuideControl:getInstance():showUserGuide("lounge_unlock_tip")

	-- 大厅footer mansion引导
	UserGuideControl:getInstance():showUserGuide("mansion_quest")
	UserGuideControl:getInstance():showUserGuide("mansion_quest_back")

	-- 大厅header puzzle引导
	UserGuideControl:getInstance():showUserGuide("frenzy_vault_puzzle")

	-- 大厅header礼物盒引导
	UserGuideControl:getInstance():showUserGuide("gift_lobby")

	-- 大厅footer bc引导
	-- UserGuideControl:getInstance():showUserGuide("bc_lobby_words_game")

	-- 大厅footer bc引导
	UserGuideControl:getInstance():showUserGuide("bc_lobby")

	-- UserGuideControl:getInstance():showUserGuide("money_bank_maximum")

	-- 大厅footer mow引导
	UserGuideControl:getInstance():showUserGuide("mow_lobby")

	UserGuideControl:getInstance():showUserGuide("inbox_sale")

	-- mpS23 提醒玩家可以买头像了
	UserGuideControl:getInstance():showUserGuide("buy_avatar_tip")

	self:handleEnterLobby()
end

-- function LobbyThemeControl:spin_wheel(data)
-- 	local callback = function ( ... )
-- 		self:handleEnterLobby()
-- 	end

-- 	local wheel_data = self.rets["spin_wheel"]
-- 	self.rets["spin_wheel"] = nil

-- 	DailyBonusController:getInstance():showLoadingWheelDialog(true, false, callback)

-- end

function LobbyThemeControl:login_reward(  )
	local callback = function ( ... )
		self:handleEnterLobby()
	end
	local rewardData = self.rets["login_reward"]
	self.rets["login_reward"] = nil
	-- PopupController:getInstance():addDialogToPopupTail("login_reward",rewardData,callback)
end

function LobbyThemeControl:package_update(  )
	local callback = function ( ... )
		self:handleEnterLobby()
	end
	self.rets["package_update"] = nil
	PopupController:getInstance():addDialogToPopupFront("update", nil, callback)
end

-- function LobbyThemeControl:lobby_quest(from)
-- 	local lobby_quest_from
-- 	if self.rets["lobby_quest"] and type(self.rets["lobby_quest"]) == "string" then
-- 		lobby_quest_from = self.rets["lobby_quest"]
-- 	end
-- 	self.rets["lobby_quest"] = nil

-- 	if UserGuideControl:getInstance():getFirstQuestLobbyFlag() == 0 then
-- 		bole.send_codeInfo(Splunk_Type.Guide, {pid = "LobbyThemeControl_lobby_quest"}, false)
-- 	end

-- 	UserGuideControl:getInstance():showUserGuideQuestDialog(lobby_quest_from)
-- 	self:handleEnterLobby()
-- end

-- function LobbyThemeControl:welcome_back(data)
-- 	local welcomeback_data = self.rets["welcome_back"]
-- 	self.rets["welcome_back"] = nil
-- 	-- 弹welcome back弹窗
--     WelcomeBackWeekController:getInstance():showWeekBackDialog(true)
-- 	self:handleEnterLobby()
-- end

function LobbyThemeControl:exclusive_gift(data)
	local exclusivegift_data = self.rets["exclusive_gift"]
	self.rets["exclusive_gift"] = nil
	-- 弹welcome back弹窗
    WelcomeBackWeekController:getInstance():showExclusiveGiftDialog(true)
	self:handleEnterLobby()
end

function LobbyThemeControl:new_user_prize()
	self.rets["new_user_prize"] = nil
	-- 弹welcome back弹窗
    UserGuideControl:getInstance():showAfterNewPeriodDialog()
	self:handleEnterLobby()
end

function LobbyThemeControl:daily_prize(data)
	local dailyPrize_data = self.rets["daily_prize"]
	self.rets["daily_prize"] = nil
	DailyPrizeController:getInstance():showDailyPrizeDailog(true)
	self:handleEnterLobby()
end

function LobbyThemeControl:inbox_voucher(data)
	local dailyPrize_data = self.rets["inbox_voucher"]
	self.rets["inbox_voucher"] = nil
	GiftControl:getInstance():showInboxDailog(true)
	self:handleEnterLobby()
end

function LobbyThemeControl:birthday(data)
	local birthday = self.rets["birthday"]
	self.rets["birthday"] = nil
	-- 弹birthday弹窗
	PopupController:getInstance():addDialogToPopupFront("birthday_gift", nil, callback)
    self:handleEnterLobby()
end
   
function LobbyThemeControl:hot_today(data)
	local callback = function ( ... )
		self:handleEnterLobby()
	end

	local hottoday_data = self.rets["hot_today"]
	self.rets["hot_today"] = nil

	UserGuideControl:getInstance():showNewUserCActivity(true)

	ActivityCenterControl:getInstance():popupActivityDialogs(true, callback)
	if EventAndOfferController:getInstance():isLoginPopEnable() then
		-- 有红点没点才弹
		EventAndOfferController:getInstance():showHallPop()
	end

end

-- function LobbyThemeControl:userguide_login(data)
-- 	local hottoday_data = self.rets["userguide_login"]
-- 	self.rets["userguide_login"] = nil
-- 	UserGuideControl:getInstance():showUserGuideLoginPopup()
-- 	self:handleEnterLobby()
-- end

function LobbyThemeControl:pick_bonus(data)
	self.rets["pick_bonus"] = nil
	PromotionControl:getInstance():showPickBonusDialog()

	self:handleEnterLobby()
end

function LobbyThemeControl:newyear_bonus(data)
	local data = (data or {}).newyear_bonus
	self.rets["newyear_bonus"] = nil
	ActivityCenterControl:getInstance():showNewYearBonusDialog(data)

	self:handleEnterLobby()
end

function LobbyThemeControl:store_blast(data)
	local data = (data or {}).store_blast
	self.rets["store_blast"] = nil
	ActivityCenterControl:getInstance():showStoreBlastWheel(data)
	self:handleEnterLobby()
end

function LobbyThemeControl:cumulative_purchase(data)
	self.rets["cumulative_purchase"] = nil
	local function callback()
		self:handleEnterLobby()
	end
	ActivityCenterControl:getInstance():showCumulativePurchaseWinDialog(callback)
end

-- function LobbyThemeControl:coin_bonanza(data)
-- 	self.rets["coin_bonanza"] = nil
-- 	local function callback()
-- 		self:handleEnterLobby()
-- 	end
	-- ActivityCenterControl:getInstance():showCoinBonanzaWinDialog(callback)
-- end

function LobbyThemeControl:store_blast_deluxe(data)
	local data = (data or {}).store_blast_deluxe
	self.rets["store_blast_deluxe"] = nil
	ActivityCenterControl:getInstance():showStoreBlasDeluxetWheel(data)
	self:handleEnterLobby()
end

function LobbyThemeControl:purchase_blast_deluxe(data)
	local data = (data or {}).purchase_blast_deluxe
	self.rets["purchase_blast_deluxe"] = nil
	ActivityCenterControl:getInstance():showPurchaseBlasDeluxetRes(data)
	self:handleEnterLobby()
end

function LobbyThemeControl:purchase_blast(data)
	local data = (data or {}).purchase_blast or {}
	self.rets["purchase_blast"] = nil
	local function callback()
		self:handleEnterLobby()
	end
	ActivityCenterControl:getInstance():showBigWinnerRes(data.data, callback)
end

function LobbyThemeControl:newuser_booster(data)
	self.rets["newuser_booster"] = nil
	ActivityCenterControl:getInstance():showNewUserBoosterRes()
	self:handleEnterLobby()
end

function LobbyThemeControl:lup_challenge(data)
	self.rets["lup_challenge"] = nil
	ActivityCenterControl:getInstance():showLevelChallengeTipPop()
	self:handleEnterLobby()
end

function LobbyThemeControl:play_luck_pinball()
	self.rets["play_luck_pinball"] = nil
	-- print("play_luck_pinball show")
	LuckyPinballController:getInstance():showPinballGame()
	self:handleEnterLobby() 
end

function LobbyThemeControl:pick_party()
	self.rets["pick_party"] = nil
	PickPartyController:getInstance():showGameDialogCheckCanPlay()
	self:handleEnterLobby() 
end
function LobbyThemeControl:setAdMarquee()
	self.rets["ad_marquee"] = self.rets["ad_marquee"] or {}
end
function LobbyThemeControl:ad_marquee()
	self.rets["ad_marquee"] = nil
	AdMarqueeController:getInstance():checkRewardShow(function()
		self:handleEnterLobby()
	end)
end

function LobbyThemeControl:atw_wild_game(data)
	self.rets["atw_wild_game"] = nil
	ActivityCenterControl:getInstance():onAtwWildBagGameEnterLobby()
	self:handleEnterLobby()
end

function LobbyThemeControl:level_rush(data)
	self.rets["level_rush"] = nil
	LevelUpPartyController:getInstance():showChallengeReplaceRewardPop()
	self:handleEnterLobby()
end

-- function LobbyThemeControl:improve_ad_experience(data)
-- 	self.rets["improve_ad_experience"] = nil

-- 	local num = ImproveController:getInstance():getRefuseNumber() or 0
-- 	local max_num = ImproveController:getInstance():getPopupMaxNum() or 6
-- 	if num >= 1 and num <= max_num then
-- 		ImproveController:getInstance():showImproveDialog()
-- 	end
-- 	self:handleEnterLobby()
-- end

function LobbyThemeControl:mb_challenge(data)
	self.rets["mb_challenge"] = nil
	ActivityCenterControl:getInstance():showMbChallengePrize()
	self:handleEnterLobby()
end

function LobbyThemeControl:badge_pick()
	self.rets["badge_pick"] = nil
	BadgeController:getInstance():showBadgePickWinDialog(nil, true)
	self:handleEnterLobby()
end

function LobbyThemeControl:repeat_win_deluxe(data)
	self.rets["repeat_win_deluxe"] = nil
	ActivityCenterControl:getInstance():showActivityThemeDialog("repeat_win_deluxe", nil, nil)

	self:handleEnterLobby()
end

function LobbyThemeControl:new_cbo(data)
	self.rets["new_cbo"] = nil
	ActivityCenterControl:getInstance():showCboDialog(nil, true, false, true)
	self:handleEnterLobby()
end

function LobbyThemeControl:ad_login_pop()
	local ad_data = self.rets["ad_login_pop"]
	self.rets["ad_login_pop"] = nil
	local callback = function ( ... )
		self:handleEnterLobby()
	end
	if ADSControl:getInstance():canShowAds(ADType.REWARDVIDEO) and bole.canDisturbTheme() and User:getInstance():getExp() > 0 then
		PopupController:getInstance():addDialogToPopupTail("ad_login_pop",nil,callback)
	else
		self:handleEnterLobby()
	end
end

-- 礼物提示弹窗，在login进入大厅所有弹窗的末尾，确保之后不能有其它未处理process
function LobbyThemeControl:gift_tips(data)

	self.rets["gift_tips"] = nil

	self.showGiftTips = true

	self:handleEnterLobby()
end

-- 推送的奖励
function LobbyThemeControl:gift_reward(data)
	local rewardData = self.rets["broadcast_gift"]
	self.rets["broadcast_gift"] = nil
	if rewardData then
		-- bole.send_codeInfo("record", {pid = PID.collect_broadcast_reward, broadcast_id = rewardData[1], key = rewardData[2]}, false)
		GiftControl:getInstance():collectBroadcastCoins(rewardData)
	end
	self:handleEnterLobby()
end

-- deeplink奖励
function LobbyThemeControl:deeplink_gift(data)
	local rewardData = self.rets["deeplink_gift"]
	self.rets["deeplink_gift"] = nil
	if User:getInstance().deeplink_data then
		if User:getInstance().deeplink_data.gift_type == RewardGiftType.WelcomBackWeek then
			if User:getInstance().deeplink_data.old_user_welcome_back then
				DeepLinkControl:getInstance():sendGetRewardCmd(nil,User:getInstance().deeplink_data.gift_type)
			end
		elseif User:getInstance().deeplink_data.gift_type == RewardGiftType.Deeplink then
			if User:getInstance().deeplink_data.gift_coins > 0 then
				DeepLinkControl:getInstance():sendGetRewardCmd(nil,User:getInstance().deeplink_data.gift_type)
			end
		elseif User:getInstance().deeplink_data.gift_type == RewardGiftType.VipDeeplink then
			if User:getInstance().deeplink_data.gift_coins > 0 then
				DeepLinkControl:getInstance():sendGetRewardCmd(nil,User:getInstance().deeplink_data.gift_type)
			end
		elseif User:getInstance().deeplink_data.gift_type == RewardGiftType.INS then
			if User:getInstance().deeplink_data.gift_coins and User:getInstance().deeplink_data.gift_coins > 0 then
				DeepLinkControl:getInstance():sendGetRewardCmd(nil,User:getInstance().deeplink_data.gift_type)
			end
		elseif User:getInstance().deeplink_data.gift_type == RewardGiftType.LUCKY then
			if User:getInstance().deeplink_data.invalid_type == 0 then
				DeepLinkControl:getInstance():sendGetRewardCmd(nil,User:getInstance().deeplink_data.gift_type)
			end
		elseif User:getInstance().deeplink_data.gift_type == RewardGiftType.NORMAL then
			if User:getInstance().deeplink_data.invalid_type == 0 then
				DeepLinkControl:getInstance():sendGetRewardCmd(nil,User:getInstance().deeplink_data.gift_type)
			end
		end
		DeepLinkControl:getInstance():onCollectRewardCoin(User:getInstance().deeplink_data, true)
	else
		DeepLinkControl:getInstance():checkoutReward()
	end
	self:handleEnterLobby()
end

-- lounge end奖励
function LobbyThemeControl:lounge_end(data)
	local rewardData = self.rets["lounge_end"]
	self.rets["lounge_end"] = nil
	LobbyControl:getInstance():showLoungeEndDialog(rewardData)
	self:handleEnterLobby()
end

-- 
function LobbyThemeControl:newuser_stimulate_info(data)
	self.rets["newuser_stimulate_info"] = nil 

	local function callback()
		self:handleEnterLobby()
	end

	if NewuserStimulateController:getInstance():getNewUserFundLeftTime() > 0 then
		NewuserStimulateController:getInstance():showNewUserFundDialog({delay = 0.5, from = "login"}, callback)
	else
		callback()
	end
end

-- enter_theme会进入游戏，确保此项之后不能有其他未处理Process
function LobbyThemeControl:enter_theme(data)
	-- local callback = function ( ... )
	-- 	self:handleEnterLobby()
	-- end

	local theme_id = self.rets["enter_theme"]
	self.rets["enter_theme"] = nil

	-- callback()

	-- 进入礼物箱界面
	if theme_id == 10001 then
		LobbyFooterControl:getInstance():openInbox()
	
	-- 进入dashboard wheel bonus
	-- elseif theme_id == 10002 then
	-- 	if DashboardController:getInstance():canPlayPick() then
	-- 		DashboardController:getInstance():showDashPickDialog({show_state = 1, is_recovery = false, win_data = nil, delay = 0.5})
	-- 	end
	-- elseif theme_id == 10003 then
	-- 	if DashboardController:getInstance():canPlayWheel() then
	-- 		DashboardController:getInstance():showDashWheelDialog({show_state = 1, win_data = nil, delay = 0.5})
	-- 	end

	-- 打开quest
	elseif theme_id == 10004 then -- quest相关功能暂未开启
		QuestController:getInstance():showLastPrizeDialogs()
		QuestController:getInstance():showQuestDialog({delay = 0, show_single = true}, nil)
		QuestController:getInstance():showQuestEndDialog()

	-- play mini game
	elseif theme_id == 10005 then
		ActivityBController:getInstance():enterMiniGame(ACTIVITY_B.BLAST, nil, nil)

	-- exit mini game
	elseif theme_id == 10006 then
		local last_themeid = ActivityBController:getInstance():getThemeId(ACTIVITY_B.BLAST)
		if last_themeid then
			self:enterTheme(last_themeid)
		else
			ActivityBController:getInstance():showBlastPickDialog(ACTIVITY_B.BLAST, true, nil)
		end

	-- open stamp album
	-- elseif theme_id == 10007 then
	-- 	AmazingStampController:getInstance():showStampsDialog(nil)

	-- enter free game(2002) of store game
	elseif theme_id == 10008 then
		self:enterTheme(2002)
	
	elseif theme_id == 1000810 then
		self:enterTheme(2005)

	elseif theme_id == 10008100 then
		self:enterTheme(2007)

    -- return store game related theme
	elseif theme_id == 10009 then
		local save_themeid = self:getStoreGameThemeID()
		if save_themeid then
			self:enterTheme (save_themeid)
		else
			self:enterTheme (131)
		end

	-- 打开dashboard
	-- elseif theme_id == 10010 then
	-- 	DashboardController:getInstance():showDashboardDialog(true)

	-- 回到神灯
	elseif theme_id == 10011 then
		RubTheLampController:getInstance():showHallDialog()

	-- level up party
	elseif theme_id == 10012 then
		self:enterTheme(LevelUpPartyController:getInstance():getBonusThemeId())

	elseif theme_id ~= 600 then
		if self:isNeedAppUpdate(theme_id) then
			PopupController:getInstance():popupDialogDirectly("update", {themeName=THEME_LIST[theme_id].name}, nil)
		else
			self:clickLobbyTheme(theme_id)
		end
		
	end

	self:handleEnterLobby()

end

-- 公会
function LobbyThemeControl:cash_club(  )
	local data = self.rets["cash_club"] or {}
	local tag = table.remove(data, 1)
	if #data == 0 then
		self.rets["cash_club"] = nil
	end
	if tag == "last_reward" then
		-- 上个赛季奖励
		CashClubController:getInstance():checkClubKeyEnableLobbyTip()
		CashClubController:getInstance():checkSelfLastChestReward(function ()
			self:handleEnterLobby()
		end, true)
	elseif tag == "key_enable" then
		-- 宝箱钥匙解锁
		CashClubController:getInstance():checkLeaveEnableLobbyTip()
		CashClubController:getInstance():showKeyCollectedPop(nil, function ()
			self:handleEnterLobby()
		end, true)
	elseif tag == "leave_tip" then
		-- 宝箱钥匙解锁
		CashClubController:getInstance():checkLeaveTipPop(nil, function ()
			self:handleEnterLobby()
		end, true)
	else
		self:handleEnterLobby()
	end
end
function LobbyThemeControl:addCashClubData( tag )
	self.rets["cash_club"] = self.rets["cash_club"] or {}
	table.insert(self.rets["cash_club"], tag)
end
-- 公会分享
function LobbyThemeControl:share_goto(  )
	local data = self.rets["share_goto"] or {}
	local tag = table.remove(data, 1)
	if #data == 0 then
		self.rets["share_goto"] = nil
	end
	if tag == "club_id" then
		-- 分享公会
		CashClubController:getInstance():checkShareClub(function ()
			self:handleEnterLobby()
		end)
	else
		self:handleEnterLobby()
	end
end
function LobbyThemeControl:addShareGotoData( tag )
	self.rets["share_goto"] = self.rets["share_goto"] or {}
	table.insert(self.rets["share_goto"], tag)
end

function LobbyThemeControl:week_tour()
	self.rets["week_tour"] = nil
	
	WeekendTournamentController:getInstance():showWeekendTournamentCollectDialog()
    self:handleEnterLobby()
end

function LobbyThemeControl:week_tour_turntable()
	self.rets["week_tour_turntable"] = nil
	
	PopupController:getInstance():popupDialogDirectly("weekend_tournament_turntable")
    self:handleEnterLobby()
end

function LobbyThemeControl:exchange_tip()
	self.rets["exchange_tip"] = nil
	local callback = function ( ... )
		self:handleEnterLobby()
	end
	VoucherController:getInstance():showExchangeTip(callback)
end



function LobbyThemeControl:tourn_cash()
	local data = self.rets["tourn_cash"]
	self.rets["tourn_cash"] = nil
	if data then
		TournCashController:getInstance():enterTournCashLobby(nil, function ()
			self:handleEnterLobby()
		end)
	end
end

function LobbyThemeControl:single_combat()
	self.rets["single_combat"] = nil
	PopupController:getInstance():addDialogToPopupFront("Single_Combat_Result_Pop")
end

function LobbyThemeControl:setPurchaseData(key, data) 
	if key == nil then
		self.rets["last_purchase"] = self.rets["last_purchase"] or {}
		if data then
			for key1, val in pairs(data) do
				self.rets["last_purchase"][key1] = val
			end
		end
	else
		self.rets["last_purchase"] = self.rets["last_purchase"] or {}
		self.rets["last_purchase"][key] = data
	end
end


function LobbyThemeControl:setLuckyPinball()
	self.rets["play_luck_pinball"] = self.rets["play_luck_pinball"] or {}
end
function LobbyThemeControl:setPickParty()
	self.rets["pick_party"] = self.rets["pick_party"] or {}
end



-- function LobbyThemeControl:setWheelData()
-- 	self.rets["spin_wheel"] = true
-- end

-- function LobbyThemeControl:isAutoSlotOfCash()
-- 	return self.rets["spin_wheel"]
-- end

function LobbyThemeControl:setHotTodayData(activity_name)
	self.rets["hot_today"] = activity_name or ""
end

function LobbyThemeControl:setGiftTipsData()
	self.rets["gift_tips"] = true
end

function LobbyThemeControl:setEnterThemeData(theme_id)
	self.rets["enter_theme"] = theme_id
end

function LobbyThemeControl:setNewuserFundDataTag()
	self.rets["newuser_stimulate_info"] = true
end


function LobbyThemeControl:addEnterHandleData(key,value)
	if key then
		self.rets[key] = value or true

		if key == "user_guide" then
			UserGuideControl:getInstance():clear()
		end
	end
end

function LobbyThemeControl:removeEnterHandleData(key)
	if key then
		self.rets[key] = nil
	end
end

function LobbyThemeControl:showGiftGuide()
	return (self.showGiftTips)
end

function LobbyThemeControl:setGiftGuideStatus(show)
	self.showGiftTips = show
end

---------------------------Store Game 相关 --------------------------------------
function LobbyThemeControl:setStoreGameThemeID(tid)
	self.storeGameThemeID = tid
end

function LobbyThemeControl:getStoreGameThemeID()
	return self.storeGameThemeID
end

---------------------------回大厅立即弹出 --------------------------------------
function LobbyThemeControl:setInstantPopup(key, data)
	self.instantPopup = key
	self.instantPopupData = data
end

function LobbyThemeControl:checkInstantPopup()
	if self.instantPopup then
		local tempKey = self.instantPopup
		self.instantPopup = nil
	end
end

---------------------------Debug 相关 -------------------------------------------
function LobbyThemeControl:printTable(t)
	t = t or {}
	for k, v in pairs(t) do
		print(k, type(k), " PD:=========value = ", v, ", type = " .. type(v))
		if type(v) == "table" then
			self:printTable(v)
		end
	end
end

function LobbyThemeControl:print(name, ... )
	print("PD:===========" .. name .. ": ", ...)
end

-------------------- 大厅主题随机播放特效 --------------------
function LobbyThemeControl:dealCurThemeList(themeNode)

	if not libUI.isValidNode(themeNode) then
		return 
	end

	self.curThemeList = self.curThemeList or {}

	local flag = true
	for k, v in pairs(self.curThemeList) do 
		if v == themeNode then
			flag = false
			break 
		end
	end

	if flag then
		self.curThemeList[#self.curThemeList + 1] = themeNode
	end

	self:startDealThemeSpine()

end

-- 刷新theme list调用了，下载完会刷新
-- 播放完上一个调用了
-- 切换页签调用
function LobbyThemeControl:startDealThemeSpine()

	if not User:getInstance():getIsReady() then
		return 
	end

	local distance = 50
	local startPosX = LEFT_WIDTH_OFFSET + distance
	local endPosX = FRAME_WIDTH - distance

	local dealList = {}
	self.curThemeList = self.curThemeList or {}
	for k, v in pairs(self.curThemeList) do
		if libUI.isValidNode(v) and libUI.isValidNode(v.jackpotNode) and self:isWorldParentNormal(v) then
			local loadingId 	= THEME_LIST[v.themeid]['loadingId']
			local needDownload  = self:needDownloadTheme(loadingId)
			local needPreload	= self:needPreload(loadingId) 
			local worldPosX = (bole.getWorldPos(v)).x
			local isPosFlag = worldPosX >= startPosX and worldPosX <= endPosX
			local is_maintenance = self:isUnderMaintenance(v.themeid)
			local is_coming = self:isComingSoon(v.themeid)
			local addFlag = isPosFlag and not is_coming and not is_maintenance and not needDownload and not needPreload
			if addFlag then
				if v.jackpotNode:isVisible() then
					return 
				end
				dealList[#dealList + 1] = v
			end
		end
	end
	local dealListLen = #dealList
	self.dealListConfig = self.dealListConfig or {}
	if self.dealListConfig.lastLen ~= dealListLen then
		self.dealListConfig.index = 0
		self.dealListConfig.showOrderList = self:getDealThemeOrderList(dealListLen)
		self.dealListConfig.lastLen = dealListLen
	end
	self.dealListConfig.index = self.dealListConfig.index or 0
	self.dealListConfig.index = self.dealListConfig.index + 1
	if self.dealListConfig.index > dealListLen then
		self.dealListConfig.index = 1
	end
	local index = self.dealListConfig.index
	local orderList = self.dealListConfig.showOrderList
	local showIndex = orderList[index]
	local themeNode = dealList[showIndex]
	if libUI.isValidNode(themeNode) and not self.lobbyMoved then
		if dealListLen and dealListLen > 1 and libUI.isValidNode(self.dealListConfig.themeNode) and self.dealListConfig.themeNode == themeNode then -- 判断两个主题节点是否相同，避免重复播放
			self:startDealThemeSpine()
			return 
		end
		self.dealListConfig.themeNode = themeNode

		if themeNode.isDouble and themeNode.showRandomThemeNode then
			themeNode:showRandomThemeNode()
		else
			local lobbyTheme = LobbyTheme.new()
			-- self:stopOtherThemeNode(themeNode)
			lobbyTheme:showRandomThemeNode(themeNode)
		end
	end

end

-- function LobbyThemeControl:stopOtherThemeNode()
	-- if self.curThemeList then
	-- 	for k, themeNode in pairs(self.curThemeList) do
	-- 		if libUI.isValidNode(themeNode) then
	-- 			local lobbyTheme = LobbyTheme.new()
	-- 			lobbyTheme:updateLogo(themeNode)
	-- 			lobbyTheme:playJackpotNodesAnim(themeNode, false)
	-- 		end
	-- 	end
	-- end
-- end

function LobbyThemeControl:getDealThemeOrderList(len)
	local res = {}
    for i = 1, len do
        res[i] = i
    end
    local num, testMapPos, tmp
    for i = 2, len do
        num = math.random(2, len)
        tmp = res[i]
        res[i] = res[num]
        res[num] = tmp
    end
    return res
end

function LobbyThemeControl:isWorldParentNormal(node)
	local isValidNode = libUI.isValidNode
	local parent = node
    while parent ~= bole.scene do
		if not isValidNode(parent) or not parent:isVisible() then
			return false
		end
        parent = parent:getParent() 
    end
	return true
end

function LobbyThemeControl:setLobbyMovedFlag(flag)
	self.lobbyMoved = flag
	if not self.lobbyMoved then
		self:startDealThemeSpine()
	-- else
		-- self:stopOtherThemeNode()
	end
end

function LobbyThemeControl:isLobbyMoved()
	return self.lobbyMoved
end

function LobbyThemeControl:getCellBigIDs()
	return self.themeData.cellBigIDs
end

-- cell index 前面的单主题个数
function LobbyThemeControl:getBigNumByIndex(index)
	local num = 0
	if not index then 
		num = table.nums(self.themeData.cellBigIDs)
	else		
		for i, v in pairs(self.themeData.cellBigIDs) do 
			if i < index then
				num = num + 1
			end
		end
	end
	return num
end

-- 在最前面的大主题有几个
function LobbyThemeControl:getFrontBigNum() 
	local num = 0
	if self.themeInfo then
		for k, v in pairs(self.themeInfo) do
			if not (self:isRecommend(v) and not IS_CHECK)then
				break
			end
			num = num + 1
		end
	end

	return num
end

function LobbyThemeControl:setNumOfLobbyAdvInfo(count) 
	self.lobbyAdvInfoCount = count or 0
end
function LobbyThemeControl:getNumOfLobbyAdvInfo() 
	return self.lobbyAdvInfoCount or 0
end

------------------------------------------------------------------------------------------------------------
--@ DES_BIG_THEME
function LobbyThemeControl:setLobbyBigThemeData(index, data)
	local id = data.theme_id
	if self:canPlayLoungeMode() and bole.getLoungeThemeId(data.theme_id) then 
		id = bole.getLoungeThemeId(data.theme_id)
	end

	-- 存储解锁的theme ID
	local unlockIndex = #self.themeData.unlockThemeIDs
	local user_level = User:getInstance().level or 1
	local need_level = data.need_level or 1

	if TOTAL_OPEN_TO_ALL or user_level >= need_level then
		if self:canPlay(data.attribute,data.theme_id) then
			self.themeData.unlockThemeIDs[unlockIndex+1] = id
		end
	end

	if not self.themeData.cellBigIDs then return end 

	local lastIndex = self.lastBigIndex or 0
	local count_big = table.nums(self.themeData.cellBigIDs) -- 双主题的组数
	local pageCount = table.nums(self.themeData.cellIDs) -- 八个主题的组数

	local index = count_big + 1
	self.themeData.cellBigIDs[index] = {}
	self.themeData.cellBigIDs[index][1] = id
	self.lastBigIndex = index
end

-- fb 分享标记: 参数1: 状态0代表不分享，1代表分享
function LobbyThemeControl:setFBShareTag(tag)
	self.fbShareTag = tag
end

function LobbyThemeControl:getFBShareTag()
	local chooseShare = true
	if self.fbShareTag then
		chooseShare = self.fbShareTag == 1
	end
	return chooseShare
end

function LobbyThemeControl:setHasClickFBShareBtn(isClick)
	self.hasClickFBShareBtn = isClick
end

function LobbyThemeControl:getHasClickFBShareBtn()
	return self.hasClickFBShareBtn
end

-- 参数1: tid， 参数2: 状态（0或者没有代表还没有进入过主题，1代表进入过主题）
function LobbyThemeControl:setFirstEnterThemeTag(tid, tag)
	if not tid then return end
	
	tag = tag or 1
	self.firstEnterThemeTagList = self.firstEnterThemeTagList or {}
	self.firstEnterThemeTagList[tid] = tag
end

function LobbyThemeControl:getFirstEnterThemeTag(tid)
	if not tid then return false end
	
	local tag = 0
	if self.firstEnterThemeTagList and self.firstEnterThemeTagList[tid] then
		tag = self.firstEnterThemeTagList[tid]
	end
	return tag
end