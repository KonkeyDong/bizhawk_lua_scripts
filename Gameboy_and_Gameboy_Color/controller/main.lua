local Controller = dofile("./GBC_controller.lua")

-- The input should adjust based off of the button size.
-- It would behoove you to keep the value divisible by 25.
local cell_size = 25

local controller = Controller:new(cell_size)

local form = forms.newform(controller.window.width, controller.window.height, "Gameboy Controller")
controller:set_picture_box(0, form)

while true do
  controller:display_controller()
 
  emu.frameadvance()
end
