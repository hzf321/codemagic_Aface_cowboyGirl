require "Themes/Theme"
require "UI/SpinNode"
require "UI/FlipSpinNode"

require "UI/FootNode"
require "Themes/init"
require "UI/DialogFreeSpin/init"
require "UI/ViewThemeLoadding/init"
require "UI/HeadNode"

local Header_Node = require (bole.getDesktopFilePath("HeaderFooter/Header_Node"))

------------------------------------------------------------------------------------------------------------------------------------
-- scene扩展相关
------------------------------------------------------------------------------------------------------------------------------------
local l_node_zorder_list = {
	["bg"] 				= {100, 1, nil},
	["content"] 		= {200, nil, nil},
	["special_dialog"]  = {250, 1, nil},
	["content_footer"]  = {300, nil, 1},
	["footer"]  	  	= {400, nil, nil},
	["footer_header"] 	= {500, nil,nil},
	["header"] 			= {600, nil, nil}, -- header 层级
	["top"]				= {700, nil,1},
	["dialog"]			= {800, 1, nil},
	["loadding"]		= {800, nil, nil},
	["guide"]			= {750, 1, nil},
	["combat"]			= {900, 1, nil},

}
SceneExtend = {}
function SceneExtend:initOrderNodes( )
	local l_win_size = cc.Director:getInstance():getWinSize()
	self.nodeList = {}
	self.rootList = {}
	for theNodeName,theConfig in pairs(l_node_zorder_list) do
		local theZOrder = theConfig[1]
		local theIndex  = theConfig[2]
		if theIndex then
			local theRoot 	= cc.Node:create()
			theRoot:setPosition(cc.p(l_win_size.width/2, l_win_size.height/2))
			self:addNode(theRoot, theZOrder)
			self.rootList[theIndex] = self.rootList[theIndex] or {}
			table.insert(self.rootList[theIndex], theRoot)
			---------------------------------------------------------------------------
			local theNode 	= cc.Node:create()
			theNode:setPosition(cc.p(-l_win_size.width/2, -l_win_size.height/2))
			theRoot:addChild(theNode)
			self.nodeList[theNodeName] = theNode
		else
			local theNode = cc.Node:create()
			self:addNode(theNode, theZOrder)
			self.nodeList[theNodeName] = theNode
			if theConfig[3] then
				local themeData = THEME_LIST[self.themeid]
				local isPortrait = (themeData and themeData['portrait'] == 1)
				bole.adaptScale(theNode,isPortrait)
			end
		end
	end	
end
function SceneExtend:adjustTheRootScale( rootIndex, theScale )
	if self.rootList[rootIndex] and #self.rootList[rootIndex]>0 then
		for _,theRoot in ipairs(self.rootList[rootIndex]) do
			theRoot:setScale(theScale)
		end
	end
end
function SceneExtend:getCenterPos( )
	return cc.p(640, 360)
end
function SceneExtend:addToBg(theChild, zOrder)
	self.nodeList["bg"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToContent(theChild, zOrder)
	self.nodeList["content"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToSpecialDialog(theChild, zOrder)
	self.nodeList["special_dialog"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToContentFooter(theChild, zOrder)
	self.nodeList["content_footer"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToFooter(theChild, zOrder)
	self.nodeList["footer"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToFooterHeader(theChild, zOrder)
	self.nodeList["footer_header"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToHeader(theChild, zOrder)
	self.nodeList["header"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToTop(theChild, zOrder)
	self.nodeList["top"]:addChild(theChild, zOrder or 0)
end
function SceneExtend:addToDialog(theChild, zOrder)
	self.nodeList["dialog"]:addChild(theChild, zOrder or 0)
end

function SceneExtend:addToLoadding(theChild, zOrder)
	self.nodeList["loadding"]:addChild(theChild, zOrder or 0)
end

function SceneExtend:addToGuide(theChild, zOrder)
	self.nodeList["guide"]:addChild(theChild, zOrder or 0)
end

function SceneExtend:addToCombat(theChild, zOrder)
	self.nodeList["combat"]:addChild(theChild, zOrder or 0)
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

------------------------------------------------------------------------------------------------------------------------------------
-- theme_scene相关
------------------------------------------------------------------------------------------------------------------------------------
PlayScene = class("PlayScene", Scene)
-- gift_data -- 当通过Inbox中Gifts进入主题时候, Gifts 信息存储在 gift_data 中
function PlayScene:ctor(themeid, from, gift_data, bet)
	inherit(self, SceneExtend)
	self.themeid = themeid or 0
	self.from    = from -- nil / normal, 'gift' / from mail
	self.gift_data = gift_data
	self.name 	 = "PlayScene"
	self:setName("PlayScene")
	Scene.ctor(self)
	self.bet 	= bet -- whj 添加逻辑,用来传递当前选择的bet
end

function PlayScene:setJackpotBet (bet)
	self.jackpotBet = bet
end

function PlayScene:onEnter()
	Scene.onEnter(self)
	self:initOrderNodes()
	self:initLayout()
	self:loadTheme()
end

function PlayScene:onExit( )
	self.sendEnterThemeID = nil
	if self.ctl then self.ctl:onExit() end

	Scene.onExit(self)
end
function PlayScene:onPause( )
	-- body
end
function PlayScene:onResume( )
    if self.ctl.sendInitCmd then
	    self.ctl:sendInitCmd()
    end
end
function PlayScene:initLayout( )
	if not self.ctl then

		local themeConfig 	= THEME_LIST[self.themeid]
		local theme_name = THEME_LIST[self.themeid]["class"]
		
		local ThemeModule = self:getThemeClass(theme_name)
		
		local theTheme
		local theCtl
		if themeConfig["isNew2"] then
			theTheme  	= ThemeModule.new(self.themeid, self)
			theCtl = theTheme
		elseif themeConfig["isNew"] then
			theTheme  	= ThemeModule.new(self.themeid, self)
			
			self:addToContent(theTheme)
			theTheme:setCurScene(self)
			theCtl 		= ThemeControl.new(theTheme, self)
		else
			theTheme  	= ThemeModule.new(self.themeid)
			self:addToContent(theTheme)
			theTheme:setCurScene(self)
			theCtl 		= ThemeControl.new(theTheme, self)
		end
		
		theTheme:setControl(theCtl)
		self.ctl = theCtl

		------------------------------------------------------------------------
		-- used for temporary dialog or animation
		local tempLayer = cc.Node:create()
		self:addToDialog(tempLayer)
		self.tempLayer = tempLayer

   		local s = cc.Director:getInstance():getWinSize()
   		if s.width<s.height then
			s = cc.size(s.height,s.width)
		end
    	if theTheme.isPortrait then
			self.__layer:setPosition(s.height/2,s.width/2)
		else
		    self.__layer:setPosition(s.width/2,s.height/2)
		end

		local header = Header_Node.new(theCtl, theTheme.isPortrait)		
		if theTheme.isPortrait then
		    if bole.isDynamicIsland() then
				header:setPosition(0, FRAME_WIDTH/2-90)
			elseif bole.isIphoneX() then
				header:setPosition(0, FRAME_WIDTH/2-58)
			else
				header:setPosition(0, FRAME_WIDTH/2 - 0)
			end
		else
		    header:setPosition(0,360)
		end
		header.themeCtl = theCtl
		-- User:getInstance():setHeader(header)
		header:setName("Header_Node")
		theCtl:setHeader(header)
		self:addToHeader(header) 
		User:getInstance():setHeader(header)

		local footer = Footer.new(theCtl, theTheme.isPortrait)
		if theTheme.isPortrait then
			if bole.isIphoneX() then
				footer:setPosition(0,-FRAME_WIDTH/2+30)
			else
				footer:setPosition(0,-FRAME_WIDTH/2-2)
			end
			local scale = bole.getAdaptScale(theTheme.isPortrait)
			if scale < 1 and SHRINKSCALE_H > scale then
				footer:setScale(1 - SHRINKSCALE_H + scale)
			end
		else
		    footer:setPosition(0,-360)
		end
		theCtl:setFooter(footer)
		self:addToFooter(footer)
	end
end

local file_extend = ".luac"
if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
	file_extend = ".lua"
end

-- 主题代码 在使用前单独require一次
function PlayScene:getThemeClass( theme_name )
	local luaPath_old = "Themes/"..theme_name
	local theme = nil

    local luaPath = string.format("Themes/ThemeSrc/theme%d/%s", self.themeid, theme_name)
    if luaPath then
		theme = require(luaPath)
    end

    return theme
end

function PlayScene:loadTheme( )
	local callBack = function ()
		if self and self.enterTheme then
			self:enterTheme()
		end
	end
	if self.ctl then self.ctl:onLoading(callBack) end
end


function PlayScene:enterTheme()
	--单机，直接使用模拟数据
	local playLoadData = require (string.format("Desktop/Theme%d/Theme/PlayLoad", THEME_DESKTOP_ID))
	local data = playLoadData.enterGame
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(function()
			if data and self.ctl then self.ctl:onEnter(data) end
		end)
	))
end

-- function PlayScene:outToLobby( )
-- 	GiftControl:getInstance():getGiftList()
-- 	LobbyControl:getInstance():initScene("PlayScene")
-- end
--------------------------------------------------------------------------------
-- 事件注册
--------------------------------------------------------------------------------
function PlayScene:ConnectLost( )
	-- todo
end
function PlayScene:registerCmd( cmd )
	-- bole.potp:registerCmd(cmd, self.oncmd, self)
	SystemController:getInstance():listenCmd("PlayScene", cmd, self, function (obj, data)
		if not libUI.isValidNode(self) then return end

		self:oncmd(cmd, data)
	end)
end
function PlayScene:unregisterCmd( cmds )
	for _,c in pairs(cmds) do
		-- bole.potp:unregisterCmd(c)
		SystemController:getInstance():cancelCmd("PlayScene", c)
	end
end
function PlayScene:getCmds( )
	return {ENTER_THEME}
end
function PlayScene:initPotpCmd( )
	local cmds = self:getCmds()
	self:unregisterCmd(cmds)
	
	for _,c in pairs(cmds) do
		self:registerCmd(c)
	end
end
function PlayScene:oncmd(cmd, data)
	if cmd == ENTER_THEME then
		if self and self.enterTheme then 
			self:enterTheme(data)
		end

		TimerCallFunc:getInstance():unscheduleGroup("enter_theme")
	end
end
