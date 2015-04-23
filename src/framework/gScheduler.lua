local gScheduler = {}

gScheduler.maps = {}

local scheduler = cc.Director:getInstance():getScheduler()

function gScheduler:new(name, handler, interval, paused)
	if not self.maps[name] then
		self.maps[name] = scheduler:scheduleScriptFunc(handler, interval, paused)
	end
	return self.maps[name]
end

function gScheduler:delete(name)
	if self.maps[name] then
		scheduler:unscheduleScriptEntry(self.maps[name])
		self.maps[name] = nil
	end
end

return gScheduler