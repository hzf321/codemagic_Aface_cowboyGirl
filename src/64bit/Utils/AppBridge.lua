
bole.methomName = function ()
	if THEME_DESKTOP_ID == 188 then
		return ""
	end
	local nameSuffix = "Slots" .. THEME_DESKTOP_ID
	return nameSuffix
end

bole.setKeepScreen = function(bAwake)
	if true or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return
	end

	 
	local args = {bAwake}
	local sigs = "(Z)V"

	local luaj = require "cocos.cocos2d.luaj"
	local className = "org/cocos2dx/lua/AppActivity"
	local MethodName = "setKeepScreen" .. bole.methomName()
	luaj.callStaticMethod(className, MethodName, args, sigs)
end

bole.getAndroidId = function()
	if true or  cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return "0000"
	end
	
	local args = {}
	local sigs = "()Ljava/lang/String;"
	
	local luaj = require "cocos.cocos2d.luaj"
	local className = "org/cocos2dx/lua/AppActivity"
	local MethodName = "getAndroidId" .. bole.methomName()
	local ok, uuid = luaj.callStaticMethod(className, MethodName, args, sigs)
	if not ok then
		uuid = "0000"
	end
	return uuid
end

bole.getAppPackageName = function()
	if true or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return "package.name"
	end

	local args = {}
	local sigs = "()Ljava/lang/String;"

	local luaj = require "cocos.cocos2d.luaj"
	local className = "org/cocos2dx/lua/AppActivity"
	local MethodName = "getAppPackageName" .. bole.methomName()
	local ok, pkg = luaj.callStaticMethod(className, MethodName, args, sigs)
	if not ok then
		pkg = "package.name"
	end
	return pkg
end

bole.getVersionName = function()
	if true or  cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return "0000"
	end
	
	local args = {}
	local sigs = "()Ljava/lang/String;"

	local luaj = require "cocos.cocos2d.luaj"
	local className = "org/cocos2dx/lua/AppActivity"
	local MethodName = "getVersionName" .. bole.methomName()
	local ok, pkg = luaj.callStaticMethod(className, MethodName, args, sigs)
	if not ok then
		pkg = "0000"
	end
	return pkg
end

bole.setScreenOrientation = function(orientation)

 if true then
        return
    end
	local director = cc.Director:getInstance()
    local glView   = director:getOpenGLView()
	local screenSize = glView:getFrameSize()
	local designSize = {width = 1280, height = 720}

	if true or  cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		director:pause()
		if orientation == 1 then
			glView:setFrameSize(1280, 720)
			glView:setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.FIXED_HEIGHT)
		elseif orientation == 2 then
			glView:setFrameSize(720 * 0.75, 1280 * 0.75)
			glView:setDesignResolutionSize(designSize.height, designSize.width, cc.ResolutionPolicy.FIXED_WIDTH)
		end
		director:resume()
		return 
	end

	local requestedOrientation = bole.getOrientation()
	if requestedOrientation == orientation then
		return
	end
	
	local args = {orientation}
	local sigs = "(I)V"

	local luaj = require "cocos.cocos2d.luaj"
	local className = "org/cocos2dx/lua/AppActivity"
	local MethodName = "changeOrientation" .. bole.methomName()
	luaj.callStaticMethod(className, MethodName, args, sigs)

	if orientation == 1 then
		glView:setFrameSize(screenSize.height, screenSize.width)
		glView:setDesignResolutionSize(designSize.width, designSize.height, cc.ResolutionPolicy.FIXED_HEIGHT)
	elseif orientation == 2 then
		glView:setFrameSize(screenSize.height, screenSize.width)
		glView:setDesignResolutionSize(designSize.height, designSize.width, cc.ResolutionPolicy.FIXED_WIDTH)
	end
end

bole.getOrientation = function()
	if true or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return 
	end

	local args = {}
	local sigs = "()I"

	local luaj = require "cocos.cocos2d.luaj"
	local className = "org/cocos2dx/lua/AppActivity"
	local MethodName = "getOrientation" .. bole.methomName()
	local ok, ret = luaj.callStaticMethod(className, MethodName, args, sigs)
	if not ok then
		return -1
	else
		return ret or -1
	end
end
