local core = require "SSBM_PAL_core"

local cssCore = {}

local function cssSelectBounds()
    bounds = {X = {[0]=-32.7, -27.1, -20.1, -13.1, -6.1, 0.9, 7.9, 14.9, 21.7, 26.01},
              Y = {[0]=1, 8, 15, 22}}
    return bounds
end
cssCore.cssSelectBounds = cssSelectBounds

local function cssTargetPosition(character)
    local index = {DrMario = {X=0, Y=2},
                   Mario = {X=1, Y=2},
                   Luigi = {X=2, Y=2},
                   Bowser = {X=3, Y=2},
                   Peach = {X=4, Y=2},
                   Yoshi = {X=5, Y=2},
                   DK = {X=6, Y=2},
                   CFalcon = {X=7, Y=2},
                   Ganondorf = {X=8, Y=2},
                   Falco = {X=0, Y=1},
                   Fox = {X=1, Y=1},
                   Ness = {X=2, Y=1},
                   IceClimbers = {X=3, Y=1},
                   Kirby = {X=4, Y=1},
                   Samus = {X=5, Y=1},
                   Zelda = {X=6, Y=1},
                   Sheik = {X=6, Y=1},
                   Link = {X=7, Y=1},
                   YoungLink = {X=8, Y=1},
                   BLRandom = {X=0, Y=0},
                   Pichu = {X=1, Y=0},
                   Pikachu = {X=2, Y=0},
                   Jigglypuff = {X=3, Y=0},
                   Mewtwo = {X=4, Y=0},
                   MrGameWatch = {X=5, Y=0},
                   Marth = {X=6, Y=0},
                   Roy = {X=7, Y=0},
                   BRRandom = {X=8, Y=0},
                  }
    xTarget = index[character].X
    yTarget = index[character].Y
    
    xTargetMax = index[character].X + 1
    yTargetMax = index[character].Y + 1
    
    local bounds = cssSelectBounds()
    targetBounds = {xMin = bounds.X[xTarget], xMax = bounds.X[xTargetMax], yMin = bounds.Y[yTarget], yMax = bounds.Y[yTargetMax]}
	if character == "Pichu" then targetBounds.xMin = -26.1 end
	if character == "Roy" then targetBounds.xMax = 20.9 end
    return targetBounds
end
cssCore.cssTargetPosition = cssTargetPosition

--[[
if current character selected:
    Start
    if Sheik:
        A
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
        
    X-breaks: -32.7, -27.1, -20.1, -13.1, -6.1, 0.9, 7.9, 14.9, 21.7, can't reach so effectively 26
    Y-breaks: 1, 8, 15, 22
]]--

local function cssSelect(character)
    local targetBounds = cssTargetPosition(character)
    local targetID = core.getCSSIDs()[character]
    local cssPos = core.getCSSPos()
    
    if cssPos.exists == false then
        return false
    end
	if targetID == core.getCharacterSelectID() then
		if core.getSceneFrameCount() >= 29 then
			PressButton("Start")
			if character == "Sheik" then
				PressButton("A")
			end
		end
    elseif targetBounds.xMin < cssPos.X and cssPos.X < targetBounds.xMax and targetBounds.yMin < cssPos.Y and cssPos.Y < targetBounds.yMax then
        if cssPos.selected == 1 then
            PressButton("B")
        else
            PressButton("A")
        end
    elseif targetBounds.xMin < cssPos.X and cssPos.X < targetBounds.xMax then
        if cssPos.Y <= targetBounds.yMin then SetMainStickY(255)
        elseif targetBounds.yMax <= cssPos.Y then SetMainStickY(0)
        end
    elseif targetBounds.yMin < cssPos.Y and cssPos.Y < targetBounds.yMax then
        if cssPos.X <= targetBounds.xMin then SetMainStickX(255)
        elseif targetBounds.xMax <= cssPos.X then SetMainStickX(0)
        end
	else
		if cssPos.X <= targetBounds.xMin then 
			xTarget = targetBounds.xMin
			xDir = 1
		else
			xTarget = targetBounds.xMax
			xDir = -1
		end
		if cssPos.Y <= targetBounds.yMin then
			yTarget = targetBounds.yMin
			yDir = 1
		else
			yTarget = targetBounds.yMax
			yDir = -1
		end
		xDist = math.abs(cssPos.X - xTarget)
		yDist = math.abs(cssPos.Y - yTarget)
		larger = math.max(xDist, yDist)
		xMove = math.max(math.ceil(xDist/larger*127), 2) * xDir
		yMove = math.max(math.ceil(yDist/larger*127), 2) * yDir
		SetMainStickX(128 + xMove)
		SetMainStickY(128 + yMove)
    end
	if cssPos.Y > 0.2 and cssPos.Y < 22 and targetID ~= core.getCharacterSelectID() and cssPos.selected == 1 then
        PressButton("B")
	end
	return true
end
cssCore.cssSelect = cssSelect

return cssCore