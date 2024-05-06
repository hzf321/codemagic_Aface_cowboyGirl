
ThemeBaseAudioControl = class("ThemeBaseAudioControl")
local cls = ThemeBaseAudioControl

function cls:ctor( themeCtl, _audio_theme_rollup_list, audio_win_list )
	self.themeCtl = themeCtl

	self.node = cc.Node:create()
	self.themeCtl:getCurScene():addToContent(self.node)


	self.audio_win_list = {
		commonrollup03			= "sounds/bigwin/common_win3.mp3",
		commonrollup03_end		= "sounds/bigwin/common_win3end.mp3",
		commonrollup04			= "sounds/bigwin/common_win4.mp3",
		commonrollup04_end		= "sounds/bigwin/common_win4end.mp3",

		peopelrollup01			= "sounds/bigwin/win_bigwin.mp3",
		peopelrollup02			= "sounds/bigwin/win_hugewin.mp3",
		peopelrollup03			= "sounds/bigwin/win_massivewin.mp3",
		peopelrollup04			= "sounds/bigwin/win_apocalypticwin.mp3",
	}

	local _theme_rollup_music = {
		["rollup01"]	 = "audio/base/win1.mp3",
		["rollup01_end"] = "audio/base/win1end.mp3",
		["rollup02"]	 = "audio/base/win2.mp3",
		["rollup02_end"] = "audio/base/win2end.mp3",
		["rollup03"]	 = "audio/base/win3.mp3",
		["rollup03_end"] = "audio/base/win3end.mp3",
		["rollup04"]	 = "audio/base/win4.mp3",
		["rollup04_end"] = "audio/base/win4end.mp3",
	}
	self.audio_list = _audio_theme_rollup_list or _theme_rollup_music
	self.audio_win_list  = audio_win_list or self.audio_win_list
end

function cls:dealMusic_OutMuteLoopMusic( )
	local groupName = "loop"
	self.nowMusicValue = 1
	AudioControl:volumeGroupAudio(1)
	self:dealMusic_OutLoopMusicFade()
end

function cls:playMusic( name, singleton, loop )
	if name and self:isExistFile(name) then
		local audioFile = self.themeCtl:getPic(name)
		AudioControl:playEffect(audioFile,loop, singleton)
	end
end

-- 播放音效 通用音效
function cls:playCommonMusic( audioFile, singleton, loop )
	if audioFile and cc.FileUtils:getInstance():isFileExist(audioFile) then
		AudioControl:playEffect(audioFile, loop, singleton)
	end
end

-- 播放音效
function cls:playEffectWithInterval( name, interval, loop, singleton )
	if name and self:isExistFile(name) then
		local audioFile = self.themeCtl:getPic(name)
		AudioControl:playEffectWithInterval(audioFile,interval, loop, singleton)
	end
end

-- 停止音效
function cls:stopMusic( name, isCleanSingle )
	if self:isExistFile(name) then
		local audioFile = self.themeCtl:getPic(name)
		AudioControl:stopEffect(audioFile)
	end
end

-- 停止音效 通用音效
function cls:stopCommonMusic( audioFile, isCleanSingle )
	if cc.FileUtils:getInstance():isFileExist(audioFile) then
		AudioControl:stopEffect(audioFile)
	end
end

-- 播放背景音乐
function cls:playLoopMusic( name)
	local singleton = true
	local loop = true
	local audioFile = self.themeCtl:getPic(name)
	AudioControl:playMusic("music", audioFile, singleton, loop)
end

-- 结束所有背景音乐
function cls:stopAllLoopMusic( )
	AudioControl:stopGroupAudio("music")
end

function cls:refreshAllAudioVolume( )
	AudioControl:refreshAllAudioVolume()
end
-- 结束背景音乐
function cls:stopLoopMusicForStage( stageType)
end

function cls:dealMusic_PlayGameLoopMusic( file )
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(file)
	AudioControl:volumeGroupAudio(1)
end

-- -- 播放base game的背景音乐
-- function cls:dealMusic_PlayNormalLoopMusic()
-- 	-- 播放背景音乐
-- 	AudioControl:stopGroupAudio("music")
-- 	self:playLoopMusic(self.audio_list.base_background)
-- 	AudioControl:volumeGroupAudio(1)
-- end

-- -- 播放free games的背景音乐
-- function cls:dealMusic_PlayFreeSpinLoopMusic()
-- 	-- 播放背景音乐
-- 	AudioControl:stopGroupAudio("music")
-- 	self:playLoopMusic(self.audio_list.free_background)
-- 	AudioControl:volumeGroupAudio(1)
-- end

-- -- 播放bonus game的背景音乐
-- function cls:dealMusic_EnterBonusGame()
-- 	-- 播放背景音乐
-- 	AudioControl:stopGroupAudio("music")
-- 	self:playLoopMusic(self.audio_list.bonus_background)
-- 	AudioControl:volumeGroupAudio(1)
-- end

-- 结束bonus game的背景音乐
-- function cls:dealMusic_ExitBonusGame()
-- 	local name = self.audio_list.base_background
-- 	local stageType = 1
-- 	if self.ctl.freewin then
-- 		name = self.audio_list.free_background
-- 		stageType = 2
-- 	end

-- 	-- 播放背景音乐
-- 	self:playLoopMusic(name)
-- end

-- function cls:dealMusic_ExitPickGame()
-- 	local name = self.audio_list.free_background
-- 	-- 播放背景音乐
-- 	self:playLoopMusic(name)
-- end

-- 转轮停止声音
function cls:dealMusic_PlayReelStopMusic( pCol )
	self:playEffectWithInterval(self.audio_list["reel_stop"],0.1,false)
end

function cls:playRollupSound( mul )
	local winLevel
	if mul <= 0 then
		winLevel = nil
	elseif mul < 5 then
		winLevel = 1
	elseif mul < 10 then
		winLevel = 2
	elseif mul < 25 then
		winLevel = 3
	else
		winLevel = 4
	end

	if winLevel then
		if self.audio_win_list["commonrollup0"..winLevel] and self:isExistCommonFile(self.audio_win_list["commonrollup0"..winLevel]) then 
			local audioName = self.audio_win_list["commonrollup0"..winLevel]
			self:playCommonMusic(audioName, true, true)
		else
			local audioName = self.audio_list["rollup0" .. winLevel]
			self:playMusic(audioName, true, true)
		end
		
	end

	-- whj 新加 人声
	local peopelLevel
	if mul >=10 and mul<25 then 
		peopelLevel = 1
	elseif mul >=25 and mul<50 then 
		peopelLevel = 2
	elseif mul >=50 and mul<100 then 
		peopelLevel = 3
	elseif mul >=100 then 
		peopelLevel = 4
	end
	if peopelLevel then
		local music_name = "peopelrollup0" .. peopelLevel
        if self.themeCtl:getAudioFile(music_name) and self:isExistFile(self.themeCtl:getAudioFile(music_name)) then
            self:playMusic(self.themeCtl:getAudioFile(music_name))
        else
			local audioName2 = self.audio_win_list[music_name]
			self:playCommonMusic(audioName2)
		end
	end
end

-- 结束rollup声音
function cls:stopRollupSound( mul )
	local winLevel
	if mul <= 0 then
		winLevel = nil
	elseif mul < 5 then
		winLevel = 1
	elseif mul < 10 then
		winLevel = 2
	elseif mul < 25 then
		winLevel = 3
	else
		winLevel = 4
	end

	if winLevel then
		if self.audio_win_list["commonrollup0" .. winLevel] and self:isExistCommonFile(self.audio_win_list["commonrollup0" .. winLevel]) then 
			local stopAudioName = self.audio_win_list["commonrollup0" .. winLevel]
			self:stopCommonMusic(stopAudioName, true)
		else
			local stopAudioName = self.audio_list["rollup0" .. winLevel]
			self:stopMusic(stopAudioName, true)
		end

		if self.audio_win_list["commonrollup0"..winLevel.."_end"] and self:isExistCommonFile(self.audio_win_list["commonrollup0"..winLevel.."_end"]) then
			local audioName = self.audio_win_list["commonrollup0"..winLevel.."_end"]
			self:playCommonMusic(audioName)
		else
			local audioName = self.audio_list["rollup0" .. winLevel .. "_end"]
			self:playMusic(audioName)
		end

		-- local stopAudioName = self.audio_list["rollup0" .. winLevel]
		-- local audioName = self.audio_list["rollup0" .. winLevel .. "_end"]
		-- self:stopMusic(stopAudioName, true)
		-- self:playMusic(audioName)
	end

	-- whj 新加 人声
	local peopelLevel
	if mul >=10 and mul<25 then 
		peopelLevel = 1
	elseif mul >=25 and mul<50 then 
		peopelLevel = 2
	elseif mul >=50 and mul<100 then 
		peopelLevel = 3
	elseif mul >=100 then 
		peopelLevel = 4
	end
	if peopelLevel then
		local music_name = "peopelrollup0" .. peopelLevel
        if self.themeCtl:getAudioFile(music_name) and self:isExistFile(self.themeCtl:getAudioFile(music_name)) then
            self:stopMusic(self.themeCtl:getAudioFile(music_name))
        else
			local audioName2 = self.audio_win_list[music_name]
			self:stopCommonMusic(audioName2)
		end
	end
end
-- 结束rollup行为，默认调用stopRollupSound
function cls:stopRollUpFunction(mul)
	self:stopRollupSound(mul)
end

function cls:dealMusic_PlayWinMusic( rets, totalBet )
end

-- symbol音效相关
function cls:dealMusic_PlayThemeItemMusic( name, isSingle )
	-- if isSingle == nil then
	-- 	isSingle = true
	-- end
	self:playMusic(name, isSingle)
end

-- 打铃音效相关
function cls:dealMusic_PlayTriggerBellMusic()
	self:playMusic(self.audio_list.trigger_bell, false)
end


-- 声音从最大声音渐变到静音
function cls:dealMusic_FadeOutLoopMusic()
	self:dealMusic_FadeLoopMusic(1,1,0)
end

-- 延迟delay秒后，经过duration时间，声音从beginVolume线性变化到endVolume
function cls:dealMusic_FadeLoopMusic(duration, beginVolume, endVolume, delay)

	if not self.fadeMusicActionNode then
		self.fadeMusicActionNode = cc.Node:create()
		self.node:addChild(self.fadeMusicActionNode)
	end
	local nowMusicVolume = AudioControl:getVolume() or beginVolume
	if (nowMusicVolume - endVolume) < 0.01 and (nowMusicVolume - endVolume) > -0.01 then
		return
	end
	self.fadeMusicTag = true
	local groupName   = "loop"
	local fadeDur     = duration or 1
    local interval    = 1/10
    local actionList  = {}
    local frame       = math.modf(fadeDur/interval)
    local begVolume   = nowMusicVolume or 0
    local endVolume   = endVolume or 1
    local perChangeVolume = (endVolume-begVolume)/frame
    ----------------------------------------------------------------------
    local begDelay    = delay or 0
    local delayTime   = cc.DelayTime:create(begDelay)
    table.insert(actionList, delayTime)
    for i = 1, frame do
        local changeAction = cc.CallFunc:create(function()
			if self.fadeMusicTag then
				AudioControl:volumeGroupAudio(begVolume+perChangeVolume*i)
			end
		end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, delayTime)
        table.insert(actionList, changeAction)
    end
    self.fadeMusicActionNode:stopAllActions()
    self.fadeMusicActionNode:runAction(cc.Sequence:create( unpack(actionList) ))
end
-- 滚轮音效相关
function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效

	if self.playR1Col == nil then
		-- print("whj: self.audio_list.reel_notify,",self.audio_list.reel_notify)
		self:playMusic(self.audio_list.reel_notify, true, true)
	end
	self.playR1Col = pCol
	-- print("whj: self.playR1Col ",self.playR1Col)
end
function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end
	
	if self.playR1Col == pCol and pCol < #self.spinLayer.spins and self:checkNeedNotify(pCol+1) then
		return
	end
	self.playR1Col = nil
	self:stopMusic(self.audio_list.reel_notify,true)
end


function cls:playEffect( name, volume)
	local audioFile = "audio/"..name
	if self:isExistFile(audioFile..".mp3") then
		audioFile = self.themeCtl:getPic(audioFile..".mp3")
	elseif self:isExistFile(audioFile..".ogg") then
		audioFile = self.themeCtl:getPic(audioFile..".ogg")
	elseif self:isExistFile(audioFile..".wav") then
		audioFile = self.themeCtl:getPic(audioFile..".wav")
	else
		return
	end
	AudioControl:playEffect(audioFile,false )
end

function cls:dealMusic_NoWinMusic()
	if not self._music_no_Cnt then
		self._music_no_Cnt = 0
		--确定 v.mp3 个数，上限20
		for i=1,20 do
			if self:isExistFile("audio/no win "..i..".mp3") then
				self._music_no_Cnt = self._music_no_Cnt + 1
			else
				break
			end
		end
	end
	if self.NoWinCnt >= 4 and not self.n3_playing and math.random(0,99) < 3 and self._music_no_Cnt>=1 then
		self:lockThemeVoices()
	end
end

function cls:isExistFile(path)
	return cc.FileUtils:getInstance():isFileExist(self.themeCtl:getPic(path))
end

function cls:isExistCommonFile(path)
	return cc.FileUtils:getInstance():isFileExist(path)
end


-- function Theme:dealMusic_PlaySpecialSpeedMusic() -- 突然加速的音效(打鼓)
-- 	bole.playMusic("special_speed", nil, nil, self.themeCtl:getPic("audio/"))
-- end 




 

-- -- 滚轮音效相关
-- function Theme:dealMusic_TouchBtnSpinMusic( )
-- 	bole.playMusic("14_reel_click", nil, nil, "sounds/")
-- end

-- function Theme:dealMusic_PlaySpecialSymbolStopMusic( pCol )
-- 	self.hintMusicCnt = self.hintMusicCnt + 1
-- 	self:playMusic(self.audio_list["anticipation"])--..self.hintMusicCnt
-- end


-- -- bonus game音效
-- function Theme:dealMusic_PlayBGEnterMusic( )
-- 	self:playMusic("b1")
-- end
-- function Theme:dealMusic_StopBGEnterMusic( )
-- 	self:stopMusic("b1")
-- end
-- function Theme:dealMusic_PlayBGEnterClickMusic( )
-- 	self:playMusic("b2")
-- end
-- function Theme:dealMusic_PlayBGCollectMusic( )
-- 	self:playMusic("b3")
-- end
-- function Theme:dealMusic_StopBGCollectMusic( )
-- 	self:stopMusic("b3")
-- end
-- function Theme:dealMusic_PlayBGCollectClickMusic( )
-- 	self:playMusic("b4")
-- end
-- -- 背景音效相关
-- local normalLoopAudioFile    = "audio/s0.mp3"
-- local freespinLoopAuidoFile  = "audio/s1.mp3"
-- local bonusGameLoopAuidoFile = "audio/s4.mp3"




-- -- 静音
function cls:dealMusic_MuteLoopMusic( )
	local groupName = "loop"
	self.nowMusicValue = 0
	AudioControl:volumeGroupAudio(0)
	self:dealMusic_OutLoopMusicFade()
	-- self:stopActionByTag(777)
end
-- -- 把声音恢复成最大
function cls:dealMusic_OutMuteLoopMusic( )
	local groupName = "loop"
	self.nowMusicValue = 1
	AudioControl:volumeGroupAudio(1)
	self:dealMusic_OutLoopMusicFade()
end
-- 设置loop类型音乐的声音大小
function cls:dealMusic_SetLoopMusic(volume)
	if not volume then return end
	local groupName = "loop"
	self.nowMusicValue = volume
	self:dealMusic_OutLoopMusicFade()
	AudioControl:volumeGroupAudio(volume)
end

-- -- 停止音乐渐变动作
function cls:dealMusic_OutLoopMusicFade( )
	if self.fadeMusicActionNode then
		self.fadeMusicTag = false
		bole.cleanAction(self.fadeMusicActionNode)
	end
end



