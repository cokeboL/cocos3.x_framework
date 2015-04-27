
collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)

__GTRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)
    return msg
end

cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

--require "config"
require "init"

function cclog(...)
    print(...)
end

local function main()
    --require("app.MyApp"):create():run()
    --require("update"):run()

    net:init()

    net:connect(net.gateIp, net.gatePort, function()
        print("xxxxxxxxxxxxxxxx")
    end)
    require("Scene/Main/MainScene").new():run()
    --require("TestJoystick"):run()
end

local status, msg = xpcall(main, __GTRACKBACK__)
if not status then
    print(msg)
end
