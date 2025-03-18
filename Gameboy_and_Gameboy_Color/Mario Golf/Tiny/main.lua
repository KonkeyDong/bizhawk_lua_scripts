local Tiny = dofile("./tiny.lua")

local form = forms.newform(390, 310, "Tiny Showing Off")
local pic_handler = forms.pictureBox(form, 0, 0, 390, 310)
local frame_delay = 6

local tiny = Tiny:new(pic_handler, frame_delay)

while true do
  forms.clear(pic_handler, "white")
  
  forms.drawImage(pic_handler, tiny:next_frame(), 0, 0)

  forms.refresh(pic_handler)
  emu.frameadvance()
end
