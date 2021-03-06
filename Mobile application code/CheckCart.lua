-----------------------------------------------------------------------------------------
--
-- CheckCart.lua
--
-----------------------------------------------------------------------------------------
local composer = require("composer");
local widget = require("widget")
local json = require("json");

display.setStatusBar( display.HiddenStatusBar );

local height = display.contentHeight
local width = display.contentWidth
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newImageRect("images/silver.jpg",width,height);
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
    sceneGroup:insert( background )
	
	local label1 = display.newText(" Enter Smart Shopping Cart Id:",width/2,(height - 40)/4, 250, 40, native.SystemFontBold, 18)
	label1:setFillColor( 0, 0, 1 )
	
	sceneGroup:insert( label1 )
	
	textBox1 = native.newTextField( width/2, (height - 40)/3, 250, 30 )
	textBox1.isEditable = true
	
	sceneGroup:insert( textBox1 )
	
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error!")
			return false;
		else
			myNewData = event.response
			print ("From Server: "..myNewData)
			local options = {
				params = {
					jsondata = myNewData
				}
			}
			composer.gotoScene("ShowSmartCartDetails",options);
		end
	end
	
	local showMyCartButton = widget.newButton(
	{
        left = (width - 150)/2,
        top = height/2,
        id = "checkMyCart",
        label = "Show My Cart",
		shape = "roundedRect",
		labelColor = { default={0,0,0,1}, over={1,1,1,1} },
		fontSize = 18,
		width = 150,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={0.5,0.4,1,1}, over={0.1,0.05,0.5,0.5} },
        strokeColor = { default={0,0,0.5,1}, over={0,0,0.5,1} },
        strokeWidth = 2,
        onPress = function()
			print("Cart Id: "..textBox1.text);
			--network.request("http://10.20.0.137:81/smartcart/getSmartCartDetails.php?CartId="..textBox1.text, "GET", networkListener )
			--network.request("http://172.20.10.2:81/smartcart/getSmartCartDetails.php?CartId="..textBox1.text, "GET", networkListener )
			network.request("http://localhost:81/smartcart/getSmartCartDetails.php?CartId="..textBox1.text, "GET", networkListener )
		end
	}
	)
	
	sceneGroup:insert( showMyCartButton )
end

function scene:hide(event)	
	if textBox1 then
		textBox1:removeSelf()
		textBox1 = nil
	end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene