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

local pauseButton = display.newImageRect("pause-button.png", levelArea.height, levelArea.height);
pauseButton.x = gameArea.x
pauseButton.y = gameArea.y / 2
pauseButton.anchorX = 0
pauseButton.anchorY = 0

local pauseButtonPressed = false
local function touchOnPause (event)
    if(event.phase == "began") then
      pauseButton.height = pauseButton.height / 1.1
      pauseButton.width = pauseButton.width / 1.1
      pauseButtonPressed = true
    end
    if(event.phase == "ended" or event.phase == "cancelled") then
        if (pauseButtonPressed) then
            pauseButton.height = pauseButton.height * 1.1
            pauseButton.width = pauseButton.width * 1.1
            pauseButtonPressed = false
        end
    end
    if(event.phase == "moved") then
        if (pauseButtonPressed) then
            pauseButton.height = pauseButton.height * 1.1
            pauseButton.width = pauseButton.width * 1.1
        pauseButtonPressed = false
        end
    end
end

pauseButton:addEventListener("touch", touchOnPause)


local gravityTetrisLabel = display.newEmbossedText(
    "Gravity \n\r Tetris", 
    whatIsTheNextBrickArea.x + (whatIsTheNextBrickArea.x - levelArea.x / 2),
    whatIsTheNextBrickArea.y, 
    "Century Gothic Bold", 
    85
)
local color = { highlight = { r=0, g=0, b=0 } }
gravityTetrisLabel:setEmbossColor(color)

--local text1 = display.newText(pauseButton.height, 160, 240, font, 50)