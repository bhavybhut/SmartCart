-----------------------------------------------------------------------------------------
--
-- ShowSmartCartDetails.lua
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
	
	local background = display.newImageRect("images/silver.jpg",width,height)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
    sceneGroup:insert( background )
	
	local decoded, msg, pos = json.decode(event.params.jsondata)
	
	local function onRowRender( event )
			  local row = event.row
			  local name = display.newText(  row, row.params.input1, 12, 0, nil, 14 )
			  --number:setReferencePoint( display.CenterLeftReferencePoint )
			  name.x = 50
			  name.width = 120
			  name.y = row.height * 0.5
			  name:setFillColor( 0, 0, 0 )
			  
			  local quantity = display.newText(row, row.params.input2, 12, 0, nil, 14 )
			  --name:setReferencePoint( display.CenterLeftReferencePoint )
			  quantity.width = 50
			  quantity.x = name.x + name.contentWidth			  
			  quantity.y = row.height * 0.5
			  quantity:setFillColor( 0, 0, 0 )

			  local price = display.newText(row,row.params.input3, 12, 0, nil, 14 )
			  --score:setReferencePoint( display.CenterLeftReferencePoint )
			  price.width = 50
			  price.x = quantity.x + quantity.contentWidth + 20
			  price.y = row.height * 0.5
			  price:setFillColor( 0, 0, 0 )
			  
			  --print("Row"..row)
			  --sceneGroup:insert( row )
	end
	
	local cartTable = widget.newTableView{
		top = 50,
		left = 10,
		width = width - 20,
		height = 300,
		onRowRender = onRowRender,
	}

	sceneGroup:insert( cartTable )
	
	if not decoded then
		print("Decode failed at "..tostring(pos)..": "..tostring(msg))
	else
		cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Product Name",
					input2 = "Quantity",
					input3 = "Price"
				}
		}
		
		local sum = 0;
		for k in pairs(decoded) do
			cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = decoded[k][1],
					input2 = decoded[k][3],
					input3 = decoded[k][3] * decoded[k][2]
				}
			}
			sum = sum + decoded[k][2] * decoded[k][3];
		end	
		
		cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Total Price:",
					input2 = "",
					input3 = sum
				}
		}
		--print("log: "..decoded.item2[1])
		--print("log: "..decoded.item2[2])
		--print("log: "..decoded.item2[3])
	end
	
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
 
return scene