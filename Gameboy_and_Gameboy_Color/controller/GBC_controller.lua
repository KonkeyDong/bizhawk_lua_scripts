--[[
joypad.get() table definition: 
  "A":      bool
  "B":      bool
  "Down":   bool
  "Left":   bool
  "Power":  bool
  "Right":  bool
  "Select": bool
  "Start":  bool
  "Up":     bool
]]

-- The input should adjust based off of the button size.
-- It would behoove you to keep the value divisible by 25.
local BUTTON_SIZE = 25
local FONT_SIZE = (math.floor(math.sqrt(BUTTON_SIZE)) -1) ^ 2 -- default is 12
local DIRECTION_BASE = {
  X = BUTTON_SIZE * 2,
  Y = BUTTON_SIZE
}

local START_SELECT_BASE = {
  X = DIRECTION_BASE.X + (BUTTON_SIZE * 3) + 5,
  Y = DIRECTION_BASE.Y + (BUTTON_SIZE * 2)
}

local AB_BASE = {
  X = START_SELECT_BASE.X + (BUTTON_SIZE * 6),
  Y = START_SELECT_BASE.Y
}

local WINDOW = {
  WIDTH = BUTTON_SIZE * 16,
  HEIGHT = BUTTON_SIZE * 7,
}

local myForm = forms.newform(WINDOW.WIDTH, WINDOW.HEIGHT, "Gameboy Controller Input Display")
local pic = forms.pictureBox(myForm, 0, 0, WINDOW.WIDTH, WINDOW.HEIGHT)
forms.drawRectangle(pic, 0, 0, WINDOW.WIDTH, WINDOW.HEIGHT, nil, "lightgray")

function drawAB(x, y, pressed, message)
  local background = pressed and "purple" or "white"
  
  forms.drawString(pic, x + (BUTTON_SIZE / 5), y - BUTTON_SIZE, message, "black", "white", FONT_SIZE)
  forms.drawRectangle(pic, x, y, BUTTON_SIZE, BUTTON_SIZE, "purple", background)
end

function drawDirection(x, y, pressed)
  local background = pressed and "black" or "white"
  
  forms.drawRectangle(pic, x, y, BUTTON_SIZE, BUTTON_SIZE, "black", background)
end

function drawStartSelect(x, y, pressed, message)
  local background = pressed and "black" or "white"
  
  forms.drawString(pic, x - (BUTTON_SIZE / 5), y - BUTTON_SIZE, message, "black", "white", FONT_SIZE)
  forms.drawRectangle(pic, x, y, BUTTON_SIZE, BUTTON_SIZE / 2, "black", background)
end

function displayController()
  local joypad = joypad.get()

  -- arrow directions
  drawDirection(DIRECTION_BASE.X,               DIRECTION_BASE.Y,                     joypad["Up"])
  drawDirection(DIRECTION_BASE.X - BUTTON_SIZE, DIRECTION_BASE.Y + BUTTON_SIZE,       joypad["Left"])
  drawDirection(DIRECTION_BASE.X + BUTTON_SIZE, DIRECTION_BASE.Y + BUTTON_SIZE,       joypad["Right"])
  drawDirection(DIRECTION_BASE.X,               DIRECTION_BASE.Y + (BUTTON_SIZE * 2), joypad["Down"])
  
  -- draw dimple in center of control pad
  forms.drawEllipse(pic, DIRECTION_BASE.X, DIRECTION_BASE.Y + BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE, "black", "gray")
  
  -- Start/Select buttons
  drawStartSelect(START_SELECT_BASE.X,                     START_SELECT_BASE.Y, joypad["Select"], "SELECT")
  drawStartSelect(START_SELECT_BASE.X + (BUTTON_SIZE * 3), START_SELECT_BASE.Y, joypad["Start"],  "START")
  
  -- B/A buttons (gameboy has the "B" button to the left of the "A" button)
  drawAB(AB_BASE.X,                     AB_BASE.Y,               joypad["B"], "B")
  drawAB(AB_BASE.X + (BUTTON_SIZE * 2), AB_BASE.Y - BUTTON_SIZE, joypad["A"], "A")
  
  forms.refresh(pic)
end

while true do
  displayController()  

  emu.frameadvance()
end
