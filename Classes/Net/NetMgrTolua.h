#ifndef _NetManagerTolua_H_
#define _NetManagerTolua_H_


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
	int luaopen_Net(lua_State* tolua_S);
#endif

#endif
