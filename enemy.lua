-----------------------------------------------------------
--
-- enemy.lua
--
-----------------------------------------------------------

local vector = require("vector")
local json = require("json")

local enemy = {}
local enemy_mt = { __index = enemy }	-- metatable

-- constructor
-----------------------------------------------------------
function enemy.new(imagesheet, frame, speed, health)

	local newEnemy = {
		imagesheet = imagesheet,
		frame = frame,
		ship = 0,
		speedPerSecond = speed or 50,
		health = health,
		paths = {},
		path = {},
		nextWayPoint = 1,
		newTransition = true,
		vector = 0
	}
	return setmetatable(newEnemy, enemy_mt)
end


-- create the enemy
-----------------------------------------------------------
function enemy:create(x, y, group)

	local filename = system.pathForFile("assets/enemy/green1.json")
	local decoded, pos, msg = json.decodeFile( filename )
 
	if not decoded then
	    print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
	else
	    print( "File successfully decoded!" )
	end

	for i in pairs(decoded.attack) do
		print(decoded.attack[i].x .. decoded.attack[i].y)
	end

	-- the image
	self.ship = display.newImage(self.imagesheet, self.frame)

	-- the name
	self.ship.name = "enemy"
	
	-- center the ship
	self.ship.x = x --display.contentWidth/2
	self.ship.y = y --display.contentHeight/2
	
	-- the ship vector
	self.vector = vector.new(0, 0)

	-- calculate the speed per frame
	self.speedPerFrame = self.speedPerSecond / display.fps

	group:insert(self.ship)

	-------------------------------------------------------
	function self.ship.hit(x)

		self.health = self.health - x

	end
end

-----------------------------------------------------------
function enemy:load(file)

end

-----------------------------------------------------------
function enemy:nextTransition()

	if(self.nextWayPoint > #self.path) then

		self.nextWayPoint = 1

	end

	-------------------------------------------------------
	local function setNewWayPoint()

		self:setNextWayPoint()

	end

	local dist = self:distBetween(self.ship.x, self.ship.y, self.path[self.nextWayPoint].x, self.path[self.nextWayPoint].y)

	local transTime = dist/self.speedPerSecond*1000

	self.ship.rotation = self:angleBetween(self.ship.x, self.ship.y, self.path[self.nextWayPoint].x, self.path[self.nextWayPoint].y)

	transition.to( self.ship, 
		{ tag = "moveObject", 
		time = transTime, 
		x = self.path[self.nextWayPoint].x,
		y = self.path[self.nextWayPoint].y,
		onComplete = setNewWayPoint
		})
	
	self.newTransition = false

end

-----------------------------------------------------------
function enemy:setNextWayPoint()

	self.nextWayPoint = self.nextWayPoint + 1
	self.newTransition = true

end
-----------------------------------------------------------
function enemy:update()

	if (#self.path > 1) then

		if(self.newTransition) then 

			self:nextTransition()

		end

	end

end

-----------------------------------------------------------
function enemy:angleBetween( srcX, srcY, dstX, dstY )

	local angle = ( math.deg( math.atan2( dstY-srcY, dstX-srcX ) )+270 )
	return angle % 360

end

-----------------------------------------------------------
function enemy:distBetween( x1, y1, x2, y2 )
	
	local xFactor = x2 - x1
	local yFactor = y2 - y1
	local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
	return dist

end
-----------------------------------------------------------
function enemy:setPath(path)

	for i = 1, #path, 1 do

		tmpX = path[i].x + self.ship.x
		tmpY = path[i].y + self.ship.y

		table.insert(self.path, {x=tmpX, y=tmpY})

	end

	table.insert(self.path, {x=self.ship.x, y=self.ship.y})

end

-----------------------------------------------------------
return enemy