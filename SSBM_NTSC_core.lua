local core = {}

local function safeReadValueFloat(intVal)
  return string.unpack("f", string.pack("I4", ReadValue32(intVal)))
end
core.safeReadValueFloat = safeReadValueFloat

local function getSceneController()
	base = 0x80479D30 --ntsc
	return {currMaj = ReadValue8(base), pendMaj = ReadValue8(base + 1), prevMaj = ReadValue8(base + 2), currMin = ReadValue8(base + 3)}
end
core.getSceneController = getSceneController

 -- only really reliably resets to 2
 -- first actionable frame on game start is 84
local function getSceneFrameCount() --ntsc
	return ReadValue32(0x80479D60)
end
core.getSceneFrameCount = getSceneFrameCount

local function getRngSeed() --ntsc
	return ReadValue32(0x804D5F90)
end
core.getRngSeed = getRngSeed

local function setRngSeed(seed) --ntsc
	WriteValue32(0x804D5F90, seed)
end
core.setRngSeed = setRngSeed

local function getCharacterSelectID()
	return ReadValue8(0x803F0E0B)
end
core.getCharacterSelectID = getCharacterSelectID

local function getStageID() --ntsc
	return ReadValue8(0x804D49EB)
end
core.getStageID = getStageID

local function getP1Pos()
	base = 0x80453090 --ntsc
	local pos = {exists = true, X = safeReadValueFloat(base), Y = safeReadValueFloat(base + 4)}
	return pos
end
core.getP1Pos = getP1Pos

local function getP2Pos()
	base = 0x80453F20 --ntsc
	local pos = {exists = true, X = safeReadValueFloat(base), Y = safeReadValueFloat(base + 4)}
	return pos
end
core.getP2Pos = getP2Pos

local function getGameState() -- 0x0 = game, 0x10 = game-end, 0x20 = menu
	return ReadValue8(0x80479D69) --ntsc
end
core.getGameState = getGameState

local function getScreenText()
	text = ""
	--text = text .. string.format("Scene ID: 0x%08x\n", core.getSceneID())
	text = text .. string.format("Current Major Scene: 0x%02x\n", core.getSceneController().currMaj)
	text = text .. string.format("Pending Major Scene: 0x%02x\n", core.getSceneController().pendMaj)
	text = text .. string.format("Previous Major Scene: 0x%02x\n", core.getSceneController().prevMaj)
	text = text .. string.format("Current Minor Scene: 0x%02x\n", core.getSceneController().currMin)
	text = text .. string.format("Game State: 0x%02x\n", core.getGameState())
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
	
	return text
end
core.getScreenText = getScreenText

return core