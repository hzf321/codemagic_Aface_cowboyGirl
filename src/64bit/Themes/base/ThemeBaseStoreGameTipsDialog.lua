




ThemeBaseStoreGameTipsDialog = class("ThemeBaseStoreGameTipsDialog", CCSNode)
local cls = ThemeBaseStoreGameTipsDialog
local tip_type = 
{
	rules = 1,
	unfinish = 2,
}


function cls:ctor(data,theme,callback) 
	self.tip_type = data.type or 1
	self.theme = theme
	self.csb  = self.theme:getPic("store/csb/store_tips.csb")
	self.callback = callback
	self.isPortrait = true
	if self.isPortrait then
	   
	end
	CCSNode.ctor(self, self.csb)
end

function cls:loadControls()
	self.dimmer = self.node:getChildByName("dimmer_node")
	self.dimmer:setOpacity(0)
	self.dimmer:setVisible(true)
	self.pop_node = self.node:getChildByName("pop_node")
	self.pop_node:setScale(0)
	self.pop_node:setVisible(true)

	local tip_rule_node = self.pop_node:getChildByName("rule_tip")
	local tip_unfinis_node = self.pop_node:getChildByName("unfinish_tip")
	if self.tip_type == tip_type.rules then
		tip_unfinis_node:setVisible(false)
	elseif self.tip_type == tip_type.unfinish then
		tip_rule_node:setVisible(false)
	end

	self.btn_close = self.pop_node:getChildByName("btn_close")
end

function cls:show()
	self.theme.curScene:addToContentFooter(self)
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.dimmer:runAction(cc.FadeIn:create(0.3))
			self.pop_node:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.3,1.2,1.2),
				cc.ScaleTo:create(0.1,1,1)
			))
			self.theme:playMusic(self.theme.audio_list.theme_store_tip)
		end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function()
			self.pop_node:runAction(cc.Sequence:create(
				cc.DelayTime:create(5),
				cc.CallFunc:create(function()
					self:hide()
				end)
			))
			self.btn_close :setTouchEnabled(true)
			self:initCloseEvent()
		end)
	))
end

function cls:initCloseEvent()
	local pressFunc = function(obj)
	    self.btn_close:setTouchEnabled(false)
	    self:hide()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end
	-- 设置按钮
	self.btn_close:addTouchEventListener(onTouch)
end

function cls:hide()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.pop_node:stopAllActions()
			self.dimmer:runAction(cc.FadeOut:create(0.3))
			self.pop_node:runAction(cc.FadeOut:create(0.3))
		end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function()
			if self.callback then
				self.callback()
			end
		end),
		cc.RemoveSelf:create()
	))
end
