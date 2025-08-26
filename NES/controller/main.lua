local Controller = dofile("./NES_controller.lua")

local cell_size = 25

local controller = Controller:new(cell_size)

local form = forms.newform(controller.window.width, controller.window.height, "NES Controller")
controller:set_picture_box(0, form)

while true do
  controller:display_controller()
  
  emu.frameadvance()
end
