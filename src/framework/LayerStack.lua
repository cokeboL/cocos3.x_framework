local LayerStack = class("LayerStack", function()
	return cc.Node:create()
end)

local SHOW_CB = "show"
local HIDE_CB = "hide"
function LayerStack:ctor()
	self.idStack = {}
	self.layers = {}
	self.data = {}

	self.currLayer = "empty"

	self:registerScriptHandler(function(event)
        if event == "enter" then
        elseif event == "exit" then
        	self:clear()
        end
    end)
end

function LayerStack:regist(id, layer)
	if type(layer) == 'function' then

	else -- userdata

	end

	self.layers[id] = layer
end

function LayerStack:push(id, data)
	if not self.layers[id] then
		return
	end

	--if type(data) == 'string' then
		--data = json.decode(data)
	--end
	local layer
	local len = #self.idStack
	if len > 0 then
		layer = self.layers[self.idStack[len]]
		layer[HIDE_CB](layer)
	end
	self.idStack[#self.idStack+1] = id
	layer = self.layers[id]
	layer[SHOW_CB](layer, data)
	self.data[id] = data

	self.currLayer = id
end

function LayerStack:pop()
	local len = #self.idStack
	if len > 0 then
		local id = self.idStack[len]
		local layer = self.layers[id]
		layer[HIDE_CB](layer)
		self.idStack[len] = nil
		len = len - 1
	end
	if len > 0 then
		local id = self.idStack[len]
		local layer = self.layers[id]
		layer[SHOW_CB](layer, self.data[id])
		self.currLayer = id
	else
		self.currLayer = "empty"
	end
end

function LayerStack:reset()
	local len = #self.idStack
	if len > 0 then
		local id = self.idStack[len]
		local layer = self.layers[id]
		layer[HIDE_CB](layer)
		len = len - 1
	end

	for i, _ in ipairs(self.idStack) do
		self.idStack[i] = nil
	end
end

function LayerStack:clear()
	self.idStack = nil
	self.layers = nil
	self.data = nil

	self.currLayer = nil

end

return LayerStack
