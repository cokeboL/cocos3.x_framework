local ui = require "ui"
local net = require "net"
local toolkit = require "toolkit"
local director = require "director"


local template = {}

-- init module 
function template:initVars()
	self.scene = nil
	self.layer = nil
	self.widget = nil

	self.loadFrameCount = 0
end

function template:getData()
	local msgName = "xxx"
	local msg = "xxxx"
	net:sendMessage(msgName, msg, self.setData)
end

function template.setData(msgName, msg)
	-- xxx
	local self = template

	self:loadScene()
end

function template.loadResource()
	local self = template
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

--[[
function template:onEnter()
	self.widget = ui.binWidget(file)
	--self.widget = ui.jsonWidget(file)
	self.layer:addChild(self.widget)

    schedule(self.loadNode, self.loadResource, 0)
end
--]]

function template:loadScene()
	self.scene = ui.Scene()
	
	self.layer = ui.Layer()
    self.scene:addChild(self.layer)

    --[[
	self.layer:registerScriptHandler(function(eventType)
	    if "enter" == eventType then
	        self:onEnter()
	    end
	end)
	--]]
	
	self.loadNode = ui.Node()
	self.layer:addChild(self.loadNode)
	schedule(self.loadNode, self.loadResource, 0)

    director.runScene(self.scene, self.clear)
end

function template.clear()
	toolkit.clearModule(template)
end

function template:run()	
	-- push loading UI to the running scene
	toolkit.disableTouch()
	
	-- init module base data
	self:initVars()
	
	-- get server data by net
	self:getData()
end

-- ************************************

-- ************************************

return template
