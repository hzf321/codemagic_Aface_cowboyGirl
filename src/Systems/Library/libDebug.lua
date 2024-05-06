
libDebug = {}

local function printTableItem(owner, data)
	for k, v in pairs(data) do
		if type(v) == "table" then
			if type(k) == "string" then
				libDebug.print(owner .. "[\"" .. k .. "\"] = ")
			else
				libDebug.print(owner .. "[" .. k .. "] = ")
			end
			libDebug.print(owner .. "{")
			printTableItem(owner .. "  ", v)
			libDebug.print(owner .. "}")
		else
			if type(k) == "string" then
				if type(v) == "number" or type(v) == "string" then
					libDebug.print(owner .. "[\"" .. k .. "\"] = " .. v .. " (" .. type(v) .. ")")
				else
					libDebug.print(owner .. "[\"" .. k .. "\"] = ", v)
				end	
			else
				if type(v) == "number" or type(v) == "string" then
					libDebug.print(owner .. "[" .. k .. "] = " .. v .. " (" .. type(v) .. ")")
				else
					libDebug.print(owner .. "[" .. k .. "] = ", v)
				end
			end
			
		end
	end
end

function libDebug.print(owner, ...)
	print(owner, ...)
end

function libDebug.printTable(owner, data)
	libDebug.print(owner)
	libDebug.print(owner .. "================== Print Table Start =================")

	if type(data) ~= "table" then
		libDebug.print(owner .. "This is a " .. type(data) .. ", rather than a table! [", data, "]")
	else
		libDebug.print(owner .. "[data] = ")
		libDebug.print(owner .. "{")
		printTableItem(owner .. "  ", data)
		libDebug.print(owner .. "}")
	end

	libDebug.print(owner .. "================== Print Table End =================")
	libDebug.print(owner)

	
end





-- 对比两个table是否相同，打印不同的值
function libDebug.checkTable( t1, t2, ks )
    ks = ks or "root"
    local checkedKeys = {}
    local isSame = true

    for k, v1 in pairs(t1) do
        if not checkedKeys[k] then
            checkedKeys[k] = true
            -- print("check : ", ks.." -> "..k)
            local v2 = t2[k]
            if (v2 ~= nil) and type(v1) == type(v2) then
                if type(v1) == "table" then
                    isSame = libDebug.checkTable(v1, v2, ks.." -> "..k) and isSame
                else
                    if v1 ~= v2 then
                        isSame = false
                        print("diff : ===================================")
                        print("diff : k", ks.." -> "..k)
                        print("diff : v1", v1)
                        print("diff : v2", v2)
                        print("diff : ===================================")
                    end
                end
            else
                isSame = false
                print("diff : ===================================")
                print("diff : k", ks.." -> "..k)
                print("diff : v1", v1, type(v1))
                print("diff : v2", v2, type(v2))
                print("diff : ===================================")
            end
        end
    end
    for k, v2 in pairs(t2) do
        if not checkedKeys[k] then
            checkedKeys[k] = true
            -- print("check : ", ks.." -> "..k)
            local v1 = t1[k]
            if (v1 ~= nil) and type(v1) == type(v2) then
                if type(v1) == "table" then
                    isSame = libDebug.checkTable(v1, v2) and isSame
                else
                    if v1 ~= v2 then
                        isSame = false
                        print("diff : ===================================")
                        print("diff : k", ks.." -> "..k)
                        print("diff : v1", v1)
                        print("diff : v2", v2)
                        print("diff : ===================================")
                    end
                end
            else
                isSame = false
                print("diff : ===================================")
                print("diff : k", ks.." -> "..k)
                print("diff : v1", v1, type(v1))
                print("diff : v2", v2, type(v2))
                print("diff : ===================================")
            end
        end
    end
    return isSame
end



-- 上传日志，日志名为 userId_owner_2021_04_10__00_28_21
libDebug._logPath = {}
-- 日志开关接口
function libDebug.startLog( owner )
    if not appDebugMode then return end

    local logDir = string.format("%slog/", cc.FileUtils:getInstance():getWritablePath())
    if not cc.FileUtils:getInstance():isDirectoryExist(logDir) then
        cc.FileUtils:getInstance():createDirectory(logDir)
    end
    local filePath = string.format("%s%s_%s", logDir, tostring(SettingControl:getInstance():parseUserID()), owner)
    libDebug._logPath[owner] = filePath
end
-- 一次写入
function libDebug.endLog( owner )
    if not appDebugMode then return end

    libDebug.sendLog(owner)
end
function libDebug.sendLog( owner )
    local ip = string.match(bole.scriptServer, ".*%d+%.%d+%.%d+%.%d+")
    if not ip then return end

    local logDir = string.format("%slog/", cc.FileUtils:getInstance():getWritablePath())
    if not cc.FileUtils:getInstance():isDirectoryExist(logDir) then return end

    local fileName = string.format("%s_%s", tostring(SettingControl:getInstance():parseUserID()), owner)
    local filePath = string.format("%s%s", logDir, fileName)
    if not cc.FileUtils:getInstance():isFileExist(filePath) then return end

    local fileTime = os.date("%m-%d %H:%M:%S", os.time())
    local fileTimeName = string.format("%s_%s", fileName, fileTime)
    local fileTimePath = string.format("%s_%s", filePath, fileTime)
    -- 复制一份
    cc.FileUtils:getInstance():renameFile(filePath, fileTimePath)
    local content = cc.FileUtils:getInstance():getStringFromFile(fileTimePath) or ""
    if cc.FileUtils:getInstance():getFileSize(filePath) > 5*1024*1024 then
        local lineLimit = 100000
        local sendStart = 1
        local sendEnd = libDebug._getLines(content, sendStart, lineLimit)
        while (sendEnd) do
            HttpRequest:getInstance():sendRequest(string.format("%s:8083", ip),{
                ["file"] = fileTimeName,
                ["content"] = string.sub(content, sendStart, sendEnd),
            })
            sendStart = sendEnd + 1
            sendEnd = libDebug._getLines(content, sendStart, lineLimit)
        end
        do
            if sendStart <= string.len(content) then
                HttpRequest:getInstance():sendRequest(string.format("%s:8083", ip),{
                    ["file"] = fileTimeName,
                    ["content"] = string.sub(content, sendStart),
                })
            end
        end
    else
        -- 直接发
        HttpRequest:getInstance():sendRequest(string.format("%s:8083", ip),{
            ["file"] = fileTimeName,
            ["content"] = content,
        })
    end
    libDebug.print("sendLog", ip, fileName)
end
-- 因为lua正则不能匹配重复数量
function libDebug._getLines( content, linesStart, lineCount )
    local linesEnd = nil
    local lineStart, lineEnd = string.find(content, "[^\n]*\n", linesStart)
    while (lineStart and lineEnd and lineCount > 0) do
        linesEnd = lineEnd
        lineCount = lineCount - 1
        lineStart, lineEnd = string.find(content, "[^\n]*\n", linesEnd + 1)
    end
    return linesEnd
end
-- 清理所有日志
function libDebug.cleanLog()
    local logDir = string.format("%slog/", cc.FileUtils:getInstance():getWritablePath())
    if cc.FileUtils:getInstance():isDirectoryExist(logDir) then
        local files = cc.FileUtils:getInstance():listFiles(logDir)
        for i, existPath in pairs(files) do
            local ignore = false
            if existPath == logDir .. "./" then
                ignore = true
            elseif existPath == logDir .. "../" then
                ignore = true
            else
                for owner, logPath in pairs(libDebug._logPath) do
                    if existPath == logPath then
                        ignore = true
                        break
                    end
                end
            end
            if not ignore then
                -- 删除
                cc.FileUtils:getInstance():removeFile(existPath)
                libDebug.print("removeFile", existPath)
            end
        end
    end
end


function libDebug._log( owner, logFile, content )
	libDebug.print("debug:"..owner, content)
    -- 写入文件
    logFile:write(content)
    logFile:write("\n")
end
function libDebug._logTime( owner, logFile )
    libDebug._log(owner, logFile, os.date("------------------------ %m-%d %H:%M:%S ------------------------", os.time()))
end
function libDebug._transData( prefix, key, value, callback )
    local keyStr = ""
    if type(key) == "string" then
        keyStr = "[\"" .. key .. "\"]"
    else
        keyStr = "[" .. key .. "]"
    end
    if type(value) == "table" then
        callback(prefix .. keyStr .. " = {")
        local _keys = {}
        for _key, _value in pairs(value) do
            _keys[#_keys + 1] = _key
        end
        table.sort(_keys)
        for i, _key in ipairs(_keys) do
            libDebug._transData(prefix .. "  ", _key, value[_key], callback)
        end
        callback(prefix .. "}")
    else
        local valueStr = ""
        if type(value) == "number" then
            valueStr = value
        elseif type(value) == "string" then
            valueStr = value
        elseif type(value) == "boolean" then
            valueStr = tostring(value)
        elseif type(value) == "nil" then
            valueStr = "\b"
        elseif type(value) == "function" then
            valueStr = "\b"
        elseif type(value) == "userdata" then
            valueStr = value[".classname"]
        elseif type(value) == "thread" then
            valueStr = "\b"
        end
        callback(prefix .. keyStr .. " = " .. valueStr .. " (" .. type(value) .. ")")
    end
end
function libDebug._transUserData( metatable, keyTable )
    if not metatable then return end

    for key, value in pairs(metatable) do
        if not keyTable[key] then

            local valueStr = ""
            if type(value) == "number" then
                valueStr = value
            elseif type(value) == "string" then
                valueStr = value
            elseif type(value) == "boolean" then
                valueStr = tostring(value)
            elseif type(value) == "nil" then
                valueStr = "\b"
            elseif type(value) == "function" then
                valueStr = "\b"
            elseif type(value) == "userdata" then
                valueStr = value[".classname"]
            elseif type(value) == "thread" then
                valueStr = "\b"
            elseif type(value) == "table" then
                valueStr = "\b"
            end
            keyTable[key] = valueStr .. " (" .. type(value) .. ")"
        end
    end

    libDebug._transUserData(getmetatable(metatable), keyTable)
end


-- debug级别只输出给owner
function libDebug.debug( owner, ... )
    if not libDebug._logPath[owner] then return end

    -- 处理nil的情况
    local params = {}
    local param = nil
    for i = 1, select("#", ...) do
        param = select(i, ...)
        if param == nil then
            params[i] = tostring(param)
        elseif type(param) == "boolean" then
            params[i] = tostring(param)
        else
            params[i] = param
        end
    end
    local content = table.concat(params, " ")
    
    local logFile = io.open(libDebug._logPath[owner], "a+")
    libDebug._logTime(owner, logFile)
    libDebug._log(owner, logFile, content)
    logFile:close()
end
function libDebug.debugData( owner, tag, data )
    if not libDebug._logPath[owner] then return end
    
    local logFile = io.open(libDebug._logPath[owner], "a+")
    libDebug._logTime(owner, logFile)

    libDebug._transData("", tag, data, function ( str )
        libDebug._log(owner, logFile, str)
    end)

    logFile:close()
end
function libDebug._debugStringLines( owner, tag, data )
    if not libDebug._logPath[owner] then return end
    
	if type(data) ~= "string" then
		libDebug.debugData(owner, tag, data)
	else
		local strList = string.split(data, "\n")
        libDebug.debugData(owner, tag, strList)
	end
end
function libDebug.debugTraceback( owner, tag )
    if not libDebug._logPath[owner] then return end
    
    -- json不要使用'，替换成"
    local data = string.gsub(debug.traceback(), "\'", "\"")
    libDebug._debugStringLines(owner, tag, data)
end
-- userdata
function libDebug.debugUserdata( owner, tag, data )
    if not libDebug._logPath[owner] then return end
    
    local logFile = io.open(libDebug._logPath[owner], "a+")
    libDebug._logTime(owner, logFile)

    local keys_map = {}
    libDebug._transUserData(getmetatable(data), keys_map)

    local keys_list = table.keys(keys_map)
    table.sort(keys_list)
    libDebug._log(owner, logFile, string.format("[%s] = {", tag))
    for i, key in ipairs(keys_list) do
        libDebug._log(owner, logFile, string.format("    %s = %s", key, keys_map[key]))
    end
    libDebug._log(owner, logFile, string.format("}"))

    logFile:close()
end
function libDebug.debugCachedTextureInfo( owner )
    if not libDebug._logPath[owner] then return end

	local cacheInfoStr = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
	local cacheInfoList = bole.splitStr(cacheInfoStr, "\n")
    local resRootList = {
        bole.resourceRoot,
        "assets/res/",
    }

    local cacheResList = {}
	for index = 1, #cacheInfoList - 2 do
        local cacheResInfo = cacheInfoList[index]

        local absPath, rc, id, width, height, bpp, size = string.match(cacheResInfo, "\"([^\"]*)\" rc=([%d]*) id=([%d]*) ([%d]*) x ([%d]*) @ ([%d]*) bpp => ([%d]*) KB")

        local resPath = nil
        local resRoot = nil
        for i, resRootPath in ipairs(resRootList) do
            if resPath == nil then
                local rootStart, rootEnd = string.find(absPath, resRootPath)
                if rootStart and rootEnd then
                    resPath = string.sub(absPath, rootEnd + 1, string.len(absPath))
                    resRoot = resRootPath
                end
            end
        end

        if resPath == nil then
            resPath = absPath
            resRoot = ""
        end
        local resDir = ""
        local dirStart, dirEnd = string.find(resPath, "/")
        if dirStart and dirEnd then
            resDir = string.sub(resPath, 1, dirStart - 1)
        end
        cacheResList[#cacheResList + 1] = {
            path = resPath,
            root = resRoot,
            dir = resDir,
            rc = rc,
            id = id,
            width = width,
            height = height,
            bpp = bpp,
            size = tonumber(size),
        }
	end
    local dirMap = {}
    for i, cacheResData in ipairs(cacheResList) do
        local resDir = cacheResData.dir
        dirMap[resDir] = dirMap[resDir] or {size = 0, list = {}}
        dirMap[resDir].dir = resDir
        dirMap[resDir].size = dirMap[resDir].size + cacheResData.size
        dirMap[resDir].list[#dirMap[resDir].list + 1] = {
            path = cacheResData.path,
            size = cacheResData.size,
            bpp = cacheResData.bpp,
        }
    end
    local dirList = {}
    for resDir, dirData in pairs(dirMap) do
        dirList[#dirList + 1] = dirData
    end
    table.sort(dirList, function (a, b)
        return a.size > b.size
    end)

    
    local logFile = io.open(libDebug._logPath[owner], "a+")
    libDebug._logTime(owner, logFile)

    libDebug._log(owner, logFile, cacheInfoList[#cacheInfoList - 1])
    for dirIndex, dirData in ipairs(dirList) do
        libDebug._log(owner, logFile, string.format("  %3.2f M (%d) = %s", dirData.size/1024, dirData.size, dirData.dir))

        table.sort(dirData.list, function (a, b)
            return a.size > b.size
        end)
        for resIndex, resData in ipairs(dirData.list) do
            libDebug._log(owner, logFile, string.format("      % 6d = (% 6s) [%s]", resData.size, resData.bpp, resData.path))
        end
    end

    logFile:close()
end


-- warn级别会向所有owner输出日志
function libDebug.warn( ... )
    for owner, _ in pairs(libDebug._logPath) do
        libDebug.debug(owner, ...)
    end
end
function libDebug.warnTraceback( tag )
    -- json不要使用'，替换成"
    local data = string.gsub(debug.traceback(), "\'", "\"")
    for owner, _ in pairs(libDebug._logPath) do
        libDebug._debugStringLines(owner, tag, data)
    end
end

-- error级别目前只处理lua报错
function libDebug.error( msg )
    -- json不要使用'，替换成"
    msg = string.gsub(msg, "\'", "\"")
    local tag = "error-msg"
    for owner, _ in pairs(libDebug._logPath) do
        libDebug._debugStringLines(owner, tag, msg)
    end
end

if appDebugMode then
    local _showMessageBox = bole.showMessageBox
    bole.showMessageBox = function ( msg )
        libDebug.error(msg)
        _showMessageBox(msg)
    end
else
    libDebug.startLog = function ()
    end
    libDebug.endLog = function ()
    end
    libDebug.sendLog = function ()
    end
    
    libDebug.debug = function ()
    end
    libDebug.debugData = function ()
    end
    libDebug.debugTraceback = function ()
    end
    libDebug.debugUserdata = function ()
    end
    libDebug.debugCachedTextureInfo = function ()
    end
    libDebug.warn = function ()
    end
    libDebug.warnTraceback = function ()
    end
    libDebug.error = function ()
    end
end

--[[
    安全执行，报错加日志
    func 函数
    default_result 报错时默认的返回值
]]
libDebug.safeFuncReported = {}
libDebug.getSafeFunc = function ( error_tag, func, default_results )
    return function ( ... )
        local args = {...}
        xpcall(function ()
            return func(unpack(args))
        end, function ( errorMsg )
            if not libDebug.safeFuncReported[error_tag] then
                -- 避免连续大量报错
                libDebug.safeFuncReported[error_tag] = true
                local data = {
                    msg = "getSafeFunc",
                    hotV = HOTUPDATE_VERSION,
                    errorMsg = errorMsg,
                    errorTag = error_tag,
                }
                if appDebugMode then
                    bole.send_codeInfo(Splunk_Type.Error, data, false)
                    libDebug.printTable("error safeExcute", data)
                else
                    bole.send_codeInfo(Splunk_Type.Error, data, false)
                end
                __G__TRACKBACK__(errorMsg)
            end
            if default_results then
                return unpack(default_results)
            end
        end)
    end
end
