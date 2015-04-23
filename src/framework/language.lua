local language = 
{
	currLang = cc.Application:getInstance():getCurrentLanguage()	
}


local langCfg = require("Cfg/langCfg")

function language.get(id)
	if langCfg[id] then	
		return langCfg[id][language.currLang]
	end

	return ""
end

function language.setLang(lang)
	language.currLang = lang
end

return language