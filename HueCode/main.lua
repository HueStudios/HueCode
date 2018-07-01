
local nodes = require("nodes")
local camera = require("camera")

local x = 0
local y = 0
local zoom = 1
isInCircularMenu = false
local options = {}

local drawNodes = {}
local r = {}
local g = {}
local b = {}
r["EXECUTION_CONNECTION"] = 176
g["EXECUTION_CONNECTION"] = 63
b["EXECUTION_CONNECTION"] = 63
r["VALUE_CONNECTION"] =	176
g["VALUE_CONNECTION"] = 176
b["VALUE_CONNECTION"] =	176
r["REFERENCE_CONNECTION"] = 121
g["REFERENCE_CONNECTION"] = 176
b["REFERENCE_CONNECTION"] = 64
r["DATA_CONNECTION"] = 62
g["DATA_CONNECTION"] = 172
b["DATA_CONNECTION"] = 150

function love.load()
	love.keyboard.setKeyRepeat(true)
	love.graphics.setFont(love.graphics.newFont("NotoSans-Regular.ttf", 18))
end

lastMouseX = 0
lastMouseY = 0

newNodeX = 0
newNodeY = 0

function love.update(dt)
	currentMouseX = love.mouse.getX()
	currentMouseY = love.mouse.getY()
	deltaX = (currentMouseX - lastMouseX)
	deltaY = (currentMouseY - lastMouseY)
	if love.mouse.isDown(2) then
		x = x - deltaX
		y = y - deltaY
	end
	lastMouseX = currentMouseX
	lastMouseY = currentMouseY
	camera:setPosition(x, y)
end

function addOption (text, r, g, b, forceSide, callback)
	local option = {}
	option.text = text
	option.r = r 
	option.g = g
	option.b = b
	option.forceSide = forceSide
	option.callback = callback
	options[#options + 1] = option
end

function clearOptions ()
	options = {}
end

function drawAllNodes ()
	for i, node in ipairs(drawNodes) do
		love.graphics.push()
		love.graphics.translate(node.x, node.y)
		--Text drawing
		local nodeText = ""
		local specialText = "something"
		local type = node.nodeInternal.type
		if type == nodes.VALUE_NODE then nodeText = specialText
		elseif type == nodes.FUNCTION_NODE then nodeText = "function ( • ) • end"
		elseif type == nodes.RETURN_NODE then nodeText = "return •"
		elseif type == nodes.ASSIGN_NODE then nodeText = "• = •"
		elseif type == nodes.REFERENCE_NODE then nodeText = "• . " .. specialText
		elseif type == nodes.CONDITIONAL_NODE then nodeText = "if • then • else • end •"
		elseif type == nodes.CALLFUNCTION_NODE then nodeText = "• ( • )"
		elseif type == nodes.EVALUATE_NODE then nodeText = "do • end"
		elseif type == nodes.GENERICFORLOOP_NODE then nodeText = "for • in • do •"
		elseif type == nodes.FORLOOP_NODE then nodeText = "for •=•,•,• do • end •"
		elseif type == nodes.WHILELOOP_NODE then nodeText = "while • do • end •"
		elseif type == nodes.TABLEINDEX_NODE then nodeText = "•[ • ]"
		elseif type == nodes.OPERATOR_NODE then nodeText = "• " .. specialText .. " •"
		end
		love.graphics.push()
		love.graphics.translate(0, -70)
		love.graphics.setColor(176/256,176/256,176/256, 1)
		love.graphics.printf(nodeText, -500, 0, 1000, "center")
		love.graphics.pop()
		--Circle drawing
		local plugsOnLeft = 0
		local plugsOnRight = 0
		local plugCount = 0
		local offset = math.pi/360 * 10
		for k, plug in pairs(node.nodeInternal.plugs) do
			if plug.output == true then
				plugsOnRight = plugsOnRight + 1
				plugCount = plugCount + 1
			elseif plug.output == false and plug.type ~= "EXECUTION_CONNECTION" then
				plugsOnLeft = plugsOnLeft + 1
				plugCount = plugCount + 1
			end
			if plug.output == false and plug.type == "EXECUTION_CONNECTION" then
				love.graphics.setColor(r[plug.type]/256.0, g[plug.type]/256.0, b[plug.type]/256.0, 255/256.0)
				love.graphics.circle("fill", 0, 0, 7)
			end
		end
		if plugsOnLeft == 0 or plugsOnRight == 0 then
			local radiansPerPlug = math.pi*2 / plugCount
			local plugsDrawn = 1
			for l, plug in pairs(node.nodeInternal.plugs) do
				if not (plug.type == "EXECUTION_CONNECTION" and plug.output == false) then
					local j = plugsDrawn
					love.graphics.push()
					love.graphics.rotate(math.pi/2)
					local abegin = ((j - 1) * radiansPerPlug) + offset
					local aend = ((j) * radiansPerPlug) - offset
					love.graphics.setColor(r[plug.type]/256.0, g[plug.type]/256.0, b[plug.type]/256.0, 255/256.0)
					love.graphics.arc("line", "open", 0, 0, 32, abegin, aend, 30)
					love.graphics.pop()		
					plugsDrawn = plugsDrawn + 1
				end
			end
		else
			local radiansPerLeft = math.pi/plugsOnLeft
			local radiansPerRight = math.pi/plugsOnRight
			local plugsDrawnL = 1
			local plugsDrawnR = 1
			for l, plug in pairs(node.nodeInternal.plugs) do
				if plug.output == true then
					local j = plugsDrawnR
					love.graphics.push()
					love.graphics.rotate(-math.pi/2)
					local abegin = ((j - 1) * radiansPerRight) + offset
					local aend = ((j) * radiansPerRight) - offset
					love.graphics.setColor(r[plug.type]/256.0, g[plug.type]/256.0, b[plug.type]/256.0, 255/256.0)
					love.graphics.arc("line", "open", 0, 0, 32, abegin, aend, 30)
					love.graphics.pop()		
					plugsDrawnR = plugsDrawnR + 1
				elseif plug.output == false and plug.type ~= "EXECUTION_CONNECTION" then
					local j = plugsDrawnL
					love.graphics.push()
					love.graphics.rotate(math.pi/2)
					local abegin = (j - 1) * radiansPerLeft + offset
					local aend = (j) * radiansPerLeft - offset
					love.graphics.setColor(r[plug.type]/256.0, g[plug.type]/256.0, b[plug.type]/256.0, 255/256.0)
					love.graphics.arc("line", "open", 0, 0, 32, abegin, aend, 30)
					love.graphics.pop()
					plugsDrawnL = plugsDrawnL + 1
				end
			end
		end
		love.graphics.pop()
	end
end

function createNode (type)
	local newNode = {}
	newNode.x = newNodeX
	newNode.y = newNodeY
	if type == nodes.VALUE_NODE then newNode.nodeInternal = nodes.valueNode()
	elseif type == nodes.FUNCTION_NODE then newNode.nodeInternal = nodes.functionNode()
	elseif type == nodes.RETURN_NODE then newNode.nodeInternal = nodes.returnNode()
	elseif type == nodes.ASSIGN_NODE then newNode.nodeInternal = nodes.assignNode()
	elseif type == nodes.REFERENCE_NODE then newNode.nodeInternal = nodes.referenceNode()
	elseif type == nodes.CONDITIONAL_NODE then newNode.nodeInternal = nodes.conditionalNode()
	elseif type == nodes.CALLFUNCTION_NODE then newNode.nodeInternal = nodes.callFunctionNode()
	elseif type == nodes.EVALUATE_NODE then newNode.nodeInternal = nodes.evaluateNode()
	elseif type == nodes.FORLOOP_NODE then newNode.nodeInternal = nodes.forLoopNode()
	elseif type == nodes.GENERICFORLOOP_NODE then newNode.nodeInternal = nodes.genericForLoopNode()
	elseif type == nodes.WHILELOOP_NODE then newNode.nodeInternal = nodes.whileLoopNode()
	elseif type == nodes.TABLEINDEX_NODE then newNode.nodeInternal = nodes.tableIndexNode()
	elseif type == nodes.OPERATOR_NODE then newNode.nodeInternal = nodes.operatorNode()
	end
	drawNodes[#drawNodes + 1] = newNode
end

function addNewNodeMenu ()
	clearOptions()
	local color = 0.67
	addOption("Value node", color, color, color, nil, function () createNode(nodes.VALUE_NODE) end)
	addOption("Function node", color, color, color, nil, function () createNode(nodes.FUNCTION_NODE) end)
	addOption("Return node", color, color, color, nil, function () createNode(nodes.RETURN_NODE) end)
	addOption("Assign node", color, color, color, nil, function () createNode(nodes.ASSIGN_NODE) end)
	addOption("Reference node", color, color, color, nil, function () createNode(nodes.REFERENCE_NODE) end)
	addOption("Conditional node", color, color, color, nil, function () createNode(nodes.CONDITIONAL_NODE) end)
	addOption("Call node", color, color, color, nil, function () createNode(nodes.CALLFUNCTION_NODE) end)
	addOption("Evaluate node", color, color, color, nil, function () createNode(nodes.EVALUATE_NODE) end)
	addOption("For loop node", color, color, color, nil, function () createNode(nodes.FORLOOP_NODE) end)
	addOption("Generic for loop node", color, color, color, nil, function () createNode(nodes.GENERICFORLOOP_NODE) end)
	addOption("While loop node", color, color, color, nil, function () createNode(nodes.WHILELOOP_NODE) end)
	addOption("Operator node", color, color, color, nil, function () createNode(nodes.OPERATOR_NODE) end)
	addOption("Table index node", color, color, color, nil, function () createNode(nodes.TABLEINDEX_NODE) end)
	isInCircularMenu = true
end

function drawCircularMenu ()
	love.graphics.push()
	love.graphics.clear(0.11, 0.11, 0.11, 0.5)
	local referenceSize = 0
	if love.graphics.getWidth() > love.graphics.getHeight() then 
		referenceSize = love.graphics.getHeight() 
	else 
		referenceSize = love.graphics.getWidth() 
	end
	local radiusToUse = (referenceSize/2) - 70
	love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight() / 2)
	mouseX, mouseY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
	local angle = math.atan2(mouseY, mouseX)
	local distance = math.sqrt((mouseX*mouseX)+(mouseY*mouseY))
	--print(angle)
	local radians = angle
	if radians < 0 then
		radians = (math.pi - math.abs(radians)) + math.pi
	end
	local inSelect = false
	size = 30
	if distance > 50 then
		inSelect = true
		size = 25
		love.graphics.push()
		love.graphics.rotate(radians)
		love.graphics.rotate(-math.pi/2)
		love.graphics.translate(0, 50)
		love.graphics.polygon('fill', -15, 0, 0, 15, 15, 0)
		love.graphics.pop()
	end
	love.graphics.push()
	love.graphics.rotate(math.pi/4)
	for i=1,4,1 do
		love.graphics.line(0,0, 0, size)
		love.graphics.rotate(math.pi/2)
	end
	if inSelect == false then
		if love.mouse.isDown(1) then
			isInCircularMenu = false
		end
	end
	love.graphics.pop()
	--love.graphics.circle("line", 0, 0, radiusToUse)
	local fullCircle = math.pi * 2 
	local eachDiv = fullCircle / #options
	local offset = (fullCircle/360)*2
	for i, v in ipairs(options) do
		local abegin = (i - 1) * eachDiv + offset
		local aend = (i) * eachDiv - offset
		local add = 0
		if (radians > abegin and radians < aend) and inSelect then
			add = 15 
			if love.mouse.isDown(1) then
				isInCircularMenu = false
				v.callback()
			end
		end
		love.graphics.setColor(v.r, v.g, v.b, 1)
		love.graphics.arc("line", "open", 0, 0, radiusToUse + add, abegin, aend, 30)
		love.graphics.arc("line", "open", 0, 0, 45, abegin + offset, aend - offset, 30)
		love.graphics.push()
		local textAngle = (i-1) * eachDiv + eachDiv / 2
		love.graphics.rotate((i-1) * eachDiv + eachDiv / 2)
		love.graphics.translate(0, -12)
		if textAngle > math.pi/2 and textAngle < 3*math.pi/2 then
			love.graphics.scale(-1, -1)
			love.graphics.translate(0-radiusToUse - 50 - add, -23)
			--love.graphics.rotate(math.pi)
		end
		love.graphics.printf(v.text, 30, 0, radiusToUse - 10 + add, "center")
		love.graphics.pop()
	end
	love.graphics.pop()
end
  
function love.draw()
	love.graphics.clear(0.137, 0.137, 0.137)
	camera:set()
	love.graphics.setLineWidth(2)
	--Code goes here
	if love.keyboard.isDown("tab") then
		if not isInCircularMenu then
			newNodeX, newNodeY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
			print(newNodeX, newNodeY)
			addNewNodeMenu()
		end
	end
	drawAllNodes()
	camera:unset()
	if isInCircularMenu then
		drawCircularMenu()
	end
end
--function love.draw()
	--love.graphics.print("Hello ", x + 100, y + 100)
--end

function love.wheelmoved (x, y)
	if (zoom > 0.4 and y < 0 or zoom <= 1.3 and y > 0) then
		zoom = zoom + y / 5
		camera.scaleX = 1/zoom
		camera.scaleY = 1/zoom
	end
end
