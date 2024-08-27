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
    height = cell_size * 20
  }
  
  instance.font_size = (math.floor(math.sqrt(cell_size)) -1) ^ 2 -- default is 12

  instance.address = {
    world_map_position = 0xDB54,
    dungeon_position = 0xDBAE,
    location = 0xDB5F -- 0 = outdoors; 1 = indoors (dungeon, cave, house, etc.)
  }
  
  instance.color_codes = color_codes
  instance.cell_background_color = {
    [-1] = instance.color_codes.no_value,
    [0] = instance.color_codes.empty,
    [1] = instance.color_codes.room,
    [2] = instance.color_codes.dungeon_entrance,
    [3] = instance.color_codes.instrument,
    [4] = instance.color_codes.link,
    [5] = instance.color_codes.boss,
    [6] = instance.color_codes.dungeon_entrance_outdoors,
    [7] = instance.color_codes.link_green,
    [8] = instance.color_codes.link_skin
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
    grid = 0
  }
  
  -- full path to file. on windows, it might be:
  -- "C:\\Users\\Larry\\path\\to\\world_map_gbc_no_grid.png"
  instance.image_path = "C:\\path\\to\\world_map_gbc_no_grid.png"
  
  console.writeline("Map has ben instantiated successfully!")
  console.writeline("Don't forget to call Map:set_picture_box(offset, form_handler) to set the display!")
  console.writeline("")
  
  return instance
end

function Map:set_picture_box(offset, form_handler)
  local cell_size = self.window.cell_size
  self.pic.grid = forms.pictureBox(form_handler, 0, offset, self.window.width + cell_size, self.window.height + (cell_size))
  forms.drawRectangle(self.pic.grid, 0, 0, self.window.width, self.window.height, nil, "lightgray")
  
  self:_draw_map()
end

function Map:display_minimap() 
  if self.blinker:is_ready_to_blink() then
    self.blinker:flip()
  end
  
  self:_draw_map()

  self.blinker:increment()
end

function Map:_draw_map()
  forms.clear(self.pic.grid, "white")

  self:_draw_map_title(0)
  local offset = self.window.cell_size
  
  local maps = self:_get_current_map_layout()
  if not maps then
    self:_draw_link_sprite(offset)
  else
    self:_draw_axis_labels(offset)
    self:_draw_grid(offset)
    self:_draw_current_position(offset)
  end
  
  forms.refresh(self.pic.grid)
end

function Map:_draw_map_title(offset)
  local maps = self:_get_current_map_layout()
  if not maps then
    forms.drawString(self.pic.grid, 0, 0, "Caves / Indoors", "black", "white", 20)
    return
  end
  
  local title = maps.title

  forms.drawString(self.pic.grid, 0, 0, title, "black", "white", 20)
end

function Map:_draw_link_sprite(offset)
  local maps = self:_get_link_sprite()
  local layout = maps.layout
  local dimension = self.window.cell_size
  
  for row = 1, #layout do
    for col = 1, #layout[row] do
      color_code = layout[row][col]
      background_color = self.cell_background_color[color_code]
      
      forms.drawRectangle(self.pic.grid, dimension * col, offset + (dimension * row), dimension, dimension, "none", background_color)
    end
  end
end

function Map:_draw_grid(offset)
  local background_color = ""
  local color_code = ""
    
  local maps = self:_get_current_map_layout()
  if not maps then
    return -- no map data found
  end
  
  local layout = maps.layout
  
  local dimension = self:_cell_size_dimension()
  
  if self:_is_outside() then
    forms.drawImage(self.pic.grid, self.image_path, dimension, offset + dimension)
  end
  
  for row = 1, #layout do
    for col = 1, #layout[row] do
      color_code = layout[row][col]
      background_color = self.cell_background_color[color_code]
      
      forms.drawRectangle(self.pic.grid, dimension * col, offset + (dimension * row), dimension, dimension, self.color_codes.line, background_color)
    end
  end
end

function Map:_draw_current_position(offset)
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
  forms.drawRectangle(self.pic.grid, dimension * (col), offset + (dimension * row), dimension, dimension, self.color_codes.line, background)
end

function Map:_draw_axis_labels(offset)
  local dimension = self:_cell_size_dimension()
  local scale_factor = self:_get_scale_factor()
  local axis_labels = self:_is_outside() and self.axis_labels.world_map or self.axis_labels.dungeon
  
  -- draw top-left square
  forms.drawRectangle(self.pic.grid, 0, offset, dimension * scale_factor, dimension * scale_factor, self.color_codes.axis, self.color_codes.axis)
  
  for i, v in ipairs(axis_labels) do
    -- Y-Axis
    forms.drawRectangle(self.pic.grid, 0, offset + (dimension * i), dimension, dimension * scale_factor,self.color_codes.axis, self.color_codes.axis) 
    forms.drawString(self.pic.grid, 0, offset + (dimension * i), v, self.color_codes.line, self.color_codes.axis, 20 * scale_factor)
    
    -- X-Axis
    forms.drawRectangle(self.pic.grid, (dimension * i), offset, dimension * scale_factor, dimension, self.color_codes.axis, self.color_codes.axis)
    forms.drawString(self.pic.grid, (dimension * i), offset, v, self.color_codes.line, self.color_codes.axis, 20 * scale_factor)
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

function Map:_get_link_sprite()
  local sprite = self.blinker.blink and self.map_data.link_walking_01 or self.map_data.link_walking_02
  
  return self.map_data[sprite]
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

function Map:_get_scale_factor()
  if self:_is_outside() then
    return 1
  end
  
  return 2
end

return Map
