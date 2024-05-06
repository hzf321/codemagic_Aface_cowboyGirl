--定义事件的名字(data ＝ "")
local EVENTS = {
	CHECK_UPDATE_COINS					     	= "CHECK_UPDATE_COINS",
    --new store
	NTF_STORE_VIDEO_OVER						= "NTF_STORE_VIDEO_OVER",
	NTF_CHECK_NEXT_VIDEO						= "NTF_CHECK_NEXT_VIDEO",
	--viproom
	NTF_START_DOWNLOAD							= "NTF_START_DOWNLOAD",
	NTF_DOWNLOAD_ERROR							= "NTF_DOWNLOAD_ERROR",
	NTF_DOWNLOAD_PROGRESS						= "NTF_DOWNLOAD_PROGRESS",
	NTF_DOWNLOAD_SUCCESS						= "NTF_DOWNLOAD_SUCCESS",
	--界面数据刷新
	NTF_UPDATE_VIP_TICKETS						= "NTF_UPDATE_VIP_TICKETS",
	NTF_UPDATE_VIP_PONTS						= "NTF_UPDATE_VIP_PONTS",

	NTF_UPDATE_GIFT_VIEW 						= "NTF_UPDATE_GIFT_VIEW",
	NTF_UPDATE_GIFT_INVITE_VIEW 				= "NTF_UPDATE_GIFT_INVITE_VIEW",
	NTF_UPDATE_ALL_GIFT_VIEW 					= "NTF_UPDATE_ALL_GIFT_VIEW",
	NTF_RELOAD_FRIENDS 							= "NTF_RELOAD_FRIENDS",
	NTF_RELOAD_INVITE_FRIENDS 					= "NTF_RELOAD_INVITE_FRIENDS",
	NTF_REFRESH_GIFT_COLLECT_ALL_BTN 			= "NTF_REFRESH_GIFT_COLLECT_ALL_BTN",
	-- facebook奖励首次登录领取
	EVT_FACEBOOK_FIRST_LOGIN_COIN				= 'EVT_FACEBOOK_FIRST_LOGIN_COIN',
	

	------------------------------------- 系统 -------------------------------------
	SYSTEM = {
		-- 前台
		ENTER_FOREGROUND						= "SYSTEM.ENTER_FOREGROUND",
		-- 后台
		ENTER_BACKGROUND						= "SYSTEM.ENTER_BACKGROUND",
		-- 系统功能资源下载完，可以下载其他资源
		ENTER_GAME_DOWNLOAD_FINISH				= "SYSTEM.ENTER_GAME_DOWNLOAD_FINISH",
		-- 多语言资源下载完
		LANGUAGE_RES_DOWNLOAD_FINISH 			= "SYSTEM.LANGUAGE_RES_DOWNLOAD_FINISH",
	},


	------------------------------------- 用户数据 -------------------------------------
	USER = {
		-- 刷新vip
		REFRESH_VIP 							= "USER.REFRESH_VIP",
		-- 刷新store info
		REFRESH_STORE_INFO 					    = "USER.REFRESH_STORE_INFO",
		-- 刷新用户数据
		REFRESH_USER_DATA 						= "USER.REFRESH_USER_DATA",
		-- 刷新等级
		REFRESH_LEVEL							= "USER.REFRESH_LEVEL",
		-- 刷新help shift数量
		REFRESH_HELP_SHIFT						= "USER.REFRESH_HELP_SHIFT",
		-- 切换语言
		LANGUAGE_CHANGED						= "USER.LANGUAGE_CHANGED",
	},


	------------------------------------- 新手引导 -------------------------------------
	USERGUIDE = {
		UPDATE_B_MOVE_ICON_PROGRESS				= "USERGUIDE.UPDATE_B_MOVE_ICON_PROGRESS",
	},

	------------------------------------- 新手quest -------------------------------------
	USERGUIDE_QUEST = {
		UPDATE_B_MOVE_ICON_PROGRESS				= "USERGUIDE_QUEST.UPDATE_B_MOVE_ICON_PROGRESS",
	},

	------------------------------------- purchase -------------------------------------
	PURCHASE = {
		-- collect store
		COLLECT_STORE 							= "PURCHASE.COLLECT_STORE",
		NEW_PAY									= "PURCHASE.NEW_PAY"
	},

	------------------------------------- header -------------------------------------
	HEADER = {
		ON_ENTER_LOBBY 							= "HEADER.ON_ENTER_LOBBY",
	},

	------------------------------------- 主题 -------------------------------------
	THEME = {
		-- 请求退出主题
		ASK_QUIT_THEME							= "THEME.ASK_QUIT_THEME",
		-- 允许退出主题
		ALLOW_QUIT_THEME						= "THEME.ALLOW_QUIT_THEME",

		CHANGE_BET 								= "THEME.CHANGE_BET",
		STOP_ANIM 								= "THEME.STOP_ANIM",
		SPIN_START 								= "THEME.SPIN_START",
		CHOOSE_BET 								= "THEME.CHOOSE_BET",
		CLICK_MAXBET 						 	= "THEME.CLICK_MAXBET",
		CLICK_SUBBET 						 	= "THEME.CLICK_SUBBET",
		CLICK_ADDBET 						 	= "THEME.CLICK_ADDBET",
		STOP_BIG_WIN 						 	= "THEME.STOP_BIG_WIN",
		STOP_WIN 						 	    = "THEME.STOP_WIN",
		SPIN_OR_FEATURE 						= "THEME.SPIN_OR_FEATURE", -- spin 或者 feature 状态
		INIT_THEME_OVER 						= "THEME.INIT_THEME_OVER", -- spin 或者 feature 状态
		CLICK_SAME_THEME						= "THEME.CLICK_SAME_THEME", -- 选bet界面点击到了相同的主题
		IS_IN_FREE								= "THEME.IS_IN_FREE", -- 在free中
		IS_OUT_FREE								= "THEME.IS_OUT_FREE", -- free结束
		ON_ENTER_THEME							= "THEME.ON_ENTER_THEME", -- 进入主题
		ENTER_LOADING_HIDE						= "THEME.ENTER_LOADING_HIDE", -- 进入的loading结束
		START_SPIN								= "THEME.START_SPIN",
		FINISH_SPIN								= "THEME.FINISH_SPIN",
		EXIT_THEME								= "THEME.EXIT_THEME",	-- 退出主题
		REFRESH_RANK							= "THEME.REFRESH_RANK",	-- 退出主题
		REFRESH_BOARDCAST						= "THEME.REFRESH_BOARDCAST",	-- 退出主题
		ON_SCENE_ENTER							= "THEME.ON_SCENE_ENTER",
		-- 退出主题，停止音效
		STOP_ALL_EFFECTS						= "THEME.STOP_ALL_EFFECTS",
		-- 弹窗弹出暂停主题
		PAUSE_THEME								= "THEME.PAUSE_THEME",
		RESUME_THEME							= "THEME.RESUME_THEME",
		-- 播放背景音乐
		PLAY_BACKGROUND							= "THEME.PLAY_BACKGROUND",
		CLICK_SPIN 								= "THEME.CLICK_SPIN",
		UPDATE_LOADDING_PROGRESS 				= "THEME.UPDATE_LOADDING_PROGRESS", -- 主题loadding刷新进度
		FOOTER_HIDE 							= "THEME.FOOTER_HIDE", -- 主题内隐藏footer
		FOOTER_SHOW 							= "THEME.FOOTER_SHOW", --主题内显示footer
		HEADER_HIDE 							= "THEME.HEADER_HIDE", -- 主题内隐藏header
		HEADER_HIDE_PART 						= "THEME.HEADER_HIDE_PART", -- 主题内隐藏header 但是回大厅按钮不隐藏
		HEADER_SHOW 							= "THEME.HEADER_SHOW", --主题内显示header
		HEADER_SHOW_PART 						= "THEME.HEADER_SHOW_PART", --主题内显示header
		ENTER_FREE_GAME 						= "THEME.ENTER_FREE_GAME", -- 进入freegame
		ENTER_BONUS_GAME 						= "THEME.ENTER_BONUS_GAME", -- 进入bonusgame
		IS_OUT_BONUS							= "THEME.IS_OUT_BONUS", -- bonus结束
		COLLECT_COINS							= "THEME.COLLECT_COINS", -- 主题collect coins协议返回
		REFRESH_PAYOUT                  		= "THEME.REFRESH_PAYOUT",
		SET_HELPSHIFT                  			= "THEME.SET_HELPSHIFT", -- 主题，展示helpShft btn
		CHANGE_KEYBOARD_TOUCH                  	= "THEME.CHANGE_KEYBOARD_TOUCH", -- 主题内部弹窗控制事件，是否可以空格点击
		CLOSE_AD_SEND_FEATURE_TIP 		        = "THEME.CLOSE_AD_SEND_FEATURE_TIP", -- 主题内部送奖feature广告气泡关闭
	},
	LOBBY = {
		ON_SCENE_ENTER							= "LOBBY.ON_SCENE_ENTER",
		ON_TOUCH_SIDERBAR						= "LOBBY.ON_TOUCH_SIDERBAR",
	},

	------------------------------------- 主题中的活动 -------------------------------------
	ACTIVITY_THEME = {
		-- 立即显示侧边栏
		ALL_SHOW_QUIET							= "ACTIVITY_THEME.ALL_SHOW_QUIET",
		-- 立即隐藏侧边栏
		ALL_HIDE_QUIET							= "ACTIVITY_THEME.ALL_HIDE_QUIET",
		-- 运动显示侧边栏
		ALL_SHOW_ACTION							= "ACTIVITY_THEME.ALL_SHOW_ACTION",
		-- 运动隐藏侧边栏
		ALL_HIDE_ACTION							= "ACTIVITY_THEME.ALL_HIDE_ACTION",
		-- 设置是否可移动
		MOVE_ENABLE 							= "ACTIVITY_THEME.MOVE_ENABLE",
		-- 设置是否可触摸
		TOUCH_ENABLE 							= "ACTIVITY_THEME.TOUCH_ENABLE",
		-- 切换左右
		CHANGE_SIDE								= "ACTIVITY_THEME.CHANGE_SIDE",
		-- 玩家有操作，touch end
		USER_TOUCH_END							= "ACTIVITY_THEME.USER_TOUCH_END",
		-- 隐藏b级活动侧边栏
		B_SIDE_HIDE_QUIET 						= "ACTIVITY_THEME.B_SIDE_HIDE_QUIET",
		-- b级活动侧边栏刷新
		B_UPDATE								= "ACTIVITY_THEME.B_UPDATE",
		-- b side翻页
		B_SIDE_PAGE_TURNING						= "ACTIVITY_THEME.B_SIDE_PAGE_TURNING",
		-- 开始移动滚动bmove
		B_MOVE_START_MOVE_ICON					= "ACTIVITY_THEME.B_MOVE_START_MOVE_ICON",
		B_MOVE_START_MOVE_LIST					= "ACTIVITY_THEME.B_MOVE_START_MOVE_LIST",
		B_MOVE_START_SCROLL_LIST				= "ACTIVITY_THEME.B_MOVE_START_SCROLL_LIST",
		B_MOVE_START_MOVE_ITEM					= "ACTIVITY_THEME.B_MOVE_START_MOVE_ITEM",
		-- icon显示完毕
		B_MOVE_ON_SHOW_ICON						= "ACTIVITY_THEME.B_MOVE_ON_SHOW_ICON",
		-- list显示完毕
		B_MOVE_ON_SHOW_LIST						= "ACTIVITY_THEME.B_MOVE_ON_SHOW_LIST",
		-- item显示完毕
		B_MOVE_ON_SHOW_ITEM						= "ACTIVITY_THEME.B_MOVE_ON_SHOW_ITEM",
		-- b气泡显示完
		B_MOVE_TIP_SHOWED						= "ACTIVITY_THEME.B_MOVE_TIP_SHOWED",
		-- 进入主题
		B_MOVE_ON_ENTER_THEME					= "ACTIVITY_THEME.B_MOVE_ON_ENTER_THEME",
		B_SIDE_ON_ENTER_THEME					= "ACTIVITY_THEME.B_SIDE_ON_ENTER_THEME",
		-- 刷新右侧边栏
		C_SIDE_UPDATE 							= "ACTIVITY_THEME.C_SIDE_UPDATE",
		-- c级提示
		C_SHOW_TIP								= "ACTIVITY_THEME.C_SHOW_TIP",
		-- c级显示
		C_MOVE_SHOW								= "ACTIVITY_THEME.C_MOVE_SHOW",
		C_MOVE_HIDE								= "ACTIVITY_THEME.C_MOVE_HIDE",
		-- 更新c级活动
		C_UPDATE_CASH_BACK 						= "ACTIVITY_THEME.C_UPDATE_CASH_BACK",
		C_UPDATE_REPEAT_WIN						= "ACTIVITY_THEME.C_UPDATE_REPEAT_WIN",
		C_UPDATE_REPEAT_WIN_PLUS				= "ACTIVITY_THEME.C_UPDATE_REPEAT_WIN_PLUS",
		C_UPDATE_BOOSTED_WINS 					= "ACTIVITY_THEME.C_UPDATE_BOOSTED_WINS",
		C_UPDATE_JACKPOT_AGAIN					= "ACTIVITY_THEME.C_UPDATE_JACKPOT_AGAIN",
		C_UPDATE_ROCKET_UP						= "ACTIVITY_THEME.C_UPDATE_ROCKET_UP",
		C_UPDATE_REPEAT_WIN_DELUXE				= "ACTIVITY_THEME.C_UPDATE_REPEAT_WIN_DELUXE",
		C_UPDATE_SPIN_REWARDS 					= "ACTIVITY_THEME.C_UPDATE_SPIN_REWARDS",
		C_GAME_MASTER_START						= "ACTIVITY_THEME.C_GAME_MASTER_START",
		C_GAME_MASTER_END						= "ACTIVITY_THEME.C_GAME_MASTER_END",
	},

	------------------------------------- frenzy vault -------------------------------------
	FRENZY_VAULT = {
		DOWNLOAD_SUCCESS 						= "FRENZY_VAULT.DOWNLOAD_SUCCESS",
		WILD_ICON_HIDE							= "FRENZY_VAULT.WILD_ICON_HIDE",
		SHOW_EDIT_POP							= "FRENZY_VAULT.SHOW_EDIT_POP",
		CLOSE_BUY_ICON_DIALOG 					= "FRENZY_VAULTCLOSE_BUY_ICON_DIALOG",
		CLOSE_CHOOSE_ICON_DIALOG 				= "FRENZY_VAULT.CLOSE_CHOOSE_ICON_DIALOG",
	},

	----------------------------------- 奖励中心 ------------------------------------
	REWARDS_CENTER = {
		DOWNLOAD_FINISH 						= "REWARDS_CENTER.DOWNLOAD_FINISH",
		DOWNLOAD_PROGRESS 						= "REWARDS_CENTER.DOWNLOAD_PROGRESS",
		UPDATE_LOCK 							= "REWARDS_CENTER.UPDATE_LOCK",
		UPDATE_RED 								= "REWARDS_CENTER.UPDATE_RED",
		CHANGE_DAY								= "REWARDS_CENTER.CHANGE_DAY",
		UPDATE_MAIN								= "REWARDS_CENTER.UPDATE_MAIN",
		CLOSE                                   = "REWARDS_CENTER.CLOSE",
	},

	------------------------------------- 邮件 -------------------------------------
	INBOX = {
		SHOW_INBOX_SEND 						= "INBOX.SHOW_INBOX_SEND",
		GET_COLLECT_GIFT_COIN					= "INBOX.GET_COLLECT_GIFT_COIN",
		REFRESH_USER_ICON_RED					= "INBOX.REFRESH_USER_ICON_RED",
		REFRESH_USER_ICON_FRAME					= "INBOX.REFRESH_USER_ICON_FRAME",
		REFRESH_ICON_POP 						= "INBOX.REFRESH_ICON_POP",
		GET_GIFT_LIST 							= "INBOX.GET_GIFT_LIST",
		ON_SENDING								= "INBOX.ON_SENDING",

		UPDATE_COUPON 						    = "INBOX.UPDATE_COUPON",
		CLOSE 								    = "INBOX.CLOSE",
		ON_COLLECT_LIST_UPDATE					= "INBOX.ON_COLLECT_LIST_UPDATE",

	},

	------------------------------------- 日常任务 -------------------------------------
	DAILY_MISSION = {
		COLLECT_REWARD_OVER 					= "DAILY_MISSION.COLLECT_REWARD_OVER",
		HIDE_DASHBOARD 					        = "DAILY_MISSION.HIDE_DASHBOARD",
		ON_COLLECT_DASHBOARD 					= "DAILY_MISSION.ON_COLLECT_DASHBOARD",
	},

	------------------------------------- theme footer -------------------------------------
	THEME_FOOTER = {
		SWALLOW_IMAGE_TOUCH  					= "THEME_FOOTER.SWALLOW_IMAGE_TOUCH",
	},

	------------------------------------- B活动 -------------------------------------
	ACTIVITY_B = {
		UPDATE_LOBBY_COUNT 						= "ACTIVITY_B.UPDATE_LOBBY_COUNT",
	},

	------------------------------------- B活动rocket -------------------------------------
	ROCKET = {
		COLLECT_ROCKET_STEP  					= "ROCKET.COLLECT_ROCKET_STEP",
		CONSUME_CHIPS  							= "ROCKET.CONSUME_CHIPS",
		BOOSTER_REFRESH 						= "ROCKET.BOOSTER_REFRESH",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "ROCKET.UPDATE_B_MOVE_ICON_PROGRESS",
	},
	------------------------------------- B活动journey -------------------------------------
	JOURNEY = {
		BOOSTER_REFRESH 						= "JOURNEY.BOOSTER_REFRESH",
		ACTIVITY_END 							= "JOURNEY.ACTIVITY_END",
		COLLECT_JOURNEY_STEP 					= "JOURNEY.COLLECT_JOURNEY_STEP",
		SPIN 									= "JOURNEY.SPIN",
		TRICK_END 								= "JOURNEY.TRICK_END",
		CONSUME_CHIPS 							= "JOURNEY.CONSUME_CHIPS",
		BOOSTER_BUY_FINISH 						= "JOURNEY.BOOSTER_BUY_FINISH",
		BOOSTER_BUY_COLLECT 					= "JOURNEY.BOOSTER_BUY_COLLECT",
		COLLECT_SUPER_CANDY 					= "JOURNEY.COLLECT_SUPER_CANDY",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "JOURNEY.UPDATE_B_MOVE_ICON_PROGRESS",
		REFRESH_B_TOKEN_THEME 					= "JOURNEY.REFRESH_B_TOKEN_THEME",
		REFRESH_B_TOKEN_CHEST 					= "JOURNEY.REFRESH_B_TOKEN_CHEST",
	},
	------------------------------------- B活动bingo -------------------------------------
	BINGO = {
		COUNT_REFRESH  							= "BINGO.COUNT_REFRESH",
		RANK_REFRESH  							= "BINGO.RANK_REFRESH",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "BINGO.UPDATE_B_MOVE_ICON_PROGRESS",
		UPDATA_B_GUIDE 							= "BINGO.UPDATA_B_GUIDE",
		SHOW_GUIDE 								= "BINGO.SHOW_GUIDE",
		UPDATE_CHEST_SHOW 						= "BINGO.UPDATE_CHEST_SHOW",
		COLLECT_PUZZLE_PRIZE 					= "BINGO.COLLECT_PUZZLE_PRIZE",
		SHOW_CHEST_BY_INDEX 					= "BINGO.SHOW_CHEST_BY_INDEX",
		UPDATA_PUZZLE_PROGRESS_SHOW 			= "BINGO.UPDATA_PUZZLE_PROGRESS_SHOW",
		UPDATE_BOOSTER_SHOW 					= "BINGO.UPDATE_BOOSTER_SHOW",
		DISABLE_BTN_FOR_WHILE 					= "BINGO.DISABLE_BTN_FOR_WHILE",
		UPDATE_DASH 							= "BINGO.UPDATE_DASH",
		KEEP_PLAYING							= "BINGO.KEEP_PLAYING",
	},
	------------------------------------- B活动blast -------------------------------------
	BLAST = {
		-- COUNT_REFRESH  							= "BLAST.COUNT_REFRESH",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "BLAST.UPDATE_B_MOVE_ICON_PROGRESS",
	},
	------------------------------------- B活动blast -------------------------------------
	MOW = {
		COUNT_REFRESH  							= "MOW.COUNT_REFRESH",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "MOW.UPDATE_B_MOVE_ICON_PROGRESS",
		BOOSTER_BUY_FINISH 						= "MOW.BOOSTER_BUY_FINISH",
		UPDATE_DASH_DATA 						= "MOW.UPDATE_DASH_DATA",
	},
	------------------------------------- B活动cooking -------------------------------------
	COOKING = {
		COUNT_REFRESH  							= "COOKING.COUNT_REFRESH",
		DASH_REFRESH							= "COOKING.DASH_REFRESH",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "COOKING.UPDATE_B_MOVE_ICON_PROGRESS",
	},

	------------------------------------- B活动gof -------------------------------------
	GOF = {
		COUNT_REFRESH  							= "GOF.COUNT_REFRESH",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "GOF.UPDATE_B_MOVE_ICON_PROGRESS",
	},

	------------------------------------- 新灯神 -------------------------------------
	RTL_NEW = {
		UPGRADE_GAME_LEVEL						= "RTL_NEW.UPGRADE_GAME_LEVEL",
		ENTER_GENIE_GAME 						= "RTL_NEW.ENTER_GENIE_GAME",
		GENIE_GAME_LOAD_FINISHED				= "RTL_NEW.GENIE_GAME_LOAD_FINISHED",
		HIDE_GAME_DIALOG						= "RTL_NEW.HIDE_GAME_DIALOG",
		ADD_GENIE_ANIMATION 					= "RTL_NEW.ADD_GENIE_ANIMATION",
		COLLECT_REWARD_OVER 					= "RTL_NEW.COLLECT_REWARD_OVER",
		ON_STAMP_SEASON_FINISH 					= "RTL_NEW.ON_STAMP_SEASON_FINISH",
		ON_CUT_ANIMATION_FINISH 				= "RTL_NEW.ON_CUT_ANIMATION_FINISH",
		ON_CUT_ANIMATION_DURING 				= "RTL_NEW.ON_CUT_ANIMATION_DURING",
	},
	------------------------------------- 公会 -------------------------------------
	CLUB = {
		-- 挑战任务进度变化
		CHALLENGE_PROGRESS 						= "CLUB.CHALLENGE_PROGRESS",
		-- 收完挑战奖励
		COLLECT_CHALLENGE 						= "CLUB.COLLECT_CHALLENGE",
		-- 创建公会
		CREATE_CLUB 							= "CLUB.CREATE_CLUB",
		-- 加入公会
		JOIN_CLUB 								= "CLUB.JOIN_CLUB",
		-- 退出公会
		QUIT_CLUB 								= "CLUB.QUIT_CLUB",
	},
	------------------------------------- Money Bank -------------------------------------
	MONEY_BANK = {
		PAY_OVER 								= "MONEY_BANK.PAY_OVER",
		HIDE_MB									= "MONEY_BANK.HIDE_MB",
	},
	------------------------------------- 21040 -------------------------------------
	SPOOKY_CHALLENGE = {
		COLLECT_REWARD_END 						= "SPOOKY_CHALLENGE.COLLECT_REWARD_END",
	},
	------------------------------------- 23009 -------------------------------------
	ATW_WILD_BAG = {
		COLLECT_BOX_START 						= "ATW_WILD_BAG.COLLECT_BOX_START",
		FINISH_BUY 								= "ATW_WILD_BAG.FINISH_BUY",
		COLLECT_BOX_END 						= "ATW_WILD_BAG.COLLECT_BOX_END",
	},

	------------------------------------- store -------------------------------------
	STORE = {
		COLLECT_LUCKY_CHARM						= "STORE.COLLECT_LUCKY_CHARM",
		HIDE_LUCKY_CHARM						= "STORE.HIDE_LUCKY_CHARM",
	},
	------------------------------------- stamp -------------------------------------
	STAMP = {
		REFRESH_CURRENT_TOTAL_STAMP_COUNT 		= "STAMP.REFRESH_CURRENT_TOTAL_STAMP_COUNT",
		-- 获取新邮票
		NEW_EASY_STAMP							= "STAMP.NEW_EASY_STAMP",
		CLEAR_EASY_STAMP						= "STAMP.CLEAR_EASY_STAMP",
		STAMP_GUIDE_INDEX                       = "STAMP.STAMP_GUIDE_INDEX",
		ON_TOUCH_PLAY_AGAIN_SECTION_CHANGE      = "STAMP.ON_TOUCH_PLAY_AGAIN_SECTION_CHANGE",
		ON_COLLECTED_PLAY_AGAIN_PRIZE      		= "STAMP.ON_COLLECTED_PLAY_AGAIN_PRIZE",
		REFRESH_HALL_MENU_BTN_ENABLE      		= "STAMP.REFRESH_HALL_MENU_BTN_ENABLE",
		INFO_SEND      							= "STAMP.INFO_SEND",
		REFRESH_STAMP_NODE 						= "STAMP.REFRESH_STAMP_NODE",
		UPDATE_DOWNLOAD_PROGRESS 				= "STAMP.UPDATE_DOWNLOAD_PROGRESS",
	},
	------------------------------------- words game ----------------------------------
	WORDS_GAME = {
		RATIO_TIME_UP 							= "WORDS_GAME.RATIO_TIME_UP",
		UPDATE_RATIO 							= "WORDS_GAME.UPDATE_RATIO",
		ON_SEASON_FINISH						= "WORDS_GAME.ON_SEASON_FINISH",
	},
	-------------------------------------- byd --------------------------------------
	BYD = {
		UNLOCK_GURU 							= "BYD.UNLOCK_GURU",
		HIDE_OPEN_VAULT 						= "BYD.HIDE_OPEN_VAULT",
		CLOSE_WILD_DEPOT						= "BYD.CLOSE_WILD_DEPOT",
		UPDATE_GURU_BUILDING					= "BYD.UPDATE_GURU_BUILDING",
		HIDE_BUILD_SPINE_NODE					= "BYD.HIDE_BUILD_SPINE_NODE",
	},
	------------------------------------- atw -------------------------------------
	ATW = {
		OPEN_ALL_PURCHASE_BTN 					= "ATW.OPEN_ALL_PURCHASE_BTN",
		CLOSE_ALL_PURCHASE_BTN 					= "ATW.CLOSE_ALL_PURCHASE_BTN",
		UPDATE_STORE_POINT 						= "ATW.UPDATE_STORE_POINT",
		SHOW_PRIZE_DIALOG 						= "ATW.SHOW_PRIZE_DIALOG",
		ON_CHANGE_BET 							= "ATW.ON_CHANGE_BET",
		REFRESH_THEME_ICON_COUNT_DOWN			= "ATW.REFRESH_THEME_ICON_COUNT_DOWN",
		ON_COLLECT_ATW_ALL_PRIZE				= "ATW.ON_COLLECT_ATW_ALL_PRIZE",
		REFRESH_THEME_ICON 						= "ATW.REFRESH_THEME_ICON",
	},
	------------------------------------- archer -------------------------------------
	ARCHER = {
		BUTTON_INITIAL							= "ARCHER.BUTTON_INITIAL",
		REFRESH_WORDS 							= "ARCHER.REFRESH_WORDS",
		-- 更新主题滑动icon
		UPDATE_B_MOVE_ICON_PROGRESS 			= "ARCHER.UPDATE_B_MOVE_ICON_PROGRESS",
	},

	------------------------------------- setting -------------------------------------
	SETTING = {
		UPDATE_STATUS	 						= "SETTING.UPDATE_STATUS",
		BONUS_CODE_TIMER 						= "SETTING.BONUS_CODE_TIMER",
		BONUS_CODE_RIGHT 						= "SETTING.BONUS_CODE_RIGHT",
		BONUS_CODE_ERROR						= "SETTING.BONUS_CODE_ERROR",
		USER_DELETE_ACCOUNT						= "SETTING.USER_DELETE_ACCOUNT",
	},
	------------------------------------- daily_prize -------------------------------------
	DAILY_PRIZE = {
		SHOWMAINDIALOG 							= "DAILY_PRIZE.SHOWMAINDIALOG",
	},

	------------------------------------- badge -------------------------------------
	BADGE = {
		PICK_BADGE_BONUS_GAME  					= "BADGE.PICK_BADGE_BONUS_GAME",
		GET_BADGE  								= "BADGE.GET_BADGE",
		DOWNLOAD_THEME_LOADING  				= "BADGE.DOWNLOAD_THEME_LOADING",
		COLLECT_BADGE_BONUS_GAME  				= "BADGE.COLLECT_BADGE_BONUS_GAME",
		GET_BADGE_BASE_STATUS  					= "BADGE.GET_BADGE_BASE_STATUS",
		COLLECT_CHALLENGE 						= "BADGE.COLLECT_CHALLENGE",
		-- CLICK_SAME_THEME  						= "BADGE.CLICK_SAME_THEME",
	},

	------------------------------------- voucher -------------------------------------
	VOUCHER = {
		ON_CHANGE_BET 							= "VOUCHER.ON_CHANGE_BET",
		REFRESH_THEME_ICON 						= "VOUCHER.REFRESH_THEME_ICON",
		REFRESH_THEME_ICON_FULL 				= "VOUCHER.REFRESH_THEME_ICON_FULL",
		REFRESH_SPIN_ICON                       = "VOUCHER.REFRESH_SPIN_ICON",
		REFRESH_SPIN_LEFT_COUNT                 = "VOUCHER.REFRESH_SPIN_LEFT_COUNT",
		REFRESH_SPIN_AUTO_TIP                 = "VOUCHER.REFRESH_SPIN_AUTO_TIP",
		REFRESH_NUMS                       		= "VOUCHER.REFRESH_NUMS",
	},

	------------------------------------- login_bonus -------------------------------------
	LOGIN_BONUS = {
		PLAY_WEEK_COUNT_SPIN 				    = "LOGIN_BONUS.PLAY_WEEK_COUNT_SPIN",
		PLAY_SIGN_SPIN 							= "LOGIN_BONUS.PLAY_SIGN_SPIN",
		SHOW_DAY_TIP							= "LOGIN_BONUS.SHOW_DAY_TIP",
	},

	------------------------------------- free_bonus -------------------------------------
	FREE_BONUS = {
		SHOW_CARD_SPINE 				        = "FREE_BONUS.SHOW_CARD_SPINE",
	},

	------------------------------------- mansion -------------------------------------
	MANSION_QUEST = {
		-- 主题任务进度变化
		UPDATE_THEME_MISSION					= "MANSION_QUEST.UPDATE_THEME_MISSION",
		-- 刷新主题入口
		UPDATE_ROOM_THEME						= "MANSION_QUEST.UPDATE_ROOM_THEME",
		-- 刷新booster
		UPDATE_MANSION_BOOSTER					= "MANSION_QUEST.UPDATE_MANSION_BOOSTER",
		-- 刷新skip卡
		UPDATE_MANSION_SKIP						= "MANSION_QUEST.UPDATE_MANSION_SKIP",
		-- loading加载完毕
		HIDE_LOADING							= "MANSION_QUEST.HIDE_LOADING",
		-- 领取主题奖励
		COLLECT_THEME_REWARD				 	= "MANSION_QUEST.COLLECT_THEME_REWARD",
		-- 显示主题任务描述
		SHOW_THEME_DETAIL						= "MANSION_QUEST.SHOW_THEME_DETAIL",
		-- 刷新地图角色模型
		UPDATE_MAP_MODEL						= "MANSION_QUEST.UPDATE_MAP_MODEL",
		-- 解锁地图建筑
		UNLOCK_MAP_ITEM							= "MANSION_QUEST.UNLOCK_MAP_ITEM",
		-- 点击任意位置
		TOUCH_SCREEN_END						= "MANSION_QUEST.TOUCH_SCREEN_END",
		-- 点击商店弹窗的任意位置
		TOUCH_SHOP_SCREEN_END					= "MANSION_QUEST.TOUCH_SHOP_SCREEN_END",
		-- mansion主题入口气泡
		MANSION_THEME_ENTER_TIP					= "MANSION_QUEST.MANSION_THEME_ENTER_TIP",
		-- mansion主题内收集星星结束
		THEME_COLLECT_STAR_OVER					= "MANSION_QUEST.THEME_COLLECT_STAR_OVER",
		-- 关闭mansion任务弹窗
		HIDE_MANSION_TASK_POP					= "MANSION_QUEST.HIDE_MANSION_TASK_POP",
		-- debug
		DEBUG_SHOW_MAP_MODEL					= "MANSION_QUEST.DEBUG_SHOW_MAP_MODEL",

		SHOW_ITEM_APPEAR_ACTION 				= "MANSION_QUEST.SHOW_ITEM_APPEAR_ACTION",
		-- 清理cd building状态特效
		CLEAR_ANIMATION_BUILDING 				= "MANSION_QUEST.CLEAR_ANIMATION_BUILDING",
	},


	------------------------------------- 21034 -------------------------------------
	ATWCBO = {
		ATWCBO_HIDE_PROGRESS 					= "ATWCBO.ATWCBO_HIDE_PROGRESS",
		ATWCBO_SHOW_PROGRESS 					= "ATWCBO.ATWCBO_SHOW_PROGRESS",
		ATWCBO_HIDE								= "ATWCBO.ATWCBO_HIDE",
	},

	------------------------------------- 20428 -------------------------------------
	STAMPCBO = {
		STAMPCBO_HIDE_PROGRESS 					= "STAMPCBO.STAMPCBO_HIDE_PROGRESS",
		STAMPCBO_SHOW_PROGRESS 					= "STAMPCBO.STAMPCBO_SHOW_PROGRESS",
		STAMPCBO_HIDE							= "STAMPCBO.STAMPCBO_HIDE",
	},

	------------------------------------- 22218 -------------------------------------
	BYDCBODELUXE = {
		BYDCBODELUXE_HIDE_PROGRESS 					= "BYDCBODELUXE.BYDCBODELUXE_HIDE_PROGRESS",
		BYDCBODELUXE_SHOW_PROGRESS 					= "BYDCBODELUXE.BYDCBODELUXE_SHOW_PROGRESS",
		BYDCBODELUXE_HIDE							= "BYDCBODELUXE.BYDCBODELUXE_HIDE",
	},

	------------------------------- MB Challenge活动相关 ------------------------------
	MBCHALLENGE = {
		AFTER_COLLECT				= "MBCHALLENGE.AFTER_COLLECT",
	},

	------------------------------------- mission pass -------------------------------------
	MISSIONPASS = {
		MP_SETDASHBOARD_TOUCH_ENABLE 			= "MISSIONPASS.MP_SETDASHBOARD_TOUCH_ENABLE",
		MP_ON_CONSUME_CHIPS						= "MISSIONPASS.MP_ON_CONSUME_CHIPS",
		MP_GUIDE 								= "MISSIONPASS.MP_GUIDE",
		MP_CHANGE_THEME_FOOTER_SHOWTYPE_TO_MP   = "MISSIONPASS.MP_CHANGE_THEME_FOOTER_SHOWTYPE_TO_MP",
		MP_DASHBOARD_CLOSE_CTL 					= "MISSIONPASS.MP_DASHBOARD_CLOSE_CTL",

		MP_SHOW_REWARD_TIP   					= "MISSIONPASS.MP_SHOW_REWARD_TIP",

	},

	------------------------------------- theme control -------------------------------------
	THEMECONTROL = {
		THEMECONTROL_LEVELUP_ENDED 			= "THEMECONTROL.THEMECONTROL_LEVELUP_ENDED",
	},

	------------------------------------- level up party -------------------------------------
	LEVEL_UP_PARTY = {
		AUTO_SPIN_POPUP_CLOSE 			 	= "LEVEL_UP_PARTY.AUTO_SPIN_POPUP_CLOSE",
		COLLECT_CHALLENGE_PRIZE 			= "LEVEL_UP_PARTY.COLLECT_CHALLENGE_PRIZE",
		-- 显示气泡
		SHOW_THEME_TIP						= "LEVEL_UP_PARTY.SHOW_THEME_TIP",
		COLLECT_CHALLENGE_REISSUE_PRIZE		= "LEVEL_UP_PARTY.COLLECT_CHALLENGE_REISSUE_PRIZE",
		REFRESH_CHALLENGE_PLUS_SHOW			= "LEVEL_UP_PARTY.REFRESH_CHALLENGE_PLUS_SHOW",
	},

	------------------------------------- C活动43006 cumulative_purchase -------------------------------------
	CUMULATIVE_PURCHASE = {
		COLLECT_PRIZE_END 			 			= "CUMULATIVE_PURCHASE.COLLECT_PRIZE_END",
	},

	-- 20422
	PRIZE_HUNT = {
		ON_COLLECT_STORE 						= "PRIZE_HUNT.ON_COLLECT_STORE",
	},

	------------------------------------- privacy policy -------------------------------------
	PRIVACY_POLICY = {
		STATUS_CHANGE 							= "PRIVACY_POLICY.STATUS_CHANGE",
	},

	-- IMPROVE = {
	-- 	HIDE_NEW_PERIOD_PRIZE 					= "IMPROVE.HIDE_NEW_PERIOD_PRIZE",
	-- },

	------------------------------------- promotion -------------------------------------
	PROMOTION = {
		LOWEST_FREE_COLLECT_RESULT				= "PROMOTION.LOWEST_FREE_COLLECT_RESULT",
	},

	------------------------------------- tourn cash -------------------------------------
	TOURN_CASH = {
		DOWNLOAD_PROGRESS 						= "TOURN_CASH.DOWNLOAD_PROGRESS",
		DOWNLOAD_SUCCESS 						= "TOURN_CASH.DOWNLOAD_SUCCESS",
		LOCK_START 								= "TOURN_CASH.LOCK_START",
		-- 加入房间结果
		JOIN_ROOM_FAIL 							= "TOURN_CASH.JOIN_ROOM_FAIL",
		-- 玩家加入退出房间
		PLAYER_CHANGE							= "TOURN_CASH.PLAYER_CHANGE",
		-- 阶段变化
		STAGE_CHANGE							= "TOURN_CASH.STAGE_CHANGE",
		-- bonus结束
		BONUS_OVER								= "TOURN_CASH.BONUS_OVER",
		-- 关闭loading
		HIDE_LOADING 							= "TOURN_CASH.HIDE_LOADING",
		-- 关闭大厅弹窗
		QUIT_LOBBY								= "TOURN_CASH.QUIT_LOBBY",
		-- 显示result
		PLAY_RESULT_ACTION 						= "TOURN_CASH.PLAY_RESULT_ACTION",
		-- 刷新lobby
		REFRESH_LOBBY 							= "TOURN_CASH.REFRESH_LOBBY",
		-- 关闭引导
		GUIDE_OVER								= "TOURN_CASH.GUIDE_OVER",
		-- 阶段结束
		ROUND_OVER								= "TOURN_CASH.ROUND_OVER",
		-- 刷新bet
		REFRESH_BET								= "TOURN_CASH.REFRESH_BET",
		-- 开始spin
		START_SPIN								= "TOURN_CASH.START_SPIN",
	},

	------------------------------------- infinity machine -------------------------------------
	INFINITY_MACHINE = {
		REFRESH_CHOOSE_STAMP_ITEM_COUNT 		= "INFINITY_MACHINE.REFRESH_CHOOSE_STAMP_ITEM_COUNT",
		REFRESH_CHOOSE_STAMP_OFFSETX 			= "INFINITY_MACHINE.REFRESH_CHOOSE_STAMP_OFFSETX",
	},

	------------------------------------- LAZY SPRITE -------------------------------------
	LAZY_SPRITE = {
		REFRESH_FB_ICON_ALL 					= "LAZY_SPRITE.REFRESH_FB_ICON_ALL",
	},
	------------------------------------- C活动 purchase blast -------------------------------------
	PURCHASE_BLAST = {
		COLLECT_PRIZE_FINISH 					= "PURCHASE_BLAST.COLLECT_PRIZE_FINISH",
	},

	------------------------------- C活动 store/purchase blast deluxe -------------------------------
	STORE_BLAST_DELUXE = {
		SHOW_FLY_STAR 							= "STORE_BLAST_DELUXE.SHOW_FLY_STAR",
	},

	------------------------------- C活动 22006 upgrade byd -------------------------------
	UPGRADE_BYD = {
		POPUP_CLOSE 							= "UPGRADE_BYD.POPUP_CLOSE",
	},

	PURCHASE_BLAST_DELUXE = {
		SHOW_FLY_STAR 							= "PURCHASE_BLAST_DELUXE.SHOW_FLY_STAR",
	},

	BOQING = {
		COLLSISION_SPECIAL_DING				    = "BOQING.COLLSISION_SPECIAL_DING",
	},

	------------------------------- 广告 start -------------------------------
	AD_MARQUEE = {
		ADSUCCESSFUL 							= "AD_MARQUEE.ADSUCCESSFUL",
		ADFAIL 									= "AD_MARQUEE.ADFAIL",
		ON_FREE_RESULT 							= "AD_MARQUEE.ON_FREE_RESULT",
		ON_AD_PRIZE 							= "AD_MARQUEE.ON_AD_PRIZE",
		TRA_AD_FAILED 							= "AD_MARQUEE.TRA_AD_FAILED",
		-- -- 资源下载进度变化
		-- DOWNLOAD_PROGRESS 						= "AD_MARQUEE.DOWNLOAD_PROGRESS",
		-- UPDATE_LOCK 							= "AD_MARQUEE.UPDATE_LOCK",
		-- DOWNLOAD_FINISH 						= "AD_MARQUEE.DOWNLOAD_FINISH",
		-- 刷新红点
		-- UPDATE_RED								= "AD_MARQUEE.UPDATE_RED",
	},
	AD_REWARD = {
		ADSUCCESSFUL 							= "AD_REWARD.ADSUCCESSFUL",
		ADFAIL 									= "AD_REWARD.ADFAIL",
		ON_FREE_RESULT 							= "AD_REWARD.ON_FREE_RESULT",
		ON_AD_PRIZE 							= "AD_REWARD.ON_AD_PRIZE",
		TRA_AD_FAILED 							= "AD_REWARD.TRA_AD_FAILED",
		-- -- 资源下载进度变化
		-- DOWNLOAD_PROGRESS 						= "AD_REWARD.DOWNLOAD_PROGRESS",
		-- DOWNLOAD_FINISH 						= "AD_REWARD.DOWNLOAD_FINISH",
		-- UPDATE_LOCK 							= "AD_REWARD.UPDATE_LOCK",
		-- 刷新红点
		-- UPDATE_RED								= "AD_REWARD.UPDATE_RED",
	},
}
-- 定义个全局变量吧，不用每次都require了
EVENTNAMES = EVENTS;
--leaderboard
-- EVT_GET_LEADBOARD_LIST_BEGIN  = "EVT_GET_LEADBOARD_LIST_BEGIN"
-- EVT_GET_LEADBOARD_LIST_END    = "EVT_GET_LEADBOARD_LIST_END"
-- NTF_LEADBOARD_UPDATE_VIEW     = "NTF_LEADBOARD_UPDATE_VIEW"

--vipRoom
return EVENTS
