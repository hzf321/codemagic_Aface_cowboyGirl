--------------------------------------------------------------------------------------------
--                                         nsm                                            --
-- Creation Date:2017-03-01
-- Adjust   Date:2017-04-27
--      1，将"loop"之外的音效处理，改回原有逻辑
-- 相关问题：
--      1，前后台切换对ccexp.audioEngine播放音效的处理
--------------------------------------------------------------------------------------------
-- require "Controllers/SettingControl" 
-- require "Systems/Setting/SettingControl"
G_AUDIO_VALUE = 1   --音效音量(0~1)
G_AUDIO_MUTE = false
G_SOUND_MUTE = false
G_MUSIC_MUTE = false
local M = class("M")
function M:ctor()
    self.idGroupList     = {}
    self.singleTagList   = {}
    self.simpleAudioList = {}
    self.intervalList = {}
    -- 保存当前播放的背景音乐的相关参数，用于关闭界面时，恢复之前的背景音乐
    self.curMusic = nil
end
--------------------------------------------------------------------------------------------
-- 场景切换时，整体对音效进行处理
--------------------------------------------------------------------------------------------
function M:onSceneSwitch( )
    -- uncacheAll包含stopAll作用
    -- self:uncacheGroupAudio()
    self:uncacheAll()
    -- self:cleanAllSingleTag()
end
--------------------------------------------------------------------------------------------
-- 音效加载相关：
--------------------------------------------------------------------------------------------
function M:preloadAudio( theFilePro, theNameList, filters, endCallBack )
    --------------------------------------------
    -- 现有版本，ccexp.AudioEngine没有加载接口
    --------------------------------------------
    local ret = {}
    --filters = filters or {"s%d+.*"}
    theFilePro  = theFilePro or ""
    theNameList = theNameList or {}
    local cnt = 1
    for _,theName in ipairs(theNameList) do
        cnt = cnt + 1
        local entry 
        local scheduler = cc.Director:getInstance():getScheduler()
        entry = scheduler:scheduleScriptFunc(function ()
            scheduler:unscheduleScriptEntry(entry)
            if bole.isIOS() then
                ccexp.AudioEngine:preload(theFilePro..theName)
            else
                AudioEngine.preloadEffect(theFilePro..theName)
            end
            endCallBack()
        end, 0.05*cnt, false)
        table.insert(ret, theFilePro..theName)
    end    
    return ret
end

function M:unloadEffect( name )
    if bole.isIOS() then
        -- print("music ios unloadEffect ",name)
        ccexp.AudioEngine:uncache(name)
    else
        -- print("music android unloadEffect ",name)
        AudioEngine.unloadEffect(name)
    end
end

function M:preloadMusic( name )
    if bole.isIOS() then
        -- print("music ios preloadMusic ",name)
        ccexp.AudioEngine:preload(name)
    else
        -- print("music android preloadMusic ",name)
        AudioEngine.preloadMusic(name)
    end
end

function M:preloadEffect( name )
    if bole.isIOS() then
        -- print("music ios preloadEffect ",name)
        ccexp.AudioEngine:preload(name)
    else
        -- print("music android preloadEffect ",name)
        AudioEngine.preloadEffect(name)
    end
end
--------------------------------------------------------------------------------------------
-- 音效资源卸载相关：
-- 1，卸载的同事相关音效也会同事停止
--------------------------------------------------------------------------------------------
function M:uncacheAudio( audioFile )
    -- ccexp.AudioEngine:uncache(audioFile)
end

function M:pauseAllEffects( ... )
    if bole.isIOS() then
        -- print("music ios pauseAllEffects ")
        ccexp.AudioEngine:pauseAll()
    else
        -- print("music android pauseAllEffects ")
        AudioEngine.pauseAllEffects()
    end
end

function M:resumeAllEffects( ... )
    if bole.isIOS() then
        -- print("music ios resumeAllEffects ")
        ccexp.AudioEngine:resumeAll()
    else
        -- print("music android resumeAllEffects ")
        AudioEngine.resumeAllEffects()
    end
end

function M:uncacheGroupAudio( groupName )
    -- groupName = groupName or "define"
    -- if groupName == "loop" then
    --     self.idGroupList[groupName] = self.idGroupList[groupName] or {}
    --     for theAudioFile,theAIDList in pairs(self.idGroupList[groupName]) do
    --         ccexp.AudioEngine:uncache(theAudioFile)
    --     end
    --     self.idGroupList[groupName] = nil
    -- end
end
function M:uncacheAll( )
    -- ccexp.AudioEngine:uncacheAll()
    -- self.idGroupList   = {}
end
--------------------------------------------------------------------------------------------
-- 音效停止相关：
--------------------------------------------------------------------------------------------
function M:stopAudio( groupName, audioFile, isClearSingleTag )
    groupName = groupName or "effect"
    if groupName == "music" then
        self.curMusic = nil
        if bole.isIOS() then
            -- print("music ios loop stopAudio ")
            if self.preMusicId then
                ccexp.AudioEngine:stop(self.preMusicId)
                self.preMusicId = nil
            end
        else
            -- print("music android loop stopAudio ")
            AudioEngine.stopMusic()
        end
    else
        if self.simpleAudioList[audioFile] then
            if bole.isIOS() then
                -- print("music ios stopAudio ")
                ccexp.AudioEngine:stop(self.simpleAudioList[audioFile])
            else
                -- print("music android stopAudio ")
                AudioEngine.stopEffect(self.simpleAudioList[audioFile])
            end 
            self.simpleAudioList[audioFile] = nil
        end
    end
end
function M:stopGroupAudio( groupName, isClearSingleTag )
    groupName = groupName or "music"
    if groupName == "music" then
        self.curMusic = nil
        if bole.isIOS() then
            -- print("music ios loop stopGroupAudio ")
            if self.preMusicId then
                ccexp.AudioEngine:stop(self.preMusicId)
                self.preMusicId = nil
            end
        else
            -- print("music android loop stopGroupAudio ")
            AudioEngine.stopMusic()
        end
    else
        if bole.isIOS() then
            -- print("music ios stopGroupAudio ")
            ccexp.AudioEngine:stopAll()
            self.preMusicId = nil
            self.simpleAudioList = {}
        else
            -- print("music android stopGroupAudio ")
            AudioEngine.stopAllEffects()
        end
        self.simpleAudioList = {}
    end
end

function M:stopAllEffects()
    for theAudioFile,theAID in pairs(self.simpleAudioList) do
        if theAID then
            if bole.isIOS() then
                -- print("music ios stopAllEffects ")
                ccexp.AudioEngine:stop(theAID)
            else
                -- print("music android stopAllEffects ")
                AudioEngine.stopEffect(theAID)
            end
        end
    end
    self.simpleAudioList = {}
end

function M:cleanAllSingleTag( )
    self.simpleAudioList = {}
end
--------------------------------------------------------------------------------------------
-- 音效音量控制相关
--------------------------------------------------------------------------------------------
function M:volumeGroupAudio(volume)

    if volume and (volume > 0 or volume < 1) and G_SOUND_MUTE then -- 认为音量在0到1之间是调整音乐音量，在音效静音状态下不可以调整音乐的音量
        return 
    end

    if not G_MUSIC_MUTE then
        if bole.isIOS() then
            if self.preMusicId then
                ccexp.AudioEngine:setVolume(self.preMusicId, volume)
            end
        else
            AudioEngine.setMusicVolume(volume)
        end
    end
end

function M:refreshAllAudioVolume()
    self:volumeGroupAudio(1)
end

--设置界面的音乐开关控制
function M:setAllAudioVolume (volume)
    -- print("music android ios setAllAudioVolume ",volume)
    local settingCtl = SettingControl:getInstance()
    if settingCtl:getSettingStatus("sound") ~= volume then
        if bole.isIOS() and self.preMusicId and volume then
            ccexp.AudioEngine:setVolume(self.preMusicId, volume)
        else
            AudioEngine.setMusicVolume(volume)
        end
        
        if volume == 0 then
            self:stopAllEffects()
        end
   end
end

-- 设置界面的音乐开关控制 music
function M:setAllMusicVolume(volume)
    local settingCtl = SettingControl:getInstance()
--     if settingCtl:getSettingStatus("music") ~= volume then
        if bole.isIOS() and self.preMusicId and volume then
            ccexp.AudioEngine:setVolume(self.preMusicId, volume)
        else
            AudioEngine.setMusicVolume(volume)
        end
--    end
end

-- 设置界面的音效开关控制 sound
function M:setAllSoundVolume (volume)
    local settingCtl = SettingControl:getInstance()
    if settingCtl:getSettingStatus("sound") ~= volume then
        if volume == 0 then
            self:stopAllEffects()
        end
   end
end

--设置界面的音乐开关控制
function M:getVolume ()
    if bole.isIOS() then
        if self.preMusicId then
            return ccexp.AudioEngine:getVolume(self.preMusicId)
        end
        return nil
    else
        return AudioEngine.getMusicVolume()
    end
end

function M:playEffect( audioFile, loop ,isSingle)
    if G_SOUND_MUTE then
        return nil
    else
        if isSingle and self.simpleAudioList[audioFile] then
            return
        end
        loop = loop or false
        local audioId
        if bole.isIOS() then
            -- print("music ios playEffect ",audioFile)
            audioId = ccexp.AudioEngine:play2d(audioFile, loop)
        else
            -- print("music android playEffect ",audioFile)
            audioId = AudioEngine.playEffect(audioFile, loop)
        end
        if audioId then
            self.simpleAudioList[audioFile] = audioId
        end
        return audioId
    end
end

function M:playEffectWithInterval( audioFile, interval,loop, isSingle)
    if G_SOUND_MUTE then
        return nil
    else
        interval = interval or 0.1
        if self.intervalList[audioFile] then
            if os.time() - self.intervalList[audioFile] < interval then
                return
            end
        end
        self.intervalList[audioFile] = os.time() 
        loop = loop or false
        -- if bole.isIOS() then
        --     ccexp.AudioEngine:play2d(audioFile, loop)
        -- else
        --     AudioEngine.playEffect(audioFile, loop)
        -- end
        self:playEffect(audioFile, loop, isSingle)
    end

end


function M:stopEffect( audioFile )
    if self.simpleAudioList[audioFile] then
        if bole.isIOS() then
            -- print("music ios stopEffect ",audioFile)
            ccexp.AudioEngine:stop(self.simpleAudioList[audioFile])
        else
            -- print("music android stopEffect ",audioFile)
            AudioEngine.stopEffect(self.simpleAudioList[audioFile])
        end 
        self.simpleAudioList[audioFile] = nil
    end
end

function M:stopEffectById( audioId )
    if audioId then
        if bole.isIOS() then
            -- print("music ios stopEffectById ",audioId)
            ccexp.AudioEngine:stop(audioId)
        else
            -- print("music android stopEffectById ",audioId)
            AudioEngine.stopEffect(audioId)
        end 
    end
end

function M:playMusic( groupName, audioFile, isSingle, isLoop )
    groupName = groupName or "effect"
    if groupName == "music" then
        self.curMusic = {
            groupName = groupName,
            audioFile = audioFile,
            isSingle = isSingle,
            isLoop = isLoop,
        }
        if bole.isIOS() then
            -- print("music ios playMusic ",audioFile)
            if self.preMusicId then
                ccexp.AudioEngine:stop(self.preMusicId)
                self.preMusicId = nil
            end
            self.preMusicId = ccexp.AudioEngine:play2d(audioFile, isLoop)
            if G_MUSIC_MUTE then
                -- print("music 静音")
                ccexp.AudioEngine:setVolume(self.preMusicId, 0)
            end
        else
            -- print("music android playMusic ",audioFile)
            AudioEngine.playMusic(audioFile,isLoop)
            if G_MUSIC_MUTE then
                -- print("music 静音")
                AudioEngine.setMusicVolume(0)
            end
        end
    elseif not G_SOUND_MUTE then
        if isSingle and self.simpleAudioList[audioFile] then
            return
        end
        local audio
        if bole.isIOS() then
            -- print("music ios effect playMusic ",audioFile)
            audio = ccexp.AudioEngine:play2d(audioFile, isLoop)
        else
            -- print("music android effect playMusic ",audioFile)
            audio = AudioEngine.playEffect(audioFile, isLoop)
        end
        if audio then
            self.simpleAudioList[audioFile] = audio
        end
    end
end

function M:pauseAudio()
    if bole.isIOS() then
        -- print("music ios pauseAudio ")
        ccexp.AudioEngine:pauseAll()
    else
        -- print("music android pauseAudio ")
        AudioEngine.pauseMusic()
    end
end

function M:resumeAudio()
    if bole.isIOS() then
        -- print("music ios resumeAudio ")
        ccexp.AudioEngine:resumeAll()
    else
        -- print("music android resumeAudio ")
        AudioEngine.resumeMusic()
    end
end

function M:getCurMusicParams( ... )
    return self.curMusic
end

--播放网络下载的音乐
function M:playWebMusic(url)
    if string.find(url, "http://") or string.find(url, "https://") then  -- download from other servers
        local fileName = bole.hash(url) .. ".mp3"
        local isExist = cc.FileUtils:getInstance():isFileExist(fileName)
        if isExist then
            -- print("zhf AudioControl playWebMusic ",url,fileName)
            self:playMusic("music",fileName,true,true)
            return true
        else
            -- print("zhf AudioControl download music ",url)
            HttpRequest:getInstance():downloadMp3(url, nil)
        end
    end
    return false
end

AudioControl = M.new()
