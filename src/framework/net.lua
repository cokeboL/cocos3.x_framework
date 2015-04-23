local heartBeatInterval = 30
local msgTimeout = 10

net = { gateIp = "192.168.0.220", gatePort = 8080, state = "" }

function net:clearListeners()
	self.listeners = {}
end
function net:addListener(cmd, action, callback)
	self.listeners[cmd] = self.listeners[cmd] or {}
	self.listeners[cmd][action] = callback
end
function net:removeListener(cmd, action)
	if self.listeners[cmd] and self.listeners[cmd][action] then
		self.listeners[cmd][action] = nil
	end
end

function net.onMessage(err, cmd, action, flags, option, time, message)
	local self = net
	

	print("---------- onMessage: ", cmd, action, err)
	self.packResponsed = true

	if message == "syncServerTime" then
		self:getTimestamp()
		return
	end
	if err ~= 0 then
		
		local pack = self.packQueue[1]
		print("-------------- err : ", pack.cmd, pack.action)
		if(self.callBack[pack.cmd] and self.callBack[pack.cmd][pack.action]) then
			self.callBack[pack.cmd][pack.action](err, pack.cmd, pack.action, flags, option, time, message)
		else
			--toolkit.pushMsg("err code: " .. err)
		end
		table.remove(self.packQueue, 1)
		--toolkit.finishLoading()
	elseif(self.callBack[cmd] and self.callBack[cmd][action]) then
		self.callBack[cmd][action](err, cmd, action, flags, option, time, message)
		table.remove(self.packQueue, 1)
		--toolkit.finishLoading()
	elseif(self.listeners[cmd] and self.listeners[cmd][action]) then
		self.listeners[cmd][action](err, cmd, action, flags, option, time, message)
	end
	
end

local heartbeatCount = 0
function net.heartBeatCB(t)
	--print("...................... timestamp: ", t)
end
function net.heartBeat()
	local self = net

	if self.state ~= "connected" then
		return 
	end

	local timeInterval = os.time() - self.lastSendPackTime
	if not self.packResponsed and timeInterval >= msgTimeout then
	elseif timeInterval >= heartBeatInterval then
		net:getTimestamp(self.heartBeatCB)
		heartbeatCount = heartbeatCount + 1
	end

end

function net.onConnected()

	local self = net

	self.state = "connected"

	if self.isLogicServer then
		self.isLogicServerOn = true
	else
	end
	if self.connCB then
		self.connCB()
	end
end

function net.onDisConnected()
	local self = net
	self.state = ""
	
	self.onNetErr()

	cclog("--------------- onDisConnected xxxx")
end
	
function net.onConnectError()
	local self = net
	self.state = ""

	self.onNetErr()
	cclog("--------------- onConnectError")
end
	
function net.onConnectTimeout()
	local self = net
	self.state = ""
	
	self.onNetErr()
	cclog("--------------- onConnectTimeout")
end
	
function net:init()
	self.connCB = nil
	self.isLogicServer = nil
	self.reconnectCount = 0
	self.reconnStartTime = 0
	self.timestampIncrement = 0
	self.ip = nil
	self.port = nil
	self.lastSendPackTime = -1
	self.gameEchoStr = nil
	self.packResponsed = false
	self.state = ""
	self.isLogicServerOn = false

	self.callBack = {}
	self.listeners = {}
	self.gamerMsgs = {}

	self.packQueue = {}

	self.instance = NetMgr:getInstance()
	
	--self.instance:close()
	
	--gScheduler:delete("heartbeat")

	self.instance:registerCallBacks(
		self.onConnected,
		self.onDisConnected,
		self.onConnectError,
		self.onConnectTimeout,
		self.onMessage
	)
end

function net:httpGet(url, callback)
	self.instance:httpRequest(url, callback);
end

function net:httpPost(url, data, callback)
	self.instance:httpPost(url, data, callback);
end

function net:connect(ip, port, callback, isLogicServer)
	self.state = ""
	self.connCB = callback
	self.isLogicServer = isLogicServer
	self.ip = ip
	self.port = port
	self.instance:close()
	self.instance:connect(ip, port)
end

function net:sendMessage(len, cmd, action, pbMsg, callback, disableTouch)
	cclog("----sendMessage: ", len, cmd, action, pbMsg, callback, disableTouch)
	self.callBack[cmd] = self.callBack[cmd] or {}
	self.callBack[cmd][action] = callback
	if disableTouch or disableTouch == nil then
		--toolkit.startLoading(scene)
	end
	self.packResponsed = false
	self.instance:sendMessage(len, cmd, action, pbMsg)
	self.lastSendPackTime = os.time()

	self.packQueue[#self.packQueue+1] = {cmd=cmd, action=action, msg=pbMsg, cb=callback}
end

function net:getTimestamp(callback)
	self:sendMessage(string.len(self.gameEchoStr), 1, 8, self.gameEchoStr, function(err, cmd, action, flags, option, timestamp, message)
		--[[
		local gameEchoS2c = pb.new("PB_GamerEcho_S2C")
		pb.parseFromString(gameEchoS2c, message)
		self.timestampIncrement = gameEchoS2c.time - os.time()
		if callback then
			callback(gameEchoS2c.time)
		end
		--]]
		if callback then
			callback(message)
		end
	end, false)
end

function net.reconnect()
	local self = net

	self.state = ""

	local function reconnCheck(error, cmd, action, flags, option, time, message)
		cclog(error, cmd, action, flags, option, time, message)

		local msg = pb.new("PB_GamerInit_S2C")
		pb.parseFromString(msg, message)
		self.reconnSession = msg.reconn

		table.remove(self.packQueue, 1)
		--toolkit.finishLoading()

		if #self.packQueue > 0 then
			local pack
			for i=1, #self.packQueue do
				pack = self.packQueue[i]
				net:sendMessage(string.len(pack.msg), pack.cmd, pack.action, pack.msg, pack.cb)
			end
			self.packQueue = {}
		end
		--]]
	end
	local function onReconnected()
		--[[
		local loginReq = pb.new("PB_GamerInit_C2S")
		loginReq.reconn = self.reconnSession
		loginReq.session = ""
		--loginReq.version = "1.1.0.0"
		local req = pb.serializeToString(loginReq)
		net:sendMessage(string.len(req), 1, 2, req, reconnCheck)
		--]]
	end
	if self.isLogicServerOn then
		self:connect(self.ip, self.port, onReconnected, self.isLogicServer)
	else
		self:connect(self.ip, self.port, self.connCB, self.isLogicServer)
	end
end

function net.onNetErr(cb)
	local self = net

	--[[
	toolkit.finishLoading()
	toolkit.pushMsg("网络出错，请重试!", function()
		if cb then cb() end
		if self.isLogicServer or self.isLogicServerOn then
			self.reconnect()
		end
	end)
	--]]
	cclog("--- Net Error ---")
end

return net