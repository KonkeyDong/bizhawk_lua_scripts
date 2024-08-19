local Map = dofile("map.lua")

-- The input should adjust based off of the button size.
-- It would behoove you to keep the value divisible by 25.
local BUTTON_SIZE = 25

local WINDOW = {
  WIDTH  = BUTTON_SIZE * 17,
  HEIGHT = BUTTON_SIZE * 18,
}

local map = Map:new(BUTTON_SIZE, WINDOW.WIDTH, WINDOW.HEIGHT, "Minimap")

while true do
  map:display_minimap()
  
  emu.frameadvance()
end
