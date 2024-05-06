AD_REWARD_DATA_KEY = "ad_reward_data"

-- 宝箱类型
AdBoxType = {
	Bronze   = 1,    --青铜宝箱
	Platinum = 2,    --铂金宝箱
	Golden   = 3     --黄金宝箱
}

-- 宝箱奖励配置
local AdBoxRewardConfig = {
	[AdBoxType.Bronze]   = {
        count = 5,
        coins = 10000000
    },
	[AdBoxType.Platinum] = {
        count = 10,
        coins = 50000000
    },
	[AdBoxType.Golden]   = {
        count = 15,
        coins = 150000000
    },
} 

-- 每次看广告奖励
local AdRewardConfig = {
    coins = 6000000
}

local FreeConfig = {
    coins = 5000000
}

AdRewardControl = class("AdRewardControl")
function AdRewardControl:ctor()
	self:reset()
end

function AdRewardControl:reset()
	self.adData         = {}
    self.callback_event = {}
end

function AdRewardControl:getInstance( ... )
	if not self._instance then
		self._instance = AdRewardControl.new()
	end
	return self._instance
end

---------------------------  广告数据  ---------------------------------

-- 从本地数据获取广告数据
function AdRewardControl:getAdDataToLocal()
    local adData = cc.UserDefault:getInstance():getStringForKey(AD_REWARD_DATA_KEY)
    if adData ~= "" then
        self.adData = json.decode(adData)
    else
        self.adData = {
            curCount   = 0,
            totalCount = 15,
            adBox      = {0, 0, 0}
        }
    end
end

-- 将数据保存到本地缓存
function AdRewardControl:saveLocalAdData()
    if next(self.adData) then
        local dataStr = json.encode(self.adData)
        cc.UserDefault:getInstance():setStringForKey(AD_REWARD_DATA_KEY, dataStr)
    end
end

-- 获取看广告总次数
function AdRewardControl:getAdTotalCount()
    return self.adData.totalCount or 15
end

-- 获取当前看广告次数
function AdRewardControl:getAdCurrentCount()
    return self.adData.curCount or 0
end

-- 刷新看广告次数
function AdRewardControl:updateAdCount(count)
    count = count or 0
    self.adData.curCount = count
    self:saveLocalAdData()

    self:updateEvent("updateAdProgress")
    for key, value in pairs(AdBoxRewardConfig) do
        if value.count == count then
            self:updateEvent("updateBox", {key})
            break 

        end
    end
end

-- 获取宝箱是否已领取  0: 未领取  1: 已领取
function AdRewardControl:getAdBoxCollected(type)
    type = type or AdBoxType.Bronze
    return self.adData.adBox[type] == 1
end

-- 刷新宝箱领取转态
function AdRewardControl:updateAdBoxCollectState(type)
    type = type or AdBoxType.Bronze
    self.adData.adBox[type] = 1
    self:saveLocalAdData()
    self:updateEvent("updateBox", {type})
end


---------------------------  广告配置  ---------------------------------

-- 获取宝箱开启次数
function AdRewardControl:getAdBoxOpenCount(type)
    type = type or AdBoxType.Bronze
    local config = AdBoxRewardConfig[type]
    if config then
        return config.count
    end
    return 5 
end

-- 获取宝箱金币
function AdRewardControl:getAdBoxRewardCoins(type)
    type = type or AdBoxType.Bronze
    local config = AdBoxRewardConfig[type]
    if config then
        return config.coins
    end
    return 924000 
end

-- 获取看广告金币数
function AdRewardControl:getAdRewardCoins()
    return AdRewardConfig.coins or 6000000
end

-- 获取免费金币数
function AdRewardControl:getFreeCoins()
    return FreeConfig.coins or 5000000
end

-- 获取看广告宝箱配置
function AdRewardControl:getAdBoxRewardConfig()
    return AdBoxRewardConfig or {}
end



-------------------- 事件监听 --------------------

function AdRewardControl:listenEvent( event, tag, callback )
	self.callback_event[event] 		= self.callback_event[event] or {}
	self.callback_event[event][tag] = callback
end

function AdRewardControl:updateEvent( event, params )
	if not self.callback_event[event] then return end
	for tag, callback in pairs(self.callback_event[event]) do
		if callback then
			callback(unpack(params or {}))
		end
	end
end

function AdRewardControl:cancelEvent( tag )
	for event, config in pairs(self.callback_event or {}) do
		if config[tag] then
			config[tag] = nil
		end
	end
end