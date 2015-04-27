local MainUILayer = class("MainUILayer", function(delegate, data)
	return cc.Layer:create()
end)

local _images = 
{
	{
		file="res/fixed-ortho-test2.png",
		flag=true
	},
	{
		file="res/fixed-ortho-test2.png",
		flag=true
	}
}

local _plists = 
{
	{
		file="res/ui.plist",
		flag=true
	},
	{
		file="res/ui.plist",
		flag=true
	}
}

local _spineImages = 
{
	{
		file="res/spine/spineboy.atlas",
		flag=true
	},
	{
		file="res/spine/goblins-ffd.atlas",
		flag=false
	}
}

local _ccsArmatures =
{
	{
		model="BaiTu",
		flag=true
	},
	{
		model="dabaitu",
		flag=false
	}
}

function MainUILayer:ctor(delegate, data)
	self.delegate = delegate
	self.data = data

	self:onShow()
end

function MainUILayer:onShow()
	if ModuleCtrl.MainUIResAsyncLoad and (not self.resMgr) then
		self:loadRes()
	else
		self:showUI()
	end
	self:setPosition(cc.p(0,0))
	self:setTouchEnabled(true)
end

function MainUILayer:onHide()
	self:setPosition(director.out)
	self:setTouchEnabled(false)
end

function MainUILayer:loadRes()
	print("---- MainUILayer:loadRes()")
	self.resMgr = ResMgr.new()
	self.resMgr:setLoadType(false)
	self.resMgr:addImages(_images)
	self.resMgr:setListener(function()
		self.resMgr2 = ResMgr.new()
		--self.resMgr2:setLoadType()
		self.resMgr2:addPlist(_plists)
		self.resMgr2:addSpineImages(_spineImages)
		self.resMgr2:addCCSArmatures(_ccsArmatures)
		self.resMgr2:setListener(function()
			self.allResLoaded = true
		end)
		self.resMgr2:load()
		self:addChild(self.resMgr2)
		self:showUI()
	end)
	self.resMgr:load()
	self:addChild(self.resMgr)
end

function MainUILayer:showUI()
	print("---- MainUILayer:showUI()")
	--local widget = ccs.GUIReader:getInstance():widgetFromBinaryFile("NewUi_1.csb")
	--self:addChild(widget)
end

return MainUILayer