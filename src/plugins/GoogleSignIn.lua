GoogleSignIn = class("GoogleSignIn")

function GoogleSignIn:ctor( ... )
	self._instance = nil
	self.successCallback = nil
	self.userid = ""
end

function GoogleSignIn:getInstance( ... )
	if not self._instance then
		self._instance = GoogleSignIn.new()
	end
	return self._instance
end

function GoogleSignIn:callStaticMethod(callName, args, sigs, args_ios)
	if  cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return false
	end


	if Config.platform == "ios" then
		-- local luaoc = require "cocos.cocos2d.luaoc"
		-- local className = "BuglyManager"
		-- luaoc.callStaticMethod(className, callName, args_ios)
	else
		local luaj = require "cocos.cocos2d.luaj"
		local className = "com.example.signin/SignIn" .. bole.methomName()
		return luaj.callStaticMethod(className, callName, args, sigs)
	end
end

-- 登录
function GoogleSignIn:login(callback)
	self.successCallback = callback
	-- self:showLoading("getting your line id...")

	-- if self:isLoggedIn() then
	-- 	print("GoogleSignIn login: true")
	-- 	return
	-- end
    print(12121212333)
	local args_ios = {}
	local args = {}
	local sigs = "()V"
	local methodName ="signIn" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end

-- 登出
function GoogleSignIn:loginOut(callback)
	self.successCallback = callback
	local args_ios = {}
	local args = {}
	local sigs = "()V"
	local methodName ="signOut" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end


-- 设置回调
function GoogleSignIn:setCallback(callback)
	self.successCallback = callback
	print("注册回调 SignIn setCallback")
	local callbackLua = function ( json_data )
		local data = json.decode(json_data)
		dump(data, "注册回调 SignIn login result", 10)
		-- 0： 登录成功。 1 退出成功， 2登录失败 3,登录过了
		if data and data.ret == 0 then
			-- 登录成功
			if self.successCallback then
				bole.showTips("SignIn Success")
				self.successCallback()
			end
		elseif data and data.ret == 1 then
			-- 退出成功
			if self.successCallback then
				bole.showTips("SignOut Success")
				self.successCallback()
			end
		elseif data and data.ret == 3 then
			-- 退出成功
			if self.successCallback then
				self.successCallback()
			end
		else
			-- 失败
			bole.showTips("SignIn error, please try again!")
		end
		self.successCallback = nil
    end

	local args_ios = {}
	local args = {callbackLua}
	local sigs = "(I)V"
	local methodName = "setCallback" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end
