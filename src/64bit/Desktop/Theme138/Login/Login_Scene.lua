local Login_View = require (bole.getDesktopFilePath("Login/Login_View"))

local Login_Scene = class("Login_Scene", Scene)

function Login_Scene:ctor(enterlobby_callback)
    self.sceneName = "Login_Scene"
	self.super.ctor(self)   -- 此处必须使用“.”来调用父类构造函数
	self.enterlobby_callback = enterlobby_callback
    bole.playBGM("hallbg")
	self:initLayout()

	local screenCtl = ScreenControl:getInstance()
    screenCtl:setScreenOrientation(false)

    HttpManager:getInstance():doReport(ReportConfig.view_login)
end


function Login_Scene:initLayout()
    local winSize = cc.Director:getInstance():getWinSize()
    local layer = Login_View.new()
    -- local layer = require "UI/LoginView".new()
    layer:setPosition(winSize.width / 2, winSize.height / 2)
    self:addChild(layer, 1)
    local playLoadData = require (string.format("Desktop/Theme%d/Theme/PlayLoad", THEME_DESKTOP_ID))
	local data = playLoadData.img_data
    -- 需要预加载的图片路径
    local imagePaths = data
    -- 判断是否有配置
    if not imagePaths then return end

    for index = 1, #imagePaths do
        -- 异步加载图片
        cc.Director:getInstance():getTextureCache():addImageAsync(imagePaths[index], function(texture)
            -- 图片加载完成后的回调函数
            if texture then
                -- 图片加载成功
                print("Image loaded successfully:", imagePaths)
            else
                -- 图片加载失败
                print("Failed to load image:", imagePaths)
            end
        end)
    end
end

function Login_Scene:onExit( ... )
	Scene.onExit(self)
end

function Login_Scene:addToGuide( node, zorder )
	self.__layer:addChild(node, zorder)
end

return Login_Scene
