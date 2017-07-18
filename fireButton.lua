-----------------------------------------------------------
--
-- fireButton.lua
--
-----------------------------------------------------------

local fireButton = {}
local fireButton_mt = { __index = fireButton }	-- metatable

-- constructor
-----------------------------------------------------------
function fireButton.new(imagesheet, frame, scale)

	local newFireButton = {
		imagesheet = imagesheet,
		frame = frame,
		scale = scale or 1.0
	}
	return setmetatable( newFireButton, fireButton_mt )

end

-----------------------------------------------------------
-- create the firebutton
function fireButton:create(x, y, group)

	-- the image
	self.button = display.newImage(self.imagesheet, self.frame)
	
	self.button:scale(self.scale, self.scale)
	-- center the ship
	self.button.x = x
	self.button.y = y

	self.down = false

	--print (group)
	group:insert(self.button)

	-------------------------------------------------------
	function onTouch(event) 

		if(event.phase == "began") then

			display.getCurrentStage():setFocus(event.target)
			self.down = true
			
		elseif(event.phase == "ended" or event.phase == "cancelled") then

			display.getCurrentStage():setFocus(nil)
			self.down = false
		end

	end

	-------------------------------------------------------
	self.button:addEventListener("touch", onTouch)
	
end

-----------------------------------------------------------
return fireButton