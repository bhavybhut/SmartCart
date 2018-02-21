-----------------------------------------------------------------------------------------
--
-- ShowProductPrice.lua
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
	
	local decoded, msg, pos = json.decode(event.params.jsondata)
	
	local function onRowRender( event )
			  local row = event.row
			  local name = display.newText(  row, row.params.input1, 12, 0, nil, 14 )
			  --number:setReferencePoint( display.CenterLeftReferencePoint )
			  name.x = 75
			  name.width = 150
			  name.y = row.height * 0.5
			  name:setFillColor( 0, 0, 0 )
			  
			  local value = display.newText(row, row.params.input2, 12, 0, nil, 14 )
			  --name:setReferencePoint( display.CenterLeftReferencePoint )
			  value.width = 50
			  value.x = name.x + name.contentWidth			  
			  value.y = row.height * 0.5
			  value:setFillColor( 0, 0, 0 )

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
		local counter = 1;
		for k in pairs(decoded) do
			cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Product Id:",
					input2 = decoded[k][counter],
				}
			}
			counter = counter + 1
			
			cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Name:",
					input2 = decoded[k][counter],
				}
			}
			counter = counter + 1
			
			cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Price:",
					input2 = decoded[k][counter],
				}
			}
			counter = counter + 1
			
			cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Discount %:",
					input2 = decoded[k][counter],
				}
			}
			counter = counter + 1
			
			cartTable:insertRow{"label",
				rowColor = { 0, 0, 1 },
				onRender = onRowRender,
				params = {
					input1 = "Discounted Price:",
					input2 = decoded[k][counter],
				}
			}
			counter = counter + 1
		end	
	end
	
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
 
return scene