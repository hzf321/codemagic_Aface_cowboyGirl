 
Admop = class("Admop")

function Admop:ctor ()
	self._instance = nil
	self.successCallback = nil
 

	-- bole.potp:registerCmd(LINE_CONNECT, self.oncmd,self)
	-- bole.potp:registerCmd(LINE_LOGOUT, self.oncmd, self)
end

function Admop:getInstance (...)
	if not self._instance then
		self._instance = Admop.new()
	end
	return self._instance
end


function Admop:callStaticMethod(callName, args, sigs, args_ios)
	if  cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		return false
	end

	if Config.platform == "ios" then
		-- local luaoc = require "cocos.cocos2d.luaoc"
		-- local className = "BuglyManager"
		-- luaoc.callStaticMethod(className, callName, args_ios)
	else
		local luaj = require "cocos.cocos2d.luaj"
		local className = "org/cocos2dx/admop/Admop" .. bole.methomName()
		return luaj.callStaticMethod(className, callName, args, sigs)
	end
end

function Admop:openAd(callback)
    self.successCallback = callback
    local args_ios = {}
	local args = {}
	local sigs = "()V"
	local methodName = "openAd" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end


-- 设置回调
function Admop:setCallback()
	print("Admop setCallback")
	local callbackLua = function ( json_data )
		local data = json.decode(json_data)
		dump(data, "Admop login result", 10)
		if data and data.ret == 0 then
			-- 成功
			if self.successCallback then
				self.successCallback()
			end
		else
			-- 失败
			bole.showTips("Advertisement error, please try again!")
		end
		self.successCallback = nil
    end

	local args_ios = {}
	local args = {callbackLua}
	local sigs = "(I)V"
	local methodName = "setCallback" .. bole.methomName()
	self:callStaticMethod(methodName, args, sigs, args_ios)
end
