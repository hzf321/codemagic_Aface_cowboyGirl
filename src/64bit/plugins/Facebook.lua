Facebook = class("Facebook")

function Facebook:ctor( ... )
	self._instance = nil
	self.userid = ""
end

function Facebook:getInstance( ... )
	if not self._instance then
		self._instance = Facebook.new()
	end
	return self._instance
end

function Facebook:callStaticMethod(callName, args, sigs, args_ios)
	-- 去掉Facebook
	if true or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return false
	end

	if Config.platform == "ios" then
		-- local luaoc = require "cocos.cocos2d.luaoc"
		-- local className = "BuglyManager"
		-- luaoc.callStaticMethod(className, callName, args_ios)
	else
		local luaj = require "cocos.cocos2d.luaj"
		local className = "org/cocos2dx/facebook/Facebook" .. bole.methomName()
		return luaj.callStaticMethod(className, callName, args, sigs)
	end
end

-- 设置回调
function Facebook:setCallback()
	print("Facebook setCallback")
	local callbackLua = function ( json_data )
		if not json_data then
			if self.successCallback then
				self.successCallback(1)
			end
		end

		local data = json.decode(json_data)
		dump(data, "Facebook login result", 10)
		if data and data.ret == 0 then
			-- 成功
			if data and data.userid then
				self.userid = data.userid
			end

			if self.successCallback then
				self.successCallback(0)
			end
		else
			-- 失败
			if self.successCallback then
				self.successCallback(1)
			end
			bole.showTips("An error has occurred, please try again!")
		end
    end

	local args_ios = {}
	local args = {callbackLua}
	local sigs = "(I)V"
	local methodName ="setCallback" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end

-- 登录
function Facebook:login(callback)
	self.successCallback = callback
	-- self:showLoading("getting your line id...")

	if self:isLoggedIn() then
		print("facebook login: true")
		return
	end

	local args_ios = {}
	local args = {"public_profile"}
	local sigs = "(Ljava/lang/String;)V"
	local methodName ="login" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end

-- 登出
function Facebook:loginOut()
	local args_ios = {}
	local args = {}
	local sigs = "()V"
	local methodName ="loginOut" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end

function Facebook:isLoggedIn( )
	local args_ios = {}
	local args = {}
	local sigs = "()boolean"
	local methodName ="isLoggedIn" .. bole.methomName()
	local ok, ret = self:callStaticMethod(methodName, args, sigs, args_ios)
	if not ok then
		return false
	else
		return ret
	end
end

function Facebook:getUserID( ... )
	return self.userid
end

function Facebook:hideLoading( ... )
	-- body
	if self.loading and self.loading.hide then
		self.loading:hide()
	end
	self.loading = nil
end

function Facebook:showLoading (txt)
	-- body
	self:hideLoading()
	self.loading = LoadingDialog.new(txt)
	self.loading:show()
end

function Facebook:getPicture(width, height)
	width = width or 128
	height = height or 128
	return self:getFbIconPic(width, height)
end

function Facebook:getFbIconPic(width, height)
	local id = self.userid
	local res = ""
	if width and height then
		res = string.format("https://graph.facebook.com/%s/picture?width=%d&height=%d", id, width, height)
	else
		res = string.format("https://graph.facebook.com/%s/picture", id)
	end
	return res
end

function Facebook:getName( ... )
	return self.name or ""
end

function Facebook:getFirstName( ... )
	return self.firstName or ""
end

function Facebook:getLastName( ... )
	return self.lastName or ""
end

function Facebook:hasLoginBefore ()
	return 1 == cc.UserDefault:getInstance():getIntegerForKey(FACEBOOK_HAS_LOGIN_BEFORE, 0)
end