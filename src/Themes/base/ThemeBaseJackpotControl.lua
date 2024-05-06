

ThemeBaseJackpotControl = class("ThemeBaseJackpotControl")
local baseJpCtl = ThemeBaseJackpotControl


function baseJpCtl:ctor(mainCtl)
	self._mainViewCtl = mainCtl
	-- self.jpView = nil
end

function baseJpCtl:initialJackpotNode()
	if not self.jpView then return end
	local jpConfig = self._mainViewCtl:getThemeJackpotConfig()
	local themeId = self._mainViewCtl:getThemeId()
	local jackpotLabels = self.jpView:getJackpotLabels() or {}
	if jpConfig == nil or not themeId then return end

	-- 配置服务器传来的jackpot
	local link_config       = jpConfig.link_config or {}
	local jackpotController = JackpotControl:getInstance()
	local bet               = self._mainViewCtl:getCurTotalBet() -- self._mainViewCtl:getThemeControl():getCurTotalBet()
	local baseBet           = self._mainViewCtl:getBaseBet()
	local betMul            = bet / baseBet
	local allowKList        = jpConfig.allowK or {}
	local allowK            = allowKList[themeId] or false
	for i=1, #link_config do
		local jp_level = link_config[i]
		if jp_level and jackpotLabels[i] then
			jackpotController:configJackpotUI (themeId, jp_level, betMul, jackpotLabels[i], allowK, true)
		end
	end

	-- 配置本地的jackpot
	local local_config = jpConfig.local_config or {}
	local startIndex   = #link_config
	for i=1, #local_config do
		if jackpotLabels[i+startIndex] then
			local jpValue = local_config[i][2] * bet
			jackpotLabels[i+startIndex]:setString(self:formatJackpotMeter(jpValue))

			local max_width = local_config[i][3]
			local max_scale = local_config[i][4]
			if max_width and max_scale then
				bole.shrinkLabel (jackpotLabels[i+startIndex], max_width, max_scale)
			end
		end
	end
end

function baseJpCtl:updateJackpotByBet(bet)
	if not self.jpView then return end
	local jpConfig = self._mainViewCtl:getThemeJackpotConfig()
	local themeId = self._mainViewCtl:getThemeId()
	local jackpotLabels = self.jpView:getJackpotLabels() or {}
	if jpConfig == nil or not themeId or not jackpotLabels then return end

	-- 更新服务器传来的jackpot
	local link_config  = jpConfig.link_config or {}

	local baseBet      = self._mainViewCtl:getBaseBet()
	for i=1, #link_config do
		if jackpotLabels[i] then
			jackpotLabels[i]:updateBet(bet/baseBet)
		end
	end

	-- 更新本地jackpot
	local local_config = jpConfig.local_config or {}
	local startIndex   = #link_config
	for i=1, #local_config do
		if jackpotLabels[i+startIndex] then
			local jpValue = local_config[i][2] * bet
			jackpotLabels[i+startIndex]:setString(self:formatJackpotMeter(jpValue))

			local max_width = local_config[i][3]
			local max_scale = local_config[i][4]
			if max_width and max_scale then
				bole.shrinkLabel (jackpotLabels[i+startIndex], max_width, max_scale)
			end
		end
	end
end

function baseJpCtl:getJackpotValue(incrementList, mul) -- progressive_list  mul 倍数
	if not self.jpView then return end
	local jpConfig = self._mainViewCtl:getThemeJackpotConfig()
	if jpConfig == nil then return end

	mul = mul or 1
	-- 更新服务器reset值
	local link_config       = jpConfig.link_config or {}
	local incrementList     = incrementList or {}
	local bet               = self._mainViewCtl:getCurTotalBet() -- self._mainViewCtl:getThemeControl():getCurTotalBet()
	local baseBet           = self._mainViewCtl:getBaseBet()
	local betMul            = bet / baseBet
	local jpData            = {}
	for i=1, #link_config do
		local increment = incrementList[i] or 0
		jpData[i]       = self:getResetValue(link_config[i],mul) + increment
	end

	-- 更新本地reset值
	local local_config = jpConfig.local_config or {}
	local startIndex   = #link_config
	for i=1, #local_config do
		local jpValue        = local_config[i][2] * bet
		jpData[i+startIndex] = jpValue
	end

	return jpData
end

function baseJpCtl:getResetValue(jp_level, mul)
	local themeId = self._mainViewCtl:getThemeId()
	if not themeId then return end

	mul           = mul or 1
	local bet     = self._mainViewCtl:getCurTotalBet() -- self._mainViewCtl:getThemeControl():getCurTotalBet()
	local baseBet = self._mainViewCtl:getBaseBet()
	local betMul  = bet / baseBet

	local resetValue = JackpotControl:getInstance():getResetValue(themeId, jp_level, betMul) * mul

	return resetValue
end

function baseJpCtl:getSpineAniList()
	return self:getGameConfig().jackpot_config.ani_list
end
function baseJpCtl:getSpineDelay(status)
	if self:getGameConfig().jackpot_config.change_delay then
		local change_delay = self:getGameConfig().jackpot_config.change_delay
		if status == "lock" then
			return change_delay.lock or 0
		else
			return change_delay.unlock or 0
		end
	end
	return 0
end

function baseJpCtl:lockJackpotMeters(lock, index)
	local jpConfig = self._mainViewCtl:getThemeJackpotConfig()
	local jackpotLabels = self.jpView:getJackpotLabels() or {}
	if jpConfig == nil then return end

	local link_config = jpConfig.link_config or {}
	for i=1, #link_config do
		local single_lock = (index and index == i) or true
		if jackpotLabels[i] and single_lock then
			jackpotLabels[i]:lockJackpotMeter(lock)
		end
	end

end

function baseJpCtl:formatJackpotMeter(n)
	local jpConfig = self._mainViewCtl:getThemeJackpotConfig()
	local themeId = self._mainViewCtl:getThemeId()
	if jpConfig == nil or not themeId then return end

	local allowKList = jpConfig.allowK or {}
	local allowK     = allowKList[themeId] or false

	local last = ""
	if allowK then
		n = n / 1000
		n = math.floor(n)
		last = "K"
	end

	return FONTS.format(n, true) .. last
end


---------------------------------------------------------------------------------------------------

function baseJpCtl:getPic(name)
	return self._mainViewCtl:getPic(name)
end

function baseJpCtl:playMusicByName(name, singleton, loop)
	self._mainViewCtl:playMusicByName(name, singleton, loop)
end

function baseJpCtl:playMusicByOnce(file_name)
	self._mainViewCtl:playMusicByOnce(file_name)
end
function baseJpCtl:getCsbPath(file_name)
	return self._mainViewCtl:getCsbPath(file_name)
end

function baseJpCtl:getGameConfig()
	return self.gameConfig 
end

function baseJpCtl:dealMusic_FadeLoopMusic(duration, beginVolume, endVolume, delay)
	self._mainViewCtl:dealMusic_FadeLoopMusic(duration, beginVolume, endVolume, delay)
end

function baseJpCtl:showThemeDialog(theData, sType, dialogType)
    return self._mainViewCtl:showThemeDialog( theData, sType, dialogType )
end

function baseJpCtl:getSpineFile(file_name, notPathSpine)
    return self._mainViewCtl:getSpineFile(file_name, notPathSpine)
end


function baseJpCtl:getFntFilePath(file_name)
    return self._mainViewCtl:getFntFilePath(file_name)
end

-- function baseJpCtl:playNodeShowAction(node, animData)
-- 	self._mainViewCtl:playNodeShowAction(node, animData)
-- end

