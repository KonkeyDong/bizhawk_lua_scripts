local DonkeyKong = dofile("./donkey_kong.lua")
local DiddyKong = dofile("./diddy_kong.lua")

local form = forms.newform(802, 794, "Donkey Kong Running")
local pic_handler = forms.pictureBox(form, 0, 0, 802, 794)
local frame_delay = 2

local donkey = DonkeyKong:new(pic_handler, frame_delay)
local diddy = DiddyKong:new(pic_handler, frame_delay)

local background = ".\\backgrounds\\jungle_hijinxs.png"
local LEFT_THRESHOLD = -300
local RIGHT_THRESHOLD = 1000
local SPEED = 10

local x = LEFT_THRESHOLD
while true do
  forms.clear(pic_handler, "white")
  forms.drawImage(pic_handler, background, 0, 0)
  forms.drawImage(pic_handler, diddy:next_frame(), x, 550)
  forms.drawImage(pic_handler, donkey:next_frame(), x + 190, 550)

  -- move the sprites from left-to-right
  x = x + SPEED
  if x > RIGHT_THRESHOLD then
    x = LEFT_THRESHOLD
  end

  forms.refresh(pic_handler)
  emu.frameadvance()
end
