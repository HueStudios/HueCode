local utf8 = require("utf8")
local colorScheme = require("colorScheme")
local nodes = require("nodes")
local camera = require("camera")

local x = 0
local y = 0
local zoom = 1
isInCircularMenu = false
local options = {}

local drawNodes = {}

local connectingPlug = nil
local connectingNode = nil

local text = ""

function love.load()
	love.keyboard.setKeyRepeat(true)
	love.graphics.setFont(love.graphics.newFont("NotoSans-Regular.ttf", 18))
end

lastMouseX = 0
lastMouseY = 0

newNodeX = 0
newNodeY = 0
local isDragging = false
local dragDeltaX = 0
local dragDeltaY = 0
local dragNode = nil
local interacted = false

function love.mousereleased(x, y, button)
	if button == 1 then
	   interacted = true
	end
 end


function showMenuForPlugs (node)
	clearOptions()
	for k,v in pairs (node.nodeInternal.plugs) do
		side = nil
		if v.output == true then
			side = "right"
		else
			side = "left"
		end
		local thisfunction = function ()
			if connectingNode == nil then
				connectingNode = node
				connectingPlug = k 
			else
				if v.connection and v.connection.connection ~= nil then 
				v.connection.connection = nil 
				end
				if connectingNode.nodeInternal.plugs[connectingPlug].connection and 
				connectingNode.nodeInternal.plugs[connectingPlug].connection.connection ~= nil then
				connectingNode.nodeInternal.plugs[connectingPlug].connection.connection = nil end
				v.connection = nil
				connectingNode.nodeInternal.plugs[connectingPlug].connection = nil
				connectingNode.nodeInternal.plugs[connectingPlug].connect(v)
				connectingNode = nil
				connectingPlug = nil
			end
		end
		local compatible = false
		if connectingNode then
			local target = connectingNode.nodeInternal.plugs[connectingPlug]
			print(target.type, v.type)
			if v.type == nodes.EXECUTION_CONNECTION and target.type == nodes.EXECUTION_CONNECTION then
				compatible = true
			end
			if v.type == nodes.DATA_CONNECTION and target.type == nodes.DATA_CONNECTION then
				compatible = true
			end
			if v.type == nodes.DATA_CONNECTION and target.type == nodes.VALUE_CONNECTION then
				compatible = true
			end
			if v.type == nodes.VALUE_CONNECTION and target.type == nodes.VALUE_CONNECTION then
				compatible = true
			end
			if v.type == nodes.DATA_CONNECTION and target.type == nodes.REFERENCE_CONNECTION then
				compatible = true
			end
			if v.type == nodes.REFERENCE_CONNECTION and target.type == nodes.REFERENCE_CONNECTION then
				compatible = true
			end
		end
		if connectingNode == nil or (compatible and connectingNode) and
		connectingNode.nodeInternal.plugs[connectingPlug].output ~= v.output then
			addOption(k, colorScheme.red[v.type], colorScheme.green[v.type], colorScheme.blue[v.type], side, thisfunction)
		end
	end
	isInCircularMenu = true
end 

function nodeMouseHandler ()
	selectedAnything = false
	mouseEvent = false
	mouseX, mouseY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
	if love.mouse.isDown(1) == false then isDragging = false end
	for i,v in ipairs (drawNodes) do
		if dragNode == v and isDragging then
			v.x = mouseX - dragDeltaX
			v.y = mouseY - dragDeltaY
		end
		distance = math.sqrt( (v.x - mouseX)*(v.x - mouseX)+(v.y - mouseY)*(v.y - mouseY) )
		if distance < 15 then
			love.graphics.push()
			love.graphics.translate(v.x, v.y)
			love.graphics.setColor(176,176,176, 1)
			love.graphics.circle("fill", 0, 0, 10, 30)
			love.graphics.pop()
			if love.mouse.isDown(1) then
				mouseEvent = true
				for j,other in ipairs (drawNodes) do
					other.selected = false
				end
				selectedAnything = true
				text = v.nodeInternal.specialText
				v.selected = true
				if isDragging == false then
					isDragging = true
					dragDeltaX = mouseX - v.x
					dragDeltaY = mouseY - v.y
					dragNode = v
				end
			end
			v.hovering = false
		elseif distance < 40 then
			v.hovering = true
			if love.mouse.isDown(1) then
				mouseEvent = true
			end
			if interacted then
				showMenuForPlugs(v)
			end
		else
			v.hovering = false
			if love.mouse.isDown(1) then
				mouseEvent = true
			end 
		end
	end
	interacted = false
	if selectedAnything == false and mouseEvent then
		for j,other in ipairs (drawNodes) do
			other.selected = false
		end
	end
end

function love.textinput(t)
    text = text .. t
end

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

function love.keypressed (key) 
	if key == "space" and connectingNode ~= nil then
		connectingNode = nil
		connectingPlug = nil
	end
	if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
    end
end

function drawAllNodes ()
	for i, node in ipairs(drawNodes) do
		love.graphics.push()
		love.graphics.translate(node.x, node.y)
		if node.selected then
			love.graphics.push()
			love.graphics.setColor(176,176,176, 1)
			love.graphics.setLineWidth(1)
			love.graphics.circle("line", 0, 0, 40, 100)
			love.graphics.pop() 
			node.nodeInternal.specialText = text
		end
		--Text drawing
		local nodeText = ""
		local specialText = node.nodeInternal.specialText
		local type = node.nodeInternal.type
		if type == nodes.VALUE_NODE then nodeText = specialText
		elseif type == nodes.FUNCTION_NODE then nodeText = "function ( • ) • end"
		elseif type == nodes.RETURN_NODE then nodeText = "return •"
		elseif type == nodes.ASSIGN_NODE then nodeText = "• = •"
		elseif type == nodes.REFERENCE_NODE then nodeText = "{ • . } " .. specialText
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
		love.graphics.setColor(176,176,176, 1)
		love.graphics.printf(nodeText, -500, 0, 1000, "center")
		love.graphics.pop()
		--Circle drawing
		local plugsOnLeft = 0
		local plugsOnRight = 0
		local plugCount = 0
		local offset = math.pi/360 * 10
		if node.hovering then
			love.graphics.setLineWidth(4)
		else
			love.graphics.setLineWidth(2)
		end
		for k, plug in pairs(node.nodeInternal.plugs) do
			if plug.output == true then
				plugsOnRight = plugsOnRight + 1
				plugCount = plugCount + 1
			elseif plug.output == false and plug.type ~= nodes.EXECUTION_CONNECTION then
				plugsOnLeft = plugsOnLeft + 1
				plugCount = plugCount + 1
			end
			if plug.output == false and plug.type == nodes.EXECUTION_CONNECTION then
				love.graphics.setColor(colorScheme.red[plug.type], colorScheme.green[plug.type], colorScheme.blue[plug.type], 1)
				love.graphics.circle("fill", 0, 0, 7, 30)
				plug.posX, plug.posY = love.graphics.transformPoint(0, 0)
			end
		end
		if plugsOnLeft == 0 or plugsOnRight == 0 then
			local radiansPerPlug = math.pi*2 / plugCount
			local plugsDrawn = 1
			for l, plug in pairs(node.nodeInternal.plugs) do
				if not (plug.type == nodes.EXECUTION_CONNECTION and plug.output == false) then
					local j = plugsDrawn
					love.graphics.push()
					love.graphics.rotate(math.pi/2)
					local abegin = ((j - 1) * radiansPerPlug) + offset
					local aend = ((j) * radiansPerPlug) - offset
					love.graphics.push()
					love.graphics.rotate(-math.pi/2)
					love.graphics.rotate((abegin + aend) / 2 )
					plug.posX, plug.posY = love.graphics.transformPoint(0, 32)
					love.graphics.pop()
					love.graphics.setColor(colorScheme.red[plug.type], colorScheme.green[plug.type], colorScheme.blue[plug.type], 1)
					love.graphics.arc("line", "open", 0, 0, 32, abegin, aend, 30)
					love.graphics.pop()		
					plugsDrawn = plugsDrawn + 1
					if plugsOnLeft == 1 then
						plug.posX, plug.posY = love.graphics.transformPoint(-32, 0)
					end
					if plugsOnRight == 1 then
						plug.posX, plug.posY = love.graphics.transformPoint(32, 0)
					end
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
					love.graphics.push()
					love.graphics.rotate(-math.pi/2)
					love.graphics.rotate((abegin + aend) / 2 )
					plug.posX, plug.posY = love.graphics.transformPoint(0, 32)
					love.graphics.pop()
					love.graphics.setColor(colorScheme.red[plug.type], colorScheme.green[plug.type], colorScheme.blue[plug.type], 1)
					love.graphics.arc("line", "open", 0, 0, 32, abegin, aend, 30)
					love.graphics.pop()		
					plugsDrawnR = plugsDrawnR + 1
				elseif plug.output == false and plug.type ~= nodes.EXECUTION_CONNECTION then
					local j = plugsDrawnL
					love.graphics.push()
					love.graphics.rotate(math.pi/2)
					local abegin = (j - 1) * radiansPerLeft + offset
					local aend = (j) * radiansPerLeft - offset
					love.graphics.push()
					love.graphics.rotate(-math.pi/2)
					love.graphics.rotate((abegin + aend) / 2 )
					plug.posX, plug.posY = love.graphics.transformPoint(0, 32)
					love.graphics.pop()
					love.graphics.setColor(colorScheme.red[plug.type], colorScheme.green[plug.type], colorScheme.blue[plug.type], 1)
					love.graphics.arc("line", "open", 0, 0, 32, abegin, aend, 30)
					love.graphics.pop()
					plugsDrawnL = plugsDrawnL + 1
				end
			end
		end
		love.graphics.pop()
	end
	if connectingNode ~= nil then
		local mouseX, mouseY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
		love.graphics.push()
		local colorr = colorScheme.red[connectingNode.nodeInternal.plugs[connectingPlug].type]
		local colorg = colorScheme.green[connectingNode.nodeInternal.plugs[connectingPlug].type]
		local colorb = colorScheme.blue[connectingNode.nodeInternal.plugs[connectingPlug].type]
		love.graphics.setColor(colorr, colorg, colorb, 1)
		local tx, ty = love.graphics.inverseTransformPoint(connectingNode.nodeInternal.plugs[connectingPlug].posX, connectingNode.nodeInternal.plugs[connectingPlug].posY)
		love.graphics.line(tx, ty, mouseX, mouseY)
		love.graphics.pop()
	end
	
	love.graphics.setLineWidth(2)
	for i,nodea in ipairs(drawNodes) do
		for plugindex, pluga in pairs(nodea.nodeInternal.plugs) do
			if pluga.connection ~= nil then
				for j,nodeb in ipairs(drawNodes) do
					for plugindex, plugb in pairs(nodeb.nodeInternal.plugs) do
						if plugb == pluga.connection then
							local tx, ty = love.graphics.inverseTransformPoint(pluga.posX, pluga.posY)
							local rx, ry = love.graphics.inverseTransformPoint(plugb.posX, plugb.posY)
							local colorr = colorScheme.red[pluga.type]
							local colorg = colorScheme.green[pluga.type]
							local colorb = colorScheme.blue[pluga.type]
							love.graphics.setColor(colorr, colorg, colorb, 1)
							love.graphics.line(tx, ty, rx, ry)
						end
					end
				end
			end
		end
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
	newNode.selected = true
	text = newNode.nodeInternal.specialText
	drawNodes[#drawNodes + 1] = newNode
end

function addNewNodeMenu ()
	clearOptions()
	local color = 176
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
  
function love.draw()
	love.graphics.clear(0.137, 0.137, 0.137)
	if isInCircularMenu then
		drawCircularMenu()
	else
		camera:set()
		love.graphics.setLineWidth(2)
		--Code goes here
		nodeMouseHandler()
		if love.keyboard.isDown("tab") then
			if not isInCircularMenu then
				newNodeX, newNodeY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
				addNewNodeMenu()
			end
		end
		drawAllNodes()
		camera:unset()
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
