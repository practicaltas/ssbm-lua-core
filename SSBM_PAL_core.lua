local core = {}

local function safeReadValueFloat(intVal)
  return string.unpack("f", string.pack("I4", ReadValue32(intVal)))
end
core.safeReadValueFloat = safeReadValueFloat

--[[ not needed
local function getSceneID()
	return ReadValue32(0x80407EB0) -- other id: 0x80407EB4
end
core.getSceneID = getSceneID
]]--
local function getSceneController()
	base = 0x8046AB38
	return {currMaj = ReadValue8(base), pendMaj = ReadValue8(base + 1), prevMaj = ReadValue8(base + 2), currMin = ReadValue8(base + 3)}
end
core.getSceneController = getSceneController

 -- only really reliably resets to 2
 -- first actionable frame on game start is 84
local function getSceneFrameCount()
	return ReadValue32(0x8046AB60) -- other count: 0x8046AB68
end
core.getSceneFrameCount = getSceneFrameCount

local function getRngSeed()
	return ReadValue32(0x804C71B8)
end
core.getRngSeed = getRngSeed

local function setRngSeed(seed)
	WriteValue32(0x804C71B8, seed)
end
core.setRngSeed = setRngSeed

local function getCharacterSelectID()
	return ReadValue8(0x803F1C77) -- other id: 0x803F1C76 (doesn't switch to 0x19 for no selection)
end
core.getCharacterSelectID = getCharacterSelectID

local function getStageID()
	return ReadValue8(0x804C5A8B) -- other ids: 0x80422E2B, 0x80422E7F, 0x8045E97F
end
core.getStageID = getStageID

local function getP1Pos()
	base = 0x80443E30
	local pos = {exists = true, X = safeReadValueFloat(base), Y = safeReadValueFloat(base + 4)}
	return pos
end
core.getP1Pos = getP1Pos

local function getP2Pos()
	base = 0x80444CD0
	local pos = {exists = true, X = safeReadValueFloat(base), Y = safeReadValueFloat(base + 4)}
	return pos
end
core.getP2Pos = getP2Pos

--[[
P1 Character Select: maj 0x02, min 0x00
X = 0x8113D998 -- other values: D9B0, DA50, DAF0, (actual but delayed 1f) E70C, (weird) DF10
Y = 0x8113D99C -- other values: D9C0, DA60, DB00, (actual but delayed 1f) E710, (weird) DF20

P1 selected: 0x8113E7DA

1P Regular: maj 0x03-0x05, min 0x70; 1P Event: maj 0x2e, min 0x00
X = 0x811218B8 -- 18D0, 1970, 1EF0, (actual but delayed 1f) 2C0C, (weird) 1F90, 8004993BC
Y = 0x811218BC -- 18E0, 1980, 1F00, (actual but delayed 1f) 2C10, (weird) 1FA0, 8004993CC

1P Stadium: maj 0x0F, 0x23-0x29, min 0x00
X = 0x81122CB8 -- 2CD0, 2D70, 2E10, (actual but delayed 1f) 2A8C, (weird) 2EB0, 8004993BC
Y = 0x81122CBC -- 2CE0, 2D80, 2E20, (actual but delayed 1f) 3A90, (weird) 2EC0, 8004993CC

Character selected: 0x804C800F

Cursor base position: -31, -21.5
Movement per frame: 1.24

X-breaks: -32.7, -27.1, -20.1, -13.1, -6.1, 0.9, 7.9, 14.9, 21.7, can't reach so effectively 26
Y-breaks: 1, 8, 15 22

Selection zone: 0.2 <= Y <= 22

if current character selected:
	Start
	End script
if in character zone:
	if other character selected:
		B
	else:
		A
else:
	if in horizontal zone:
		go up or down
	if in vertical zone:
		go left or right
	if in neither zone:
		find nearest corner
		find vert/horiz distance to corner
		set farther to 127, closer to proprortion
	if other character selected and in selection zone:
		B
]]--
local function getCSSPos()
	local pos = {exists = false, X = nil, Y = nil, selected = nil}
	local con = getSceneController()
	if con.currMaj == 0x02 and con.currMin == 0x00 then
		pos.exists = true
		pos.X = safeReadValueFloat(0x8113D998)
		pos.Y = safeReadValueFloat(0x8113D99C)
		pos.selected = ReadValue8(0x8113E7DA)
	elseif (con.currMaj >= 0x03 and con.currMaj <= 0x05 and con.currMin == 0x70) or (con.currMaj == 0x2E and con.currMin == 0x00) then
		pos.exists = true
		pos.X = safeReadValueFloat(0x811218B8)
		pos.Y = safeReadValueFloat(0x811218BC)
		pos.selected = ReadValue8(0x804C800F)
	elseif (con.currMaj == 0x0F or (con.currMaj >= 0x23 and con.currMaj <= 0x29)) and con.currMin == 0x00 then
		pos.exists = true
		pos.X = safeReadValueFloat(0x81122CB8)
		pos.Y = safeReadValueFloat(0x81122CBC)
		if math.abs(pos.X - -0.000001) < 0.000001 and math.abs(pos.Y - 19.999998) < 0.000001 then
			pos.X = safeReadValueFloat(0x81135138)
			pos.Y = safeReadValueFloat(0x8113513C)
		end
		pos.selected = ReadValue8(0x804C800F)
	else
		pos = {exists = false, X = nil, Y = nil, selected = nil}
	end
	return pos
end
core.getCSSPos = getCSSPos

local function targetsRemaining()
	local con = getSceneController()
	local targets = {exists = false, remaining = nil}
	if con.currMaj == 0x0F and con.currMin == 0x01 then
		targets.exists = true
		targets.remaining = ReadValue8(0x80491D2B)
	end
	return targets
end
core.targetsRemaining = targetsRemaining

local function getScreenText()
	text = ""
	--text = text .. string.format("Scene ID: 0x%08x\n", core.getSceneID())
	text = text .. string.format("Current Major Scene: 0x%02x\n", core.getSceneController().currMaj)
	text = text .. string.format("Pending Major Scene: 0x%02x\n", core.getSceneController().pendMaj)
	text = text .. string.format("Previous Major Scene: 0x%02x\n", core.getSceneController().prevMaj)
	text = text .. string.format("Current Minor Scene: 0x%02x\n", core.getSceneController().currMin)
	text = text .. string.format("Scene Frame Count: %d\n", core.getSceneFrameCount())
	text = text .. string.format("Input Frame Count: %d\n", GetInputFrameCount())
	text = text .. string.format("RNG Seed: 0x%08x\n", core.getRngSeed())
	text = text .. string.format("Character Select ID: 0x%02x\n", core.getCharacterSelectID())
	text = text .. string.format("Stage ID: 0x%02x\n", core.getStageID())
	p1Pos = core.getP1Pos()
	if p1Pos.exists == true then
		text = text .. string.format("P1 Position: (%9.5f, %9.5f)\n", core.getP1Pos().X, core.getP1Pos().Y)
	end
	p2Pos = core.getP2Pos()
	if p2Pos.exists == true then
		text = text .. string.format("P2 Position: (%9.5f, %9.5f)\n", core.getP2Pos().X, core.getP2Pos().Y)
	end
	cssPos = core.getCSSPos()
	if cssPos.exists == true then
		text = text .. string.format("Cursor Position: (%10.6f, %10.6f)\n", cssPos.X, cssPos.Y)
		text = text .. string.format("Cursor Selected: " ..tostring(cssPos.selected) .. "\n")
	end
	targets = core.targetsRemaining()
	if targets.exists == true then
		text = text .. string.format("Targets Remaining: %d\n", targets.remaining)
	end
	
	return text
end
core.getScreenText = getScreenText

local function getCSSIDs()
	local index = {DrMario = 0x0,
				   Mario = 0x1,
				   Luigi = 0x2,
				   Bowser = 0x3,
				   Peach = 0x4,
				   Yoshi = 0x5,
				   DK = 0x6,
				   CFalcon = 0x7,
				   Ganondorf = 0x8,
				   Falco = 0x9,
				   Fox = 0xA,
				   Ness = 0xB,
				   IceClimbers = 0xC,
				   Kirby = 0xD,
				   Samus = 0xE,
				   Zelda = 0xF,
				   Sheik = 0xF,
				   Link = 0x10,
				   YoungLink = 0x11,
				   Pichu = 0x12,
				   Pikachu = 0x13,
				   Jigglypuff = 0x14,
				   Mewtwo = 0x15,
				   MrGameWatch = 0x16,
				   Marth = 0x17,
				   Roy = 0x18
				  }
	return index
end
core.getCSSIDs = getCSSIDs

local function fastMenu(direction)
	if getSceneFrameCount() % 2 == 0 then
		if direction == "U" then SetMainStickY(255)
		elseif direction == "D" then SetMainStickY(0)
		elseif direction == "R" then SetMainStickX(255)
		elseif direction == "L" then SetMainStickX(0)
		end
	else
		if direction == "U" then PressButton("D-Up")
		elseif direction == "D" then PressButton("D-Down")
		elseif direction == "R" then PressButton("D-Right")
		elseif direction == "L" then PressButton("D-Left")
		end
	end
end
core.fastMenu = fastMenu

local function getPercent()
	local pct = {0, 0, 0, 0}
	pct[1] = safeReadValueFloat(0x80C99470)
	return pct
end
core.getPercent = getPercent

return core