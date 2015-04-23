local language = 
{
	currLang = cc.Application:getInstance():getCurrentLanguage()	
}


local LangCfg = require("Cfg/LangCfg")

function language.get(id)
	if LangCfg[id] then	
		return LangCfg[id][language.currLang]
	end

	return ""
end

function language.setLang(lang)
	language.currLang = lang
end

return language