local db = 
{
	--playerInfo.proto
	playerInfo = nil, -- 玩家信息,  playerInfo_S2C
}

function db.get(key)
	return db[key]
end

function db.set(key, value)
	db[key] = value
	eventCenter:dispatchEvent(key, value)
end

function db.clear(key, value)
	db[key] = value
	eventCenter:dispatchEvent(key, value)
end

return db