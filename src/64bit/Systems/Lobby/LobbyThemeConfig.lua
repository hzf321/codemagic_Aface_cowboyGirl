
local LobbyThemeConfig = {}

local JP_SIZE = {
	GRAND = 234,
	MAJOR = 184,
	MINI = 164
}

FEATURE_CLASS = {
	ULTRA_RESPIN = "ultra_respin",
	EPIC_LINK = "epic_link",
	RAPID_PAY = "rapid_pay",
	LUCKY_PUZZLE = "lucky_puzzle",
	-- LUCKY_PUZZLE2 = "lucky_puzzle2",
	SUPER_BONUS = "super_bonus",
}

THEME_TYPE = {
	NORMAL = "normal",
	NEW = "new",
	SOON = "comming soon",
	POPULAR = "popular",
	SPECIAL = "special",
	PROGRESSIVE = "progressive"
}

THEME_STYLE = {
	SMALL = 1,
    LONG = 2,
    HUGE = 3
}

LOBBY_TYPE = {
	LOBBY = 1,
	FAVORITE = 2,
	VIP = 3
}

SAVED_LOBBY_OFFSET = 0
SAVED_LOUNGE_OFFSET = 0

SHOW_PIGGY_TIPS = false

LobbyThemeConfig.themeAttributes =
{
	Normal = 0,
	NewTheme = 1, -- new
	ComingSoon = 2, -- coming soon
	Hot = 3, -- hot
	OnlyInQuest = 4, -- only in quest
	Maintainess = 5, -- maintainess
	NeedUpdate = 6, -- update app
}

LobbyThemeConfig.themeConfig =
{
	[188] =
	{
		jpLoading =
		{
    		{"grand", 65},
			{"major", 49},
			{"minor", 49},
    	},
    	lobbyConfig =
    	{
	        lobby_type         = 0,
	        animation_list     = {"animation"},
	        play_frame         = {},
	        preload_spine      = "188_icon_01",
	  --       feature_logo       = true,
			-- feature_logo_themePath = "lucky_puzzle2",
	        useCommonJP = true,
	        lobby_bg_scale = 1,
	        --jackpot_label = "lobby_jackpot_purple",
	        jackpot_label_list =
	        {
	            {
	                level     = "grand",
	            },
	            {
	                level     = "major",
	            },
	            {
	                level     = "minor",
	            },
	        },
	    },
    },
}


return LobbyThemeConfig

