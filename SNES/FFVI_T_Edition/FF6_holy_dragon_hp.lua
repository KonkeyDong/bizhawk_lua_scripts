local HPAddress   = 0x003BFC
local MPAddress = 0x003C10
local statusByte1 = 0x003E7C
local statusByte2 = 0x00327D

local regenBit  = 2   -- 0b00000010
local slowBit   = 4   -- 0b00000100
local hasteBit  = 8   -- 0b00001000
local shellBit  = 32  -- 0b00100000
local safeBit   = 64  -- 0b01000000
local floatBit  = 128 -- 0b10000000

local regenFlag = 0
local slowFlag  = 0
local hasteFlag = 0
local shellFlag = 0
local safeFlag  = 0
local floatFlag = 0

local monsterHP = 0
local statByte  = 0

function boolToString(flag)
	return tostring(flag > 0)
end

while true do
	monsterHP = memory.read_u16_le(HPAddress)
	monsterMP = memory.read_u16_le(MPAddress)
	
	statByte  = memory.read_s8(statusByte1)
	regenFlag = bit.band(statByte, regenBit)
	slowFlag  = bit.band(statByte, slowBit)
	hasteFlag = bit.band(statByte, hasteBit)
	shellFlag = bit.band(statByte, shellBit)
	safeFlag  = bit.band(statByte, safeBit)
	
	statByte  = memory.read_s8(statusByte2)
	floatFlag = bit.band(statByte, floatBit)
	
	gui.text(25, 25,  "HP Remaining: " .. monsterHP)
	gui.text(25, 50,  "MP Remaining: " .. monsterMP)
	gui.text(25, 75,  "Regen Flag  : " .. boolToString(regenFlag))
	gui.text(25, 100, "Slow Flag   : " .. boolToString(slowFlag))
	gui.text(25, 125, "Haste Flag  : " .. boolToString(hasteFlag))
	gui.text(25, 150, "Shell Flag  : " .. boolToString(shellFlag))
	gui.text(25, 175, "Safe Flag   : " .. boolToString(safeFlag))
	gui.text(25, 200, "Float Flag  : " .. boolToString(floatFlag))
		
	emu.frameadvance();
end
