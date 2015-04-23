local ui = require "ui"
local net = require "net"
local toolkit = require "toolkit"
local director = require "director"


local example = {}

-- init module 
function example:initVars()
	self.scene = nil
	self.layer = nil
	self.widget = nil

	self.loadFrameCount = 0
end

function example:getData()
	local msgName = "xxx"
	local msg = "xxxx"
	--net:sendMessage(msgName, msg, self.setData)
end

function example.setData(msgName, msg)
	-- xxx
	local self = example

	self:loadScene()
end

function example.loadResource()
	local self = example
	self.loadFrameCount = self.loadFrameCount + 1

	if self.loadFrameCount == 2 then

	elseif self.loadFrameCount == 4 then

	elseif self.loadFrameCount == 6 then

	elseif self.loadFrameCount == 8 then

	elseif self.loadFrameCount == 10 then
		self.loadNode:removeFromParent()
		toolkit.enableTouch()
	end
end

function example:loadScene()
	self.scene = ui.Scene()
	
	self.layer = ui.Layer()
    self.scene:addChild(self.layer)

	self.loadNode = ui.Node()
	self.layer:addChild(self.loadNode)
	schedule(self.loadNode, self.loadResource, 0)

	toolkit.disableTouch(self.scene)
    director.runScene(self.scene, self.clear)
end

function example.clear()
	--toolkit.unloadLua("example")
end

function example:run()	
	-- push loading UI to the running scene
	toolkit.disableTouch()
	
	-- init module base data
	self:initVars()
	
	-- get server data by net
	self:getData()
end

-- ************************************

-- ************************************

return example
