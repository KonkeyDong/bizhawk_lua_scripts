local Controller = dofile("./Sega_Genesis_Controller.lua")

local cell_size = 25

local controller = Controller:new(cell_size)

local form = forms.newform(controller.window.width, controller.window.height, "Sega Genesis Controller")
controller:set_picture_box(0, form)

while true do
  controller:display_controller()

  emu.frameadvance()
end
