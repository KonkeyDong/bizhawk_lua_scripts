local BananaBunch = {}
BananaBunch.__index = BananaBunch

function BananaBunch:new(pic_handler, frame_delay)
  local self = setmetatable({}, { __index = BananaBunch })
  self.frame_delay = frame_delay
  self.frame_delay_counter = self.frame_delay
  
  self.number_multiplier = 1
  self.current_frame = 1
  self.frames = {}
  local path = ""
  for i = 1, 6 do
    path = ".\\sprites\\banana bunches\\banana_bunch_" .. string.format("%02d", i) .. "_transparent.png"
    table.insert(self.frames, path)
  end
  
  for i = 6, 1, -1 do
    path = ".\\sprites\\banana bunches\\banana_bunch_" .. string.format("%02d", i) .. "_transparent.png"
    table.insert(self.frames, path)
  end
  
  return self
end

function BananaBunch:next_frame()
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

return BananaBunch
