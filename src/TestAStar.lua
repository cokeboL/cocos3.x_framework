local TestAStar = {}

local beginNode = false
local endNode = false
function TestAStar:run()
    local scene = cc.Scene:create()
    local layer = cc.Layer:create()

    cc.TextureCache:getInstance():addImage("res/fixed-ortho-test2.png")
    
    --local tiledMap = cc.TMXTiledMap:create("res/map.tmx")
    --local tileNum = tiledMap:getMapSize()

    local tiledMap = cc.TMXTiledMap:create("res/map.tmx")
    tiledMap:retain()

    local map = cc.Sprite:create("res/map.jpg")
    map:setAnchorPoint(cc.p(0,0))
    map:setPosition(cc.p(0,0))
    
    local tileSize = tiledMap:getTileSize()
    local mapSize = tiledMap:getContentSize()

    local center = cc.p(director.width/2,director.height/2+tileSize.height/2)
    local sprite = cc.Sprite:create("res/menu1.png")
    sprite:setScale(32/sprite:getContentSize().width)
    sprite:setPosition(center)
    
    local x = 0
    local y = 0
    local disx = 0
    local disy = 0
    local speed = 50
    local speedx = 0
    local speedy = 0  
    local preWorldPos = false
    local currWorldPos = false 
    local mapWorldPos = false
    local target = false
    local targets = false
    local xArived = false
    local yArived = false
    local xcentered = false
    local ycentered = false
    local angle = 0

    ---[[
    local function nextTarget()
        speedx, speedy = 0, 0
        xArived, yArived = false, false
        if #targets > 0 then
            local currx, curry = sprite:getPosition()
            target = targets[1]
            table.remove(targets, 1)
            
            disx, disy = target.x-currx, target.y-curry
            if disx == 0 then
                if disy >= 0 then
                    speedx, speedy = 0, speed
                else
                    speedx, speedy = 0, -speed
                end
                return
            elseif disy == 0 then
                if disx >= 0 then
                    speedx, speedy = speed, 0
                else
                    speedx, speedy = -speed, 0
                end
                return
            end
            speedx = speed/math.sqrt(1+math.pow(disy/disx, 2))*(disx/math.abs(disx))
            speedy = speedx*(disy/disx)
        else
            target = false
            targets = false
        end
    end
    --]]

    --[[
    local function nextTarget()
        speedx, speedy = 0, 0
        xArived, yArived = false, false
        if #targets > 0 then
            local currx, curry = sprite:getPosition()
            target = targets[1]
            table.remove(targets, 1)
            if target.x ~= currx then
                speedx = speed*(target.x - currx)/math.abs(target.x - currx)
            elseif target.y ~= curry then
                speedy = speed*(target.y - curry)/math.abs(target.y - curry)
            end
        else
            target = false
            targets = false
        end
    end
    --]]

    local mapOffset = 0
    local newMapPos = 0
    local function updateMapPos()
        currWorldPos = map:convertToWorldSpace(cc.p(sprite:getPosition()))
        mapWorldPos = cc.p(map:getPosition())
        mapOffset = currWorldPos.x - center.x
        newMapPos = mapWorldPos.x - mapOffset
        if not ((newMapPos > 0) or (newMapPos < 480 - mapSize.width)) then
            map:setPositionX(newMapPos)
        end

        mapOffset = currWorldPos.y - center.y
        newMapPos = mapWorldPos.y - mapOffset
        if not ((newMapPos > 0) or (newMapPos < 320 - mapSize.height)) then
            map:setPositionY(newMapPos)
        end
    end

    local astar = AStar:getInstance()
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(function (event, x, y)
        if event == "ended" then
            local posx, posy = sprite:getPosition()
            local touchPos = map:convertToNodeSpace(cc.p(x,y))
            if astar:findPath(tiledMap, posx, posy, touchPos.x, touchPos.y) then
                targets = astar:getPath()
                for k,v in pairs(targets) do
                    print("path ", k, v.x, v.y)
                end
                nextTarget()
                if beginNode then
                    beginNode:removeFromParent()
                    endNode:removeFromParent()
                end
                beginNode = cc.DrawNode:create()
                endNode = cc.DrawNode:create()
                beginNode:drawPoint(targets[1], 10, cc.c4f(1,0,0,1))
                endNode:drawPoint(targets[#targets], 10, cc.c4f(1,0,0,1))
                map:addChild(beginNode)
                map:addChild(endNode)
            end
        end
        return true
    end)
    
    sprite:scheduleUpdateWithPriorityLua(function(dt)
        if target then
            preWorldPos = map:convertToWorldSpace(cc.p(sprite:getPosition()))
            x, y = sprite:getPosition()
            
            if speedx > 0 then
                x = x + speedx * dt
                if x >= target.x then
                    x = target.x
                    xArived = true
                end
            elseif speedx < 0 then
                x = x + speedx * dt
                if x <= target.x then
                    x = target.x
                    xArived = true
                end
            else
                xArived = true
            end

            if speedy > 0 then
                y = y + speedy * dt
                if y >= target.y then
                    y = target.y
                    yArived = true
                end
            elseif speedy < 0 then
                y = y + speedy * dt
                if y <= target.y then
                    y = target.y
                    yArived = true
                end
            else
                yArived = true
            end
            
            sprite:setPosition(cc.p(x,y))

            if xArived and yArived then
                nextTarget()
            end

            updateMapPos()
        end
    end, 0)

    --[[
    sprite:scheduleUpdateWithPriorityLua(function(dt)
        if target then
            preWorldPos = map:convertToWorldSpace(cc.p(sprite:getPosition()))
            x, y = sprite:getPosition()
            
            if speedx ~= 0 then
                x = x + speedx * dt
                if speedx >= 0 then
                    if x >= target.x then
                        x = target.x
                        xArived = true
                    end
                else
                    if x <= target.x then
                        x = target.x
                        xArived = true
                    end
                end
            else
                xArived = true
            end

            if speedy ~= 0 then
                y = y + speedy * dt
                if speedy >= 0 then
                    if y >= target.y then
                        y = target.y
                        yArived = true
                    end
                else
                    if y <= target.y then
                        y = target.y
                        yArived = true
                    end
                end
            else
                yArived = true
            end
            
            sprite:setPosition(cc.p(x,y))

            if xArived and yArived then
                nextTarget()
            end

            updateMapPos()
        end
    end, 0)
    --]]

	map:addChild(sprite)
	layer:addChild(map)
	scene:addChild(layer)

    director.runScene(scene)
end

return TestAStar