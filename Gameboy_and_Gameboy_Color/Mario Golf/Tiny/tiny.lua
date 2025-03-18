local Tiny = {}
Tiny.__index = Tiny

function Tiny:new(pic_handler, frame_delay)
  local self = setmetatable({}, { __index = Tiny })
  self.frame_delay = frame_delay
  self.frame_delay_counter = self.frame_delay
  
  self.current_frame = 1
  self.animation_frames = {}
  local path = ""
  for i = 1, 4 do
    path = ".\\sprites\\birdy\\birdy_" .. string.format("%02d", i) .. "_5x.png"
    table.insert(self.animation_frames, path)
  end
  
  self.frames = {
    self.animation_frames[1],
    self.animation_frames[2],
    self.animation_frames[3],
    self.animation_frames[4],
    self.animation_frames[3],
    self.animation_frames[4],
    self.animation_frames[3],
    self.animation_frames[4],
    self.animation_frames[3],
    self.animation_frames[2],
    self.animation_frames[1],
  }
  
  return self
end

function Tiny:next_frame()
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

return Tiny
