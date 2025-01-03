local DonkeyKong = dofile("./donkey_kong.lua")
local DiddyKong = dofile("./diddy_kong.lua")
local BananaBunch = dofile("./banana_bunch.lua")
local Controller = dofile("../controller/SNES_controller.lua")

local cell_size = 25
local controller = Controller:new(cell_size)

-- local form = forms.newform(500, 500, "")
local form = forms.newform(802, 794 + controller.window.height, "Donkey Kong Country 3")
controller:set_picture_box(0, form)
local title_background_pic_handler = forms.pictureBox(form, 401, 0, 402, 175)
local pic_handler = forms.pictureBox(form, 0, controller.window.height, 802, 794)
local frame_delay = 2

local donkey = DonkeyKong:new(pic_handler, frame_delay)
local diddy = DiddyKong:new(pic_handler, frame_delay)
local banana_bunch = BananaBunch:new(pic_handler, 6)

local background = ".\\backgrounds\\jungle_hijinxs.png"
local title_background = ".\\backgrounds\\title_screen.png"

local LEFT_THRESHOLD = -550
local RIGHT_THRESHOLD = 1000
local SPEED = 10

local x = LEFT_THRESHOLD
while true do
  forms.clear(pic_handler, "white")
  
  forms.drawImage(title_background_pic_handler, title_background, 0, 0)
  forms.drawImage(pic_handler, background, 0, 0)
  
  controller:display_controller()
  
  forms.drawImage(pic_handler, diddy:next_frame(), x, 550)
  forms.drawImage(pic_handler, donkey:next_frame(), x + 190, 550)
  forms.drawImage(pic_handler, banana_bunch:next_frame(), x + 500, 550)

  -- move the sprites from left-to-right
  x = x + SPEED
  if x > RIGHT_THRESHOLD then
    x = LEFT_THRESHOLD
  end

  forms.refresh(pic_handler)
  emu.frameadvance()
end
