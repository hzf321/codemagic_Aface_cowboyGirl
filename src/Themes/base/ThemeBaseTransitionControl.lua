

-----------------------------Transition弹窗相关------------------------------

ThemeBaseTransitionControl = class("ThemeBaseTransitionControl", CCSNode)
local GameTransition = ThemeBaseTransitionControl

function GameTransition:ctor(themeCtl, endCallBack, coverCallBack)
	self.spine = nil
	self.themeCtl = themeCtl
	self.endFunc = endCallBack
	self.coverFunc = coverCallBack
end

function GameTransition:play(config, parent)
	-- local spineFile = self.theme:getPic("spine/transition_free/spine") -- 默认显示 Free transition
	-- local pos = cc.p(0,0)
	-- local delay1 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间
	-- local animName = "animation"
	-- local audioFile = self.theme.audio_list.transition_free
	
	-- if tType == "respin" then 
	-- 	spineFile = self.theme:getPic("spine/transition_respin/spine") -- 默认显示 Free transition
	-- 	animName = "animation"
	-- 	audioFile = self.theme.audio_list.transition_bonus
	-- elseif tType == "wheel" then 
	-- 	spineFile = self.theme:getPic("spine/transition_wheel/spine") -- 默认显示 Free transition
	-- 	animName = "animation"
	-- 	audioFile = self.theme.audio_list.transition_wheel
	-- end

	local spineFile = self.themeCtl:getPic(config.path) -- 默认显示 Free transition
	local animName = config.animName
	-- local audioFile = self.themeCtl:playMusicByName(config.audio)
	local pos = config.pos or cc.p(0,0)
	config.coverTime = config.coverTime or 0 
	if bole.isValidNode(parent) then 
		parent:addChild(self)
	else
		bole.scene:addToContentFooter(self)
		bole.adaptTransition(self,true,true)
	end

    self:setVisible(false) 
    self:runAction(
    	cc.Sequence:create(
    		cc.DelayTime:create(0.1), 
    		cc.CallFunc:create(function()
		    	self.themeCtl:playMusicByName(config.audio)-- 播放转场声音
		    	self:setVisible(true)
		    	bole.addSpineAnimation(self, nil, spineFile, pos, animName)
		    end),
		    cc.DelayTime:create(config.coverTime), -- 切屏动画完成时间
		    cc.CallFunc:create(function ( ... )
		    	if self.coverFunc then 
		    		self.coverFunc()
		    	end
		    end),
		    cc.DelayTime:create(config.endTime - config.coverTime), -- 切屏动画完成时间
		    cc.CallFunc:create(function ( ... )
		    	if self.endFunc then 
		    		self.endFunc()
		    	end
		    end),
		    cc.RemoveSelf:create()))
end

-------------------------------Transition 结束--------------------------------------
