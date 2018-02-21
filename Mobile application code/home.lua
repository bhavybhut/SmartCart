-----------------------------------------------------------------------------------------
--
-- home.lua
--
-----------------------------------------------------------------------------------------
local composer = require("composer");

local widget = require("widget")
display.setStatusBar( display.HiddenStatusBar );

local height = display.contentHeight
local width = display.contentWidth
local scene = composer.newScene()

function scene:create( event )
 
    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
	
	local background = display.newImageRect("images/silver.jpg",width,height);
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
    -- local rect = display.newRect( 160, 240, 200, 200 )
    -- Insert rectangle into "sceneGroup"
    sceneGroup:insert( background )
	
	local checkMyCartButton = widget.newButton(
	{
        left = (width-180)/2,
        top = (height-40)/3,
        id = "checkMyCart",
        label = "Check My Cart",
		shape = "roundedRect",
		labelColor = { default={0,0,0,1}, over={1,1,1,1} },
		fontSize = 22,
		width = 180,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={0.5,0.4,1,1}, over={0.1,0.05,0.5,0.5} },
        strokeColor = { default={0,0,0.5,1}, over={0,0,0.5,1} },
        strokeWidth = 4,
        onPress = function()
			composer.gotoScene("CheckCart");
		end
	}
	)
	
	sceneGroup:insert( checkMyCartButton )
	
	local checkProductPriceButton = widget.newButton(
	{
        left = (width - 240)/2,
        top = (height-40)/1.5,
        id = "checkProductPrice",
        label = "Check Product Price",
		shape = "roundedRect",
		labelColor = { default={0,0,0,1}, over={1,1,1,1} },
		fontSize = 22,
		width = 240,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={0.5,0.4,1,1}, over={0.1,0.05,0.5,0.5} },
        strokeColor = { default={0,0,0.5,1}, over={0,0,0.5,1} },
        strokeWidth = 4,
        onRelease = function()
			composer.gotoScene("CheckProductPrice");
		end
    }
	)
	
	sceneGroup:insert( checkProductPriceButton )
end
 
-----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )

return scene