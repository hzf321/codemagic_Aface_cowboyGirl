
local PopupConfig = {}

-- 弹窗配置
-- dialog: 保存当前弹窗
-- download_type／download_key: 下载项
-- create_func: 弹窗创建函数
-- popup_func: 弹窗直接弹函数，不管当前是否已有弹窗
-- add_front_func: 将弹窗加入popup列表队首，当前没有弹窗才弹出；
-- add_tail_func: 将弹窗加入popup列表队尾，当前没有弹窗才弹出；
PopupConfig.popupDialogConfig = {

	["ad_reward"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("AdReward/Ad_Reward_Dialog"))
			return dialog.new(data, callback)
		end,
	},
	["facebook"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("FaceBook/FaceBook_Dialog"))
			return dialog.new(data, callback)
		end,
	},
	["setting"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("Setting/Setting_Dialog"))
			return dialog.new(data, callback)
		end,
	},
	["gift"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("Lobby/Lobby_Gift_Dialog"))
			return dialog.new(data, callback)
		end,
	},
	["game_rules"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
			local dialog = require ("UI/PaytableView")
			return dialog.new(data.controller, data.page) -- data.page added by rwb 指定打开某一页
		end,
	},
	["inspect_ad"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("Inspect/Inspect_Ad_Dialog"))
			return dialog.new(data, callback)
		end,
	},
	["inspect_fb"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("Inspect/Inspect_facebook_Dialog"))
			return dialog.new(data, callback)
		end,
	},
	["freecoins"] =
	{
		dialog = nil,
		create_func = function (key, data, callback)
            local dialog = require (bole.getDesktopFilePath("FreeCoins/Freecoins__Dialog"))
			return dialog.new(data, callback)
		end,
	},
}

return PopupConfig
