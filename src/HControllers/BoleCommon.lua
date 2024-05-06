
local ACTION_TAG_NUM_ROLL = 10101010

LabelNumRoll = {}

function LabelNumRoll:nrInit (beginNum, secFrame, parserFunc)
	self.nrCurValue = beginNum or 0
	self.nrSecFrame = secFrame or 25
	self.nrParserFunc = parserFunc or bole.dealValueToRetString
end

function LabelNumRoll:nrStartRoll (beginNum, endNum, playDur, parserFunc, nrValueFunc)
	if beginNum then -- set beginNum
		self.nrCurValue = beginNum
	end
	self.nrEndNum = endNum
	self.nrPlayDur = playDur
	if parserFunc then
		self.nrParserFunc = parserFunc
	end

	local addSumNum 	= self.nrEndNum - self.nrCurValue
	
	local minAddValue   = 1
	local changeCnt 	= math.ceil(self.nrPlayDur*self.nrSecFrame)
	self.nrOffset 		= math.floor(addSumNum/changeCnt)
    if math.abs(self.nrOffset) < minAddValue then
    	self.nrOffset = minAddValue
    end
    self.randomValue 	= math.floor(math.abs(self.nrOffset) * 0.2)
    if math.abs(self.randomValue) < minAddValue then
    	self.randomValue = 0
    end

    if self:getActionByTag(ACTION_TAG_NUM_ROLL) then
    	return
    end

    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1/self.nrSecFrame), cc.CallFunc:create(function ()
		if self.nrCurValue == self.nrEndNum then return end

		self.nrCurValue = self.nrCurValue + self.nrOffset + math.random(-self.randomValue, self.randomValue)
		if (self.nrOffset > 0 and self.nrCurValue > self.nrEndNum) or (self.nrOffset < 0 and self.nrCurValue < self.nrEndNum) then
			self.nrCurValue = self.nrEndNum
		end
		self:setString(self.nrParserFunc(self.nrCurValue))
		if nrValueFunc then 
			nrValueFunc(self.nrCurValue)
		end
	end)))
	action:setTag(ACTION_TAG_NUM_ROLL)
	self:setString(self.nrParserFunc(self.nrCurValue))
	libUI.runAction(self,action)
	-- self:runAction(action)
end

function LabelNumRoll:nrStopRoll ()
	self:stopActionByTag(ACTION_TAG_NUM_ROLL)
end

function LabelNumRoll:nrOverRoll ()
	self:stopActionByTag(ACTION_TAG_NUM_ROLL)
	self:setString(self.nrParserFunc(self.nrEndNum))
end

function LabelNumRoll:nrSetCurValue (val, parser)
	self.nrCurValue = val
	self.nrEndNum = val
	parser = parser or self.nrParserFunc
    self:setString(parser(self.nrCurValue))
end

bole.cleanLabelNumRoll = function (label)
	if label.nrStopRoll then
		label:nrStopRoll()
	end
end

bole.dealValueToRetString = function( theValue, abbrMinValue, decimalMaxValue, deZero)
	abbrMinValue    = abbrMinValue or 100000000
	decimalMaxValue = decimalMaxValue or 1000
	local retString = ""
	if abbrMinValue ~= -1 and theValue >= abbrMinValue then
	    retString = FONTS.format(theValue, false, true)
	else
		if decimalMaxValue ~= -1 and theValue >= decimalMaxValue then
			retString = FONTS.format(theValue, true, false)
		else
			retString = FONTS.format(theValue, true, true)
			-- if retString == "0" then
			--      retString = "0.00"
		   	-- end
		end
	end

	if deZero == nil then deZero = true end
	if deZero and not string.match(retString, "%u") then
		if string.match(retString, "%.0+$") then
			retString = string.match(retString, "[^%.]+")
		end
		if string.match(retString, "%.%d0$") then
			retString = string.match(retString, ".*%.%d")
		end
	end
	return retString
end

bole.parseValueWithKB = function(value,count)
    local last = ""
	local maxValue = math.pow(10,count)
    if value > maxValue*1000000000 then
        value = value / 1000000000
        value = math.floor(value)
        last = "B"
        return FONTS.format(value, true) .. last
    elseif value > maxValue*1000000 then
        value = value / 1000000
        value = math.floor(value)
        last = "M"
        return FONTS.format(value, true) .. last
    elseif value > maxValue*1000 then
        value = value / 1000
        value = math.floor(value)
        last = "K"
        return FONTS.format(value, true) .. last
    end
    return FONTS.format(value, true)
end

bole.parseValueWithoutKB = function(value)
    return FONTS.format(value, true)
end

