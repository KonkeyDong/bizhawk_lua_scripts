local addr = 0x003BFC
local holyDragonHP

while true do
	holyDragonHP = memory.read_u16_le(addr)
	gui.text(25, 25, "HP Remaining: " .. holyDragonHP)
	emu.frameadvance();
end