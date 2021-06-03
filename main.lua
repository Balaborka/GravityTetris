local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
local gradient = {
    type="gradient",
    color1={ 0.486, 0.788, 0.956, 1 }, 
    color2={ 0.176, 0.886, 0.290, 1 }, 
    direction="down"
}
background:setFillColor(gradient)
background.fill.rotation = 345

local gameArea = display.newRoundedRect(
    display.contentCenterX,
    display.contentCenterY - (display.actualContentHeight / 18),
    900,
    1500,
    20
)

gameArea:setFillColor(0, 0, 0, 1)