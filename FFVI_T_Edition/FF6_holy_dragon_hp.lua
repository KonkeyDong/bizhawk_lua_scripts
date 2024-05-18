local addr        = 0x003BFC
local statusByte1 = 0x003E7C
local statusByte2 = 0x00327D

local regenBit  = 2   -- 0b00000010
local slowBit   = 4   -- 0b00000100
local shellBit  = 32  -- 0b00100000
local safeBit   = 64  -- 0b01000000
local floatBit  = 128 -- 0b10000000

local regenFlag = 0
local slowFlag  = 0
local shellFlag = 0
local safeFlag  = 0
local floatFlag = 0

local monsterHP = 0
local statByte  = 0

function boolToString(flag)
	return tostring(flag > 0)
end

while true do
	monsterHP = memory.read_u16_le(addr)
	
	statByte  = memory.read_s8(statusByte1)
	regenFlag = bit.band(statByte, regenBit)
	slowFlag  = bit.band(statByte, slowBit)
	shellFlag = bit.band(statByte, shellBit)
	safeFlag  = bit.band(statByte, safeBit)
	
	statByte  = memory.read_s8(statusByte2)
	floatFlag = bit.band(statByte, floatBit)
	
	gui.text(25, 25,  "HP Remaining: " .. monsterHP)
	gui.text(25, 50,  "Regen Flag  : " .. boolToString(regenFlag))
	gui.text(25, 75,  "Slow Flag   : " .. boolToString(slowFlag))
	gui.text(25, 100, "Shell Flag  : " .. boolToString(shellFlag))
	gui.text(25, 125, "Safe Flag   : " .. boolToString(safeFlag))
	gui.text(25, 150, "Float Flag  : " .. boolToString(floatFlag))
		
	emu.frameadvance();
end
