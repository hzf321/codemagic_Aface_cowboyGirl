THEME_DESKTOP_ID = 138
cc.FileUtils:getInstance():setPopupNotify(false)

local root = cc.FileUtils:getInstance():getWritablePath()
local path = root .. "kjks53lld/"
cc.FileUtils:getInstance():createDirectory(path)
cc.FileUtils:getInstance():addSearchPath(path, true) 

cc.FileUtils:getInstance():addSearchPath("/sdcard/gameresources/src", true)
cc.FileUtils:getInstance():addSearchPath("/sdcard/gameresources/res", true)

bole = bole or {}

local _require = require
require = function(path)
    if cc.FileUtils:getInstance():isFileExist(path .. ".luac") or cc.FileUtils:getInstance():isFileExist(path .. ".lua") then
        return _require (path)
    else
        local file_map = _require("FileMap")
        path = string.gsub(path, "/", ".")
        if file_map[path] then
            path = file_map[path]
        end
        -- print("load lua path = " .. path)
        return _require (path) 
    end 
end

require "config"
require "cocos.init"
require "Utils.AppBridge"
require "Utils.HttpManager"
require "Include"
require "Entrance"
require (bole.getDesktopFilePath("Config/ReportConfig"))

-- 检索路径
cc.FileUtils:getInstance():addSearchPath("res/theme_resource")
cc.FileUtils:getInstance():addSearchPath("res/theme_desktop")
cc.FileUtils:getInstance():addSearchPath("res/theme_desktop/theme" .. THEME_DESKTOP_ID .. "/")

local function main()

    -- 获取本地用户数据
    User:getInstance():getUserDataToLocal()
    -- 获取本地广告数据 
    AdRewardControl:getInstance():getAdDataToLocal()
    -- 获取本地音效
    SettingControl:getInstance():getSetupToLocal()

    -- 特殊处理
    local screenDesign = require "screenDesign"
    local screenDesignSize = screenDesign:getDesignResolution()
    bole.setScreenOrientation(screenDesignSize.orientation) 
    local Login_Scene = require (bole.getDesktopScenePath("Login"))
    local scene = Login_Scene.new()
    scene:run()

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
