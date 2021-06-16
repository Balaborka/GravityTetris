display.anchorX = 0
display.anchorY = 0
roundValue = 20

local background = display.newRect(display.screenOriginX, 0, display.actualContentWidth, display.actualContentHeight)
local gradient = {
    type="gradient",
    color1={ 0.486, 0.788, 0.956, 1 },
    color2={ 0.176, 0.886, 0.290, 1 },
    direction="down"
}
background:setFillColor(gradient)
background.fill.rotation = 345
background.anchorX = 0
background.anchorY = 0

local gameArea = display.newRoundedRect(
    0, --display.screenOriginX + display.actualContentWidth / 12, --This value is calculated later
    display.actualContentHeight / 8,
    0, --background.width - background.width / 6, --This value is calculated later
    background.height - background.height / 2.5,
    roundValue
)
gameArea.anchorX = 0
gameArea.anchorY = 0
local horisontalLinesCount = 10
local varticalLinesCount = 6
gameArea.width = gameArea.height * varticalLinesCount / horisontalLinesCount
gameArea.x = display.screenOriginX + (background.width - gameArea.width) / 2
gameArea:setFillColor(0, 0, 0, 0.85)

local lineThickness = 4
local hx = gameArea.x
local hy = gameArea.y + gameArea.height / horisontalLinesCount
for i = 1, horisontalLinesCount - 1 do
    local horisontalGridLine = display.newRect(hx, hy, gameArea.width, lineThickness)
    horisontalGridLine:setFillColor(0.176, 0.886, 0.290, 0.3)
    hy = hy + gameArea.height / horisontalLinesCount
    horisontalGridLine.anchorX = 0
    horisontalGridLine.anchorY = 0
end

local vx = gameArea.x + gameArea.width / varticalLinesCount
local vy = gameArea.y
for i=1, varticalLinesCount - 1 do
  local verticalGridLine = display.newRect(vx, vy, lineThickness, gameArea.height)
  verticalGridLine:setFillColor(0.176, 0.886, 0.290, 0.3)
  vx = vx + gameArea.width / varticalLinesCount
  verticalGridLine.anchorX = 0
  verticalGridLine.anchorY = 0
end

local whatIsTheNextBrickArea = display.newRoundedRect(
    display.contentCenterX,
    background.height - (background.height - gameArea.height) / 2.5,
    gameArea.width / varticalLinesCount * 2 / 1.2,
    gameArea.width / varticalLinesCount * 2 / 1.2,
    roundValue
)
whatIsTheNextBrickArea:setFillColor(0, 0, 0, 0.85)

local levelArea = display.newRoundedRect(
    gameArea.x,
    whatIsTheNextBrickArea.y - whatIsTheNextBrickArea.height / 2,
    gameArea.width / varticalLinesCount * 2 / 1.2,
    gameArea.width / varticalLinesCount / 1.6,
    roundValue
)
levelArea:setFillColor(0, 0, 0, 0.85)
levelArea.anchorX = 0
levelArea.anchorY = 0

local scoreArea = display.newRoundedRect(
    levelArea.x,
    levelArea.y + levelArea.height + levelArea.height / 4,
    levelArea.width,
    levelArea.height,
    roundValue
)
scoreArea:setFillColor(0, 0, 0, 0.8)
scoreArea.anchorX = 0
scoreArea.anchorY = 0

local gravityTetrisLabel = display.newEmbossedText(
    "Gravity \n\r Tetris", 
    whatIsTheNextBrickArea.x + (whatIsTheNextBrickArea.x - levelArea.x / 2),
    whatIsTheNextBrickArea.y, 
    "Century Gothic Bold", 
    85
)
local color = { highlight = { r=0, g=0, b=0 } }
gravityTetrisLabel:setEmbossColor(color)

local function TouchOnObject (event)
    local object = event.target
	local value = 0.93

	if not object.isFocus then
		if event.phase == "began" or event.phase == "moved" then
			object.isFocus = true
			object.xScale = value
			object.yScale = value
			object.offsetX = (object.width - object.width*value)/2
			object.offsetY = (object.height - object.height*value)/2
			display.getCurrentStage():setFocus(object)
		end
	end

	if object.isFocus then
		if event.phase == "moved" then
				if event.x < object.contentBounds.xMin - object.offsetX or 
                event.x > object.contentBounds.xMax + object.offsetX or
				event.y < object.contentBounds.yMin - object.offsetY or 
                event.y > object.contentBounds.yMax + object.offsetY then
						object.isFocus = false
						object.xScale = 1
						object.yScale = 1
						display.getCurrentStage():setFocus(nil)
				end
		end

		if event.phase == "ended" then
			object.isFocus = false
			object.xScale = 1
			object.yScale = 1
			display.getCurrentStage():setFocus(nil)
		end
	end
end

local prePauseScreen = display.newImageRect("pre-pause-screen.png", whatIsTheNextBrickArea.width * 1.5, whatIsTheNextBrickArea.height * 1.5);
prePauseScreen.x = gameArea.x + gameArea.width / 2
prePauseScreen.y = gameArea.y + gameArea.height / 2
prePauseScreen.alpha = 0.8
prePauseScreen.isVisible = false
function ShowHidePause(isPaused)
    prePauseScreen.isVisible = isPaused
end
local function TouchOnPrePauseScreen (event)
	TouchOnObject(event)
    if (event.phase == "ended") then
        ShowHidePause(false)
    end
end
prePauseScreen:addEventListener("touch", TouchOnPrePauseScreen)

local pauseButton = display.newImageRect("pause-button.png", levelArea.height, levelArea.height);
pauseButton.x = gameArea.x
pauseButton.y = gameArea.y / 2
pauseButton.anchorX = 0
pauseButton.anchorY = 0
local function TouchOnPause (event)
	TouchOnObject(event)
    if (event.phase == "ended") then
        ShowHidePause(not prePauseScreen.isVisible)
    end
end
pauseButton:addEventListener("touch", TouchOnPause)

-- Below is a simple brick creating demonstration. You can use this code to create a logic.
local itemsEnum = {
    Triangle=1,
    Cube=2,
    Line=3,
}

local brick = display.newRoundedRect(gameArea.x + gameArea.width / 2 + 12, gameArea.y + 12, (gameArea.width / varticalLinesCount) / 1.2, (gameArea.width / varticalLinesCount) / 1.2, roundValue)
local gradient = {
    type="gradient",
    color1={ 169 / 255, 254 / 255, 178 / 255, 1 },
    color2={ 91 / 255, 206 / 255, 103 / 255, 1 },
    direction="down"
}
brick:setFillColor(gradient)
brick.fill.rotation = 30
brick.anchorX = 0
brick.anchorY = 0

--local text1 = display.newText(pauseButton.height, 160, 240, font, 50)