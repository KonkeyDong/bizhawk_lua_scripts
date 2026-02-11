local Stats_Overlay = dofile("./stats_overlay.lua")

local stats = Stats_Overlay:new()

local form = forms.newform(stats.window.width, stats.window.height, "Mario Golf Stats")
stats:set_picture_box(0, form)

while true do
  stats:draw_overlay()

  emu.frameadvance()
end
