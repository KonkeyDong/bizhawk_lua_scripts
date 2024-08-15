-- The input should adjust based off of the button size.
-- It would behoove you to keep the value divisible by 25.
local BUTTON_SIZE = 25

local WINDOW = {
  WIDTH  = BUTTON_SIZE * 16,
  HEIGHT = BUTTON_SIZE * 17,
}

local myForm = forms.newform(WINDOW.WIDTH, WINDOW.HEIGHT, "Gameboy Controller Input Display")
local pic = forms.pictureBox(myForm, 0, 0, WINDOW.WIDTH, WINDOW.HEIGHT)
forms.drawRectangle(pic, 0, 0, WINDOW.WIDTH, WINDOW.HEIGHT, nil, "lightgray")
forms.clear(pic, "lightgray")

local FRAME = {
  count = 1,
  blink_delay = 20,
  toggle = false,
  
  toggle_frame_delay = function(self)
    return (self.count % self.blink_delay) == 0
  end,
  
  increment = function(self)
    self.count = self.count + 1
  end,
  
  flip_toggle = function(self)
    self.toggle = not self.toggle
    self.count = 0
  end,
}

local BACKGROUND_COLOR_MAP = {
  
  [0] = "black",
  [1] = "white",
  [2] = "green"
}

local MAPS = {
  
  -- level 2: bottle grotto
  L2 = {
    { 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 1, 1, 1, 1, 1, 1, 0 },
    { 0, 0, 1, 0, 0, 1, 0, 0 },
    { 0, 1, 1, 1, 1, 1, 1, 0 },
    { 0, 1, 0, 1, 1, 0, 1, 0 },
    { 0, 1, 0, 1, 1, 0, 1, 0 },
    { 0, 1, 1, 1, 1, 1, 1, 0 },
    { 0, 0, 2, 1, 1, 1, 0, 0 }
  }
}

function drawPosition()
  if FRAME:toggle_frame_delay() then
    FRAME:flip_toggle()
  end
  
  local dungeon_position = memory.read_s8(0xDBAE) - 1 -- dungeons are 8x8 grids

  local row = math.floor(dungeon_position / 8) + 1
  local col = (dungeon_position % 8) + 1
  local background = FRAME.toggle and "yellow" or "white"
  
  forms.drawRectangle(pic, BUTTON_SIZE * col, BUTTON_SIZE * row, BUTTON_SIZE, BUTTON_SIZE, "black", background)
end

function drawGrid()
  local background = ""
  local color_code = 0
  for row = 1, 8 do
    for col = 1, 8 do 
      color_code = MAPS.L2[row][col]
      background = BACKGROUND_COLOR_MAP[color_code]
    
      forms.drawRectangle(pic, BUTTON_SIZE * (col - 1), BUTTON_SIZE * (row), BUTTON_SIZE, BUTTON_SIZE, "black", background)
    end
  end
end

function displayMinimap()
  drawGrid()
  drawPosition()
  
  forms.refresh(pic)
end

while true do
  displayMinimap()
  
  FRAME:increment()
  
  emu.frameadvance()
end
