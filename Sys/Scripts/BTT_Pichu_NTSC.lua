local core = require "SSBM_NTSC_core"

function onScriptStart()
    if GetGameID() ~= "GALE01" then
        SetScreenText("")
        CancelScript()
    end
    startFrame = 0
end

function onScriptCancel()
end

function onScriptUpdate()
	if core.getSceneController().currMaj == 0x0F and core.getSceneController().currMin == 0x01 and core.getCharacterSelectID() == 0x12 then
		local currentFrame = core.getSceneFrameCount()
		local frameDiff = currentFrame - startFrame
		--local targets = core.targetsRemaining()
    
		if frameDiff < 84 then 
		elseif frameDiff < 86 then SetMainStickX(49)
		elseif frameDiff < 89 then PressButton("Y") SetMainStickX(49)
		elseif frameDiff < 90 then PressButton("B") SetMainStickX(151)
		elseif frameDiff < 104 then SetMainStickX(208)
		elseif frameDiff < 125 then 
		elseif frameDiff < 126 then SetMainStickY(48)
		elseif frameDiff < 140 then 
		elseif frameDiff < 146 then SetMainStickX(208)
		elseif frameDiff < 147 then PressButton("Y") SetMainStickX(48)
		elseif frameDiff < 148 then PressButton("A") SetMainStickX(151)
		elseif frameDiff < 168 then SetMainStickX(48)
		elseif frameDiff < 170 then PressButton("L")
		elseif frameDiff < 176 then 
		elseif frameDiff < 184 then SetMainStickX(48)
		elseif frameDiff < 187 then PressButton("Y") SetMainStickX(48)
		elseif frameDiff < 204 then 
		elseif frameDiff < 206 then SetMainStickX(208)
		elseif frameDiff < 207 then PressButton("Y")
		elseif frameDiff < 208 then PressButton("A") SetMainStickX(179) SetMainStickY(189)
		elseif frameDiff < 237 then SetMainStickX(208)
		elseif frameDiff < 238 then PressButton("A") SetMainStickY(208)
		elseif frameDiff < 242 then SetMainStickX(208)
		elseif frameDiff < 243 then SetMainStickY(48)
		elseif frameDiff < 258 then SetMainStickX(208)
		elseif frameDiff < 259 then 
		elseif frameDiff < 266 then SetMainStickX(208)
		elseif frameDiff < 269 then PressButton("Y") SetMainStickX(208)
		elseif frameDiff < 303 then SetMainStickX(208)
		elseif frameDiff < 304 then PressButton("Y") SetMainStickX(208)
		elseif frameDiff < 305 then PressButton("A") SetMainStickY(208)
		elseif frameDiff < 337 then SetMainStickX(208)
		elseif frameDiff < 338 then PressButton("B")
		elseif frameDiff < 341 then SetMainStickX(208)
		elseif frameDiff < 394 then 
		elseif frameDiff < 395 then SetMainStickX(208)
		elseif frameDiff < 397 then PressButton("Y") SetMainStickX(208)
		elseif frameDiff < 410 then SetMainStickX(208)
		elseif frameDiff < 411 then PressButton("B") SetMainStickY(48)
		elseif frameDiff < 446 then 
		end
	end
end

function onStateLoaded()
end

function onStateSaved()
end

out = {}
out.onScriptStart = onScriptStart
out.onScriptUpdate = onScriptUpdate
return out