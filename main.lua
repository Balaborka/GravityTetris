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

-- Bricks and Blocks.
local BrickColorEnum = {
    Green = 1,
    Yellow = 2,
    Red = 3,
    Blue = 4,
    Purple = 5,
}
local BlcokFormEnum = {
    Triangle = 1,
    Cube = 2,
    Line = 3,
}

--local BlcokFormEnum = {}
--BlcokFormEnum.Triangle = 1
--BlcokFormEnum.Cube = 2
--BlcokFormEnum.Line = 3
--BlcokFormEnum.ALL = {
    --BlcokFormEnum.Triangle,
    --BlcokFormEnum.Cube,
  --  BlcokFormEnum.Line
--}
--return Color

local Brick = {}
local brickWidth = (gameArea.width / varticalLinesCount) / 1.2
local brickHeight = brickWidth
function Brick:new(x, y, brickColor)
  local brick = display.newRoundedRect(x, y, brickWidth, brickHeight, roundValue)
  local gradient = {}
  if (brickColor == BrickColorEnum.Green) then      
  gradient = {
    type="gradient",
    color1={ 169 / 255, 254 / 255, 178 / 255, 1 },
    color2={ 91 / 255, 206 / 255, 103 / 255, 1 },
    direction="down"
  }
  elseif (brickColor == BrickColorEnum.Yellow) then
    gradient = {
        type="gradient",
        color1={ 255 / 255, 245 / 255, 155 / 255, 1 },
        color2={ 249 / 255, 194 / 255, 0 / 255, 1 },
        direction="down"
      }
  elseif (brickColor == BrickColorEnum.Red) then
    gradient = {
        type="gradient",
        color1={ 234 / 255, 168 / 255, 147 / 255, 1 },
        color2={ 249 / 255, 15 / 255, 0 / 255, 1 },
        direction="down"
      }
  elseif (brickColor == BrickColorEnum.Blue) then
    gradient = {
        type="gradient",
        color1={ 147 / 255, 187 / 255, 234 / 255, 1 },
        color2={ 0 / 255, 85 / 255, 249 / 255, 1 },
        direction="down"
      }
  elseif (brickColor == BrickColorEnum.Purple) then
    gradient = {
        type="gradient",
        color1={ 232 / 255, 147 / 255, 234 / 255, 1 },
        color2={ 206 / 255, 4 / 255, 210 / 255, 1 },
        direction="down"
      }
  end
  brick:setFillColor(gradient)
  brick.fill.rotation = 30
  brick.anchorX = 0
  brick.anchorY = 0
  return brick
end

local Block = {}
function Block:new(blcokForm)

  local block = display.newGroup()
  if (blcokForm == BlcokFormEnum.Cube or blcokForm == BlcokFormEnum.Triangle) then
    local x1_3 = gameArea.x + gameArea.width / 3 + 13
    local x2_4 = gameArea.x + gameArea.width / 2 + 13
    local y1_2 = gameArea.y + 13
    local y3_4 = y1_2 + (x2_4 - x1_3)
    local brick1 = Brick:new(x1_3, y1_2, BrickColorEnum.Yellow)
    local brick2 = Brick:new(x2_4, y1_2, BrickColorEnum.Red)
    local brick3 = Brick:new(x1_3, y3_4, BrickColorEnum.Blue)
    block:insert( brick1 )
    block:insert( brick2 )
    block:insert( brick3 )
    if(blcokForm == BlcokFormEnum.Cube) then
      local brick4 = Brick:new(x2_4, y3_4, BrickColorEnum.Purple)
      block:insert( brick4 )
    end
  elseif (blcokForm == BlcokFormEnum.Line) then
    local x1_2_3 = gameArea.x + gameArea.width / 3 + 13
    local y1 = gameArea.y + 13
    local y2 = y1 + ((gameArea.x + gameArea.width / 2 + 13) - (gameArea.x + gameArea.width / 3 + 13))
    local y3 = y2 + (y2 - y1)
    local brick1 = Brick:new(x1_2_3, y1, BrickColorEnum.Green)
    local brick2 = Brick:new(x1_2_3, y2, BrickColorEnum.Green)
    local brick3 = Brick:new(x1_2_3, y3, BrickColorEnum.Green)
    block:insert( brick1 )
    block:insert( brick2 )
    block:insert( brick3 )
  end
  return block
end

local block = Block:new(math.random(1, 3))

--local text1 = display.newText(blcokForm, 160, 240, font, 50)
