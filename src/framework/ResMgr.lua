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
local strByte = string.byte
local strChar = string.char

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

function ResMgr:getCCSArmatureFile(model)
	local file
	for _, v in ipairs(armatureTailTypes) do
		file = fileUtils:fullPathForFilename(resRoot .. model .. "/" .. model .. v)
		if strLen(file) > 0 then
			break
		end
	end

	return file
end

function ResMgr:getSpineTextureFiles(file, flag)
	local item
	local textures = {}
	local i = strLen(file)
	while strChar(strByte(file, i)) ~= '/' do
		i = i-1
		if i == 1 then break end
	end
	local dir = strSub(file, 1, i)
	local function _xx(s)
		local idx = strFind(s, ".png")
		
		if not idx then return end
		
		local subS = strSub(s, 1, idx+3)

		local j = -1
		while strChar(strByte(subS, j)) ~= '\n' do
			j = j-1
		end
		subS = strSub(subS, j+1)
		
		item = {}
		item.file = dir .. subS
		item.flag = flag
		textures[#textures+1] = item
		
		_xx(strSub(s, idx+4))
	end
	
	local str = fileUtils:getStringFromFile(file)
	_xx(str)
	
	return textures
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
images = 
{
	[1] = 
	{
		file="res/xxx1.png",
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},

	[2] = 
	{
		model="res/xxx2.pvr.ccz",
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

	if type(images) == 'table' then
		for _, v in ipairs(images) do
			self.images[#self.images+1] = v
		end
	end
end

--[[
function addPlist
arg: 
plists = 
{
	[1] = 
	{
		file="res/ui.plist",
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},

	[2] = 
	{
		model="res/ui2.plist",
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

	if type(plists) == 'table' then
		for _, v in ipairs(plists) do
			self.plists[#self.plists+1] = v
		end
	end
end

--[[
function addCCSArmatures
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
	resMgr:addCCSArmatures({{model="BaiTu",flag=true}, {model="dabaitu",flag=false}})
	layer:addChild(resMgr)
]]
function ResMgr:addCCSArmatures(armatures)
	self.armatures = self.armatures or {}

	if type(armatures) == 'table' then
		for _, v in ipairs(armatures) do
			self.armatures[#self.armatures+1] = v
		end
	end
end

--[[
function addSpineImages
arg: 
spImages = 
{
	[1] = 
	{
		file="res/spine/spineboy.atlas",
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},

	[2] = 
	{
		model="res/spine/spineboy2.atlas",
		flag=true/false -- true: clear when exit, false/nil: not clear when exit
	},
	...
}
example: 
	local resMgr = ResMgr.new()
	resMgr:addImages({{file="res/spine/spineboy.atlas",flag=true}, {file="res/spine/spineboy2.atlas",flag=false}})
	layer:addChild(resMgr)
]]
function ResMgr:addSpineImages(atlasFiles)
	self.spineImages = self.spineImages or {}

	if type(atlasFiles) == 'table' then
		local textures
		for _, v in ipairs(atlasFiles) do
			textures = self:getSpineTextureFiles(v.file, v.flag)
			for _, tfile in ipairs(textures) do
				self.spineImages[#self.spineImages+1] = tfile
			end
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

function ResMgr:addCCSArmaturePlist(model, flag)
	for i=0, 10 do
		local pfile = fileUtils:fullPathForFilename(resRoot .. model .. "/" .. model .. i .. plistTail)
		if strLen(pfile) > 0 then
			local plistItem = {}
			plistItem.file = pfile
			plistItem.flag = flag
			local tfile = self:getTextureFile(pfile)
			if strLen(tfile) > 0 then
				plistItem.tfile = tfile
				self.ccsArmaturePlists[#self.ccsArmaturePlists+1] = plistItem
			end
		else
			break
		end
	end
end



function ResMgr:loadCCSArmatures(cb)
	if (not self.ccsArmatures) or (type(self.ccsArmatures) ~= 'table') or (#self.ccsArmatures == 0) then
		cb()
		return
	end

	self.ccsArmaturePlists = self.ccsArmaturePlists or {}

	local sum = #self.ccsArmatures

	local function loadCount()
		sum = sum - 1
		if sum == 0 then
			cb()
		end
	end
	
	
	for _, item in ipairs(self.ccsArmatures) do
		item.file = self:getCCSArmatureFile(item.model)
		armatureDataMgr:addArmatureFileInfoAsync(item.file, loadCount)

		self:addCCSArmaturePlist(item.model, item.flag)
	end
	
end


function ResMgr:loadSpineImages(cb)
	if (not self.spineImages) or (type(self.spineImages) ~= 'table') or (#self.spineImages == 0) then
		cb()
		return
	end

	local sum = #self.spineImages

	local function loadCount(texture)
		sum = sum - 1
		if sum == 0 then
			cb()
		end
	end

	for _, item in ipairs(self.spineImages) do
		textureCache:addImageAsync(item.file, loadCount)
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
	self:loadSpineImages(onloaded)
	self:loadPlists(onloaded)
	self:loadCCSArmatures(onloaded)
end

function ResMgr:clearArmatures()
	if self.ccsArmatures then
		for _, item in ipairs(self.ccsArmatures) do
			if item.flag then
				armatureDataMgr:removeArmatureFileInfo(item.file)
			end
		end
	end
end

function ResMgr:clearPlists()
	if self.plists then
		for _, item in ipairs(self.plists) do
			if item.flag then
				frameCache:removeSpriteFramesFromFile(item.file)
				if item.tfile then
					textureCache:removeTextureForKey(item.tfile)
				end
			end
		end
	end
	if self.ccsArmaturePlists then
		for _, item in ipairs(self.ccsArmaturePlists) do
			if item.flag then
				frameCache:removeSpriteFramesFromFile(item.file)
				if item.tfile then
					textureCache:removeTextureForKey(item.tfile)
				end
			end
		end
	end
end

function ResMgr:clearImages()
	if self.images then
		for _, item in ipairs(self.images) do
			if item.flag then
				textureCache:removeTextureForKey(item.file)
			end
		end
	end
end

function ResMgr:clearSpineImages()
	if self.spineImages then
		for _, item in ipairs(self.spineImages) do
			if item.flag then
				textureCache:removeTextureForKey(item.file)
				
			end
		end
	end
end

function ResMgr:clear()
	self:clearArmatures()
	self:clearPlists()
	self:clearImages()
	self:clearSpineImages()
end

return ResMgr
