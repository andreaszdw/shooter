-----------------------------------------------------------
--
-- player.lua
--
-----------------------------------------------------------

local vector = require ("vector")

local player = {}
local player_mt = { __index = player }	-- metatable

-- constructor
-----------------------------------------------------------
function player.new(imagesheet, frame, speed, health)

	local newPlayer = {
		imagesheet = imagesheet,
		frame = frame,
		ship = 0,
		speedPerSecond = speed or 50,
		health = health,
		stickAngle = 0,
		stickDistance = 0,
		stickMaxDistance = 0,
		vector = 0

	}
	return setmetatable( newPlayer, player_mt )
end

-----------------------------------------------------------
-- create the player
function player:create(x, y, group)

	-- the image
	self.ship = display.newImage(self.imagesheet, self.frame)
	
	-- center the ship
	self.ship.x = x --display.contentWidth/2
	self.ship.y = y --display.contentHeight/2

	self.ship.name = "player"
	
	-- set the max for updating
	self.displayWidth = display.contentWidth
	self.displayHeight = display.contentHeight
	
	-- the ship vector
	self.vector = vector.new(0, 0)

	-- calculate the speed per frame
	self.speedPerFrame = self.speedPerSecond / display.fps

	group:insert(self.ship)

end

-----------------------------------------------------------
-- set stick angle and distance, for updating the ship
function player:setStick(angle, distance)

	self.stickAngle = angle
	self.stickDistance = distance

end

-----------------------------------------------------------
-- set the max of stick distance
function player:setStickMaxDistance(maxDistance)

	self.stickMaxDistance = maxDistance

end

-----------------------------------------------------------
function player:update()

	-- calculate vector with stick in ascpect with stick distance
	local radians = math.rad(self.stickAngle)
	self.vector.y = math.cos(radians)
	self.vector.x = math.sin(radians)
	
	-- set x and y, depending of speed per frame and stickdistance
	self.ship.x = self.ship.x + self.vector.x * self.stickDistance/self.stickMaxDistance * self.speedPerFrame
	self.ship.y = self.ship.y - self.vector.y * self.stickDistance/self.stickMaxDistance * self.speedPerFrame

	-- check for borders
	if self.ship.x < 0 + self.ship.width * self.ship.anchorX then
		self.ship.x = 0 + self.ship.width * self.ship.anchorX
		self.velocity = 0
	end

	if self.ship.x > self.displayWidth - self.ship.width*self.ship.anchorX then
		self.ship.x = self.displayWidth - self.ship.width * self.ship.anchorX
		self.velocity = 0
	end

	if self.ship.y < 0 + self.ship.height * self.ship.anchorY then
		self.ship.y = 0 + self.ship.height * self.ship.anchorY
	end

	if self.ship.y > self.displayHeight - self.ship.height * self.ship.anchorY then
		self.ship.y = self.displayHeight - self.ship.height * self.ship.anchorY
	end

end

-----------------------------------------------------------
return player