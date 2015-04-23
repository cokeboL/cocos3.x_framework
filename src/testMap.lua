local testMap = {}

function testMap:createLayer()
	self.layer = cc.Layer:create()

	self.widget = ccs.GUIReader:getInstance():widgetFromBinaryFile("map_1.csb")
	self.layer:addChild(self.widget)

	self.bloks = {}
	local i=1
	local block
	repeat
		local block  = self.widget:getChildByName("block_" .. i)
		
		if not block then break end

		self.bloks[i] = block:getBoundingBox()
    	block:addTouchEventListener(function(sender,eventType)
    		print("block i on thouched")
	        return true
	    end)
		block:setTouchEnabled(true)		
		print("---- " .. i, self.bloks[i].x, self.bloks[i].y, self.bloks[i].width, self.bloks[i].height)
		i = i+1
	until(not block)

	local currPos, nextPos, targetPos
	local speed = 96
	local speedx, speedy
	local role = cc.Sprite:create("head.png")
	role:setPosition(cc.p(480, 320))
	self.layer:addChild(role)

	local division
	local function getNormSpeedXY()
		division = (targetPos.y - currPos.y) / (targetPos.x - currPos.x)
		speedx = speed/math.sqrt(1+division*division)
		speedy = speedx * division
	end
	local function invalidPos()
		for _, rect in pairs(self.blocks) do
			if cc.rectContainsPoint(rect, nextPos) then
	           return true, rect
	        end
	    end
	    return false
	end
	local function update(dt)
        if targetPos then

			currPos = cc.p(role:getPosition())
			getNormSpeedXY()
			nextPos.x, nextPos.y = currPos.x + speedx, currPos.y + speedy
			print("xxx ", currPos.x, currPos.y, nextPos.x, nextPos.y)
			if invalidPos() then

			else
				role:setPosition(nextPos)
			end
        end
        currPos = false
        nextPos = false
        print("------ update ", targetPos)
    end
    role:scheduleUpdateWithPriorityLua(update, 0)
	
	self.widget:setTouchEnabled(true)
	self.widget:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
        	targetPos = sender:getTouchEndPosition()
        	print("pannel on touch ", targetPos.x, targetPos.y)
        elseif eventType == ccui.TouchEventType.canceled then
        end        
    end)

	return self.layer
end

function testMap:run()
	self.scene = cc.Scene:create()
	self.scene:addChild(self:createLayer())

	cc.Director:getInstance():runWithScene(self.scene)
end

return testMap