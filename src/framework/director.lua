local director = {}

director.winSize = cc.Director:getInstance():getWinSize()
director.leftTop = cc.p(2, director.winSize.height-2)
director.left = cc.p(-director.winSize.width, 0)
director.right = cc.p(director.winSize.width, 0)
director.center = cc.p(director.winSize.width/2, director.winSize.height/2)
director.width = director.winSize.width
director.height = director.winSize.height
director.out = cc.p(1000000,1000000)

function director.runScene(scene, releaseCallback, notFade)
	--local scene = util.Scene()
	--layer:addChild(statusBar.getLayer(), 1)
	--scene:addChild(layer)

	local running = cc.Director:getInstance():getRunningScene()
	if(not running)then
		cc.Director:getInstance():runWithScene(scene)
	else
		if notFade then

		else
			scene = cc.TransitionFade:create(constant.transitionTime, scene)
		end
		--running:addChild(ui.maskLayer())
		cc.Director:getInstance():replaceScene(scene)
	end
	
	if(director.releaseCB and "function" == type(director.releaseCB))then
		director.releaseCB()
	end
	director.releaseCB = releaseCallback
end

function director.replaceScene(scene)
	cc.Director:getInstance():replaceScene(scene)
end

function director.pushScene(scene)
	cc.Director:getInstance():pushScene(scene)
end

function director.popScene()
	cc.Director:getInstance():popScene()
end

function director.getRunningScene()
	return cc.Director:getInstance():getRunningScene()
end

function director.startAnimation()
	cc.Director:getInstance():startAnimation()
end

function director.stopAnimation()
	cc.Director:getInstance():stopAnimation()
end

function director.enableKeypadEvents(backCallback, menuCallback)
	local function KeypadHandler(strEvent)
		if "backClicked" == strEvent then
			if(backCallback and "function" == type(backCallback))then
				backCallback()
			end
		elseif "menuClicked" == strEvent then
			if(menuCallback and "function" == type(menuCallback))then
				menuCallback()
			end
		end
	end
	local layer = cc.Layer:create()
	layer:setKeypadEnabled(true)
	layer:registerScriptKeypadHandler(KeypadHandler)
	director.getRunningScene():addChild(layer)
end

return director