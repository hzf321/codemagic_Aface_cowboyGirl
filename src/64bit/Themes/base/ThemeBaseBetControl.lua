
ThemeBaseBetControl = class("ThemeBaseBetControl")
local BetControl = ThemeBaseBetControl
function BetControl:ctor( theThemeControl )
	self.saveLv 		= 1
	self.betIndex 		= 1
	self.betList 		= nil
	self.curBet  		= nil
	self.pointBet 		= nil
	self.themeCtr 		= theThemeControl
	self.theme 			= theThemeControl.theme
end
function BetControl:refreshBetList()
	if self.saveLv == self.themeCtr:getUserLevel() then return end
	
	self.saveLv  = self.themeCtr:getUserLevel()
	self.curBet  = self.themeCtr.defaultBet 
	self.betList = self.themeCtr.nowBetList
	local tmpIndx = table.find(self.betList, self.curBet)
	if tmpIndx < 0 then --nofind
		-- self.curBet = self.betList[self.betIndex]
		local fix = {v = self.betList[#self.betList], i=#self.betList}
		for i,v in ipairs(self.betList) do
			if math.abs(v-self.curBet) < fix.v then
				fix.v = math.abs(v-self.curBet)
				fix.i = i
			end
		end
		self.betIndex = fix.i
		self.curBet = self.betList[self.betIndex]
	else
		self.betIndex = tmpIndx
	end
	-- if User:getInstance():getExp() == 0 then
	-- 	local userId = SettingControl:getInstance():parseUserID() or 0
	-- 	-- if userId %2 == 0 then
	-- 	local number = userId % 10
	-- 	if number >= 0 and number <= 2 then
	-- 		self.betIndex = #self.betList
	-- 		self.curBet = self.betList[self.betIndex]
	-- 	elseif number >=3 and number <= 5 then
	-- 		self.betIndex = #self.betList - 1
	-- 		self.curBet = self.betList[self.betIndex]
	-- 	else
	-- 		-- 对照组
	-- 	end
	-- end
	self:refreshCurBet()
end
function BetControl:adjustWithUserLevelUp()
	-- 废弃
	-- self:refreshBetList()
end
function BetControl:initBetControl()
	self:refreshBetList()
end
function BetControl:getBetList( )
	return self.betList
end
function BetControl:refreshCurBet( )
	if self.pointBet then
		self.themeCtr:adjustThemeBet(self.pointBet,true)
	elseif self.curBet then
		self.themeCtr:adjustThemeBet(self.curBet,false)		
	end
end
function BetControl:setPointBet( thePointBet )
	self.pointBet = thePointBet
	self:refreshCurBet()
end
function BetControl:removePointBet( )
	self.pointBet = nil
	self:refreshBetList()
	self:refreshCurBet()
end
function BetControl:setCurBet( theBet )
	if self.curBet ~= theBet then
		self.curBet = theBet
 		self.betIndex = table.find(self.betList, self.curBet)
		if self.betIndex < 0 then
			self.betIndex = 1
		end
		self:setCurBetSound()
		self:refreshCurBet()
	end
end
function BetControl:getCurBet( )
	local bet = self.pointBet or self.curBet
	-- if self.theme.betFixMul and not self.pointBet then
	-- 	bet = bet * self.theme.betFixMul
	-- end
	return bet
end

function BetControl:getMaxBet( ... )
	local maxBet = self.betList[#self.betList]
	return maxBet
end

function BetControl:setCurBetSound()
	local index = 1
	for i,v in ipairs(self.betList) do
		if self.curBet == v then 
			index = i
			break
		end
		if self.betList[i+1] and self.curBet > v and self.curBet < self.betList[i+1] then
			index = i
			break
		end
	end
	if index == #self.betList then
		bole.playMusic("bet/global_max_bet", nil, nil, "sounds/")
	end
	index = index > 25 and 25 or index
	bole.playMusic("bet" .. index, nil, nil, "sounds/bet/")
end
---------------------------------------------------------------
function BetControl:changeToUpBet( )
	local theIndex = table.find(self.betList, self.curBet)
	local theBet   = nil
	if theIndex >= 1 then
		if theIndex < #self.betList then
			theBet = self.betList[theIndex+1]
		else
			theBet = self.betList[1]
		end
	else
		for index=1,#self.betList do
			if self.curBet < self.betList[index] then
				theBet = self.betList[index]
				break
			end
		end
	end
	if theBet then
		self:setCurBet(theBet)
		self.theme:changeBet(theBet)
	end
end
function BetControl:changeToDownBet( )
	local theIndex = table.find(self.betList, self.curBet)
	local theBet   = nil
	if theIndex >= 1 then
		if theIndex ~= 1 then
			theBet = self.betList[theIndex-1]
		else
			theBet = self.betList[#self.betList]
		end
	else
		for index=#self.betList,1,-1 do
			if self.curBet > self.betList[index] then
				theBet = self.betList[index]
				break
			end
		end
	end
	if theBet then
		self:setCurBet(theBet)
		self.theme:changeBet(theBet)
	end
end
function BetControl:setMaxBet( )
	local maxBet = self.betList[#self.betList]
	if self.curBet ~= maxBet then
		self:setCurBet(maxBet)	
		self.theme:changeBet(maxBet)
	end
end
function BetControl:setMinBet( )
	local minBet = self.betList[1]
	if self.curBet ~= minBet then
		self:setCurBet(minBet)
	end	
end
function BetControl:getMinBet( )
	return self.betList[1]
end
function BetControl:checkIsMaxBet( theBetList )
	local betList = theBetList or self.betList
	local maxBet  = betList[#betList]
	local retTag  = false
	if self.curBet >= maxBet then
		retTag = true
	end
	return retTag
end
function BetControl:checkIsMinBet( theBetList )
	local betList = theBetList or self.betList
	local minBet  = betList[1]
	local retTag  = false
	if self.curBet <= minBet then
		retTag = true
	end
	return retTag
end

function BetControl:checkIsSingleBet( theBetList )
	local betList = theBetList or self.betList

	local retTag  = #betList <= 1

	return retTag
end



