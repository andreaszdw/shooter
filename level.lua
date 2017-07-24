-----------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------

local level = {}
local level_mt = { __index = level }    -- metatable

-- constructor
-----------------------------------------------------------
function level.new()

    local newLevel = {
        name = "",
        foes = {},
        endboss = "",
        speed = 1
    }
    return setmetatable(newLevel, level_mt)
end

-----------------------------------------------------------
-- load level
function level:load(file)
end

-----------------------------------------------------------
return level