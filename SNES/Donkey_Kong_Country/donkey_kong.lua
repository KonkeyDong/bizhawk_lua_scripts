local DonkeyKong = {}
DonkeyKong.__index = DonkeyKong

function DonkeyKong:new(pic_handler, frame_delay)
  local self = setmetatable({}, { __index = DonkeyKong })
  self.frame_delay = frame_delay
  self.frame_delay_counter = self.frame_delay
  
  self.current_frame = 1
  self.frames = {}
  local path = ""
  for i = 1, 20 do
    path = ".\\sprites\\donkey\\donkey_running_" .. string.format("%02d", i) .. "_transparent.png"
    table.insert(self.frames, path)
  end
  
  return self
end

function DonkeyKong:next_frame()
  if self.frame_delay_counter == 0 then
    self.current_frame = self.current_frame + 1
    self.frame_delay_counter = self.frame_delay 
  end
  
  if self.current_frame > #self.frames then
    self.current_frame = 1
  end
  
  self.frame_delay_counter = self.frame_delay_counter - 1
  
  return self.frames[self.current_frame]
end

return DonkeyKong
