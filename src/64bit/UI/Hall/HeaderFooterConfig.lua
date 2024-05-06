
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
local createScale9Sprite = bole.createScale9Sprite
local newButton            = Widget.newButton

local HFStyle = {
    ["style1"]=1,
    ["style2"]=2,
    ["style3"]=3,
    ["style4"]=4,
    ["style5"]=5
}

local getImage = function (style, name, isFooter)
	local str = (isFooter and "/footer") or "/header"
	str = "/style" .. style .. str
	return ("header_footer" .. str .. "/images/" .. name ..".png")
end

local getDynamicImage = function (style, name, isFooter)
    local str = (isFooter and "/footer") or "/header"
    str = "/style" .. style .. str
    return ("header_footer_dynamic" .. str .. "/images/" .. name ..".png")
end

local getGoldSpinImage = function (style, name, isFooter)
    local str = (isFooter and "/footer") or "/header"
    str = "/style" .. style .. str
    return ("#gold_spin/header_footer" .. str .. "/images/" .. name ..".png")
end

local getActivityImage = function (style, name, isFooter) -- activities/blast/footer/lobby_pickfrenzy_icon01.png
    local str = (isFooter and "/footer") or "/header"
    return ("activities/" .. style .. str .. "/" .. name ..".png")
end

local getFont = function (style, name, isFooter)
    local str = (isFooter and "/footer") or "/header"
	str = "/style" .. style .. str
	return ("header_footer" .. str .. "/images/" .. name ..".fnt")
end

local getGoldSpinFont = function (style, name, isFooter)
    local str = (isFooter and "/footer") or "/header"
	str = "/style" .. style .. str
	return ("gold_spin/header_footer" .. str .. "/images/" .. name ..".fnt")
end

local getParticle = function (style, name, isFooter)
	local str = (isFooter and "/footer") or "/header"
	str = "/style" .. style .. str
	return ("header_footer" .. str .. "/particles/" .. name ..".plist")
end

local getSpine = function (style, name, isFooter)
	local str = (isFooter and "/footer") or "/header"
	str = "/style" .. style .. str
	return ("header_footer" .. str .. "/spines/" .. name .."/spine")
end

local getGoldSpinSpine = function (style, name, isFooter)
	local str = (isFooter and "/footer") or "/header"
	str = "/style" .. style .. str
	return ("gold_spin/header_footer" .. str .. "/spines/" .. name .."/spine")
end

local getCommonImage = function (name)
	return ("commonpics/" .. name ..".png")
end

local getCommonNewFont = function (name)
	return ("commonNew/font/" .. name ..".fnt")
end

local coinSpine = function (name)
	return ("commonEffect/coin/" .. name .."/spine")
end


local coinParticle = function (name)
	return ("commonEffect/coin/" .. name ..".plist")
end

local coinCommonImage = function (name)
	return ("commonpics/" .. name ..".png")
end


local zuanshiSpine = function (name)
	return ("commonEffect/zuanshi/" .. name .."/spine")
end


local zuanshiParticle = function (name)
	return ("commonEffect/zuanshi/" .. name ..".plist")
end

HEADER_ZORDER = {
    BACKGROUND_BOTTOM = 0,
    ICON_BOTTOM = 1,
    POP_BOTTOM = 2,
    BACKGROUND_TOP = 3,
    FACEBOOK = 4,
    CHIP = 4,
    LOBBY = 4,
    MANSION_QUEST = 4,
    MANSION_STAR = 4,
    MANSION_QUEST = 4,
    HOT_TODAY = 4,
    BUY = 5,
    WHEEL = 6,
    COIN = 7,
    SCREEN_TOUCH = 8,
    PIG = 9,
    EXP = 10,
    SETTING = 11,
    POP_TOP = 12,
}

local HeaderFooterConfig = {}

-- Header配置表
HeaderFooterConfig.header_config_list =
{	
	-- 大厅蓝色横屏
    [1] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
        	{getImage(1, "lobby_header_back01"), cc.p(-0.2, -37), false},
        	{getImage(1, "lobby_header_back01"), cc.p(0.2, -37), true},
        },
        facebook =
        {
            position = cc.p(-601,-32.5),
            button   = {getImage(1, "lobby_facebooktop"), getImage(1, "lobby_facebooktoppressdown"), cc.p(0, 0)},
            red      = {getSpine(1, "red"), cc.p(20, 20), 0.7},
            frame    = {getImage(1, "lobby_logo_frenzy_frame"), cc.p(0, 0), 1},
            loading  = {getImage(1, "lobby_logo_frenzy01"), getImage(1, "lobby_logo_frenzy03"), cc.p(0, 0), 1},
        },
        lobby =
        {
            position = cc.p(-600, -34),
            button = {getImage(1, "lobby_phome"), getImage(1, "lobby_phome_pressdown"), getImage(1, "lobby_phome_pressdown"), cc.p(0, 0)},
        },
        chips =
        {
            position       = cc.p(-486.5, -34.5),
            bg             = {"commonEffect/zuanshi/emerald_bg01.png", "commonEffect/zuanshi/emerald_bg01.png", cc.p(-0.8, -0.5)},
            logo           = {"commonEffect/zuanshi/emerald_img01.png", cc.p(-53, 1.5)},
            label          = {"commonEffect/zuanshi/header_01.fnt", cc.p(15, 0.5), 0.95, 85},
            spine          = {zuanshiSpine("chip"), cc.p(27, 25), 0.6},
            get_spine      = {zuanshiSpine("coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {zuanshiSpine("coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {zuanshiParticle("baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {zuanshiParticle("bs_lz_01_1"), cc.p(0, 0)},
        },
    	coin = 
    	{
            position       = cc.p(-285, -33.5),
    		bg           = {"commonEffect/coin/lobby_jdt_back.png", cc.p(3.5, -2)},
    		coin         = {"commonEffect/coin/lobby_jdt_coin.png", cc.p(-99.5, -1)},
    		label        = {"commonEffect/coin/header_01.fnt", cc.p(17, -1), 0.95, 179},
            spine        = {coinSpine( "coin"), cc.p(17, 27.5)},
            get_spine    = {coinSpine( "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine  = {coinSpine( "coins_fly_start"), cc.p(0, 0)},
            fly_particle = {coinParticle("jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {coinParticle( "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise    = 
            {
                parent= {position = cc.p(0,0)},
                button= {coinCommonImage("kong"), cc.p(0, -78), 8},
                label = {"commonEffect/coin/lobby_video_topfont.fnt", cc.p(28,-75), 1},
                spine = {coinParticle( "ad"), cc.p(0,-78)}
            }
        },
        buy =
        {
            position = cc.p(0, -37),
            buy1 = {getImage(1, "lobby_buy"), getImage(1, "lobby_buy_pressdown"), cc.p(0, -2) }, -- 大buy
            buy2 = {getImage(1, "lobby_buyleft"), getImage(1, "lobby_buyleft_pressdown"), cc.p(-75, -2)}, -- 有礼物盒展示的小buy
            buy3 = {getImage(1, "lobby_buyleft3"), getImage(1, "lobby_buyleft_pressdown3"), cc.p(-75, -2)}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(1, "lobby_deal"), getImage(1, "lobby_deal_pressdown"), cc.p(75, -2) },
                label  = {getFont(1, "dealtime_font01"), cc.p(71, 26.5), 1}, 
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-122, 3), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-122, 3), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-122, 3), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},
            },
            buy_spine = {getSpine(1, "wholebingbing"), cc.p(0, -320)},--这个是单个按钮闪光的动画
            -- buy2_spine = {getSpine(1, "buy2_h"), cc.p(0, -3)},--这个是两个按钮闪光的动画
            spine = {getSpine(1, "wholebingbing"), cc.p(0, -326)},--这个是整体闪光的动画
        },
        hotToday =
        {
            position = cc.p(480, -34),
            button = {getImage(1, "eventoffer_lobby_img01"), getImage(1, "eventoffer_lobby_img01"), cc.p(0, 0)},
            tips   =
            {
                bg    = {getImage(1, "new_playergo_neiwen"), cc.p(-122, -144)},
            },
            spine  = {getSpine(1, "logo"), cc.p(65, 31.5), 0.5},
            count  = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(120, 46), 0.9},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 21), 1},
            },
            loading = {getImage(1, "eventoffer_lobby_img04"), getImage(1, "eventoffer_lobby_img05"), cc.p(0, 0), 1},
        },
        exp = 
        {
            position              = cc.p(280, -34),
            level_up_position     = cc.p(295, -46.5),
            bg                    = {getImage(1, "lobby_header_coins_bg"), cc.p(0, 0)},
            top   = {getImage(1, "lobby_header_coins_bg3"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(1, "booster_bg"), cc.p(7, -31)},
            flash_label_pink_bg   = {getImage(1, "Level_upparty_img02"), getImage(1, "Level_upparty_img03"), cc.p(7, -31)},
            booster_tips =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label  = {getImage(1, "boostme"), cc.p(114, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(110, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 0.95, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(13, -31), 1, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)},
            },
            double =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(1, "top_double_blast"), cc.p(110, 15), 1},
                label2 = {getImage(1, "EVEN"), cc.p(110, 15), 1},
            },
            lounge =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(109, 16), 1},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(109, 16), 1},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(1, "lobby_jdt_blue"), 
                    booster = getImage(1, "lobby_jdt_yellow"), 
                    double  = getImage(1, "lobby_jdt_blue"), 
                    doublexp= getImage(1, "lobby_jdt_blue"), 
                    pos     = cc.p(105, 18)
                },
                range       = {-110, 110},
                position    = cc.p(-105, -18.5),
                size        = cc.size(210, 37),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 210
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-99, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(105, 19.5), "animation2"},
                range       = {0, 210},
                position    = cc.p(-105, -20),
                size        = cc.size(210, 39),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-106, -2)}, 
            -- label    = {getFont(1, "lobby_head01_zit"), cc.p(18, 0)},
            label    = {getFont(1, "header_01"), cc.p(0, -0.5), 0.9},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
    	setting =
    	{
            position = cc.p(600, -34),
    		button = {getImage(1, "lobby_setting"), getImage(1, "lobby_setting_pressdown"), cc.p(0, 0) },
        	bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(1, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1)},
                setting_bg_line1     = {getImage(1, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(1, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(1, "setting_bg_line"), cc.p(-87, -201)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-87, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(1, "setting_bg02"), cc.p(-87, -175) },
                btn_Setting          = {getImage(1, "setting_bg03"), getImage(1, "setting_btn_di"), cc.p(-87, -228)},
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-87, -69)},
                label_music          = {getImage(1, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(1, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(1, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting        = {getImage(1, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(1, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(1, "sound_btn"), cc.p(-10, -69)},
            },
    	},
    },
    -- 金色横屏
    [2] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
            {getImage(2, "lobby_header_back01"), cc.p(-0.2, -37), false},
            {getImage(2, "lobby_header_back01"), cc.p(-0.2, -37), true},
        },
        lobby =
        {
            position = cc.p(-603, -33.5),
            button = {getImage(2, "lobby_phome"), getImage(2, "lobby_phome_pressdown"), getImage(2, "lobby_phome_pressdown"), cc.p(0, 0)},
        },
        coin = 
        {
            position       = cc.p(-285, -33),
            bg             = {getImage(2, "lobby_jdt_back"), cc.p(3.5, -2)},
            coin           = {getImage(1, "lobby_jdt_coin"), cc.p(-99.5, -1)},
            label          = {getFont(8, "header_02"), cc.p(17, -1), 0.95, 179},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      = 
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        chips =
        {
            position       = cc.p(-485, -33),
            bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
            logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(15, -1), 1, 85},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        buy =
        {
            position = cc.p(0, -37),
            buy1 = {getImage(1, "lobby_buy"), getImage(1, "lobby_buy_pressdown"), cc.p(0, -2) }, -- 大buy
            buy2 = {getImage(1, "lobby_buyleft"), getImage(1, "lobby_buyleft_pressdown"), cc.p(-75, -2)}, -- 有礼物盒展示的小buy
            buy3 = {getImage(1, "lobby_buyleft3"), getImage(1, "lobby_buyleft_pressdown3"), cc.p(-75, -2)}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(1, "lobby_deal"), getImage(1, "lobby_deal_pressdown"), cc.p(75, -2) },
                label  = {getFont(1, "dealtime_font01"), cc.p(71, 26.5), 1}, 
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-122, 3), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-122, 3), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-122, 3), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},

            },
            buy_spine = {getSpine(1, "buy_h"), cc.p(0, -3)},--这个是单个按钮闪光的动画
            buy2_spine = {getSpine(1, "buy2_h"), cc.p(0, -3)},--这个是两个按钮闪光的动画
            spine = {getSpine(1, "wholebingbing"), cc.p(0, -3)}--这个是整体闪光的动画
        },
        exp = 
        {
            position              = cc.p(280, -34),
            level_up_position     = cc.p(295, -46.5),
            bg                    = {getImage(2, "lobby_header_coins_bg"), cc.p(0, 0)},
            top   = {getImage(2, "lobby_header_coins_bg3"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(1, "booster_bg"), cc.p(7, -31)},
            flash_label_pink_bg   = {getImage(1, "Level_upparty_img02"), getImage(1, "Level_upparty_img03"), cc.p(7, -31)},
            booster_tips =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label  = {getImage(1, "boostme"), cc.p(114, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(110, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 0.95, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(13, -31), 1, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)},
            },
            double =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(1, "top_double_blast"), cc.p(110, 15), 1},
                label2 = {getImage(1, "EVEN"), cc.p(110, 15), 1},
            },
            lounge =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(109, 16), 1},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(109, 16), 1},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(1, "lobby_jdt_blue"), 
                    booster = getImage(1, "lobby_jdt_yellow"), 
                    double  = getImage(1, "lobby_jdt_blue"), 
                    doublexp= getImage(1, "lobby_jdt_blue"), 
                    pos     = cc.p(105, 18)
                },
                range       = {-110, 110},
                position    = cc.p(-105, -18.5),
                size        = cc.size(210, 37),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 210
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-110, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(105, 19.5), "animation2"},
                range       = {0, 210},
                position    = cc.p(-105, -20),
                size        = cc.size(210, 39),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-106, -2)}, 
            -- label    = {getFont(1, "lobby_head01_zit"), cc.p(18, 0)},
            label    = {getFont(8, "header_02"), cc.p(0, -0.5), 0.9},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-483.5, -35.5),
            bg    = {getImage(2, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese07"), cc.p(-14, -31)},
            wheel = 
            {
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 122
				},
				texture = getImage(5, "lobby_jdt"),
			},
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 0), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(2, "theme_wheel_normal_bg"), cc.p(119, -145.5)},
            wheel_normal1 = {getImage(3, "booster_bg_triangle03"), cc.p(123, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(8, "header_02"), cc.p(0, -13), cc.p(0, 0), 1, 0.5},
            wheel_level   = {getImage(3, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(3, "booster_levelburst_font05"), cc.p(227, 61), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(8, "booster_levelburst_font03"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(2, "zhuanp_hese05"), cc.p(1, 0)},
        },
        -- chips =
        -- {
        --     position       = cc.p(-492.5, -33),
        --     bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
        --     logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
        --     label          = {getFont(8, "lobby_head03_zit"), cc.p(15, -1), 1, 96},
        --     spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
        --     get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
        --     start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
        --     fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
        --     fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
        -- },
        pig =
        {
            position = {cc.p(537, -32), cc.p(488, -32)},
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1, "header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position       = {cc.p(537, -32), cc.p(488, -33.5)},
            bg             = {getImage(2, "vouhcer_bg"), cc.p(0, -1.5)},
            logo           = {getImage(5, "cash_icon2"), cc.p(-59.5, -1)},
            label          = {getFont(8, "header_02"), cc.p(20, -1), 0.85, 179},
        },
        setting =
        {
            position = cc.p(600, -34),
            button = {getImage(2, "lobby_setting"), getImage(2, "lobby_setting_pressdown"), cc.p(0, 0) },
            bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(2, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1), cc.size(281, 323 - 50)},
                setting_bg_line1     = {getImage(8, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(8, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(8, "setting_bg_line"), cc.p(-87, -201)}, 
                -- setting_bg_line4     = {getImage(8, "setting_bg_line"), cc.p(-87, -254)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting           = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-84, -175) },
                -- btn_Setting          = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable          = {getImage(1, "setting_bg03"), getImage(8, "setting_btn_di"), cc.p(-84, -228)},
                -- btn_paytable         = {getImage(1, "setting_bg03"), getImage(8, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(8, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(8, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(8, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting         = {getImage(8, "setting_SETTINGS"), cc.p(-193, -173), cc.p(0, 0.5)},
                -- label_setting        = {getImage(8, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule        = {getImage(2, "setting_GAMERULE02"), cc.p(-193, -226), cc.p(0, 0.5)},
                -- label_gamerule       = {getImage(2, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(8, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(8, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(8, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(8, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(8, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(8, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 紫色竖屏
    [3] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
        	{getImage(3, "lobby_header_back01long"), cc.p(0, -4), true},
        	{getImage(3, "lobby_header_back01long"), cc.p(0, -4), false},
        	{getImage(3, "lobby_header_back02long"), cc.p(-360, -85), true},
        	{getImage(3, "lobby_header_back02long"), cc.p(360, -85), false},
        },
        lobby =
        {
            position = cc.p(-330, -30),
            button = {getImage(5, "lobby_phome"), getImage(5, "lobby_phome_pressdown"), getImage(5, "lobby_phome_pressdown"), cc.p(0, 0), 1},
        },
        coin = 
        {
            position       = cc.p(-203, -31),
            bg             = {getImage(3, "header_purple_frame02shuban04"), cc.p(2, 1)},
            coin           = {getImage(1, "lobby_jdt_coin"), cc.p(-72, 0.5), 0.9},
            label          = {getFont(1, "header_01"), cc.p(16, -0.5), 0.85, 125},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      = 
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        chips =
        {
            position       = cc.p(-203, -31),
            bg             = {getImage(1, "emerald_bg01"), getImage(1, "emerald_bg01"), cc.p(0, 0)},
            logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(15, -1), 1, 85},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        buy =
        {
            position = cc.p(0, -35),
            buy1 = {getImage(3, "lobby_buy"), getImage(3, "lobby_buy_pressdown"), cc.p(0, 0) }, -- 大buy
            buy2 = {getImage(3, "lobby_buyleft"), getImage(3, "lobby_buyleft_pressdown"), cc.p(-51, 0)}, -- 有礼物盒展示的小buy
            buy3 = {getImage(3, "lobby_buyleft3"), getImage(3, "lobby_buyleft_pressdown3"), cc.p(-51, 0)}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(3, "lobby_deal"), getImage(3, "lobby_deal_pressdown"), cc.p(50, 0) },
                label  = {getFont(1, "dealtime_font01"), cc.p(50.5, 25), 1}, 
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-81, 3), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-81, 3), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-81, 3), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},

            },
            buy_spine = {getSpine(1, "buy_v"), cc.p(0, 0)},
            buy2_spine = {getSpine(1, "buy2_v"), cc.p(0, 0)},
            spine = {getSpine(1, "sp_01"), cc.p(0, 6)}--这个是整体闪光的动画
        },
        exp = 
        {
            position              = cc.p(212, -31),
            level_up_position     = cc.p(212, -46.5),
            bg                    = {getImage(3, "header_purple_frame02shuban02"), cc.p(0, 0)},
            top                    = {getImage(3, "header_purple_frame02shuban03"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
            -- flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), cc.p(-6, -28)},
            flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), getImage(3, "lobby_jdt_tips03"), cc.p(-6, -28)},
            booster_tips =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label  = {getImage(1, "boostme"), cc.p(89, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(45, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.78, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.78, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(0, -27), 0.8, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)},
            },
            double =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(1, "top_double_blast"), cc.p(90, 16), 0.83},
                label2 = {getImage(1, "EVEN"), cc.p(90, 16), 0.83},
            },
            lounge =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(90, 16), 0.83},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(90, 16), 0.83},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(3, "lobby_jdt_redlong"), 
                    booster = getImage(3, "lobby_jdt_redlong02"), 
                    double  = getImage(3, "lobby_jdt_redlong"), 
                    doublexp= getImage(3, "lobby_jdt_redlong"), 
                    pos     = cc.p(82, 16.5)
                },
                range       = {-78.5, 78.5},
                position    = cc.p(-82.5, -15.5),
                size        = cc.size(164, 36),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 164
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-83.5, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(78.5, 16.5), "animation1"},
                range       = {0, 157},
                position    = cc.p(-78.5, -16.5),
                size        = cc.size(157, 33),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-78.5, -2), 0.9}, 
            label    = {getFont(1, "header_01"), cc.p(0, -0.5), 0.8, 100},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-309, -86),
            scale = 0.74,
            bg    = {getImage(5, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese07"), cc.p(-14, -31)},
            wheel = 
            {   
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 122
				},
				texture = getImage(5, "lobby_jdt"),
			},
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 0), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(3, "theme_wheel_normal_bg"), cc.p(160, -136)},
            wheel_normal1 = {getImage(3, "booster_bg_triangle03"), cc.p(65, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(1, "header_01"), cc.p(0, -13), cc.p(0, 0), 1, 0.5},
            wheel_level   = {getImage(3, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(3, "booster_levelburst_font05"), cc.p(227, 61), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(8, "booster_levelburst_font03"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(5, "zhuanp_hese05"), cc.p(1, 0)},
        },
        -- chips =
        -- {
        --     position       = cc.p(-492.5, -33),
        --     bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
        --     logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
        --     label          = {getFont(8, "lobby_head03_zit"), cc.p(15, -1), 1, 96},
        --     spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
        --     get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
        --     start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
        --     fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
        --     fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
        -- },
        pig =
        {
            position = {cc.p(333, -84), cc.p(325, -84)},
            zorder   = HEADER_ZORDER.ICON_BOTTOM,
            scale    = 0.75,
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1,"header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position = {cc.p(333, -84), cc.p(325, -86)},
            zorder   = HEADER_ZORDER.ICON_BOTTOM,
            scale    = 0.75,
            bg       = {getImage(1, "emerald_bg01"), cc.p(-15, 0)},
            logo     = {getImage(5, "cash_icon2"), cc.p(-75, -1)},
            label    = {getFont(1, "header_01"), cc.p(-6, -1), 0.75, 60},
        },
        setting =
        {
            position = cc.p(332, -30),
            button = {getImage(3, "lobby_setting"), getImage(3, "lobby_setting_pressdown"), cc.p(0, 0), 1},
            bar = {
                position             = cc.p(-10, -20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(3, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1), cc.size(281, 323 - 50)},
                setting_bg_line1     = {getImage(3, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(3, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(3, "setting_bg_line"), cc.p(-87, -201)}, 
                setting_bg_line4     = {getImage(3, "setting_bg_line"), cc.p(-87, -254)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                -- btn_Setting          = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable          = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -228)},
                -- btn_paytable         = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(3, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(3, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(3, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting         = {getImage(3, "setting_SETTINGS"), cc.p(-193, -173), cc.p(0, 0.5)},
                -- label_setting        = {getImage(3, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule        = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -226), cc.p(0, 0.5)},
                -- label_gamerule       = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 紫色横屏
    [5] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
        	{getImage(1, "lobby_header_back01"), cc.p(-0.2, -37), false},
        	{getImage(1, "lobby_header_back01"), cc.p(0.2, -37), true},
        },
        lobby =
        {
            position = cc.p(-603, -33.5),
            button = {getImage(5, "lobby_phome"), getImage(5, "lobby_phome_pressdown"), getImage(5, "lobby_phome_pressdown"), cc.p(0, 0)},
        },
        coin = 
        {
            position       = cc.p(-285, -33.5),
    		bg           = {getImage(1, "lobby_jdt_back"), cc.p(3.5, -2)},
    		coin         = {getImage(1, "lobby_jdt_coin"), cc.p(-99.5, -1)},
    		label        = {getFont(1, "header_01"), cc.p(17, -1), 0.95, 179},
            spine        = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine    = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine  = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise    = 
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        chips =
        {
            position       = cc.p(-485, -33),
            bg             = {getImage(1, "emerald_bg01"), getImage(1, "emerald_bg01"), cc.p(0, 0)},
            logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(15, -1), 1, 85},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        buy =
        {
            position = cc.p(0, -37),
            buy1 = {getImage(1, "lobby_buy"), getImage(1, "lobby_buy_pressdown"), cc.p(0, -2) }, -- 大buy
            buy2 = {getImage(1, "lobby_buyleft"), getImage(1, "lobby_buyleft_pressdown"), cc.p(-75, -2)}, -- 有礼物盒展示的小buy
            buy3 = {getImage(1, "lobby_buyleft3"), getImage(1, "lobby_buyleft_pressdown3"), cc.p(-75, -2)}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(1, "lobby_deal"), getImage(1, "lobby_deal_pressdown"), cc.p(75, -2) },
                label  = {getFont(1, "dealtime_font01"), cc.p(71, 26.5), 1}, 
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-122, 3), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-122, 3), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-122, 3), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},

            },
            buy_spine = {getSpine(1, "wholebingbing"), cc.p(0, -320)},--这个是单个按钮闪光的动画
            -- buy2_spine = {getSpine(1, "buy2_h"), cc.p(0, -3)},--这个是两个按钮闪光的动画
            spine = {getSpine(1, "wholebingbing"), cc.p(0, -326)},--这个是整体闪光的动画
        },
        exp = 
        {
            position              = cc.p(280, -34),
            level_up_position     = cc.p(295, -46.5),
            bg                    = {getImage(1, "lobby_header_coins_bg"), cc.p(0, 0)},
            top   = {getImage(1, "lobby_header_coins_bg3"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(1, "booster_bg"), cc.p(7, -31)},
            flash_label_pink_bg   = {getImage(1, "Level_upparty_img02"), getImage(1, "Level_upparty_img03"), cc.p(7, -31)},
            booster_tips =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label  = {getImage(1, "boostme"), cc.p(114, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(110, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 0.95, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(13, -31), 1, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)},
            },
            double =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(1, "top_double_blast"), cc.p(110, 15), 1},
                label2 = {getImage(1, "EVEN"), cc.p(110, 15), 1},
            },
            lounge =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(109, 16), 1},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(109, 16), 1},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(1, "lobby_jdt_blue"), 
                    booster = getImage(1, "lobby_jdt_yellow"), 
                    double  = getImage(1, "lobby_jdt_blue"), 
                    doublexp= getImage(1, "lobby_jdt_blue"), 
                    pos     = cc.p(105, 18)
                },
                range       = {-110, 110},
                position    = cc.p(-105, -18.5),
                size        = cc.size(210, 37),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 210
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-110, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(105, 19.5), "animation2"},
                range       = {0, 210},
                position    = cc.p(-105, -20),
                size        = cc.size(210, 39),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-106, -2)}, 
            -- label    = {getFont(1, "lobby_head01_zit"), cc.p(18, 0)},
            label    = {getFont(1, "header_01"), cc.p(0, -0.5), 0.9},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-483.5, -35.5),
            bg    = {getImage(5, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese07"), cc.p(-14, -31)},
            wheel = 
            {
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 122
				},
				texture = getImage(5, "lobby_jdt"),
			},
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 0), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(3, "theme_wheel_normal_bg"), cc.p(119, -145.5)},
            wheel_normal1 = {getImage(3, "booster_bg_triangle03"), cc.p(123, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(1, "header_01"), cc.p(0, -13), cc.p(0, 0), 1, 0.5},
            wheel_level   = {getImage(3, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(3, "booster_levelburst_font05"), cc.p(227, 61), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(8, "booster_levelburst_font03"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(5, "zhuanp_hese05"), cc.p(1, 0)},
        },
        -- chips =
        -- {
        --     position       = cc.p(-492.5, -33),
        --     bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
        --     logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
        --     label          = {getFont(8, "lobby_head03_zit"), cc.p(15, -1), 1, 96},
        --     spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
        --     get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
        --     start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
        --     fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
        --     fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
        -- },
        pig =
        {
            position = {cc.p(537, -32), cc.p(477, -32)},
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1,"header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position       = {cc.p(537, -32), cc.p(488, -33.5)},
            bg             = {getImage(5, "vouhcer_bg"), cc.p(0, -1.5)},
            logo           = {getImage(5, "cash_icon2"), cc.p(-59.5, -1)},
            label          = {getFont(1, "header_01", false), cc.p(20, -1), 0.85, 95},
        },
        setting =
        {
            position = cc.p(600, -34),
            button = {getImage(3, "lobby_setting"), getImage(3, "lobby_setting_pressdown"), cc.p(0, 0)},
            bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(3, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1), cc.size(281, 323 - 50)},
                setting_bg_line1     = {getImage(3, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(3, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(3, "setting_bg_line"), cc.p(-87, -201)}, 
                setting_bg_line4     = {getImage(3, "setting_bg_line"), cc.p(-87, -254)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                -- btn_Setting          = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable          = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -228)},
                -- btn_paytable         = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(3, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(3, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(3, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting         = {getImage(3, "setting_SETTINGS"), cc.p(-193, -173), cc.p(0, 0.5)},
                -- label_setting        = {getImage(3, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule        = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -226), cc.p(0, 0.5)},
                -- label_gamerule       = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 金色竖屏
    [7] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
        	{getImage(7, "header_bg_golden"), cc.p(0, -4), true},
        	{getImage(7, "header_bg_golden"), cc.p(0, -4), false},
        	{getImage(7, "header_bg_golden02"), cc.p(-360, -85), true},
        	{getImage(7, "header_bg_golden02"), cc.p(360, -85), false},
        },
        lobby =
        {
            position = cc.p(-330, -30),
            button = {getImage(2, "lobby_phome"), getImage(2, "lobby_phome_pressdown"), getImage(2, "lobby_phome_pressdown"), cc.p(0, 0), 1},
        },
        coin = 
        {
            position       = cc.p(-203, -31),
            bg             = {getImage(7, "lobby_coin_bg"), cc.p(2, 1)},
            coin           = {getImage(1, "lobby_jdt_coin"), cc.p(-72, 0.5), 0.9},
            label          = {getFont(8, "header_02"), cc.p(16, -0.5), 1, 125},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      = 
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        chips =
        {
            position       = cc.p(-203, -31),
            bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
            logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
            label          = {getFont(8, "lobby_head03_zit"), cc.p(15, -1), 1, 85},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        buy =
        {
            position = cc.p(0, -35),
            buy1 = {getImage(3, "lobby_buy"), getImage(3, "lobby_buy_pressdown"), cc.p(0, 0) }, -- 大buy
            buy2 = {getImage(3, "lobby_buyleft"), getImage(3, "lobby_buyleft_pressdown"), cc.p(-51.5, 0.5)}, -- 有礼物盒展示的小buy
            buy3 = {getImage(3, "lobby_buyleft3"), getImage(3, "lobby_buyleft_pressdown3"), cc.p(-51.5, 0.5)}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(3, "lobby_deal"), getImage(3, "lobby_deal_pressdown"), cc.p(51.5, 0.5) },
                label  = {getFont(1, "dealtime_font01"), cc.p(50.5, 25), 1}, 
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-81, 3), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-81, 3), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-81, 3), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},

            },
            buy_spine = {getSpine(1, "buy_v"), cc.p(0, 0)},
            buy2_spine = {getSpine(1, "buy2_v"), cc.p(0, 0)},
            spine = {getSpine(1, "sp_01"), cc.p(0, 6)}--这个是整体闪光的动画
        },
        exp = 
        {
            position              = cc.p(212, -31),
            level_up_position     = cc.p(212, -46.5),
            bg                    = {getImage(7, "header_purple_frame02shuban02"), cc.p(0, 0)},
            top                   = {getImage(7, "header_purple_frame02shuban03"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
            -- flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), cc.p(-6, -28)},
            flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), getImage(3, "lobby_jdt_tips03"), cc.p(-6, -28)},
            booster_tips =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label  = {getImage(1, "boostme"), cc.p(89, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(45, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.78, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.78, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(0, -27), 0.83, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)},
            },
            double =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(1, "top_double_blast"), cc.p(90, 16), 0.83},
                label2 = {getImage(1, "EVEN"), cc.p(90, 16), 0.8},
            },
            lounge =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(90, 16), 0.83},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(90, 16), 0.83},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(3, "lobby_jdt_redlong"), 
                    booster = getImage(3, "lobby_jdt_redlong02"), 
                    double  = getImage(3, "lobby_jdt_redlong"), 
                    doublexp= getImage(3, "lobby_jdt_redlong"), 
                    pos     = cc.p(82, 16.5)
                },
                range       = {-78.5, 78.5},
                position    = cc.p(-82.5, -15.5),
                size        = cc.size(164, 36),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 164
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-83.5, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(78.5, 16.5), "animation1"},
                range       = {0, 157},
                position    = cc.p(-78.5, -16.5),
                size        = cc.size(157, 33),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-78.5, -2), 0.9}, 
            label    = {getFont(8, "header_02"), cc.p(0, -0.5), 0.8, 100},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-309, -86),
            scale = 0.74,
            bg    = {getImage(2, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese07"), cc.p(-14, -31)},
            wheel = 
            {   
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 122
				},
				texture = getImage(5, "lobby_jdt"),
			},
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 0), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(2, "theme_wheel_normal_bg"), cc.p(160, -136)},
            wheel_normal1 = {getImage(8, "booster_bg_triangle"), cc.p(65, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(8, "header_02"), cc.p(0, -13), cc.p(0, 0), 1, 0.5},
            wheel_level   = {getImage(2, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(8, "booster_levelburst_font03"), cc.p(-178, 12), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(2, "booster_levelburst_font04"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(2, "zhuanp_hese05"), cc.p(1, 0)},
        },
        -- chips =
        -- {
        --     position       = cc.p(-492.5, -33),
        --     bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
        --     logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
        --     label          = {getFont(8, "lobby_head03_zit"), cc.p(15, -1), 1, 96},
        --     spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
        --     get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
        --     start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
        --     fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
        --     fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
        -- },
        pig =
        {
            position = {cc.p(333, -84), cc.p(325, -84)},
            zorder   = HEADER_ZORDER.ICON_BOTTOM,
            scale    = 0.75,
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1,"header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position = {cc.p(333, -84), cc.p(325, -86)},
            zorder   = HEADER_ZORDER.ICON_BOTTOM,
            scale    = 0.75,
            bg       = {getImage(8, "emerald_bg01"), cc.p(-15, 0)},
            logo     = {getImage(5, "cash_icon2"), cc.p(-75, -1)},
            label    = {getFont(8, "header_02"), cc.p(-6, -1), 0.75, 60},
        },
        setting =
        {
            position = cc.p(332, -30),
            button = {getImage(2, "lobby_setting"), getImage(2, "lobby_setting_pressdown"), cc.p(0, 0), 1},
            bar = {
                position             = cc.p(-10, -20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(2, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1), cc.size(281, 323 - 50)},
                setting_bg_line1     = {getImage(8, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(8, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(8, "setting_bg_line"), cc.p(-87, -201)}, 
                setting_bg_line4     = {getImage(8, "setting_bg_line"), cc.p(-87, -254)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting           = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-84, -175) },
                -- btn_Setting          = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable          = {getImage(1, "setting_bg03"), getImage(8, "setting_btn_di"), cc.p(-84, -228)},
                -- btn_paytable         = {getImage(1, "setting_bg03"), getImage(8, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(8, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(8, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(8, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting         = {getImage(8, "setting_SETTINGS"), cc.p(-193, -173), cc.p(0, 0.5)},
                -- label_setting        = {getImage(8, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule        = {getImage(2, "setting_GAMERULE02"), cc.p(-193, -226), cc.p(0, 0.5)},
                -- label_gamerule       = {getImage(2, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(8, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(8, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 大厅金色横屏
    [8] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
        	{getImage(8, "lobby_header_back01"), cc.p(-0.2, -37), false},
        	{getImage(8, "lobby_header_back01"), cc.p(0.2, -37), true},
        },
        facebook =
        {
            position = cc.p(-601,-32.5),
            button   = {getImage(1, "lobby_facebooktop"), getImage(1, "lobby_facebooktoppressdown"), cc.p(0, 0)},
            red      = {getSpine(1, "red"), cc.p(20, 20), 0.7},
            frame    = {getImage(8, "lobby_logo_frenzy_frame"), cc.p(0, 0), 1},
            loading  = {getImage(1, "lobby_logo_frenzy01"), getImage(1, "lobby_logo_frenzy03"), cc.p(0, 0), 1},
        },
        lobby =
        {
            position = cc.p(-600, -34),
            button = {getImage(8, "lobby_phome"), getImage(8, "lobby_phome_pressdown"), getImage(8, "lobby_phome_pressdown"), cc.p(0, 0)},
        },
        chips =
        {
            position       = cc.p(-486.5, -34.5),
            bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(-0.8, -0.5)},
            logo           = {getImage(1, "emerald_img01"), cc.p(-53, 1.5)},
            label          = {getFont(8, "header_02"), cc.p(15, 0.5), 0.95, 85},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        coin = 
        {
            position       = cc.p(-285, -33.5),
            bg             = {getImage(8, "lobby_jdt_back"), cc.p(3.5, -2)},
            coin           = {getImage(1, "lobby_jdt_coin"), cc.p(-99.5, -1)},
    		label          = {getFont(8, "header_02"), cc.p(17, -1), 0.95, 179},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      = 
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        buy =
        {
            position = cc.p(0, -37),
            buy1 = {getImage(1, "lobby_buy"), getImage(1, "lobby_buy_pressdown"), cc.p(0, -2) }, -- 大buy
            buy2 = {getImage(1, "lobby_buyleft"), getImage(1, "lobby_buyleft_pressdown"), cc.p(-75, -2)}, -- 有礼物盒展示的小buy
            buy3 = {getImage(1, "lobby_buyleft3"), getImage(1, "lobby_buyleft_pressdown3"), cc.p(-75, -2)}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(1, "lobby_deal"), getImage(1, "lobby_deal_pressdown"), cc.p(75, -2) },
                label  = {getFont(1, "dealtime_font01"), cc.p(71, 26.5), 1}, 
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-122, 3), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-122, 3), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-122, 3), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},
            },
            buy_spine = {getSpine(1, "wholebingbing"), cc.p(0, -320)},--这个是单个按钮闪光的动画
            -- buy2_spine = {getSpine(1, "buy2_h"), cc.p(0, -3)},--这个是两个按钮闪光的动画
            spine = {getSpine(1, "wholebingbing"), cc.p(0, -326)},--这个是整体闪光的动画
        },
        hotToday =
        {
            position = cc.p(480, -34),
            button = {getImage(1, "eventoffer_lobby_img01"), getImage(1, "eventoffer_lobby_img01"), cc.p(0, 0)},
            tips   =
            {
                bg    = {getImage(1, "new_playergo_neiwen"), cc.p(-122, -144)},
            },
            spine  = {getSpine(1, "logo"), cc.p(65, 31.5), 0.5},
            count  = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(120, 46), 0.9},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 21), 1},
            },
            loading = {getImage(1, "eventoffer_lobby_img04"), getImage(1, "eventoffer_lobby_img05"), cc.p(0, 0), 1},
        },
        exp = 
        {
            position              = cc.p(280, -34),
            level_up_position     = cc.p(295, -46.5),
            bg                    = {getImage(8, "lobby_header_coins_bg"), cc.p(0, 0)},
            top   = {getImage(8, "lobby_header_coins_bg3"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(1, "booster_bg"), cc.p(7, -31)},
            flash_label_pink_bg   = {getImage(1, "Level_upparty_img02"), getImage(1, "Level_upparty_img03"), cc.p(7, -31)},
            booster_tips =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label  = {getImage(1, "boostme"), cc.p(114, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(110, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 0.95, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(13, -31), 1, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)},
            },
            double =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(1, "top_double_blast"), cc.p(110, 15), 1},
                label2 = {getImage(1, "EVEN"), cc.p(110, 15), 1},
            },
            lounge =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(109, 16), 1},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(109, 16), 1},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(1, "lobby_jdt_blue"), 
                    booster = getImage(1, "lobby_jdt_yellow"), 
                    double  = getImage(1, "lobby_jdt_blue"), 
                    doublexp= getImage(1, "lobby_jdt_blue"), 
                    pos     = cc.p(105, 18)
                },
                range       = {-110, 110},
                position    = cc.p(-105, -18.5),
                size        = cc.size(210, 37),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 210
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-99, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(105, 19.5), "animation2"},
                range       = {0, 210},
                position    = cc.p(-105, -20),
                size        = cc.size(210, 39),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-106, -2)}, 
            -- label    = {getFont(1, "lobby_head01_zit"), cc.p(18, 0)},
            label    = {getFont(8, "header_02"), cc.p(0, -0.5), 0.9},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        setting =
        {
            position = cc.p(600, -34),
            button = {getImage(8, "lobby_setting"), getImage(8, "lobby_setting_pressdown"), cc.p(0, 0) },
            bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(8, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1)},
                setting_bg_line1     = {getImage(8, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(8, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(8, "setting_bg_line"), cc.p(-87, -201)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-87, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(8, "setting_bg02"), cc.p(-87, -175) },
                btn_Setting          = {getImage(1, "setting_bg03"), getImage(8, "setting_btn_di"), cc.p(-87, -228)},
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-87, -69)},
                label_music          = {getImage(8, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(8, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(8, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting        = {getImage(8, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(8, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(8, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(8, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(8, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(8, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(8, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 绿色竖屏
    [9] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
            nil,
            nil,
            nil,
            nil,
            {getImage(9, "mansion_ingame_shu_bg03"), cc.p(0, 10.5), true},
            {getImage(9, "mansion_ingame_shu_bg04"), cc.p(0, -85), true},
        },
        lobby =
        {
            position = cc.p(-332, -35),
            button = {getImage(9, "mansion_ingame_btn01"), getImage(9, "mansion_ingame_btn02"), getImage(9, "mansion_ingame_btn02"), cc.p(0, 0), 0.82},
        },
        coin = 
        {
            position       = cc.p(-225, -34),
            bg             = {getImage(9, "mansion_ingame_img01"), cc.p(0, 0)},
            coin           = {getImage(9, "mansion_ingame_icon01"), cc.p(-58, 0), 1},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(1, -1), 1, 68},
            plus           = {getImage(9, "mansion_ingame_btn03"), getImage(9, "mansion_ingame_btn04"), cc.p(59, 0)},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      = 
            {
                tip         = {getImage(1, "bf_popup_img01", true), cc.p(120, 100)},
                ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            },
        },
        chips =
        {
            position       = cc.p(-56, -34),
            bg             = {getImage(9, "mansion_ingame_img01"), getImage(9, "mansion_ingame_img01"), cc.p(0, 0)},
            logo           = {getImage(9, "mansion_ingame_icon02"), cc.p(-58, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(1, -1), 1, 68},
            plus           = {getImage(9, "mansion_ingame_btn03"), getImage(9, "mansion_ingame_btn04"), cc.p(59, 0)},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        mansion_star = {
            position       = cc.p(89, -34),
            bg             = {getImage(9, "mansion_ingame_img10"), cc.p(0, 0)},
            logo           = {getImage(9, "mansion_ingame_icon03"), cc.p(-38, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(15, -1), 1, 60},
        },
        exp = 
        {
            position              = cc.p(227, -34),
            level_up_position     = cc.p(227, -49.5),
            bg                    = {getImage(9, "mansion_ingame_bar05"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(3, "lobby_jdt_tips"), cc.p(7, -31)},
            -- flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), cc.p(-6, -28)},
            flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), getImage(3, "lobby_jdt_tips03"), cc.p(-6, -28)},
            booster_tips =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label  = {getImage(1, "boostme"), cc.p(89, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(45, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                },
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.78, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.78, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(0, -27), 0.8, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)},
            },
            double =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(1, "top_double_blast"), cc.p(90, 16), 0.83},
                label2 = {getImage(1, "EVEN"), cc.p(90, 16), 0.83},
            },
            lounge =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(90, 16), 0.83},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(90, 16), 0.83},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(9, "mansion_ingame_bar04"), 
                    booster = getImage(9, "mansion_ingame_bar04"), 
                    double  = getImage(9, "mansion_ingame_bar04"), 
                    doublexp= getImage(9, "mansion_ingame_bar04"), 
                    pos     = cc.p(73, 18.5)
                },
                range       = {-73, 73},
                position    = cc.p(-73, -17),
                size        = cc.size(146, 37),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 146
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},

            animNode =
            {
                node        = cc.p(-73, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(73, 16.5), "animation1"},
                range       = {0, 157},
                position    = cc.p(-78.5, -16.5),
                size        = cc.size(157, 33),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-73, 0), 0.9}, 
            label    = {getFont(1, "lobby_head01_zit"), cc.p(0, 0), 1, 78},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-309, -86),
            scale = 0.74,
            bg    = {getImage(5, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese020"), cc.p(-14, -31)},
            wheel = 
            {   
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 122
				},
				texture = getImage(5, "lobby_jdt"),
			},
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 0), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(3, "theme_wheel_normal_bg"), cc.p(160, -136)},
            wheel_normal1 = {getImage(3, "booster_bg_triangle03"), cc.p(65, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(1, "header_01"), cc.p(0, -13), cc.p(0, 0), 1, 0.5},
            wheel_level   = {getImage(3, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(3, "booster_levelburst_font05"), cc.p(227, 61), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(8, "booster_levelburst_font03"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(5, "zhuanp_hese05"), cc.p(1, 0)},
        },
        pig =
        {
            position = {cc.p(333, -84), cc.p(325, -84)},
            zorder   = HEADER_ZORDER.ICON_BOTTOM,
            scale    = 0.75,
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1,"header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position = {cc.p(333, -84), cc.p(325, -86)},
            zorder   = HEADER_ZORDER.ICON_BOTTOM,
            scale    = 0.75,
            bg       = {getImage(1, "emerald_bg01"), cc.p(-15, 0)},
            logo     = {getImage(5, "cash_icon2"), cc.p(-75, -1)},
            label    = {getFont(1, "header_01"), cc.p(-6, -1), 0.75, 60},
        },
        setting =
        {
            position = cc.p(332, -35),
            button = {getImage(9, "mansion_ingame_btn05"), getImage(9, "mansion_ingame_btn06"), cc.p(0, 0), 0.82},
            bar = {
                position             = cc.p(-10, -20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(3, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1), cc.size(281, 323 - 50)},
                setting_bg_line1     = {getImage(3, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(3, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(3, "setting_bg_line"), cc.p(-87, -201)}, 
                setting_bg_line4     = {getImage(3, "setting_bg_line"), cc.p(-87, -254)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                -- btn_Setting          = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable          = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -228)},
                -- btn_paytable         = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(3, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(3, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(3, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting         = {getImage(3, "setting_SETTINGS"), cc.p(-193, -173), cc.p(0, 0.5)},
                -- label_setting        = {getImage(3, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule        = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -226), cc.p(0, 0.5)},
                -- label_gamerule       = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 绿色横屏
    [10] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background = 
        {
            nil,
            nil,
            nil,
            nil,
            {getImage(10, "mansion_ingame_img03"), cc.p(0, -39), true},
        },
        lobby =
        {
            position = cc.p(-600, -34),
            button = {getImage(9, "mansion_ingame_btn01"), getImage(9, "mansion_ingame_btn02"), getImage(9, "mansion_ingame_btn02"), cc.p(0, 0), 1},
        },
        coin = 
        {
            position       = cc.p(-350, -33),
            bg             = {getImage(9, "mansion_ingame_img01"), cc.p(0, 0)},
            coin           = {getImage(9, "mansion_ingame_icon01"), cc.p(-58, 0)},
            label          = {getFont(5, "coins_font04", true), cc.p(1, -1), 0.85, 68},
            plus           = {getImage(9, "mansion_ingame_btn03"), getImage(9, "mansion_ingame_btn04"), cc.p(59, -2)},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      = 
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        chips =
        {
            position       = cc.p(-179, -33),
            bg             = {getImage(9, "mansion_ingame_img01"), getImage(9, "mansion_ingame_img01"), cc.p(0, 0)},
            logo           = {getImage(9, "mansion_ingame_icon02"), cc.p(-58, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(1, -1), 1, 68},
            plus           = {getImage(9, "mansion_ingame_btn03"), getImage(9, "mansion_ingame_btn04"), cc.p(59, -2)},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        mansion_star = {
            position       = cc.p(-29, -33),
            bg             = {getImage(9, "mansion_ingame_img10"), cc.p(0, 0)},
            logo           = {getImage(9, "mansion_ingame_icon03"), cc.p(-38, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(15, -1), 1, 60},
        },
        exp = 
        {
            position              = cc.p(114, -31),
            level_up_position     = cc.p(114, -45.5),
            bg                    = {getImage(9, "mansion_ingame_bar05"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
            -- flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), cc.p(-6, -28)},
            flash_label_pink_bg   = {getImage(3, "lobby_jdt_tips02"), getImage(3, "lobby_jdt_tips03"), cc.p(-6, -28)},
            booster_tips =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label  = {getImage(1, "boostme"), cc.p(89, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(45, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                },
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.78, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), 0.83},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.78, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(0, -27), 0.8, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(0, -27), 0.83, getFont(1, "Level_upparty_booster_fnt02"), cc.p(0, -27)},
            },
            double =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(1, "top_double_blast"), cc.p(90, 16), 0.83},
                label2 = {getImage(1, "EVEN"), cc.p(90, 16), 0.83},
            },
            lounge =
            {
                bg     = {getImage(3, "lobby_jdt_tips"), cc.p(-6, -28)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(90, 16), 0.83},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(90, 16), 0.83},
            },
            progress = 
            {
                normalImage = 
                {
                    normal  = getImage(9, "mansion_ingame_bar04"), 
                    booster = getImage(9, "mansion_ingame_bar04"), 
                    double  = getImage(9, "mansion_ingame_bar04"), 
                    doublexp= getImage(9, "mansion_ingame_bar04"), 
                    pos     = cc.p(73, 18.5)
                },
                range       = {-73, 73},
                position    = cc.p(-73, -18),
                size        = cc.size(146, 37),
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 16,
					y = 0
				},
				content_size = {
					height = 36,
					width = 146
				},
				texture = getImage(1, "lobby_header_bar02"),
                normal = getImage(1, "lobby_header_bar02"),
                booster = getImage(1, "lobby_header_bar01"),
			},
            animNode =
            {
                node        = cc.p(-73, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  = 
            {
                image       = {getSpine(1, "exp"), cc.p(73, 18.5), "animation1"},
                range       = {0, 146},
                position    = cc.p(-73, -17),
                size        = cc.size(146, 37),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-73, 0)}, 
            label    = {getFont(1, "lobby_head01_zit"), cc.p(0, 0)},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-500, -31),
            bg    = {getImage(5, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese020"), cc.p(-14, -31)},
            wheel = 
            {   
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            newProgress = 
            {
				cap_insets = {
					height = 36,
					width = 4,
					x = 18,
					y = 0
				},
				content_size = {
					height = 36,
					width = 122
				},
				texture = getImage(5, "lobby_jdt"),
			},
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 0), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(3, "theme_wheel_normal_bg"), cc.p(119, -145.5)},
            wheel_normal1 = {getImage(3, "booster_bg_triangle03"), cc.p(123, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(1, "header_01"), cc.p(0, -13), cc.p(0, 0), 1, 0.5},
            wheel_level   = {getImage(3, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(3, "booster_levelburst_font05"), cc.p(227, 61), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(8, "booster_levelburst_font03"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(5, "zhuanp_hese05"), cc.p(1, 0)},
        },
        pig =
        {
            position = {cc.p(544, -32), cc.p(504, -32)},
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1,"header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position       = {cc.p(537, -32), cc.p(488, -33.5)},
            bg             = {getImage(5, "vouhcer_bg"), cc.p(0, -1.5)},
            logo           = {getImage(5, "cash_icon2"), cc.p(-59.5, -1)},
            label          = {getFont(1, "header_01", false), cc.p(20, -1), 0.85, 95},
        },
        mansion_quest = {
            position = cc.p(329, -34),
            bg = {getImage(10, "mansion_ingame_task_img13"), cc.p(0, 0), 1, 1},
            logo = {getImage(10, "mansion_ingame_task_img12"), cc.p(-68, 3), 1, 1},
            label = {getFont(10, "mansion_ingame_fnt02"), cc.p(10, 2), 1.2, 60},
            plus = {getImage(9, "mansion_ingame_btn03"), getImage(9, "mansion_ingame_btn04"), cc.p(68, 0)},
        },
        setting =
        {
            position = cc.p(600, -35),
            button = {getImage(9, "mansion_ingame_btn05"), getImage(9, "mansion_ingame_btn06"), cc.p(0, 0)},
            bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(3, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1), cc.size(281, 323 -50)},
                setting_bg_line1     = {getImage(3, "setting_bg_line"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getImage(3, "setting_bg_line"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getImage(3, "setting_bg_line"), cc.p(-87, -201)}, 
                setting_bg_line4     = {getImage(3, "setting_bg_line"), cc.p(-87, -254)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                -- btn_Setting          = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable          = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -228)},
                -- btn_paytable         = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(3, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(3, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(3, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting         = {getImage(3, "setting_SETTINGS"), cc.p(-193, -173), cc.p(0, 0.5)},
                -- label_setting        = {getImage(3, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule        = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -226), cc.p(0, 0.5)},
                -- label_gamerule       = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- 紫色横屏 + 紫色大厅按钮 
    [11] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background =
        {
            {getImage(5, "lobby_header_back01"), cc.p(0, -39), true},
            {getImage(5, "lobby_header_back01"), cc.p(0, -39), false},
        },
        lobby =
        {
            position = cc.p(-600, -34),
            button = {getImage(11, "lobby_phome"), getImage(11, "lobby_phome_pressdown"), getImage(5, "lobby_phome_pressdown"), cc.p(0, 0)},
        },
        coin =
        {
            position       = cc.p(-285, -33),
            bg             = {getImage(5, "lobby_jdt_back"), cc.p(0, 0)},
            coin           = {getImage(1, "lobby_jdt_coin"), cc.p(-96.5, 1)},
            label          = {getFont(5, "coins_font04", true), cc.p(18, -1), 0.85, 179},
            spine          = {getSpine(1, "coin"), cc.p(17, 27.5)},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(23.5,22.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "jinbilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
            advertise      =
            {
                parent= {position = cc.p(0,0)},
                button= {getCommonImage("kong"), cc.p(0, -78), 8},
                label = {getFont(1, "lobby_video_topfont"), cc.p(28,-75), 1},
                spine = {getSpine(1, "ad"), cc.p(0,-78)}
            }
        },
        chips =
        {
            position       = cc.p(-485, -33),
            bg             = {getImage(1, "emerald_bg01"), getImage(1, "emerald_bg01"), cc.p(0, 0)},
            logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
            label          = {getFont(1, "lobby_head02_zit"), cc.p(15, -1), 1, 85},
            spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
            get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
            start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
            fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
            fly_particle_2 = {getParticle(1, "bs_lz_01_1"), cc.p(0, 0)},
        },
        buy =
        {
            position = cc.p(0, -38),
            buy1 = {getImage(1, "lobby_buy"), getImage(1, "lobby_buy_pressdown"), cc.p(0, 8), 1}, -- 大buy
            buy2 = {getImage(1, "lobby_buyleft"), getImage(1, "lobby_buyleft_pressdown"), cc.p(-75, 8), 1}, -- 有礼物盒展示的小buy
            buy3 = {getImage(1, "lobby_buyleft3"), getImage(1, "lobby_buyleft_pressdown3"), cc.p(-75, 8), 1}, -- 没礼物盒展示的小buy
            deal =
            {
                button = {getImage(1, "lobby_deal"), getImage(1, "lobby_deal_pressdown"), cc.p(74.5, 8), 1},
                label  = {getFont(1, "dealtime_font01"), cc.p(69, 28.5), 1},
            },
            gift = -- 这个没有修改
            {
                giftSpine   = {getSpine(1, "gift"), cc.p(-115, 15), 1},--这个应该是心形礼物动画
                saleSpine   = {getSpine(1, "sale"), cc.p(-115, 15), 1},
                couponSpine = {getSpine(1, "coupon"), cc.p(-115, 15), 1},
                giftRed     = {getImage(1, "icon_red"), cc.p(19, 15), 0.55},

            },
            spine = {getSpine(1, "wholebingbing"), cc.p(0, -3)}--这个是整体闪光的动画
        },
        exp =
        {
            position              = cc.p(305, -31),
            level_up_position     = cc.p(295, -46.5),
            bg                    = {getImage(5, "lobby_header_coins_bg"), cc.p(0, 0)},
            flash_label_normal_bg = {getImage(1, "booster_bg"), cc.p(7, -31)},
            -- flash_label_pink_bg   = {getImage(1, "Level_upparty_img02"), cc.p(7, -31)},
            flash_label_pink_bg   = {getImage(1, "Level_upparty_img02"), getImage(1, "Level_upparty_img03"), cc.p(7, -31)},
            booster_tips =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label  = {getImage(1, "boostme"), cc.p(114, 15)},
                tips   =
                {
                    bg = {getImage(8, "booster_tipbg"), cc.p(110, -120)},
                    bg1 = {getImage(8, "booster_bg_triangle"), cc.p(196, 213)},
                    labels =
                    {
                        {getFont(8, "booster_levelburst_font03"), "GET", cc.p(126, 172)},
                        {getFont(2, "booster_levelburst_font04"), "X25", cc.p(175, 172)},
                        {getFont(8, "booster_levelburst_font03"), "ON YOUR", cc.p(250, 172)},
                        {getFont(8, "booster_levelburst_font03"), "NEXT LEVEL UP BONUS", cc.p(201, 143)},
                        {getFont(8, "booster_levelburst_font03"), "WITH", cc.p(122, 114)},
                        {getFont(2, "booster_levelburst_font04"), "LEVEL BURST!", cc.p(234, 114)},
                    },
                    btn = {getImage(1, "boost_now01"), getImage(1, "boost_now02"), cc.p(201, 62)},
                }
            },
            level_up_party =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1, "LEVEL_UP.level_up_party"},
                label2 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
                label3 = {getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), 1},
            },
            booster =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
                label2 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "LEVEL_UP.level_burst"}, -- 黄色背景下的字体，坐标，粉色背景下的字体和坐标
            },
            double_xp =
            {
                label1 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 0.95, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31), "X2 LEVEL UP EXP"},
                label2 = {getImage(1, "FASTER"), cc.p(13, -31), 1, getImage(1, "FASTER02")},
                label3 = {getFont(1, "Level_upparty_booster_fnt"), cc.p(13, -31), 1, getFont(1, "Level_upparty_booster_fnt02"), cc.p(13, -31)},
            },
            double =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(1, "top_double_blast"), cc.p(110, 15), 1},
                label2 = {getImage(1, "EVEN"), cc.p(110, 15), 1},
            },
            lounge =
            {
                bg     = {getImage(1, "booster_bg"), cc.p(7, -31)},
                label1 = {getImage(8, "lobbylounge_picfont01"), cc.p(109, 16), 1},
                label2 = {getImage(8, "lobbylounge_picfont02"), cc.p(109, 16), 1},
            },
            progress =
            {
                normalImage =
                {
                    normal  = getImage(2, "lobby_jdt_blue"),
                    booster = getImage(2, "lobby_jdt_yellow"),
                    double  = getImage(2, "lobby_jdt_blue"),
                    doublexp= getImage(2, "lobby_jdt_blue"),
                    pos     = cc.p(132, 18.5)
                },
                range       = {-132, 132},
                position    = cc.p(-132, -19),
                size        = cc.size(264, 37),
            },
            animNode =
            {
                node        = cc.p(-137, 0),
                particle    = {getParticle(1,"jingyantiao_lizi01_1"), cc.p(0, 0)},
                spine       = {getSpine(1, "exp2"), cc.p(0, 0)},
            },
            bgSpine  =
            {
                image       = {getSpine(1, "exp"), cc.p(132, 18.5), "animation1"},
                range       = {0, 264},
                position    = cc.p(-132, -19),
                size        = cc.size(264, 37),
            },
            star     = {getImage(1, "lobby_star"), cc.p(-106, -2)}, 
            label    = {getFont(1, "lobby_head01_zit"), cc.p(0, 0)},
            spine    = {getSpine(1, "star"), cc.p(29, 27)}
        },
        wheel =
        {
            position = cc.p(-478, -31),
            bg    = {getImage(2, "zhuanp_hese01"), cc.p(0, 0)},
            bg2   = {getImage(2, "zhuanp_hese020"), getImage(2, "zhuanp_hese07"), cc.p(-14, -31)},
            wheel =
            {
                clip_pos = cc.p(0, 0),
                image = {getImage(2, "zhuanp_hese02"), cc.p(60.5, 21.5)},
                position = cc.p(-60.5, -21.5),
                size = cc.size(121, 43),
                range = {-181.5, -60.5},
            },
            particleLine  = {getParticle(2, "dt_ysj_lizi_01_1"), cc.p(-60.5, 0), 11},
            label         = {getFont(2, "zhanpan_beishuzit"), cc.p(0, 7), cc.p(0, 4), 1},
            spine         = {getSpine(2, "wheel"), cc.p(0, 0)},
            wheel_btn     = {getCommonImage("kong"), cc.p(0, 0), 12.1, 4.3}, -- wheel muiltiplier 新增点击提示文字以及升级提醒
            wheel_normal  = {getImage(3, "theme_wheel_normal_bg"), cc.p(119, -145.5)},
            wheel_normal1 = {getImage(3, "booster_bg_triangle03"), cc.p(123, 215)},
            wheel_reward  = {getImage(2, "zhuanp_hese04"), cc.p(26, 6)},
            time_label    = {getFont(2, "zhuanp_hesefnt"), cc.p(0, -13), cc.p(0, 4), 1, 0.8},
            wheel_level   = {getImage(3, "theme_wheel_level_bg"), cc.p(155, -90)},
            level_text    = {getFont(3, "booster_levelburst_font05"), cc.p(227, 61), 1, "FREE_BONUS.bonus_multiplier"},
            level_label   = {getFont(8, "booster_levelburst_font03"), cc.p(403, 61), 1},
            button        = {getCommonImage("kong"), cc.p(0, 0), 12.1, 6.4},
            buttonSpine   = {getSpine(2, "wheel_btn"), cc.p(-14, -31)},
            cardSpine     = {getSpine(2, "wheel_card"), cc.p(0, 0)},
            card_coins    = {getFont(1, "lobby_video_topfont"), cc.p(0, -48), 1},
            multi_bg      = {getImage(2, "multiple_scratch_multiple"), cc.p(120, -53), 0.5},
            multi_label   = {getFont(2, "header_zhanpan_beishuzit"), cc.p(76, 75.5), 1},
            wheel_frame   = {getImage(2, "zhuanp_hese05"), cc.p(1, 0)},
        },
        -- chips =
        -- {
        --     position       = cc.p(-492.5, -33),
        --     bg             = {getImage(8, "emerald_bg01"), getImage(8, "emerald_bg01"), cc.p(0, 0)},
        --     logo           = {getImage(1, "emerald_img01"), cc.p(-53, 0)},
        --     label          = {getFont(8, "lobby_head03_zit"), cc.p(15, -1), 1, 96},
        --     spine          = {getSpine(1, "chip"), cc.p(27, 25), 0.6},
        --     get_spine      = {getSpine(1, "coins_fly_get"), cc.p(24, 23.5)},
        --     start_spine    = {getSpine(1, "coins_fly_start"), cc.p(0, 0)},
        --     fly_particle   = {getParticle(1, "baoshilizi_1"), cc.p(0, 0)},
        --     fly_particle_2 = {getParticle(1, "jb_lzbj_01_1"), cc.p(0, 0)},
        -- },
        pig =
        {
            position = {cc.p(537, -32), cc.p(488, -32)},
            button   = {getImage(2, "lobby_ypig"), getImage(2, "lobby_ypig_pressdown"), cc.p(0, 0) },
            particle = {getParticle(1,"header_pig_bg"), cc.p(35, 35)},
            coupon   = {getImage(2, "lobby_money_coupon01"), cc.p(-53, 0), 1},
            max      = {getImage(1, "moneybank_img_1", true), cc.p(35, 10), 1},
            spine    = {getSpine(2, "pig"), cc.p(35, 35)},
        },
        voucher = 
        {
            position = {cc.p(544, -32), cc.p(504, -32)},
            bg             = {getImage(5, "lobby_jdt_back"), cc.p(0, 0)},
            logo           = {getImage(1, "lobby_jdt_coin"), cc.p(-96.5, 1)},
            label          = {getFont(2, "coins_font04", true), cc.p(18, -1), 0.8, 179},
        },
        setting =
        {
            position = cc.p(600, -27),
            button = {getImage(3, "lobby_setting"), getImage(3, "lobby_setting_pressdown"), cc.p(0, 0)},
            bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getImage(3, "setting_bg"), cc.p(-91, -13), cc.p(0.5, 1)},
                setting_bg_line1     = {getImage(3, "setting_bg_line"), cc.p(-87, -96)},
                setting_bg_line2     = {getImage(3, "setting_bg_line"), cc.p(-87, -149)},
                setting_bg_line3     = {getImage(3, "setting_bg_line"), cc.p(-87, -201)},
                setting_bg_line4     = {getImage(3, "setting_bg_line"), cc.p(-87, -254)},
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -175) },
                btn_Setting          = {getImage(1, "setting_bg03"), getImage(3, "setting_bg02"), cc.p(-84, -228)},
                btn_paytable         = {getImage(1, "setting_bg03"), getImage(3, "setting_btn_di"), cc.p(-84, -280) },
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-84, -69)},
                label_music          = {getImage(3, "setting_MUSIC"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getImage(3, "setting_SOUND"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getImage(3, "setting_RATEUS"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting        = {getImage(3, "setting_SETTINGS"), cc.p(-193, -226), cc.p(0, 0.5)},
                label_gamerule       = {getImage(3, "setting_GAMERULE02"), cc.p(-193, -280), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(3, "sound_btn"), cc.p(-10, -69)},
            },
        },
    },
    -- gold spin header 横版
    [12] = -- 未做
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 128, 7.4}
        },
        background =
        {
            {getGoldSpinImage(12, "gold_spin_lobby_header1"), cc.p(0, -39), true},
            {getGoldSpinImage(12, "gold_spin_lobby_header1"), cc.p(0, -39), false},
        },
        lobby =
        {
            position = cc.p(-599, -33),
            button = {getGoldSpinImage(12, "gold_spin_lobby_header2"), getGoldSpinImage(12, "gold_spin_lobby_header3"), getGoldSpinImage(12, "gold_spin_lobby_header3"), cc.p(0, 0)},
        },
        buy =
        {
            position = cc.p(0, -38),
            spine = {getGoldSpinSpine(12, "wholebingbing"), cc.p(-6, -34)}--这个是整体闪光的动画
        },
        setting =
    	{
            position = cc.p(600, -27),
    		button = {getGoldSpinImage(12, "gold_spin_lobby_header6"), getGoldSpinImage(12, "gold_spin_lobby_header7"), cc.p(0, 0) },
        	bar = {
                position             = cc.p(0,-20),
                animation            = {getCommonImage("kong"), cc.p(0,0)}, -- kong图片，用来写动画
                setting_bg           = {getGoldSpinImage(12, "gold_spin_lobby_header8"), cc.p(-91, -13), cc.p(0.5, 1)},
                setting_bg_line1     = {getGoldSpinImage(12, "gold_spin_lobby_header9"), cc.p(-87, -96)}, 
                setting_bg_line2     = {getGoldSpinImage(12, "gold_spin_lobby_header9"), cc.p(-87, -149)}, 
                setting_bg_line3     = {getGoldSpinImage(12, "gold_spin_lobby_header9"), cc.p(-87, -201)}, 
                btn_sound            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-87, -121)},
                btn_RateUs           = {getImage(1, "setting_bg03"), getGoldSpinImage(12, "gold_spin_lobby_header10"), cc.p(-87, -175)},
                btn_Setting          = {getImage(1, "setting_bg03"), getGoldSpinImage(12, "gold_spin_lobby_header11"), cc.p(-87, -228)},
                btn_music            = {getImage(1, "setting_bg03"), getCommonImage("kong"),cc.p(-87, -69)},
                label_music          = {getGoldSpinImage(12, "gold_spin_lobby_header12"), cc.p(-193, -70), cc.p(0, 0.5)},
                label_sound          = {getGoldSpinImage(12, "gold_spin_lobby_header13"), cc.p(-193, -124), cc.p(0, 0.5)},
                label_rateus         = {getGoldSpinImage(12, "gold_spin_lobby_header14"), cc.p(-193, -173), cc.p(0, 0.5)},
                label_setting        = {getGoldSpinImage(12, "gold_spin_lobby_header15"), cc.p(-193, -226), cc.p(0, 0.5)},
                sound_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -124)},
                sound_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -124)},
                sound_choose_btn     = {getImage(1, "sound_btn"), cc.p(-10, -125)},
                music_chooseBg_open  = {getImage(1, "sound_btn_bg_open"), cc.p(-32, -68)},
                music_chooseBg_close = {getImage(1, "sound_btn_bg_close"), cc.p(-32, -68)},
                music_choose_btn     = {getImage(1, "sound_btn"), cc.p(-10, -69)},
            },
    	},
        gold_spin = 
        {
            buy_node = 
            {
                position = cc.p(0, -38),
                button   = {getGoldSpinImage(12, "gold_spin_lobby_header4"), getGoldSpinImage(12, "gold_spin_lobby_header5"), cc.p(0, 0)},
                spine    = {getGoldSpinSpine(12, "lobby_header_buy"), cc.p(0, 0)}
            },
            spine_logo = {getGoldSpinSpine(12, "lobby_header_logo"), cc.p(-354, -11)},

            time_node  = 
            {
                position = cc.p(-371, -88),
                bg       = {getGoldSpinImage(12, "gold_spin_lobby_header16"), cc.p(0, 0)},
                label    = {getGoldSpinFont(12, "gold_spin_lobby_header_fnt1"), cc.p(0, 5)},
            },
            count_node = 
            {
                position = cc.p(356, -33),
                bg       = {getGoldSpinImage(12, "gold_spin_lobby_header17"), cc.p(0, 0)},
                bg_label = {getGoldSpinImage(12, "gold_spin_lobby_header18"), cc.p(-23.5, -1)},
                label    = {getGoldSpinFont(12, "gold_spin_lobby_footer_fnt1"), cc.p(45, 0), cc.p(0, 0.5)},
                button   = {getGoldSpinImage(12, "gold_spin_lobby_header19"), getGoldSpinImage(12, "gold_spin_lobby_header20"), cc.p(-113, -1)},
            },
        },
    },     
}

HeaderFooterConfig.footer_config_list =
{   
    -- 大厅footer
    [1] =
    {
        background = 
        {
            bg_more = 
            {
                bg            = {getImage(1, "background_more", true), cc.p(0, -142.5), cc.p(0.5, 0)},
                btn_close     = {getImage(1, "main_btn01", true), getImage(1, "main_btn02", true), getImage(1, "main_btn02", true), cc.p(898, 124)}, 
                btn_see_more  = {getImage(1, "main_btn03", true), getImage(1, "main_btn04", true), getImage(1, "main_btn04", true), cc.p(430, 60)},
                btn_see_more2 = {getCommonImage("kong"), getCommonImage("kong"), getCommonImage("kong"), cc.p(433, 62), 9},
                btn_close2 = {getCommonImage("kong"), getCommonImage("kong"), getCommonImage("kong"), cc.p(433, -18), 8, 25},
                red           = {getSpine(1, "red"), cc.p(453, 92), 1},
                spine_close   = {getSpine(1, "close", true), cc.p(71/2, 248/2)},
                line          = 
                {
                    {getImage(1, "background_line_more", true), cc.p(140, 123)},
                    {getImage(1, "background_line_more", true), cc.p(260, 123)},
                    {getImage(1, "background_line_more", true), cc.p(380, 123)},
                    {getImage(1, "background_line_more", true), cc.p(500, 123)},
                    {getImage(1, "background_line_more", true), cc.p(620, 123)},
                    {getImage(1, "background_line_more", true), cc.p(740, 123)},
                },
            },
            bg1 = {getImage(1, "background_top", true), cc.p(0, 42), true},
            bg2 = {getImage(1, "background", true), cc.p(390, 59)},
            bg3 = {getImage(1, "background", true), cc.p(-390, 59), true},
        },
        lobby =
        {
            button   = {getImage(1, "fh_LoungePoints_icon", true), getImage(1, "lobby_btn02", true), getImage(1, "fh_LoungePoints_icon", true), cc.p(10, 14), 1},
            bg_frame = {getImage(1, "fh_LoungePoints_jdtframe", true), cc.p(57, 24)},
            container =
            {
                position = cc.p(20, 14),
                size     = cc.size(74, 18),
                image    = {getImage(1, "fh_LoungePoints_jdt", true), cc.p(-37, 10)},
                image2   = getImage(1, "fh_LoungePoints_jdt02", true),
                min      = -37,
                max      = 37,
            },
            fg_frame = {getImage(1, "fh_LoungePoints_jdtframe03", true), cc.p(57, 24)},
            label = {getFont(1, "LoungePoints_sj_font", true), cc.p(57, 17), 1},
            count = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 21), 1},
            },
            name       = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_lounge", 112},
            new        = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
            time       = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            lock       = {getImage(1, "lobby_btn02", true), getImage(1, "lobby_btn02", true), getImage(1, "lobby_btn02", true), cc.p(10, 14)},
            lock_spine = {getSpine(1, "lock", true), cc.p(10, -18), 1},
            lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
            lock_info  = {
                root        = {cc.p(0, 0)},
                bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
            },
        },
        pig =
        {
            label  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_money_bank", 112},
            button = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_pressdown", true), getImage(1, "lobby_money_pressdown", true), cc.p(0, 0)},
            coupon = {getImage(1, "lobby_money_coupon01", true), cc.p(-7, 4), 1},
            max    = {getImage(1, "moneybank_img_1", true), cc.p(0, 30), 1},
            tips   = 
            { 
                tip         = {getImage(1, "zisediban", true), cc.p(170, 170)},
                ratio       = {getFont(1, "pop_ups_fnt", true), cc.p(184, 61), 1},
                bg          = {getImage(1, "lobby_piaodai", true), cc.p(0, -29)},
                label_node1 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                label_node2 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                special_offer_label = {getFont(1, "Level_upparty_booster_fnt"), cc.p(56, 19), 0.75}, -- 单行label
            },
            BFtips = 
            {
                tip         = {getImage(1, "bf_popup_img01", true), cc.p(120, 100)},
                ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            },
            -- BDStips = 
            -- {
            --     tip         = {getImage(1, "bf_popup_img02", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BDSpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            -- Christmastips = 
            -- {
            --     tip         = {getImage(1, "christmas_popup_img01", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            loading = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_gray", true), cc.p(0, 0), 1},
        },
        pig_right =
        {
            position    = cc.p(557, 95),
            label  = {getFont(1, "footer_fnt03", true), cc.p(0, -75), 1, "LOBBY.footer_money_bank", 150},
            label_now = {getFont(1, "footer_fnt02", true), cc.p(0, - 75), 1, "LOBBY.footer_open_now", 150},
            button = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_pressdown", true), getImage(1, "lobby_money_pressdown", true), cc.p(0, -4), 0.8},
            coupon = {getImage(1, "lobby_money_coupon01", true), cc.p(-7, 4), 1},
            max    = {getImage(1, "moneybank_img_1", true), cc.p(0, 30), 1},
            lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
            tips   = 
            { 
                tip         = {getImage(1, "zisediban", true), cc.p(170, 170)},
                ratio       = {getFont(1, "pop_ups_fnt", true), cc.p(184, 61), 1},
                bg          = {getImage(1, "lobby_piaodai", true), cc.p(0, -29)},
                label_node1 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                label_node2 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                special_offer_label = {getFont(1, "Level_upparty_booster_fnt"), cc.p(56, 19), 0.75}, -- 单行label
            },
            BFtips = 
            {
                tip         = {getImage(1, "bf_popup_img01", true), cc.p(120, 100)},
                ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            },
            -- BDStips = 
            -- {
            --     tip         = {getImage(1, "bf_popup_img02", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BDSpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            -- Christmastips = 
            -- {
            --     tip         = {getImage(1, "christmas_popup_img01", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            loading = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_pressdown", true), cc.p(0, 0), 0.8},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(0, 0), 1},
        },

        facebook =
        {
            facebook1 = 
            {
                button = {getImage(1, "facebook_jl", true), getImage(1, "facebook_jl02", true), getImage(1, "facebook_jl02", true), cc.p(10, 14), 0.7},
            },
            facebook2 = 
            {
                button = {getImage(1, "facebook01", true), getImage(1, "facebook02", true), getImage(1, "facebook02", true), cc.p(10, 14), 0.7},
            },
            friends = 
            {
                button = {getImage(1, "friends", true), getImage(1, "friends02", true), getImage(1, "friends02", true), cc.p(10, 14), 0.7},
            },
            label_facebook = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_facebook", 112},
            label_friend   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_friend", 112},
        },
        userguide_quest =
        {
            unlockquest = 
            {
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_quest_frenzy", 112},
                button  = {getImage(1, "userguide_quest_1", true), getImage(1, "userguide_quest_2", true), getImage(1, "userguide_quest_2", true), cc.p(10, 16)},
                new     = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -17), 1},
                time    = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
             },
            loading = {getImage(1, "userguide_quest_1", true), getImage(1, "userguide_quest_2", true), cc.p(10, 16), 1},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        mansion =
        {
            position = cc.p(-557, 89),
            mansion = 
            {
                button = {getImage(1, "mansion_icon01", true), getImage(1, "mansion_icon02", true), getImage(1, "mansion_icon02", true), cc.p(10, 16), 0.7},
                name   = {getImage(1, "mansion_name", true), cc.p(10, -45), 1},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_mansion_quest", 112},
            },
            disable = 
            {
                button = {getImage(1, "mansion_icon02", true), getImage(1, "mansion_icon02", true), getImage(1, "mansion_icon02", true), cc.p(10, 16), 0.7},
                lock_spine = {getSpine(1, "lock", true), cc.p(100, 38), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 55), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            count = 
            {
                red  = {getSpine(1, "red"), cc.p(45, 20)},
            },
            loading = {getImage(1, "mansion_icon01", true), getImage(1, "mansion_icon03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 14), 1},
        },
        atw =
        {
            atw = 
            {
                button = {getImage(1, "around_lobby_btn01", true), getImage(1, "around_lobby_btn02", true), getImage(1, "around_lobby_btn02", true), cc.p(10, 14), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_atw", 112},
                new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            },
            disable = 
            {
                button = {getImage(1, "around_lobby_btn02", true), getImage(1, "around_lobby_btn02", true), getImage(1, "around_lobby_btn02", true), cc.p(10, 14), 0.7},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                lock_spine = {getSpine(1, "lock", true), cc.p(10, -18), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
            },
            count  = 
            {
                red  = {getSpine(1, "red"), cc.p(45, 20)},
            },
            loading = {getImage(1, "around_lobby_btn01", true), getImage(1, "around_lobby_btn02", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        club =
        {
            position = cc.p(-557, 95),
            club = 
            {
                button = {getImage(1, "club_lobby_btn01", true), getImage(1, "club_lobby_btn02", true), getImage(1, "club_lobby_btn02", true), cc.p(0, 0), 0.8},
                label  = {getFont(1, "footer_fnt03", true), cc.p(0, -75), 1, "LOBBY.footer_cash_club", 150},
            },
            disable = 
            {
                button = {getImage(1, "club_lobby_btn02", true), getImage(1, "club_lobby_btn02", true), getImage(1, "club_lobby_btn02", true), cc.p(0, 0), 0.8},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(124, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(124, 64), 1, "TO UNLOCK"},
                },
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1.4},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
            },
            count  = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
            },
            loading = {getImage(1, "club_lobby_btn01", true), getImage(1, "club_lobby_btn02", true), cc.p(0, 0), 0.8},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(0, 0), 1},
        },
        blast =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "lobby_pickfrenzy_icon01", true), getDynamicImage(1, "lobby_pickfrenzy_icon02", true), getDynamicImage(1, "lobby_pickfrenzy_icon02", true), cc.p(10, 14), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -17), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "lobby_pickfrenzy_icon01", true), getDynamicImage(1, "lobby_pickfrenzy_icon03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_blast", 112},
        },
        bingo =
        {
            -- bingo = 
            -- {
            --     button = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon02", true), getDynamicImage(1, "lobby_bingo_icon02", true), cc.p(-1, -1), 0.9},
            --     shadow = {getImage(1, "tb_touying", true), cc.p(0, -35), 127.5},
            --     -- label  = {getImage(1, "bingo_frenzy", true), cc.p(0,-56),0.9},
            --     label  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_bingo", 112},
            --     -- new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(57, 20) },
            --     new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
            --     time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            -- },
            -- count  = 
            -- {
            --     image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
            --     label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
            --     red  = {getSpine(1, "red"), cc.p(45, 20)},
            -- },
            -- loading = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon03", true), cc.p(-1, -5),0.9},

            unlock = 
            {
                button = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon02", true), getDynamicImage(1, "lobby_bingo_icon02", true), cc.p(10, 14), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_bingo", 112},
        },
        rocket =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "chutes_rockets", true), getDynamicImage(1, "chutes_rockets02", true), getDynamicImage(1, "chutes_rockets02", true), cc.p(10, 16), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -17), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "chutes_rockets", true), getDynamicImage(1, "chutes_rockets03", true), cc.p(10, 16), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_rocket", 112},
        },
        journey =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "cashjourney_logo01", true), getDynamicImage(1, "cashjourney_logo02", true), getDynamicImage(1, "cashjourney_logo02", true), cc.p(10, 0), 1, 0.7},
                timeBg    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count = {cc.p(35, 27)},
            }, 
            loading = {getDynamicImage(1, "cashjourney_logo01", true), getDynamicImage(1, "cashjourney_logo02", true), cc.p(10, 0), 0.7}, 
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_journey", 112},
        },
        cooking =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "cookingfrenzy_logo01", true), getDynamicImage(1, "cookingfrenzy_logo03", true), getDynamicImage(1, "cookingfrenzy_logo03", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "cookingfrenzy_logo01", true), getDynamicImage(1, "cookingfrenzy_logo02", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_cooking", 112},
        },
        archer =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "archer_lobby_icon01", true), getDynamicImage(1, "archer_lobby_icon03", true), getDynamicImage(1, "archer_lobby_icon03", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "archer_lobby_icon01", true), getDynamicImage(1, "archer_lobby_icon02", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_archer", 112},
        },
        gof =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "logo_gameforune_img01", true), getDynamicImage(1, "logo_gameforune_img02", true), getDynamicImage(1, "logo_gameforune_img02", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "logo_gameforune_img01", true), getDynamicImage(1, "logo_gameforune_img03", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_gof", 112},
        },
        mow =
        { 
            unlock = 
            {
                button = {getDynamicImage(1, "lobby_mowfrenzy_icon01", true), getDynamicImage(1, "lobby_mowfrenzy_icon02", true), getDynamicImage(1, "lobby_mowfrenzy_icon02", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "lobby_mowfrenzy_icon01", true), getDynamicImage(1, "lobby_mowfrenzy_icon03", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_mow", 112},
        },
        dashboard =
        {
            enable = 
            {
                button = {getImage(1, "lobby_logo_mission01", true), getImage(1, "lobby_logo_mission02", true), getImage(1, "lobby_logo_mission02", true), cc.p(0, 14), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(5, -45), 1, "LOBBY.footer_mission", 112},
            },
            disable = 
            {
                button = {getImage(1, "lobby_logo_mission02", true), getImage(1, "lobby_logo_mission02", true), getImage(1, "lobby_logo_mission02", true), cc.p(0, 14), 0.7},
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info       = 
                {
                    root   = {cc.p(0, 0)},
                    bg     = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            count = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20), 0.9},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 21), 1},
            },
            loading = {getImage(1, "lobby_logo_mission01", true), getImage(1, "lobby_logo_mission02", true), cc.p(0, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        wheel =
        {
            position = cc.p(568, 0), -- 已修改
            particle       = {getParticle(1,"megaball", true), cc.p(-4.5, 56)},
            megaballSpine  = {getSpine(1, "megaball", true), cc.p(-10, 89)},
            container =
            {
                position = cc.p(-134, 39),
                size = cc.size(230, 150),
                wheel = 
                {
                    button = {getImage(1, "wheel", true), getImage(1, "wheel", true), getImage(1, "wheel", true), cc.p(130, 11) },
                    spine  = {getSpine(1, "wheel", true), cc.p(92, -13)}
                },
                rewards = 
                {
                    spine_bg    = {getSpine(1, "daily_reward_bg", true), cc.p(124, 48)},
                    button      = {getImage(1, "lobby_footer_coin", true), getImage(1, "lobby_footer_coin02", true), getImage(1, "lobby_footer_coin02", true), cc.p(124, 48)},
                    spine_front = {getSpine(1, "daily_reward_front", true), cc.p(124, 48)},
                    count       = 
                    {
                        image  = {getImage(1, "yeqian_01", true), cc.p(175, 73)},
                        label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
                    },
                },
                megaball = 
                {
                    button = {getImage(1, "megaball_lobby01", true), getImage(1, "megaball_lobby02", true), getImage(1, "megaball_lobby02", true), cc.p(130, 48) },
                },
            },
            img_play_now = {getImage(1, "daily_bonus_play_now", true), cc.p(-10, 22)},
            lable2       = {getImage(1, "daily_bonus_collect", true), cc.p(-9, 22)},
            next_wheel   =
            {
                pos = cc.p(-10, 33),
                images =
                {
                    {getImage(8, "WHEEL_OF_CASHIN", true), cc.p(6, -16),1},
                    {getImage(1, "slotofcash_dating_bar04", true), cc.p(6, 1),1},
                },
                progress = 
                {
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(-53.5, 0.5), 1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(-24, 0.5), 1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(5.5, 0.5), 1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(35, 0.5),  1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(63.5, 0.5),  1},
                },
            },
            next_megaball =
            {
                pos = cc.p(-10, 33),
                images =
                {
                    {getImage(8, "daily_bonus_megaball", true), cc.p(2, -16)},
                    {getImage(1, "lobby_footer_lotto_jd02", true), cc.p(-54, 1)},
                    {getImage(1, "lobby_footer_lotto_jd02", true), cc.p(0, 1)},
                    {getImage(1, "lobby_footer_lotto_jd02", true), cc.p(54, 1)},
                },
                labels =
                {
                    {getImage(1, "lobby_footer_lotto_jd01", true), cc.p(-54, 2)},
                    {getImage(1, "lobby_footer_lotto_jd01", true), cc.p(0, 2)},
                    {getImage(1, "lobby_footer_lotto_jd01", true), cc.p(54, 2)},
                },
            }
        },
        bonus =
        {
            wheel = 
            {
                button = {getImage(1, "lobby_bonus_soc_icon01", true), getImage(1, "lobby_bonus_soc_icon02", true), getImage(1, "lobby_bonus_soc_icon02", true), cc.p(10, 12)},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_soc", 112},
            },
            rewards = 
            {
                spine_bg    = {getSpine(1, "daily_reward_bg", true), cc.p(10, 0), 0.6},
                button      = {getImage(1, "lobby_bonus_wheel_icon01", true), getImage(1, "lobby_bonus_wheel_icon02", true), getImage(1, "lobby_bonus_wheel_icon02", true), cc.p(10, 14), 0.7},
                label       = {getFont(1, "new_lobby_fnt", true), cc.p(10, - 45), 1, "LOBBY.footer_free_bonus", 112},
                count       = 
                {
                        image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
                        label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
                },
            },
            megaball = 
            {
                button = {getImage(1, "lobby_bonus_bgq_icon01", true), getImage(1, "lobby_bonus_bgq_icon02", true), getImage(1, "lobby_bonus_bgq_icon02", true), cc.p(4, 14)},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_pachincoin", 112},
            },
        },
        inbox =
        {
            gift = 
            {
                button = {getImage(1, "INBOX01", true), getImage(1, "INBOX02", true), getImage(1, "INBOX02", true), cc.p(10, 14), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_inbox", 112},
            },
            count = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20), 0.9},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
            },
            loading = {getImage(1, "INBOX01", true), getImage(1, "INBOX02", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(20, 0), 1},
        },
        booster =
        {
            booster = 
            {
                button = {getImage(1, "booster01", true), getImage(1, "booster02", true), getImage(1, "booster02", true), cc.p(10, 14)},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_boosters", 112},
            },
        },
        chips =
        {
            chips = 
            {
                button = {getImage(1, "headbooster_icon01", true), getImage(1, "headbooster_icon02", true), getImage(1, "headbooster_icon02", true), cc.p(5, 14), 0.9},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_emerald", 112},
            },
        },
        stamps =
        {
            stamps = 
            {
                button     = {getImage(1, "AmazingStamps_icon", true), getImage(1, "AmazingStamps_icon02", true), getImage(1, "AmazingStamps_icon02", true), cc.p(10, 14), 0.66},
                label      = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_stamp", 112},
                frenzy     = {getImage(1, "stamp_frenzy", true), cc.p(19, 92), 1, -40},
                words_game = {getImage(1, "stamp_words_game", true), cc.p(90, 85), 0.68},
                new        = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time       = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            },
            lockstamps = 
            {
                button     = {getImage(1, "AmazingStamps_icon02", true), getImage(1, "AmazingStamps_icon02", true), getImage(1, "AmazingStamps_icon02", true), cc.p(10, 14), 0.66},
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1}, 
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            loading = {getImage(1, "AmazingStamps_icon", true), getImage(1, "AmazingStamps_icon_disable", true), cc.p(10, 14), 0.66},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        byd =
        {
            enable = 
            {
                button = {getImage(1, "lobby_footer_byd01", true), getImage(1, "lobby_footer_byd02", true), getImage(1, "lobby_footer_byd02", true), cc.p(10, 14), 1},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_byd", 112},
                new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                count  = 
                {
                    image  = {getImage(1, "yeqian_01", true), cc.p(45, 20), 0.9},
                    label  = {getFont(1, "lobby_count", true), cc.p(21, 20), 1},
                },
            },
            disable = 
            {
                button     = {getImage(1, "lobby_footer_byd02", true), getImage(1, "lobby_footer_byd02", true), getImage(1, "lobby_footer_byd02", true), cc.p(10, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(10, -18), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            loading = {getImage(13, "lobby_footer_byd01", true), getImage(13, "lobby_footer_byd02", true), cc.p(10, 14), 1},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 14), 1},
        },
        vip =
        {
            vip = 
            {
                button = {getImage(1, "lobby_footer_vip_icon", true), getImage(1, "lobby_footer_vip_icon_grey", true), getImage(1, "lobby_footer_vip_icon_grey", true), cc.p(10, 14), 0.82},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_vip", 112},
            },
            tips =
            {
                bg     = {getImage(1, "lobby_piaodai", true), cc.p(0, -29)},
                label1 = {getImage(1, "lobby_s", true), cc.p(57, 19), 0.95},
                label2 = {getImage(1, "lobby_b", true), cc.p(57, 18), 0.95},
            },
            loading = {getImage(1, "lobby_footer_vip_icon", true), getImage(1, "lobby_footer_vip_icon_grey", true), cc.p(10, 14)},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 14), 1},
        },
        dailyPrize =
        {
            dailyPrize = 
            {
                button = {getImage(1, "loginbonus01", true), getImage(1, "loginbonus02", true), getImage(1, "loginbonus02", true), cc.p(10, 16), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_login_bonus", 112},
            },
            disable = 
            {
                button = {getImage(1, "loginbonus03", true), getImage(1, "loginbonus03", true), getImage(1, "loginbonus02", true), cc.p(10, 16), 0.7},
                lock_spine = {getSpine(1, "lock", true), cc.p(10, -3), 1.2},
                info   = {
                    bg_starter     = {getImage(1, "loginbonus04", true), cc.p(-52, 150)},
                    bg_back     = {getImage(1, "loginbonus05", true), cc.p(-52, 150)},
                },
            },
            loading = {getImage(1, "loginbonus01", true), getImage(1, "loginbonus03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(20, 14), 1},
        },
        dailyShare =
        {
            position = cc.p(-527, 90),
            unlockshare = 
            {
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -45), 1, "LOBBY.footer_daily_share", 112},
                button = {getImage(1, "dailyshare01", true), getImage(1, "dailyshare02", true), getImage(1, "dailyshare02", true), cc.p(0, 10), 0.7},
            },
            loading = {getImage(1, "dailyshare01", true), getImage(1, "dailyshare02", true), cc.p(0, 10), 0.7},
        },
        tourncash =
        {
            unlock =
            {
                button = {getImage(1, "tourncash_01", true), getImage(1, "tourncash_02", true), getImage(1, "tourncash_02", true), cc.p(0, 5)},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                count  = {cc.p(83, 70)},
            },
            lock =
            {
                button = {getImage(1, "tourncash_01", true), getImage(1, "tourncash_02", true), getImage(1, "tourncash_02", true), cc.p(0, 5)},
                timeBg = {getImage(1, "tourncash_lobby_img01", true), cc.p(0, -31), 1},
                timeTip= {getImage(1, "tourncash_lobby_lbl01", true), cc.p(0, -25), 1},
                time   = {getFont(1, "tourncash_lobby_fnt01", true), cc.p(0, -38), 1},
            },
            common_lock = 
            {
                button = {getImage(1, "tourncash_03", true), getImage(1, "tourncash_03", true), getImage(1, "tourncash_03", true), cc.p(0, 5)},
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1},
            },
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_tourn_frenzy", 112},
            loading = {getImage(1, "tourncash_01", true), getImage(1, "tourncash_03", true), cc.p(0, 5)},
        },
        faq = {
            button = {getImage(1, "faq_icon01", true), getImage(1, "faq_icon02", true), getImage(1, "faq_icon02", true), cc.p(10, 18), 0.66},
            label = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_faq", 112},
        },
    },
    -- 横版主题金色footer
    [2] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2},
        },
        background = 
        {
            leftBg   = {getImage(2, "big_back_half", true), cc.p(0, 48), true},
            rightBg  = {getImage(2, "big_back_half", true), cc.p(0, 48), false},
            spine    = {getSpine(2, "frame_footer", true), cc.p(0, 360 + 58), "animation1"},
        },
        dashboard =
        {
            position = cc.p(-588, 50),
            unlockdashboard = 
            {
                bg    = {getImage(2, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(2, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(2, "Daily_Mission_ingame_right", true), cc.p(39, 59)},
                frame = {getImage(2, "Daily_Mission_ingame_frame_top", true), cc.p(39, 60)},
                giftspine = {getSpine(2, "claim", true), cc.p(40, 52)},
                label_bg  = {getImage(2, "Daily_Mission_ingame_box", true), cc.p(39, 13)},
                label  = {getFont(2, "Daily_Mission_ingame_front", true), cc.p(39, 14), 1},
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(195, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "new_player_dashtips", true), cc.p(250, 210), 1},
                },
                mission_tip = 
                {
                    bg     = {getImage(2, "bc_yh_ingme01", true), cc.p(70, 100), cc.p(0.22, 0.12)},
                },
                blazing_challenge = 
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard = 
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(198, 200), false, 1},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },  
                collect_dashboard =
                {
                    root = {cc.p(45, 95), 1},
                    bg = {getImage(2, "di_dhk", true), cc.p(40, 66.5), false, 1},
                    title = {getCommonNewFont("common_withe"), cc.p(40, 98), 0.3, ""},
                    pos = cc.p(40, 57.5),
                    spine = {getSpine(2, "tick", true), cc.p(100, 105), 0.8},
                    label = {
                        {getCommonNewFont("common_withe"), cc.p(40, 70), 0.3, ""},
                        {getCommonNewFont("common_withe"), cc.p(40, 45), 0.3, ""},
                    }
                },
            },
            lockdashboard = 
            {
                button = {getImage(2, "Daily_Mission_ingame_frame_disable", true), getImage(2, "Daily_Mission_ingame_frame_disable", true), getImage(2, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(2, "Daily_Mission_ingame_front", true), cc.p(40, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(40, 48), 1},
            },
        },
        totalbet =
        {
            position          = cc.p(-395.5, 43),
        	bigBgImage        = {getImage(2, "bes_gameback", true), cc.p(0, 0)},
        	smallBgImage      = {getImage(2, "free_gameback", true), cc.p(76, 0)},
        	subButton         = {getImage(2, "minus01", true), getImage(2, "minus02", true), getImage(2, "minus03", true), cc.p(-111, 4), 1},
        	addButton         = {getImage(2, "plus01", true), getImage(2, "plus02", true), getImage(2, "plus03", true), cc.p(111, 4), 1},
            labelBet          = {getFont(2, "coins_font02", true), cc.p(0, 3), 1, 162, cc.p(76, 3), 1, 115},
        	totalBetImage1    = {getImage(2, "totalbetzit", true), cc.p(3, -32)},
        	totalBetImage2    = {getImage(2, "totalbetzit", true), cc.p(74, -32)},
			animNode          = cc.p(0, 0),
            particle          = {getParticle(2,"max_bet_liziwenjian01_1", true), cc.p(0, 0)},
            max_bet_spine     = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(0, 176)},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "LOBBY.lp_by_spining"},

                },
                big_bet = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-395, 94)},
            },
            voucher_bet_big = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-395, 136.5)},
            },
        },
        freegames =
        {
            position = cc.p(-468, 43),
            bgImage     = {getImage(2, "free_gameback", true), cc.p(0, 0)},
            labelCount  = {getFont(2, "coins_font02", true), cc.p(0, 3), 1, 115},
            labelImage  = {getImage(2, "FREEGAME", true), cc.p(1, -32)},
        },
        totalwin =
        {
            position = cc.p(0,0),
            particle    = {getParticle(2,"winParticle", true), cc.p(0, 72)},
            animNode    = cc.p(0, 55),
            winLabel    = {getFont(2, "win_coins02", true), cc.p(0, 0), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 0), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 0), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 0), 1},
            label       = {getImage(2, "totalwin", true), cc.p(0, 10)},
        },
        maxbet =
        {
            position = cc.p(305, 45),
            button = {getImage(2, "maxbet_01", true), getImage(2, "maxbet_02", true), getImage(2, "maxbet_03", true), cc.p(0, 0) },
            image  = {getImage(2, "maxbet_03", true), cc.p(52.5, 42.5)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(312, 95)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-284, 97),
                scale = 1,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-284, 47),
            },
        },
        activityB = 
        {
            position  = cc.p(-580, 0),
            bg        = {getImage(2, "activity_b_list_bg_h", true), cc.p(0, 380)},
            btn       = {getSpine(2, "b_loading", true), cc.p(0, 150), 1},
            show_rect =
            {
                -1070, 0, 3000, 650
            },
            list_pos = cc.p(1070, -10),
            item_pos = cc.p(1000, 135)
        },
        themeIconDefault =
        {
            list_pos    = cc.p(0, 0),
            list_height = 110,
            list_scale  = 1,
        },
        spin =
        {
            position = cc.p(498, 44),
            autoOn = 
            {
                root       = cc.p(0, 151),
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
            	button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
            	button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
            	button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
            	button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
            	button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
            	button     = {getImage(2, "spin_01", true), getImage(2, "spin_02", true), getImage(2, "spin_03", true), cc.p(0, 0)},
            	labelStop  = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 58)},
                labelStopFast   = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin = 
            {
            	button            = {getImage(2, "spin_01", true), getImage(2, "spin_02", true), getImage(2, "spin_03", true), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage(2, "SPIN", true), getImage(2, "SPIN02", true)},
                    disable  = getImage(2, "SPIN_disable", true),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage(2, "HOLDFORAUTO", true), getImage(2, "HOLDFORAUTO02", true)},
                    disable  = getImage(2, "HOLDFORAUTO_disable", true),
                    position = cc.p(123, 27),
                },
            	labelStop         = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(125, 49)},
                spineCharge = {getSpine(2, "charge", true), cc.p(0, 0)}
            },
        },
        themeUserGuideQuest = 
        {
            item_pos = cc.p(-13, -15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBlast = 
        {
            item_pos = cc.p(5,9), -- -15
            item_height = 650,
            item_scale = 1, 
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBingo = 
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeRocket = 
        {
            item_pos = cc.p(5, 15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeJourney = 
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeUserGuide = 
        {
            item_pos = cc.p(5,-15),
            item_height = 650,
            item_scale = 1,
            list_posX = 0,
            list_height = 110,
            list_scale = 1,
        },
        themeMoreGames = 
        {
            position = cc.p(640,220),
        },
        themeCookingFrenzy = {
            item_pos = cc.p(90, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeArcher = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeWordsGame =
        {
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeGof = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeMansion = {
            item_pos = cc.p(70, 250),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
    },
    -- 竖版主题紫色footer
    [3] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2}
        },
        background = 
        {
            leftBg   = {getImage(3, "big_back_half", true), cc.p(0, 72), false},
            rightBg  = {getImage(3, "big_back_half", true), cc.p(0, 72), true},
            spine    = {getSpine(2, "frame_footer", true), cc.p(0, 824), "animation2"},
            animNode = cc.p(0, 135)
        },
        dashboard =
        {
            position = cc.p(303, 73),
            scale    = 1.25,
            unlockdashboard = 
            {
                bg    = {getImage(5, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(5, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(5, "Daily_Mission_ingame_right", true), cc.p(39, 59)},
                frame = {getImage(5, "Daily_Mission_ingame_frame_top", true), cc.p(39, 60)},
                giftspine = {getSpine(2, "claim", true), cc.p(40, 52)},
                label_bg  = {getImage(5, "Daily_Mission_ingame_box", true), cc.p(39, 13)},
                label  = {getFont(5, "Daily_Mission_ingame_front", true), cc.p(39, 14), 1},
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(-155, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "newplayer_yd_lbl25", true), cc.p(-100, 170), 0.7},
                },
                mission_tip = 
                {
                    bg     = {getImage(2, "bc_yh_ingme04", true), cc.p(54.5, 110), cc.p(0.81, 0.12)},
                },
                blazing_challenge = 
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard = 
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(-68, 160), true, 0.7},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },  
                collect_dashboard =
                {
                    root = {cc.p(37, 95), 0.8},
                    bg = {getImage(2, "di_dhk", true), cc.p(-40, 66.5), true, 1},
                    title = {getCommonNewFont("common_withe"), cc.p(-40, 98), 0.3, ""},
                    pos = cc.p(-40, 57.5),
                    spine = {getSpine(2, "tick", true), cc.p(20, 105), 0.8},
                    label = {
                        {getCommonNewFont("common_withe"), cc.p(-40, 70), 0.3, ""},
                        {getCommonNewFont("common_withe"), cc.p(-40, 45), 0.3, ""},
                    }
                },
            },
            lockdashboard = 
            {
                button = {getImage(5, "Daily_Mission_ingame_frame_disable", true), getImage(5, "Daily_Mission_ingame_frame_disable", true), getImage(5, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.75, 0.1), true},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(5, "Daily_Mission_ingame_front", true), cc.p(40, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(40, 48), 1},
            },
        },
        totalbet =
        {
            position = cc.p(-241, 80),
            bigBgImage     = {getImage(3, "wnzi_back", true), cc.p(0, 0)},
            smallBgImage   = {getImage(3, "freegame_backyellow", true), cc.p(58, -23.5)},
            subButton      = {getImage(3, "minus_h01", true), getImage(3, "minus_h02", true), getImage(3, "minus_h03", true), cc.p(-54.5, -56) },
            addButton      = {getImage(3, "plus_h01", true), getImage(3, "plus_h02", true), getImage(3, "plus_h03", true), cc.p(57, -56) },
            labelBet       = {getFont(5, "coins_font04", true), cc.p(0, 2), 0.8, 199, cc.p(59, -22), 1, 91}, 
            totalBetImage1 = {getImage(5, "totalbetzit", true), cc.p(-0.5, -21)},
            totalBetImage2 = {getImage(5, "totalbetzit", true), cc.p(58, -60.5)}, 
            animNode       = cc.p(0, 0),
            particle       = {getParticle(2, "max_bet_liziwenjian01_1", true), cc.p(0, 0)}, 
            max_bet_spine  = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(50, 180), 0.8},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "BY SPINNING!"},

                },
                big_bet = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-242, 132)},
            },
            voucher_bet_big = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-242, 153), 0.7},
            },
        },
        freegames =
        {
            position = cc.p(-299, 56.5),
            bgImage     = {getImage(3, "freegame_backyellow", true), cc.p(0, 0)},
            labelCount  = {getFont(5, "coins_font04", true), cc.p(0, 0), 1, 85},
            labelImage  = {getImage(5, "FREEGAME", true), cc.p(-1, -38)},
        },
        totalwin =
        {
            position = cc.p(-3, 110),
            particle    = {getParticle(2,"winParticle", true), cc.p(0, 2)},
            animNode    = cc.p(0, 40),
            winLabel    = {getFont(5, "win_coins02", true), cc.p(2, 0), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 15), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 15), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 15), 1},
            label       = {getImage(5, "totalwin", true), cc.p(0, 0)},
        },
        maxbet =
        {
            position = cc.p(192, 50),
            button = {getImage(5, "maxbet_01", true), getImage(5, "maxbet_02", true), getImage(5, "maxbet_03", true), cc.p(0, 0) },
            image  = {getImage(5, "maxbet_03", true), cc.p(52.5, 42.5)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(192, 100)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-234, 102),
                scale = 0.8,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-184, 32),
            },
        },
        activityB = 
        {
            position = cc.p(-290, 50),
            bg        = {getImage(2, "activity_b_list_bg_v", true), cc.p(0, 260)},
            btn       = {getSpine(2, "b_loading", true), cc.p(0, 80), 1},
            show_rect =
            {
                -1070, 0, 3000, 530
            },
            list_pos = cc.p(1045, 100),
            item_pos = cc.p(1000, 155),
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
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
                button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
                button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
                button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
                button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
                button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
                button     = {getImage(5, "spin_01", true), getImage(5, "spin_02", true), getImage(5, "spin_03", true), cc.p(0, 0)},
                labelStop  = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 58)},
                labelStopFast   = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin = 
            {
                button            = {getImage(5, "spin_01", true), getImage(5, "spin_02", true), getImage(5, "spin_03", true), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage(2, "SPIN", true), getImage(2, "SPIN02", true)},
                    disable  = getImage(2, "SPIN_disable", true),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage(5, "HOLDFORAUTO", true), getImage(5, "HOLDFORAUTO02", true)},
                    disable  = getImage(5, "HOLDFORAUTO_disable", true),
                    position = cc.p(123, 27),
                },
                labelStop         = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(125, 49)},
                spineCharge = {getSpine(2, "charge", true), cc.p(0, 0)}
            },
        },
        themeQuest = 
        {
            item_pos = cc.p(5,7),
            item_height = 620,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
            themeQuestEntrance = 
            {
                position = cc.p(-308, 223),
                button   = {getImage(2, "quest_entrance", true), getImage(2, "quest_entrance", true), getImage(2, "quest_entrance", true), cc.p(0, 5) },
                -- time     = {getFont(2, "lobby_quest_yellow_font", true), cc.p(64, 24), 1},
                spine    = {getSpine(2, "no_quest_entrance", true), cc.p(68.5, 54.5)},
            }, 
            loading = {getImage(2, "in_quest_small_logo_2", true), getImage(2, "in_quest_small_logo", true), cc.p(68.5, 0)},
            loading_label = {getFont(2, "sm_logo_font", true), cc.p(68.5, 0), 1 },
        },
        themeUserGuideQuest = 
        {
            item_pos = cc.p(-16, -6),
            item_height = 620,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeBlast = 
        {
            item_pos = cc.p(-6, 20),
            item_height = 533,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeBingo = 
        {
            item_pos = cc.p(0,14),
            item_height = 540,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeRocket = 
        {
            item_pos = cc.p(-10,23),
            item_height = 550,
            item_scale = 0.75,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeJourney = 
        {
            item_pos = cc.p(0, 25),
            item_height = 515,
            item_scale = 0.65,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeUserGuide = 
        {
            item_pos = cc.p(-10,7),
            item_height = 560,
            item_scale = 0.75,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeTreasure = 
        {
            item_pos = cc.p(0,65),
            item_height = 500,
            item_scale = 0.6,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        -- themeBuildYourDream =
        -- {
        --     list_pos = cc.p(0, 0),
        --     list_height = 110,
        --     list_scale = 0.68,
        -- },
        themeMoreGames = 
        {
            position = cc.p(360,380),
        },
        themeCookingFrenzy = {
            item_pos = cc.p(60, 0),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeArcher = {
            item_pos = cc.p(60, 0),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeWordsGame =
        {
            list_pos    = cc.p(0, 0),
            list_height = 110,
            list_scale  = 0.68,
        },
        themeGof = {
            item_pos = cc.p(45, 0),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeMansion = {
            item_pos = cc.p(45, 270),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
    },
    -- 横版主题紫色footer
    [5] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2},
        },
        background = 
        {
            leftBg   = {getImage(5, "big_back_half", true), cc.p(0, 48), true},
            rightBg  = {getImage(5, "big_back_half", true), cc.p(0, 48), false},
            spine    = {getSpine(2, "frame_footer", true), cc.p(0, 360 + 58), "animation1"},
        },
        dashboard =
        {
            position = cc.p(-588, 50),
            unlockdashboard = 
            {
                bg    = {getImage(5, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(5, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(5, "Daily_Mission_ingame_right", true), cc.p(39, 59)},
                frame = {getImage(5, "Daily_Mission_ingame_frame_top", true), cc.p(39, 60)},
                giftspine = {getSpine(2, "claim", true), cc.p(40, 52)},
                label_bg  = {getImage(5, "Daily_Mission_ingame_box", true), cc.p(39, 13)},
                label  = {getFont(5, "Daily_Mission_ingame_front", true), cc.p(39, 14), 1},
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(195, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "new_player_dashtips", true), cc.p(250, 210), 1},
                },
                mission_tip = 
                {
                    bg     = {getImage(2, "bc_yh_ingme01", true), cc.p(70, 100), cc.p(0.22, 0.12)},
                },
                blazing_challenge = 
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard = 
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(198, 200), false, 1},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },  
                collect_dashboard =
                {
                    root = {cc.p(45, 95), 1},
                    bg = {getImage(2, "di_dhk", true), cc.p(40, 66.5), false, 1},
                    title = {getCommonNewFont("common_withe"), cc.p(40, 98), 0.3, ""},
                    pos = cc.p(40, 57.5),
                    spine = {getSpine(2, "tick", true), cc.p(100, 105), 0.8},
                    label = {
                        {getCommonNewFont("common_withe"), cc.p(40, 70), 0.3, ""},
                        {getCommonNewFont("common_withe"), cc.p(40, 45), 0.3, ""},
                    }
                },
            },
            lockdashboard = 
            {
                button = {getImage(5, "Daily_Mission_ingame_frame_disable", true), getImage(5, "Daily_Mission_ingame_frame_disable", true), getImage(5, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(5, "Daily_Mission_ingame_front", true), cc.p(40, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(40, 48), 1},
            },
        },
        totalbet =
        {
            position          = cc.p(-395.5, 43),
            bigBgImage        = {getImage(5, "bes_gameback", true), cc.p(0, 0)},
            smallBgImage      = {getImage(5, "free_gameback", true), cc.p(76, 0)},
            subButton         = {getImage(5, "minus01", true), getImage(5, "minus02", true), getImage(5, "minus03", true), cc.p(-111, 4), 1},
            addButton         = {getImage(5, "plus01", true), getImage(5, "plus02", true), getImage(5, "plus03", true), cc.p(111, 4), 1},
            labelBet          = {getFont(5, "coins_font04", true), cc.p(0, 3), 1, 162, cc.p(76, 3), 1, 115},
            totalBetImage1    = {getImage(5, "totalbetzit", true), cc.p(3, -32)},
            totalBetImage2    = {getImage(5, "totalbetzit", true), cc.p(74, -32)},
            animNode          = cc.p(0, 0),
            particle          = {getParticle(2,"max_bet_liziwenjian01_1", true), cc.p(0, 0)},
            max_bet_spine     = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(0, 176)},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "BY SPINNING!"},

                },
                big_bet = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-395, 94)},
            },
            voucher_bet_big = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-395, 136.5)},
            },
        },
        freegames =
        {
            position = cc.p(-468, 43),
            bgImage     = {getImage(5, "free_gameback", true), cc.p(0, 0)},
            labelCount  = {getFont(5, "coins_font04", true), cc.p(0, 3), 1, 115},
            labelImage  = {getImage(5, "FREEGAME", true), cc.p(1, -32)},
        },
        totalwin =
        {
            position     = cc.p(0,0),
            particle     = {getParticle(2,"winParticle", true), cc.p(0, 12)},
            animNode     = cc.p(0, 55),
            winLabel     = {getFont(5, "win_coins02", true), cc.p(0, 0), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 0), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 0), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 0), 1},
            label        = {getImage(5, "totalwin", true), cc.p(0, 10)},
        },
        maxbet =
        {
            position = cc.p(305, 45),
            button = {getImage(5, "maxbet_01", true), getImage(5, "maxbet_02", true), getImage(5, "maxbet_03", true), cc.p(0, 0) },
            image  = {getImage(5, "maxbet_03", true), cc.p(52.5, 42.5)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(312, 95)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-284, 97),
                scale = 1,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-284, 47),
            },
        },
        activityB = 
        {
            position  = cc.p(-580, 0),
            bg        = {getImage(2, "activity_b_list_bg_h", true), cc.p(0, 380)},
            btn       = {getSpine(2, "b_loading", true), cc.p(0, 150), 1},
            show_rect =
            {
                -1070, 0, 3000, 650
            },
            list_pos = cc.p(1070, -10),
            item_pos = cc.p(1000, 135)
        },
        themeIconDefault =
        {
            list_pos    = cc.p(0, 0),
            list_height = 110,
            list_scale  = 1,
        },
        spin =
        {
            position = cc.p(498, 44),
            autoOn = 
            {
                root       = cc.p(0, 151),
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
                button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
                button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
                button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
                button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
                button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
                button     = {getImage(5, "spin_01", true), getImage(5, "spin_02", true), getImage(5, "spin_03", true), cc.p(0, 0)},
                labelStop  = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 58)},
                labelStopFast   = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin = 
            {
                button            = {getImage(5, "spin_01", true), getImage(5, "spin_02", true), getImage(5, "spin_03", true), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage(2, "SPIN", true), getImage(2, "SPIN02", true)},
                    disable  = getImage(2, "SPIN_disable", true),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage(5, "HOLDFORAUTO", true), getImage(5, "HOLDFORAUTO02", true)},
                    disable  = getImage(5, "HOLDFORAUTO_disable", true),
                    position = cc.p(123, 27),
                },
                labelStop         = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(125, 49)},
                spineCharge = {getSpine(2, "charge", true), cc.p(0, 0)}
            },
        },
        themeUserGuideQuest = 
        {
            item_pos = cc.p(-13, -15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBlast = 
        {
            item_pos = cc.p(5,9), -- -15
            item_height = 650,
            item_scale = 1, 
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBingo = 
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeRocket = 
        {
            item_pos = cc.p(5, 15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeJourney = 
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeUserGuide = 
        {
            item_pos = cc.p(5,-15),
            item_height = 650,
            item_scale = 1,
            list_posX = 0,
            list_height = 110,
            list_scale = 1,
        },
        themeMoreGames = 
        {
            position = cc.p(640,220),
        },
        themeCookingFrenzy = {
            item_pos = cc.p(90, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeArcher = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeWordsGame =
        {
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeGof = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeMansion = {
            item_pos = cc.p(70, 250),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
    },
    -- 竖版主题金色footer
    [7] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2}
        },
        background = 
        {
            leftBg  = {getImage(7, "big_back_yellowfooter", true), cc.p(0, 72), false},
            rightBg = {getImage(7, "big_back_yellowfooter", true), cc.p(0, 72), true},
            spine   = {getSpine(2, "frame_footer", true), cc.p(0, 824), "animation2"},
        },
        dashboard =
        {
            position = cc.p(303, 73),
            scale    = 1.25,
            unlockdashboard = 
            {
                bg    = {getImage(2, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(2, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(2, "Daily_Mission_ingame_right", true), cc.p(39, 59)},
                frame = {getImage(2, "Daily_Mission_ingame_frame_top", true), cc.p(39, 60)},
                giftspine = {getSpine(2, "claim", true), cc.p(40, 52)},
                label_bg  = {getImage(2, "Daily_Mission_ingame_box", true), cc.p(39, 13)},
                label  = {getFont(2, "Daily_Mission_ingame_front", true), cc.p(39, 14), 1},
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(-155, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "newplayer_yd_lbl25", true), cc.p(-100, 170), 0.7},
                },
                mission_tip = 
                {
                    bg     = {getImage(2, "bc_yh_ingme04", true), cc.p(54.5, 110), cc.p(0.81, 0.12)},
                },
                blazing_challenge = 
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard = 
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(-68, 160), true, 0.7},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },  
                collect_dashboard =
                {
                    root = {cc.p(37, 95), 0.8},
                    bg = {getImage(2, "di_dhk", true), cc.p(-40, 66.5), true, 1},
                    title = {getCommonNewFont("common_withe"), cc.p(-40, 98), 0.3, ""},
                    pos = cc.p(-40, 57.5),
                    spine = {getSpine(2, "tick", true), cc.p(20, 105), 0.8},
                    label = {
                        {getCommonNewFont("common_withe"), cc.p(-40, 70), 0.3, ""},
                        {getCommonNewFont("common_withe"), cc.p(-40, 45), 0.3, ""},
                    }
                },
            },
            lockdashboard = 
            {
                button = {getImage(2, "Daily_Mission_ingame_frame_disable", true), getImage(2, "Daily_Mission_ingame_frame_disable", true), getImage(2, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.75, 0.1), true},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(2, "Daily_Mission_ingame_front", true), cc.p(40, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(40, 48), 1},
            },
        },
        totalbet =
        {
            position          = cc.p(-241, 80),
            bigBgImage        = {getImage(7, "wnzi_backyellow", true), cc.p(0, 0)},
            smallBgImage      = {getImage(7, "freegame_backyellow", true), cc.p(58, -23.5)},
            subButton         = {getImage(7, "minus_h01", true), getImage(7, "minus_h02", true), getImage(7, "minus_h03", true), cc.p(-54.5, -56) },
            addButton         = {getImage(7, "plus_h01", true), getImage(7, "plus_h02", true), getImage(7, "plus_h03", true), cc.p(57, -56) },
            labelBet          = {getFont(2, "coins_font02", true), cc.p(0, 2), 0.8, 199, cc.p(59, -22), 1, 91}, 
            totalBetImage1    = {getImage(2, "totalbetzit", true), cc.p(-0.5, -21)},
            totalBetImage2    = {getImage(2, "totalbetzit", true), cc.p(58, -60.5)}, 
            animNode          = cc.p(0, 0),
            particle          = {getParticle(2, "max_bet_liziwenjian01_1", true), cc.p(0, 0)}, 
            max_bet_spine     = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(50, 180), 0.8},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "BY SPINNING!"},

                },
                big_bet = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-242, 132)},
            },
            voucher_bet_big = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-242, 153), 0.7},
            },
        },
        freegames =
        {
            position = cc.p(-299, 56.5),
            bgImage     = {getImage(7, "freegame_backyellow", true), cc.p(0, 0)},
            labelCount  = {getFont(2, "coins_font02", true), cc.p(0, 0), 1, 85},
            labelImage  = {getImage(2, "FREEGAME", true), cc.p(-1, -38)},
        },
        totalwin =
        {
            position = cc.p(-3, 110),
            particle    = {getParticle(2,"winParticle", true), cc.p(0, 2)},
            animNode    = cc.p(0, 40),
            winLabel    = {getFont(2, "win_coins02", true), cc.p(2, 0), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 15), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 15), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 15), 1},
            label       = {getImage(2, "totalwin", true), cc.p(0, 0)},
        },
        maxbet =
        {
            position = cc.p(192, 50),
            button = {getImage(2, "maxbet_01", true), getImage(2, "maxbet_02", true), getImage(2, "maxbet_03", true), cc.p(0, 0) },
            image  = {getImage(2, "maxbet_03", true), cc.p(52.5, 42.5)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(192, 95)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-234, 102),
                scale = 0.8,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-184, 32),
            },
        },
        activityB = 
        {
            position = cc.p(-290, 50),
            bg        = {getImage(2, "activity_b_list_bg_v", true), cc.p(0, 260)},
            btn       = {getSpine(2, "b_loading", true), cc.p(0, 80), 1},
            show_rect =
            {
                -1070, 0, 3000, 530
            },
            list_pos = cc.p(1045, 100),
            item_pos = cc.p(1000, 155),
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
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
                button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
                button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
                button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
                button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
                button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
                button     = {getImage(2, "spin_01", true), getImage(2, "spin_02", true), getImage(2, "spin_03", true), cc.p(0, 0)},
                labelStop  = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 58)},
                labelStopFast   = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin = 
            {
                button            = {getImage(2, "spin_01", true), getImage(2, "spin_02", true), getImage(2, "spin_03", true), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage(2, "SPIN", true), getImage(2, "SPIN02", true)},
                    disable  = getImage(2, "SPIN_disable", true),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage(2, "HOLDFORAUTO", true), getImage(2, "HOLDFORAUTO02", true)},
                    disable  = getImage(2, "HOLDFORAUTO_disable", true),
                    position = cc.p(123, 27),
                },
                labelStop         = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(125, 49)},
                spineCharge = {getSpine(2, "charge", true), cc.p(0, 0)}
            },
        },
        themeQuest = 
        {
            item_pos = cc.p(5,7),
            item_height = 620,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
            themeQuestEntrance = 
            {
                position = cc.p(-308, 223),
                button   = {getImage(2, "quest_entrance", true), getImage(2, "quest_entrance", true), getImage(2, "quest_entrance", true), cc.p(0, 5) },
                -- time     = {getFont(2, "lobby_quest_yellow_font", true), cc.p(64, 24), 1},
                spine    = {getSpine(2, "no_quest_entrance", true), cc.p(68.5, 54.5)},
            }, 
            loading = {getImage(2, "in_quest_small_logo_2", true), getImage(2, "in_quest_small_logo", true), cc.p(68.5, 0)},
            loading_label = {getFont(2, "sm_logo_font", true), cc.p(68.5, 0), 1 },
        },
        themeUserGuideQuest = 
        {
            item_pos = cc.p(-16, -6),
            item_height = 620,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeBlast = 
        {
            item_pos = cc.p(-6, 20),
            item_height = 533,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeBingo = 
        {
            item_pos = cc.p(0,14),
            item_height = 540,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeRocket = 
        {
            item_pos = cc.p(-10,23),
            item_height = 550,
            item_scale = 0.75,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeJourney = 
        {
            item_pos = cc.p(0, 25),
            item_height = 515,
            item_scale = 0.65,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeUserGuide = 
        {
            item_pos = cc.p(-10,7),
            item_height = 560,
            item_scale = 0.75,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeTreasure = 
        {
            item_pos = cc.p(0,65),
            item_height = 500,
            item_scale = 0.6,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        -- themeBuildYourDream =
        -- {
        --     list_pos = cc.p(0, 0),
        --     list_height = 110,
        --     list_scale = 0.68,
        -- },
        themeMoreGames = 
        {
            position = cc.p(360,380),
        },
        themeCookingFrenzy = {
            item_pos = cc.p(60, 0),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeArcher = {
            item_pos = cc.p(60, 0),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeWordsGame =
        {
            list_pos    = cc.p(0, 0),
            list_height = 110,
            list_scale  = 0.68,
        },
        themeGof = {
            item_pos = cc.p(45, 0),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
        themeMansion = {
            item_pos = cc.p(45, 270),
            item_height = 530,
            item_scale = 0.7,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 0.68,
        },
    },
    -- 大厅金色横屏
    [8] =
    {
        background = 
        {
            bg_more = 
            {
                bg            = {getImage(8, "background_more", true), cc.p(0, -142.5), cc.p(0.5, 0)},
                btn_close     = {getImage(8, "main_btn01", true), getImage(8, "main_btn02", true), getImage(8, "main_btn02", true), cc.p(898, 124)}, 
                btn_see_more  = {getImage(8, "main_btn03", true), getImage(8, "main_btn04", true), getImage(8, "main_btn04", true), cc.p(430, 60.5)},
                btn_see_more2 = {getCommonImage("kong"), getCommonImage("kong"), getCommonImage("kong"), cc.p(433, 62), 9},
                btn_close2 = {getCommonImage("kong"), getCommonImage("kong"), getCommonImage("kong"), cc.p(433, -18), 8, 25},
                red           = {getSpine(1, "red"), cc.p(453, 92)},
                spine_close   = {getSpine(1, "close", true), cc.p(71/2, 248/2)},
                line          = 
                {
                    {getImage(8, "background_line_more", true), cc.p(140, 123)},
                    {getImage(8, "background_line_more", true), cc.p(260, 123)},
                    {getImage(8, "background_line_more", true), cc.p(380, 123)},
                    {getImage(8, "background_line_more", true), cc.p(500, 123)},
                    {getImage(8, "background_line_more", true), cc.p(620, 123)},
                    {getImage(8, "background_line_more", true), cc.p(740, 123)},
                },
            },
            bg1 = {getImage(8, "background_top", true), cc.p(0, 42), true},
            bg2 = {getImage(8, "background", true), cc.p(390, 59)},
            bg3 = {getImage(8, "background", true), cc.p(-390, 59), true},
        },
        lobby =
        {
            button   = {getImage(1, "fh_LoungePoints_icon", true), getImage(1, "lobby_btn02", true), getImage(1, "fh_LoungePoints_icon", true), cc.p(10, 14), 1},
            bg_frame = {getImage(1, "fh_LoungePoints_jdtframe", true), cc.p(57, 24)},
            container =
            {
                position = cc.p(20, 14),
                size     = cc.size(74, 18),
                image    = {getImage(1, "fh_LoungePoints_jdt", true), cc.p(-37, 10)},
                image2   = getImage(1, "fh_LoungePoints_jdt02", true),
                min      = -37,
                max      = 37,
            },
            fg_frame = {getImage(1, "fh_LoungePoints_jdtframe03", true), cc.p(57, 24)},
            label = {getFont(1, "LoungePoints_sj_font", true), cc.p(57, 17), 1},
            count = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 21), 1},
            },
            name       = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_lounge", 112},
            new        = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
            time       = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            lock       = {getImage(1, "lobby_btn02", true), getImage(1, "lobby_btn02", true), getImage(1, "lobby_btn02", true), cc.p(10, 14)},
            lock_spine = {getSpine(1, "lock", true), cc.p(10, -18), 1},
            lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
            lock_info  = {
                root        = {cc.p(0, 0)},
                bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
            },
        },
        pig =
        {
            label  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_money_bank", 112},
            button = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_pressdown", true), getImage(1, "lobby_money_pressdown", true), cc.p(0, 0)},
            coupon = {getImage(1, "lobby_money_coupon01", true), cc.p(-7, 4), 1},
            max    = {getImage(1, "moneybank_img_1", true), cc.p(0, 30), 1},
            tips   = 
            { 
                tip         = {getImage(1, "zisediban", true), cc.p(170, 170)},
                ratio       = {getFont(1, "pop_ups_fnt", true), cc.p(184, 61), 1},
                bg          = {getImage(1, "lobby_piaodai", true), cc.p(0, -29)},
                label_node1 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                label_node2 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                special_offer_label = {getFont(1, "Level_upparty_booster_fnt"), cc.p(56, 19), 0.75}, -- 单行label
            },
            BFtips = 
            {
                tip         = {getImage(1, "bf_popup_img01", true), cc.p(120, 100)},
                ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            },
            -- BDStips = 
            -- {
            --     tip         = {getImage(1, "bf_popup_img02", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BDSpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            -- Christmastips = 
            -- {
            --     tip         = {getImage(1, "christmas_popup_img01", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            loading = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_gray", true), cc.p(0, 0), 1},
        },
        pig_right =
        {
            position    = cc.p(557, 95),
            label  = {getFont(1, "footer_fnt03", true), cc.p(0, -75), 1, "LOBBY.footer_money_bank", 150},
            label_now = {getFont(1, "footer_fnt02", true), cc.p(0, - 75), 1, "LOBBY.footer_open_now", 150},
            button = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_pressdown", true), getImage(1, "lobby_money_pressdown", true), cc.p(0, 0), 0.8},
            coupon = {getImage(1, "lobby_money_coupon01", true), cc.p(-7, 4), 1},
            max    = {getImage(1, "moneybank_img_1", true), cc.p(0, 30), 1},
            lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
            tips   = 
            { 
                tip         = {getImage(1, "zisediban", true), cc.p(170, 170)},
                ratio       = {getFont(1, "pop_ups_fnt", true), cc.p(184, 61), 1},
                bg          = {getImage(1, "lobby_piaodai", true), cc.p(0, -29)},
                label_node1 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                label_node2 = 
                {
                    cc.p(55, 17),
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(1, 10), 0.75},
                    {getFont(1, "Level_upparty_booster_fnt"), cc.p(2, -5), 0.75},
                },
                special_offer_label = {getFont(1, "Level_upparty_booster_fnt"), cc.p(56, 19), 0.75}, -- 单行label
            },
            BFtips = 
            {
                tip         = {getImage(1, "bf_popup_img01", true), cc.p(120, 100)},
                ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            },
            -- BDStips = 
            -- {
            --     tip         = {getImage(1, "bf_popup_img02", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BDSpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            -- Christmastips = 
            -- {
            --     tip         = {getImage(1, "christmas_popup_img01", true), cc.p(120, 100)},
            --     ratio       = {getFont(1, "BFpop_ups_fnt", true), cc.p(215, 61), 0.82},
            -- },
            loading = {getImage(1, "lobby_money", true), getImage(1, "lobby_money_pressdown", true), cc.p(0, 0), 0.8},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(0, 0), 1},
        },

        facebook =
        {
            facebook1 = 
            {
                button = {getImage(1, "facebook_jl", true), getImage(1, "facebook_jl02", true), getImage(1, "facebook_jl02", true), cc.p(10, 14), 0.7},
            },
            facebook2 = 
            {
                button = {getImage(1, "facebook01", true), getImage(1, "facebook02", true), getImage(1, "facebook02", true), cc.p(10, 14), 0.7},
            },
            friends = 
            {
                button = {getImage(1, "friends", true), getImage(1, "friends02", true), getImage(1, "friends02", true), cc.p(10, 14), 0.7},
            },
            label_facebook = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_facebook", 112},
            label_friend   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_friend", 112},
        },
        userguide_quest =
        {
            unlockquest = 
            {
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_quest_frenzy", 112},
                button  = {getImage(1, "userguide_quest_1", true), getImage(1, "userguide_quest_2", true), getImage(1, "userguide_quest_2", true), cc.p(10, 16)},
                new     = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -17), 1},
                time    = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
             },
            loading = {getImage(1, "userguide_quest_1", true), getImage(1, "userguide_quest_2", true), cc.p(10, 16), 1},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        mansion =
        {
            position = cc.p(-557, 89),
            mansion = 
            {
                button = {getImage(1, "mansion_icon01", true), getImage(1, "mansion_icon02", true), getImage(1, "mansion_icon02", true), cc.p(10, 16), 0.7},
                name   = {getImage(1, "mansion_name", true), cc.p(10, -45), 1},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_mansion_quest", 112},
            },
            disable = 
            {
                button = {getImage(1, "mansion_icon02", true), getImage(1, "mansion_icon02", true), getImage(1, "mansion_icon02", true), cc.p(10, 16), 0.7},
                lock_spine = {getSpine(1, "lock", true), cc.p(100, 38), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 55), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            count = 
            {
                red  = {getSpine(1, "red"), cc.p(45, 20)},
            },
            loading = {getImage(1, "mansion_icon01", true), getImage(1, "mansion_icon03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 14), 1},
        },
        atw =
        {
            atw = 
            {
                button = {getImage(1, "around_lobby_btn01", true), getImage(1, "around_lobby_btn02", true), getImage(1, "around_lobby_btn02", true), cc.p(10, 14), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_atw", 112},
                new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            },
            disable = 
            {
                button = {getImage(1, "around_lobby_btn02", true), getImage(1, "around_lobby_btn02", true), getImage(1, "around_lobby_btn02", true), cc.p(10, 14), 0.7},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                lock_spine = {getSpine(1, "lock", true), cc.p(10, -18), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
            },
            count  = 
            {
                red  = {getSpine(1, "red"), cc.p(45, 20)},
            },
            loading = {getImage(1, "around_lobby_btn01", true), getImage(1, "around_lobby_btn02", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        club =
        {
            position = cc.p(-557, 95),
            club = 
            {
                button = {getImage(1, "club_lobby_btn01", true), getImage(1, "club_lobby_btn02", true), getImage(1, "club_lobby_btn02", true), cc.p(0, 0), 0.8},
                label  = {getFont(1, "footer_fnt03", true), cc.p(0, -75), 1, "LOBBY.footer_cash_club", 150},
            },
            disable = 
            {
                button = {getImage(1, "club_lobby_btn02", true), getImage(1, "club_lobby_btn02", true), getImage(1, "club_lobby_btn02", true), cc.p(0, 0), 0.8},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(124, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(124, 64), 1, "TO UNLOCK"},
                },
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1.4},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
            },
            count  = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
            },
            loading = {getImage(1, "club_lobby_btn01", true), getImage(1, "club_lobby_btn02", true), cc.p(0, 0), 0.8},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(0, 0), 1},
        },
        blast =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "lobby_pickfrenzy_icon01", true), getDynamicImage(1, "lobby_pickfrenzy_icon02", true), getDynamicImage(1, "lobby_pickfrenzy_icon02", true), cc.p(10, 14), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -17), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "lobby_pickfrenzy_icon01", true), getDynamicImage(1, "lobby_pickfrenzy_icon03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_blast", 112},
        },
        bingo =
        {
            -- bingo = 
            -- {
            --     button = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon02", true), getDynamicImage(1, "lobby_bingo_icon02", true), cc.p(-1, -1), 0.9},
            --     shadow = {getImage(1, "tb_touying", true), cc.p(0, -35), 127.5},
            --     -- label  = {getImage(1, "bingo_frenzy", true), cc.p(0,-56),0.9},
            --     label  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_bingo", 112},
            --     -- new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(57, 20) },
            --     new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
            --     time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            -- },
            -- count  = 
            -- {
            --     image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
            --     label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
            --     red  = {getSpine(1, "red"), cc.p(45, 20)},
            -- },
            -- loading = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon03", true), cc.p(-1, -5),0.9},

            unlock = 
            {
                button = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon02", true), getDynamicImage(1, "lobby_bingo_icon02", true), cc.p(10, 14), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "lobby_bingo_icon", true), getDynamicImage(1, "lobby_bingo_icon03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_bingo", 112},
        },
        rocket =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "chutes_rockets", true), getDynamicImage(1, "chutes_rockets02", true), getDynamicImage(1, "chutes_rockets02", true), cc.p(10, 16), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -17), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "chutes_rockets", true), getDynamicImage(1, "chutes_rockets03", true), cc.p(10, 16), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_rocket", 112},
        },
        journey =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "cashjourney_logo01", true), getDynamicImage(1, "cashjourney_logo02", true), getDynamicImage(1, "cashjourney_logo02", true), cc.p(10, 0), 1, 0.7},
                timeBg    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count = {cc.p(35, 27)},
            }, 
            loading = {getDynamicImage(1, "cashjourney_logo01", true), getDynamicImage(1, "cashjourney_logo02", true), cc.p(10, 0), 0.7}, 
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_journey", 112},
        },
        cooking =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "cookingfrenzy_logo01", true), getDynamicImage(1, "cookingfrenzy_logo03", true), getDynamicImage(1, "cookingfrenzy_logo03", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "cookingfrenzy_logo01", true), getDynamicImage(1, "cookingfrenzy_logo02", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_cooking", 112},
        },
        archer =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "archer_lobby_icon01", true), getDynamicImage(1, "archer_lobby_icon03", true), getDynamicImage(1, "archer_lobby_icon03", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "archer_lobby_icon01", true), getDynamicImage(1, "archer_lobby_icon02", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_archer", 112},
        },
        gof =
        {
            unlock = 
            {
                button = {getDynamicImage(1, "logo_gameforune_img01", true), getDynamicImage(1, "logo_gameforune_img02", true), getDynamicImage(1, "logo_gameforune_img02", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "logo_gameforune_img01", true), getDynamicImage(1, "logo_gameforune_img03", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_gof", 112},
        },
        mow =
        { 
            unlock = 
            {
                button = {getDynamicImage(1, "lobby_mowfrenzy_icon01", true), getDynamicImage(1, "lobby_mowfrenzy_icon02", true), getDynamicImage(1, "lobby_mowfrenzy_icon02", true), cc.p(10, 0), 0.7},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(10, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -30), 1},
                count  = {cc.p(45, 20)},
            },
            loading = {getDynamicImage(1, "lobby_mowfrenzy_icon01", true), getDynamicImage(1, "lobby_mowfrenzy_icon03", true), cc.p(10, 0), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
            title   = {getFont(1, "new_lobby_fnt", true), cc.p(10, -55), 1, "LOBBY.footer_mow", 112},
        },
        dashboard =
        {
            enable = 
            {
                button = {getImage(1, "lobby_logo_mission01", true), getImage(1, "lobby_logo_mission02", true), getImage(1, "lobby_logo_mission02", true), cc.p(0, 14), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(5, -45), 1, "LOBBY.footer_mission", 112},
            },
            disable = 
            {
                button = {getImage(1, "lobby_logo_mission02", true), getImage(1, "lobby_logo_mission02", true), getImage(1, "lobby_logo_mission02", true), cc.p(0, 14), 0.7},
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info       = 
                {
                    root   = {cc.p(0, 0)},
                    bg     = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            count = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20), 0.9},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 21), 1},
            },
            loading = {getImage(1, "lobby_logo_mission01", true), getImage(1, "lobby_logo_mission02", true), cc.p(0, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        wheel =
        {
            position = cc.p(568, 0), -- 已修改
            particle       = {getParticle(1,"megaball", true), cc.p(-4.5, 56)},
            megaballSpine  = {getSpine(1, "megaball", true), cc.p(-10, 89)},
            container =
            {
                position = cc.p(-134, 39),
                size = cc.size(230, 150),
                wheel = 
                {
                    button = {getImage(1, "wheel", true), getImage(1, "wheel", true), getImage(1, "wheel", true), cc.p(130, 11) },
                    spine  = {getSpine(1, "wheel", true), cc.p(92, -13)}
                },
                rewards = 
                {
                    spine_bg    = {getSpine(1, "daily_reward_bg", true), cc.p(124, 48)},
                    button      = {getImage(1, "lobby_footer_coin", true), getImage(1, "lobby_footer_coin02", true), getImage(1, "lobby_footer_coin02", true), cc.p(124, 48)},
                    spine_front = {getSpine(1, "daily_reward_front", true), cc.p(124, 48)},
                    count       = 
                    {
                        image  = {getImage(1, "yeqian_01", true), cc.p(175, 73)},
                        label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
                    },
                },
                megaball = 
                {
                    button = {getImage(1, "megaball_lobby01", true), getImage(1, "megaball_lobby02", true), getImage(1, "megaball_lobby02", true), cc.p(130, 48) },
                },
            },
            img_play_now = {getImage(1, "daily_bonus_play_now", true), cc.p(-10, 22)},
            lable2       = {getImage(1, "daily_bonus_collect", true), cc.p(-9, 22)},
            next_wheel   =
            {
                pos = cc.p(-10, 33),
                images =
                {
                    {getImage(8, "WHEEL_OF_CASHIN", true), cc.p(6, -16),1},
                    {getImage(1, "slotofcash_dating_bar04", true), cc.p(6, 1),1},
                },
                progress = 
                {
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(-53.5, 0.5), 1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(-24, 0.5), 1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(5.5, 0.5), 1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(35, 0.5),  1},
                    {getImage(1, "slotofcash_dating_bar02", true), cc.p(63.5, 0.5),  1},
                },
            },
            next_megaball =
            {
                pos = cc.p(-10, 33),
                images =
                {
                    {getImage(8, "daily_bonus_megaball", true), cc.p(2, -16)},
                    {getImage(1, "lobby_footer_lotto_jd02", true), cc.p(-54, 1)},
                    {getImage(1, "lobby_footer_lotto_jd02", true), cc.p(0, 1)},
                    {getImage(1, "lobby_footer_lotto_jd02", true), cc.p(54, 1)},
                },
                labels =
                {
                    {getImage(1, "lobby_footer_lotto_jd01", true), cc.p(-54, 2)},
                    {getImage(1, "lobby_footer_lotto_jd01", true), cc.p(0, 2)},
                    {getImage(1, "lobby_footer_lotto_jd01", true), cc.p(54, 2)},
                },
            }
        },
        bonus =
        {
            wheel = 
            {
                button = {getImage(1, "lobby_bonus_soc_icon01", true), getImage(1, "lobby_bonus_soc_icon02", true), getImage(1, "lobby_bonus_soc_icon02", true), cc.p(10, 12)},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_soc", 112},
            },
            rewards = 
            {
                spine_bg    = {getSpine(1, "daily_reward_bg", true), cc.p(10, 0), 0.6},
                button      = {getImage(1, "lobby_bonus_wheel_icon01", true), getImage(1, "lobby_bonus_wheel_icon02", true), getImage(1, "lobby_bonus_wheel_icon02", true), cc.p(10, 14), 0.7},
                label       = {getFont(1, "new_lobby_fnt", true), cc.p(10, - 45), 1, "LOBBY.footer_free_bonus", 112},
                count       = 
                {
                        image  = {getImage(1, "yeqian_01", true), cc.p(45, 20)},
                        label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
                },
            },
            megaball = 
            {
                button = {getImage(1, "lobby_bonus_bgq_icon01", true), getImage(1, "lobby_bonus_bgq_icon02", true), getImage(1, "lobby_bonus_bgq_icon02", true), cc.p(4, 14)},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_pachincoin", 112},
            },
        },
        inbox =
        {
            gift = 
            {
                button = {getImage(1, "INBOX01", true), getImage(1, "INBOX02", true), getImage(1, "INBOX02", true), cc.p(10, 14), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_inbox", 112},
            },
            count = 
            {
                image  = {getImage(1, "yeqian_01", true), cc.p(45, 20), 0.9},
                label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
            },
            loading = {getImage(1, "INBOX01", true), getImage(1, "INBOX02", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(20, 0), 1},
        },
        booster =
        {
            booster = 
            {
                button = {getImage(1, "booster01", true), getImage(1, "booster02", true), getImage(1, "booster02", true), cc.p(10, 14)},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_boosters", 112},
            },
        },
        chips =
        {
            chips = 
            {
                button = {getImage(1, "headbooster_icon01", true), getImage(1, "headbooster_icon02", true), getImage(1, "headbooster_icon02", true), cc.p(5, 14), 0.9},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_emerald", 112},
            },
        },
        stamps =
        {
            stamps = 
            {
                button     = {getImage(1, "AmazingStamps_icon", true), getImage(1, "AmazingStamps_icon02", true), getImage(1, "AmazingStamps_icon02", true), cc.p(10, 14), 0.66},
                label      = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_stamp", 112},
                frenzy     = {getImage(1, "stamp_frenzy", true), cc.p(19, 92), 1, -40},
                words_game = {getImage(1, "stamp_words_game", true), cc.p(90, 85), 0.68},
                new        = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time       = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
            },
            lockstamps = 
            {
                button     = {getImage(1, "AmazingStamps_icon02", true), getImage(1, "AmazingStamps_icon02", true), getImage(1, "AmazingStamps_icon02", true), cc.p(10, 14), 0.66},
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1}, 
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info   = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            loading = {getImage(1, "AmazingStamps_icon", true), getImage(1, "AmazingStamps_icon_disable", true), cc.p(10, 14), 0.66},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 0), 1},
        },
        byd =
        {
            enable = 
            {
                button = {getImage(1, "lobby_footer_byd01", true), getImage(1, "lobby_footer_byd02", true), getImage(1, "lobby_footer_byd02", true), cc.p(10, 14), 1},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_byd", 112},
                new    = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                count  = 
                {
                    image  = {getImage(1, "yeqian_01", true), cc.p(45, 20), 0.9},
                    label  = {getFont(1, "lobby_count", true), cc.p(22, 20), 1},
                },
            },
            disable = 
            {
                button     = {getImage(1, "lobby_footer_byd02", true), getImage(1, "lobby_footer_byd02", true), getImage(1, "lobby_footer_byd02", true), cc.p(10, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(10, -18), 1},
                lock_sp = {getImage(1, "lobby_lock", true), cc.p(36, -18), 1},
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(0, 45), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
            },
            loading = {getImage(13, "lobby_footer_byd01", true), getImage(13, "lobby_footer_byd02", true), cc.p(10, 14), 1},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 14), 1},
        },
        vip =
        {
            vip = 
            {
                button = {getImage(1, "lobby_footer_vip_icon", true), getImage(1, "lobby_footer_vip_icon_grey", true), getImage(1, "lobby_footer_vip_icon_grey", true), cc.p(10, 14), 0.82},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_vip", 112},
            },
            tips =
            {
                bg     = {getImage(1, "lobby_piaodai", true), cc.p(0, -29)},
                label1 = {getImage(1, "lobby_s", true), cc.p(57, 19), 0.95},
                label2 = {getImage(1, "lobby_b", true), cc.p(57, 18), 0.95},
            },
            loading = {getImage(1, "lobby_footer_vip_icon", true), getImage(1, "lobby_footer_vip_icon_grey", true), cc.p(10, 14)},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(10, 14), 1},
        },
        dailyPrize =
        {
            dailyPrize = 
            {
                button = {getImage(1, "loginbonus01", true), getImage(1, "loginbonus02", true), getImage(1, "loginbonus02", true), cc.p(10, 16), 0.7},
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_login_bonus", 112},
            },
            disable = 
            {
                button = {getImage(1, "loginbonus03", true), getImage(1, "loginbonus03", true), getImage(1, "loginbonus02", true), cc.p(10, 16), 0.7},
                lock_spine = {getSpine(1, "lock", true), cc.p(10, -3), 1.2},
                info   = {
                    bg_starter     = {getImage(1, "loginbonus04", true), cc.p(-52, 150)},
                    bg_back     = {getImage(1, "loginbonus05", true), cc.p(-52, 150)},
                },
            },
            loading = {getImage(1, "loginbonus01", true), getImage(1, "loginbonus03", true), cc.p(10, 14), 0.7},
            label_loading = {getFont(1, "footer_fnt01", true), cc.p(20, 14), 1},
        },
        dailyShare =
        {
            position = cc.p(-527, 90),
            unlockshare = 
            {
                label  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -45), 1, "LOBBY.footer_daily_share", 112},
                button = {getImage(1, "dailyshare01", true), getImage(1, "dailyshare02", true), getImage(1, "dailyshare02", true), cc.p(0, 10), 0.7},
            },
            loading = {getImage(1, "dailyshare01", true), getImage(1, "dailyshare02", true), cc.p(0, 10), 0.7},
        },
        tourncash =
        {
            unlock =
            {
                button = {getImage(1, "tourncash_01", true), getImage(1, "tourncash_02", true), getImage(1, "tourncash_02", true), cc.p(0, 5)},
                timeBg = {getImage(1, "Daily_Mission_iconframe", true), cc.p(0, -31), 1},
                time   = {getFont(1, "Daily_mission_timefont", true), cc.p(44, 13), 1},
                count  = {cc.p(83, 70)},
            },
            lock =
            {
                button = {getImage(1, "tourncash_01", true), getImage(1, "tourncash_02", true), getImage(1, "tourncash_02", true), cc.p(0, 5)},
                timeBg = {getImage(1, "tourncash_lobby_img01", true), cc.p(0, -31), 1},
                timeTip= {getImage(1, "tourncash_lobby_lbl01", true), cc.p(0, -25), 1},
                time   = {getFont(1, "tourncash_lobby_fnt01", true), cc.p(0, -38), 1},
            },
            common_lock = 
            {
                button = {getImage(1, "tourncash_03", true), getImage(1, "tourncash_03", true), getImage(1, "tourncash_03", true), cc.p(0, 5)},
                lock_spine = {getSpine(1, "lock", true), cc.p(-1, -18), 1},
            },
            title  = {getFont(1, "new_lobby_fnt", true), cc.p(0, -55), 1, "LOBBY.footer_tourn_frenzy", 112},
            loading = {getImage(1, "tourncash_01", true), getImage(1, "tourncash_03", true), cc.p(0, 5)},
        },
        faq = {
            button = {getImage(1, "faq_icon01", true), getImage(1, "faq_icon02", true), getImage(1, "faq_icon02", true), cc.p(10, 18), 0.66},
            label = {getFont(1, "new_lobby_fnt", true), cc.p(10, -45), 1, "LOBBY.footer_faq", 112},
        },
    },
    -- 竖版主题绿色footer
    [9] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2}
        },
        background = 
        {
            centerBg = {getImage(9, "mansion_ingame_shu_bg02", true), cc.p(0, 72), false},
            spine   = {getSpine(2, "frame_footer", true), cc.p(0, 824), "animation2"},
        },
        dashboard =
        {
            position = cc.p(303, 73),
            scale    = 1.25,
            unlockdashboard = 
            {
                bg    = {getImage(10, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(10, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(10, "Daily_Mission_ingame_right", true), cc.p(39, 59)},
                frame = {getImage(10, "Daily_Mission_ingame_frame_top", true), cc.p(39, 60)},
                giftspine = {getSpine(2, "claim", true), cc.p(40, 52)},
                label_bg  = {getImage(10, "Daily_Mission_ingame_box", true), cc.p(39, 13)},
                label  = {getFont(10, "Daily_Mission_ingame_front", true), cc.p(39, 14), 1},
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(-155, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "newplayer_yd_lbl25", true), cc.p(-100, 170), 0.7},
                },
                mission_tip = 
                {
                    bg     = {getImage(2, "bc_yh_ingme04", true), cc.p(54.5, 110), cc.p(0.81, 0.12)},
                },
                blazing_challenge = 
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard = 
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(-68, 160), true, 0.7},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },  
                collect_dashboard =
                {
                    root = {cc.p(37, 95), 0.8},
                    bg = {getImage(2, "di_dhk", true), cc.p(-40, 66.5), true, 1},
                    title = {getCommonNewFont("common_withe"), cc.p(-40, 98), 0.3, ""},
                    pos = cc.p(-40, 57.5),
                    spine = {getSpine(2, "tick", true), cc.p(20, 105), 0.8},
                    label = {
                        {getCommonNewFont("common_withe"), cc.p(-40, 70), 0.3, ""},
                        {getCommonNewFont("common_withe"), cc.p(-40, 45), 0.3, ""},
                    }
                },
            },
            lockdashboard = 
            {
                button = {getImage(10, "Daily_Mission_ingame_frame_disable", true), getImage(10, "Daily_Mission_ingame_frame_disable", true), getImage(10, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.75, 0.1), true},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(10, "Daily_Mission_ingame_front", true), cc.p(40, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(40, 48), 1},
            },
        },
        totalbet =
        {
            position          = cc.p(-241, 80),
            bigBgImage        = {getImage(9, "mansion_ingame_shu_img03", true), cc.p(0, 0)},
            smallBgImage      = {getImage(9, "free_gameback", true), cc.p(58, -23.5)},
            subButton         = {getImage(9, "mansion_ingame_shu_btn03", true), getImage(9, "mansion_ingame_shu_btn04", true), getImage(9, "mansion_ingame_shu_btn071", true), cc.p(-54.5, -56)},
            addButton         = {getImage(9, "mansion_ingame_shu_btn05", true), getImage(9, "mansion_ingame_shu_btn06", true), getImage(9, "mansion_ingame_shu_btn081", true), cc.p(57, -56)},
            labelBet          = {getFont(10, "coins_font04", true), cc.p(0, -1), 0.8, 199, cc.p(59, -26), 1, 91}, 
            totalBetImage1    = {getImage(10, "totalbetzit", true), cc.p(-0.5, -21)},
            totalBetImage2    = {getImage(10, "totalbetzit", true), cc.p(58, -60.5)}, 
            animNode          = cc.p(0, 0),
            particle          = {getParticle(2, "max_bet_liziwenjian01_1", true), cc.p(0, 0)}, 
            max_bet_spine     = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(50, 180), 0.8},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "BY SPINNING!"},

                },
                big_bet = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-242, 132)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-242, 132)},
            },
            voucher_bet_big = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-242, 153), 0.7},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-242, 153), 0.7},
            },
        },
        freegames =
        {
            position = cc.p(-299, 56.5),
            bgImage     = {getImage(9, "free_gameback", true), cc.p(0, 0)},
            labelCount  = {getFont(10, "coins_font04", true), cc.p(0, -5), 1, 85},
            labelImage  = {getImage(10, "FREEGAME", true), cc.p(-1, -38)},
        },
        totalwin =
        {
            position = cc.p(-3, 110),
            particle     = {getParticle(2,"winParticle", true), cc.p(0, 2)},
            animNode     = cc.p(0, 40),
            winLabel     = {getFont(10, "win_coins04", true), cc.p(2, 3), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 15), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 15), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 15), 1},
            label        = {getImage(10, "totalwin", true), cc.p(0, 0)},
        },
        maxbet =
        {
            position = cc.p(191, 56),
            button = {getImage(10, "mansion_ingame_btn13", true), getImage(10, "mansion_ingame_btn14", true), getImage(10, "mansion_ingame_btn24", true), cc.p(0, 0) },
            image  = {getImage(10, "mansion_ingame_btn24", true), cc.p(52.5, 42.5)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(192, 100)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-234, 85),
                scale = 0.8,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-184, 35),
            },
        },
        spin =
        {
            position = cc.p(0, 56),
            autoOn = 
            {
                root       = cc.p(0, 151),
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
                button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
                button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
                button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
                button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
                button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
                button     = {getImage(10, "mansion_ingame_btn17", true), getImage(10, "mansion_ingame_btn18", true), getImage(10, "mansion_ingame_btn21", true), cc.p(0, 0)},
                labelStop  = {getImage(10, "mansion_ingame_lbl01", true), getImage(10, "mansion_ingame_lbl10", true), getImage(10, "mansion_ingame_lbl09", true), cc.p(128, 58)},
                labelStopFast   = {getImage(10, "mansion_ingame_lbl01", true), getImage(10, "mansion_ingame_lbl10", true), getImage(10, "mansion_ingame_lbl09", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin = 
            {
                button     = {getImage(10, "mansion_ingame_btn17", true), getImage(10, "mansion_ingame_btn18", true), getImage(10, "mansion_ingame_btn21", true), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage(10, "mansion_ingame_lbl05", true), getImage(10, "mansion_ingame_lbl07", true)},
                    disable  = getImage(10, "mansion_ingame_lbl03", true),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage(10, "mansion_ingame_lbl06", true), getImage(10, "mansion_ingame_lbl08", true)},
                    disable  = getImage(10, "mansion_ingame_lbl04", true),
                    position = cc.p(123, 27),
                },
                labelStop   = {getImage(10, "mansion_ingame_lbl01", true), getImage(10, "mansion_ingame_lbl10", true), getImage(10, "mansion_ingame_lbl09", true), cc.p(125, 49)},
            },
        },
    },
    -- 横版主题绿色footer
    [10] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2},
        },
        background = 
        {
            centerBg   = {getImage(10, "mansion_ingame_img08", true), cc.p(0, 48), true},
            spine    = {getSpine(10, "background", true), cc.p(0, 48), "animation"},
        },
        dashboard =
        {
            position = cc.p(-586, 50),
            unlockdashboard = 
            {
                bg    = {getImage(10, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(10, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(10, "Daily_Mission_ingame_right", true), cc.p(39, 59)},
                frame = {getImage(10, "Daily_Mission_ingame_frame_top", true), cc.p(39, 60)},
                giftspine = {getSpine(2, "claim", true), cc.p(40, 52)},
                label_bg  = {getImage(10, "Daily_Mission_ingame_box", true), cc.p(39, 13)},
                label  = {getFont(10, "Daily_Mission_ingame_front", true), cc.p(39, 14), 1},
                
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(195, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "new_player_dashtips", true), cc.p(250, 210), 1},
                },
                mission_tip = 
                {
                    bg     = {getImage(2, "bc_yh_ingme01", true), cc.p(70, 100), cc.p(0.22, 0.12)},
                },
                blazing_challenge = 
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard = 
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(198, 200), false, 1},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },  
                collect_dashboard =
                {
                    root = {cc.p(45, 95), 1},
                    bg = {getImage(2, "di_dhk", true), cc.p(40, 66.5), false, 1},
                    title = {getCommonNewFont("common_withe"), cc.p(40, 98), 0.3, ""},
                    pos = cc.p(40, 57.5),
                    spine = {getSpine(2, "tick", true), cc.p(100, 105), 0.8},
                    label = {
                        {getCommonNewFont("common_withe"), cc.p(40, 70), 0.3, ""},
                        {getCommonNewFont("common_withe"), cc.p(40, 45), 0.3, ""},
                    }
                },
                -- {
                --     root = {cc.p(45, 95), 1},
                --     bg = {getImage(2, "collect_dashboard_bg", true), cc.p(96, 66.5), false, 1},
                --     title = {getImage(2, "collect_dashboard_title_1", true), cc.p(97, 102), false, 1},
                --     label = {
                --         -- {getFont(1, "system_popup_fnt01", true), cc.p(97, 98), 1, "DAILY MISSION:"},
                --         {getFont(1, "system_popup_fnt01", true), cc.p(97, 64), 1, ""},
                --         {getFont(1, "system_popup_fnt01", true), cc.p(97, 38), 1, ""},
                --     }
                -- },
            },
            lockdashboard = 
            {
                button = {getImage(10, "Daily_Mission_ingame_frame_disable", true), getImage(10, "Daily_Mission_ingame_frame_disable", true), getImage(10, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(10, "Daily_Mission_ingame_front", true), cc.p(40, 14), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(40, 48), 1},
            },
        },
        totalbet =
        {
            position          = cc.p(-395, 43),
            bigBgImage        = {getImage(10, "mansion_bes_gameback", true), cc.p(0, 0)},
            smallBgImage      = {getImage(10, "free_gameback", true), cc.p(76, 0)},
            subButton         = {getImage(10, "mansion_ingame_btn11", true), getImage(10, "mansion_ingame_btn12", true), getImage(10, "mansion_ingame_btn22", true), cc.p(-111, 4) },
            addButton         = {getImage(10, "mansion_ingame_btn09", true), getImage(10, "mansion_ingame_btn10", true), getImage(10, "mansion_ingame_btn23", true), cc.p(111, 4) },
            labelBet          = {getFont(10, "coins_font04", true), cc.p(0, -1), 1, 162, cc.p(76, -3), 1, 115},
            totalBetImage1    = {getImage(10, "totalbetzit", true), cc.p(3, -32)},
            totalBetImage2    = {getImage(10, "totalbetzit", true), cc.p(74, -32)},
            animNode          = cc.p(0, 0),
            particle          = {getParticle(2,"max_bet_liziwenjian01_1", true), cc.p(0, 0)},
            max_bet_spine     = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(0, 176)},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "BY SPINNING!"},

                },
                big_bet = 
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-395, 94)},
            },
            voucher_bet_big = -- C级活动21038相关 
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-395, 136.5)},
            },
        },
        freegames =
        {
            position = cc.p(-466, 43),
            bgImage     = {getImage(10, "free_gameback", true), cc.p(0, 0)},
            labelCount  = {getFont(10, "coins_font04", true), cc.p(0, -5), 1, 115},
            labelImage  = {getImage(10, "FREEGAME", true), cc.p(1, -32)},
        },
        totalwin =
        {
            position = cc.p(0,0),
            particle    = {getParticle(2,"winParticle", true), cc.p(0, 12)},
            animNode    = cc.p(0, 55),
            winLabel    = {getFont(10, "win_coins04", true), cc.p(0, 5), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 0), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 0), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 0), 1},
            label       = {getImage(10, "totalwin", true), cc.p(0, 11)},
        },
        maxbet =
        {
            position = cc.p(312, 45),
            button = {getImage(10, "mansion_ingame_btn13", true), getImage(10, "mansion_ingame_btn14", true), getImage(10, "mansion_ingame_btn24", true), cc.p(0, 0) },
            image  = {getImage(10, "mansion_ingame_btn24", true), cc.p(52.5, 42.5)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(312, 95)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-284, 97),
                scale = 1,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-284, 47),
            },
        },
        activityB = 
        {
            position  = cc.p(-580, 0),
            bg        = {getImage(2, "activity_b_list_bg_h", true), cc.p(0, 380)},
            btn       = {getSpine(2, "b_loading", true), cc.p(0, 150), 1},
            show_rect =
            {
                -1070, 0, 3000, 650
            },
            list_pos = cc.p(1070, -10),
            item_pos = cc.p(1000, 135)
        },
        themeIconDefault =
        {
            list_pos    = cc.p(0, 0),
            list_height = 110,
            list_scale  = 1,
        },
        spin =
        {
            position = cc.p(503, 44),
            autoOn = 
            {
                root       = cc.p(0, 151),
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
                button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
                button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
                button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
                button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
                button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop = 
            {
                button     = {getImage(10, "mansion_ingame_btn17", true), getImage(10, "mansion_ingame_btn18", true), getImage(10, "mansion_ingame_btn21", true), cc.p(0, 0)},
                labelStop  = {getImage(10, "mansion_ingame_lbl01", true), getImage(10, "mansion_ingame_lbl10", true), getImage(10, "mansion_ingame_lbl09", true), cc.p(128, 58)},
                labelStopFast   = {getImage(10, "mansion_ingame_lbl01", true), getImage(10, "mansion_ingame_lbl10", true), getImage(10, "mansion_ingame_lbl09", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin = 
            {
                button      = {getImage(10, "mansion_ingame_btn17", true), getImage(10, "mansion_ingame_btn18", true), getImage(10, "mansion_ingame_btn21", true), cc.p(0, 0)},  
                labelSpin  = 
                {
                    enable   = {getImage(10, "mansion_ingame_lbl05", true), getImage(10, "mansion_ingame_lbl07", true)},
                    disable  = getImage(10, "mansion_ingame_lbl03", true),
                    position = cc.p(123, 58),
                },
                labelHold  = 
                {
                    enable   = {getImage(10, "mansion_ingame_lbl06", true), getImage(10, "mansion_ingame_lbl08", true)},
                    disable  = getImage(10, "mansion_ingame_lbl04", true),
                    position = cc.p(123, 27),
                },
                labelStop   = {getImage(10, "mansion_ingame_lbl01", true), getImage(10, "mansion_ingame_lbl10", true), getImage(10, "mansion_ingame_lbl09", true), cc.p(125, 49)},
            },
        },
        themeUserGuideQuest = 
        {
            item_pos = cc.p(-13, -15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBlast = 
        {
            item_pos = cc.p(5,9), -- -15
            item_height = 650,
            item_scale = 1, 
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBingo = 
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeRocket = 
        {
            item_pos = cc.p(5, 15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeJourney = 
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeUserGuide = 
        {
            item_pos = cc.p(5,-15),
            item_height = 650,
            item_scale = 1,
            list_posX = 0,
            list_height = 110,
            list_scale = 1,
        },
        themeMoreGames = 
        {
            position = cc.p(640,220),
        },
        themeCookingFrenzy = {
            item_pos = cc.p(90, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeArcher = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeWordsGame =
        {
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeGof = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeMansion = {
            item_pos = cc.p(70, 220),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
    },
    [11] =
    {
        screentouch =
        {
            image = {getCommonImage("kong"), cc.p(0, 0), 156*2, 156*2},
        },
        background =
        {
            leftBg   = {getImage(5, "big_back_half", true), cc.p(0, 48), true},
            rightBg  = {getImage(5, "big_back_half", true), cc.p(0, 48), false},
            spine    = {getSpine(2, "background", true), cc.p(0, 48), "animation"},
        },
        dashboard =
        {
            position = cc.p(-586, 50),
            unlockdashboard =
            {
                bg    = {getImage(2, "Daily_Mission_ingame_frame", true), cc.p(0, 0) },
                button  = {getCommonImage("kong"), cc.p(36, 53), 10.7, 11},
                dashboard =
                {
                    clip = {getImage(5, "Daily_Mission_ingame_frametd", true), cc.p(38.6, 59), 1.01},
                    spine = {getSpine(2, "progress", true), cc.p(36, -25)},
                },
                right = {getImage(2, "Daily_Mission_ingame_right", true), cc.p(38, 57)},
                frame = {getImage(2, "Daily_Mission_ingame_frame_top", true), cc.p(37, 57)},
                giftspine = {getSpine(2, "claim", true), cc.p(38, 50)},
                label  = {getFont(2, "Daily_Mission_ingame_front", true), cc.p(38, 9), 1},
                info =
                {
                    bg     = {getImage(2, "new_daily_tips04", true), cc.p(195, 197)},
                    bg1    = {getImage(1, "new_daily_tips05", true), cc.p(50, -1)},
                },
                new_user_info =
                {
                    bg     = {getImage(2, "new_player_dashtips", true), cc.p(250, 210), 1},
                },
                mission_tip =
                {
                    bg     = {getImage(2, "bc_yh_ingme01", true), cc.p(70, 100), cc.p(0.22, 0.12)},
                },
                blazing_challenge =
                {
                    icon   = {getImage(2, "bc_yh_ingme03", true), cc.p(40, 18), 0.12},
                },
                open_dashboard =
                {
                    bg    = {getImage(2, "moneybank_purchase_img01", true), cc.p(198, 200), false, 1},
                    image = {getImage(2, "moneybank_purchase_lbl01", true), cc.p(230, 130)}
                },
                
                collect_dashboard =
                {
                    root = {cc.p(45, 95), 1},
                    bg = {getImage(2, "collect_dashboard_bg", true), cc.p(96, 66.5), false, 1},
                    title = {getImage(2, "collect_dashboard_title_1", true), cc.p(97, 102), false, 1},
                    label = {
                        -- {getFont(1, "system_popup_fnt01", true), cc.p(97, 98), 1, "DAILY MISSION:"},
                        {getFont(1, "system_popup_fnt01", true), cc.p(97, 64), 1, ""},
                        {getFont(1, "system_popup_fnt01", true), cc.p(97, 38), 1, ""},
                    }
                },
            },
            lockdashboard =
            {
                button = {getImage(2, "Daily_Mission_ingame_frame_disable", true), getImage(2, "Daily_Mission_ingame_frame_disable", true), getImage(2, "Daily_Mission_ingame_frame_disable", true), cc.p(0, 0) },
                info  = {
                    root        = {cc.p(0, 0)},
                    bg          = {getImage(1, "pop_ups_img02", true), cc.p(38, 109), cc.p(0.25, 0.1)},
                    font_level  = {getFont(1, "system_popup_fnt01", true), cc.p(122, 96), 1},
                    font_unlock = {getFont(1, "system_popup_fnt01", true), cc.p(122, 64), 1, "TO UNLOCK"},
                },
                label  = {getFont(2, "Daily_Mission_ingame_front", true), cc.p(38, 9), 1},
                lock_spine = {getSpine(1, "lock", true), cc.p(38, 40), 1},
            },
        },
        totalbet =
        {
            position          = cc.p(-395, 43),
            bigBgImage        = {getImage(5, "bes_gameback", true), cc.p(0, 0)},
            smallBgImage      = {getImage(5, "free_gameback", true), cc.p(76, 0)},
            subButton         = {getImage(2, "minus01", true), getImage(2, "minus02", true), getImage(2, "minus03", true), cc.p(-111, 4) },
            addButton         = {getImage(2, "plus01", true), getImage(2, "plus02", true), getImage(2, "plus03", true), cc.p(111, 4) },
            labelBet          = {getFont(5, "coins_font04", true), cc.p(0, 3), 1, 144, cc.p(76, 3), 1, 115},
            totalBetImage1    = {getImage(2, "totalbetzit", true), cc.p(3, -32)},
            totalBetImage2    = {getImage(2, "totalbetzit", true), cc.p(74, -32)},
            animNode          = cc.p(0, 0),
            particle          = {getParticle(2,"max_bet_liziwenjian01_1", true), cc.p(0, 0)},
            max_bet_spine     = getSpine(2, "maxbet", true),
            lounge_points_tip =
            {
                bg         = {getImage(2, "lbbet_tips_frame01", true), cc.p(0, 176)},
                title      = {getImage(2, "lbbet_tips_logo01", true), cc.p(218.5, 159.5)},
                label_bet  = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(255, 240, 0)},
                label_fade = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                label_fade2 = {getFont(2, "bet_tips_fnt02", true), cc.p(223, 96), cc.c3b(254, 243, 203)},
                small_bet  =
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 126.5), cc.c3b(254, 243, 203), "LOBBY.not_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 67), cc.c3b(254, 243, 203), "LOBBY.lp_by_spining"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(260, 122), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt02", true), cc.p(334, 122), cc.c3b(255, 255, 255), "!"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(56, 65), cc.c3b(255, 255, 255), "GET"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(150, 65), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(286, 65), cc.c3b(255, 255, 255), "BY SPINNING!"},

                },
                big_bet =
                {
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 131), cc.c3b(255, 240, 0), "LOBBY.current_bet_qualified"},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 103.5), cc.c3b(254, 243, 203), "LOBBY.get_lp_by_spining", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 82), cc.c3b(254, 243, 203), "LOBBY.bet_you_spin", 0.8},
                    {getFont(2, "bet_tips_fnt02", true), cc.p(223, 57.5), cc.c3b(254, 243, 203), "LOBBY.more_lp", 0.8},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(119, 64), cc.c3b(255, 255, 255), "MORE"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(219, 64), cc.c3b(255, 247, 34), "LOUNGE POINTS"},
                    -- {getFont(2, "bet_tips_fnt01", true), cc.p(298, 64), cc.c3b(255, 255, 255), "!"},

                },
            },
            voucher_bet = -- C级活动21038相关
            {
                {getDynamicImage(2, "bonus_voucher_img_4", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_3", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_2", true), cc.p(-395, 94)},
                {getDynamicImage(2, "bonus_voucher_img_1", true), cc.p(-395, 94)},
            },
            voucher_bet_big = -- C级活动21038相关
            {
                {getDynamicImage(2, "bonus_voucher_img_8", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_6", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_7", true), cc.p(-395, 136.5)},
                {getDynamicImage(2, "bonus_voucher_img_5", true), cc.p(-395, 136.5)},
            },
        },
        freegames =
        {
            position = cc.p(-466, 43),
            bgImage     = {getImage(5, "free_gameback", true), cc.p(0, 0)},
            labelCount  = {getFont(5, "coins_font04", true), cc.p(0, 3), 1, 115},
            labelImage  = {getImage(2, "FREEGAME", true), cc.p(1, -32)},
        },
        totalwin =
        {
            position     = cc.p(0,0),
            particle     = {getParticle(2,"winParticle", true), cc.p(0, 12)},
            animNode     = cc.p(0, 55),
            winLabel     = {getFont(2, "win_coins02", true), cc.p(0, 0), 1},
            -- effectLabel = {"commonfonts/bigwin_up.fnt", cc.p(0, 0), 0.5},
            effectLabel = {getFont(2, "nice_win_fnt01", true), cc.p(0, 0), 1},
            small_win_spine1 = {getSpine(2, "small_win", true), cc.p(0, 110), 1},
            small_win_spine2 = {getSpine(2, "small_win1", true), cc.p(0, 0), 1},
            label        = {getImage(2, "totalwin", true), cc.p(0, 11)},
        },
        maxbet =
        {
            position = cc.p(312, 45),
            button = {getImage(2, "maxbet_01", true), getImage(2, "maxbet_02", true), getImage(2, "maxbet_03", true), cc.p(0, 0) },
            image  = {getImage(2, "maxbet_03", true), cc.p(60, 50)},
            bubble = {
                {getImage(2, "middle_bubble", true), cc.p(0, 50), cc.p(312, 95)},
                {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_max_bet_activated"},
            },
            raise_tip = {
                position = cc.p(-284, 97),
                scale = 1,
                bg = {getImage(2, "middle_bubble", true), cc.p(0, 50)},
                text = {getFont(1, "system_popup_fnt01", true), cc.p(0, 60), 1, "LOBBY.footer_raise_bet_to_win_more"},
                spine_pos = cc.p(-284, 47),
            },
        },
        activityB =
        {
            position  = cc.p(-580, 0),
            bg        = {getImage(2, "activity_b_list_bg_h", true), cc.p(0, 380)},
            btn       = {getSpine(2, "b_loading", true), cc.p(0, 150), 1},
            show_rect =
            {
                -1070, 0, 3000, 650
            },
            list_pos = cc.p(1070, -10),
            item_pos = cc.p(1000, 135)
        },
        themeIconDefault =
        {
            list_pos    = cc.p(0, 0),
            list_height = 110,
            list_scale  = 1,
        },
        spin =
        {
            position = cc.p(503, 44),
            autoOn =
            {
                root       = cc.p(0, 151),
                background = {getImage(2, "freegamespin_back", true), cc.p(-3, 22)},
                buttonFast = {getImage(2, "kong13345", true), getImage(2, "anxia_fast", true), getImage(2, "kong13345", true), cc.p(-3, 130)},
                button500  = {getImage(2, "kong13345", true), getImage(2, "anxia_500", true), getImage(2, "kong13345", true), cc.p(0, 86)},
                button100  = {getImage(2, "kong13345", true), getImage(2, "anxia_100", true), getImage(2, "kong13345", true), cc.p(0, 42)},
                button50   = {getImage(2, "kong13345", true), getImage(2, "anxia_50", true), getImage(2, "kong13345", true), cc.p(0, -2)},
                button20   = {getImage(2, "kong13345", true), getImage(2, "anxia_20", true), getImage(2, "kong13345", true), cc.p(0, -46.5)},
                button10   = {getImage(2, "kong13345", true), getImage(2, "anxia_10", true), getImage(2, "kong13345", true), cc.p(0, -91)},
                disappearButton  = {getCommonImage("kong"), cc.p(-502, 157), 160, 120},
            },
            autoStop =
            {
                button     = {getImage(2, "spin_01", true), getImage(2, "spin_02", true), getImage(2, "spin_03", true), cc.p(0, 0)},
                labelStop  = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 61)},
                labelStopFast   = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(128, 49)},
                remaining  = {getFont(2, "auto_fnt01", true), getFont(2, "auto_fnt02", true), cc.p(126, 27), 1},
            },
            spin =
            {
                button            = {getImage(2, "spin_01", true), getImage(2, "spin_02", true), getImage(2, "spin_03", true), cc.p(0, 0)},
                labelSpin  =
                {
                    enable   = {getImage(2, "SPIN", true), getImage(2, "SPIN02", true)},
                    disable  = getImage(2, "SPIN_disable", true),
                    position = cc.p(123, 59),
                },
                labelHold  =
                {
                    enable   = {getImage(2, "HOLDFORAUTO", true), getImage(2, "HOLDFORAUTO02", true)},
                    disable  = getImage(2, "HOLDFORAUTO_disable", true),
                    position = cc.p(123, 22),
                },
                labelStop         = {getImage(2, "STOP", true), getImage(2, "STOP02", true), getImage(2, "STOP03", true), cc.p(125, 49)},
                spineCharge = {getSpine(2, "charge", true), cc.p(0, 0)}
            },
        },
        themeUserGuideQuest =
        {
            item_pos = cc.p(-13, -15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBlast =
        {
            item_pos = cc.p(5,9), -- -15
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeBingo =
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeRocket =
        {
            item_pos = cc.p(5, 15),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeJourney =
        {
            item_pos = cc.p(5, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeUserGuide =
        {
            item_pos = cc.p(5,-15),
            item_height = 650,
            item_scale = 1,
            list_posX = 0,
            list_height = 110,
            list_scale = 1,
        },
        themeMoreGames =
        {
            position = cc.p(640,220),
        },
        themeCookingFrenzy = {
            item_pos = cc.p(90, 0),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeArcher = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeWordsGame =
        {
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeGof = {
            item_pos = cc.p(70, -20),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
        themeMansion = {
            item_pos = cc.p(70, 250),
            item_height = 650,
            item_scale = 1,
            list_pos = cc.p(0, 0),
            list_height = 110,
            list_scale = 1,
        },
    },          
}

-- 创建容器结点
HeaderFooterConfig.createContainer = function (parent, pos, zOrder, size)
	local containerCsb = "header_footer/style1/header/basic/BasicContainer.csb"
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
    local lineCsb = "header_footer/style1/header/basic/BasicLine.csb"
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

        return linef
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
        sprite = createSpriteWithFile("commonEffect/kong.png")
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

    bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", misfile = filename, err_type = 3}, false)
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

    bole.send_codeInfo(Splunk_Type.Error, {error = "miss_file", misfile = filename, err_type = 3}, false)
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

-- 创建粒子结点
-- HeaderFooterConfig.createParticle = function (parent, file, pos, zOrder, scale)
-- 	local fileUtils = cc.FileUtils:getInstance()
-- 	if fileUtils:isFileExist(file) then
-- 		local particle = cc.ParticleSystemQuad:create(file)

-- 		if pos then
-- 			particle:setPosition(pos)
-- 		end

-- 		scale = scale or 1
-- 		particle:setScale(scale)

-- 		if parent then
-- 			parent:addChild(particle, zOrder)
-- 		end

-- 		particle:stopSystem()

-- 		return particle
-- 	end

-- 	return nil
-- end

return HeaderFooterConfig
