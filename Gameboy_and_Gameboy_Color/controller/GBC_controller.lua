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

local GBC_Controller = {}
GBC_Controller.__index = GBC_Controller

function GBC_Controller:new(cell_size)
  local instance = setmetatable({}, { __index = GBC_Controller })
  
  instance.window = {
    cell_size = cell_size,
    width = cell_size * 16,
    height = cell_size * 5
  }
  
  instance.font_size = (math.floor(math.sqrt(cell_size)) -1) ^ 2 -- default is 12
  instance.directional_position = {
    X = cell_size * 2,
    Y = cell_size
  }
  
  instance.start_select_position = {
    X = instance.directional_position.X + (cell_size * 3) + 5,
    Y = instance.directional_position.Y + (cell_size * 2)
  }
  
  instance.AB_position = {
    X = instance.start_select_position.X + (cell_size * 6),
    Y = instance.start_select_position.Y
  }
  
  console.writeline("GBC_controller has ben instantiated successfully!")
  console.writeline("Don't forget to call GBC_controller:set_picture_box(offset, form_handler) to set the display!")
  console.writeline("")
  
  return instance
end

function GBC_Controller:set_picture_box(offset, form_handler)
  self.offset = offset
  self.pic = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)
  forms.drawRectangle(self.pic, 0, offset, self.window.width, self.window.height, nil, "lightgray")
end

function GBC_Controller:display_controller()
  forms.clear(self.pic, "white")
  local joypad = joypad.get()

  -- arrow directions
  self:_draw_direction(self.directional_position.X,                  self.directional_position.Y,                        joypad["Up"])
  self:_draw_direction(self.directional_position.X - self.window.cell_size, self.directional_position.Y + self.window.cell_size,       joypad["Left"])
  self:_draw_direction(self.directional_position.X + self.window.cell_size, self.directional_position.Y + self.window.cell_size,       joypad["Right"])
  self:_draw_direction(self.directional_position.X,                  self.directional_position.Y + (self.window.cell_size * 2), joypad["Down"])
  
  -- draw dimple in center of control pad
  forms.drawEllipse(self.pic, self.directional_position.X, self.directional_position.Y + self.window.cell_size, self.window.cell_size, self.window.cell_size, "black", "gray")
  
  -- Start/Select buttons
  self:_draw_start_select(self.start_select_position.X,                        self.start_select_position.Y, joypad["Select"], "SELECT")
  self:_draw_start_select(self.start_select_position.X + (self.window.cell_size * 3), self.start_select_position.Y, joypad["Start"],  "START")
  
  -- B/A buttons (gameboy has the "B" button to the left of the "A" button)
  self:_draw_AB(self.AB_position.X,                        self.AB_position.Y,                  joypad["B"], "B")
  self:_draw_AB(self.AB_position.X + (self.window.cell_size * 2), self.AB_position.Y - self.window.cell_size, joypad["A"], "A")
  
  forms.refresh(self.pic)
end

function GBC_Controller:refresh()
  forms.refresh(self.pic)
end

function GBC_Controller:_draw_direction(x, y, pressed)
  local background = pressed and "black" or "white"
  
  forms.drawRectangle(self.pic, x, y, self.window.cell_size, self.window.cell_size, "black", background)
end

function GBC_Controller:_draw_start_select(x, y, pressed, message)
  local background = pressed and "black" or "white"
  
  forms.drawString(self.pic, x - (self.window.cell_size / 5), y - self.window.cell_size, message, "black", "white", self.font_size)
  forms.drawRectangle(self.pic, x, y, self.window.cell_size, self.window.cell_size / 2, "black", background)
end

function GBC_Controller:_draw_AB(x, y, pressed, message)
  local background = pressed and "purple" or "white"
  
  forms.drawString(self.pic, x + (self.window.cell_size / 5), y - self.window.cell_size, message, "black", "white", self.font_size)
  forms.drawRectangle(self.pic, x, y, self.window.cell_size, self.window.cell_size, "purple", background)
end

return GBC_Controller
