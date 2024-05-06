local BLControllerBase  = require("UI/CreatorUI/BLControllerBase")
local AnimeController   = require("UI/CreatorUI/AnimeController")
local Clip              = require("UI/CreatorUI/Clip")

local Controller = class("Controller", BLControllerBase)

function Controller:ctor()
    self.__clipList = {}
    self.__currentClipName = {}
    self.__running = false
end

function Controller:getClipData(name)
    local clipData = require(name)
    if clipData then
        return clipData
    end
    return nil
end

function Controller:createAnimeWithClip(clipFileName, targetNode)
    local clipLuaData = self:getClipData(clipFileName)
    if clipLuaData == nil then
        return nil
    end
    
    local ac = AnimeController:create()

    local clip = Clip:create()
    clip:setLuaData(clipLuaData)

    ac:setClip(clip)
    ac:setTargetNode(targetNode)
    return ac, clipLuaData._name
end

function Controller:initUI()
    local ui = self.ui
    self.__root = self:getRoot();
    local config = self.__config
    self.__currentClipName = config.clipList[1]

    for _, clipName in ipairs(config.clipList) do
        local ac, name = self:createAnimeWithClip(clipName, self.__root)
        if ac then
            self.__clipList[name] = ac;

            if config.defaultClip == clipName then
                self.__currentClipName = name
            end

        end

    end

    if config.playOnLoad then
        self:play(self.__currentClipName)
    end
end

function Controller:update(dt)
    local clip = self.__clipList[self.__currentClipName]
    if nil == clip then
        return
    end

    if false == self.__running then
        return
    end

    clip:update(dt)

    if not clip:isRunning() then
        -- self:stopAll()
        self:stopUpdate()
    end

end

function Controller:stop()
    self.__running = false

    local clip = self.__clipList[self.__currentClipName]
    if nil == clip then
        return
    end

    self:stopUpdate()
    clip:stop()
end

function Controller:stopAll()
    self.__running = false

    for _, clip in pairs(self.__clipList) do
        clip:stop()
    end

    self:stopUpdate()
end

function Controller:startUpdate()
    -- local root = self:getRoot()
    self.__root:startUpdate()
end

function Controller:stopUpdate()
    -- local root = self:getRoot()
    self.__root:stopUpdate()
end

function Controller:playCurrent()
    return self:play(self.__currentClipName)
end

function Controller:play(clipName)

    local clip = self.__clipList[clipName]
    if clip == nil then
        -- print("clip : ", clipName, "not found")
        return
    end
    self.__currentClipName = clipName;
    -- 停止 所有 
    self:stopAll()
    self:startUpdate()
    self.__running = true
    -- 开启 对应的 内容
    return clip:playDefault(true)
end

function Controller:playFromToByName(fn, tn, dir)
    local clip = self.__clipList[self.__currentClipName]

    self:stopAll()
    self:startUpdate()
    self.__running = true
    -- 开启 对应的 内容
    return clip:playFromNameToName(fn, tn, dir)
end

function Controller:playFromToByNameAutoDirection(fn, tn)
    local clip = self.__clipList[self.__currentClipName]

    self:stopAll()
    self:startUpdate()
    self.__running = true
    -- 开启 对应的 内容
    return clip:playFromNameToNameAutoDirection(fn, tn)
end

-- 从某个时间开始播放到某个时间
function Controller:playByTimeToTime(st, et, dir)
    local clip = self.__clipList[self.__currentClipName]
    self:stopAll()
    self:startUpdate()
    self.__running = true
    -- 开启 对应的 内容
    return clip:playByTimeToTime(st, et, dir, 0)
end

-- 从某个时间开始播放
function Controller:playFromTime( st )
    local clip = self.__clipList[self.__currentClipName]
    self:stopAll()
    self:startUpdate()
    self.__running = true
    -- 开启 对应的 内容
    return clip:playFromTime(st)
end

function Controller:getClipByName(name)
    return self.__clipList[name]
end

function Controller:getCurrentClip()
    return self.__clipList[self.__currentClipName]
end

return Controller
