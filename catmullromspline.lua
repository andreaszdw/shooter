-----------------------------------------------------------
--
-- catmullromspline.lua
--
-----------------------------------------------------------

local catmullromspline = {}
local catmullromspline_mt = { __index = catmullromspline }	-- metatable

-- constructor
-----------------------------------------------------------
function catmullromspline.new(points, steps)

	local newcatmullromspline = {
		points = points or {},
		steps = steps or 5

	}
	return setmetatable( newcatmullromspline, catmullromspline_mt )
end

-----------------------------------------------------------

function catmullromspline:create()

	if #self.points < 3 then
		return self.points
	end

	-- local self.steps = self.steps or 5

	local spline = {}
	local count = #self.points - 1
	local p0, p1, p2, p3, x, y

	for i = 1, count do

		if i == 1 then
			p0, p1, p2, p3 = self.points[i], self.points[i], self.points[i + 1], self.points[i + 2]
		elseif i == count then
			p0, p1, p2, p3 = self.points[#self.points - 2], self.points[#self.points - 1], self.points[#self.points], self.points[#self.points]
		else
			p0, p1, p2, p3 = self.points[i - 1], self.points[i], self.points[i + 1], self.points[i + 2]
		end	

		for t = 0, 1, 1 / self.steps do

			x = 0.5 * ( ( 2 * p1.x ) + ( p2.x - p0.x ) * t + ( 2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x ) * t * t + ( 3 * p1.x - p0.x - 3 * p2.x + p3.x ) * t * t * t )
			y = 0.5 * ( ( 2 * p1.y ) + ( p2.y - p0.y ) * t + ( 2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y ) * t * t + ( 3 * p1.y - p0.y - 3 * p2.y + p3.y ) * t * t * t )

			--prevent duplicate entries
			if not(#spline > 0 and spline[#spline].x == x and spline[#spline].y == y) then
				table.insert( spline , { x = x , y = y } )				
			end	
			
		end

	end	

	--[[for i=#spline, 1, -1 do
		print(spline[i].x .. " " ..spline[i].y )
	end

	for i = 1, #self.points do
		local point = self.points[i]
		print (point.x .. " " .. point.y)
	end ]]--
	
	return spline

end

-----------------------------------------------------------
return catmullromspline
