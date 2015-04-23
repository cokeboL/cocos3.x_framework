local eventCenter = {}
eventCenter.events = {}


function eventCenter:addListener(name, event, cb)
	if self.events[name] then
		print("--- Error: eventCenter addListener, listener already exists!")
		return
	end
	self.events[name] = {event=event, cb=cb}
end


function eventCenter:removeListener(name)
	self.events[name] = nil
end

function eventCenter:dispatchEvent(event, data)
	for _, v in pairs(self.events) do
		if event == v.event then
			v.cb(event, data)
		end
	end
end

return eventCenter