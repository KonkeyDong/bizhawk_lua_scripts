local Map = dofile("./map.lua")
local Controller = dofile("../../controller/GBC_controller.lua")

-- -- The input should adjust based off of the button size.
-- -- It would behoove you to keep the value divisible by 25.
local cell_size = 25

local map = Map:new(cell_size, false)
local controller = Controller:new(cell_size)

local width = math.max(controller.window.width, map.window.width)
local form = forms.newform(width, controller.window.height + map.window.height, "Zelda LADX")
controller:set_picture_box(0, form)
map:set_picture_box(controller.window.height + cell_size, form)

while true do
  map:display_minimap()
  controller:display_controller()
  
  emu.frameadvance()
end
