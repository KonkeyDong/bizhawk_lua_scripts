local Controller = dofile("../controller/NES_controller.lua")
local Side_Panels = dofile("./side_panels.lua")

local cell_size = 30
local controller = Controller:new(cell_size)
local side_panels = Side_Panels:new()

local width = math.max(controller.window.width, side_panels.window.width)
local forms = forms.newform(width, controller.window.height + side_panels.window.height, "Side Panels")

controller:set_picture_box(0, forms)
side_panels:set_picture_box(controller.window.height + cell_size, forms)

local area

while true do
  -- area = memory.readbyte(0x006c)
  
  -- gui.drawText(10, 0, "Area ID: " .. area)
  
  controller:display_controller()
  side_panels:display_side_panel()
  
  emu.frameadvance()
end
