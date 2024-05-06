
local FPS = 30
local INTERVAL = 1 / FPS

----------------------

FrameAnimationParticleSystem = class("FrameAnimationParticleSystem", function () return cc.Node:create() end)

function FrameAnimationParticleSystem:ctor (frameAnimCacheName, frameFile, startFrame, endFrame, frameRate)
	-- if frameAnim's start frame index is required to be random, then can't use Cocos Animation
	-- else can cache Animation for better performance
	self.frameAnimCacheName = frameAnimCacheName
	self.frameFile = frameFile
	self.startFrame = startFrame
	self.endFrame = endFrame
	self.frameRate = frameRate

	if frameAnimCacheName then
		Display.cacheFrameAnimation(frameAnimCacheName, frameFile, startFrame, endFrame, frameRate)
	end

	self.conf = {}
	self.conf.num = num
	self.conf.numVar = 0
	self.conf.pos = cc.p(0, 0)
	self.conf.posVar = cc.p(0, 0)
	self.conf.startAnimScale = 1
	self.conf.startAnimScaleVar = 0
	self.conf.timeSpan = 0
	self.conf.timeSpanVar = 0
	self.conf.lifeTime = 5
	self.conf.lifeTimeVar = 0
	self.conf.speed = 0
	self.conf.speedVar = 0
	self.conf.endSpeed = 0
	self.conf.endSpeedVar = 0
	self.conf.startAngle = 0
	self.conf.startAngleVar = 0
	self.conf.gravity = nil
	self.conf.startRotation = 0
	self.conf.startRotationVar = 0
	self.conf.rotatePerSecond = 0
	self.conf.rotatePerSecondVar = 0

	self.timeElapsed = 0

	self.particles = { }
end


function FrameAnimationParticleSystem:start ()
	self.num = self.conf.num + math.random(-100, 100) * 0.01 * self.conf.numVar
	self.timeSpan = self.conf.timeSpan + math.random(-100, 100) * 0.01 * self.conf.timeSpanVar
	self.lifeTime = self.conf.lifeTime + math.random(-100, 100) * 0.01 * self.conf.lifeTimeVar
	self.speed = self.conf.speed + math.random(-100, 100) * 0.01 * self.conf.speedVar
	self.startAngle = self.conf.startAngle + math.random(-100, 100) * 0.01 * self.conf.startAngleVar
	self.rotatePerSecond = self.conf.rotatePerSecond + math.random(-100, 100) * 0.01 * self.conf.rotatePerSecondVar

	-- loop to add particle
	self.genTimes = { }
	for i = 1, self.num do
		if self.timeSpan > 0 then
			table.insert(self.genTimes, math.random() * self.timeSpan)
		else
			table.insert(self.genTimes, 0)
		end
	end
	table.sort(self.genTimes)
	
	local function _gameLogic (dt)
		self:gameLogic(dt)
	end
	self:scheduleUpdateWithPriorityLua(_gameLogic, 0)
	-- self:gameLogic()
end

function FrameAnimationParticleSystem:setNum (num, numVar)
	self.conf.num = num
	self.conf.numVar = numVar or 0
end

-- second
function FrameAnimationParticleSystem:setTimeSpan (timeSpan, timeSpanVar)
	self.conf.timeSpan = timeSpan
	self.conf.timeSpanVar = timeSpanVar or 0
end

-- second
function FrameAnimationParticleSystem:setLifeTime (lifeTime, liftTimeVar)
	self.conf.lifeTime = lifeTime
	self.conf.liftTimeVar = liftTimeVar or 0
end

function FrameAnimationParticleSystem:setPos (pos, posVar)
	self.conf.pos = pos or cc.p(0, 0)
	self.conf.posVar = posVar or cc.p(0, 0)
end

function FrameAnimationParticleSystem:setStartAnimScale (s, sVar)
	self.conf.startAnimScale = s
	self.conf.startAnimScaleVar = sVar or 0
end

-- speed = pixel per sec
function FrameAnimationParticleSystem:setStartSpeed (speed, speedVar)
	self.conf.startSpeed = speed
	self.conf.startSpeedVar = speedVar or 0
end

function FrameAnimationParticleSystem:setEndSpeed (speed, speedVar)
	self.conf.endSpeed = speed
	self.conf.endSpeedVar = speedVar or 0
end

-- ccw from x-axis, movement
function FrameAnimationParticleSystem:setAngle (angle, angleVar)
	self.conf.angle = angle
	self.conf.angleVar = angleVar or 0
end

function FrameAnimationParticleSystem:setGravity (gravity)
	self.conf.gravity = gravity
end

-- degree cw
function FrameAnimationParticleSystem:setStartRotation (r, rVar)
	self.conf.startRotation = r
	self.conf.startRotationVar = rVar or 0
end

-- degree cw
function FrameAnimationParticleSystem:setRotatePerSecond (rps, rpsVar)
	self.conf.rotatePerSecond = rps
	self.conf.rotatePerSecondVar = rpsVar or 0
end

function FrameAnimationParticleSystem:addParticle ()
	local p = FrameAnimationParticle.new(self)
	table.insert(self.particles, p)
end

function FrameAnimationParticleSystem:gameLogic (dt)
	if self.ended then return end
	self.timeElapsed = self.timeElapsed + dt
	-- add new particles
	while #self.genTimes > 0 do
		if self.genTimes[1] > self.timeElapsed then break end
		table.remove(self.genTimes, 1)

		self:addParticle()
	end
	for i, p in pairs(self.particles) do
		if p then
			p:gameLogic(dt)
			if p.cd <= 0 then
				-- remove it
				p:removeFromParent()
				table.remove(self.particles, i)
			end
		end
	end
	if 0 == #self.genTimes and 0 == #self.particles then
		-- remove self
		self.ended = true
		self:removeFromParent()
	end

	-- self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(logic), cc.DelayTime:create(INTERVAL))))
end

------------------------

FrameAnimationParticle = class("FrameAnimationParticle", function () return cc.Node:create() end)

function FrameAnimationParticle:ctor (particleSystem)
	self.particleSystem = particleSystem
	self.conf = particleSystem.conf

	self.pos = cc.pAdd(self.conf.pos, cc.pMul(self.conf.posVar, math.random(-100, 100) * 0.01))
	self.animScale = self.conf.startAnimScale + self.conf.startAnimScaleVar, math.random(-100, 100) * 0.01
	self.lifeTime = self.conf.lifeTime + math.random(-100, 100) * 0.01 * self.conf.lifeTimeVar
	self.startSpeed = self.conf.startSpeed + math.random(-100, 100) * 0.01 * self.conf.startSpeedVar
	self.endSpeed = self.conf.endSpeed + math.random(-100, 100) * 0.01 * self.conf.endSpeedVar
	self.angle = self.conf.angle + math.random(-100, 100) * 0.01 * self.conf.angleVar
	self.speedVec =  cc.pRotateByAngle(cc.p(self.startSpeed, 0), cc.p(0, 0), math.pi * self.angle / 180)
	self.accelerateVec = cc.pMul(cc.pSub(cc.pRotateByAngle(cc.p(self.endSpeed, 0), cc.p(0, 0), math.pi * self.angle / 180), self.speedVec), 1 / self.lifeTime)
	local startRotation = self.conf.startRotation + math.random(-100, 100) * 0.01 * self.conf.startRotationVar
	self.rotatePerSecond = self.conf.rotatePerSecond + math.random(-100, 100) * 0.01 * self.conf.rotatePerSecondVar

	if particleSystem.frameAnimCacheName then
		-- Frame Animation's start frame index can NOT be random
		Display.playFrameAnimationByName(self, self.pos, particleSystem.frameAnimCacheName, nil, true)
	else
		Display.playSelfAnimation(self, {particleSystem.frameFile, true}, self.pos,
			math.random(particleSystem.startFrame, particleSystem.endFrame), particleSystem.endFrame, particleSystem.frameRate, true)
	end
	self:setRotation(startRotation)

	particleSystem:addChild(self)

	self.cd = self.lifeTime
end

function FrameAnimationParticle:gameLogic (dt)

	if self.cd <= 0 then return end

	if self.conf.gravity then
		self.speedVec.y = self.speedVec.y - self.conf.gravity * dt
	end
	
	-- pos
	local posDelta = cc.pMul(self.speedVec, dt)
	self.pos = cc.pAdd(self.pos, posDelta)
	self:setPosition(self.pos)

	-- scale
	self:setScale(self.animScale)

	-- rotate per second
	self:setRotation(self:getRotation() + self.rotatePerSecond * dt)

	self.cd = self.cd - dt
	if self.cd <= 0 then
		--self:removeFromParent()
	end

end

