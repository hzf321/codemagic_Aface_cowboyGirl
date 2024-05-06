--- Splunk --- a class about logging
--- communicate with serverside
--- to log down the login process

Splunk = class("Splunk")

function Splunk:ctor()
	self.instance = nil

	-- login track
	self.hasLogin = false
	self.login_index = 1
	self.process_map = {}
	
	self.enable_log_info = false
	self.last_send_time = 0
end

function Splunk:getInstance()
	if not self.instance then
		self.instance = Splunk.new()
	end
	return self.instance
end

function Splunk:send_codeInfo(stepName,obj,new_user)
	if bole.__isWeb__ then
		return
	end

	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        return
    end
	
	local  isNewUser = User:getInstance().isNewUser and 1 or 0
    if new_user and not User:getInstance().isNewUser then
        return
    end
	local user_id = 0
	local coins = 0
	if User:getInstance().user_id then
		user_id = User:getInstance().user_id
		coins = User:getInstance().coins
	end

	local infoStr = ""
	if obj then
		if type(obj) == "table" then
			for k, v in pairs(obj) do
				infoStr = infoStr .. k .."="..tostring(v)  .. ","
		 	end
		end
	end

	local platform = 1
	if bole.isIOS() then
		platform = 2
	elseif bole.isAmazon() then
		platform = 3
	elseif bole.isHuawei() then
		platform = 4
	end
	
	local time = os.time() * 1000
	if time <= self.last_send_time then
		self.last_send_time = self.last_send_time + 1;
	else
		self.last_send_time = time
	end	
	
	infoStr = infoStr ..'step='..stepName..",id="..user_id..",new="..isNewUser..",p="..platform..",c="..coins..",uuid="..bole.UUID..",ver="..Config.versionCode..',_t='..self.last_send_time
	if SplunkHEC then
		SplunkHEC:getInstance():sendData("EVENT_1",infoStr)
	end
end

function Splunk:send_codeInfo_JC(stepName,obj,new_user)
	local  isNewUser = User:getInstance().isNewUser and 1 or 0
    if new_user and not User:getInstance().isNewUser then
        return
    end
	local user_id = 000
	local coins = 0
	if User:getInstance().user_id then
		user_id = User:getInstance().user_id
		coins = User:getInstance().coins
	end

	local infoStr = ""
	if obj then
		if type(obj) == "table" then
			for k, v in pairs(obj) do
				infoStr = infoStr .. k .."="..v  .. ","
		 	end
		end
	end

	local platform = 1
	if bole.isIOS() then
		platform = 2
	elseif bole.isAmazon() then
		platform = 3
	elseif bole.isHuawei() then
		platform = 4
	end
	infoStr = infoStr ..'step='..stepName..",id="..user_id..",new="..isNewUser..",p=f"..platform..",c="..coins
	if SplunkHEC then
		SplunkHEC:getInstance():sendJCData("EVENT_1",infoStr)
	end
end

function Splunk:send_Error(infoStr)
	infoStr = "step=luaError, " .. infoStr
	if SplunkHEC then
		SplunkHEC:getInstance():sendData("EVENT_1",infoStr)
	end
end

function Splunk:log(infoStr)
end
