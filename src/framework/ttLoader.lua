local fileUtils = cc.FileUtils:getInstance()
local frameCache = cc.SpriteFrameCache:getInstance()
local textureCache = cc.TextureCache:getInstance()

local ttLoader = 
{
	loadingNum = 0,
}

ttLoader.images = {}
ttLoader.plists = {}

function ttLoader.ok()
	return ttLoader.loadingNum == 0
end

function ttLoader:loadImages(files)	
	if type(files) == 'string' then
		files = { [1] = files }
	end
	
	if type(files) ~= 'table' then
		return
	end
	
	for _, file in pairs(files) do
		self.images[#self.images+1] = file
		self.loadingNum = self.loadingNum + 1
	end
		
	local file
	local function load_()
		if #self.images > 0 then
			self.loadingNum = self.loadingNum - 1
			file = self.images[1]
			table.remove(self.images, 1)
			
			local tfile = fileUtils:fullPathForFilename(file .. ".png")
			if not tfile then
				tfile = fileUtils:fullPathForFilename(file .. ".pvr.ccz")
			end
			local function onTxextureLoaded(texture)
				load_()
			end
			if tfile then
				textureCache:addImageAsync(tfile, onTxextureLoaded)
			else
				load_()
			end
		else
			if callback then
				callback()
			end
		end
	end
	load_()
end

function ttLoader:loadPlists(files, callback)	
	if type(files) == 'string' then
		files = { [1] = files }
	end
	
	if type(files) ~= 'table' then
		return
	end
	
	for _, file in pairs(files) do
		self.plists[#self.plists+1] = file
		self.loadingNum = self.loadingNum + 1
		--print("------- load texture: ", file)
	end
		
	local file
	local function load_()
		
		if #self.plists > 0 then
			self.loadingNum = self.loadingNum - 1
			file = self.plists[1]
			table.remove(self.plists, 1)

			local pfile = fileUtils:fullPathForFilename(file .. ".plist")
			local tfile = fileUtils:fullPathForFilename(file .. ".png")
			if not tfile then
				tfile = fileUtils:fullPathForFilename(file .. ".pvr.ccz")
			end
			local function onTxextureLoaded(texture)
				frameCache:addSpriteFrames(pfile, texture);
				load_()
			end
			if pfile and tfile then
				textureCache:addImageAsync(tfile, onTxextureLoaded)
			else
				load_()
			end
		else
			if callback then
				callback()
			end
		end
	end
	load_()
end

return ttLoader