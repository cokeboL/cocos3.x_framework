local update = {}

function update:run()
	local scene = cc.Scene:create()
	local layer = cc.Layer:create()
	scene:addChild(layer)

    

	local text = ccui.Text:create()
	text:setString("Downloading")
	text:setPosition(cc.p(240, 160))
	layer:addChild(text)

	local net = NetMgr:getInstance()

	local pathToSave = createDownloadDir()
	local assetsManager = cc.AssetsManager:new(" ", " ", pathToSave)
    assetsManager:retain()

	local updateList = {}
	local downloadedNum = 0

	local function setAssetsManager(packageUrl, versionUrl, savePath)
	    assetsManager:setPackageUrl(packageUrl)
	end

	local function update()
        text:setString("")
        setAssetsManager(updateList[1].url)
        assetsManager:update()
    end

	local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            text:setString("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            text:setString("network error")
        end
    end

    local function onProgress( percent )
        local progress = string.format("downloading %d%%",percent)
        text:setString(progress)
    end

    local function onSuccess()
    	downloadedNum = downloadedNum + 1
    	print("update package ", downloadedNum)
        text:setString("downloading ok")
        table.remove(updateList, 1)
        if #updateList > 0 then
	        update()
	    else
	    	--[[
            local scene2 = cc.Scene:create()
	    	local sprite = BlurSprite:create("res/farm.jpg")
	    	sprite:setPosition(cc.p(480/2, 320/2))

	    	local layer2 = cc.Layer:create()
    		layer2:addChild(sprite)
    		scene2:addChild(layer2)
	    	cc.Director:getInstance():replaceScene(scene2)
            --]]
	    	local binPath = "xxx.zip"
	    	uncompress(binPath)

            schedule(layer, function()
                local done = cc.UserDefault:getInstance():getBoolForKey("uncompressed", false)
                if done then
                    require "test"
                    --text:setString("xxxxxxxxxxxxxxxx")
                    --layer:stopAllActions()
                end
                print("done:::::::: ", done)
            end, 0.1)

            print("000000xxxxxxxxxxxxxxxxxxxxxx")
            
	    end
	    
    end

    assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
    assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
    assetsManager:setConnectionTimeout(10)

	local function onNodeEvent(msgName)
        if event == "enter" then
        	deleteDownloadDir(pathToSave)
	        assetsManager():deleteVersion()
	        createDownloadDir()
        elseif event == "exit" then
            assetsManager:release()
        end
    end
    layer:registerScriptHandler(onNodeEvent)

    local versionlist = "http://127.0.0.1:3001/versionlist"
    net:httpGet(versionlist, function(ok, ret)
    	if ok then
    		---[[
    		local currVersion = tonumber(cc.UserDefault:getInstance():getStringForKey("version", "90"))
		    local versions = json.decode(ret)
		    for k, v in pairs(versions) do
    			print("-- ", k, v)
    		end
		    for _, v in pairs(versions) do
				if v.version > currVersion then
					updateList[#updateList+1] = v
				end
			end
			if #updateList > 0 then
				update()
			end
			--]]
    	else
    		print(ok)
            onSuccess()
    	end
    	---[[
        --uncompress("xxx.zip")

        --]]
    end)
	
    --uncompress("xxx.zip")

    print("0000000000000000000000000")
    print(":::::::: ", cc.FileUtils:getInstance():getWritablePath())
    cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath() .. "script")

	cc.Director:getInstance():runWithScene(scene)
end

return update
