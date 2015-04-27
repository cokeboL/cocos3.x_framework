local MainScene = class("MainScene", function(data)
	return cc.Scene:create()
end)

local MainUI = require("Scene/Main/MainUI/MainUILayer")
local Chat = require("Scene/Main/Chat/ChatLayer")
local Card = require("Scene/Main/Card/CardLayer")
local Fight = require("Scene/Main/Fight/FightLayer")

function MainScene:ctor(data)
	self.data = data

	self.mainUI = MainUI.new(self, data)
	---[[
	self.card = Chat.new(self, data)
	self.chat = Card.new(self, data)
	self.fight = Fight.new(self, data)
	--]]

	self:addChild(self.mainUI)
	---[[
	self:addChild(self.card)
	self:addChild(self.chat)
	self:addChild(self.fight)
	--]]
	print("----------- MainScene")
end

function MainScene:run()
	director.runScene(self)
end

return MainScene