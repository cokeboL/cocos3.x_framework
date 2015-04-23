/*
** Lua binding: LuaModule
** Generated automatically by tolua++-1.0.92 on 03/24/15 15:23:06.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_LuaModule_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"LuaModule");
}

/* method: registerLuaHandler of class  LuaModule */
#ifndef TOLUA_DISABLE_tolua_LuaModule_LuaModule_registerLuaHandler00
static int tolua_LuaModule_LuaModule_registerLuaHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"LuaModule",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int luaFunc = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   LuaModule::registerLuaHandler(luaFunc);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'registerLuaHandler'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_LuaModule_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"LuaModule","LuaModule","",NULL);
  tolua_beginmodule(tolua_S,"LuaModule");
   tolua_function(tolua_S,"registerLuaHandler",tolua_LuaModule_LuaModule_registerLuaHandler00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_LuaModule (lua_State* tolua_S) {
 return tolua_LuaModule_open(tolua_S);
};
#endif

