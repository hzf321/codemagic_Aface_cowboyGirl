Display = Display or {}

function Display.cacheFrameAnimation(name, file, startFrame, endFrame, secFrame)
    local interval = 1/secFrame
    local animation = cc.Animation:create()
    local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
    for i = startFrame, endFrame do
        local path = string.format(file, i)
        local spriteFrame = sharedSpriteFrameCache:getSpriteFrame(path)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(interval)
    cc.AnimationCache:getInstance():addAnimation(animation, name)
end

function Display.playFrameAnimationByName(parent, pos, name, blendfunc, isLoop, loopDelay)
    isLoop = isLoop or false
    loopDelay = loopDelay or 0
    pos = pos or cc.p(0, 0)
    local animation = cc.AnimationCache:getInstance():getAnimation(name)
    local sprite = cc.Sprite:create()
    local animate = cc.Animate:create(animation)
    if isLoop then
        sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(
           animate, cc.DelayTime:create(loopDelay))))
    else
        sprite:runAction(cc.Sequence:create(cc.DelayTime:create(loopDelay), animate,
            cc.RemoveSelf:create()))
    end
    if blendfunc then
        sprite:setBlendFunc(blendfunc[1], blendfunc[2])
    end
    sprite:setPosition(pos)
    parent:addChild(sprite)
end

function Display.addFrameAnimation(parent, file, pos, frame, secFrame, isRetain)
    local interval = 1/secFrame
    local sprite = cc.Sprite:create()
    local animation = cc.Animation:create()
    local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
    for i = 1, frame do
        local path = string.format(file, i)
        if string.byte(path) == 35 then
            path  = string.sub(path,2)
            local tempSpriteFrame = sharedSpriteFrameCache:getSpriteFrame(path)
            animation:addSpriteFrame(tempSpriteFrame)
        else 
            animation:addSpriteFrameWithFile(path)
        end
    end
    animation:setDelayPerUnit(interval)
    if not isRetain then
        animation:setLoops(1)
        sprite:runAction(cc.Sequence:create(cc.Animate:create(animation),cc.RemoveSelf:create()))
    else
        sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
    end
    sprite:setPosition(pos)
    parent:addChild(sprite)
    return frame * interval, sprite
end

function Display:addSelfFrameAnimation(parent, file, pos, frame, secFrame, isRetain, blendfunc)
    local interval = 1/secFrame
    local sprite = cc.Sprite:create()
    parent:addChild(sprite)
    sprite:setPosition(pos)
    local actionList = {}
    for i = 1, frame do
        local changeImg = cc.CallFunc:create(function()
                sprite:setTexture(string.format(file, i))
                if blendfunc then
                    sprite:setBlendFunc(blendfunc[1], blendfunc[2])
                end
            end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, changeImg)
        table.insert(actionList, delayTime)
    end
    local delay = frame * interval
    if not isRetain then 
        table.insert(actionList, cc.RemoveSelf:create())
        sprite:runAction(cc.Sequence:create( unpack(actionList) ))
    else
        sprite:runAction(cc.RepeatForever:create(cc.Sequence:create( unpack(actionList))))
    end
    return delay, sprite
end

function Display.playSelfFrameAnimation(sprite, file, pos, frame, fps, isRetain, blendfunc, isNotLoop, loopDelay)
    local interval = 1.0 / fps
    pos = pos or cc.p(sprite:getPosition())
    sprite:setPosition(pos)
    local actionList = {}
    for i = 1, frame do
        local changeImg = cc.CallFunc:create(function()
                sprite:setTexture(string.format(file, i))
                if blendfunc then
                    sprite:setBlendFunc(blendfunc[1], blendfunc[2])
                end
            end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, changeImg)
        table.insert(actionList, delayTime)
    end
    if isRetain then
        -- 默认当isRetain为真的时候循环播放, 当置isNotLoop为真时，则限定只播放一次，而且不释放
        if isNotLoop then 
            sprite:runAction(cc.Sequence:create( unpack(actionList) ))
        else
            if loopDelay then
                table.insert(actionList, cc.DelayTime:create(loopDelay))
            end
            sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(unpack(actionList))))
        end
    else
        table.insert(actionList, cc.RemoveSelf:create())
        sprite:runAction(cc.Sequence:create( unpack(actionList) ))
    end
end

function Display.playSelfAnimation(parent, fileParam, pos, start, frame, fps, isLoop, blendfunc)
    local interval = 1.0 / fps
    local file = fileParam
    local fromSpriteCache = false
    if 'table' == type(fileParam) then
        file = fileParam[1]
        fromSpriteCache = fileParam[2]
    end
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    local actionList = {}
    local sprite = cc.Sprite:create()
    parent:addChild(sprite)
    sprite:setPosition(pos)

    for i = 1, frame do
        local changeImg = cc.CallFunc:create(function()
                if start > frame then
                    start = 1
                end
                if fromSpriteCache then
                    -- can NOT use (not supported in lua) sprite:setTexture(spriteFrameCache:getSpriteFrame(string.format(file, start)):getTexture())
                    sprite:setSpriteFrame(spriteFrameCache:getSpriteFrame(string.format(file, start)))
                else
                    sprite:setTexture(string.format(file, start))
                end
                if blendfunc then
                    sprite:setBlendFunc(blendfunc[1], blendfunc[2])
                end
                start = start + 1
            end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, changeImg)
        table.insert(actionList, delayTime)
    end
    local delay = frame * interval
 
    if not isLoop then 
        sprite:runAction(cc.Sequence:create( unpack(actionList) ))
    else
        sprite:runAction(cc.RepeatForever:create(cc.Sequence:create( unpack(actionList))))
    end
    return delay
end

function Display:actionAnchorYTo(obj, changeAnchorY, time, secFrame )
    local interval = 1.0 / secFrame
    local actionList = {}
    local frame = math.modf(time / interval)
    local baseAnchor = obj:getAnchorPoint()
    local perChangeAnchor = changeAnchorY / frame
    for i = 1, frame do
        local changeAchtion = cc.CallFunc:create(function()
                obj:setAnchorPoint(baseAnchor.x, baseAnchor.y + perChangeAnchor*i)
                -- print("====>"..baseAnchor.y + perChangeAnchor*i)
            end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, delayTime)
        table.insert(actionList, changeAchtion)
    end
    obj:runAction(cc.Sequence:create( unpack(actionList) ))
    return time
end

function Display:actionColorTo(obj, beginColor, engColor, time, secFrame )
    local interval = 1/secFrame
    local actionList = {}
    local frame = math.modf(time/interval)
    beginColor = beginColor or obj:getColor()
    obj:setColor(beginColor)
    local perChangeR = (engColor.r - beginColor.r)/frame
    local perChangeG = (engColor.g - beginColor.g)/frame
    local perChangeB = (engColor.b - beginColor.b)/frame
    for i = 1, frame do
        local changeAchtion = cc.CallFunc:create(function()
            local objColor = cc.c3b(beginColor.r + perChangeR*i,
                                    beginColor.g + perChangeG*i,
                                    beginColor.b + perChangeB*i)
            obj:setColor(objColor)
        end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, delayTime)
        table.insert(actionList, changeAchtion)
    end
    obj:runAction(cc.Sequence:create( unpack(actionList) ))
    return time
end

function Display.getMoveSpeedFadeActionList( curPos, beginSpeed, engSpeed, time, secFrame )
    local interval    = 1/secFrame
    local actionList  = {}
    local frame       = math.modf(time/interval)
    local perChangeSX = (engSpeed.x - beginSpeed.x)/frame
    local perChangeSY = (engSpeed.y - beginSpeed.y)/frame
    local curPosX     = curPos.x
    local curPosY     = curPos.y
    for i = 0, frame do
        local curSpeedX  = beginSpeed.x + perChangeSX*i
        local curSpeedY  = beginSpeed.y + perChangeSY*i
        curPosX = curPosX + curSpeedX*interval
        curPosY = curPosY + curSpeedY*interval
        local curAction  = cc.MoveTo:create(interval, cc.p(curPosX, curPosY))
        table.insert(actionList, curAction)
    end
    local finalPos = cc.p(curPosX, curPosY)
    return actionList, finalPos
end

function Display:getNoRepeatTable(paramTable)
    local retTable = {}
    for _,v in pairs(paramTable) do
        if table.find(retTable, v) == -1 then
            table.insert(retTable, v)
        end
    end
    return retTable
end

Widget = Widget or {}
Widget.newProgress = function(img, scale)
    scale = scale or 1
    local progress = libUI.createProgressTimer(img)
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0,0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setScaleX(scale)
    return progress
end

Widget.newButton = function( callback, img1, img2, img3 ,isPlist) -- true:从plist文件中获取  false:从本地获取资源
    if isPlist then 
        isPlist = 1 
    else
        isPlist = 0
    end
    local function touchEvent( sender, eventType )
        
        if eventType == ccui.TouchEventType.ended then
            if callback then callback(sender, eventType) end     
        end
    end
    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    img2 = img2  or ""
    img3 = img3 or ""
    button:loadTextures(img1,img2, img3,isPlist) --1:从plist文件中获取 0:从本地获取资源
    button:addTouchEventListener(touchEvent)
    return button
end

Widget.LayerColor = cc.c4b(0, 0, 0, 200)

RoundProgress = class("RoundProgress",function ()
    
    return cc.Node:create()
end)

function RoundProgress:ctor(progress, left, right)
    self.progress = progress
    if left then
        self.left = left
        left:setAnchorPoint(cc.p(0,0))
    else self.left = cc.Node:create()
    end
    local ls = self.left:getContentSize()

    local ps = progress:getContentSize()
    self.ps = ps
    self.scale = progress:getScaleX()
    progress:setAnchorPoint(cc.p(0,0))
    progress:setPosition(cc.p(ls.width, 0))

    if right then
        self.right = right
        self.right:setAnchorPoint(cc.p(0,0))
        local dd = ps.width*progress:getPercentage()*self.scale/100
        self.right:setPosition(cc.p(dd+ls.width,0))
    else
        self.right = cc.Node:create()
    end
    local rs = self.right:getContentSize()
    self:setContentSize(cc.size(ls.width+ps.width*self.scale+rs.width, ps.height))
    self:addChild(self.left)
    self:addChild(progress)
    self:addChild(self.right)
end

function RoundProgress:setPercent( p, duration)
    
    duration = duration or 0.5
    -- self.progress:setPercentage(p)
    self.progress:stopAllActions()
    self.right:stopAllActions()
    if p > 100 then
        p = p%100
    end
    local to = cc.ProgressTo:create(duration, p)
    self.progress:runAction(to)
    -- self.right:setPosition(cc.p(p*self.ps.width*self.scale/100, 0))
    local move = cc.MoveTo:create(duration, cc.p(p*self.ps.width*self.scale/100, 0))
    self.right:runAction(move)
end

function RoundProgress:getPercent( )
    return self.progress:getPercentage()
end

function RoundProgress:fadeOut( duration )
    self.progress:runAction(cc.FadeOut:create(duration))
    self.left:runAction(cc.FadeOut:create(duration))
    self.right:runAction(cc.FadeOut:create(duration))
end


Widget = Widget or {}
Widget.VerticalProgress = function(img, scale)
    scale = scale or 1
    local progress = libUI.createProgressTimer(img)
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0,0))
    progress:setBarChangeRate(cc.p(0, 1))
    progress:setScaleY(scale)
    return progress
end


VerticalRoundProgress = class("VerticalRoundProgress",function ()
    
    return cc.Node:create()
end)

function VerticalRoundProgress:ctor(progress, down, up)
    self.progress = progress
    if down then
        self.down = down
        down:setAnchorPoint(cc.p(0,0))
    else 
        self.down = cc.Node:create()
    end
    local ls = self.down:getContentSize()
    local ps = progress:getContentSize()
    self.ps = ps
    self.scale = progress:getScaleY()
    progress:setAnchorPoint(cc.p(0,0))
    progress:setPosition(cc.p(0, ls.height))

    if up then
        self.up = up
        self.up:setAnchorPoint(cc.p(0,0))
        local dd = ps.height*progress:getPercentage()*self.scale/100
        self.up:setPosition(cc.p(0, dd+ls.height))
    else
        self.up = cc.Node:create()
    end
    local rs = self.up:getContentSize()
    self:setContentSize(cc.size(ps.width, ls.height+ps.height*self.scale+rs.height))
    self:addChild(self.down)
    self:addChild(progress)
    self:addChild(self.up)
end

function VerticalRoundProgress:setPercent( p, duration)
    
    duration = duration or 0
    self.progress:stopAllActions()
    self.up:stopAllActions()
    if p > 100 then
        p = p%100
    end
    local to = cc.ProgressTo:create(duration, p)
    self.progress:runAction(to)
    local move = cc.MoveTo:create(duration, cc.p(0, p*self.ps.height*self.scale/100))
    self.up:runAction(move)
end

function VerticalRoundProgress:getPercent( )
    return self.progress:getPercentage()
end

------------------

Dialog = class("Dialog", function()
    
    return cc.LayerColor:create(Widget.LayerColor)
end)

function Dialog:ctor(txt,click,btn)
    
    -- self.label = cc.Label:createWithSystemFont(txt, "Arial", 30)
    self.label = cc.MenuItemFont:create(txt)
    if not btn then btn = "OK" end
    self.btn = cc.MenuItemFont:create(btn)
    self.event = click
    local function btnClicked(sender) 
        self:hide(sender)
    end
    self.btn:registerScriptTapHandler(btnClicked)

    local  menu = cc.Menu:create()
    self.menu = menu
    local border = 30
    local s1 = self.label:getContentSize()
    local s2 = self.btn:getContentSize()
    local s = cc.size(s1.width+border, s1.height+s2.height+border)
    menu:setContentSize(s)
    menu:setPosition(cc.p(s.width/2,s.height/2))
   
    menu:addChild(self.label)
    menu:addChild(self.btn)
    menu:alignItemsVertically()
    self:setContentSize(s)
    local win = cc.Director:getInstance():getWinSize()
    self:setPosition(cc.p(win.width/2-s.width/2, win.height/2-s.height/2))
    self:addChild(menu)
end

function Dialog:setBtn( c )
    
    self.btn:setString(c)
end

function Dialog:show( ... )
    
    local scene = cc.Director:getInstance():getRunningScene()
    scene:addChild(self)
end


function Dialog:hide( sender )
    
    if self.event then
        self.event()
        self.event = nil
    end
    self:removeFromParent()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

--------------------

Scene = class("Scene", function() return cc.Scene:create() end)

function Scene:ctor()
	local function onNodeEvent(event)
		if event == "enter" then
			self:onEnter()
		elseif event == "exit" then
			self:onExit()
        elseif event == "enterTransitionFinish" then
            self:onTransitionFinish()
		end
	end

	self.__layer = cc.Node:create()
    self.__layer:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
    -- self.__layer:setPosition(0,0)
	self:addChild(self.__layer)
	self.__layer:registerScriptHandler(onNodeEvent)

end

function Scene:addNode( node, zorder )
    zorder = zorder or 0
    self.__layer:addChild(node, zorder)
end

function Scene:onTouchEvent(touches, event, eventType)
	local et = event:getType()
	local target = event:getCurrentTarget()
	return true
end

function Scene:onTransitionFinish( ... )

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function Scene:onEnter()
    -- AudioControl:onSceneSwitch()
    
    local function onTouchBegan( touch, event )
    	return self:onTouchEvent(touch, event, cc.Handler.EVENT_TOUCHES_BEGAN)
    	
    end
    local function onTouchMoved( touch, event )
    	return self:onTouchEvent(touch, event, cc.Handler.EVENT_TOUCH_MOVED)
    	
    end
    local function onTouchEnded(touch, event)
    	return self:onTouchEvent(touch, event, cc.Handler.EVENT_TOUCHES_ENDED)
    end
    local function onTouchCancelled(touch, event)
    	return self:onTouchEvent(touch, event, cc.Handler.EVENT_TOUCH_CANCELLED)
    end
    
    self._touchListener = nil
    local listener = cc.EventListenerTouchOneByOne:create()
    --listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
   	listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self.__layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.__layer)
    self._touchListener = listener

    bole.scene = self
end

function Scene:onExit()
    TimerCallFunc:getInstance():clearGroup(self)
end

function Scene:push( ... )
    
    cc.Director:getInstance():pushScene( self )
end

function Scene:pop( ... )
    
    cc.Director:getInstance():popScene()
end

function Scene:run()
    local director = cc.Director:getInstance()
	if director:getRunningScene() then
		director:replaceScene(self)
	else
		director:runWithScene(self)
	end
end


function Scene:onPause( ... )
    
end
function Scene:onResume( ... )
    
end

-----------
-- < @brief
-- < sameIndex | facebook头像有冲突加监听
-----------
LazySprite = class("LazySprite", function() return cc.Sprite:create() end)

function LazySprite:ctor( url, size, default , sameIndex)
    self.size = size
    self.default = default
    self.sameIndex = sameIndex or 1
    if url then
        self:setUrl(url)
    elseif default then
        self:updateTexture(default, size)
    end
    self:listenEvent()
end

function LazySprite:listenEvent()
    EventCenter:registerEvent(EVENTNAMES.LAZY_SPRITE.REFRESH_FB_ICON_ALL, (self.url or "") .. self.sameIndex, function (headle, data)
        if not libUI.isValidNode(self) then return end
        data            = data or {}
        local name      = data.name
        local isLocal   = data.isLocal
        local sameIndex = data.sameIndex
        local url       = data.url
        if name and (isLocal or self:isRunning()) and sameIndex and sameIndex ~= self.sameIndex and url == self.url then
            self:updateTexture(name, self.size)
        end
    end)
end

function LazySprite:setUrl( url )
    
    if url ~= self.url then
        if self.default then
            self:updateTexture(self.default, self.size)
        end
        self.url = url
        local function downloadFinished(name, isLocal)
            if self.url == url and (isLocal or self:isRunning()) then
                self:updateTexture(name, self.size)
                EventCenter:pushEvent(EVENTNAMES.LAZY_SPRITE.REFRESH_FB_ICON_ALL, {name = name, isLocal = isLocal, sameIndex = self.sameIndex, url = self.url})
                User:getInstance():addUserAvatarData(self.url)
            end
        end
        if url then
            
            local force = LoginControl:getInstance():isFbIconForceDownload(url)

            if force then
                local save_name = bole.hash(url)
                local abPath = cc.FileUtils:getInstance():fullPathForFilename(save_name)
                local isExist = cc.FileUtils:getInstance():isFileExist(abPath)
                if isExist then
                    local size = cc.FileUtils:getInstance():getFileSize(abPath)
                    if size > 10 then
                        self:updateTexture(save_name, self.size)
                    end
                end
            end

            HttpRequest:getInstance():downloadFile(url, downloadFinished, force)
        end
    end
end

function LazySprite:updateTexture( tex, size )

    --self:setTexture(tex)
    bole.updateSpriteWithFile(self,tex)
    if size then
        local ss = self:getContentSize()
        if ss.width > 0 then self:setScaleX(size.width/ss.width) end
        if ss.height > 0 then self:setScaleY(size.height/ss.height) end
    end
end

bole.createMaskFromSprite = function (sp)
    local sz = sp:getContentSize()
    local vex = {cc.p(0,0), cc.p(sz.width,0), cc.p(sz.width,sz.height), cc.p(0,sz.height)}
    local mask = cc.DrawNode:create()
    mask:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
    mask:setPosition(-sz.width * 0.5, -sz.height * 0.5)
    local clone = cc.Sprite:createWithSpriteFrame(sp:getSpriteFrame())
    local clip = cc.ClippingNode:create(clone)
    clip:setInverted(true)
    clip:addChild(mask)
    clip:setScaleX(sp:getScaleX())
    clip:setScaleY(sp:getScaleY())
    return clip
end

