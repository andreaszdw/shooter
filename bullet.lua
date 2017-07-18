-----------------------------------------------------------
--
-- bullet.lua
--
-----------------------------------------------------------

local bullet = {}
local bullet_mt = { __index = bullet }	-- metatable

-- constructor
-----------------------------------------------------------
function bullet.new(imagesheet, frame, sound, speedPerSecond, power)	
	local newBullet = {
		imagesheet = imagesheet,
		frame = frame,
		sound = sound,
		speedPerSecond = speedPerSecond,
		power = power
	}
	return setmetatable( newBullet, bullet_mt )
end

-----------------------------------------------------------
function bullet:create(x, y, name)
	self.image =  display.newImage(self.imagesheet, self.frame)
	self.image.x = x
	self.image.y = y
	self.image.isBullet = true
	self.image.gravityScale = 0
    self.image.isSensor = true
    self.image.name = name
    --self.image:setLinearVelocity(0, self.speedPerSecond)

    -------------------------------------------------------
    function self.image.getPower()


    	return self.power

	end
end

-----------------------------------------------------------
return bullet