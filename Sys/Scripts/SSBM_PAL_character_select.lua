local core = require "SSBM_PAL_core"
local cssCore = require "Sys.SSBM_PAL_character_select_core"

function onScriptStart()
	if GetGameID() ~= "GALP01" then
		SetScreenText("")
		CancelScript()
	end
end

function onScriptCancel()
end

function onScriptUpdate()
	if core.getCSSPos().exists == true then
		local css_file = io.open("Sys/Scripts/character_select.txt")
		local character = css_file:read( "*l" )
		css_file:close()
		running = cssCore.cssSelect(character)
		if running == false then
			SaveState(true, 2)
		end
	end
end

function onStateLoaded()

end

function onStateSaved()

end