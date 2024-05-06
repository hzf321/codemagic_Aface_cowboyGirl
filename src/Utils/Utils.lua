FONTS = FONTS or {}

math.mod = math.fmod

-- 配置倒计时
bole.configCountDownLabel = function (label, time_func, end_func, time_config, allow_day, day_config)
	if not label or not time_func then return end

	time_config          = time_config or {}
	day_config           = day_config  or {}
	local time_pre_text  = time_config[1] or ""
	local time_post_text = time_config[2] or ""
	local day_pre_text   = day_config[1]  or ""
	local day_post_text1 = day_config[2] or "DAYS"
	local day_post_text2 = day_config[3] or "DAY"
    local end_func_called= false

	label:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
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
            
        end),
        cc.DelayTime:create(1))))
end

-- 配置倒计时 (只有分秒)
bole.configCountDownLabel2 = function (label, time_func, end_func)
	if not label or not time_func then return end

    local end_func_called= false

	label:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            local left_time = time_func()
            local day_time  = 86400
            if left_time >= 0 then

                local function getTimeString(num)
                    return ((num < 10 and "0") or "") .. num
                end

                local minute = getTimeString(math.floor(left_time % 3600 / 60))
                local second = getTimeString(math.floor(left_time % 60))
                label:setString(minute .. ":" .. second)

                
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
        cc.DelayTime:create(1))))
end

bole.isAndroid = function() 
    return Config.platform == "android"
end

bole.isIOS = function()
    return Config.platform == "ios"
end

bole.isAmazon = function() 
    return Config.platform == "amazon"
end

bole.isHuawei = function() 
    return Config.platform == "huawei"
end

bole.isGoogle = function() 
    return Config.platform == "android"
end

bole.isMac = function()
    return cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC
end

bole.isIphoneX = function()
    if true then return false end

    if Config.platform == "ios" and FRAME_WIDTH/DESIGN_WIDTH > 1.2 then
        return true
    end
    local  isIphoneX = false
    if appDebugMode then
        local saveinfo = cc.UserDefault:getInstance():getStringForKey("is_iphonex")
        if saveinfo and saveinfo == "1" then
            isIphoneX = true
        else
            isIphoneX = false
        end
    end

    return isIphoneX
end

bole.isWidescreen = function()
    if HEADER_FOOTER_SCALE_H < 1 then
        return true
    end
    return false
end

--判断Version是否兼容当前包
bole.isCompatible = function(version)
    local packageVersion = tonumber(Config.versionCode)
    if packageVersion == version or packageVersion > version then
        return true
    end
    return false
end

bole.convertPrice = function(price)
    if bole.isHuawei() then
        if price then
            return "$" .. price .. ".00"
        end
        return ""
    else
        return PurchaseControl:getInstance():getLocalizationPrice(price)
    end
end

bole.adaptReelBoard = function(child, scaleDis) -- 控制传入的节点, 向footer偏移
    scaleDis = scaleDis or 1
    if child then
        if bole.isIphoneX() then
            child:setPosition(cc.p(0,child:getPositionY()-(bole.getAdaptWidth() * scaleDis)/2+30))
        else
            child:setPosition(cc.p(0,child:getPositionY()-(bole.getAdaptWidth() * scaleDis)/2))
        end
    end
end

--bole.adaptBottomHorizontal = function ( child )
--    if bole.isValidNode(child) then
--        if SHRINKSCALE_H < 1 then
--            child:setPositionY(child:getPositionY()-DESIGN_HEIGHT*(1-SHRINKSCALE_H)/2 - 120*(1-SHRINKSCALE_H))    --
--        end
--    end
--end
---@desc  if param child is mainThemeScene ,param baseScale is 1
---@desc else param child is mainThemeScene's child, param baseScale is nil
bole.adaptBottomHorizontal = function(child, baseScale)
    baseScale = baseScale or bole.getAdaptScale()
    if bole.isValidNode(child) then
        if bole.isWidescreen() then
            local moveY = bole.getAdaptBottomHMoveY(baseScale)
            child:setPositionY(child:getPositionY() - moveY)
        end
    end
end
bole.getAdaptBottomHMoveY = function(baseScale)
    baseScale = baseScale or bole.getAdaptScale()
    if bole.isWidescreen() then
        local moveY = FRAME_HEIGHT * (1 - bole.getAdaptScale()) / 2 / baseScale
        return moveY
    end
    return 0
end

bole.getAdaptReelBoardMoveY = function(scaleDis)
    scaleDis = scaleDis or 1
    local moveY = 0
    if bole.isIphoneX() then
        moveY = -(bole.getAdaptWidth() * scaleDis)/2+30
    else
        moveY = -(bole.getAdaptWidth() * scaleDis)/2
    end
    return moveY
end

bole.getAdaptReelBoardY = function( scaleDis)
    scaleDis = scaleDis or 1
    local posY = bole.getAdaptWidth() * scaleDis / 2
    if bole.isIphoneX() then
        posY = posY - 30
    end
    return posY
end
bole.adaptTop = function(child, scaleDis) 
    scaleDis = scaleDis or 1
    if child then
        if bole.isIphoneX() then
            child:setPosition(cc.p(child:getPositionX(),child:getPositionY() + (bole.getAdaptWidth() * scaleDis)/2 - 50))
        else
            child:setPosition(cc.p(child:getPositionX(),child:getPositionY() + (bole.getAdaptWidth() * scaleDis)/2))
        end
    end
end

bole.adaptTopAll = function(child, scaleDis) 
    scaleDis = scaleDis or 1
    if child then
        child:setPosition(cc.p(child:getPositionX(),child:getPositionY() + (bole.getAdaptWidth() * scaleDis)/2))
    end
end


bole.getAdaptReelDistance = function()
    if bole.isIphoneX() then
        return bole.getAdaptWidth()/2-50
    else
        return bole.getAdaptWidth()/2
    end
end

bole.getAdaptScale = function (isPortrait)
    if SHRINKSCALE_H < 1 then
        if isPortrait then
            return SHRINKSCALE_H - 2*(130/SHRINKSCALE_H-130)/DESIGN_WIDTH
        else
            return SHRINKSCALE_H
        end
        
    end
    return 1
end

bole.adaptScale = function ( node,isPortrait)
    if SHRINKSCALE_H < 1 then
        if isPortrait then
            local scale = SHRINKSCALE_H - 2*(130/SHRINKSCALE_H-130)/DESIGN_WIDTH
            node:setScale(scale)
        else
            local scale = SHRINKSCALE_H
            node:setScale(scale)
        end
    end
end

--适配背景图片
bole.adaptBackground = function (bg)
    if bg then
        local scale = FRAME_WIDTH/DESIGN_WIDTH
        if scale > 1 then 
            bg:setScale(bg:getScale()*scale)
        elseif scale < 1 then
            bg:setScale(bg:getScale()/scale)
        end
    end
end

bole.getAdaptationWidthScreen = function (pro)
    pro = pro or 0.86 -- 1100/1280
	if HEADER_FOOTER_SCALE_H <= pro then
		return true
	end
	return false
end

bole.getAdaptationLongScreen = function (pro)
    pro = pro or 1.14  -- 1460/1280
	if HEADER_FOOTER_RATE_H >= pro then
		return true
	end
	return false
end

bole.isWaveAvailable = function ()
    local version = 0
    if tonumber(Config.versionCode) > version then
        if bole.isAndroid() then
            if bole.isBit64 then
                return true
            end
            return false
        end
        return true
    end
    return false
end

ComponentType = {
    TopLeft       = 1,
    TopRight      = 2,
    BottomLeft    = 3,
    BottomRight   = 4,
    Top           = 5,
    Bottom        = 6,
    Left          = 7,
    Right         = 8
}
--适配关闭按钮类型的需要贴边的元素
bole.adaptComponent = function (node,type,spaceX,spaceY,isPortrait)
    spaceX = spaceX or 0
    spaceY = spaceY or 0
    -- if isPortrait then
    --     bole.adaptComponentV(node,type,spaceX,spaceY)
    --     return
    -- end
    -- print("zhf FRAME = ",FRAME_WIDTH,FRAME_HEIGHT)
    -- print("zhf space = ",spaceX,spaceY)
    if type == ComponentType.TopLeft then
        node:setPosition(cc.p(-FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)+spaceX,FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)-spaceY))
    elseif type == ComponentType.TopRight then 
        node:setPosition(cc.p(FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)-spaceX,FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)-spaceY))
    elseif type == ComponentType.BottomLeft then 
        node:setPosition(cc.p(-FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)+spaceX,-FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)+spaceY))
    elseif type == ComponentType.BottomRight then 
        node:setPosition(cc.p(-FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)+spaceX,-FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)+spaceY))
    elseif type == ComponentType.Top then 
        if isPortrait then
            node:setPosition(cc.p(node:getPositionX(),FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)-spaceY))
        else
            node:setPosition(cc.p(node:getPositionX(),FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)-spaceY))
        end
    elseif type == ComponentType.Bottom then 
        if isPortrait then
            node:setPosition(cc.p(node:getPositionX(),-FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)+spaceY))
        else
            node:setPosition(cc.p(node:getPositionX(),-FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)+spaceY))
        end

    elseif type == ComponentType.Left then
        if isPortrait then
            node:setPosition(cc.p(-FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)+spaceX,node:getPositionY()))
        else
            node:setPosition(cc.p(-FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)+spaceX,node:getPositionY()))
        end
        
    elseif type == ComponentType.Right then
        if isPortrait then
            node:setPosition(cc.p(FRAME_HEIGHT/2/bole.getAdaptScale(isPortrait)-spaceX,node:getPositionY()))
        else
            node:setPosition(cc.p(FRAME_WIDTH/2/bole.getAdaptScale(isPortrait)-spaceX,node:getPositionY()))
        end
    end
end

bole.adaptComponentV = function (node,type,spaceX,spaceY)
    -- spaceX = spaceX or 0
    -- spaceY = spaceY or 0
    -- if type == ComponentType.TopLeft then
    --     node:setPosition(cc.p(-FRAME_HEIGHT/2/bole.getAdaptScale(true)+spaceX,FRAME_WIDTH/2/bole.getAdaptScale(true)-spaceY))
    -- elseif type == ComponentType.TopRight then 
    --     node:setPosition(cc.p(FRAME_HEIGHT/2/bole.getAdaptScale(true)-spaceX,FRAME_WIDTH/2/bole.getAdaptScale(true)-spaceY))
    -- elseif type == ComponentType.BottomLeft then 
    --     node:setPosition(cc.p(-FRAME_HEIGHT/2/bole.getAdaptScale(true)+spaceX,-FRAME_WIDTH/2/bole.getAdaptScale(true)+spaceY))
    -- elseif type == ComponentType.BottomRight then 
    --     node:setPosition(cc.p(-FRAME_HEIGHT/2/bole.getAdaptScale(true)+spaceX,-FRAME_WIDTH/2/bole.getAdaptScale(true)+spaceY))
    -- elseif type == ComponentType.Top then 
    --     node:setPosition(cc.p(node:getPositionX(),FRAME_WIDTH/2/bole.getAdaptScale(true)-spaceY))
    -- end
end

--设计屏幕宽度和实际屏幕宽度差
bole.getAdaptWidth = function ()
    if SHRINKSCALE_H == 1 then
        return (FRAME_WIDTH - DESIGN_WIDTH)
    end
    return 0
end

bole.adaptTransition = function (node,isPortrait,sameRate)
    if SHRINKSCALE_H < 1 then
        local scale = bole.getAdaptScale(isPortrait)
        if sameRate then
            node:setScale(1/scale)
        else
            node:setScaleX(1/scale) 
        end
    else
        if sameRate then
            node:setScale(FRAME_WIDTH/DESIGN_WIDTH)
        else
            node:setScaleY(FRAME_WIDTH/DESIGN_WIDTH)    
        end
    end
end

bole.isValidNode = function (node)
    return (not tolua.isnull(node))
end

bole.getNodePos = function(node,pos)
    return node:convertToNodeSpace(pos)
end

bole.getWorldPosByPos = function(parent,pos)
    return parent:convertToWorldSpace(pos)
end

 -- 抛物线 状态 向footer 移动的 
bole.bezierAction2 = function(obj, from, to, duration, beginInterval, callFunc, showAction)
    showAction = showAction or cc.Show:create()
    beginInterval = beginInterval or 0
    duration = duration or 1
    obj:setPosition(from)
    obj:setVisible(false)

    local function myBezier( from, to, duration )
        local sy = math.abs(to.y-from.y)
        local sx = to.x-from.x
        local bezier = {
            cc.p(to.x -(sx*math.random(7,8)/10) ,(sy+80)*math.random(7,11)/10),
            cc.p(to.x -(sx*math.random(3,4)/10) ,from.y*math.random(7,11)/10), --cc.p(2.4*dd*sx,  -sy/4),
            to
        }     
        local bezier = cc.BezierTo:create(duration, bezier)
        return bezier
    end
    obj:runAction(cc.Sequence:create(
            cc.DelayTime:create(beginInterval), 
            showAction, 
            myBezier(from,to, duration),
            cc.CallFunc:create(function( )
                if callFunc then
                    callFunc()
                end
            end)
        )
    )
end

bole.getSysVersionInt = function()
    local versionStr = bole.getSysVersion()
    if versionStr then
        return tonumber(versionStr:sub(1,2))
    end
    return 0
end

bole.getMainVersion = function()
    local versionStr = bole.getSysVersion()
    if bole.isIOS() then
        local index = string.find(versionStr,"%.",4)
        if index then
            versionStr = versionStr:sub(1,index-1)
        end
        return tonumber(versionStr)
    end
    return 1.0
end

-- 多个 spine 默认 循环
bole.bezierAction3 = function(parent,spinData,from, to, count,duration, beginInterval,interval,needRotation, callFunc, showAction)
    showAction = showAction or cc.Show:create()
    beginInterval = beginInterval or 0
    duration = duration or 1
    interval = interval or 0.1
    for i = 1,count do
        beginInterval = beginInterval + interval*(i-1)
        local _,s  = bole.addSpineAnimation(parent, nil, spinData.spineFile, spinData.startNPos, spinData.animaName, nil, nil, nil,spinData.isRetain,spinData.isLoop)
        obj = s
        obj:setVisible(false)
        if needRotation then 
            obj:setRotation(math.random(1,90))
        end
        local function myBezier( from, to, duration )
            local sy = math.abs(to.y-from.y)
            local sx = to.x-from.x
            local bezier = {
                cc.p(to.x -(sx*math.random(7,8)/10) ,(sy+80)*math.random(7,11)/10),
                cc.p(to.x -(sx*math.random(3,4)/10) ,from.y*math.random(7,11)/10), --cc.p(2.4*dd*sx,  -sy/4),
                to
            }   
            local bezier = cc.BezierTo:create(duration, bezier)
            return bezier
        end
        obj:runAction(cc.Sequence:create(
            cc.DelayTime:create(beginInterval), 
            showAction, 
            myBezier(from,to, duration),
            cc.CallFunc:create(function()
                if i == count and callFunc then 
                    callFunc()
                end
            end),
            cc.RemoveSelf:create()))
    end
end

bole.getVideoName = function(url)
    local save_name = bole.hash(url)
    save_name = save_name..".mp4"
    return save_name
end

-- 统计崩溃辅助函数,setIntegerForKey(key, value)
bole.setIntegerForCrash = function(key, value) -- 参数一的意义是名字, 参数二的意义是此次增加的数值
    local flag = cc.UserDefault:getInstance():getIntegerForKey(key, 0)
    local res = flag + value
    cc.UserDefault:getInstance():setIntegerForKey(key, res)
end

-- login中发送给splunk数据,并且置零
bole.sendCrashData = function (key) -- 名字
    local value = cc.UserDefault:getInstance():getIntegerForKey(key, 0)
    Splunk:getInstance():send_codeInfo("crash",{erk = key, erv = value})
    cc.UserDefault:getInstance():setIntegerForKey(key, 0)
end

-- 下载网络图片并更新
bole.updateTexture = function(sprite, url, needlocal, success_func) -- 参数意义：参数一图片节点，参数二图片下载地址，参数三是否下载到本地以后才开始使用
    if url and sprite then
        local function onDownLoadFinish(name, isLocal)
            if cc.FileUtils:getInstance():isFileExist(name) and not tolua.isnull(sprite) then
                sprite:setTexture(name)
                if success_func then
                    success_func(sprite)
                end
            end
        end
      
        if url then
            HttpRequest:getInstance():downloadFile(url, onDownLoadFinish, false)
        end
    end
end

-- splunk 打点
bole.sendBySplunk = function(stepName, obj, new_user) -- 参数意义：字段名字，数据，是否对新用户打点
    local temp_data = {}
    if type(obj) == "table" then
        for k, v in pairs(obj) do
            if k and v then
                local temp = {k,v}
                table.insert(temp_data, temp)
            end
        end
    end
    local  isNewUser =  (User:getInstance().isNewUser and 1) or 0   
    local user_id = nil
    if User:getInstance().user_id then
        user_id = User:getInstance().user_id
    else
        user_id = bole.getDeviceId()
    end 

    local platform = 1
    if bole.isIOS() then
        platform = 2
    elseif bole.isAmazon() then
        platform = 3
    elseif bole.isHuawei() then
        platform = 4
    end
    table.insert(temp_data, {'step', stepName})
    if user_id then
        table.insert(temp_data, {'id', user_id})
        table.insert(temp_data, {'lv', User:getInstance().level or 1})
        table.insert(temp_data, {'v', Config.versionCode})
        table.insert(temp_data, {'ip', User:getInstance().ip or "1"})
        table.insert(temp_data, {'rt', User:getInstance().registerTime or "1"})
        table.insert(temp_data, {'c', User:getInstance().coins or 1})
        table.insert(temp_data, {'uuid', bole.UUID})
    end
    
    table.insert(temp_data, {'new', isNewUser})
    table.insert(temp_data, {'p', platform})

    if new_user then
        if User:getInstance().isNewUser then
            bole.potp:send("client", temp_data)
        end
    else
        bole.potp:send("client", temp_data)
    end
end

bole.send_codeInfo = function(stepName,obj,new_user)
    -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
    --     return
    -- end
    
    -- Splunk:getInstance():send_codeInfo(stepName,obj,new_user)
end

bole.send_codeInfo_JC = function(stepName,obj,new_user)
    Splunk:getInstance():send_codeInfo_JC(stepName,obj,new_user)
end

bole.print = function(key,data)
    print(key .. " = " .. tool.lua_to_json(data))
end

-- 更改动画播放
bole.changeSpineNormal = function(node,animation,isLoop)
    node:setAnimation(0,animation,isLoop)
end

bole.changeSpineSetupPose = function(node,animation,isLoop)
    node:setToSetupPose()
    node:setAnimation(0,animation,isLoop)
end

bole.changeSpineclearTracks = function(node,animation,isLoop)
    node:clearTracks()
    node:setAnimation(0,animation,isLoop)
end

-- whj: 2020.08.30 主题中可以调用的方法。可以调用spine 的 stopAllActions 不会有显示不出来动画
bole.addSpineAnimationInTheme = function(parent, zOrder, file, pos, animateName, completeCallback, callbackDelay, returnDelay, isRetain, isLoop, timeScale)
    local delay = returnDelay or 0
    callbackDelay = callbackDelay or 0
    zOrder = zOrder or 0
    if cc.FileUtils:getInstance():isFileExist(file..".json") then
        local skeleton = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
        skeleton:setPosition(pos)
        skeleton:setAnimation(0, animateName, isLoop) 
        skeleton:setTimeScale(timeScale or 1)
        parent:addChild(skeleton, zOrder)
        skeleton:registerSpineEventHandler(function (event)
                if not isRetain then
                    -- 延迟释放，否则会报错
                    skeleton:runAction(cc.Sequence:create(
                            cc.DelayTime:create(0),
                            cc.RemoveSelf:create()
                        ))
                end
                if completeCallback then
                    if callbackDelay == 0 then
                        completeCallback()
                    else
                        self:runAction(cc.Sequence:create(
                        cc.DelayTime:create(callbackDelay),
                        cc.CallFunc:create(function()
                            completeCallback()
                        end)))
                    end
                end
            end, sp.EventType.ANIMATION_COMPLETE)
        return delay, skeleton
    else
        if appDebugMode then
            print("Spine not exist ",file)
            print(a.b)
        else
            bole.send_codeInfo(Splunk_Type.Error, {error = "Spine_not_exist", msg = file}, false)
        end
        return 0, nil
    end
end

--@middlePos中点坐标，distance两个item中间的距离，index当前第几个item，total总得item数量，direction 0代表横向 1代表竖向
bole.getConvertedPos = function(middlePos,distance,index,total,direction)
    local dis = (2*index-total - 1)*distance/2
    if direction == 0 then
        return cc.p(middlePos.x+dis,middlePos.y)
    else
        return cc.p(middlePos.x,middlePos.y-dis)
    end
end

-- 延迟delay秒后，经过duration时间，声音从beginVolume线性变化到endVolume
bole.dealMusic_FadeLoopMusic = function(duration, beginVolume, endVolume, delay)

    local fadeMusicActionNode = cc.Node:create()
    fadeMusicActionNode:setName("voice_node")
    bole.scene:addChild(fadeMusicActionNode)
    local nowMusicVolume = AudioControl:getVolume() or beginVolume
    if (nowMusicVolume - endVolume) < 0.01 and (nowMusicVolume - endVolume) > -0.01 then
        return
    end
    local fadeMusicTag = true
    local groupName   = "loop"
    local fadeDur     = duration or 1
    local interval    = 1/10
    local actionList  = {}
    local frame       = math.modf(fadeDur/interval)
    local begVolume   = nowMusicVolume or 0
    local endVolume   = endVolume or 1
    local perChangeVolume = (endVolume-begVolume)/frame
    ----------------------------------------------------------------------
    local begDelay    = delay or 0
    local delayTime   = cc.DelayTime:create(begDelay)
    table.insert(actionList, delayTime)
    for i = 1, frame do
        local changeAction = cc.CallFunc:create(function()
            if fadeMusicTag then
                AudioControl:volumeGroupAudio(begVolume+perChangeVolume*i)
            end
        end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, delayTime)
        table.insert(actionList, changeAction)
    end
    fadeMusicActionNode:stopAllActions()
    fadeMusicActionNode:runAction(cc.Sequence:create( unpack(actionList) ))
end
bole.dealMusic_StopFadeLoopMusic = function ()
    if not libUI.isValidNode(bole.scene) then return end

    local fadeMusicActionNode = bole.scene:getChildByName("voice_node")
    if libUI.isValidNode(fadeMusicActionNode) then
        fadeMusicActionNode:stopAllActions()
    end
    local volume = (bole.isMusicMute() and 1) or 0
    AudioControl:volumeGroupAudio(volume)
end


--label 字体节点，image 图片集合的父节点，imgWidth 图片集合宽度（缩放之后的），maxWidth 显示框的最大宽度，maxScale 字体允许的最大缩放比例
bole.adaptRichText = function(label, image, imgWidth, maxWidth, maxScale, label_width)
    if not libUI.isValidNode(image) or not libUI.isValidNode(label) then
        return 
    end
    local label_width = label_width and label_width or label:getContentSize().width*maxScale
    if (imgWidth + label_width) < maxWidth then
        label:setScale(maxScale)
        label:setPositionX(label_width/2 - (imgWidth + label_width)/2 )
        image:setPositionX((imgWidth + label_width)/2-imgWidth)
    else
        local w_left = maxWidth - imgWidth
        local scale = w_left/label_width
        label:setScale(maxScale*scale)
        label_width = label_width*scale
        label:setPositionX(label_width/2 - (imgWidth + label_width)/2)
        image:setPositionX((imgWidth + label_width)/2-imgWidth)

        -- print("zhf adaptRichText ",w_left,scale,maxScale*scale,label_width,imgWidth,(imgWidth + label_width)/2 - label_width/2,(imgWidth + label_width)/2-imgWidth)
    end
end

bole.getPurchasePrice = function( itemInfo )
    if not itemInfo then return 1.99 end

    if bole.isHuawei() then
        return itemInfo[4]
    else
        return itemInfo[3]
    end
end

bole.addRewardAnimation = function(parent,baseDelay,delay, baseScale)
    if not bole.isValidNode(parent) then
        return
    end
    local time_delay = delay or 1
    baseDelay = baseDelay or 1
    baseScale = baseScale or 1
    for i, child in pairs(parent:getChildren()) do
        i = i or 0
        parent:runAction(cc.Sequence:create(cc.DelayTime:create(baseDelay + i*0.2),
            cc.CallFunc:create(function ()
                child:stopAllActions()
                child:setScale(1*baseScale)
                child:runAction(cc.RepeatForever:create(cc.Sequence:create(
                    cc.DelayTime:create(time_delay),
                    cc.ScaleTo:create(0.2, 1.2*baseScale),
                    cc.ScaleTo:create(0.2, 1*baseScale)
                )))
        end)))
    end
end


-- bole.addShadow = function (node,opacity,time,color)
--     time = time or 0 
    
--     local handler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
--         local sz = cc.Director:getInstance():getWinSize()
--         --创建RenderTexture
--         local render = cc.RenderTexture:create(sz.width,sz.height)
--         --清除屏幕
--         render:beginWithClear(0,0,0,0)
--         --对象调用visit实现渲染（visit会调用draw）
--         node:visit()
--         --结束RenderTexture
--         render:endToLua()
--         --利用renderTexture得到截图的数据，创建图片
--         local shadow = cc.Sprite:createWithTexture(render:getSprite():getTexture())
--         -- shadow:setAnchorPoint(cc.p(0,0))
--         shadow:setColor(color or cc.c3b(255,0,100))
--         shadow:setFlippedY(true)
--         shadow:setOpacity(opacity or 255)
--         --得到对象的zOrder，让残影出现的对象的下面
--         node:addChild(shadow,- 1)
--         --残影图片播放动画并删除
--         shadow:runAction(cc.Sequence:create(cc.FadeTo:create(0.01,0),cc.CallFunc:create(function()
--             shadow:removeFromParent()
--         end)))
--     end, time , false)

--     return handler
-- end

-- bole.stopAddShadow = function (nodeHandler)
--     if nodeHandler then 
--         cc.Director:getInstance():getScheduler():unscheduleScriptEntry(nodeHandler)
--     end
-- end


-- 可以同时下载相同的纹理
local update_texture_state = {}
local _updateSameTexture = function(url)
    if not update_texture_state[url] then return end
    local name = update_texture_state[url].name
    if not name or not cc.FileUtils:getInstance():isFileExist(name) then return end

    while true do
        local callback = update_texture_state[url].callback:pop()
        if callback == nil then
            break
        end

        if libUI.isValidNode(callback.sprite) then
            callback.sprite:setTexture(name)
            if callback.func then
                callback.func()
            end
        end
    end
end
bole.downloadSameTexture = function(sprite, url, needlocal, success_func)
    if not url or not sprite then return end

    update_texture_state[url] = update_texture_state[url] or {
        state = "none",
        callback = BoleQueueStack.new(),
    }
    update_texture_state[url].callback:push({
        sprite = sprite,
        func = success_func,
    })
    if update_texture_state[url].state == "start" then
        -- 下载中
    elseif update_texture_state[url].state == "success" then
        -- 已下载
        _updateSameTexture(url)
    else
        -- 未下载或者下载失败
        update_texture_state[url].state = "start"
        HttpRequest:getInstance():downloadFile(url, function (name, isLocal)
            update_texture_state[url].state = "success"
            update_texture_state[url].name = name
            _updateSameTexture(url)
        end, false)
    end
end




local vertShaderByteArray = "\n"..
"attribute vec4 a_position; \n" ..
"attribute vec2 a_texCoord; \n" ..
"attribute vec4 a_color; \n"..
"#ifdef GL_ES  \n"..
"varying lowp vec4 v_fragmentColor;\n"..
"varying mediump vec2 v_texCoord;\n"..
"#else                      \n" ..
"varying vec4 v_fragmentColor; \n" ..
"varying vec2 v_texCoord;  \n"..
"#endif    \n"..
"void main() \n"..
"{\n" ..
"gl_Position = CC_PMatrix * a_position; \n"..
"v_fragmentColor = a_color;\n"..
"v_texCoord = a_texCoord;\n"..
"}"

-- 置灰色
local flagGrayShaderByteArray = "#ifdef GL_ES \n" ..
"precision mediump float; \n" ..
"#endif \n" ..
"varying vec4 v_fragmentColor; \n" ..
"varying vec2 v_texCoord; \n" ..
"void main(void) \n" ..
"{ \n" ..
"vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
"gl_FragColor.xyz = vec3(0.3 * c.r + 0.3 * c.g + 0.3 * c.b); \n"..
"gl_FragColor.w = c.w; \n"..
"}"
-- 置黑色
local flagDarkShaderByteArray = "#ifdef GL_ES \n" ..
"precision mediump float; \n" ..
"#endif \n" ..
"varying vec4 v_fragmentColor; \n" ..
"varying vec2 v_texCoord; \n" ..
"void main(void) \n" ..
"{ \n" ..
"vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
"gl_FragColor.xyz = vec3(0.6*c.r, 0.6*c.g, 0.6*c.b); \n" ..
"gl_FragColor.w = c.w; \n"..
"}"

-- 移除frag  
local pszRemoveShader = "#ifdef GL_ES \n" ..  
"precision mediump float; \n" ..  
"#endif \n" ..  
"varying vec4 v_fragmentColor; \n" ..  
"varying vec2 v_texCoord; \n" ..  
"void main(void) \n" ..  
"{ \n" ..  
"gl_FragColor = texture2D(CC_Texture0, v_texCoord); \n" ..  
"}"   

-- node需要置灰色的节点
-- recover 恢复原本的颜色
-- all 该节点下的所有节点
bole.setGray = function ( node, recover, all )
	if not node then return end
  
    local glProgram = nil

    if recover then
    	glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray,pszRemoveShader)
    else
    	glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray,flagGrayShaderByteArray)	
    end

    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    glProgram:link()
    glProgram:updateUniforms()
    node:setGLProgram( glProgram )

    if all then
    	local children = node:getChildren()
    	for key, value in ipairs(children) do
    		bole.setGray(value, recover, all)
    	end
    end

end
bole.setDark = function ( node, recover, all )
	if not node then return end    

    local glProgram = nil

    if recover then
    	glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray,pszRemoveShader)
    else
    	glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray,flagDarkShaderByteArray)	
    end

    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    glProgram:link()
    glProgram:updateUniforms()
    node:setGLProgram( glProgram )

    if all then
    	local children = node:getChildren()
    	for key, value in ipairs(children) do
    		bole.setDark(value, recover, all)
    	end
    end

end


-- 设置global zorder
bole.setNodeGlobalZOrder = function ( node, zorder )
	if not libUI.isValidNode(node) then return end

	node:setGlobalZOrder(zorder)

    -- 进度条特殊处理
	for i, v in ipairs(node:getChildren()) do
        if v:getName() ~= "progress_bar_tag789" then
            bole.setNodeGlobalZOrder(v, zorder)
        end
	end
end
bole.addTouchEvent = function ( btn, event, obj, param )
    if not libUI.isValidNode(btn) then return end
    
	local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
        	if event then
        		event(obj, unpack(param or {}))
        	end
        end
    end
    btn:addTouchEventListener(btnEvent)
end

bole.addTouchEventZoom = function ( btn, event, obj, param, node )
    if not libUI.isValidNode(btn) then return end

    local scale = 1
    if libUI.isValidNode(node) then
        scale = node:getScaleX()
    end

    if node and libUI.isValidNode(node) then
        node:setCascadeColorEnabled(true)
    end

    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if node and libUI.isValidNode(node) then
                node:setScale(scale * 0.9)
                node:setColor(cc.c3b(200,200,200))
            end
        elseif eventType == ccui.TouchEventType.canceled then
            if node and libUI.isValidNode(node) then
                node:setScale(scale * 1)
                node:setColor(cc.c3b(255,255,255))
            end
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            if node and libUI.isValidNode(node) then
                node:setScale(scale * 1)
                node:setColor(cc.c3b(255,255,255))
            end
            if event then
        		event(obj, unpack(param or {}))
        	end
        end
    end
    btn:addTouchEventListener(btnEvent)
end

FONTS.formatByCount4 = function (num, maxLen, decimal)
    local string_len_list = {}

    if not num then
        return 0
    end    
    -- 只加逗号
    local num_len = string.len(string.format("%d",tonumber(num)))

    string_len_list[1] = {type = 1, value = num_len + (num_len % 3 == 0 and (math.floor(num_len / 3) - 1) or (math.floor(num_len / 3)))}

    -- 逗号+K
    string_len_list[2] = {type = 2, value = (num_len > 3 and (string_len_list[1].value - 3) or 999)}

    -- 逗号+M
    string_len_list[3] = {type = 3, value = (num_len > 6 and (string_len_list[1].value - 7) or 999)}

    -- 逗号+B
    string_len_list[4] = {type = 4, value = (num_len > 9 and (string_len_list[1].value - 11) or 999)}

    -- 逗号+T
    string_len_list[7] = {type = 7, value = (num_len > 12 and (string_len_list[1].value - 15) or 999)}

    -- 逗号+Q
    string_len_list[8] = {type = 8, value = (num_len > 15 and (string_len_list[1].value - 19) or 999)}

    if decimal then
        -- 带一位小数的KMB
        string_len_list[5] = {type = 5, value = (num_len > 3 and ((num_len%3 == 0 and 6 or (num_len % 3 + 3))) or num_len)}

        -- 带两位小数的KMB
        string_len_list[6] = {type = 6, value = (num_len > 3 and ((num_len%3 == 0 and 7 or (num_len % 3 + 4))) or num_len)}
    else
        -- 带一位小数的KMB
        string_len_list[5] = {type = 5, value = 999}

        -- 带两位小数的KMB
        string_len_list[6] = {type = 6, value = 999}
    end

    table.sort( string_len_list, function (a, b) return a.value>b.value end)
    local format_type = 1
    for i=1, #string_len_list do
        if string_len_list[i].value <= maxLen then
            format_type = string_len_list[i].type
            break
        end
    end

    local format_string
    if format_type == 1 then
        format_string = FONTS.format(num, true)

    elseif format_type == 2 then
        local temp_num = num / 1000
        format_string = FONTS.format(temp_num, true).."K"

    elseif format_type == 3 then
        local temp_num = num / 1000000
        format_string = FONTS.format(temp_num, true).."M"

    elseif format_type == 4 then
        local temp_num = num / 1000000000
        format_string = FONTS.format(temp_num, true).."B"
    elseif format_type == 7 then
        local temp_num = num / 1000000000000
        format_string = FONTS.format(temp_num, true).."T"
    elseif format_type == 8 then
        local temp_num = num / 1000000000000000
        format_string = FONTS.format(temp_num, true).."Q"

    elseif format_type == 5 then
        format_string = FONTS.format(num, false, false)
        if string.len(format_string)>maxLen then 
            format_string = string.format("%0.1f", string.match(format_string, "%d+.%d+"))..string.match(format_string, "[^$0-9%.]")
        end

    elseif format_type == 6 then
        format_string = FONTS.format(num, false, false)

    end

    return format_string
end

-- 设置玩家头像
bole.updatePlayerIcon = function ( node, facebook_id, width )
    if node == nil or facebook_id == nil then
        return
    end

    node:removeAllChildren()

    local icon = nil
    if facebook_id == "slotsgames" then
        icon = cc.Sprite:create(User:getInstance():getAvatarPicture())
        icon:setScale(width / 229.0)
    else
        local pic_data = GiftControl:getInstance():getPlayerPicture({facebook_id = facebook_id}, 229, 229)
        icon = LazySprite.new(pic_data.pic[1], cc.size(width, width), "commonpics/icon_common_noavatar.png")
    end

    if icon then
        node:addChild(icon)
    end 
end

-- 设置玩家头像
bole.breathingShake = function (node)
    if bole.isValidNode(node) then
        node:stopActionByTag(100)
        local baseScale = node:getScaleX()
        if node.breathingScale and node.breathingScale == baseScale then 
            return
        else
            node.breathingScale = baseScale
        end
        local action = cc.RepeatForever:create(cc.Sequence:create(
            cc.ScaleTo:create(0.5,baseScale+0.2*baseScale),
            cc.ScaleTo:create(0.5,baseScale),
            cc.ScaleTo:create(0.5,baseScale+0.2*baseScale),
            cc.ScaleTo:create(0.5,baseScale),
            cc.DelayTime:create(1)
            ))
        action:setTag(100)
        node:runAction(action)
    end
                -- cc.ScaleTo:create(0.2,baseScale+0.2*baseScale),
            -- cc.ScaleTo:create(0.2,baseScale),
            -- cc.ScaleTo:create(0.2,baseScale+0.2*baseScale),
            -- cc.ScaleTo:create(0.2,baseScale),
end

-- 
-- bole.isUserGuideOnLobbyShow = function (name)
--     if not name then return false end
--     local lobbyNumber = -1
--     if bole.footer_position_config then
--         for i = 1, #bole.footer_position_config do 
--             if bole.footer_position_config[i] and bole.footer_position_config[i].name and name == bole.footer_position_config[i].name then
--                 lobbyNumber = i
--                 break
--             end
--         end
--     end
--     if lobbyNumber == -1 then
--         return false
--     end

--     -- 高级房和普通房可能不一样
--     local footerIconList = ActivityCenterControl:getInstance():getFooterIconList()
--     -- local isLounge = LobbyControl:getInstance():isLoungeAvailable()
--     -- if isLounge then
--     --     footerIconList = ActivityCenterControl:getInstance():getFooterIconListHigh()
--     -- else
--     --     footerIconList = ActivityCenterControl:getInstance():getFooterIconList()
--     -- end
--     -- 默认第一排只有7个
--     if footerIconList then
--         for i = 1, #footerIconList do
--             if lobbyNumber == footerIconList[i] then
--                 if i <= 7 then
--                     return true
--                 else
--                     return false
--                 end
--             end
--         end
--     end
--     return false
-- end

bole.addTouchEventSpine = function ( btn , touch_end, obj, param )
    if not btn then return end
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- 置灰+缩小
            btn:setColor(cc.c3b(150, 150, 150))
            btn:stopAllActions()
            btn:runAction(cc.ScaleTo:create(0.05, 0.9))
        elseif eventType == ccui.TouchEventType.canceled then
            -- 恢复
            btn:setColor(cc.c3b(255, 255, 255))
            btn:stopAllActions()
            btn:runAction(cc.ScaleTo:create(0.03, 1))
        elseif eventType == ccui.TouchEventType.ended then
            -- 恢复
            btn:setColor(cc.c3b(255, 255, 255))
            btn:stopAllActions()
            btn:runAction(cc.ScaleTo:create(0.03, 1))
            if touch_end then
                touch_end(obj, unpack(param or {}))
            end
        end
    end
    btn:addTouchEventListener(btnEvent)
end

bole.dumpTextures = function()
    if appDebugMode then 
        local sss = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
        local sssArr = bole.splitStr(sss, "\n")
        for k,v in ipairs(sssArr) do
            print("["..k.."]  =  "..v)
        end
    end
end

-- 打印节点下的所有孩子
bole.dumpChildren = function ( node, tag )
    if not libUI.isValidNode(node) then return end
    tag = tag or ""
    print(string.format("%s%s", tag, node:getName()))
    for i, child in ipairs(node:getChildren()) do
        bole.dumpChildren(child, tag.."    ")
    end
end


-- 获取主题的普通房id
bole.getNormalThemeId = function ( themeId )
    local loungeStartId = 600
    local normalStartId = 100
    themeId = (themeId - normalStartId)%(loungeStartId - normalStartId) + normalStartId
    if THEME_LIST and THEME_LIST[themeId] then
        return themeId
    end
end
-- 获取主题的高级房id
bole.getLoungeThemeId = function ( themeId )
    local loungeStartId = 600
    local normalStartId = 100
    themeId = (themeId - normalStartId)%(loungeStartId - normalStartId) + loungeStartId
    if THEME_LIST and THEME_LIST[themeId] then
        return themeId
    end
end

-- 获取主题的普通房id
bole.isNormalThemeId = function ( themeId )
    -- if not themeId then return end
    local extraThemeStartId = 4000
    local loungeStartId = 600

    if themeId > extraThemeStartId then
        if themeId < (extraThemeStartId + loungeStartId) and THEME_LIST and THEME_LIST[themeId] then
            return true
        end
    else
        if themeId < loungeStartId and THEME_LIST and THEME_LIST[themeId] then 
            return true
        end
    end
end

-- 获取主题的高级房id
bole.isLoungeThemeId = function ( themeId )
    local extraThemeStartId = 4000

    local loungeStartId = 600
    if themeId > extraThemeStartId then
        if themeId > (extraThemeStartId + loungeStartId) and THEME_LIST and THEME_LIST[themeId] then
            return true
        end
    else
        if themeId > loungeStartId and THEME_LIST and THEME_LIST[themeId] then 
            return true
        end
    end
end

-- 判断是否是高级房或者低级房主题ID
bole.isBaseThemeId = function ( themeId )
    if themeId and (bole.isNormalThemeId(themeId) or bole.isLoungeThemeId(themeId)) then
        return true
    end
end


bole.getWorldScale = function ( node )
    if not libUI.isValidNode(node) then return 1 end

    local scale = 1
    local parent = node
    while parent ~= nil and parent ~= bole.scene do
        scale = scale * parent:getScaleX()
        parent = parent:getParent() 
    end
    return scale
end


-- 判断新增全局变量
bole.checkGlobalVariable = function ( tag )
	if appDebugMode then
        local init = GlobalNewKeys == nil
        if init then
            GlobalNewKeys = {}
            setmetatable(_G, {
                __index = function(_, key)
                    local info = debug.getinfo(2, "S")
                    if info and info.what ~= "main" and info.what ~= "C" then
                        -- libDebug.warn("GlobalVariable:访问不存在的全局变量：" .. key)
                        -- libDebug.warnTraceback("GlobalVariable")
                    end
                    return rawget(_G, key)
                end,
                __newindex = function(_, key, value)
                    local info = debug.getinfo(2, "S")
                    if info and info.what ~= "main" and info.what ~= "C" then
                        libDebug.warn("GlobalVariable:赋值不存在的全局变量：" .. key)
                        -- libDebug.warnTraceback("GlobalVariable")
                        GlobalNewKeys[key] = true
                    end
                    return rawset(_G, key, value)
                end
            })
        end
		for k, v in pairs(GlobalNewKeys or {}) do
			print("GlobalVariable:新增全局变量", tag, k)
        end
        GlobalNewKeys = {}
	end
end

bole.getDeviceModel = function ()
    if bole._deviceModel then
        return bole._deviceModel
    end
    local device_model = bole.getDeviceInfo(0)
    local _model = "unkown_1"
    if bole.isIOS() then
        if device_model == "i386" or device_model == "x86_64" then  
            _model = "Simulator"
        elseif device_model == "iPhone15,3" then
            _model = "iPhone 14 Pro Max"
        elseif device_model == "iPhone15,2" then
            _model = "iPhone 14 pro"
        elseif device_model == "iPhone14,8" then
            _model = "iPhone 14 Plus"
        elseif device_model == "iPhone14,7" then
            _model = "iPhone 14"
        elseif device_model == "iPhone14,6" then
            _model = "iPhone SE3"
        elseif device_model == "iPhone14,3" then
            _model = "iPhone 13 Pro Max"
        elseif device_model == "iPhone14,2" then
            _model = "iPhone 13 pro"
        elseif device_model == "iPhone14,5" then
            _model = "iPhone 13"
        elseif device_model == "iPhone14,4" then
            _model = "iPhone 13 mini"
        elseif device_model == "iPhone13,4" then
            _model = "iPhone 12 Pro Max"
        elseif device_model == "iPhone13,3" then
            _model = "iPhone 12 Pro"
        elseif device_model == "iPhone13,2" then
            _model = "iPhone 12"
        elseif device_model == "iPhone13,1" then
            _model = "iPhone 12 mini"
        elseif device_model == "iPhone12,8" then
            _model = "iPhone SE2"
        elseif device_model == "iPhone12,5" then
            _model = "iPhone 11 Pro Max"
        elseif device_model == "iPhone12,3" then
            _model = "iPhone 11 Pro"
        elseif device_model == "iPhone12,1" then
            _model = "iPhone 11"
        elseif device_model == "iPhone11,4" or device_model == "iPhone11,6" then
            _model = "iPhone XS Max"
        elseif device_model == "iPhone11,2" then
            _model = "iPhone XS"
        elseif device_model == "iPhone11,8" then
            _model = "iPhone XR"
        elseif device_model == "iPhone10,3" or device_model == "iPhone10,6" then
            _model = "iPhone X"
        elseif device_model == "iPad13,8" or device_model == "iPad13,9" or device_model == "iPad13,10" or device_model == "iPad13,11" then
            _model = "iPad Pro 12.9-inch 5"
        elseif device_model == "iPad8,11" or device_model == "iPad8,12" then
            _model = "iPad Pro 12.9-inch 4"
        elseif device_model == "iPad8,5" or device_model == "iPad8,6" or device_model == "iPad8,7" or device_model == "iPad8,8" then
            _model = "iPad Pro 12.9-inch 3"
        elseif device_model == "iPad7,1" or device_model == "iPad7,2" then
            _model = "iPad Pro 12.9-inch 2"
        elseif device_model == "iPad6,7" or device_model == "iPad6,8" then
            _model = "iPad Pro 12.9-inch"
        elseif device_model == "iPad13,4" or device_model == "iPad13,5" or device_model == "iPad13,6" or device_model == "iPad13,7" then
            _model = "iPad Pro 11-inch 3"
        elseif device_model == "iPad8,9" or device_model == "iPad8,10" then
            _model = "iPad Pro 11-inch 2"
        elseif device_model == "iPad8,1" or device_model == "iPad8,2" or device_model == "iPad8,3" or device_model == "iPad8,4" then
            _model = "iPad Pro 11-inch"
        elseif device_model == "iPad7,3" or device_model == "iPad7,4" then
            _model = "iPad Pro 10.5-inch"
        elseif device_model == "iPad6,3" or device_model == "iPad6,4" then
            _model = "iPad Pro 9.7-inch"
        elseif device_model == "iPad14,1" or device_model == "iPad14,2" then
            _model = "iPad Mini 6"
        elseif device_model == "iPad11,1" or device_model == "iPad11,2" then
            _model = "iPad Mini 5"
        elseif device_model == "iPad5,1" or device_model == "iPad5,2" then
            _model = "iPad Mini 4"
        elseif device_model == "iPad4,7" or device_model == "iPad4,8" or device_model == "iPad4,9" then
            _model = "iPad Mini 3"
        elseif device_model == "iPad4,4" or device_model == "iPad4,5" or device_model == "iPad4,6" then
            _model = "iPad Mini 2"
        elseif device_model == "iPad2,5" or device_model == "iPad2,6" or device_model == "iPad2,7" then
            _model = "iPad Mini"
        elseif device_model == "iPad13,16" or device_model == "iPad13,17" then
            _model = "iPad Air 5"
        elseif device_model == "iPad13,1" or device_model == "iPad13,2" then
            _model = "iPad Air 4"
        elseif device_model == "iPad11,3" or device_model == "iPad11,4" then
            _model = "iPad Air 3"
        elseif device_model == "iPad5,3" or device_model == "iPad5,4" then
            _model = "iPad Air 2"
        elseif device_model == "iPad4,1" or device_model == "iPad4,2"  or device_model == "iPad4,2" then
            _model = "iPad Air"
        elseif device_model == "iPad12,1" or device_model == "iPad12,2" then
            _model = "iPad 9"
        elseif device_model == "iPad11,6" or device_model == "iPad11,7" then
            _model = "iPad 8"
        elseif device_model == "iPad7,11" or device_model == "iPad7,12" then
            _model = "iPad 7"
        elseif device_model == "iPad7,5" or device_model == "iPad7,6" then
            _model = "iPad 6"
        elseif device_model == "iPad6,11" or device_model == "iPad6,12" then
            _model = "iPad 5"
        elseif device_model == "iPad3,4" or device_model == "iPad3,5" or device_model == "iPad3,6" then
            _model = "iPad 4"
        elseif device_model == "iPad3,1" or device_model == "iPad3,2" or device_model == "iPad3,1" then
            _model = "iPad 3"
        elseif device_model == "iPad2,1" or device_model == "iPad2,2" or device_model == "iPad2,3" or device_model == "iPad2,4" then
            _model = "iPad 2"
        elseif device_model == "iPad1,1" then
            _model = "iPad"
        elseif device_model == "iPhone10,1" or device_model == "iPhone10,4" then
            _model = "iPhone 8"
        elseif device_model == "iPhone10,2" or device_model == "iPhone10,5" then
            _model = "iPhone 8 Plus"
        elseif device_model == "iPhone7,1" then
            _model = "iPhone 6 Plus"
        elseif device_model == "iPhone7,2" then
            _model = "iPhone 6"
        elseif device_model == "iPhone8,1" then
            _model = "iPhone 6s"
        elseif device_model == "iPhone8,2" then
            _model = "iPhone 6s Plus"
        elseif device_model == "iPhone8,4" then
            _model = "iPhone SE"
        elseif device_model == "iPhone9,1" then
            _model = "iPhone 7"
        elseif device_model == "iPhone9,2" then
            _model = "iPhone 7 Plus"
        elseif device_model == "iPhone3,1" or device_model == "iPhone3,2" or device_model == "iPhone3,3" then
            _model = "iPhone 4"
        elseif device_model == "iPhone4,1" then
            _model = "iPhone 4S"
        elseif device_model == "iPhone5,1" or device_model == "iPhone5,2" then
            _model = "iPhone 5"
        elseif device_model == "iPhone5,3" or device_model == "iPhone5,4" then
            _model = "iPhone 5c"
        elseif device_model == "iPhone6,1" or device_model == "iPhone6,2" then
            _model = "iPhone 5s"
        elseif device_model == "iPhone1,1" then
            _model =  "iPhone 2G"
        elseif device_model == "iPhone1,2" then
            _model = "iPhone 3G"
        elseif device_model == "iPhone2,1" then
            _model = "iPhone 3GS"
        else
            _model = device_model;
        end
    else
        _model = device_model;
    end
    bole._deviceModel = _model
    return bole._deviceModel
end 

bole.isDynamicIsland = function ()
    if bole.isIOS() then
        -- local model = bole.getDeviceInfo(0)
        local model = bole.getDeviceModel()
        if model and (string.find(model, 'iPhone 14 pro') or string.find(model, 'iPhone 14 Pro Max')) then
            return true
        end
    end
    local  isDynamicIsland = false
    if appDebugMode then
        local saveinfo = cc.UserDefault:getInstance():getIntegerForKey("is_dynamic_island",0)
        if saveinfo and saveinfo == 1 then
            isDynamicIsland = true
        else
            isDynamicIsland = false
        end
        return isDynamicIsland
    end
    return false
end

-- 是否是刘海屏，临时处理
bole.isNotch = function ()
    if bole.isIphoneX() then
        return true
    else
        return FRAME_WIDTH >= FRAME_HEIGHT*2
    end
end
bole.isSocialThemeID = function(theme_id)
    if theme_id == 196 or theme_id == 696 then
        return true
    end
    if TournCashController:getInstance():isInTournCashTheme() then
        return true
    end
    return false
end



-- 加速动画 action 动画对象，mul增加的倍数 ，返回的对象调用stop方法结束加速 appDebugMode
bole.addSpeedAction = function(action , mul) 
    if not bole.isValidNode(action) or not mul then return end
    local funcEntry = nil
    local scheduler = cc.Director:getInstance():getScheduler() 
    local function func(dt)  
        if bole.isValidNode(action) then
            action:step(dt * mul)
        else
            if funcEntry then
                scheduler:unscheduleScriptEntry(funcEntry)
                funcEntry = nil
            end
        end
    end

    funcEntry = scheduler:scheduleScriptFunc(func, 0, false)

    return {
        stop = function ()
            if funcEntry then
                scheduler:unscheduleScriptEntry(funcEntry)
            end
        end
    }
end 

-- 判断一个点是否在多个点组成的多边形区域内
bole.bPointInPolygen = function(posList, posTarget) -- posList:多边形顶点坐标（按照顺时针或逆时针排序）, posTarget:要判断点的坐标 
	-- posList:多边形顶点坐标（按照顺时针或逆时针排序）, posTarget:要判断点的坐标 
    local polygenSides = #posList -- 多边形边数
    local flag = 0 -- 与多边形交点个数
    for i = 1, polygenSides do 
        local Xa, Ya = posList[i].x, posList[i].y -- 首坐标
        local Xb, Yb = posList[i].x, posList[i].y -- 尾坐标
        local Xp, Yp = posTarget.x, posTarget.y -- 目标坐标
        if posList[i + 1] then 
            Xb, Yb = posList[i + 1].x, posList[i + 1].y
        else 
            Xb, Yb = posList[1].x, posList[1].y -- 最后一个点 需要与第一个点连成线段
        end 

        -- 只有以下情况才会相交
        -- 点 与 多边形顶点 重合
        if (Xp == Xa and Yp == Ya) or (Xp == Xb and Yp == Yb) then 
            -- print("点 与 多边形顶点 重合 -----true")
            return true
        end 

        -- 点Y轴 在 线断两端点Y轴 内（外永不相交）
        if (Yp <= Yb and Yp >= Ya) or (Yp >= Yb and Yp <= Ya) then 
            -- 线段上 与 射线 坐标相同的点的 X轴坐标
            local tempX = Xa + (Yp - Ya) * (Xb - Xa) / (Yb - Ya)
            -- print("pointX is ----", tostring(tempX))

            -- 点在多边形的边上
            if Xp == tempX then 
                -- print("点在多边形的边上 -----true")
                return true
            end 
    
            -- 射线穿过多边形的边界
            if Xp > tempX then 
                flag = flag + 1
            end 
        end 
    end 

    -- print("flag, bFlag is ----", tostring(flag))
    if flag % 2 == 0 then 
        return false
    else
        return true
    end 
end

bole.safeCall = function (func , ...) 
    if type(func) == "function" then
        return func(...)
    end
end

--[[
    下划线命名法转换成驼峰命名
]]
bole.underscoreToCamel = function(str)
    if not str or str == "" then
        return 
    end
    local lists = bole.splitStr(str,"_")
    local result = ""
    for key,item in ipairs(lists) do
        result = result..(item:gsub("^%l",string.upper))
    end
    return result
end 