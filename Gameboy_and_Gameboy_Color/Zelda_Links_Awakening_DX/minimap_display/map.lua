local Blinker = require("blinker")
local layout = require("layout")

local Map = {}
Map.__index = Map

function Map:new(cell_size)
  local instance = setmetatable({}, { __index = Map })
  
  instance.window = {
    cell_size = cell_size,
    width  = cell_size * 16,
    height = cell_size * 17
  }
  
  instance.address = {
    world_map_position = 0xDB54,
    dungeon_position = 0xDBAE,
    location = 0xDB5F -- 0 = outdoors; 1 = indoors (dungeon, cave, house, etc.)
  }
  
  instance.layout = layout
  
  instance.cell_background_color = {
    [0] = instance.layout.color_code.empty,
    [1] = instance.layout.color_code.room,
    [2] = instance.layout.color_code.dungeon_entrance,
    [3] = instance.layout.color_code.instrument,
    [4] = instance.layout.color_code.link,
    [5] = instance.layout.color_code.boss,
    [6] = instance.layout.color_code.dungeon,
    [7] = instance.layout.color_code.water,
    [8] = instance.layout.color_code.forest,
    [9] = instance.layout.color_code.desert,
    [10] = instance.layout.color_code.graveyard
  }
  
  -- blinker
  instance.blinker = Blinker:new(20)
  
  console.writeline("Map has ben instantiated successfully!")
  console.writeline("Don't forget to call Map:set_picture_box(offset, form_handler) to set the display!")
  console.writeline("")
  
  return instance
end

function Map:set_picture_box(offset, form_handler)
  self.offset = offset
  self.pic = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)
  forms.drawRectangle(self.pic, 0, offset, self.window.width, self.window.height, nil, "lightgray")
end

function Map:display_minimap()
  forms.clear(self.pic, "white")
  
  if self.blinker:is_ready_to_blink() then
    self.blinker:flip()
  end

  self:_draw_grid()
  self:_draw_current_position()

  self.blinker:increment()
  
  forms.refresh(self.pic)
end

function Map:_draw_grid()
  local background_color = ""
  local color_code = ""
    
  local map = self:_get_current_map_layout()
  if not map then
    return -- no map data found
  end
  
  for row = 1, #map do
    for col = 1, #map[row] do
      color_code = map[row][col]
      background_color = self.cell_background_color[color_code]
      
      forms.drawRectangle(self.pic, self:_cell_size_dimension() * (col - 1), self:_cell_size_dimension() * (row - 1), self:_cell_size_dimension(), self:_cell_size_dimension(), "black", background_color)
    end
  end
end

function Map:_draw_current_position()
  local divisor_size = self:_is_outside() and 16 or 8
  local position = self:_get_links_current_position()
  
  local map = self:_get_current_map_layout()
  if not map then
    return
  end
  
  local row = math.floor(position / divisor_size)
  local col = position % divisor_size
  local color_code = map[row + 1][col + 1] -- Lua doesn't use zero-based indexing...
  local background = self.blinker.blink and self.layout.color_code.link or self.cell_background_color[color_code]

  forms.drawRectangle(self.pic, self:_cell_size_dimension() * col, self:_cell_size_dimension() * row, self:_cell_size_dimension(), self:_cell_size_dimension(), "black", background)
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
    key = self.layout.world_map
  else
  -- the dungeon layout key is based on the XY coordinates
  -- on the world map.
    key = self:_get_world_map_position(true)
  end
  
  return self.layout[key]
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

return Map
