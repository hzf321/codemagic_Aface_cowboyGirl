local PubLoaddingView = class("PubLoaddingView", function() return cc.Node:create() end)
function PubLoaddingView:ctor( theme )
	self.theme     = theme
	self.startTime = os.time()
	self.fadeOutDuration = 1

    local mask = cc.LayerColor:create(cc.c4b(0,0,0,255))
    mask:setContentSize(cc.size(5000,5000))
    mask:setAnchorPoint(cc.p(0.5, 0.5))
	self:addChild(mask)
	local isPortrait = ScreenControl:getInstance().isPortrait
	
	local sp = cc.Sprite:create("commonpics/common_progress_themeloading_2.png")
    local bar = Widget.newProgress("commonpics/common_progress_themeloading_1.png", 1)
	self.progress = RoundProgress.new(bar, nil, nil)
    self.progress:setAnchorPoint(0.5, 0.5)

    self:setLocalZOrder(200)
    
    -- self.progress:setScale(prog:getScale())
    self:addChild(sp)
    self:addChild(self.progress)
    -- self:setContentSize(cc.size(10000,10000))
    if isPortrait then
		self:setPosition(cc.p(-360,-640))
		self.progress:setPosition(cc.p(360, 640))
		sp:setPosition(cc.p(-360, -640))
		-- mask:setPosition(cc.p(360, 640))
	else
		self:setPosition(cc.p(-640,-360))
		self.progress:setPosition(cc.p(640, 360))
		sp:setPosition(cc.p(640, 360))
		mask:setPosition(cc.p(-640, -360))
	end
end
function PubLoaddingView:getEndTime( ... )
	-- local min_duration = 2
	-- local t = os.time() - self.startTime
	-- if t >= min_duration - self.fadeOutDuration then
	-- 	return self.fadeOutDuration
	-- else
	-- 	return min_duration - t
	-- end
	return 0.3
end
function PubLoaddingView:hideOnTime( endTime )
	self:runAction(cc.Sequence:create( cc.DelayTime:create(endTime), cc.CallFunc:create(function ()
		self:hide()
	end)))
end
function PubLoaddingView:hide(  )
	if self.isHide then return end
	self.isHide = true
	self:runAction(
		cc.Sequence:create(
			cc.FadeOut:create(0.3),
			cc.RemoveSelf:create(),
			cc.CallFunc:create(function ()
				EventCenter:pushEvent(EVENTNAMES.THEME.ENTER_LOADING_HIDE)
			end)
		)
	)
end
function PubLoaddingView:setPercent(percent)
	self.progress.progress:setPercentage(percent)
end
return PubLoaddingView