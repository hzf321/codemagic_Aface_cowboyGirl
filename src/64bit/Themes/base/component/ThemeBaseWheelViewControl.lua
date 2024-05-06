

local ThemeBaseWheelViewControl = class("ThemeBaseWheelViewControl")
local cls = ThemeBaseWheelViewControl

local ThemeBaseWheelView = require "Themes/base/component/ThemeBaseWheelView"

function cls:ctor( bonusParent, themeCtl, data, nodeList, callFunc )
	self.bonusParent 	= bonusParent
	self.themeCtl 		= themeCtl
	
    self.callback = callFunc

	self.node = cc.Node:create()
	bole.scene:addToContentFooter(self.node)

    self.wheelData = data
    self.wheelCfg = self.wheelData.config

    self:initLayout(nodeList, data)
end

function cls:initLayout( nodeList, data )
	self._view = ThemeBaseWheelView.new(self, nodeList, data)
end

function cls:enterFeatureGame()
    self:onStartTrasitionCoverEvent()
    self:onStartTrasitionEndEvent( true )
end

function cls:onStartTrasitionCoverEvent(  )
    self._view:initAndShowWheelNode()
    self._view:createMiniReel(self.itemParent)
end

function cls:onStartTrasitionEndEvent( isClick )
    self._view:openWheelBtn(isClick) -- 默认直接滚动
end

function cls:playWheelClickMusic( ... )
	if self.wheelCfg.click_music then 
        self.themeCtl:playMusicByName(self.wheelCfg.click_music)
    end
end

function cls:onMiniReelRoll( )
    -- 播放滚动音效 
    if self.wheelCfg.roll_music then 
    	self.themeCtl:playMusicByName(self.wheelCfg.roll_music)
    end
    self.themeCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
end

function cls:onMiniReelStop() -- 进行参数控制
    if self.wheelCfg.stop_music then 
        self.themeCtl:playMusicByName(self.wheelCfg.stop_music)
    end
    
end

function cls:onOverWheelGame( )
    self._view:closeWheelNode()
end

function cls:finshCallBack( ... )
    if self.callback then 
        self.callback()
    end
end

function cls:onExit( ... )
    if self._view then 
    	self._view:onExit()
    end
end

---
function cls:getSpineFile(file_name, notPathSpine)
    return self.themeCtl:getSpineFile(file_name, notPathSpine)
end

return ThemeBaseWheelViewControl
