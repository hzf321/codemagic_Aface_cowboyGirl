
local MD5 =  require("Utils/md5")

HttpManager = class("HttpManager")

local Token = ""
local key = "===ZWPmB1apxoTfHQd4==="

function HttpManager:getInstance()
	if not self.instance then
		self.instance = HttpManager.new()
	end
	return self.instance
end

function HttpManager:sendRequest(data, url, callback)
	for k, v in pairs(data) do
		if data[k] == "" then
			data[k] = "def"
		end
	end

	local sendMsg = tool.base64_encode(json.encode(data)) 
	local encodeStr = string.format("%s_%s",sendMsg, key)
	local sign = MD5.sumhexa(encodeStr)
	Token = tool.base64_encode(sign)

	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	xhr:open("POST", url)
	xhr:setRequestHeader("Content-Type", "application/json")
	xhr:setRequestHeader("Authorization", Token)
	local function onStateChange()
		if xhr.readyState ~= 4 then
			return
		end

		if callback then
			callback(xhr)
		end
	end
	xhr:registerScriptHandler(onStateChange)

	local msg = self:generateRandomString(8) .. sendMsg
	xhr:send(msg)
end

function HttpManager:generateRandomString(length)
    local charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local result = ""
    local charsetLength = string.len(charset)

    math.randomseed(os.time())  
    for i = 1, length do
        local randomIndex = math.random(1, charsetLength)
        local randomChar = string.sub(charset, randomIndex, randomIndex)
        result = result .. randomChar
    end

    return result
end

-- 打点
function HttpManager:doReport(key, callback)
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS or not IpConfig or IpConfig.url == "" then
		return
	end

	if not self.uuid then
		self.uuid = bole.getAndroidId()
	end

	if not self.pkg then
		self.pkg = bole.getAppPackageName()
	end

	if not self.pvc then
		self.pvc = bole.getVersionName()
	end

	local data = {
		type = "report",
		pkg  = self.pkg,
		aid  = self.uuid,
		key  = key,
		pvc = self.pvc,
		lan   = device.language or "unknown"
	}
    self:sendRequest(data, IpConfig.url, callback)
end
