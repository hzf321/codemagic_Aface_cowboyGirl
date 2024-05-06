local getLogoSpinePath = function (themeid)
	local path = "theme_loading/theme" .. themeid .. "/logo/spine/logo/spine"
	return path
end

local getImagePath = function (themeid, name)
	local path = "theme_loading/theme" .. themeid .. "/logo/" .. name .. ".png"
	return path
end

local isValidNode = function (node)
	return not tolua.isnull(node)
end

local LobbyTheme = class("LobbyTheme",function() return cc.Node:create() end)

function LobbyTheme:ctor(themeid)
    self.themeid = themeid or 188
	self.node = cc.Node:create()
	self:addChild(self.node)

	self:configNode(self.node)
end

function LobbyTheme:configNode(node)
	if not isValidNode(node) then
		return
	end

	local bg_path = getImagePath(self.themeid, "logo")
	if cc.FileUtils:getInstance():isFileExist(bg_path) then
		local sprite = cc.Sprite:create(bg_path)
		sprite:setPosition(cc.p(0, 0))
		sprite:setLocalZOrder(1)
		node:addChild(sprite)
	end

	local btn_path = "commonpics/kong.png"
	if cc.FileUtils:getInstance():isFileExist(btn_path) then
		local function btnEvent(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				if isValidNode(self.btn_touch) then
                    self.btn_touch:setTouchEnabled(false)

                    require "UI/PlayScene"
                    local play = PlayScene.new(self.themeid, "", nil, nil)
                    bole.scene = play
                    -- play:setJackpotBet(bet)
                    play:run()
                    play:setName("PlayScene")

				end
			end
		end
		local base_width = 10
		local target_width = 255
		local target_height = 255
		local button = ccui.Button:create()
		button:loadTextures(btn_path, btn_path, btn_path)
		button:setPosition(cc.p(0, 0))
		button:setScaleX(target_width / base_width)
		button:setScaleY(target_height / base_width)
		button:setLocalZOrder(3)
		button:addTouchEventListener(btnEvent)
        button:setTouchEnabled(true)

		node:addChild(button, 3)
		self.btn_touch = button
	end

	local spine_path = getLogoSpinePath(self.themeid)
	if cc.FileUtils:getInstance():isFileExist(spine_path .. ".atlas") then
		local logo_spine = sp.SkeletonAnimation:createWithJsonFile(spine_path .. ".json", spine_path .. ".atlas", 1)
		if logo_spine then
			logo_spine:setPosition(0, 0)
			logo_spine:setAnimation(0, "animation", true) 
			node:addChild(logo_spine)
			logo_spine:setLocalZOrder(3)
		end
	end
end

return LobbyTheme
