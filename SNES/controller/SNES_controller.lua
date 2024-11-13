--[[
joypad.get() table definition: 
"P1 A": bool
"P1 B": bool
"P1 X": bool
"P1 Y": bool

"P1 L": bool
"P1 R": bool

"P1 Left":  bool
"P1 Right": bool
"P1 Up":    bool
"P1 Down":  bool

"P1 Select": bool
"P1 Start":  bool
]]

local SNES_Controller = {}
SNES_Controller.__index = SNES_Controller

function SNES_Controller:new(cell_size)
  local instance = setmetatable({}, { __index = SNES_Controller })
  
  instance.window = {
    cell_size = cell_size,
    width = cell_size * 16,
    height = cell_size * 7
  }
  
  instance.font_size = (math.floor(math.sqrt(cell_size)) -1) ^ 2 -- default is 12
  instance.directional_position = {
    X = cell_size * 2,
    Y = cell_size * 2.5
  }
  
  instance.start_select_position = {
    X = instance.directional_position.X + (cell_size * 3) + 5,
    Y = instance.directional_position.Y + (cell_size * 2)
  }
  
  instance.LR_position = {
    X = cell_size + 5,
    Y = cell_size
  }
  
  instance.ABXY_position = {
    X = instance.directional_position.X + (cell_size * 10),
    Y = instance.directional_position.Y
  }
  
  console.writeline("SNES_Controller has ben instantiated successfully!")
  console.writeline("Don't forget to call SNES_Controller:set_picture_box(offset, form_handler) to set the display!")
  console.writeline("")
  
  return instance
end

function SNES_Controller:print_joypad_strings()
  console.writeline(joypad.get())
end

function SNES_Controller:set_picture_box(offset, form_handler)
  self.offset = offset
  self.pic = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)
  self:_draw_rectangle(0, offset, self.window.width, self.window.height, nil, "lightgray")
end

function SNES_Controller:display_controller()
  forms.clear(self.pic, "white")
  local joypad = joypad.get()

  -- arrow directions
  self:_draw_direction(self.directional_position.X,                         self.directional_position.Y,                               joypad["P1 Up"])
  self:_draw_direction(self.directional_position.X - self.window.cell_size, self.directional_position.Y + self.window.cell_size,       joypad["P1 Left"])
  self:_draw_direction(self.directional_position.X + self.window.cell_size, self.directional_position.Y + self.window.cell_size,       joypad["P1 Right"])
  self:_draw_direction(self.directional_position.X,                         self.directional_position.Y + (self.window.cell_size * 2), joypad["P1 Down"])
  
  -- draw dimple in center of control pad
  forms.drawEllipse(self.pic, self.directional_position.X, self.directional_position.Y + self.window.cell_size, self.window.cell_size, self.window.cell_size, "black", "gray")
  
  -- Start/Select buttons
  self:_draw_start_select(self.start_select_position.X,                        self.start_select_position.Y, joypad["P1 Select"], "SELECT")
  self:_draw_start_select(self.start_select_position.X + (self.window.cell_size * 3), self.start_select_position.Y, joypad["P1 Start"],  "START")
  
  -- B/A buttons (gameboy has the "B" button to the left of the "A" button)
  self:_draw_ABXY(self.ABXY_position.X,                         self.ABXY_position.Y,                               "lightblue",   joypad["P1 X"], "X")
  self:_draw_ABXY(self.ABXY_position.X - self.window.cell_size, self.ABXY_position.Y + self.window.cell_size,       "lightgreen",  joypad["P1 Y"], "Y")
  self:_draw_ABXY(self.ABXY_position.X + self.window.cell_size, self.ABXY_position.Y + self.window.cell_size,       "#FF4848",     joypad["P1 A"], "A")
  self:_draw_ABXY(self.ABXY_position.X,                         self.ABXY_position.Y + (self.window.cell_size * 2), "#FFFF48",     joypad["P1 B"], "B")
  
  -- L
  self:_draw_string((self.LR_position.X - (self.window.cell_size / 5)) * 2.75, self.LR_position.Y - self.window.cell_size, "L", "black", "white", self.font_size)
  self:_draw_LR(self.LR_position.X,     self.LR_position.Y, joypad["P1 L"], "L")
  
  -- R
  self:_draw_string((self.LR_position.X * 8) - (self.window.cell_size / 5) + self.window.cell_size * 2, self.LR_position.Y - self.window.cell_size, "R", "black", "white", self.font_size)
  self:_draw_LR(self.LR_position.X * 8, self.LR_position.Y, joypad["P1 R"], "R")
  
  forms.refresh(self.pic)
end

function SNES_Controller:_draw_direction(x, y, pressed)
  local background = pressed and "black" or "white"
  
  self:_draw_rectangle(x, y, self.window.cell_size, self.window.cell_size, "black", background)
end

function SNES_Controller:_draw_start_select(x, y, pressed, message)
  local background = pressed and "black" or "white"
  
  self:_draw_string(x - (self.window.cell_size / 5), y - self.window.cell_size, message, "black", "white", self.font_size)
  self:_draw_rectangle(x, y, self.window.cell_size, self.window.cell_size / 2, "black", background)
end

function SNES_Controller:_draw_LR(x, y, pressed, message)
  local background = pressed and "lightgray" or "white"
  
  self:_draw_rectangle(x, y, self.window.cell_size * 4, self.window.cell_size / 2, "black", background)
end

function SNES_Controller:_draw_ABXY(x, y, color, pressed, message)
  local background = pressed and color or "white"
  
  self:_draw_rectangle(x, y, self.window.cell_size, self.window.cell_size, color, background)
  self:_draw_string(x + 5, y + 5, message, "black", background, self.font_size)
end

-- wrapper to draw a rectangle where the inputs are easier to read 
function SNES_Controller:_draw_rectangle(x, y, width, height, foreground, background)
  forms.drawRectangle(self.pic, x, y, width, height, foreground, background) 
end

-- wrapper to draw text where the inputs are easier to read
function SNES_Controller:_draw_string(x, y, message, foreground, background, font_size)
  forms.drawString(self.pic, x, y, message, foreground, background, font_size)
end

return SNES_Controller
