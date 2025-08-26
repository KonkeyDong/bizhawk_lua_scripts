
local Side_Panels = {}
Side_Panels.__index = Side_Panels

function Side_Panels:new()
  local instance = setmetatable({}, { __index = Side_Panels })
  
  instance.window = {
    cell_size = cell_size,
    width = 505,
    height = 923
  }
  
  instance.memory = {
    area = 0x006c
  }
  
  local leaf = ".\\images\\leaf_village_final.png"
  local valley_of_wind = ".\\images\\valley_of_wind_final.png"
  local caves = ".\\images\\caves_final.png"
  local windmill = ".\\images\\windmill_final.png"
  local sealed_cave = ".\\images\\sealed_cave_final.png"
  
  local cordel_plains = ".\\images\\cordel_plains_final.png"
  local dojo = ".\\images\\dojo_final.png"
  local brynmaer = ".\\images\\brynmaer_village_final.png"
  local poison_forest = ".\\images\\poison_forest_final.png"
  local oak = ".\\images\\oak_village_final.png"
  
  local mount_sabre = ".\\images\\mount_sabre_final.png"
  local nadare = ".\\images\\nadares_village_final.png"
  local prison = ".\\images\\prison_final.png"
  
  local portoa = ".\\images\\portoa_village_final.png"
  local portoa_castle = ".\\images\\portoa_castle_final.png"
  local angry_sea = ".\\images\\angry_sea_final.png"
  local waterfall_valley = ".\\images\\waterfall_valley_final.png"
  local kirisa = ".\\images\\kirisa_valley_final.png"
  local dock = ".\\images\\docks_final.png"
  local lookout_cabin = ".\\images\\lookout_cabin_final.png"
  local cryogenic_freezer = ".\\images\\cryogenic_freezer_final.png"
  
  local joel = ".\\images\\joel_village_final.png"
  local light_house = ".\\images\\light_house_final.png"
  local saberas_castle = ".\\images\\saberas_castle_final.png"
  local zombie_town = ".\\images\\zombie_town_final.png"
  
  local swan = ".\\images\\swan_village_final.png"
  local amazones = ".\\images\\amazones_village_final.png"
  
  local goa_fields = ".\\images\\goa_fields_final.png"
  local goa_town = ".\\images\\goa_village_final.png"
  local mount_hydra = ".\\images\\mount_hydra_final.png"
  local shyron_town = ".\\images\\shyron_village_final.png"
  local styx = ".\\images\\styx_final.png"
  local goa_fortress = ".\\images\\goa_fortress_final.png"
  local gate = ".\\images\\gate_final.png"
  local shyron_temple = ".\\images\\shyron_temple_final.png"
  
  local oasis_cave = ".\\images\\oasis_cave_final.png"
  local death_desert = ".\\images\\death_desert_final.png"
  local great_pyramid = ".\\images\\great_pyramid_final.png"
  local rabbit = ".\\images\\rabbit_field_final.png"
  local crystal_transporter = ".\\images\\crystal_transporter_final.png"
  local floating_tower = ".\\images\\floating_tower_final.png"
  local sahara = ".\\images\\sahara_village_final.png"
  local dyna = ".\\images\\dyna_final.png"
  
  instance.area_lookup = {
    -- Town of Leaf
    [0] = leaf, -- starting cave
    [1] = leaf, -- outside of cave
    [2] = leaf, -- main village
    [194] = leaf, -- inn
    [195] = leaf, -- item shop
    [196] = leaf, -- armor shop
    [193] = leaf, -- storage shed
    [192] = leaf, -- elder's house
    [197] = leaf, -- house
    
    -- valley of wind
    [3] = valley_of_wind, -- main area
    [16] = caves, -- Zebu's Cave (west in valley of wind)
    [14] = caves, -- sleeping man cave (state 1)
    [16] = caves, -- sleeping man cave (state 2)
    [15] = windmill, -- windmill
    
    -- Sealed Cave
    [4] = sealed_cave, -- entrance
    [5] = sealed_cave, -- bridge @ entrance
    [6] = sealed_cave, -- medical herb room
    [7] = sealed_cave, -- cross-portion of cave
    [8] = sealed_cave, -- warp boots room
    [9] = sealed_cave, -- south of vampire
    [10] = sealed_cave, -- vampire (boss)
    [12] = sealed_cave, -- exit
    
    -- Cordel Plains
    [20] = cordel_plains, -- main area (west)
    [21] = cordel_plains, -- main area (east)
    [25] = cordel_plains, -- outside Tornel's house
    [30] = dojo, -- tornel's house
    
    -- Town of Brynmaer
    [24] = brynmaer, -- main town
    [203] = brynmaer, -- item shop
    [201] = brynmaer, -- armor shop
    [200] = brynmaer, -- inn
    [199] = brynmaer, -- pawn shop
    [198] = brynmaer, -- pub
    
    --poison forest
    [26] = poison_forest,
    
    -- Town of Oak
    [28] = oak,
    [205] = oak,
    [207] = oak,
    [206] = oak,
    [208] = oak,
    
    -- mount sabre (west)
    [32] = mount_sabre, -- entrance
    [17] = caves, -- cave that leads to Zebu's cave
    [34] = caves, -- caves at base of mountain
    [35] = caves, -- caves from 34
    [33] = mount_sabre, -- northern part of mountain
    [36] = caves,
    [38] = caves,
    [39] = caves, -- cave to Tornado Bracelet
    
    -- mont sabre (north)
    [40] = mount_sabre, -- entrance
    [213] = nadare, -- mountain inn
    [61] = nadare, -- tool shop
    [60] = nadare, -- inn
    [62] = nadare, -- residence
    [56] = caves,
    [41] = mount_sabre,
    [42] = caves,
    [43] = caves,
    [44] = caves,
    [45] = caves,
    [46] = caves,
    [47] = caves,
    [48] = prison, -- west
    [49] = caves,
    [50] = prison, -- east
    [51] = caves,
    [52] = caves,
    [57] = caves,
    [53] = caves,
    
    -- waterfall valley
    [64] = waterfall_valley, -- main area
    [65] = waterfall_valley, -- south
    [66] = waterfall_valley, -- south-west
    [67] = cryogenic_freezer, -- cave
    [82] = cryogenic_freezer, -- chamber
    
    -- portoa town
    [220] = portoa, -- inn
    [80] = portoa, -- main area
    [218] = portoa, -- armor shop
    [221] = portoa, -- item shop
    [216] = portoa, -- fortune teller room
    [217] = portoa, -- pawn shop
    [81] = dock, -- dock to angry sea
    [214] = dock, -- dock house
    
    -- portoa castle
    [215] = portoa_castle, -- main castle
    [222] = portoa_castle, -- castle, left room
    [224] = portoa_castle, -- castle, right room
    [223] = portoa_castle, -- throne room
    [100] = caves, -- cave behind throne room
    [225] = caves, -- elder (queen) room in cave
    
    -- waterfall cave
    [84] = caves, -- entrance
    [85] = caves,
    [86] = caves,
    [87] = caves,
    
    -- kirisa valley cave
    [68] = caves,
    [69] = caves,
    [70] = caves,
    [71] = kirisa, -- flower valley
    
    -- east cave
    [72] = caves,
    [73] = caves,
    [74] = caves,
    [75] = caves,
    [76] = caves,
    [77] = caves,
    [78] = caves,
    [79] = caves,
    
    -- angry sea
    [96] = angry_sea,
    [97] = lookout_cabin,
    [98] = light_house,
    
    -- town of joel
    [113] = joel, -- main town
    [231] = joel, -- inn
    [229] = joel, -- item shop
    [228] = joel, -- shed
    [227] = joel, -- house next to shed
    
    -- evil spirit island
    [104] = caves,
    [105] = caves,
    [106] = caves,
    [107] = caves,
    
    -- zombie town
    [101] = zombie_town, -- main town
    
    -- Sabera's Castle
    [108] = saberas_castle,
    [109] = saberas_castle, -- north of vampire
    [110] = saberas_castle,
    
    -- swan
    [114] = swan, -- main town
    [241] = swan, -- house on right
    [240] = swan, -- pawn
    [239] = swan, -- pub
    [238] = swan, -- armor
    [237] = swan, -- inn
    [236] = swan, -- shed
    [235] = swan, -- item shop
    
    -- amazones
    [27] = amazones, -- main town
    [211] = amazones, -- armor
    [210] = amazones, -- item
    [209] = amazones,
    [212] = amazones,
    
    -- goa fields
    [115] = gate, -- west gate
    [120] = goa_fields, -- main fields
    
    -- goa town
    [142] = goa_town, -- main town
    [187] = goa_town, -- house
    [191] = goa_town, -- pub
    [188] = goa_town, -- inn
    [190] = goa_town, -- tool shop
    
    -- mount hydra
    [124] = mount_hydra,
    [126] = mount_hydra,
    [125] = caves,
    [127] = caves,
    [128] = caves,
    [134] = caves,
    [135] = caves,
    [129] = caves,
    [130] = caves,
    [131] = caves,
    [132] = caves,
    [133] = caves,
    
    -- shyron town
    [140] = shyron_town, -- main
    [247] = shyron_town, -- inn
    [245] = shyron_town, -- armor
    [246] = shyron_town, -- item
    [244] = shyron_town, -- house
    [243] = shyron_town, -- house
    [242] = shyron_temple,
    
    -- styx
    [136] = styx, -- entrance
    [137] = styx,
    [138] = styx,
    
    -- goa fortress
    [168] = goa_fortress,
    [169] = goa_fortress,
    [170] = goa_fortress,
    [171] = goa_fortress,
    [172] = goa_fortress,
    [173] = goa_fortress,
    [174] = goa_fortress,
    [175] = goa_fortress,
    [185] = goa_fortress,
    [176] = goa_fortress,
    [177] = goa_fortress,
    [180] = goa_fortress,
    [179] = goa_fortress,
    [178] = goa_fortress,
    [181] = goa_fortress,
    [182] = goa_fortress,
    [186] = goa_fortress,
    
    -- oasis cave
    [183] = oasis_cave,
    [184] = oasis_cave,
    [145] = oasis_cave,
    [143] = oasis_cave,
    
    -- death desert
    [144] = death_desert,
    [146] = caves,
    [149] = caves,
    [152] = death_desert,
    [150] = rabbit,
    
    -- town of sahara
    [147] = sahara, -- main town
    [250] = sahara, -- house
    [249] = sahara, -- tool shop
    [248] = sahara, -- inn
    [251] = sahara, -- pawn shop
    [148] = sahara, -- east of town
    
    -- great pyramid (front)
    [156] = great_pyramid, -- entrance
    [157] = great_pyramid,
    [158] = great_pyramid,
    [159] = great_pyramid,
    
    -- great pyramid (rear)
    [160] = great_pyramid, -- entrance
    [161] = great_pyramid,
    [162] = great_pyramid,
    [163] = great_pyramid,
    [164] = great_pyramid,
    [165] = great_pyramid,
    [166] = great_pyramid,
    
    -- crystal transporter
    [167] = crystal_transporter, -- from pyramid
    [88] = crystal_transporter, -- from floating fortress
    
    -- floating fortress
    [89] = floating_tower, -- entrance
    [90] = floating_tower,
    [91] = floating_tower,
    [92] = floating_tower,
    [94] = floating_tower, -- crystalis sword
    [93] = floating_tower, -- stairs
    
    -- dyna
    [95] = dyna
  }
  
  console.writeline("Side_Panels has ben instantiated successfully!")
  console.writeline("Don't forget to call Side_Panels:set_picture_box(offset, form_handler) to set the display!")
  console.writeline("")
  
  return instance
end

function Side_Panels:print_joypad_strings()
  console.writeline(joypad.get())
end

function Side_Panels:set_picture_box(offset, form_handler)
  self.offset = offset
  self.pic = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)
end

function Side_Panels:display_side_panel()
  forms.clear(self.pic, "white")
  
  local area = memory.readbyte(self.memory.area)
  local map = self.area_lookup[area]
  
  if (map) then
    forms.drawImage(self.pic, map, 0, 0)
  else
    forms.drawImage(self.pic, ".\\images\\default_final.png", 0, 0)
  end
  
  forms.refresh(self.pic)
end

return Side_Panels
