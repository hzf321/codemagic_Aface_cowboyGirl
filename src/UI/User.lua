User = class("User")


function User:ctor()
	self.coins = bole.getTotalCoin()
	self.diamond = bole.getTotalDiamond() 
	self.name = "Master"
	self.level = 1
	self.__inst = nil
	self.header = nil
end


function User:setHeader( h )
	if self.header ~= h then
		self.header = h	
	end 
end

function User:getInstance( ... )
	
	if not self.__inst then
		self.__inst = User.new()
	end
	return self.__inst
end

function User:setCoins( coins ,ignoreHeader)
	if coins and self.coins then
		-- print("zhf setCoins ", coins - self.coins)
		self:addCoins(coins - self.coins,ignoreHeader)
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
	return true
end
