local frameCache = cc.SpriteFrameCache:getInstance()

local toolkit = {}

function toolkit.clearModule(m)
    for k, v in pairs(m) do
        if type(v) ~= 'function' then
            m[k] = nil
        end
    end
    --cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end

function toolkit.enableTouch()
    local running = cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax)
        if mask then
            mask:removeFromParent()
        end
    end
end

function toolkit.disableTouch(scene)
    local running = scene or cc.Director:getInstance():getRunningScene()
    if running then
    	local mask = running:getChildByTag(constant.zorderMax)
    	if not mask then
        	running:addChild(ui.maskLayer(), constant.zorderMax, constant.zorderMax)
        end
    end
end

function toolkit.finishLoading()
    local running = cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax-1)
        if mask then
            mask:removeFromParent()
        end
    end
end

function toolkit.startLoading(scene)
    local running = scene or cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax-1)
        if not mask then
            mask = ui.maskLayer()
            --[[
            local cache = cc.SpriteFrameCache:getInstance()
            cache:addSpriteFrames("loading.plist")
            local loadingSP = cc.Sprite:createWithSpriteFrame(cache:getSpriteFrame(string.format("reading_1.jpg")))
            --]]
           
            --[[
            loadingSP = ui.Sprite("loading_1.png")
            loadingSP:setPosition(cc.p(300, 320))
            loadingSP:runAction(cc.RepeatForever:create(cc.RotateBy:create(3, 360)))
            loadingSP:setVisible(false)
            --]]
            loadingSP = ui.Sprite("loading_2.png")
            loadingSP:setPosition(director.center)
            --loadingSP:setVisible(false)
            loadingSP:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.5, 360)))

            local size = loadingSP:getContentSize()
            local text = ui.Text()
            text:setFontSize(36)
            text:setAnchorPoint(cc.p(0, 0.5))
            text:setString("连接中...")
            text:setPosition(cc.p(size.width/2 + director.center.x, director.center.y))
            --text:setVisible(false)

            --[[
            scheduleOnce(mask, function()
                loadingSP:setVisible(true)
                text:setVisible(true)
            end, 0.5)
            --]]

            --[[
            local cache = cc.SpriteFrameCache:getInstance()
            cache:addSpriteFrames("loading.plist")

            local loadingSP = cc.Sprite:createWithSpriteFrame(cache:getSpriteFrame(string.format("reading_1.jpg")))
            local animFrames = {}
            for i=1, 8 do 
                local frame = cache:getSpriteFrame(string.format("reading_%d.jpg", i))
                animFrames[i] = frame
            end
            local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.3)
            loadingSP:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.RepeatForever:create(cc.Animate:create(animation))))
            --]]
            mask:addChild(loadingSP)
            mask:addChild(text)

            running:addChild(mask, constant.zorderMax-1, constant.zorderMax-1)
        end
    end
end

function toolkit.finishLoading2()
    local running = cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax-2)
        if mask then
            mask:removeFromParent()
        end
    end
end

function toolkit.startLoading2(scene)
    local running = scene or cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax-2)
        if not mask then
            running:addChild(ui.maskLayer(), constant.zorderMax-2, constant.zorderMax-2)
        end
    end
end

function toolkit.finishLoading3()
    local running = cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax-3)
        if mask then
            mask:removeFromParent()
        end
    end
end

function toolkit.startLoading3(scene)
    local running = scene or cc.Director:getInstance():getRunningScene()
    if running then
        local mask = running:getChildByTag(constant.zorderMax-3)
        if not mask then
            running:addChild(ui.maskLayer(), constant.zorderMax-3, constant.zorderMax-3)
        end
    end
end

function toolkit.pushMsg(msg, callback)
    local running = cc.Director:getInstance():getRunningScene()
    if running then
        msgBox = ui.messageBox(msg, callback)
        running:addChild(msgBox, constant.zorderMax-4, constant.zorderMax-4)
    end
end

function toolkit.bind(sprite, attr, super)
    local t = clone(attr)
    tolua.setpeer(sprite, t)
    if super then
    	setmetatable(t, super)
	end
    return sprite
end

function toolkit.reloadLuaFile(file)
    package.loaded[file]  = nil
    return require(file)
end

function toolkit.addSpriteFrames(file)
    frameCache:addSpriteFramesWithFile(file)
end

--[[
local language = require "cfg/language"
function language.get(key)
    return language[key].value
end
--]]

function fnull()
end

local function generateBits()
    local bits = {}
    for i=1, 32 do
        bits[i] = math.pow(2, (i-1))
    end
    return function(num)
        local signBits = {}
        --local subCount = 0
        local signSum = 0
        for i=1, 32 do
            if i ~= 32 then
                signBits[i] = num % bits[i+1]
                signBits[i] = signBits[i] - signSum
                signSum = signSum + signBits[i]
            else
                signBits[i] = num - signSum
            end
            if signBits[i] ~= 0 then
                signBits[i] = 1
            end
        end
        return signBits
    end
end

--[[ eg.
a = 0xf0000f0f
local bs = getBits(a)
for i=1, 32 do
    print(i, bs[i])
end
--]]
toolkit.getBits = generateBits()

function toolkit.setShader(node, file)
    local shader = cc.GLProgram:createWithByteArrays(file)
    node:setGLProgram(shader)
end

return toolkit