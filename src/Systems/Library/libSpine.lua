libSpine = {}

-- 创建spine
libSpine.createSpine = function ( file )
    if cc.FileUtils:getInstance():isFileExist(file..".json")
    and cc.FileUtils:getInstance():isFileExist(file..".atlas") then
		return sp.SkeletonAnimation:createWithJsonFile(file..".json", file..".atlas", 1)
    end
end

-- 获取slot挂载节点
libSpine.getNodeForSlot = function ( spine, slotName )
    if not libUI.isValidNode(spine) then return end

    if spine.getNodeForSlot then
        return spine:getNodeForSlot(slotName)
    end
end

-- event.loopCount表示循环次数
-- 完成事件
libSpine.listenCompleteEvent = function ( spine, animationName, callback )
    if not libUI.isValidNode(spine) then return end

    spine:registerSpineEventHandler(function (event)
        if event
        and event.animation == animationName then
            if callback then
                callback(event)
            end
        end
    end, sp.EventType.ANIMATION_COMPLETE)
end
-- 用户事件
libSpine.listenUserEvent = function ( spine, animationName, eventName, callback )
    if not libUI.isValidNode(spine) then return end

    libSpine._registUserEvent(spine)
    spine._userEventCb[animationName] = spine._userEventCb[animationName] or {}
    spine._userEventCb[animationName][eventName] = callback
end
libSpine._registUserEvent = function ( spine )
    if not libUI.isValidNode(spine) then return end
    
    if not spine._userEventCb then
        spine._userEventCb = {}
        spine:registerSpineEventHandler(function (event)
            if event then
                local animationName =  event.animation
                local eventName = (event.eventData or {}).name
                if animationName and eventName then
                    local callback = (spine._userEventCb[animationName] or {})[eventName]
                    if callback then
                        callback(event)
                    end
                end
            end
        end, sp.EventType.ANIMATION_EVENT)
    end
end


-- 测试用
libSpine._listenEvent = function ( spine )
    spine:registerSpineEventHandler(function (event)
        libDebug.debugData("libSpine", "ANIMATION_START", event)
    end, sp.EventType.ANIMATION_START)
    spine:registerSpineEventHandler(function (event)
        libDebug.debugData("libSpine", "ANIMATION_INTERRUPT", event)
    end, sp.EventType.ANIMATION_INTERRUPT)
    spine:registerSpineEventHandler(function (event)
        libDebug.debugData("libSpine", "ANIMATION_END", event)
    end, sp.EventType.ANIMATION_END)
    spine:registerSpineEventHandler(function (event)
        libDebug.debugData("libSpine", "ANIMATION_COMPLETE", event)
    end, sp.EventType.ANIMATION_COMPLETE)
    spine:registerSpineEventHandler(function (event)
        libDebug.debugData("libSpine", "ANIMATION_DISPOSE", event)
    end, sp.EventType.ANIMATION_DISPOSE)
    spine:registerSpineEventHandler(function (event)
        libDebug.debugData("libSpine", "ANIMATION_EVENT", event)
    end, sp.EventType.ANIMATION_EVENT)
end