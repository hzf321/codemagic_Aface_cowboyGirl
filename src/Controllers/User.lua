USER_DATA_KEY = "user_data" .. THEME_DESKTOP_ID

User = class("User")

function User:ctor()
	self:reset()
end

function User:reset()
	self.coins    = 0
	self.userData = {}
	self.header   = nil
	self.footer   = nil
end

function User:getInstance( ... )
	if not self._instance then
		self._instance = User.new()
	end
	return self._instance
end

function User:setHeader( h )
	if self.header ~= h then
		self.header = h	
	end 
end

function User:setFooter( f )
	if self.footer ~= f then
		self.footer = f	
	end 
end

-------------------------  用户数据  ---------------------------------

-- 从本地数据获取用户数据
function User:getUserDataToLocal()
    local userData = cc.UserDefault:getInstance():getStringForKey(USER_DATA_KEY)
    if userData ~= "" then
        self.userData = json.decode(userData)
    else
        self.userData = {
            coins    = 0,
            diamonds = 0,
            name     = "",
			gift     = 0,
			user_id  = self:generateUserId(),
			loginFB  = 0,	-- 0: 没登录过。 1：登陆过
			freeCoinsTime = 0,	--领取的时间
        }
    end
	self.coins = self.userData.coins
end

-- 将时间戳作为玩家的唯一id
function User:generateUserId()
	return os.time()
end

-- 将数据保存到本地缓存
function User:saveLocalUserData()
    if next(self.userData) then
        local dataStr = json.encode(self.userData)
        cc.UserDefault:getInstance():setStringForKey(USER_DATA_KEY, dataStr)
    end
end

-- 获取金币
function User:getCoins()
    return self.userData.coins or 0
end

-- 获取钻石
function User:getDiamonds()
    return self.userData.diamonds or 0
end

-- 新手礼包是否已领取
function User:isGiftCollected()
    return self.userData.gift == 1
end

-- 新手礼包是否已领取
function User:updateGiftState(state)
	state = state or 1
    self.userData.gift = state
	self:saveLocalUserData()
end

-- faceBook是否登录过
function User:isloginFB()
    return self.userData.loginFB == 1
end

-- faceBook设置状态
function User:updateLoginFBState(state)
	state = state or 0
    self.userData.loginFB = state
	self:saveLocalUserData()
end

-- 返回领取时间
function User:getFreeCoinsTime()
    return self.userData.freeCoinsTime
end

-- 设置领取时间
function User:setFreeCoinsTime(getTime)
	self.userData.freeCoinsTime = getTime
	self:saveLocalUserData()
end



function User:setCoins( coins ,ignoreHeader)
	if coins and self.coins then
		self:addCoins(coins - self.coins, ignoreHeader)
	end
end

function User:addCoins(off, ignoreHeader)
	off = off or 0
	ignoreHeader = ignoreHeader or 0
	local tt = self.coins + off
	if tt < 0 then return false end
	if libUI.isValidNode(self.header) and ignoreHeader ~= 1 then
		self.header:addCoins(self.coins, off)
	end
	self.coins = tt
	self.userData.coins = tt
	self:saveLocalUserData()
	return true
end

function User:refreshHeaderCoins( )
	if self.header and self.header.setCoins then
		self.header:setCoins(self.coins)
	end
end


function User:addDiamonds(off, ignoreHeader)
	off = off or 0
	ignoreHeader = ignoreHeader or 0
	local tt = self.userData.diamonds + off
	if tt < 0 then return false end
	if libUI.isValidNode(self.header) and ignoreHeader ~= 1 then
		self.header:addChips(self.userData.diamonds, off)
	end
	self.userData.diamonds = tt
	self:saveLocalUserData()
	return true
end