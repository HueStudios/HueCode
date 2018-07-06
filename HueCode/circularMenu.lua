circularMenu = {}

local selectorR = 176
local selectorG = 176
local selectorB = 176
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
function drawCircularMenu ()
	love.graphics.push()
	love.graphics.setLineWidth(4)
	local fullCircle = true
	local numberLeft = 0
	local numberRight = 0
	for i,v in ipairs(options) do
		if v.forceSide == "right" then
			numberRight = numberRight + 1
		elseif v.forceSide == "left" then
			numberLeft = numberLeft + 1
		end
	end
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
	love.graphics.setColor(selectorR, selectorG, selectorB)
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
	love.graphics.setColor(176,63,63, 1)
	for i=1,4,1 do
		love.graphics.line(0,0, 0, size)
		love.graphics.rotate(math.pi/2)
	end
	if inSelect == false then
		if interacted then
			isInCircularMenu = false
		end
	end
	love.graphics.pop()
	local fullCircle = math.pi * 2 
	local offset = (fullCircle/360)*2
	if (numberLeft == 0 or numberRight == 0) then
		--love.graphics.circle("line", 0, 0, radiusToUse)
		local eachDiv = fullCircle / #options
		love.graphics.rotate(math.pi/2)
		for i, v in ipairs(options) do
			local abegin = (i - 1) * eachDiv + offset
			local aend = (i) * eachDiv - offset
			local add = 0
			mouseX, mouseY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
			local angle = math.atan2(mouseY, mouseX)
			--print(angle)
			local radians = angle
			if radians < 0 then
				radians = (math.pi - math.abs(radians)) + math.pi
			end
			if (radians > abegin and radians < aend) and inSelect then
				add = 15 
				selectorR = v.r
				selectorG = v.g
				selectorB = v.b
				if interacted then
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
			if textAngle > 0 and textAngle < math.pi then
				love.graphics.scale(-1, -1)
				love.graphics.translate(0-radiusToUse - 50 - add, -23)
				--love.graphics.rotate(math.pi)
			end
			love.graphics.printf(v.text, 30, 0, radiusToUse - 10 + add, "center")
			love.graphics.pop()
		end
	else
		local radiansPerLeft = math.pi/numberLeft
		local radiansPerRight = math.pi/numberRight
		local optionsDrawnL = 1
		local optionsDrawnR = 1
		for l, v in pairs(options) do
			if v.forceSide == "right" then
				local j = optionsDrawnR
				love.graphics.push()
				love.graphics.rotate(-math.pi/2)
				mouseX, mouseY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
				local angle = math.atan2(mouseY, mouseX)
				--print(angle)
				local radians = angle
				if radians < 0 then
					radians = (math.pi - math.abs(radians)) + math.pi
				end
				local abegin = ((j - 1) * radiansPerRight) + offset
				local aend = ((j) * radiansPerRight) - offset
				local add = 0
				if (radians > abegin and radians < aend) and inSelect then
					add = 15
					selectorR = v.r
					selectorG = v.g
					selectorB = v.b
					if interacted then
						isInCircularMenu = false
						v.callback()
					end
				end
				love.graphics.setColor(v.r, v.g, v.b, 1)
				love.graphics.arc("line", "open", 0, 0, radiusToUse + add, abegin, aend, 30)
				love.graphics.arc("line", "open", 0, 0, 45, abegin + offset, aend - offset, 30)
				eachDiv = radiansPerRight
				love.graphics.push()
				local textAngle = (j-1) * eachDiv + eachDiv / 2
				love.graphics.rotate((j-1) * eachDiv + eachDiv / 2)
				love.graphics.translate(0, -12)
				--if textAngle > math.pi/2 and textAngle < 3*math.pi/2 then
					--love.graphics.scale(-1, -1)
					--love.graphics.translate(0-radiusToUse - 50 - add, -23)
					--love.graphics.rotate(math.pi)
				--end
				love.graphics.printf(v.text, 30, 0, radiusToUse - 10 + add, "center")
				optionsDrawnR = optionsDrawnR + 1
				love.graphics.pop()
				love.graphics.pop()
			else
				local j = optionsDrawnL
				love.graphics.push()
				love.graphics.rotate(math.pi/2)
				mouseX, mouseY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())
				local angle = math.atan2(mouseY, mouseX)
				--print(angle)
				local radians = angle
				if radians < 0 then
					radians = (math.pi - math.abs(radians)) + math.pi
				end
				local abegin = ((j - 1) * radiansPerLeft) + offset
				local aend = ((j) * radiansPerLeft) - offset
				local add = 0
				if (radians > abegin and radians < aend) and inSelect then
					add = 15
					selectorR = v.r
					selectorG = v.g
					selectorB = v.b
					if interacted then
						isInCircularMenu = false
						v.callback()
					end
				end
				love.graphics.setColor(v.r, v.g, v.b, 1)
				love.graphics.arc("line", "open", 0, 0, radiusToUse + add, abegin, aend, 30)
				love.graphics.arc("line", "open", 0, 0, 45, abegin + offset, aend - offset, 30)
				eachDiv = radiansPerLeft
				love.graphics.push()
				local textAngle = (j-1) * eachDiv + eachDiv / 2
				love.graphics.rotate((j-1) * eachDiv + eachDiv / 2)
				love.graphics.translate(0, -12)
				if textAngle > 0 and textAngle < math.pi then
					love.graphics.scale(1, 1)
					love.graphics.translate(0+radiusToUse + 50 + add, 23)
					love.graphics.rotate(math.pi)
				end
				love.graphics.printf(v.text, 30, 0, radiusToUse - 10 + add, "center")
				optionsDrawnL = optionsDrawnL + 1
				love.graphics.pop()
				love.graphics.pop()
			end
		end
	end
	love.graphics.pop()
	interacted = false
end

return circularMenu 