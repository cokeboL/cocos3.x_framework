local LayerMgr = class("LayerMgr", function()
	return cc.Node:create()
end)

function LayerMgr:ctor()
	self:registerScriptHandler(function(event)
        if event == "enter" then
        	
        elseif event == "exit" then
        	
        end
    end)

end

return LayerMgr
