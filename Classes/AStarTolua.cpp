/*
** Lua binding: AStar
** Generated automatically by tolua++-1.0.92 on 03/11/15 20:48:09.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

#include "cocos2d.h"
#include "cocos-ext.h"
#include "AStar.h"
#include "LuaBasicConversions.h"

USING_NS_CC;
using namespace std;

/* Exported function */
TOLUA_API int  tolua_AStar_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"AStar");
 tolua_usertype(tolua_S,"vector<Vec2>");
 tolua_usertype(tolua_S,"TMXTiledMap");
}

/* method: getInstance of class  AStar */
#ifndef TOLUA_DISABLE_tolua_AStar_AStar_getInstance00
static int tolua_AStar_AStar_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"AStar",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   AStar* tolua_ret = (AStar*)  AStar::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"AStar");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: findPath of class  AStar */
#ifndef TOLUA_DISABLE_tolua_AStar_AStar_findPath00
static int tolua_AStar_AStar_findPath00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"AStar",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"cc.TMXTiledMap",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  AStar* self = (AStar*)  tolua_tousertype(tolua_S,1,0);
  TMXTiledMap* tiledMap = ((TMXTiledMap*)  tolua_tousertype(tolua_S,2,0));
  int startX = ((int)  tolua_tonumber(tolua_S,3,0));
  int startY = ((int)  tolua_tonumber(tolua_S,4,0));
  int endX = ((int)  tolua_tonumber(tolua_S,5,0));
  int endY = ((int)  tolua_tonumber(tolua_S,6,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'findPath'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->findPath(tiledMap,startX,startY,endX,endY);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'findPath'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getPath of class  AStar */
#ifndef TOLUA_DISABLE_tolua_AStar_AStar_getPath00
static int tolua_AStar_AStar_getPath00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"AStar",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  AStar* self = (AStar*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getPath'", NULL);
#endif
  {
   vector<Vec2>& tolua_ret = (vector<Vec2>&)  self->getPath();
    //tolua_pushusertype(tolua_S,(void*)&tolua_ret,"vector<Vec2>");
	//const std::vector<std::string>& ret = cobj->getSearchPaths();
   ccvector_Vec2_to_luaval(tolua_S, tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getPath'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_AStar_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"AStar","AStar","",NULL);
  tolua_beginmodule(tolua_S,"AStar");
   tolua_function(tolua_S,"getInstance",tolua_AStar_AStar_getInstance00);
   tolua_function(tolua_S,"findPath",tolua_AStar_AStar_findPath00);
   tolua_function(tolua_S,"getPath",tolua_AStar_AStar_getPath00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_AStar (lua_State* tolua_S) {
 return tolua_AStar_open(tolua_S);
};
#endif

