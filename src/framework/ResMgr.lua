local ResMgr = class("ResMgr", function()
	return cc.Node:create()
end)


local fileUtils = cc.FileUtils:getInstance()
local frameCache = cc.SpriteFrameCache:getInstance()
local textureCache = cc.TextureCache:getInstance()
local armatureDataMgr = ccs.ArmatureDataManager:getInstance()

local strLen = string.len
local strSub = string.sub
local strFind = string.find

-- ** ****************************************************************
-- **  modify this config and functions
-- ** ****************************************************************
local resRoot = "res/"
local plistTail = ".plist"

local textureTailTypes = 
{
	"png",
	"pvr.ccz",
	"jpg",
}

local armatureTailTypes =
{
	".ExportJson",
	".csb",
}

function ResMgr:getTextureFile(pfile)
	local tfile
	for _, v in ipairs(textureTailTypes) do
		tfile = strSub(pfile, 1, strFind(pfile, ".plist")) .. v
		tfile = fileUtils:fullPathForFilename(tfile)
		if strLen(tfile) > 0 then
			break
		end
	end

	return tfile
end

function ResMgr:getArmatureFile(model)
	local file
	for _, v in ipairs(armatureTailTypes) do
		file = fileUtils:fullPathForFilename(resRoot .. model .. "/" .. model .. v)
		if strLen(file) > 0 then
			break
		end
	end

	return file
end
-- ****************************************************************

function ResMgr:ctor()
	self:registerScriptHandler(function(event)
        if event == "enter" then
        	self:load()
        elseif event == "exit" then
        	self:clear()
        end
    end)
end


--[[
function addImages
arg: 
armatures = 
{
	[1] = 
	{
		file="res/ui.plist",
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},

	[2] = 
	{
		model="Xiaolongnv",  -- res/Xiaolongnv/Xiaolongnv.csb"
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},
	...
}
example: 
	local resMgr = ResMgr.new()
	resMgr:addImages({{file="res/ui.png",flag=true}, {file="res/ui2.png",flag=false}})
	layer:addChild(resMgr)
]]
function ResMgr:addImages(images)
	self.images = self.images or {}

	if type(images) == 'string' then
		self.images[#self.images+1] = images
	elseif type(images) == 'table' then
		for _, v in ipairs(images) do
			self.images[#self.images+1] = v
		end
	end
end

--[[
function addPlist
arg: 
armatures = 
{
	[1] = 
	{
		file="res/ui.plist",
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},

	[2] = 
	{
		model="Xiaolongnv",  -- res/Xiaolongnv/Xiaolongnv.csb"
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},
	...
}
example: 
	local resMgr = ResMgr.new()
	resMgr:addPlist({{file="res/ui.plist",flag=true}, {file="res/ui.plist",flag=false}})
	layer:addChild(resMgr)
]]
function ResMgr:addPlist(plists)
	self.plists = self.plists or {}

	if type(plists) == 'string' then
		self.plists[#self.plists+1] = plists
	elseif type(plists) == 'table' then
		for _, v in ipairs(plists) do
			self.plists[#self.plists+1] = v
		end
	end
end

--[[
function addArmatures
arg: 
armatures = 
{
	[1] = 
	{
		model="DabaiTu",  -- res/DabaiTu/DabaiTu.ExportJson"
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},

	[2] = 
	{
		model="Xiaolongnv",  -- res/Xiaolongnv/Xiaolongnv.csb"
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},
	...
}
example: 
	local resMgr = ResMgr.new()
	resMgr:addArmatures({{model="BaiTu",flag=true}, {model="dabaitu",flag=false}})
	layer:addChild(resMgr)
]]
function ResMgr:addArmatures(armatures)
	self.armatures = self.armatures or {}

	if type(armatures) == 'string' then
		self.armatures[#self.armatures+1] = armatures
	elseif type(armatures) == 'table' then
		for _, v in ipairs(armatures) do
			self.armatures[#self.armatures+1] = v
		end
	end
end


function ResMgr:setListener(listener)
	self.listener = listener
end

function ResMgr:loadImages(cb)
	if (not self.images) or (type(self.images) ~= 'table') or (#self.images == 0) then
		cb()
		return
	end

	local sum = #self.images

	local function loadCount(texture)
		sum = sum - 1
		if sum == 0 then
			cb()
		end
	end

	for _, item in ipairs(self.images) do
		textureCache:addImageAsync(item.file, loadCount)
		print("----- add image: ", item.file)
	end
end


function ResMgr:loadPlists(cb)
	if (not self.plists) or (type(self.plists) ~= 'table') or (#self.plists == 0) then
		cb()
		return
	end

	local tfile
	local sum = #self.plists

	for _, item in ipairs(self.plists) do
		local pfile = item.file
		item.tfile = self:getTextureFile(pfile)
		if strLen(item.tfile) > 0 then
			textureCache:addImageAsync(item.tfile, function(texture)
				frameCache:addSpriteFrames(pfile, texture)
				print("----- add plist: ", pfile, item.tfile)
				sum = sum - 1
				if sum == 0 then
					cb()
				end
			end)
		else
			sum = sum - 1
			if sum == 0 then
				cb()
			end
		end
	end
end

function ResMgr:addArmaturePlist(model)
	for i=0, 10 do
		local pfile = fileUtils:fullPathForFilename(resRoot .. model .. "/" .. model .. i .. plistTail)
		if strLen(pfile) > 0 then
			local plistItem = {}
			plistItem.file = pfile
			
			local tfile = self:getTextureFile(pfile)
			if strLen(tfile) > 0 then
				plistItem.tfile = tfile
				self.armaturePlists[#self.armaturePlists+1] = plistItem
			end
		else
			break
		end
	end
end



function ResMgr:loadArmatures(cb)
	if (not self.armatures) or (type(self.armatures) ~= 'table') or (#self.armatures == 0) then
		cb()
		return
	end

	self.armaturePlists = self.armaturePlists or {}

	local sum = #self.armatures

	local function loadCount()
		sum = sum - 1
		if sum == 0 then
			cb()
			for _, v in ipairs(self.armaturePlists) do

			end
		end
	end
	
	
	for _, item in ipairs(self.armatures) do
		item.file = self:getArmatureFile(item.model)
		armatureDataMgr:addArmatureFileInfoAsync(item.file, loadCount)

		self:addArmaturePlist(item.model)
		print("----- add armature: ", item.file)
	end
	
end

function ResMgr:load()
	local needLoad = 3
	local function onloaded()
		needLoad = needLoad - 1
		if needLoad == 0 and self.listener then
			self.listener()
		end
	end
	self:loadImages(onloaded)
	self:loadPlists(onloaded)
	self:loadArmatures(onloaded)
end

function ResMgr:clearArmatures()
	if self.armatures then
		for _, item in ipairs(self.armatures) do
			if item.flag then
				armatureDataMgr:removeArmatureFileInfo(item.file)
				print("----- remove armature: ", item.file)
			end
		end
	end
end

function ResMgr:clearPlists()
	if self.plists then
		for _, item in ipairs(self.plists) do
			frameCache:removeSpriteFramesFromFile(item.file)
			if item.tfile then
				textureCache:removeTextureForKey(item.tfile)
				print("----- remove plist: ", item.file, item.tfile)
			end
		end
	end
	if self.armaturePlists then
		for _, item in ipairs(self.armaturePlists) do
			frameCache:removeSpriteFramesFromFile(item.file)
			if item.tfile then
				textureCache:removeTextureForKey(item.tfile)
				print("----- remove armaturePlists: ", item.file, item.tfile)
			end
		end
	end
end

function ResMgr:clearImages()
	if self.images then
		for _, item in ipairs(self.images) do
			if item.flag then
				textureCache:removeTextureForKey(item.file)
				print("----- remove image: ", item.file)
			end
		end
	end
end

function ResMgr:clear()
	self:clearArmatures()
	self:clearPlists()
	self:clearImages()
end

return ResMgr
