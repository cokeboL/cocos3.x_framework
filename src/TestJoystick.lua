local TestJoystick = {}

function TestJoystick:createJoystick(r, cb, bgFile, tspFile)
	local joystickCenter = ccui.ImageView:create()
	joystickCenter:loadTexture(tspFile)
	joystickCenter:setAnchorPoint(cc.p(0.5,0.5))

	local joystickBg = ccui.ImageView:create()
	joystickBg:loadTexture(bgFile)
	joystickBg:setAnchorPoint(cc.p(0.5,0.5))
	joystickBg:setTouchEnabled(true)
	joystickBg:addChild(joystickCenter)
	local bgSize = joystickBg:getContentSize()
	joystickCenter:setPosition(bgSize.width/2, bgSize.height/2)

	local x = 0
	local y = 0
	local ratio = 0
	local posBegan = 0
	local posMoved = 0
	local active = false
	local center = cc.p(bgSize.width/2,bgSize.height/2)
	local size = joystickCenter:getContentSize()
	local touchRect = cc.rect(-size.width/2, -size.height/2, size.width, size.height)
    joystickBg:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.began then
			posBegan = sender:getTouchBeganPosition()
        	posBegan = sender:convertToNodeSpace(posBegan)
			joystickCenter:setColor(cc.c3b(150,0,0))
        	joystickCenter:setPosition(posBegan)

        	active = true
        elseif eventType == ccui.TouchEventType.moved then
        	posMoved = sender:getTouchMovePosition()
        	posMoved = sender:convertToNodeSpace(posMoved)
        	x = posMoved.x - center.x
	    	y = posMoved.y - center.y
	    	if not (x*x + y*y <= r*r) then
	    		ratio = (posMoved.y - center.y)/(posMoved.x - center.x)
	    		x = r/math.sqrt(1+ratio*ratio)*x/math.abs(x)
	    		y = x*ratio
	    	end
	    	joystickCenter:setPosition(cc.p(center.x + x,center.y + y))
        elseif eventType == ccui.TouchEventType.ended then
        	joystickCenter:setColor(cc.c3b(255, 255, 255))
        	joystickCenter:setPosition(center)

        	active = false
        elseif eventType == ccui.TouchEventType.canceled then
        	joystickCenter:setColor(cc.c3b(255, 255, 255))
        	joystickCenter:setPosition(center)

        	active = false
        end
    end)
	joystickCenter:scheduleUpdateWithPriorityLua(function(dt)
		if active then
	    	cb(x,y,dt) --如果卡帧可能不平滑，会瞬移
	    	--cb(x,y,0.015) --不瞬移
	    end
	end, 0)

	return joystickBg
end

function TestJoystick:run()
	local center = cc.p(director.width/2,director.height/2)

	local scene = cc.Scene:create()
	local layer = cc.Layer:create()
	
	local sprite = cc.Sprite:create("res/menu1.png")
	sprite:setScale(32/sprite:getContentSize().width)
    sprite:setPosition(center)

    local bg = cc.Sprite:create("map.jpg")

    cc.Director:getInstance():getTextureCache():addImage("res/fixed-ortho-test2.png")
    local tiledMap = cc.TMXTiledMap:create("res/map.tmx")
    local mapSize = bg:getContentSize()
 
    local gid = 0
    local tilePos = 0
    local tileBox = 0
    local tile = false
    local blocks = {}
    local mapGridSize = tiledMap:getMapSize()
    local tileSize = tiledMap:getTileSize()
	local mapLayer = tiledMap:getLayer("blocks")
	for i=1, mapGridSize.width do
		for j=1, mapGridSize.height do
			gid = mapLayer:getTileGIDAt(cc.p(i-1, j-1))
			if gid ~= 0 then
				tile = mapLayer:getTileAt(cc.p(i-1, j-1))
				tilePos = cc.p(tile:getPosition())
				--tileBox = cc.rect(tilePos.x-tileSize.width/2, tilePos.y-tileSize.height/2, tileSize.width, tileSize.height)
				tileBox = cc.rect(tilePos.x, tilePos.y, tileSize.width, tileSize.height)
				blocks[#blocks+1] = tileBox
			end
		end
	end
    
    local radius = 50
    local speed = 100
    local speed2 = 0
    local mapOffset = 0
    local newMapPos = 0
    local preWorldPos = false
    local currWorldPos = false 
    local mapWorldPos = false
    local function updateMapPos()
        currWorldPos = bg:convertToWorldSpace(cc.p(sprite:getPosition()))
        mapWorldPos = cc.p(bg:getPosition())
        mapOffset = currWorldPos.x - center.x
        newMapPos = mapWorldPos.x - mapOffset
        if not ((newMapPos > 0) or (newMapPos < director.width - mapSize.width)) then
            bg:setPositionX(newMapPos)
        end

        mapOffset = currWorldPos.y - center.y
        newMapPos = mapWorldPos.y - mapOffset
        if not ((newMapPos > 0) or (newMapPos < director.height - mapSize.height)) then
            bg:setPositionY(newMapPos)
        end
    end

    local function checkBlock(spRect)
    	for _, rect in pairs(blocks) do
			if cc.rectIntersectsRect(rect, spRect) then
				return true
			end
		end
		return false
    end

    local currx, curry, posx, posy, newPos
    local halfWidth = sprite:getContentSize().width/2*sprite:getScale()
    local halfHeight = sprite:getContentSize().height/2*sprite:getScale()
    local joystick = self:createJoystick(radius, function(x, y, dt)
    	speed2 = speed*math.sqrt(x*x+y*y)/radius
    	if x ~= 0 and y ~= 0 then
	    	local ratio = y/x
	    	x = speed2*dt/math.sqrt(1+ratio*ratio)*x/math.abs(x)
		    y = x*ratio
	    else
	    	if x == 0 then
	    		x, y = 0, speed2 * dt
	    	elseif y == 0 then
	    		x, y = speed2 * dt, 0
	    	else
	    		x, y = 0, 0
	    	end
	    end
	    currx, curry = sprite:getPosition()
	    
	    posx = currx + x
	    if posx < halfWidth then
	    	posx = halfWidth
	    end
	    if posx > mapSize.width-halfWidth then
	    	posx = mapSize.width-halfWidth
	    end

	    posy = curry + y
	    if posy < halfHeight then
	    	posy = halfHeight
	    end
	    if posy > mapSize.height-halfHeight then
	    	posy = mapSize.height-halfHeight
	    end

	    local spRect = cc.rect(posx-halfWidth, posy-halfHeight, halfWidth*2, halfHeight*2)
		if checkBlock(spRect) then
			spRect = cc.rect(currx-halfWidth, posy-halfHeight, halfWidth*2, halfHeight*2)
			if checkBlock(spRect) then
				spRect = cc.rect(posx-halfWidth, curry-halfHeight, halfWidth*2, halfHeight*2)
				if checkBlock(spRect) then
					posx, posy = currx, curry
				else
					posx, posy = posx, curry
				end
			else
				posx, posy = currx, posy
			end
		else

		end

    	sprite:setPosition(cc.p(posx,posy))
    	updateMapPos()
    end, "joystickCircle.png", "joystickMove.png")

    joystick:setPosition(cc.p(60,60))

	bg:setAnchorPoint(cc.p(0,0))
	bg:addChild(sprite)
	layer:addChild(bg)
	layer:addChild(joystick)
	
	scene:addChild(layer)

    director.runScene(scene)
end

return TestJoystick
