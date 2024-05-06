libMM = {}

libMM.unloadTexture = function (path)
	local textureCache = cc.Director:getInstance():getTextureCache()
	if path then
		textureCache:removeTextureForKey(path)
	end
end

libMM.unloadTextureByList = function (path_list)
	TimerCallFunc:getInstance():addCallFunc(function( ... )
			local textureCache = cc.Director:getInstance():getTextureCache()
			if path_list then
				for _, path in pairs(path_list) do
					if path then
						textureCache:removeTextureForKey(path)
					end
				end
			end
		end, 0.5)
end

libMM.loadTextureAsync = function (path, complete_func)
	local textureCache = cc.Director:getInstance():getTextureCache()
	if path then
		textureCache:addImageAsync(path, function ( ... ) 
			if complete_func then 
				complete_func() 
			end 
		end)
	end
end

libMM.setIntegerForKey = function (key, value)
	cc.UserDefault:getInstance():setIntegerForKey(key .. (User:getInstance().user_id or 10000), value)
end

libMM.getIntegerForKey = function (key,default)
	default = default or 0
	return cc.UserDefault:getInstance():getIntegerForKey(key .. (User:getInstance().user_id or 10000), default)
end

libMM.setBoolForKey = function (key, value)
	cc.UserDefault:getInstance():setBoolForKey(key .. (User:getInstance().user_id or 10000), value)
end

libMM.getBoolForKey = function (key,default)
	return cc.UserDefault:getInstance():getBoolForKey(key .. (User:getInstance().user_id or 10000), default)
end

libMM.setFloatForKey = function (key, value)
	cc.UserDefault:getInstance():setFloatForKey(key .. (User:getInstance().user_id or 10000), value)
end

libMM.getFloatForKey = function (key,default)
	default = default or 0
	return cc.UserDefault:getInstance():getFloatForKey(key .. (User:getInstance().user_id or 10000), default)
end

libMM.setStringForKey = function (key, value)
	cc.UserDefault:getInstance():setStringForKey(key .. (User:getInstance().user_id or 10000), value)
end

libMM.getStringForKey = function (key,default)
	return cc.UserDefault:getInstance():getStringForKey(key .. (User:getInstance().user_id or 10000), default)
end