local Blinker = dofile("./blinker.lua")
local map_data = dofile("./map_data.lua")
local color_codes = dofile("./color_code.lua")

local Map = {}
Map.__index = Map

function Map:new(cell_size, display_axis)
  local instance = setmetatable({}, { __index = Map })
  
  instance.window = {
    cell_size = cell_size,
    width  = cell_size * 18,
    height = cell_size * 19
  }
  
  instance.font_size = (math.floor(math.sqrt(cell_size)) -1) ^ 2 -- default is 12

  instance.address = {
    world_map_position = 0xDB54,
    dungeon_position = 0xDBAE,
    location = 0xDB5F -- 0 = outdoors; 1 = indoors (dungeon, cave, house, etc.)
  }
  
  instance.color_codes = color_codes
  instance.cell_background_color = {
    [0] = instance.color_codes.empty,
    [1] = instance.color_codes.room,
    [2] = instance.color_codes.dungeon_entrance,
    [3] = instance.color_codes.instrument,
    [4] = instance.color_codes.link,
    [5] = instance.color_codes.boss,
    [6] = instance.color_codes.dungeon,
    [7] = instance.color_codes.water,
    [8] = instance.color_codes.forest,
    [9] = instance.color_codes.desert,
    [10] = instance.color_codes.graveyard
  }
  
  instance.map_data = map_data
  
  instance.display_axis = display_axis
  instance.axis_labels = {
    world_map = {},
    dungeon = {}
  }
  for i = 0, 15 do
    table.insert(instance.axis_labels.world_map, string.format("%X", i))
  end
  
  for i = 0, 7 do
    table.insert(instance.axis_labels.dungeon, string.format("%X", i))
  end
  
  -- blinker
  instance.blinker = Blinker:new(20)
  
  instance.pic = {
    grid = 0,
    x_axis = 0,
    y_axis = 0
  }
  
  console.writeline("Map has ben instantiated successfully!")
  console.writeline("Don't forget to call Map:set_picture_box(offset, form_handler) to set the display!")
  console.writeline("")
  
  return instance
end

function Map:set_picture_box(offset, form_handler)
  self.offset = offset
  
  -- outside
  self.pic.x_axis = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.cell_size)
  self:_draw_rectangle(self.pic.x_axis, 0, 0, self.window.width, self.window.cell_size * 2, nil, "lightgray")
  
  self.pic.y_axis = forms.pictureBox(form_handler, 0, offset, self.window.cell_size, self.window.height)
  self:_draw_rectangle(self.pic.y_axis, 0, 0, self.window.cell_size * 2, self.window.height, nil, "lightgray")
  
  self.pic.grid = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)
  self:_draw_rectangle(self.pic.grid, 0, 0, self.window.width, self.window.height, nil, "lightgray")
end

function Map:display_minimap()
  for _, v in pairs(self.pic) do
    forms.clear(v, "white")
  end
  
  if self.blinker:is_ready_to_blink() then
    self.blinker:flip()
  end

  self:_draw_axis_labels()
  self:_draw_grid()
  self:_draw_current_position()

  self.blinker:increment()
  
  for _, v in pairs(self.pic) do
    forms.refresh(v)
  end
end

function Map:_draw_grid()
  local background_color = ""
  local color_code = ""
    
  local maps = self:_get_current_map_layout()
  if not maps then
    return -- no map data found
  end
  
  local layout = maps.layout
    
  local dimension = self:_cell_size_dimension()
  for row = 1, #layout do
    for col = 1, #layout[row] do
      color_code = layout[row][col]
      background_color = self.cell_background_color[color_code]
      
      self:_draw_rectangle(self.pic.grid, dimension * col, dimension * row, dimension, dimension, "black", background_color)
    end
  end
end

function Map:_draw_current_position()
  local divisor_size = self:_is_outside() and 16 or 8
  local position = self:_get_links_current_position()
  
  local maps = self:_get_current_map_layout()
  if not maps then
    return
  end
  
  local layout = maps.layout
  local row = math.floor(position / divisor_size) + 1
  local col = (position % divisor_size) + 1
  local color_code = layout[row][col] -- Lua doesn't use zero-based indexing...
  local background = self.blinker.blink and self.color_codes.link or self.cell_background_color[color_code]

  local dimension = self:_cell_size_dimension()
  self:_draw_rectangle(self.pic.grid, dimension * (col), dimension * (row), dimension, dimension, "black", background)
end

function Map:_draw_axis_labels()
  local dimension = self:_cell_size_dimension()
  local scale_factor = self:_is_outside() and 1 or 2
  local text_offset = self:_is_outside() and 0 or (math.floor(self.window.cell_size / 2))
  local axis_labels = self:_is_outside() and self.axis_labels.world_map or self.axis_labels.dungeon
  
  for i, v in ipairs(axis_labels) do
    -- Y-Axis
    self:_draw_rectangle(self.pic.y_axis, 0, dimension * (i), dimension * scale_factor, dimension, "darkgray", "darkgray") 
    self:_draw_string(self.pic.y_axis, 0, dimension * (i) + text_offset, v, "black", "darkgray", 20)
    
    -- X-Axis
    self:_draw_rectangle(self.pic.x_axis, dimension * (i), 0, dimension, dimension * scale_factor, "darkgray", "darkgray")
    self:_draw_string(self.pic.x_axis, dimension * (i) + text_offset, 0, v, "black", "darkgray", 20)
  end
end

-- returns the position on the world map where Link is currently
-- located. By default, the value is decimal. Pass in a flag
-- to convert to a hex string.
function Map:_get_world_map_position(hex_flag)
  local data = memory.readbyte(self.address.world_map_position)
  
  if hex_flag then
    return string.format("%02X", data)
  end
  
  return data
end

function Map:_get_dungeon_position()
  return memory.readbyte(self.address.dungeon_position)
end

-- 0 = outside; 1 = inside
function Map:_is_outside()
  return self:_get_location() == 0
end

function Map:_get_location()
  return memory.readbyte(self.address.location)
end

function Map:_get_current_map_layout()
  local key = ""
  if self:_is_outside() then
    key = self.map_data.world_map
  else
  -- the dungeon layout key is based on the XY coordinates
  -- of where Link is currently located on the world map.
    key = self:_get_world_map_position(true)
  end
  
  return self.map_data[key]
end

function Map:_get_links_current_position()
  if self:_is_outside() then
    return self:_get_world_map_position()
  end
  
  return self:_get_dungeon_position()
end

function Map:_cell_size_dimension()
  if self:_is_outside() then
    return self.window.cell_size
  end
  
  return self.window.cell_size * 2
end

-- wrapper to draw a rectangle where the inputs are easier to read 
function Map:_draw_rectangle(pic_box_handler, x, y, width, height, foreground, background)
  forms.drawRectangle(pic_box_handler, x, y, width, height, foreground, background) 
end

-- wrapper to draw text where the inputs are easier to read
function Map:_draw_string(pic_box_handler, x, y, message, foreground, background, font_size)
  forms.drawString(pic_box_handler, x, y, message, foreground, background, font_size)
end

return Map
