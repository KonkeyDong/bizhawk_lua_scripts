local form = forms.newform(400, 400, "Donkey Kong Running")
local pic = forms.pictureBox(form, 0, 0, 400, 400)

frames = {}
local path = ""
for i = 1, 13 do
  path = "D:\\Donkey Kong Country\\sprites\\diddy\\diddy_running_" .. string.format("%02d", i) .. "_transparent.png"
  table.insert(frames, path)
end

local index = 1
local flipper = false
while true do
  if flipper then
    forms.clear(pic, "lightgreen")
    forms.drawImage(pic, frames[index], 10, 10)
  
    index = index + 1
    if index > 13 then
      index = 1
    end
    
    forms.refresh(pic)
  end
  
  flipper = not flipper
  emu.frameadvance()
end
