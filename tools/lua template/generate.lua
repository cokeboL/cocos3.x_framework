local file =  io.open("./template.lua", "r")
local s = file:read("*all")
print(s)

for i,v in pairs(arg) do
	if i > 0 then
		local news = string.gsub(s, "template", v)

		local newFile =  io.open("./target/" .. v .. ".lua", "w")
		newFile:write(news)
		newFile:close()
	end
end

file:close()



--唇油   洗发水沐浴露 洗衣袋