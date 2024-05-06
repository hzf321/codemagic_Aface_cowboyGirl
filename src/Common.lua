local file = cc.FileUtils:getInstance()
local cplatform = cc.Application:getInstance():getTargetPlatform()
if false then
    Config = file:getValueMapFromFile("config_ios.plist")
else
    -- Config = file:getValueMapFromFile("config.plist")
	Config = {
		version = "1.00",
		versionCode = 100,
		platform = "android"
	}
end

LOGLEVEL = {
	DEBUG 	= 0,
	INFO	= 1,
	WARNING	= 2,
	ERROR 	= 3,
}

bole.hallAdNum = 0
bole.hallAdState = {
	level_5 = 0,
	level_10 = 0,
	level_15 = 0,
}

TimerCallFunc = class("TimerCallFunc")
function TimerCallFunc:ctor()
	self.maps = {}
	self._instance = nil
end

function TimerCallFunc:getInstance( ... )
	
	if not self._instance then
		self._instance = TimerCallFunc.new()
	end
	return self._instance
end

function inherit( sub, base )
	if type(base) == "table" then
		for k,v in pairs(base) do
			if sub[k] == nil then
				sub[k] = v
			end
		end
	end  
end

function TimerCallFunc:addCallFunc(func, delay, param, group )
	
	group = group or bole.scene
	if not group then return end
	self.maps[group] =  self.maps[group] or {}
	if func and not self.maps[group][func] then
		local function append()
			if self.maps[group] then
				self:unscheduleFunc(func, group)
				func(param)
			end
		end
		local scheduler = cc.Director:getInstance():getScheduler()
		local entry = scheduler:scheduleScriptFunc(append, delay, false)
		self.maps[group][func] = entry
	end	
end

function TimerCallFunc:clearGroup(group)
	self.maps[group] = nil
end

function TimerCallFunc:unscheduleFunc(func , group)
	
	group = group or bole.scene
	if self.maps[group] and self.maps[group][func] then
		local scheduler = cc.Director:getInstance():getScheduler()
		scheduler:unscheduleScriptEntry(self.maps[group][func])
		self.maps[group][func] = nil
	end
end

function TimerCallFunc:unscheduleGroup(group)
	group = group or bole.scene
	local funcs = self.maps[group]
	if funcs then
		local scheduler = cc.Director:getInstance():getScheduler()
		for func,entry in pairs(funcs) do
			if entry then
				scheduler:unscheduleScriptEntry(entry)
			end
		end 
		self.maps[group] = nil
	end
end

bole.showTips = function(tip)
	if bole.scene then
		local bg_tip = cc.Sprite:create("commonpics/bg_tip.png")
		-- local lab = libUI.createFont(bg_tip, "commonfonts/paytable_commonfont01.fnt", cc.p(232.5, 26.5), 0.7, 0)
		local lab = cc.Label:createWithSystemFont(tip or "", "Arial", 24)
		bg_tip:addChild(lab)
		lab:setPosition(232.5, 30)
		bg_tip:setCascadeOpacityEnabled(true)
		bole.scene:addChild(bg_tip, 9999)

		if ScreenControl:getInstance().isPortrait then
			bg_tip:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
		else
			bg_tip:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
		end

		bg_tip:runAction(cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.FadeOut:create(0.2),
			cc.CallFunc:create(
				function ()
					bg_tip:removeFromParent()
				end
			)
		))
	end
end

bole.getDistance = function ( p1, p2 )
    return math.sqrt(math.pow(p1.x - p2.x, 2) + math.pow(p1.y - p2.y, 2))
end

bole.int2String = function( number )
	if type(number) ~= "number" then
		return number
	end
	local MAX_DIGIT = 10000000000000
	if number > MAX_DIGIT then
		local a = tostring(math.floor(number/MAX_DIGIT))
		local b = tostring(MAX_DIGIT + number%MAX_DIGIT)
		return a..b:sub(2, #b)
	else
		return tostring(number)
	end
end


bole.stopAllActions = function (node)
	node:stopAllActions()
	for _,v in pairs(node:getChildren()) do
		if not (v.stopTag and v.stopTag == "ignore") then
			bole.stopAllActions(v)
		end
	end
end
bole.addAnimationSimple = function(data)
    local parent = data.parent
    local zOrder = data.zOrder or 0
    local file = data.file
    local pos = data.pos or cc.p(0, 0)
    local animateName = data.animateName or "animation"
    local completeCallback = data.completeCallback
    local callbackDelay = data.callbackDelay
    local returnDelay = data.returnDelay
    local isLoop = data.isLoop or false
    local isRetain = data.isRetain or isLoop
    local timeScale = data.timeScale or 1
    local _, s = bole.addSpineAnimationInTheme(parent, zOrder, file, pos, animateName, completeCallback, callbackDelay, returnDelay, isRetain, isLoop, timeScale)
    return _, s
end

bole.addSpineAnimation = function(parent, zOrder, file, pos, animateName, completeCallback, callbackDelay, returnDelay, isRetain, isLoop, timeScale)
	local delay = returnDelay or 0
	callbackDelay = callbackDelay or 0
	zOrder = zOrder or 0
	if cc.FileUtils:getInstance():isFileExist(file..".json") then
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
			print("Spine not exist ",file)
			print(a.b)
		end
		return 0, nil
	end

end

-- 更改动画播放
bole.spChangeAnimation = function(node,animation,isLoop)
	node:setToSetupPose()
	node:setAnimation(0,animation,isLoop)
end

bole.toNodePos = function ( myNode, referenceNode, checkPos )
	local pos = referenceNode:getParent():convertToWorldSpace(bole.getPos(referenceNode))
	pos = myNode:convertToNodeSpace(pos)
	if checkPos then
		pos = cc.pAdd(pos, checkPos)
	end
	return pos
end

bole.changeParent = function ( myNode, newParent, zorder)
    myNode:retain()
	myNode:removeFromParent(false)
	newParent:addChild(myNode, zorder or 0)
	myNode:release()
end

function getAngle(p1, p2)
	return math.atan((p2.y - p1.y) / (p2.x - p1.x))
end

 

ANIMATE = ANIMATE or {}
ANIMATE.bezier_back = function(parent, from, to, count,duration)
-- 渐隐出现金币的 飞金币特效 金币图片固定（参数：父节点，起始位置，结束位置，金币个数，飞行时间）
	for i = 1,count do
		local s = cc.Sprite:create("coin.png")
		s:setOpacity(0)
		local ss = math.random(5,6)
		s:setScale(ss/10)
		s:setPosition(cc.p(from.x, from.y+20))
		-- s:setPosition(cc.p())
		parent:addChild(s)
	    local function myBezier( from, to, duration )
	    	
	    	local sx = math.abs(to.x-from.x)
	    	local sy = math.abs(to.y-from.y)
	    	local dd = 0.5
	    	local bezier = {
		        cc.p(dd*sx, (2*dd*sy+80)*math.random(7,11)/10),
		        cc.p(2.4*dd*sx,  -80), --cc.p(2.4*dd*sx,  -sy/4),
		        to
	    	}	
	    	local bezier = cc.BezierTo:create(duration, bezier)
	    	return bezier
	    end
		-- s:runAction(cc.Sequence:create(cc.FadeIn:create(0.2), cc.BezierBy:create(bezierForward)))
		s:runAction(cc.Sequence:create(cc.DelayTime:create(0.1*i),cc.FadeIn:create(0.2) , myBezier(from,to, duration), cc.CallFunc:create(function() s:removeFromParent() end)))
	end
end

-- 渐隐出现金币的 飞金币特效 金币图片可修改（参数：父节点，起始位置，结束位置，金币个数，飞行时间，action使用节点，图片路径，缩放，费金币间隔时间，自定义动画（除了飞行之外的））
ANIMATE.bezier = function(parent, from, to, count, duration, target, textureName, scale, interval, customAction)
	interval = interval or duration/count
	local delay = 0
	textureName = textureName or "coin.png"
	scale = scale or 1
	for i = 1,count do
		local s = cc.Sprite:create(textureName)
		s:setOpacity(0)
		local ss = math.random(4,7)
		s:setScale(ss/10 * scale)
		s:setPosition(from)
		parent:addChild(s)
	    
		local function getBezierControlPoints( s, e, d, points )
			
			local d1 = bole.getDistance(s,e)
			if d1 < 120 then
				return {bole.getMidPoint(s,e, 0.3),bole.getMidPoint(s,e, 0.7),e}
			end

			local d = 302.01490029467
			local points = {{{a=-0.32984566595158,d=228.03727765433},{a=0.23561414529594,d=201.09947787103}}, 
							{{a=-0.3369014494818,d=176.51062290978},{a=0.3064792571689,d=225.85836269662}}}
							-- {{a=0.36799690490918,d=148.94660116968},{a=-0.19817926801881,d=192.14601218865}}}
			points = points[math.random(1,2)]
			local a1 = getAngle(s,e)
			d1 = d1 / d
			local bezier = {e}
			for k,p in pairs(points) do
				local a = a1 + p.a
				local d2 = d1 * p.d
				local offx = d2 * math.cos(a)
				local offy = d2 * math.sin(a)
				if s.x > e.x then
					offy = -offy
					offx = -offx
				end

				local point = cc.p(s.x + offx, s.y + offy)
				table.insert(bezier, k , point)
			end
			return bezier
		end


		delay = delay + interval*math.random(3,10)/10
		s:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.FadeIn:create(0) , cc.BezierTo:create(duration, getBezierControlPoints(from, to)), cc.RemoveSelf:create()))
		
		local a = nil
		if customAction then 
			a = cc.Sequence:create( cc.DelayTime:create(duration + delay - 0.4), customAction)  --, cc.ScaleTo:create(d, 1) 
		else
			a = cc.Sequence:create( cc.DelayTime:create(duration + delay - 0.4), cc.ScaleBy:create(0.2, 1.2))  --, cc.ScaleTo:create(d, 1) 
		end
		s:runAction(a)
		
		if target then	
			local d = 0.05
			local a = cc.Sequence:create(cc.DelayTime:create(duration + delay - 0.1), cc.ScaleTo:create(d, 1.2), cc.ScaleTo:create(d, 1))
			target:runAction(a)
		end
	end
	return delay + duration
end

ANIMATE.bezierForNewCoins = function(parent, from, to, count, duration, target, textureName, scale, interval, customAction, addTextureSpine)
	interval = interval or duration/count
	local delay = 0
	scale = scale or 1
	local objScale = 0.32
	for i = 1, count do
		delay = delay + interval*math.random(3,10)/10	 	
  		-- function Display.playSelfAnimation(parent, file, pos, start, frame, secFrame, isLoop, blendfunc)
		local function getBezierControlPoints( s, e, d, points )
			local d1 = bole.getDistance(s,e)
			if d1 < 120 then
				return {bole.getMidPoint(s,e, 0.3),bole.getMidPoint(s,e, 0.7),e}
			end

			local d = 302.01490029467
			local points = {{{a=-0.32984566595158,d=228.03727765433},{a=0.23561414529594,d=201.09947787103}}, 
							{{a=-0.3369014494818,d=176.51062290978},{a=0.3064792571689,d=225.85836269662}}}
							-- {{a=0.36799690490918,d=148.94660116968},{a=-0.19817926801881,d=192.14601218865}}}
			points = points[1] -- points[math.random(1,2)]
			local a1 = getAngle(s,e)
			d1 = d1 / d
			local bezier = {e}
			for k,p in pairs(points) do
				local a = a1 + p.a
				local d2 = d1 * p.d
				local offx = d2 * math.cos(a)
				local offy = d2 * math.sin(a)
				if s.x > e.x then
					offy = -offy
					offx = -offx
				end

				local point = cc.p(s.x + offx, s.y + offy)
				table.insert(bezier, k , point)
			end
			return bezier
		end
		parent:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
	  		local startFrame = math.random(1,23)
			local s 		 = cc.Sprite:create()
			s:setOpacity(0)

			if addTextureSpine then
				addTextureSpine(s, i)
			end

			Display.playSelfAnimation(s, textureName, cc.p(0,0), startFrame, 1, 1, true)

			bole.setEnableRecursiveCascading(s, true)

			local angle = math.random(0,360)
			local ss 	= 10 -- math.random(9,11)
			s:setRotation(angle)
			s:setScale(ss/10 * scale)
			s:setPosition(from)
			parent:addChild(s)

			local addDelay    = 0
			local actionSpawn = cc.Spawn:create(cc.BezierTo:create(duration, getBezierControlPoints(from, to)), cc.ScaleTo:create(duration, objScale))
			s:runAction(cc.Sequence:create(cc.DelayTime:create(addDelay), cc.FadeIn:create(0), actionSpawn, cc.RemoveSelf:create()))
			local a = nil
			if customAction then 
				a = cc.Sequence:create(cc.DelayTime:create(duration + addDelay - 0.4), customAction) -- cc.ScaleTo:create(d, 1) 
			else
				a = cc.Sequence:create(cc.DelayTime:create(duration + addDelay - 0.4), cc.ScaleBy:create(0.2, 1.2)) -- cc.ScaleTo:create(d, 1) 
			end
			s:runAction(a)
			if target then	
				local d = 0.05
				local a = cc.Sequence:create(cc.DelayTime:create(duration + addDelay - 0.1), cc.ScaleTo:create(d, 1.2), cc.ScaleTo:create(d, 1))
				target:runAction(a)
			end
		end)))
	end
	return delay + duration
end


-- 函数描述：为obj控件指定bezier曲线移动
-- 参数描述：obj:执行该动作的控件， from:动作执行的起始位置，to:动作执行的目标位置， 整个飘动动作的持续时间， 
-- 		   beginInterval:从调用到开始执行飘动动作的间隔时间， callFun:执行完动作后的回调, showAction:obj进去默认不显示，而该参数未出现动作
-- 注意点：obj在函数中非默认释放，如果需要释放，请自行在回调函数中执行
ANIMATE.bezierAction = function( obj, from, to, duration, beginInterval, callFunc, showAction )
	showAction = showAction or cc.Show:create()
	beginInterval = beginInterval or 0
	duration = duration or 1
	obj:setPosition(from)
	obj:setVisible(false)
	local function getBezierControlPoints( s, e, d, points )
		
		local d1 = bole.getDistance(s,e)
		if d1 < 120 then
			return {bole.getMidPoint(s,e, 0.3),bole.getMidPoint(s,e, 0.7),e}
		end

		local d = 302.01490029467
		local points = {{{a=-0.32984566595158,d=228.03727765433},{a=0.23561414529594,d=201.09947787103}}, 
						{{a=-0.3369014494818,d=176.51062290978},{a=0.3064792571689,d=225.85836269662}}}
						-- {{a=0.36799690490918,d=148.94660116968},{a=-0.19817926801881,d=192.14601218865}}}
		points = points[math.random(1,2)]
		local a1 = getAngle(s,e)
		d1 = d1 / d
		local bezier = {e}
		for k,p in pairs(points) do
			local a = a1 + p.a
			local d2 = d1 * p.d
			local offx = d2 * math.cos(a)
			local offy = d2 * math.sin(a)
			if s.x > e.x then
				offy = -offy
				offx = -offx
			end

			local point = cc.p(s.x + offx, s.y + offy)
			table.insert(bezier, k , point)
		end
		return bezier
	end
	obj:runAction(cc.Sequence:create(
			cc.DelayTime:create(beginInterval), 
			showAction, 
			cc.BezierTo:create(duration, getBezierControlPoints(from, to)),
			cc.CallFunc:create(function( )
				if callFunc then
					callFunc()
				end
			end)
		)
	)
	return beginInterval + duration
end

ANIMATE.moveAction = function( obj, from, to, duration, beginInterval, callFunc, showAction )
	showAction = showAction or cc.Show:create()
	beginInterval = beginInterval or 0
	duration = duration or 1
	obj:setPosition(from)
	obj:setVisible(false)
	obj:runAction(cc.Sequence:create(
			cc.DelayTime:create(beginInterval), 
			showAction, 
			cc.MoveTo:create(duration, to),
			cc.CallFunc:create(function( )
				if callFunc then
					callFunc()
				end
			end)
		)
	)
	return beginInterval + duration
end



------------------------------ 字體 ------------------------------

FONTS = FONTS or {}
FONTS_WINDOWS = {[1]={"Trebuchet MS",18,cc.c3b(139,83,5)}, [2]={"Arial Black", 19}, [3]={"Arial Black",24,cc.c3b(87,27,0)},
				[4]={"Arial",19,cc.c3b(246,227,160)},[5]={"Arial Black",30,cc.c3b(246,227,160)}, [7]={"Trebuchet MS",12,cc.c3b(80,0,0)}, 
				[10]={"Symbol",40,cc.c3b(255,245,88)}, [26]={"Tahoma",17,cc.c3b(255,84,237)}}
FONTS.dsize = 18
FONTS.getSysFont = function( ... )
	local fname = nil
	if bole.isIOS() then
		fname = "Arial-BoldMT"
	elseif bole.isAmazon() then
		fname = "Arial"
	elseif bole.isAndroid() then
		fname = "Droid Serif"
	end
	return fname
end

FONTS.new = function (i, txt, size)
	
	if not txt then txt = "" end

	local fname = nil
	if type(i) == "number" then
		-- fname = string.format(COMMON_FONTS_PATH.."ziti%02d.fnt", i)
		print("FONTS.new not find commonfonts number ziti")
	else
		fname = i
	end
	if i == "sys" then
		fname = FONTS.getSysFont()
		local l = cc.Label:createWithSystemFont(txt, fname, size)
		return l
	end

	if string.find(fname,".fnt") then
		if not cc.FileUtils:getInstance():isFileExist(fname) then
			if appDebugMode then
				error("[error]: not find fnt "..fname)
			else
				return cc.Label:createWithSystemFont(txt, "Arial", 30)
			end
		end
		local l =  cc.Label:createWithBMFont(fname, txt)
		return l
	end
	if not size then size = FONTS.dsize end
	if not cc.FileUtils:getInstance():isFileExist(fname) then
		if appDebugMode then
			error("[error]: not find ttf "..fname)
		else
			return cc.Label:createWithSystemFont(txt, "Arial", 30)
		end
	end
	return cc.Label:createWithTTF(txt, fname, size)
end

FONTS.format = function(n, all, decimal, bRound) -- 参数: 数字 是否全部显示 是否保留小数 保留小数的位数 (控制文字显示k,M 和保留小数的位数,带"," ".")
	-- local i, j, int = tostring(n):find('(%d+)')
  	if not all then
		local int,i = bole.int2String(n):reverse():gsub("(%d%d%d)", "%1,")
	  	local ret,j =  int:reverse():gsub("^,", "")  		
  		i = math.min(5, i-j)
		local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000000,"M"},[3]={1000000000,"B"},[4]={1000000000000,"T"},[5]= {1000000000000000,"Q"}}
  		-- local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000000,"M"},[3]={1e+9,"B"},[4]={1e+12,"T"},[5]= {1e+15,"Q"}}
  		if decimal then
  			ret = (string.format("%0.2f", n/tt[i][1]))..tt[i][2]
  		else
  			if not bRound or 'number' == type(bRound) then
				local numFraction = 2
				if 'number' == type(bRound) then -- max digits
					local intPart = math.floor(n / tt[i][1])
					local numDigitInt = intPart > 99 and 3 or (intPart >= 9 and 2 or 1)
					numFraction = (bRound - numDigitInt > 0) and bRound - numDigitInt or 0
	  			end
  				ret = bole.int2String(tonumber(string.format("%0." .. numFraction .. "f", n/tt[i][1])))..tt[i][2]
  			else -- true == bRound
  				ret = bole.int2String(math.floor(n / tt[i][1])) .. tt[i][2]
  			end
  		end
  		return ret
  	else
  		local addString = ""
  		if decimal and n~=0 then
  			addString = string.sub(string.format("%d", n%1), 2)  			
  		end
  		n = math.floor(n)
  		local int,i 		= bole.int2String(n):reverse():gsub("(%d%d%d)", "%1,")
	  	local ret,j 		=  int:reverse():gsub("^,", "")  
	  	ret = ret..addString
  		return ret
  	end  	
end
	
FONTS.format_decimal = function(n)
	-- local i, j, int = tostring(n):find('(%d+)')
	local ret = (string.format("%0.2f", n))
  	return ret
end

FONTS.format2 = function(n)
	-- local i, j, int = tostring(n):find('(%d+)')
	local int,i = bole.int2String(n):reverse():gsub("(%d%d%d)", "%1,")
  	local ret,j =  int:reverse():gsub("^,", "")
	i = math.min(3, i-j)
	local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000000,"M"},[3]={1000000000,"B"}}
	return bole.int2String(tonumber(string.format("%0.2f", n/tt[i][1]))), tt[i][2]
end

FONTS.formatByCount = function (n, count) -- 参数1: 数值, 参数2: 多少位之后显示KMB(这个位数显示包括显示出来的"," "K" "M" "B" 都是占一位的)
	local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000,"M"},[3]={1000,"B"},[4]={1000,"T"},[5]={1000,"Q"}} -- 在上一级的基础上 除以 第一个值
	local i=0
	local suffix = tt[i][2]
	while string.len(FONTS.format(n,true)..suffix) >count do 
		i = i+1
		n = n / tt[i][1]
		suffix = tt[i][2]
	end
	return FONTS.format(n, true) .. suffix
end

FONTS.formatByCount2 = function (num, maxLen, decimal)
    local string_len_list = {}

    -- 只加逗号
    local num_len = string.len(tostring(num))

    string_len_list[1] = {type = 1, value = num_len + (num_len % 3 == 0 and (num_len / 3 - 1) or (num_len / 3))}

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
        format_string = FONTS.format(num, false, false, 2)

    elseif format_type == 6 then
        format_string = FONTS.format(num, false, false)

    end

    return format_string
end

-- 这个格式是不带 "," 及 "." 而且 没有 小数
FONTS.formatByCount3 = function (n, count) -- 参数1: 数值, 参数2: 多少位之后显示KMB(这个位数显示包括显示出来的"K" "M" "B" 都是占一位的)
	local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000,"M"},[3]={1000,"B"},[4]={1000,"T"},[5]={1000,"Q"}} -- 在上一级的基础上 除以 第一个值
	local i=0
	local suffix = tt[i][2]
	while string.len(math.floor(n)..suffix) >count do 
		i = i+1		
		n = n / tt[i][1]
		suffix = tt[i][2]
	end
	n = math.floor(n)
	return n..suffix
end
---@param num 原始数字
---@param maxLen 最大长度
---@param decimal 是否显示小数位
---@param isRound 是否向下取整
FONTS.formatByCount4 = function (num, maxLen, decimal,isRoundDown)
    local string_len_list = {}

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
			local str1 = 	string.match(format_string, "%d+.%d+")
			local str2 =    string.match(format_string, "[^$0-9%.]")
			if not isRoundDown then
				str1 = string.format("%0.1f",str1)
				if math.floor(str1)-str1 == 0 then -- 如果小数位只有0 则只显示整数位
					str1 = math.floor(str1)
				end
			else
				if math.floor(str1)-str1 == 0 then -- 如果小数位只有0 则只显示整数位
					str1 = math.floor(str1)
				else
					str1 =  (str1 -str1 %0.1) -- 小数向下区取整
					if math.floor(str1)-str1 == 0 then
						 math.floor(str1)
					end
				end
			end
			format_string = str1..str2

		end
    elseif format_type == 6 then
        format_string = FONTS.format(num, false, false)
    end
    return format_string
end

COIN_PARSER = function (n, decimal)
	return FONTS.format(n, true, decimal) -- "$"..FONTS.format(n, true, decimal)
end





bole.keepScreenAwake = function( bAwake )
	bole.setKeepScreen(bAwake)
end

bole.pauseAllActionsOnNode = function (node)
	if node then

		local className = node[".classname"]
		if (node.isScrollView and node.isScrollView == 1)
			or className == "ccui.ScrollView"
			or className == "cc.ScrollView"
			or className == "cc.TableView" then
			
		elseif node.isHiding then
			-- 正在关闭的弹窗，不暂停
			return
		elseif node.isForbidPause then
			-- 指定不暂停的弹窗
			return
		else
			node:pause()
		end

		local children = node:getChildren() or {}
		for _, child in pairs(children) do
			if child then
				bole.pauseAllActionsOnNode(child)
			end
		end
	end
end

bole.resumeAllActionsOnNode = function (node)
	if node then

		local className = node[".classname"]
		if (node.isScrollView and node.isScrollView == 1)
			or className == "ccui.ScrollView"
			or className == "cc.ScrollView"
			or className == "cc.TableView" then
			
		else
			node:resume()
		end

		local children = node:getChildren() or {}
		for _, child in pairs(children) do
			if child then
				bole.resumeAllActionsOnNode(child)
			end
		end
	end
end


bole.pauseTheme = function ( ... )
	-- 暂停结点动作
	bole.pauseAllActionsOnNode(bole.scene)
end

bole.getPos = function(node)
	return cc.p(node:getPositionX(),node:getPositionY())
end

bole.getWorldPos = function(node)
	return node:getParent():convertToWorldSpace(bole.getPos(node))
end

bole.createSpriteWithFile = function( theFile )
	local retSprite = nil
    if string.byte(theFile) == 35 then -- first char is #
        retSprite = cc.Sprite:createWithSpriteFrameName(string.sub(theFile, 2))
    else
    	retSprite = cc.Sprite:create(theFile)
    end
    return retSprite
end
bole.updateSpriteWithFile = function( theSprite, theFile )
   -- print("wy_theSprite",type(theSprite))
	if not theSprite or not theFile then
		return
	end
    if string.byte(theFile) == 35 then -- first char is #
        theSprite:setSpriteFrame(string.sub(theFile, 2))
    else
    	theSprite:setTexture(theFile)
    end
end

bole.setEnableRecursiveCascading = function(node, bEnable) -- 整体设置node 节点的透明度变化随子节点更改
	if not node then
    	return
    end
    node:setCascadeColorEnabled(bEnable)
    node:setCascadeOpacityEnabled(bEnable)
    local children = node:getChildren()
    for key, value in pairs(children) do
    	bole.setEnableRecursiveCascading(value, bEnable)
    end
end


-----------------------------  音效  -----------------------------

function Set (list)
	local set = {}
	for _, l in pairs(list) do set[l] = true end
	return set
end

local BOLE_MUSIC = Set({
	"hallbg"
}) -- sound effect in android has limited length, treat as music
local BOLE_EFFECT = Set({})
bole.musics = {}
bole.isSoundMute = function ()
	return SettingControl:getInstance():isSoundOpen()
end

bole.isMusicMute = function ()
	return SettingControl:getInstance():isMusicOpen()
end


bole.refresh_G_SOUND_MUTE = function ()
	if bole.isSoundMute() then
		G_SOUND_MUTE = false
	else
		G_SOUND_MUTE = true
	end
end

bole.refresh_G_MUSIC_MUTE = function ()
	if bole.isMusicMute() then
		G_MUSIC_MUTE = false
	else
		G_MUSIC_MUTE = true
	end
end

bole.getSoundPath = function () 
	return string.format("theme_desktop/theme%d/sounds/", THEME_DESKTOP_ID)
end

bole.loadMusic = function ( name, resPath )
	resPath = resPath or bole.getSoundPath()
	local file = resPath..name..".mp3"
	if BOLE_MUSIC[name] then
		AudioControl:preloadMusic(file)
	else
		AudioControl:preloadEffect(file)
	end
end

bole.playMusic = function (name, singleton, loop, resPath)
	resPath = resPath or bole.getSoundPath()
	local file = resPath..name..".mp3"
	if not cc.FileUtils:getInstance():isFileExist(file) then return end
	if BOLE_MUSIC[name] then
		loop = loop or true
		local volume = (bole.isMusicMute() and 1) or 0

		AudioControl:volumeGroupAudio(volume)
		AudioControl:playMusic("music",file, singleton, loop)
	elseif  bole.isSoundMute() then
		loop = loop or false
		-- AudioEngine.setEffectsVolume(1)
		local id = AudioControl:playEffect(file,loop)
		if id then
			bole.musics[name] = id
		end
	end
end

bole.stopMusic = function (name, resPath)
	resPath = resPath or bole.getSoundPath()
	if not name or BOLE_MUSIC[name] then
		AudioControl:stopAudio("music")
	elseif bole.musics[name] then
		AudioControl:stopEffectById(bole.musics[name])
		bole.musics[name] = nil
	end
end


bole.playSounds = function (name)
	bole.playMusic(name)
end
 
bole.playBGM = function (name)
		bole.playMusic(name)
end


----------------------- table ------------------------------
table.find = function ( t, n )
	
	for k, v in pairs(t) do
		if v == n then
			return k
		end
	end
	return -1
end

table.delete = function ( t, n )
	local i = table.find( t, n )
	if i > 0 then
		table.remove(t, i)
	end
	return i
end


table.copy = function (t)
    local newTable = {}
    for k, v in pairs(t) do
        if type(v) ~= "table" then
            newTable[k] = v
        else
            newTable[k] = table.copy(v)
        end
    end
    return newTable
end

table.pop = function (tb)
	local l = #tb
	if l == 0 then
		return nil
	end
	local b = tb[l]
	table.remove(tb, l)
	return b
end

table.randomPop = function (tb)
	local l = #tb
	local a = math.random(1,l)
	local b = tb[a]
	table.remove(tb, a)
	return b
end

table.cp = function (t)
    local newTable = {}
    for k, v in pairs(t) do
        if type(v) ~= "table" then
        	if type(v) ~= "string" then
	            newTable[k] = v
        	else
				newTable[k] = tonumber(v)
        	end
        else
            newTable[k] = table.cp(v)
        end
    end
    return newTable
end
-- 深拷贝, 只能是纯数据类型
table.CopyTableDeep = function(arrData)
    local resultVal = nil

    if type(arrData) == "table" then
        resultVal = {}
        for k, v in pairs(arrData) do
            resultVal[k] = table.CopyTableDeep(v)
        end
    else
        resultVal = arrData
    end

    return resultVal
end

--@params: a,b  are two tables
--@return: a - b  
table.minus = function(a, b)
	for _, v in pairs(b) do
		table.delete(a, v)
	end
end

table.merge = function (...)
	local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2,#tabs do
        if origin then
            if tabs[i] then
                for k,v in pairs(tabs[i]) do
                    table.insert(origin,v)
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end


 

bole.getTableCount = function ( table )
	local cnt = 0
	for _, _ in pairs(table) do
		cnt = cnt + 1
	end
	return cnt
end

bole.cleanAction = function( obj )
	cc.Director:getInstance():getActionManager():removeAllActionsFromTarget(obj)
end

bole.unpack = function( tb )
	return unpack(tb, 1, table.maxn(tb))
end

bole.shrinkLabel = function(label, maxWidth, maxScale)
	if label and maxWidth then
		local tempWidth = label:getContentSize().width
		local scale = maxWidth/tempWidth
		local endScale = (scale > maxScale) and maxScale or scale
		-- print("PD: setScale", endScale, scale, maxScale, tempWidth, maxWidth)
		label:setScale(endScale)
		return endScale
	end
end

bole.getSceneSize = function( )
	return cc.Director:getInstance():getWinSize()
end

bole.deepFind = function (root, name)
    local childs = root:getChildren()
    for k,subChild in pairs(childs) do
        if subChild:getName() == name then
            return subChild
        else
            local ret = bole.deepFind(subChild, name)
            if ret ~= nil then
                return ret
			end
        end
    end
    return nil
end


bole.addEventToNode = function( pNode, pTouchBeganFunc, pTouchEndFunc, pTouchCancelFunc, pTouchMoveFunc ,isSwallow)
	if not pNode or not pTouchBeganFunc then return false end
	local listener = cc.EventListenerTouchOneByOne:create()

	listener:setSwallowTouches(not isSwallow)
	if pTouchBeganFunc then
		listener:registerScriptHandler(pTouchBeganFunc,cc.Handler.EVENT_TOUCH_BEGAN )
	end
	if pTouchEndFunc then
	    listener:registerScriptHandler(pTouchEndFunc,cc.Handler.EVENT_TOUCH_ENDED )
	end
	if pTouchCancelFunc then
	    listener:registerScriptHandler(pTouchCancelFunc,cc.Handler.EVENT_TOUCH_CANCELLED )
	end
	if pTouchMoveFunc then
		listener:registerScriptHandler(pTouchMoveFunc,cc.Handler.EVENT_TOUCH_MOVED )
	end
    local eventDispatcher = pNode:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, pNode)

	function pNode:removeClickEvent()
		eventDispatcher:removeEventListenersForTarget(self)
		self.removeListeners = nil
		self.touchlistener = nil
	end

	if not pNode.touchlistener then
		pNode.touchlistener = listener
	end

end

bole.clearMask = function (parent)
	local mask = cc.LayerColor:create( cc.c4b(0, 0, 0, 185))
	mask:setAnchorPoint(cc.p(0.5,0.5))
	mask:setLocalZOrder(-1)
	-- 支持pad计，蒙版层加大一些，并不影响游戏 changed by dd.
	
	mask:setContentSize( 4000, 3000 )
	mask:setPosition(-1500,-1500)
	parent:addChild(mask)
end

-- creator ui后缀
bole.fileExt_Creator = ".luac"
---@param creator_path string @creator ui路径，不带文件格式后缀
bole.getCreatorFile = function ( creator_path )
	return creator_path .. bole.fileExt_Creator
end

-- 判断代码文件是否存在
---@param code_path string @代码路径，不带文件格式后缀
bole.isCodeFileExist = function( code_path )
	-- if bole.isMac() then
	-- 	code_path = libGlobal.getMacFilePath(code_path)
	-- end
	return cc.FileUtils:getInstance():isFileExist(bole.getCodeFile(code_path)) or cc.FileUtils:getInstance():isFileExist(code_path .. ".lua")
end

-- creator ui后缀
-- 判断creator ui文件是否存在
---@param creator_path string @creator ui路径，不带文件格式后缀
bole.isCreatorFileExist = function ( creator_path )
	if bole.isMac() then
		creator_path = libGlobal.getMacFilePath(creator_path)
	end
	return cc.FileUtils:getInstance():isFileExist(bole.getCreatorFile(creator_path)) or cc.FileUtils:getInstance():isFileExist(creator_path .. ".lua")
end

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
bole.splitStr = function(str, delimiter)
	if str==nil or str=="" or delimiter==nil then
		return nil
	end
    local result = {}
	if bole.__isWeb__ then
		local gmatch_func, delimiter, str = (str..delimiter):gmatch("([^" .. delimiter .. "]+)")
		result = gmatch_func(delimiter, str)
	else
		for match in (str..delimiter):gmatch("(.-)"..delimiter) do
			table.insert(result, match)
		end
	end
    return result
end
 
bole.popWin = function( win, delay, duration, callback , scale)
	duration = duration or 0.3
	delay = delay or 0.01
	win:setVisible(true)
	-- win:setScale(0.5)
	win:setScale(0.1)
	win:setCascadeOpacityEnabled(true)
	win:setOpacity(0)
	duration = duration * 1.6
	local tempScale = scale or 1
	local scaleAct = cc.EaseBackOut:create(cc.ScaleTo:create(duration, tempScale))
	-- local scaleAct = cc.Sequence:create(cc.EaseSineOut:create(cc.ScaleTo:create(duration, 1.1)), cc.ScaleTo:create(0.1, 1))
    if callback then
	    win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), scaleAct, cc.CallFunc:create(callback)))
    else
        win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), scaleAct))
    end
	win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.FadeIn:create(duration / 2)))
	return 0.4
end

bole.closeDialog = function (target, func, callback, callback_remove) -- callback_remove针对popupconfig里面的弹窗重复弹出的问题
	func = func or bole.fadeoutWin -- bole.popExitWin
	if not target then return end
	if target.isHiding then return end
	bole.setEnableRecursiveCascading(target, true)
	target.isHiding = true
	local delay = 0
	if bole.fadeoutWin == func then
		delay = func(target.root, nil, callback)
	else -- bole.popExitWin
		delay = func(target.root, nil, nil, nil, callback)
	end

	target:hideMask(delay)
	target:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.RemoveSelf:create(),
		cc.CallFunc:create(function ()
			local temp_node = cc.Node:create()
			if libUI.isValidNode(bole.scene) then
				bole.scene:addChild(temp_node)
				temp_node:runAction(cc.Sequence:create(
					cc.DelayTime:create(0.1),
					cc.CallFunc:create(function ()
						if callback_remove then
							callback_remove()
						end
					end),
					cc.RemoveSelf:create()
					))
			else
				if callback_remove then
					callback_remove()
				end
			end
		end)
		))
	return delay
end

-- for animation, remove the dialog outside
bole.fadeoutWin = function (win, delay, pCallFunc, pCallDelay, outTime)
	delay 		= delay or 0.01
	local outTime 	= outTime or 0.2
	local removeDelay = delay+outTime
	pCallDelay 	= pCallDelay or delay+outTime
	if removeDelay <= pCallDelay then
		removeDelay = pCallDelay + 0.1
	end

	win:setCascadeOpacityEnabled(true)
	win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.FadeOut:create(outTime)))
	if pCallFunc then
		win:runAction(cc.Sequence:create(cc.DelayTime:create(pCallDelay), cc.CallFunc:create(function()
			pCallFunc()
		end)))
	end

	-- for those created with popWin_2
	if win.shieldLayer then
		win.shieldLayer:runAction(cc.Sequence:create(cc.DelayTime:create(removeDelay), cc.RemoveSelf:create()))
		win.shieldLayer = nil
	end

	return delay + outTime
end

bole.resumeAllActionsOnNode = function (node)
	if node then

		local className = node[".classname"]
		if (node.isScrollView and node.isScrollView == 1)
			or className == "ccui.ScrollView"
			or className == "cc.ScrollView"
			or className == "cc.TableView" then
			
		else
			node:resume()
		end

		local children = node:getChildren() or {}
		for _, child in pairs(children) do
			if child then
				bole.resumeAllActionsOnNode(child)
			end
		end
	end
end

bole.resumeTheme = function ( ... )
	-- 恢复结点动作
	bole.resumeAllActionsOnNode(bole.scene)

	-- 恢复音效
	AudioControl:resumeAllEffects()
end

-- 获取当前单机机台场景路径
bole.getDesktopScenePath = function (name)
	return string.format("Desktop/Theme%d/%s/%s_Scene", THEME_DESKTOP_ID, name, name)
end

-- 获取当前单机机台文件路径
bole.getDesktopFilePath = function (name)
	return string.format("Desktop/Theme%d/%s", THEME_DESKTOP_ID, name)
end

bole.popWin_4 = function( win, delay, duration, scale,callback ) ---临时用下
	duration = duration or 0.3
	delay = delay or 0.01
	scale = scale or 1
	win:setVisible(true)
	-- win:setScale(0.5)
	win:setScale(0.1)
	win:setCascadeOpacityEnabled(true)
	win:setOpacity(0)
	duration = duration * 1.6
	local scaleAct = cc.EaseBackOut:create(cc.ScaleTo:create(duration, scale))
	-- local scaleAct = cc.Sequence:create(cc.EaseSineOut:create(cc.ScaleTo:create(duration, 1.1)), cc.ScaleTo:create(0.1, 1))
    if callback then
	    win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), scaleAct, cc.CallFunc:create(callback)))
    else
        win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), scaleAct))
    end
	win:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.FadeIn:create(duration / 2)))
	return 0.4
end

-- 判断是否在机台里
bole.isThemeScene = function (  )
	if not bole.scene then
		return false
	end
	return bole.scene.name == "PlayScene"
end

bole.getServerTime = function ()
	if User:getInstance().serverTime2 then
		return User:getInstance().serverTime2 + os.time()*1000 - User:getInstance().preLocalTime
	end
	return 0
end

NumberFont = class("NumberFont",function() return cc.Node:create() end)

function NumberFont:ctor(index, n, showAll, prev, fontSize)
	self.font = FONTS.new(index, nil, fontSize)
	self.prev = prev or ""
	self.showAll = showAll
	self:addChild(self.font)
	if n then 
		self:setString(n)
	end
end

function NumberFont:setAnchorPoint(p)
	self.font:setAnchorPoint(p)
end

function NumberFont:setString( n )
	
	local s = self.prev..FONTS.format(n, self.showAll)
	self.font:setString(s)
	return s
end

function NumberFont:setColor( n )
	self.font:setColor(n)
end

