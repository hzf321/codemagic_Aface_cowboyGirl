
---@program src
---@description:  stype1 大厅蓝色横屏
---               stype2 金色横屏
---               stype3 紫色竖屏
---               stype5 紫色横屏
---               stype7 金色竖屏
---               stype8 大厅金色横屏
---               stype9 绿色竖屏
---               stype10 绿色横屏
---               stype11 紫色横屏 + 紫色箭头按钮
---
local createSpriteWithFile = bole.createSpriteWithFile
local createScale9Sprite   = bole.createScale9Sprite
local newButton            = Widget.newButton

local getImage = function (name)
	return ("header_footer/footer/images/" .. name ..".png")
end

local getFont = function (name)
	return ("header_footer/footer/fonts/" .. name ..".fnt")
end

local getParticle = function (name)
	return ("header_footer/footer/particles/" .. name ..".plist")
end

local getSpine = function (name)
	return ("header_footer/footer/spines/" .. name .."/spine")
end

local getCommonImage = function (name)
	return ("commonpics/" .. name ..".png")
end

local getCommonNewFont = function (name)
	return ("commonNew/font/" .. name ..".fnt")
end

local HeaderFooterConfig = {}

HeaderFooterConfig.footer_config_list =
{   
    -- 竖版主题
    [1] =
    {
        background = 
        {
            leftBg   = {getImage("big_back_half"), cc.p(0, 72), false},
            rightBg  = {getImage("big_back_half"), cc.p(0, 72), true},
            spine    = {getSpine("frame_footer"), cc.p(0, 824), "animation2"},
            animNode = cc.p(0, 135)
        },
        totalbet =
        {
            position = cc.p(-241, 80),
            bigBgImage     = {getImage("wnzi_back"), cc.p(0, 0)},
            smallBgImage   = {getImage("freegame_backyellow"), cc.p(58, -23.5)},
            subButton      = {getImage("minus_h01"), getImage("minus_h02"), getImage("minus_h03"), cc.p(-54.5, -56) },
            addButton      = {getImage("plus_h01"), getImage("plus_h02"), getImage("plus_h03"), cc.p(57, -56) },
            labelBet       = {getFont("coins_font04"), cc.p(0, 2), 0.8, 199, cc.p(59, -22), 1, 91}, 
            totalBetImage1 = {getImage("totalbetzit"), cc.p(-0.5, -21)},
            totalBetImage2 = {getImage("totalbetzit"), cc.p(58, -60.5)}, 
            animNode       = cc.p(0, 0),
            particle       = {getParticle("max_bet_liziwenjian01_1"), cc.p(0, 0)}, 
            max_bet_spine  = getSpine("maxbet"),
        },
        freegames =
        {
            position = cc.p(-299, 56.5),
            bgImage     = {getImage("freegame_backyellow"), cc.p(0, 0)},
            labelCount  = {getFont("coins_font04"), cc.p(0, 0), 1, 85},
            labelImage  = {getImage("FREEGAME"), cc.p(-1, -38)},
        },
        totalwin =
        {
            position = cc.p(-3, 110),
            particle    = {getParticle("winParticle"), cc.p(0, 2)},
            animNode    = cc.p(0, 40),
            winLabel    = {getFont("win_coins02"), cc.p(2, 0), 1},
            effectLabel = {getFont("nice_win_fnt01"), cc.p(0, 15), 1},
            small_win_spine1 = {getSpine("small_win"), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine("small_win1"), cc.p(0, 15), 1},
            label       = {getImage("totalwin"), cc.p(0, 0)},
        },
        maxbet =
        {
            position = cc.p(192, 50),
            button = {getImage("maxbet_01"), getImage("maxbet_02"), getImage("maxbet_03"), cc.p(0, 0) },
            image  = {getImage("maxbet_03"), cc.p(52.5, 42.5)},
        },
        themeIconDefault =
        {
            list_pos = cc.p(50, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        spin =
        {
            position = cc.p(2, 53),
            autoOn = 
            {
                root       = cc.p(0, 151),
                background = {getImage("freegamespin_back"), cc.p(-3, 22)},
                buttonFast = {getImage("kong13345"), getImage("anxia_fast"), getImage("kong13345"), cc.p(-3, 130)},
                button500  = {getImage("kong13345"), getImage("anxia_500"), getImage("kong13345"), cc.p(0, 86)},
                button100  = {getImage("kong13345"), getImage("anxia_100"), getImage("kong13345"), cc.p(0, 42)},
                button50   = {getImage("kong13345"), getImage("anxia_50"), getImage("kong13345"), cc.p(0, -2)},
                button20   = {getImage("kong13345"), getImage("anxia_20"), getImage("kong13345"), cc.p(0, -46.5)},
                button10   = {getImage("kong13345"), getImage("anxia_10"), getImage("kong13345"), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
                button     = {getImage("spin_01"), getImage("spin_02"), getImage("spin_03"), cc.p(0, 0)},
                labelStop  = {getImage("STOP"), getImage("STOP02"), getImage("STOP03"), cc.p(128, 58)},
                labelStopFast   = {getImage("STOP"), getImage("STOP02"), getImage("STOP03"), cc.p(128, 49)},
                remaining  = {getFont("auto_fnt01"), getFont("auto_fnt02"), cc.p(126, 27), 1},
            },
            spin = 
            {
                button            = {getImage("spin_01"), getImage("spin_02"), getImage("spin_03"), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage("SPIN"), getImage("SPIN02", true)},
                    disable  = getImage("SPIN_disable"),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage("HOLDFORAUTO"), getImage("HOLDFORAUTO02", true)},
                    disable  = getImage("HOLDFORAUTO_disable"),
                    position = cc.p(123, 27),
                },
                labelStop         = {getImage("STOP"), getImage("STOP02"), getImage("STOP03"), cc.p(125, 49)},
                spineCharge = {getSpine("charge"), cc.p(0, 0)}
            },
        },
    },        
}

-- 创建容器结点
HeaderFooterConfig.createContainer = function (parent, pos, zOrder, size)
	local containerCsb = "header_footer/header/basic/BasicContainer.csb"
	local fileUtils = cc.FileUtils:getInstance()
	if fileUtils:isFileExist(containerCsb) then
		local containerNode = cc.CSLoader:createNode(containerCsb)

		if pos then
			containerNode:setPosition(pos)
		end

		if parent then
			parent:addChild(containerNode, zOrder)
		end

		local container = containerNode:getChildByName("container")
		if size then
			container:setContentSize(size)
		end

		return container
	end

	return nil
end

-- 创建line结点
HeaderFooterConfig.createLine = function (parent, pos, zOrder, size)
    local lineCsb = "header_footer/header/basic/BasicLine.csb"
    local fileUtils = cc.FileUtils:getInstance()
    if fileUtils:isFileExist(lineCsb) then
        local lineNode = cc.CSLoader:createNode(lineCsb)

        if pos then
            lineNode:setPosition(pos)
        end

        if parent then
            parent:addChild(lineNode, zOrder)
        end

        local line = lineNode:getChildByName("line")
        if size then
            line:setContentSize(size)
        end

        return line
    end

    return nil
end

-- 创建精灵结点
HeaderFooterConfig.createSprite = function (parent, filename, pos, zOrder, flipX, scale)
    local fileUtils = cc.FileUtils:getInstance()
    local sprite = nil
	if fileUtils:isFileExist(filename) then
        sprite = createSpriteWithFile(filename)
    else
        sprite = createSpriteWithFile("commonpics/kong.png")
    end
    if sprite then
		if pos then
			sprite:setPosition(pos)
		end

		if flipX ~= nil then
			sprite:setFlippedX(flipX)
		end

		scale = scale or 1
		sprite:setScale(scale)

		if parent then
			parent:addChild(sprite, zOrder)
		end

		return sprite
	end

	return nil
end

-- 创建精灵九宫格结点
HeaderFooterConfig.createScale9Sprite = function (parent, filename, pos, zOrder, flipX, insets, size)
    local fileUtils = cc.FileUtils:getInstance()
    local sprite = nil
	if fileUtils:isFileExist(filename) then
        sprite = createScale9Sprite(filename)
    else
        sprite = createScale9Sprite("commonpics/kong.png")
    end

    if sprite then
		if pos then
			sprite:setPosition(pos)
		end

		if flipX ~= nil then
			sprite:setFlippedX(flipX)
		end

        if insets then
            sprite:setCapInsets(insets)
        end

        if size then
            sprite:setContentSize(size)
        end

		if parent then
			parent:addChild(sprite, zOrder)
		end

		return sprite
	end

	return nil
end

-- 创建按钮结点
HeaderFooterConfig.createButton = function (parent, touchFunc, file1, file2, file3, pos, zOrder, scale)
	local button = newButton( touchFunc, file1, file2, file3)

	if pos then
		button:setPosition(pos)
	end

	scale = scale or 1
	button:setScale(scale)

	if parent then
		parent:addChild(button, zOrder)
	end

	return button
end

-- 创建结点
HeaderFooterConfig.createNode = function (parent, zOrder, pos)
	local node = cc.Node:create()

    if pos then
        node:setPosition(pos)
    end

	if parent then
		parent:addChild(node, zOrder)
	end

	return node
end

-- 创建字体结点
HeaderFooterConfig.createFont = function (parent, font, pos, scale, zOrder)
    return libUI.createFont(parent, font, pos, scale, zOrder)
end

return HeaderFooterConfig
