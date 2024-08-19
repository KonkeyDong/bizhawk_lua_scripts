local Blinker = {}
Blinker.__index = Blinker

function Blinker:new(blink_delay) 
  local self = setmetatable({}, { __index = Blinker })
  
  self.count = 1
  self.blink_delay = blink_delay
  self.blink = false
  
  return self
end

function Blinker:is_ready_to_blink()
  return (self.count % self.blink_delay) == 0
end

function Blinker:increment()
  self.count = self.count + 1
end

-- toggles the state of the blinker between true and false;
-- resets the counter to 0.
function Blinker:flip()
  self.blink = not self.blink
  self.count = 0
end

return Blinker