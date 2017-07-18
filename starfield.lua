-----------------------------------------------------------
--
-- starfield.lua
--
-----------------------------------------------------------

local starfield = {}
local starfield_mt = { __index = starfield }	-- metatable

-- constructor
-----------------------------------------------------------
function starfield.new(total, starsMaxSize, speed)	
	local newStarfield = {
		stars = {},
		total = total or 600,
		group = group,
		field1 = 0,
		field2 = 0,
		field3 = 0,
		speed = speed or 1,
		starsMaxSize = starsMaxSize or 5
	}
	return setmetatable( newStarfield, starfield_mt )
end

-----------------------------------------------------------
function starfield:create(group)

	self.field1 = self.total/3
	self.field2 = self.field1 + self.total/3
	self.field3 = self.field2 + self.field2

	for i = 1, self.total do
		local star = {} 
		self.starSize = math.random(self.starsMaxSize)
		star.object = display.newRect(math.random(display.contentWidth),math.random(display.contentHeight), self.starSize, self.starSize)
		star.object:setFillColor(1, 1, 1, math.random(30, 100)/100)
		group:insert(star.object)
		self.stars[i] = star
	end
end

-----------------------------------------------------------
function starfield:update(event)
	local starspeed = 0.0
    for i = self.total, 1, -1 do
        if i < self.field1 then
            starspeed = 0.2 * self.speed
        end
        if i < self.field2 and i > self.field1 then
            starspeed = 0.4 * self.speed
        end
        if i < self.field3 and i > self.field2 then
            starspeed = 0.6 * self.speed
        end
        
        self.stars[i].object.y  = self.stars[i].object.y + starspeed

        if self.stars[i].object.y > display.contentHeight then
            self.stars[i].object.y = 0 -- self.stars[i].object.y + display.contentHeight
        end
	end
end

-----------------------------------------------------------
return starfield