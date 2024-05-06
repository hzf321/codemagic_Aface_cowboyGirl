SETUP_DATA_KEY = "setup_data"

SettingControl = class("SettingControl")

local SETTING = 
{
	KEY_SOUND         = "sound",
	KEY_MUSIC         = "music",
}


local SOUND_STATUS =
{
	KEY_ON = 1,
	KEY_OFF = 0
}

local MUSIC_STATUS =
{
	KEY_ON = 1,
	KEY_OFF = 0
}

function SettingControl:ctor()
    self:initSettingStatus()
	self:reset()
end

function SettingControl:reset()
	self.setupData      = {}
end

function SettingControl:initSettingStatus( ... )
    self.tagSound        = cc.UserDefault:getInstance():getIntegerForKey(SETTING.KEY_SOUND, 1)
    self.tagMusic        = cc.UserDefault:getInstance():getIntegerForKey(SETTING.KEY_MUSIC, 1)
end

function SettingControl:getInstance( ... )
	if not self._instance then
		self._instance = SettingControl.new()
	end
	return self._instance
end

---------------------------  设置数据  ---------------------------------

-- 从本地数据获取设置数据
function SettingControl:getSetupToLocal()
    local adData = cc.UserDefault:getInstance():getStringForKey(SETUP_DATA_KEY)
    if adData ~= "" then
        self.setupData = json.decode(adData)
    else
        self.setupData = {
            music   = 0,
            sound   = 0,
        }
        self:saveLocalSetupData()
    end

    if  self.setupData.music == 0 then
        SettingControl:getInstance():setSettingStatus("music",  1)
    else
        SettingControl:getInstance():setSettingStatus("music",  0)
    end

    if  self.setupData.sound == 0 then
        SettingControl:getInstance():setSettingStatus("sound", 1 )
    else
        SettingControl:getInstance():setSettingStatus("sound", 0)
    end

    if self.setupData.music == 0 then
        cc.SimpleAudioEngine:getInstance():setMusicVolume(1)
    else
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0)
    end
    print(self.setupData.music, "music")
end

-- 将数据保存到本地缓存
function SettingControl:saveLocalSetupData()
    if next(self.setupData) then
        local dataStr = json.encode(self.setupData)
        cc.UserDefault:getInstance():setStringForKey(SETUP_DATA_KEY, dataStr)
    end
end

-- 音乐是否打开
function SettingControl:isMusicOpen()
    return self.setupData.music == 0
end

-- 刷新音乐开关
function SettingControl:updateMusicOpen(state)
    state = state or 0
    self.setupData.music = state
    self:saveLocalSetupData() 
end

-- 音效是否打开
function SettingControl:isSoundOpen()
    return self.setupData.sound == 0
end

-- 刷新音效开关
function SettingControl:updateSoundOpen(state)
    state = state or 0
    self.setupData.sound = state
    self:saveLocalSetupData() 
end


function SettingControl:setSettingStatus(key, value)
	if key == SETTING.KEY_SOUND then
		if value == SOUND_STATUS.KEY_OFF then
			AudioControl:setAllSoundVolume(0)
		elseif value == SOUND_STATUS.KEY_ON then
			AudioControl:setAllSoundVolume(1)
		end
		bole.refresh_G_SOUND_MUTE()
	elseif key == SETTING.KEY_MUSIC then
		if value == MUSIC_STATUS.KEY_OFF then
			AudioControl:setAllMusicVolume(0)
		elseif value == MUSIC_STATUS.KEY_ON then
			AudioControl:setAllMusicVolume(1)
		end
		bole.refresh_G_MUSIC_MUTE()
    end
	-- EventCenter:pushEvent(EVENTNAMES.SETTING.UPDATE_STATUS, key)
end

function SettingControl:getSettingStatus( key )
    if key == SETTING.KEY_SOUND then
        return self.tagSound
    elseif key == SETTING.KEY_MUSIC then
        return self.tagMusic
    end
end