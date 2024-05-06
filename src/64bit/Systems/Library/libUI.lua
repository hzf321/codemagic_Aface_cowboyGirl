libUI = {}

-------------------------- Action相关操作 ------------------------------------
-- 创建Bezier曲线Action
libUI.bezierToAction = function (from, cp, to, duration)
	local config = {from, cp, to}
	return cc.BezierTo:create(duration, config)
end 

-- 创建sequence Action
libUI.sequenceAction = function (action, ...)
	return cc.Sequence:create(action, ...)
end 

-- 创建spawn Action
libUI.spawnAction = function (action, ...)
	return cc.Spawn:create(action, ...)
end 

-- 创建repeat Action
libUI.repeatAction = function (action, time)
	return cc.Repeat:create(action, time)
end 

-- 创建
libUI.repeatForeverAction = function (action)
	return cc.RepeatForever:create(action)
end 

-- 创建delayTime Action
libUI.delayTimeAction = function (delay)
	return cc.DelayTime:create(delay)
end 

-- 创建callFunc Action
libUI.callFuncAction = function (func)
	return cc.CallFunc:create(func)
end 

-- 创建scaleTo Action
libUI.scaleToAction = function (duration, scale_x, scale_y)
	scale_y = scale_y or scale_x
	return cc.ScaleTo:create(duration, scale_x, scale_y)
end 

-- 创建rotateTo Action
libUI.rotateToAction = function (duration, angle)
	return cc.RotateTo:create(duration, angle)
end 

-- 创建rotateBy Action
libUI.rotateByAction = function (duration, angle)
	return cc.RotateBy:create(duration, angle)
end 

-- 创建jumpTo Action
libUI.jumpToAction = function (duration, pos, height, step)
	return cc.JumpTo:create(duration, pos, height, step)
end 

-- 创建moveTo Action
libUI.moveToAction = function (duration, pos)
	return cc.MoveTo:create(duration, pos)
end 

-- 创建moveBy Action
libUI.moveByAction = function (duration, pos)
	return cc.MoveBy:create(duration, pos)
end 

-- 创建fadeTo Action
libUI.fadeToAction = function (duration, alpha)
	return cc.FadeTo:create(duration, alpha)
end 

-- 创建show Action
libUI.showAction = function ()
	return cc.Show:create()
end 

-- 创建hide Action
libUI.hideAction = function ()
	return cc.Hide:create()
end 

-------------------------- 结点相关操作 ----------------------------
-- 创建cocos Node结点
libUI.createNode = function (parent, zOrder, pos,scale)
	local node = cc.Node:create()

    if pos then
        node:setPosition(pos)
    end

	if parent then
		parent:addChild(node, zOrder)
	end

    scale = scale or 1
    node:setScale(scale)
	return node
end

-- 交换父节点
libUI.changeParent = function ( myNode, newParent, zorder)
	if libUI.isValidNode(myNode) and libUI.isValidNode(newParent) then
		myNode:retain()
		myNode:removeFromParent(false)
		newParent:addChild(myNode, zorder or 0)
		myNode:release()
	end
end
-- 交换父节点不改变位置大小
libUI.changeOnlyParent = function ( child, newParent, zorder )
	if not libUI.isValidNode(child) then return end
	if not libUI.isValidNode(newParent) then return end
	if child:getParent() == newParent then return end

	local worldPos = child:convertToWorldSpaceAR(cc.p(0, 0))
	local worldScale = bole.getWorldScale(child)

	libUI.changeParent(child, newParent, zorder)

	local parentPos = newParent:convertToNodeSpace(worldPos)
	child:setPosition(parentPos)
	local parentScale = bole.getWorldScale(newParent)
	child:setScale(worldScale/parentScale)
end

-- 结点是否存在
libUI.isValidNode = function (node)
    return (not tolua.isnull(node))
end

-- 创建容器结点
libUI.createContainer = function (parent, pos, zOrder, size)
	local containerCsb = "header_footer/style1/header/basic/BasicContainer.csb"
	local fileUtils = cc.FileUtils:getInstance()
	if fileUtils:isFileExist(containerCsb) then
		local containerNode = cc.CSLoader:createNode(containerCsb)

		if pos then
			containerNode:setPosition(pos)
		end

		if parent then
			parent:addChild(containerNode, zOrder)
		end

		local container = containerNode:getChildByName("container")
		if size then
			container:setContentSize(size)
		end

		return container
	end

	return nil
end

-------------------------- csb相关操作 -------------------------------
-- 创建cocos Node结点
libUI.createCsbNode = function (parent, csb, zOrder, pos)
	local node
	if csb then
		-- local packs = LanguageController:getInstance():getLanguagePacks(csb)
		-- bole.updatePlist(csb, packs)
		node = cc.CSLoader:createNode(csb)
		if node then
			if pos then
		        node:setPosition(pos)
		    end

		    zOrder = zOrder or 1

			if parent then
				parent:addChild(node, zOrder)
			end
		end
	end
	return node
end

libUI.createCsbNodeNew = function (csb)
	local node
	if csb then
		-- local packs = LanguageController:getInstance():getLanguagePacks(csb)
		-- bole.updatePlist(csb, packs)
		node = cc.CSLoader:createNode(csb)
	end
	return node
end

libUI.__lastCsbPathStart = false
libUI.__lastCsbPath = nil
libUI.createCsb = function ( path )
	if path == nil then return end
	if libUI.__lastCsbPathStart and libUI.__lastCsbPath ~= path then
		-- csb发生变化，需要记录
		libUI.__lastCsbPath = path
		cc.UserDefault:getInstance():setStringForKey("game_last_csb", path)
		local node = cc.CSLoader:createNode(path)
		cc.UserDefault:getInstance():setStringForKey("game_last_create_csb", path)
		return node
	end

	return cc.CSLoader:createNode(path)
end
libUI.reportLastCsb = function ()
	-- 异常 is_exit=0 is_background!=2
	local path = cc.UserDefault:getInstance():getStringForKey("game_last_csb", "default")
	local created = cc.UserDefault:getInstance():getStringForKey("game_last_create_csb", "default")
	if created ~= path then
		-- 创建csb崩溃
		libDebug.reportClientError(REPORT_CLIENT_ERROR.CREATE_CSB_CRASH, {
			path = path,
			created = created,
		})
	end
	local current_require_progress = cc.UserDefault:getInstance():getStringForKey("require_progress", "0")
	if current_require_progress ~= "0" and LAST_REQUIRE_PROGRESS ~= "0" and LAST_REQUIRE_PROGRESS ~= current_require_progress then
		libDebug.reportClientError(REPORT_CLIENT_ERROR.REQUIRE_FAILED, {
			path = current_require_progress,
			created = LAST_REQUIRE_PROGRESS,
		})
	end

	-- 是否切换到后台
	local is_background = libMM.getIntegerForKey("is_background", -1)
	libMM.setIntegerForKey("is_background", 0)
	-- 是否正常退出
	local is_exit = libMM.getIntegerForKey("is_exit", -1)
	libMM.setIntegerForKey("is_exit", 0)
	-- 点击lobbythemeid
	local theme_id = libMM.getIntegerForKey("clickLobbyTheme", 0)
	libMM.setIntegerForKey("clickLobbyTheme", 0)
	-- local click_tag = libMM.getIntegerForKey("LobbyLoadingTheme", 0)
	if is_exit == 0 and (is_background == 0 or is_background == 1) then
		-- 异常退出
		-- libDebug.reportClientError(REPORT_CLIENT_ERROR.EXIT_ERROR, {
		-- 	is_background = is_background,
		-- 	theme_id = theme_id,
		-- 	created = created,
		-- })
		bole.send_codeInfo(Splunk_Type.ACTION, {
			current = "exit_error",
			is_background = is_background,
			theme_id = theme_id,
			created = created,
			hotV = HOTUPDATE_VERSION,
		}, false)
	end
	EventCenter:registerEvent(EVENTNAMES.SYSTEM.ENTER_FOREGROUND, "REPORT_LAST_CSB", function ()
		libMM.setIntegerForKey("is_background", 1)
	end)
	EventCenter:registerEvent(EVENTNAMES.SYSTEM.ENTER_BACKGROUND, "REPORT_LAST_CSB", function ()
		libMM.setIntegerForKey("is_background", 2)
	end)
	-- EventCenter:registerEvent(EVENTNAMES.SYSTEM.EXIT_GAME, "REPORT_LAST_CSB", function ()
	-- 	libMM.setIntegerForKey("is_exit", 1)
	-- end)

	-- timeline崩溃
	local timeline_csb_pause = libMM.getStringForKey("gotoFrameAndPause_last_csb", "")
	libMM.setStringForKey("gotoFrameAndPause_last_csb", "")
	if timeline_csb_pause ~= "" then
		local _type = string.sub(timeline_csb_pause, string.len(timeline_csb_pause)-1)
		if _type == "_1" then
			-- 异常，等于函数执行前
			print("error: timeline error", timeline_csb_pause)
			libDebug.reportClientError(REPORT_CLIENT_ERROR.TIMELINE_PAUSE, {
				timeline_csb_pause = timeline_csb_pause,
			})
		end
	end
	local timeline_csb_play = libMM.getStringForKey("gotoFrameAndPlay_last_csb", "")
	libMM.setStringForKey("gotoFrameAndPlay_last_csb", "")
	if timeline_csb_play ~= "" then
		local _type = string.sub(timeline_csb_play, string.len(timeline_csb_play)-1)
		if _type == "_1" then
			-- 异常，等于函数执行前
			print("error: timeline error", timeline_csb_play)
			libDebug.reportClientError(REPORT_CLIENT_ERROR.TIMELINE_PLAY, {
				timeline_csb_play = timeline_csb_play,
			})
		end
	end
	libUI.__lastCsbPathStart = true
end


--------------------------- 按钮相关操作 -------------------------------
libUI.createButton = function (parent, touchFunc, file1, file2, file3, pos, zOrder, scale)
	local button = Widget.newButton( touchFunc, file1, file2, file3)

	if pos then
		button:setPosition(pos)
	end
	scale = scale or 1
	button:setScale(scale)

	if parent then
		parent:addChild(button, zOrder or 0)
	end

	return button
end

-------------------------- Label相关操作 -----------------------------

-- 创建字体结点
libUI.createFont = function (parent, font, pos, scale, zOrder)
	local fileUtils = cc.FileUtils:getInstance()
    if not fileUtils:isFileExist(font) then
        if appDebugMode then
        	print("miss file ",font)
        	print(a.b)
        else
        	local resKey = string.split(font, "/")
	        if resKey and resKey[1] then
	            local need = DownloadController:getInstance():needDownload(2, resKey[1])
	            local version = DownloadController:getInstance():getResVersion(2, resKey[1])
	            bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", misfile = font, res = resKey[1], need = tostring(need), version = tostring(version)}, false)
	        else
	            bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", misfile = font, err_type = 2}, false)
	        end
        end

        font = "commonfonts/display_lock_fnt01.fnt"
    end

    local fontNode = FONTS.new(font, "")

    if not fontNode then
    	fontNode = FONTS.new("commonfonts/display_lock_fnt01.fnt", "")
    	bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", misfile = font, err_type = 1}, false)
    end

    if pos then
        fontNode:setPosition(pos)
    end

    if scale then
        fontNode:setScale(scale)
    end
	zOrder = zOrder or 0 
    if parent then
        parent:addChild(fontNode, zOrder)
    end

	return fontNode
end

-- 限定label边界
libUI.adjustLabelByWidth = function(label, max_width, max_scale_X, max_scale_Y)
	max_scale_X = max_scale_X or 1
	max_scale_Y = max_scale_Y or max_scale_X
	if label and max_width then
		local font_width      = label:getContentSize().width
		local current_scale_X = label:getScaleX()
		local current_scale_Y = label:getScaleY()  
		local current_width = font_width * current_scale_X
		-- 只有当label超范围了，或scale太小才需要scale
		if current_width > max_width or (current_width < max_width and current_scale_X < max_scale_X) then
			local adjust_scale  = max_width / current_width 
			local scale_x = current_scale_X * adjust_scale
			local scale_y = current_scale_Y * adjust_scale
			if scale_x > max_scale_X then 
				scale_x = max_scale_X 
				scale_y = max_scale_Y
			end
			label:setScale(scale_x, scale_y)
		end
	end
end

-- 创建ttf字体
libUI.createFontTTF = function ( ttf_path, fontSize )
    if not cc.FileUtils:getInstance():isFileExist(ttf_path) then
        if appDebugMode then
        	print("miss file ",ttf_path)
        	print(fnta.b)
        else
        	local resKey = string.split(ttf_path, "/")
	        if resKey and resKey[1] then
	            local need = DownloadController:getInstance():needDownload(DOWNLOAD_TYPE.SYSTEM, resKey[1])
	            local version = DownloadController:getInstance():getResVersion(DOWNLOAD_TYPE.SYSTEM, resKey[1])
				libDebug.reportClientError(REPORT_CLIENT_ERROR.MISS_FILE, {
					msg = "font",
					err_type = 3,
					path = ttf_path,
					res = resKey[1],
					need = tostring(need),
					version = tostring(version),
				})
	        else
				libDebug.reportClientError(REPORT_CLIENT_ERROR.MISS_FILE, {
					msg = "font",
					err_type = 2,
					path = ttf_path,
				})
	        end
        end

        ttf_path = "commonfonts/inbox_main.TTF"
    end
	return cc.Label:createWithTTF("", ttf_path, fontSize or 18)
end

-- 配置字体数字显示
libUI.formatNumber = function (num, maxLen)
	maxLen = maxLen or 9999
	num    = num or 0
	num    = num * 1000

	local suffix      = {"", "K", "M", "B", "T", "Q"}
	local start_index = 0
	local rev_str, num_str, i, j
	repeat
		num         = math.floor(num / 1000)
		start_index = start_index + 1

		rev_str, i = bole.int2String(num):reverse():gsub("(%d%d%d)", "%1,")
		num_str, j = rev_str:reverse():gsub("^,", "")  

	until (string.len(num_str) <= maxLen or num < 1000)

	num_str = num_str or ""
	return num_str .. (suffix[start_index] or "")
end

-- 倒计时初始值
libUI.initializeCountDownLabel = function (label, time, time_config, day_config)
	if not label or not time then return end

	time_config          = time_config or {}
	day_config           = day_config  or {}
	local time_pre_text  = time_config[1] or ""
	local time_post_text = time_config[2] or ""
	local day_pre_text   = day_config[1]  or ""
	local day_post_text1 = day_config[2] or " DAYS"
	local day_post_text2 = day_config[3] or " DAY"

	local left_time = time or 0
	local day_time  = 86400
	if left_time > day_time then
		local days = math.floor(left_time / day_time)
		local day_post_text = (days == 1 and day_post_text2 or day_post_text1)
		label:setString(day_pre_text .. days .. day_post_text)
	else
		local function getTimeString(num)
			return ((num < 10 and "0") or "") .. num
		end

		local hour   = getTimeString(math.floor(left_time / 3600))
		local minute = getTimeString(math.floor(left_time % 3600 / 60))
		local second = getTimeString(math.floor(left_time % 60))
		label:setString(time_pre_text .. hour .. ":" .. minute .. ":" .. second .. time_post_text)
	end
end

-- 配置倒计时
libUI.configCountDownLabel = function (label, time_func, end_func, time_config, allow_day, day_config, hour_config)
	if not label or not time_func then return end

	time_config          = time_config or {}
	day_config           = day_config  or {}
	local time_pre_text  = time_config[1] or ""
	local time_post_text = time_config[2] or ""
	local day_pre_text   = day_config[1]  or ""
	local day_post_text1 = day_config[2] or " DAYS"
	local day_post_text2 = day_config[3] or " DAY"
    local end_func_called= false

	label:runAction(libUI.repeatForeverAction(libUI.sequenceAction(
       libUI.callFuncAction(function ( ... )
            local left_time = time_func()
            local day_time  = 86400
            if left_time >= 0 then
            	if allow_day and left_time > day_time then

            		local days = math.floor(left_time / day_time)
                    local day_post_text = (days == 1 and day_post_text2 or day_post_text1)
					if hour_config then
						-- 增加H显示
						local hour_pre_text	 = hour_config[1]  or ""
						local hour_post_text = hour_config[2]  or ""
						local hours = math.floor((left_time - days * day_time) / 3600)
						label:setString(day_pre_text .. days .. day_post_text .. hour_pre_text .. hours .. hour_post_text)
					else
						label:setString(day_pre_text .. days .. day_post_text)
					end
            	else

            		local function getTimeString(num)
	                    return ((num < 10 and "0") or "") .. num
	                end

	                -- day暂时不需要
	                local hour   = getTimeString(math.floor(left_time / 3600))
	                local minute = getTimeString(math.floor(left_time % 3600 / 60))
	                local second = getTimeString(math.floor(left_time % 60))
	                label:setString(time_pre_text .. hour .. ":" .. minute .. ":" .. second .. time_post_text)
            	end
                
                if left_time <= 0 then
                    if end_func then
                        end_func_called = true
                        end_func()
                    end
                end
            else
                -- label:stopAllActions()
                if not end_func_called and end_func then
                    end_func_called = true
                    end_func()
                end 
            end
            
        end),
        libUI.delayTimeAction(1))))
end

-- 配置倒计时
libUI.configCountDownLabelNew = function (label, time_func)
	if not label or not time_func then return end

	local function getTimeString(num)
		return ((num < 10 and "0") or "") .. num
	end

	label:runAction(libUI.repeatForeverAction(libUI.sequenceAction(
       libUI.callFuncAction(function ( ... )
            local left_time = time_func()
            local day_time  = 86400
            if left_time >= 0 then
            	if left_time > day_time then
            		local days = math.floor(left_time / day_time)
					local hour = math.ceil(left_time % day_time / 3600)
					label:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.VALUE,
						string_key = "COMMON.format_time",
						string_value = {days, hour},
					})
            	else
            		local function getTimeString(num)
	                    return ((num < 10 and "0") or "") .. num
	                end

	                -- day暂时不需要
	                local hour   = getTimeString(math.floor(left_time / 3600))
	                local minute = getTimeString(math.floor(left_time % 3600 / 60))
	                local second = getTimeString(math.floor(left_time % 60))
	                label:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.VALUE,
						string_key = "COMMON.format_time",
						string_value = {0, hour, minute, second},
					})
            	end
            else
                label:setStringConfig({
					string_type = LANGUAGE_STRING_TYPE.VALUE,
					string_key = "COMMON.format_time",
					string_value = {0, "00", "00", "00",},
				})
            end
            
        end),
        libUI.delayTimeAction(1))))
end

-- 配置倒计时
libUI.configCountDownLabelInTime = function (label, time_func, end_func, time_config, allow_day, day_config)
	if not label or not time_func then return end

	time_config          = time_config or {}
	day_config           = day_config  or {}
	local time_pre_text  = time_config[1] or ""
	local time_post_text = time_config[2] or ""
	local day_pre_text   = day_config[1]  or ""
	local day_post_text1 = day_config[2] or " DAYS"
	local day_post_text2 = day_config[3] or " DAY"
    local end_func_called= false

	local _update = function ( ... )
		local left_time = time_func()
		local day_time  = 86400
		if left_time >= 0 then
			if allow_day and left_time > day_time then

				local days = math.floor(left_time / day_time)
				local day_post_text = (days == 1 and day_post_text2 or day_post_text1)
				label:setString(day_pre_text .. days .. day_post_text)
			else

				local function getTimeString(num)
					return ((num < 10 and "0") or "") .. num
				end

				-- day暂时不需要
				local hour   = getTimeString(math.floor(left_time / 3600))
				local minute = getTimeString(math.floor(left_time % 3600 / 60))
				local second = getTimeString(math.floor(left_time % 60))
				label:setString(time_pre_text .. hour .. ":" .. minute .. ":" .. second .. time_post_text)
			end
			
			if left_time <= 0 then
				if end_func then
					end_func_called = true
					end_func()
				end
			end
		else
			-- label:stopAllActions()
			if not end_func_called and end_func then
				end_func_called = true
				end_func()
			end 
		end
	end
	_update()
	label:runAction(
		libUI.repeatForeverAction(
			libUI.sequenceAction(
				libUI.delayTimeAction(1),
				libUI.callFuncAction(_update)
			)
		)
	)
end
-- 多语言倒计时
libUI.configLanguageCountDownLabel = function (label, label_key, time_func, end_func, allow_day, day_config, hour_config)
	if not label or not time_func then return end

	day_config           = day_config  or {}
	local day_post_text1 = " DAYS"
	local day_post_text2 = " DAY"
	local hour_pre_text	 = ""
	local hour_post_text = ""
	
	local languageCtl = LanguageController:getInstance()
	if day_config[1] then
		day_post_text1 = languageCtl:getLanguageString(day_config[1]).language_string
	end
	if day_config[2] then
		day_post_text2 = languageCtl:getLanguageString(day_config[2]).language_string
	end
	if hour_config and hour_config[2] then
		hour_post_text = languageCtl:getLanguageString(hour_config[2]).language_string
	end

    local end_func_called = false

	local _update = function ( ... )
		local left_time = time_func()
		local day_time  = 86400
		if left_time >= 0 then
			if allow_day and left_time > day_time then

				local days = math.floor(left_time / day_time)
				local day_post_text = (days == 1 and day_post_text2 or day_post_text1)
				local hours = math.floor((left_time - days * day_time) / 3600)
				--没有配置小时，就不显示
				if hour_post_text == "" then hours = "" end
				local times = days .. day_post_text .. hour_pre_text .. hours .. hour_post_text
				label:setStringConfig({
					string_type = LANGUAGE_STRING_TYPE.VALUE,
					string_key = label_key,
					string_value = {times},
				})

			else

				local function getTimeString(num)
					return ((num < 10 and "0") or "") .. num
				end

				-- day暂时不需要
				local hour   = getTimeString(math.floor(left_time / 3600))
				local minute = getTimeString(math.floor(left_time % 3600 / 60))
				local second = getTimeString(math.floor(left_time % 60))
				local times = hour .. ":" .. minute .. ":" .. second
				label:setStringConfig({
					string_type = LANGUAGE_STRING_TYPE.VALUE,
					string_key = label_key,
					string_value = {times},
				})
			end
			
			if left_time <= 0 then
				if end_func then
					end_func_called = true
					end_func()
				end
			end
		else
			if not end_func_called and end_func then
				end_func_called = true
				end_func()
			end 
		end
	end
	_update()
	label:runAction(
		cc.RepeatForever:create(
			cc.Sequence:create(
				cc.DelayTime:create(1),
				cc.CallFunc:create(_update)
			)
		)
	)
end
-- 多语言倒计时 前后缀也是多语言的 可以format的 类似23:23:23left 4daysleft 1dayleft
libUI.configLanguageCountDownFormat = function (label, time_func, end_func, allow_day, time_format, day_format, tick_func)
	if not label or not time_func then return end

	time_format = time_format or {}
	day_format = day_format or {}
	local time_format_key = time_format[1] or "ROCKET.x_time_left"
	local day_format_singular = day_format[1] or "ROCKET.x_day_left"
	local day_format_complex = day_format[2] or "ROCKET.x_days_left"
	local end_func_called = false

	label:runAction(cc.RepeatForever:create(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			local left_time = time_func()
			local day_time  = 86400
			if left_time >= 0 then
				if allow_day and left_time > day_time then

					local days = math.floor(left_time / day_time)
					local day_format_key = (days == 1 and day_format_singular or day_format_complex)
					label:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.VALUE,
						string_key = day_format_key,
						string_value = {days},
					})
				else

					local function getTimeString(num)
						return ((num < 10 and "0") or "") .. num
					end

					local hour   = getTimeString(math.floor(left_time / 3600))
					local minute = getTimeString(math.floor(left_time % 3600 / 60))
					local second = getTimeString(math.floor(left_time % 60))

					label:setStringConfig({
						string_type = LANGUAGE_STRING_TYPE.VALUE,
						string_key = time_format_key,
						string_value = {hour, minute, second},
					})
				end

				bole.safeCall(tick_func, left_time)
				
				if left_time <= 0 then
					if end_func then
						end_func_called = true
						end_func()
					end
				end
			else
				if not end_func_called and end_func then
					end_func_called = true
					end_func()
				end 
			end
		end),
		cc.DelayTime:create(1)
	)))
end

-------------------------- Sprite相关操作 ----------------------------
-- 创建精灵结点
libUI.createSprite = function (parent, filename, pos, zOrder, flipX, scale, ro)
	local fileUtils = cc.FileUtils:getInstance()
	if fileUtils:isFileExist(filename) then
		local sprite = nil
	    if string.byte(filename) == 35 then -- first char is #
	        sprite = cc.Sprite:createWithSpriteFrameName(string.sub(filename, 2))
	    else
	    	sprite = cc.Sprite:create(filename)
	    end

		if pos then
			sprite:setPosition(pos)
		end

		if flipX ~= nil then
			sprite:setFlippedX(flipX)
		end

		if ro ~= nil then
			sprite:setRotation(ro)
		end

		scale = scale or 1
		sprite:setScale(scale)

		zOrder = zOrder or 1

		if parent then
			parent:addChild(sprite, zOrder)
		end

		return sprite
	end

	return nil
end

-- 创建粒子结点
libUI.createParticle = function (parent, file, pos, zOrder, scale)
	local fileUtils = cc.FileUtils:getInstance()
	if fileUtils:isFileExist(file) then
		local particle = cc.ParticleSystemQuad:create(file)

		if pos then
			particle:setPosition(pos)
		end

		scale = scale or 1
		particle:setScale(scale)

		if parent then
			parent:addChild(particle, zOrder)
		end

		particle:stopSystem()

		return particle
	end

	return nil
end

-- 选中的节点依顺序弹出
libUI.popupSuccessively = function (nodeList, spineNum, delay, time_config)  -- 参数意义：弹出元素列表，特效在元素列表中的位置，弹出动画前的延迟，{每个弹出元素间隔时间，动画总时间}
	if #nodeList == 0 then return 0 end

	local time_config = time_config or {}
	local spineNum = spineNum or {}
	local delay = delay or 0

	local gap_time = time_config[1] or 18/60
	local total_time = time_config[2] or 0
	if total_time ~= 0 then 
		gap_time = total_time/(#nodeList - #spineNum)
	else 
		total_time = gap_time*(#nodeList - #spineNum)
	end
	local spineOffset = 0	-- 用于抵消当前节点前出现的spine导致的gap_time错位
	for i=1, #nodeList do
		if nodeList[i] then
			local isSpine = false
			for j=1, #spineNum do
				if i== spineNum[j] then
					isSpine = true
				end
			end

			local origin_scale = nodeList[i]:getScaleX()
			nodeList[i]:stopAllActions()
			nodeList[i]:setScale(0.001)
			nodeList[i]:runAction(libUI.sequenceAction(
				-- libUI.scaleToAction(0, 0.001),
				cc.DelayTime:create(delay),
				cc.DelayTime:create(gap_time*(isSpine and i-2-spineOffset or i-1-spineOffset)),
				libUI.scaleToAction(15/60, 1.2*origin_scale),
				libUI.scaleToAction(10/60, 0.95*origin_scale),
				libUI.scaleToAction(10/60, 1*origin_scale)
				-- libUI.scaleToAction(10/60, origin_scale)
			))
			nodeList[i]:runAction(libUI.sequenceAction(
				cc.DelayTime:create(delay),
				cc.DelayTime:create(gap_time*(isSpine and i-2-spineOffset or i-1-spineOffset)),
				cc.FadeTo:create(0.001,0),
				cc.FadeTo:create(5/60,255)
			))
			if isSpine then
				spineOffset = spineOffset + 1
			end
		end
	end

	return total_time
end

-- Label通配符插入倒计时
libUI.configDownLabelInTimeByDefaultStr = function (label, time_func, end_func, time_config, allow_day,day_config, hour_config, default_str)
	if not label or not time_func then return end

	time_config          = time_config or {}
	day_config           = day_config  or {}
	local time_pre_text  = time_config[1] or ""
	local time_post_text = time_config[2] or ""
	local day_pre_text   = day_config[1]  or ""
	local day_post_text  = day_config[2]  or "d "
	local hour_pre_text	 = hour_config[1]  or ""
	local hour_post_text = hour_config[2]  or "h "
	local default_str	 = default_str or "%s"

    local end_func_called= false

	local _update = function ( ... )
		local left_time = time_func()
		local day_time  = 86400
		if left_time >= 0 then
			if allow_day and left_time > day_time then

				local days = math.floor(left_time / day_time)
				local hours = math.floor((left_time - days * day_time) / 3600)
				label:setString(string.format(default_str,day_pre_text .. days .. day_post_text .. hour_pre_text .. hours .. hour_post_text))
			else

				local function getTimeString(num)
					return ((num < 10 and "0") or "") .. num
				end

				-- day暂时不需要
				local hour   = getTimeString(math.floor(left_time / 3600))
				local minute = getTimeString(math.floor(left_time % 3600 / 60))
				local second = getTimeString(math.floor(left_time % 60))
				label:setString(string.format(default_str,time_pre_text .. hour .. ":" .. minute .. ":" .. second .. time_post_text))
			end
			
			if left_time <= 0 then
				if end_func then
					end_func_called = true
					end_func()
				end
			end
		else
			if not end_func_called and end_func then
				end_func_called = true
				end_func()
			end 
		end
	end
	_update()
	label:runAction(
		libUI.repeatForeverAction(
			libUI.sequenceAction(
				libUI.delayTimeAction(1),
				libUI.callFuncAction(_update)
			)
		)
	)
end

--------------------------- Spine相关操作 ----------------------------------
libUI.addSpineAnimation = function(parent, zOrder, file, pos, animateName, completeCallback, callbackDelay, returnDelay, isRetain, isLoop, timeScale)
	local delay = returnDelay or 0
	callbackDelay = callbackDelay or 0
	zOrder = zOrder or 0

	file = string.gsub(file, "new_map_", "map_")
	
	if cc.FileUtils:getInstance():isFileExist(file..".atlas") then
		local skeleton = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
		skeleton:setPosition(pos)
		skeleton:setOpacity(0)
		skeleton:setAnimation(0, animateName, isLoop) 
		skeleton:setTimeScale(timeScale or 1)
		parent:addChild(skeleton, zOrder)
		skeleton:runAction(cc.CallFunc:create(function()
			skeleton:setOpacity(255)
		end))
		skeleton:registerSpineEventHandler(function (event)
				if not isRetain then
					-- 延迟释放，否则会报错
					if not tolua.isnull(parent) then
						parent:runAction(cc.Sequence:create(
							cc.DelayTime:create(0),
							cc.CallFunc:create(function ( ... )
								if not tolua.isnull(skeleton) then
									skeleton:removeFromParent()
								end
							end)
						))
					end
					
				end
				if completeCallback then
					if callbackDelay == 0 then
						completeCallback(skeleton)
					else
						skeleton:runAction(cc.Sequence:create(
						cc.DelayTime:create(callbackDelay),
						cc.CallFunc:create(function()
							completeCallback(skeleton)
						end)))
					end
				end
	        end, sp.EventType.ANIMATION_COMPLETE)
		return delay, skeleton
	else
		if appDebugMode then
			print("miss file ",file)
			print(debug.traceback())
			print(a.b)
		end
		bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", msg = file}, false)
		return 0,nil
	end

end

libUI.createSpine = function(jsonFile,atlasFile,scale)
	scale = scale or 1
	if cc.FileUtils:getInstance():isFileExist(jsonFile) then
		return sp.SkeletonAnimation:create(jsonFile, atlasFile, scale)
	else
		bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", msg = jsonFile}, false)
		return sp.SkeletonAnimation:create("commonEffect/header_wheel_multiplier/spine.json", "commonEffect/header_wheel_multiplier/spine.atlas", 1)
	end
end

libUI.playSpineAnimation = function (skeleton, animation_name, loop)

	if skeleton then
		skeleton:setAnimation(0, animation_name, loop) 
	end
end

--------------------------- 进度条相关操作 ----------------------------------

-- 创建progresstimer
libUI.createProgressTimer = function ( imgPath )
	if imgPath and cc.FileUtils:getInstance():isFileExist(imgPath) then
		local progress_bar_sp = cc.Sprite:create(imgPath)
		if progress_bar_sp then
			local progress_bar = cc.ProgressTimer:create(progress_bar_sp)
			if progress_bar then
				return progress_bar, progress_bar_sp
			else
				bole.send_codeInfo(Splunk_Type.Error, {
					msg = "progress_timer_error",
					error = "progress_timer_error",
					error = 3,
					path = imgPath,
				}, false)
			end
		else
			bole.send_codeInfo(Splunk_Type.Error, {
				msg = "progress_timer_error",
				error = "progress_timer_error",
				error = 2,
				path = imgPath,
			}, false)
		end
	else
		bole.send_codeInfo(Splunk_Type.Error, {
			msg = "progress_timer_error",
			error = "progress_timer_error",
			error = 1,
			path = imgPath,
		}, false)
	end
end
--创建圆形进度条
libUI.createCircleLoadingBar = function (background, loading, forground, parent, pos)
	local spriteBg
	local spriteFg

	--创建一个图片精灵作为背景 需要一个空心圆形的图片
	if background then
		spriteBg = cc.Sprite:create(background)
		if spriteBg then
			spriteBg:setPosition(pos)
		end
	end

	--创建一个图片精灵作为前景 需要一个圆形的图片
	if forground then
		spriteFg = cc.Sprite:create(forground)
		if spriteFg then
			spriteFg:setPosition(pos)
		end
	end

	--创建进度条
	--创建一个进度条图片精灵 需要一个空心圆形的图片
	local circleProgressBar, sprite = libUI.createProgressTimer(loading)
	--设置类型
	if circleProgressBar then
		circleProgressBar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
		circleProgressBar:setPosition(pos)
	end

	--指定父节点
	if spriteBg then
		parent:addChild(spriteBg, 1)
		spriteBg:setName("circle_sprite_bg")
	end
	if spriteFg then
		parent:addChild(spriteFg, 3)
	end
	if circleProgressBar then
		parent:addChild(circleProgressBar, 2)

		--设置进度
		circleProgressBar:setPercentage(0)
	end

	return circleProgressBar
end

--创建条形进度条
libUI.createRectangleLoadingBar = function(background, loading, forground, parent, pos, scale)
	local spriteBg
	local spriteFg

	--创建一个图片精灵作为背景 需要一个空心条形的图片
	local scale = scale or 1
	if background then
		spriteBg = cc.Sprite:create(background)
		if spriteBg then
			spriteBg:setPosition(pos)
			spriteBg:setScale(scale)
		end
	end

	--创建一个图片精灵作为前景 需要一个条形的图片
	if forground then
		spriteFg = cc.Sprite:create(forground)
		if spriteFg then
			spriteFg:setPosition(pos)
			spriteFg:setScale(scale)
		end
	end

	--创建进度条
	--创建一个进度条图片精灵 需要一个空心条形的图片
	local circleProgressBar, sprite = libUI.createProgressTimer(loading)
	--设置类型
	if circleProgressBar then
		circleProgressBar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
		circleProgressBar:setMidpoint(cc.p(0,0)) --设置起点为条形坐下方
		circleProgressBar:setBarChangeRate(cc.p(1,0))  --设置为竖直方向
		circleProgressBar:setPosition(cc.p(spriteBg:getContentSize().width/2,spriteBg:getContentSize().height/2))
		circleProgressBar:setPosition(pos)
		circleProgressBar:setScale(scale)
	end

	--指定父节点
	if spriteBg then
		parent:addChild(spriteBg, 1)
	end
	if spriteFg then
		parent:addChild(spriteFg, 3)
	end
	if circleProgressBar then
		parent:addChild(circleProgressBar, 2)

		--设置进度
		circleProgressBar:setPercentage(0)
	end

	return circleProgressBar, sprite
end

--------------------------- TableView相关操作 ------------------------------
-- 创建tableview结点
libUI.createTableView = function (parent, size, pos, direction, scroll_func, zoom_func, size_func, spawn_func, nums_func)
	local table_view
	if parent then
        scroll_func = scroll_func or function (view) end
        zoom_func   = zoom_func or function (view) end
		size_func   = size_func or function (table,idx) return 0, 0 end
		spawn_func  = spawn_func or function (table, idx) return nil end
        nums_func   = nums_func or function (table) return 0 end

        table_view = cc.TableView:create(size)
        if table_view then
	        table_view:setDirection(direction)
	        table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	        table_view:setPosition(pos)
	        table_view:setDelegate()
	        parent:addChild(table_view, 2)

	        table_view:registerScriptHandler(nums_func,   cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
	        table_view:registerScriptHandler(scroll_func, cc.SCROLLVIEW_SCRIPT_SCROLL)
	        table_view:registerScriptHandler(zoom_func,   cc.SCROLLVIEW_SCRIPT_ZOOM)
	        table_view:registerScriptHandler(size_func,   cc.TABLECELL_SIZE_FOR_INDEX)
	        table_view:registerScriptHandler(spawn_func,  cc.TABLECELL_SIZE_AT_INDEX)
	        table_view:reloadData()
	    end
    end
    return table_view
end

-- 创建ScrollView结点
libUI.createScrollView = function (parent, size, container, pos, direction, scroll_func, zoom_func)
	local scroll_view
	if parent then
        scroll_func = scroll_func or function (view) end
        zoom_func   = zoom_func or function (view) end
        scroll_view = cc.ScrollView:create(size)
        if scroll_view then
	        scroll_view:setDirection(direction)
	        scroll_view:setPosition(pos)
	        scroll_view:setDelegate()
	        if container then
				scroll_view:setContainer(container)
        		scroll_view:setContentOffset(scroll_view:minContainerOffset())
	        end
	        parent:addChild(scroll_view, 2)

	        scroll_view:registerScriptHandler(scroll_func,   cc.SCROLLVIEW_SCRIPT_SCROLL) 
	        scroll_view:registerScriptHandler(zoom_func,   cc.SCROLLVIEW_SCRIPT_ZOOM)
	    end
    end
    return scroll_view
end

libUI.runAction = function(parent, action)
	if bole.isValidNode(parent) and action then
		parent:runAction(action)
	else
		print(runAction.runAction)
	end
end				

-- 删除无用的光标
libUI.initTextField = function( node )
	if not libUI.isValidNode(node) then return end

	local function onNodeEvent(event)
		if event == "enterTransitionFinish" then
			if libUI.isValidNode(node) then
				for i, child in ipairs(node:getChildren()) do
					child:removeFromParent()
				end
			end
        end
    end
    node:registerScriptHandler(onNodeEvent)
end

-- 显示节点显示区域
libUI.showNodeView = function ( node, r, g, b, a )
	if not libUI.isValidNode(node) then return end

	local w = node:getContentSize().width
	local h = node:getContentSize().height
	r = r or 255
	g = g or 0
	b = b or 0
	a = a or 100
	local _l = node:getChildByName("_showNodeView")
	if not _l then
		_l = cc.LayerColor:create(cc.c4b(r, g, b, a))
		_l:setPosition(cc.p(0, 0))
		node:addChild(_l, 10000000)
		_l:setName("_showNodeView")
	end
	_l:setContentSize(cc.size(w, h))
end

-- 节点做运动曲线
libUI.spineCurvePos = function (node, fromPos, aimPos, interval, curveFunc, delay)
	if not libUI.isValidNode(node) then return end
	if type(fromPos) == "number" or type(aimPos) == "number" then return end
	-- 默认曲线函数
	curveFunc = curveFunc or function ( x )
		if not x or type(x) ~= "number" then return end
		x = x / 100 -- 这个值是interval，但是默认100，不写成变量了
		if x >= 0.5 then 
			return 1 - 2 * (x - 1) * (x - 1)
		else
			return 2 * x * x
		end
	end

	if not curveFunc or type(curveFunc) ~= "function" then return end

	fromPos  = fromPos  or cc.p(0, 0)
	aimPos   = aimPos   or cc.p(0, 0)
	interval = interval or 100
	delay    = delay    or 1

	if not fromPos.x or not fromPos.y or not aimPos.x or not aimPos.y then return end

	local deltaX   = aimPos.x - fromPos.x
	local deltaY   = aimPos.y - fromPos.y

	local posList = {}
	for i = 1, interval do
		local ratio = curveFunc(i)
		if ratio and deltaX and deltaY then
			posList[i] = cc.p(deltaX * ratio, deltaY * ratio) -- 曲线函数返回的是比例和json中记录的一样
		end
	end

	node:setPosition(fromPos)
	node:runAction(cc.CardinalSplineBy:create(delay, posList, 0)) -- by 只需要记录增量 to的不好用，不知道为什么

	return delay
end

libUI.playShowAction = function (action_list, delay, delay_time, parent)
	local action_list = action_list or {}
	if #action_list == 0 then return end

	local delay = delay or 0.5
	local delay_time = delay_time or 1
	local parentDialog = parent or nil

	local start_num = 1
	if parentDialog then
		start_num = 2
		if libUI.isValidNode(action_list[1]) and parentDialog and parentDialog.playBgSpine then
			action_list[1]:stopAllActions()
			action_list[1]:runAction(libUI.sequenceAction(
				libUI.delayTimeAction(delay),
				libUI.callFuncAction(function ()
					if parentDialog.playBgSpine then
						parentDialog:playBgSpine(false)
					end
				end)
			))
		end
	end
	for i = start_num, #action_list do
		if libUI.isValidNode(action_list[i]) then
			local origin_scale = action_list[i]:getScaleX()
			action_list[i]:stopAllActions()
			action_list[i]:runAction(libUI.sequenceAction(
				libUI.fadeToAction(0.001,0),
				libUI.scaleToAction(0.001,0.01*origin_scale),
				libUI.delayTimeAction(delay_time + delay),
				libUI.scaleToAction(0.001,origin_scale),
				libUI.fadeToAction(0.001,51),
				libUI.fadeToAction(0.33,255)
			))
		end
	end
end

libUI.playHideAction = function (action_list, delay, delay_time, parent, callback)
	local action_list = action_list or {}
	if #action_list == 0 then return end

	local delay = delay or 0.5
	local delay_time = delay_time or 1
	local parentDialog = parent or nil
	local start_num = 1
	if parentDialog then
		start_num = 2
		if libUI.isValidNode(action_list[1]) and parentDialog and parentDialog.playBgSpine then
			action_list[1]:stopAllActions()
			action_list[1]:runAction(libUI.sequenceAction(
				libUI.delayTimeAction(delay + delay_time),
				libUI.callFuncAction(function ()
					if parentDialog.playBgSpine then
						parentDialog:playBgSpine(true)
					end
				end)
			))
		end
	end
	for i = start_num, #action_list do
		if libUI.isValidNode(action_list[i]) then
			action_list[i]:stopAllActions()
			action_list[i]:runAction(libUI.sequenceAction(
				libUI.fadeToAction(0.001,255),
				libUI.delayTimeAction(delay),
				libUI.fadeToAction(0.001,51),
				libUI.fadeToAction(0.33,0)
			))
		end
	end

	if parentDialog then
		parentDialog:runAction(cc.Sequence:create(
			libUI.delayTimeAction(delay + delay_time + 0.333),
			libUI.callFuncAction(function ()
				if callback then
					callback()
				end
				parentDialog:removeFromParent()
			end)
		))
	end
end

-- 更新主题icon，static表示显示coming，不要特效
libUI.updateThemeIcon = function ( node, themeId, static, tag )
	if not libUI.isValidNode(node) then return end

	-- 需要显示资源，资源下载的时序不确定，需要根据这个值判断要显示哪个主题
	node.showingThemeId = themeId
	node.showingStatic = static
	
	local resourceId = THEME_LIST[tonumber(themeId)]['resourceId']
	-- 检查资源
	if DownloadController:getInstance():needDownload(1, tostring(resourceId)) then
		-- 已显示的主题，资源未下载，此时不应该显示
		node.showedThemeId = nil
		node.showedStatic = nil
		if libUI.isValidNode(node.logoSp) then
			node.logoSp:setVisible(false)
		end
		if libUI.isValidNode(node.logoSpine) then
			node.logoSpine:removeAllChildren()
		end
		DownloadController:getInstance():downloadRes({
			resType = 1,
			resKey = tostring(resourceId),
			onSuccess = function ()
				if node.showingThemeId == themeId and node.showingStatic == static then
					-- 仍然显示对应主题
					libUI.updateThemeIcon(node, themeId, static, tag)
				end
			end,
			cbKey = tag,
		})
		return
	end

	static = static or false
	if node.showedThemeId == themeId and node.showedStatic == static then return end
	-- 实际显示的主题
	node.showedThemeId = themeId
	node.showedStatic = static

	if not libUI.isValidNode(node.logoSp) then
		node.logoSp = cc.Sprite:create()
		node:addChild(node.logoSp)
	end
	if libUI.isValidNode(node.logoSp) then
		local logoPic = static and string.format("theme_loading/theme%d/logo/coming.png", resourceId) or string.format("theme_loading/theme%d/logo/logo.png", resourceId)
		if logoPic and cc.FileUtils:getInstance():isFileExist(logoPic) then
			bole.updateSpriteWithFile(node.logoSp, logoPic)
			node.logoSp:setVisible(true)
		else
			node.logoSp:setVisible(false)
		end
	end

	if not static and not libUI.isValidNode(node.logoSpine) then
		node.logoSpine = cc.Node:create()
		node:addChild(node.logoSpine)
	end
	if libUI.isValidNode(node.logoSpine) then
		node.logoSpine:removeAllChildren()
		if not static then
			local theme_config   = LobbyThemeControl:getInstance():getLobbyThemeConfigList(themeId) or {}
			local animation_list = theme_config.animation_list or {}
			if #animation_list > 0 then
				local logoSpine = string.format("theme_loading/theme%d/logo/spine/logo/spine", resourceId)
				if logoSpine and cc.FileUtils:getInstance():isFileExist(logoSpine..".json") then
					for _, animationName in pairs(animation_list) do
						local _, s = bole.addSpineAnimation(node.logoSpine, nil, logoSpine, cc.p(0, 0), animationName, nil, nil, nil, true, true, 1)
						s:setOpacity(255)
					end
				end
			end
		end
	end
end

libUI.fullFillSpine = function (stencil, parent, clipPic, spinePath, animationName)	-- stencil有缩放时请勿使用
	if not stencil or not parent or not clipPic then return end

	local scale			= stencil:getScale() or 1
	local current  		= current or 0
	local target   		= target or 100
	local animateName 	= animateName or "animation"
	local ratio 		= current/target
	local spine_panel = ccui.Layout:create()
	spine_panel:setContentSize(stencil:getContentSize().width*scale, stencil:getContentSize().height*scale)
	spine_panel:setPosition(stencil:getPositionX()-stencil:getContentSize().width*scale/2, stencil:getPositionY())
	spine_panel:setClippingEnabled(true)
	spine_panel:setAnchorPoint(0, 0.5)
	parent:addChild(spine_panel)

	clipPic:setScale(scale)
	local clipNode = cc.ClippingNode:create(clipPic) -- 创建一个clipNode,用clipPic来初始化`
	-- local clipPicSize = clipPic:getContentSize()
	spine_panel:addChild(clipNode)
	
	clipNode:setCascadeOpacityEnabled(true) -- 子节点透明度随父节点变化
	clipNode:setAlphaThreshold(0.95)
	-- clipNode:setContentSize(clipPicSize)
	clipNode:setPosition(cc.p(stencil:getContentSize().width*scale/2, stencil:getContentSize().height/2))

	local spine_bar = cc.Node:create()
	spine_bar:setPosition(cc.p(0,0))
	clipNode:addChild(spine_bar)
	libUI.addSpineAnimation(spine_bar, nil, spinePath, cc.p(0, 0), animateName, nil, nil, nil, true, true, nil)

	return spine_panel
end
-- 一开始会有0.9秒的延迟 无法避免
libUI.flipCardsAction = function (back_sp, front_sp, startDelay, callback)
	if not libUI.isValidNode(back_sp) or not libUI.isValidNode(front_sp) then
		if callback then
			callback()
		end
		return 
	end

	startDelay = startDelay or 0

	back_sp:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(0.6 + startDelay),
			cc.Spawn:create(
				cc.Sequence:create(
					cc.Show:create(),
					cc.DelayTime:create(0.2),
					cc.Hide:create()
				),
				cc.OrbitCamera:create(0.2, 1, 0, 0, -90, 0, 0)
			)
		)
	)

	front_sp:runAction(
		cc.Sequence:create(
			cc.Hide:create(),
			cc.DelayTime:create(0.2 + startDelay),
			cc.Spawn:create(
				cc.Sequence:create(
					cc.DelayTime:create(0.6),
					cc.Show:create()
				),
				cc.OrbitCamera:create(0.8, 1, 0, 0, -360, 0, 0)
			),
			cc.CallFunc:create(function ( ... )
				if callback then
					callback()
				end
			end)
		)
	)
end

-- 通用动作
local frameRate = 60
-- 摇晃
libUI.shakeActionTag = 123
libUI.runShakeAction = function ( node, config )
	if not libUI.isValidNode(node) then return end
	libUI.stopShakeAction(node)

	config = config or {}
	
	local action = cc.Sequence:create(
		cc.DelayTime:create(config.startDelay or 0),
		cc.RotateTo:create(5/frameRate, 3),
		cc.RotateTo:create(10/frameRate, -3),
		cc.RotateTo:create(10/frameRate, 3),
		cc.RotateTo:create(10/frameRate, -2),
		cc.RotateTo:create(10/frameRate, 1),
		cc.RotateTo:create(10/frameRate, 0)
	)
	action:setTag(libUI.shakeActionTag)
	node:runAction(action)
end
libUI.stopShakeAction = function ( node )
	node:stopActionByTag(libUI.shakeActionTag)
	node:setRotation(0)
end
-- 呼吸
libUI.breathActionTag = 124
libUI.runBreathAction = function ( node, config )
	if not libUI.isValidNode(node) then return end
	
	libUI.stopBreathAction(node)

	config = config or {}
	
	local action = 
	cc.RepeatForever:create(
		cc.Sequence:create(
			cc.ScaleTo:create(10/frameRate, 1.06),
			cc.ScaleTo:create(10/frameRate, 0.95),
			cc.ScaleTo:create(10/frameRate, 1.03),
			cc.ScaleTo:create(10/frameRate, 0.98),
			cc.ScaleTo:create(10/frameRate, 1),
			cc.DelayTime:create(3)
		)
	)
	action:setTag(libUI.breathActionTag)
	node:runAction(action)
end
libUI.stopBreathAction = function ( node )
	if not libUI.isValidNode(node) then return end

	node:stopActionByTag(libUI.breathActionTag)
	node:setScale(1)
end
-- 砸下
libUI.hitDownAction = function (node, delay)
	if not libUI.isValidNode(node) then return end
	
	local origin_scale = node:getScaleX()
	local delay = delay or 0
	node:stopAllActions()
	node:setVisible(false)
	node:setOpacity(0)
	node:runAction(libUI.sequenceAction(
		libUI.scaleToAction(0.001, 2.5),
		libUI.delayTimeAction(delay),
		libUI.callFuncAction(function()
			node:setVisible(true)
		end),
		libUI.spawnAction(
			libUI.fadeToAction(15/frameRate,255),
			libUI.scaleToAction(15/frameRate, 0.95*origin_scale)
		),
		libUI.scaleToAction(10/frameRate, 1.05*origin_scale),
		libUI.scaleToAction(10/frameRate, 0.97*origin_scale),
		libUI.scaleToAction(10/frameRate, 1.02*origin_scale),
		libUI.scaleToAction(10/frameRate, 1*origin_scale)
	))
end

-- 进度条头部不规则
libUI.createProgressBar = function ( imgPath, alpha )
	local node = cc.Node:create()

	local clipStencil = cc.Sprite:create()
	local progressBar = cc.Sprite:create()
	if cc.FileUtils:getInstance():isFileExist(imgPath) then
		clipStencil:setTexture(imgPath)
		progressBar:setTexture(imgPath)
	elseif cc.SpriteFrameCache:getInstance():getSpriteFrame(imgPath) then
		clipStencil:setSpriteFrame(imgPath)
		progressBar:setSpriteFrame(imgPath)
	end
	local clipNode = cc.ClippingNode:create(clipStencil)
	clipNode:setAlphaThreshold(alpha or 0.7)
	clipNode:addChild(progressBar)
	node:addChild(clipNode)
	node.__progress_bar = progressBar
	node.__progress_width = progressBar:getContentSize().width

	node.setPercentage = function ( obj, percent )
		if not libUI.isValidNode(obj.__progress_bar) then return end

        percent = percent < 0 and 0 or percent
        percent = percent > 100 and 100 or percent
		local width = obj.__progress_width or 0
		obj.__progress_bar:setPositionX((percent/100.0 - 1)*width)
		obj.__percent = percent
	end
	node:setPercentage(0)

	node.__progress_to_tag = 2105271612
	node.progressTo = function ( obj, time, percent )
		if not libUI.isValidNode(obj) then return end
		if not time or not percent then return end

		local tag = node.__progress_to_tag or 0
		obj:stopActionByTag(tag)

		if time == 0 then
			obj:setPercentage(percent)
		else
			local frameRate = 30.0
			local diff = (percent - obj.__percent)/(time*frameRate)
			local isUp = percent > obj.__percent
			local action = cc.RepeatForever:create(
				cc.Sequence:create(
					cc.DelayTime:create(1/frameRate),
					cc.CallFunc:create(function ()
						local tmpPercent = obj.__percent + diff
						local over = false
						if tmpPercent == percent then
							-- 结束
							over = true
						elseif isUp and tmpPercent > percent then
							over = true
						elseif not isUp and tmpPercent < percent then
							over = true
						end

						if over then
							obj:stopActionByTag(tag)
							obj:setPercentage(percent)
						else
							obj:setPercentage(tmpPercent)
						end
					end)
				)
			)
			action:setTag(tag)
			obj:runAction(action)
		end
	end

	return node
end


-- 红点数字
libUI.updateCommonRedCount = function ( node, count )
	if not libUI.isValidNode(node) then return end
	if count > 0 then
		if not libUI.isValidNode(node.redBg) then
			node.redBg = libUI.createSprite(node, "header_footer/style1/footer/images/yeqian_01.png", cc.p(0, 0), 0)
		end
		if libUI.isValidNode(node.redBg) then
			node.redBg:setVisible(true)
		end

		if not libUI.isValidNode(node.redLabel) then
			node.redLabel = libUI.createFont(node, "header_footer/style1/footer/images/lobby_count.fnt", cc.p(1, -1), 1, 1)
		end
		if libUI.isValidNode(node.redLabel) then
			if count >= 100 then
				node.redLabel:setString("...")
			else
				node.redLabel:setString(tostring(count))
			end
			node.redLabel:setVisible(true)
		end
	else
		if libUI.isValidNode(node.redBg) then
			node.redBg:setVisible(false)
		end
		if libUI.isValidNode(node.redLabel) then
			node.redLabel:setVisible(false)
		end
	end
end
-- 红点感叹号
libUI.updateCommonRedEp = function ( node, show, scale )
	if not libUI.isValidNode(node) then return end
	if show then
		if not libUI.isValidNode(node.redEp) then
			node.redEp = libUI.createSprite(node, "header_footer/style1/header/images/icon_red.png", cc.p(0, 0), 0, nil, scale or 1)
		end
		if libUI.isValidNode(node.redEp) then
			node.redEp:setVisible(true)
		end
	else
		if libUI.isValidNode(node.redEp) then
			node.redEp:setVisible(false)
		end
	end
end
-- 红点动画
libUI.updateCommonRedSpine = function ( node, show )
	if not libUI.isValidNode(node) then return end
	if show then
		if not libUI.isValidNode(node.redSpine) then
			local spinePath = "header_footer/style1/header/spines/red/spine"
			local _, _spine = libUI.addSpineAnimation(node, 0, spinePath, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
			_spine:setOpacity(255)
			node.redSpine = _spine
		end
		if libUI.isValidNode(node.redSpine) then
			node.redSpine:setVisible(true)
		end
	else
		if libUI.isValidNode(node.redSpine) then
			node.redSpine:setVisible(false)
		end
	end
end


-- 主题收集特效
libUI.playThemeHitAnimation = function ( node, spinePath, callback )
	if not libUI.isValidNode(node) then
		if callback then
			callback()
		end
		return
	end
	
	local parent = bole.scene
	local atCtl = ActivityThemeController:getInstance()
	local centerWorldPos = ScreenControl:getInstance().isPortrait and cc.p(FRAME_HEIGHT/2,300) or cc.p(FRAME_WIDTH/2,360)
	local startWorldPos = atCtl:getHitAnimationStartWorldPos() or cc.pAdd(cc.p(0,0), centerWorldPos)
	local startNodePos = parent:convertToNodeSpace(startWorldPos)
	local endWorldPos = cc.p(0, 0)
	if atCtl:getBShowType() == atCtl:getBShowTypeValue("icon") then
		endWorldPos = atCtl:getBIconPos() or cc.p(0, 0)
	elseif atCtl:getBShowType() == atCtl:getBShowTypeValue("list") then
		endWorldPos = node:convertToWorldSpace(cc.p(0,0))
	end
	local endNodePos = parent:convertToNodeSpace(endWorldPos)
	for i = 1, 6 do
		local skeleton = sp.SkeletonAnimation:create(spinePath..".json", spinePath..".atlas", 1)
		skeleton:setPosition(startNodePos)
		skeleton:setScale(1)
		parent:addChild(skeleton, 0)
		skeleton:setVisible(false)
		skeleton:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(0.08*i),
				cc.CallFunc:create(function( )
					local aniIndex = i%2 + 1
					skeleton:setVisible(true)
					skeleton:setAnimation(0,"animation" .. aniIndex, false)
				end),
				cc.DelayTime:create(0.2),
				cc.MoveTo:create(0.5, endNodePos),
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(function ( ... )
					if callback then
						callback()
						callback = nil
					end
				end),
				cc.RemoveSelf:create()
			)
		)
	end
end
-- 主题收集特效
libUI.playThemeHitAnimationNew = function (startPos, endPos, spineInfo, sprInfo, callback)
	if not spineInfo and not sprInfo then
		if callback then
			callback()
		end
		return
	end
	
	local parent = bole.scene
	for i = 1, 6 do
		local flyNode = nil
		if spineInfo and spineInfo.spinePath then
			flyNode = sp.SkeletonAnimation:create(spineInfo.spinePath..".json", spineInfo.spinePath..".atlas", 1)
			flyNode:setScale(spineInfo.nScale or 1)
		elseif sprInfo and sprInfo.sprPath then
			flyNode = cc.Sprite:create(sprInfo.sprPath)
			flyNode:setScale(sprInfo.nScale or 1)
		end
		
		flyNode:setPosition(startPos)
		parent:addChild(flyNode)
		flyNode:setVisible(false)
		flyNode:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(0.08*i),
				cc.CallFunc:create(function( )
					flyNode:setVisible(true)

					if spineInfo and spineInfo.aniName then
						flyNode:setAnimation(0, spineInfo.aniName, false)
					else

					end
				end),
				cc.DelayTime:create(0.2),
				cc.MoveTo:create(0.5, endPos),
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(function ( ... )
					if callback then
						callback()
						callback = nil
					end
				end),
				cc.RemoveSelf:create()
			)
		)
	end
end


libUI.showCommonTip = function ( data )
	local node = cc.Node:create()
	bole.scene:addChild(node, 5)

    local text_label = FONTS.new("commonfonts/inbox_main.TTF", data.text or "", data.fontSize or 30)
    node:addChild(text_label)
    text_label:setColor(data.fontColor or cc.c3b(255, 255, 255))

	node:setCascadeOpacityEnabled(true)
	node:setOpacity(0)
	local centerPos = ScreenControl:getInstance().isPortrait and cc.p(FRAME_HEIGHT/2, FRAME_WIDTH/2) or cc.p(FRAME_WIDTH/2, FRAME_HEIGHT/2)
	node:setPosition(cc.p(centerPos.x, centerPos.y - 200))
	node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(data.delayTime or 0),
			cc.EaseOut:create(
				cc.Spawn:create(
					cc.FadeIn:create(0.3),
					cc.MoveTo:create(0.3, centerPos)
				),
				3
			),
			cc.DelayTime:create(data.stayTime or 2),
			cc.EaseIn:create(
				cc.Spawn:create(
					cc.FadeOut:create(0.3),
					cc.MoveTo:create(0.3, cc.p(centerPos.x, centerPos.y + 200))
				),
				3
			),
			cc.RemoveSelf:create()
		)
	)
end

libUI.isRunningAction = function (node)
	if not libUI.isValidNode(node) or not node.getNumberOfRunningActions then return false end
	return node:getNumberOfRunningActions() > 0
end

libUI.runScaleAppearAction = function (node, delay, callback, aimScale)
	if not libUI.isValidNode(node) then 
		if callback then callback() end
		return 
	end
	aimScale = aimScale or 1
	delay = delay or 0
	node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(delay),
			cc.ScaleTo:create(15 / 60, 1.07 * aimScale),
			cc.ScaleTo:create(10 / 60, 0.95 * aimScale),
			cc.ScaleTo:create(10 / 60, 1.02 * aimScale),
			cc.ScaleTo:create(10 / 60, 1 * aimScale),
			cc.CallFunc:create(function ( ... )
				if callback then
					callback()
				end
			end)
		)
	)
end

-- frenzy icon
local fbIconUrlList = {}
libUI.getHeadIconRef = function ( url )
	if url then
		fbIconUrlList[url] = (fbIconUrlList[url] or 0) + 1
		return fbIconUrlList[url]
	end
end
-- 头像
libUI.updateCommonHead = function ( node, data )
    local facebook_id 	= data.facebook_id
    local user_icon_id 	= data.user_icon_id or 0
    local head_size 	= data.head_size or 90
	-- 裁剪纹理创建的节点，一般是背景
    local stencil_sp 	= data.stencil_sp
	-- 裁剪纹理的路径，不能是合图
	local stencil_path	= data.stencil_path
    local stencil_alpha = data.stencil_alpha or 0.7
    local is_frame 		= data.is_frame
    local head_id 		= data.head_id

    -- 删除之前创建的
    if libUI.isValidNode(node.head_icon) then
        node.head_icon:removeFromParent()
        node.head_icon = nil
    end

    local parent = node
    -- 需要裁减
    if libUI.isValidNode(stencil_sp) or stencil_path then
        if libUI.isValidNode(node.clip_node) then
            parent = node.clip_node
        else
            local clip_stencil = cc.Sprite:create()
			if libUI.isValidNode(stencil_sp) then
            	clip_stencil:setSpriteFrame(stencil_sp:getSpriteFrame())
			elseif stencil_path then
				clip_stencil:setTexture(stencil_path)
			end
            if clip_stencil then
                local clip_node = cc.ClippingNode:create(clip_stencil)
                clip_node:setAlphaThreshold(stencil_alpha)
                node:addChild(clip_node)
                node.clip_node = clip_node
				clip_node:setCascadeOpacityEnabled(true)
            end

            if libUI.isValidNode(node.clip_node) then
                parent = node.clip_node
            end
        end 
    end
    
    local icon = nil
    local head_icon = FrenzyVaultControl:getInstance():getUserIconImgPath("edit_profile_" .. user_icon_id)
    local head_frame = "kong/commonpics.png"
    if head_id and head_id ~= 0 then
    	icon = cc.Sprite:create("commonpics/icon_common_noavatar.png")
		icon:setCascadeOpacityEnabled(true)
        icon = FrenzyVaultControl:getInstance():getBaseAvatarNodeRob(nil, {head_id = head_id, size = cc.size(head_size, head_size)})
    elseif user_icon_id == 0 then
        -- 未选头像
        user_icon_id = 2
        head_icon = FrenzyVaultControl:getInstance():getUserIconImgPath("edit_profile_" .. user_icon_id)
        if head_icon then
            -- 没有头像数据，显示2
            icon = cc.Sprite:create(head_icon)
            icon:setPositionY(-9)
            icon:setScale(head_size / 220.0)
        end
    elseif user_icon_id == 1 then
        -- 选择fb头像
        local pic_data = GiftControl:getInstance():getPlayerPicture({facebook_id = facebook_id}, 229, 229)
        if pic_data then
            -- 显示fb头像
            local fbUrl = pic_data.pic[1]
            icon = LazySprite.new(fbUrl, cc.size(head_size, head_size), "commonpics/icon_common_noavatar.png", libUI.getHeadIconRef(fbUrl))
        elseif head_icon then
            -- 没有头像数据，显示1
            icon = cc.Sprite:create(head_icon)
            icon:setPositionY(-9)
            icon:setScale(head_size / 220.0)
        end
    elseif user_icon_id >= FrenzyVaultControl:getInstance():getIconPrivateFromIndex() then --private icon
        icon = cc.Sprite:create("commonpics/icon_common_noavatar.png")
		icon:setCascadeOpacityEnabled(true)
        icon = FrenzyVaultControl:getInstance():getBaseAvatarNode(nil, {index = user_icon_id, frame = is_frame, size = cc.size(head_size, head_size)})
    else
        -- 选择头像
        if head_icon then
            -- 头像数据
            icon = cc.Sprite:create(head_icon)
            icon:setPositionY(-9)
            icon:setScale(head_size / 220.0)
        end
    end

    if icon then
        parent:addChild(icon)
        node.head_icon = icon
    end
	node:setCascadeOpacityEnabled(true)
end
-- 显示自己的头像
-- head_size 头像大小
libUI.updateCommonHeadSelf = function ( node, data )
	data = data or {}
	data.user_icon_id = FrenzyVaultControl:getInstance():getUserIconId()
	if Facebook:getInstance():isLoggedIn() and data.user_icon_id and data.user_icon_id == 1 then
		data.facebook_id = Facebook:getInstance().userid
	end
	libUI.updateCommonHead(node, data)
end
-- 名字
libUI.getCommonName = function ( data )
	local facebook_name = data.facebook_name or ""
	local user_nick_name = data.nick_name or ""
	local random_nick_name = data.random_nick_name or ""

	if string.match(user_nick_name, "Player%d+") then
		-- 如果玩家名字格式为Playerxxxx，认为玩家没改过名字
		random_nick_name = user_nick_name
		user_nick_name = ""
	end
	if string.match(facebook_name, "[^%w%~%!%@%#%$%%%^%&%*%(%)%_%+%-%=%{%}%[%]%|\\%:%;\"\'%<%>%,%.%?%/ ]") then
		-- 如果玩家fb名字含有非法字符，不显示fb名字
		facebook_name = ""
	end

	if user_nick_name ~= "" then
		-- 优先显示玩家修改的名字
		return user_nick_name
	elseif facebook_name ~= "" then
		-- 显示facebook名字
		return facebook_name
	else
		-- 显示playerxxxx
		return random_nick_name
	end
end
-- 国旗
libUI.updateCommonFlag = function ( node, data )
    local geo_code = string.lower(data.geo_code or "us")
	local flag_width = data.flag_width
	local flag_height = data.flag_height
	local flag_scale = data.flag_scale

    -- 删除之前创建的
    if libUI.isValidNode(node.flag_icon) then
        node.flag_icon:removeFromParent()
        node.flag_icon = nil
    end

	local icon = nil
	local icon_path = string.format("national_flag/%s.png", geo_code)
	if cc.FileUtils:getInstance():isFileExist(icon_path) then
		icon = cc.Sprite:create(icon_path)
	end

	if icon then
		if flag_width and flag_height then
			-- 分别缩放
			icon:setScaleX(flag_width/icon:getContentSize().width)
			icon:setScaleY(flag_height/icon:getContentSize().height)
		elseif flag_width then
			-- 
			icon:setScale(flag_width/icon:getContentSize().width)
		elseif flag_height then
			-- 
			icon:setScale(flag_height/icon:getContentSize().height)
		elseif flag_scale then
			icon:setScale(flag_scale)
		end
        node:addChild(icon)
        node.flag_icon = icon
	end
end

libUI.couponAppearAction = function (node)
	if not libUI.isValidNode(node) then return end
	node:stopActionByTag(123)
	node:setScaleX(0)
	local action = cc.Sequence:create(
		cc.DelayTime:create(1.5),
		cc.MoveBy:create(0.01, cc.p(0, 17)),
		cc.Spawn:create(
			cc.Sequence:create(
				cc.ScaleTo:create(15 / 60, 1.1, 1),
				cc.ScaleTo:create(10 / 60, 0.95, 1),
				cc.ScaleTo:create(10 / 60, 1, 1)
			),
			cc.MoveBy:create(15 / 60, cc.p(0, -17))
		)
	)
	action:setTag(123)
	node:runAction(action)
end

-- 把锚点放在最右边 并改变位置和之前位置一样 结束后再把锚点恢复原位
libUI.coinsLabelRiseAction = function (label, fromLbl, aimLbl, formatFunc, duration, frequency, callback)
	if not libUI.isValidNode(label) then return end

	fromLbl    = fromLbl or 0
	aimLbl     = aimLbl or 0
	duration   = duration or 1
	frequency  = frequency or 120
	formatFunc = formatFunc or function (_label)
		if not _label then return end
		return FONTS.format(_label, true)
	end
	local perDuration = duration / frequency
	do
		label:setString(formatFunc(aimLbl))
		local labelWidth = label:getContentSize().width
		label:setAnchorPoint(cc.p(1, 0.5))
		label:setPositionX(label:getPositionX() + labelWidth / 2)
	end

	local digit = 0
	local tempLbl = aimLbl
	while tempLbl >= 1 do
		digit = digit + 1
		tempLbl = tempLbl / 10
	end
	local lastTime = 0 -- frequency

	local showAndStopRatio = 2 / 3

	math.randomseed(os.time())

	label:runAction(
		cc.Sequence:create(
			cc.Repeat:create(
				cc.Sequence:create(
					cc.CallFunc:create(function ( ... )
						lastTime = lastTime + 1
						local currentProgress = lastTime / frequency
						local digitNumber = math.ceil(digit * (lastTime) / (frequency * 3 / 4)) -- 用前3/4的时间 显示位数
						if currentProgress > 0.75 then
							digitNumber = digit
						end
						-- 用后3/4的时间 停下位数
						local affirmatoryNumber = 0
						if currentProgress > 0.25 then
							affirmatoryNumber = math.ceil(digit * (lastTime - frequency * 3 / 4) / (frequency - frequency * 3 / 4))
						end

						local showNumber = 0
						for i = 1, digitNumber do
							local toolNumber = math.pow(10, i - 1)

							local currentDigitNumber = math.random(0, 9) -- 当前数位 未确定 要显示随机数
							if i <= affirmatoryNumber then -- 当前位置确定了 要显示真实的数字
								-- 获取当前位的数字
								currentDigitNumber = aimLbl
								currentDigitNumber = currentDigitNumber % (toolNumber * 10)
								currentDigitNumber = math.floor(currentDigitNumber / toolNumber)
							end
							showNumber = showNumber + currentDigitNumber * toolNumber
						end
						label:setString(formatFunc(showNumber))
					end),
					cc.DelayTime:create(perDuration)
				)
				,
				frequency
			),
			cc.CallFunc:create(function ( ... )
				label:setString(formatFunc(aimLbl))
				local labelWidth = label:getContentSize().width
				label:setAnchorPoint(cc.p(0.5, 0.5))
				label:setPositionX(label:getPositionX() - labelWidth / 2)
			end)
		)
	)
end

libUI.playCommonRibbonSpine = function ( node , delay)
	if not libUI.isValidNode(node) then return end

	delay = delay or 0

	local _, _spine = libUI.addSpineAnimation(node, nil, "commonEffect/ribbons/spine", cc.p(0, 0), "animation", nil, nil, nil, true, false, nil)
	if _spine then
		_spine:runAction(
			cc.Sequence:create(
				cc.Hide:create(),
				cc.DelayTime:create(delay),
				cc.CallFunc:create(function ( ... )
					_spine:setAnimation(0, "animation", true)
				end),
				cc.Show:create(),
				cc.DelayTime:create(43 / 30),
				cc.CallFunc:create(function ( ... )
					_spine:removeFromParent()
				end)
			)
		)
	end
end

libUI.playExplosizeEffect = function (node, prize_width, delay, callback)
	math.randomseed(os.time())

	delay = delay or 0

	local children = node:getChildren()
    local index = 0
    local num = #children
    for i, v in ipairs(children) do
        local _random = (math.random() - 0.5) * 2

        local pos = cc.p(v:getPosition())
        local offsetx = 440 + _random * 100
        if pos.x > prize_width / 2 then
            offsetx = -440 + _random * 100
        end

        v:runAction(
	        cc.Sequence:create( 
	        	cc.DelayTime:create(delay),
	        	cc.CallFunc:create(function ( ... )
	        		bole.setNodeGlobalZOrder(v, 2)
	        	end),
	            cc.EaseOut:create(
	                cc.Spawn:create(
	                    cc.JumpTo:create(0.85 , cc.p(pos.x + offsetx ,pos.y + _random * 100) , 200 , 1),
	                    cc.ScaleTo:create(0.85, 1.5),
	                    cc.RotateBy:create(0.85, 180 + 180 * _random),
	                    cc.Sequence:create(
	                        cc.DelayTime:create(0.4),
	                        cc.FadeOut:create(0.45)
	                    )
	                ),
	                2
	            ),
	            cc.CallFunc:create(function ( ... )
	            	index = index + 1
	            	if index == num and callback then
	            		callback()
	            	end
	            end)
	        )
        )
    end
end

--[[
    设置明暗不止一个节点
]]
libUI.addTouchEventDark = function ( btn, event, obj, param, nodeList)
    if not libUI.isValidNode(btn) then return end
    if nodeList then
        for key,item in pairs(nodeList) do
            if libUI.isValidNode(item) then
                item:setCascadeColorEnabled(true)
            end
        end
    end
    local size = btn:getContentSize()
    local rect = cc.rect(0, 0, size.width, size.height)

   
    local setDarkFunc = function(isGray)
        local darkColor = cc.c3b(123,123,123)
        local nromalColor = cc.c3b(255,255,255)
        if not nodeList then
            return 
        end
        local color  = isGray and darkColor or nromalColor
        for key,item in pairs(nodeList) do
            if libUI.isValidNode(item) then
                item:setColor(color)
            end
        end
    end
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            setDarkFunc(true)
        elseif eventType == ccui.TouchEventType.canceled then
            setDarkFunc(false)
        elseif eventType == ccui.TouchEventType.moved then
            local point = sender:getTouchMovePosition()
            point = btn:convertToNodeSpace(point)
            if cc.rectContainsPoint(rect, point) then
                setDarkFunc(true)
            else
                setDarkFunc(false)
            end
        elseif eventType == ccui.TouchEventType.ended then
            setDarkFunc(false)
            if event then
        		event(obj, unpack(param or {}))
        	end
        end
    end
    btn:addTouchEventListener(btnEvent)
end


-- 配置footer倒计时
libUI.configFooterCountDownLabelInTime = function (label, time_func, end_func, time_config, allow_day, day_config, hour_config)
	if not label or not time_func then return end

	time_config          = time_config or {}
	day_config           = day_config  or {}
	local time_pre_text  = time_config[1] or ""
	local time_post_text = time_config[2] or ""
	local interval_text = time_config[3] or ":"
	local day_pre_text   = day_config[1]  or ""
	local day_post_text1 = day_config[2] or " DAYS"
	local day_post_text2 = day_config[3] or " DAY"
	local hour_pre_text	 = hour_config[1]  or ""
	local hour_post_text = hour_config[2]  or ""

    local end_func_called= false

	local _update = function ( ... )
		local left_time = time_func()
		local day_time  = 86400
		if left_time >= 0 then
			if allow_day and left_time > day_time then

				local days = math.floor(left_time / day_time)
				local day_post_text = (days == 1 and day_post_text2 or day_post_text1)
				local hours = math.floor((left_time - days * day_time) / 3600)
				label:setString(day_pre_text .. days .. day_post_text .. hour_pre_text .. hours .. hour_post_text)

			else

				local function getTimeString(num)
					return ((num < 10 and "0") or "") .. num
				end

				-- day暂时不需要
				local hour   = getTimeString(math.floor(left_time / 3600))
				local minute = getTimeString(math.floor(left_time % 3600 / 60))
				local second = getTimeString(math.floor(left_time % 60))
				label:setString(time_pre_text .. hour .. interval_text .. minute .. interval_text .. second .. time_post_text)
			end
			
			if left_time <= 0 then
				if end_func then
					end_func_called = true
					end_func()
				end
			end
		else
			if not end_func_called and end_func then
				end_func_called = true
				end_func()
			end 
		end
	end
	_update()
	label:runAction(
		libUI.repeatForeverAction(
			libUI.sequenceAction(
				libUI.delayTimeAction(1),
				libUI.callFuncAction(_update)
			)
		)
	)
end

---@field libUI.setSystemPopTitle function 设置系统弹窗标题
libUI.setSystemPopTitle = function(node, params)
	if not libUI.isValidNode(node) then
		return
	end

	if not bole.hasUIComponent(node, UIComponent.LanguageLabel) then
		bole.ctorUIComponent(node, UIComponent.LanguageLabel)
	end
	
	node:setOriginFntColor(cc.c3b(249, 220, 74))
	node:setTTFShadow(cc.c4b(166, 85, 31, 255), cc.size(0, -3), 0.5)
	node:setOriginLineHeight(60)
	node:setOriginOffset(0, 8)
	if params and params.ignore_scale then
		node:setIgnoreTTFVersion(LANGUAGE.GERMAN, 1)
	end

	if params and params.string_case then
		node:setStringCase(params.string_case)
	end

	if params and params.config then
		node:setStringConfig(params.config)
	end
end

-- 按照"a/b/c"的层级顺序找到孩子
libUI.findChildNode = function ( node, child_path )
	if not libUI.isValidNode(node) then return end

	local child_path_list = string.split(child_path, "/")
	local child_node = node
	for i, child_name in ipairs(child_path_list) do
		if child_name == "" then
			-- 非法名字
			return child_node
		else
			child_node = child_node:getChildByName(child_name)
			if not child_node then
				return
			end
		end
	end

	return child_node
end


