#include "objects/collision_body_userdata.h"
#include "static_hash.h"
#include "objects/collider_userdata.h"
#include "objects/aabb.h"
#include "objects/shape/collision_shape_userdata.h"
#include "utils.h"

#define META_NAME "rp3d::Collider"
#define USERDATA_TYPE "rp3d::Collider"


using namespace reactphysics3d;

namespace rp3dDefold {

ColliderUserdata::ColliderUserdata(Collider* collider): BaseUserData(USERDATA_TYPE){
    this->metatable_name = META_NAME;
    this->collider = collider;
    this->obj = collider;
    this->collider->setUserData(this);
    user_data_ref = LUA_REFNIL;
}

ColliderUserdata::~ColliderUserdata() {

}


ColliderUserdata* ColliderUserdataCheck(lua_State *L, int index) {
    ColliderUserdata *userdata = (ColliderUserdata*) BaseUserData_get_userdata(L, index, USERDATA_TYPE);
	return userdata;
}

static int GetEntityId(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    lua_pushnumber(L,userdata->collider->getEntity().id);
	return 1;
}

static int GetCollisionShape(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    CollisionShape* shape = userdata->collider->getCollisionShape();
    CollisionShapePush(L,shape);
    return 1;
}

static int GetBody(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    CollisionBody* body = userdata->collider->getBody();
    CollisionBodyPush(L,body);
	return 1;
}

static int GetUserData(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    lua_rawgeti(L,LUA_REGISTRYINDEX,userdata->user_data_ref);
	return 1;
}
static int SetUserData(lua_State *L){
    DM_LUA_STACK_CHECK(L, 0);
    check_arg_count(L, 2);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    if (lua_istable(L, 2)) {
        luaL_unref(L, LUA_REGISTRYINDEX, userdata->user_data_ref);
        lua_pushvalue(L,2);
        userdata->user_data_ref = luaL_ref(L,LUA_REGISTRYINDEX);
    }else if (lua_isnil(L, 2)){
        luaL_unref(L, LUA_REGISTRYINDEX, userdata->user_data_ref);
        userdata->user_data_ref = LUA_REFNIL;
    }else {
       luaL_error(L,"userdata can be only table or nil");
    }
	return 0;
}

static int GetLocalToBodyTransform(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    pushRp3dTransform(L,userdata->collider->getLocalToBodyTransform());
	return 1;
}

static int SetLocalToBodyTransform(lua_State *L){
    DM_LUA_STACK_CHECK(L, 0);
    check_arg_count(L, 2);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    userdata->collider->setLocalToBodyTransform(checkRp3dTransform(L,2));
	return 0;
}

static int GetLocalToWorldTransform(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    pushRp3dTransform(L,userdata->collider->getLocalToWorldTransform());
	return 1;
}


static int GetWorldAABB(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    AABBPush(L,userdata->collider->getWorldAABB());
	return 1;
}

static int TestPointInside(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 2);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    dmVMath::Vector3* dmPoint = dmScript::CheckVector3(L, 2);
    Vector3 point(dmPoint->getX(),dmPoint->getY(),dmPoint->getZ());
    lua_pushboolean(L,userdata->collider->testPointInside(point));
	return 1;
}
static int TestAABBOverlap(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 2);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    AABBLua *aabb = AABBCheck(L,2);
    lua_pushboolean(L,userdata->collider->testAABBOverlap(aabb->aabb));
	return 1;
}

static int ToString(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    ColliderUserdata *userdata = ColliderUserdataCheck(L, 1);
    lua_pushfstring( L, "rp3d::Collider[%p]",(void *) userdata->collider);
	return 1;
}

static int Raycast(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 2);
    ColliderUserdata *collider = ColliderUserdataCheck(L, 1);
    Ray ray = CheckRay(L,2);
    RaycastInfo info;
    bool result =  collider->collider->raycast(ray,info);

    if(result){
         pushRp3dRaycastInfo(L,info);
    }else{
        lua_pushnil(L);
    }
    return 1;
}

void ColliderUserdataInitMetaTable(lua_State *L){
    int top = lua_gettop(L);

    luaL_Reg functions[] = {
        {"getEntityId",GetEntityId},
        {"getCollisionShape",GetCollisionShape},
        {"getBody",GetBody},
        {"setUserData",SetUserData},
        {"getUserData",GetUserData},
        {"setLocalToBodyTransform",SetLocalToBodyTransform},
        {"getLocalToBodyTransform",GetLocalToBodyTransform},
        {"getLocalToWorldTransform",GetLocalToWorldTransform},
        {"getWorldAABB",GetWorldAABB},
        {"testAABBOverlap",TestAABBOverlap},
        {"testPointInside",TestPointInside},
        {"raycast",Raycast},
        {"__tostring",ToString},
        { 0, 0 }
    };
    luaL_newmetatable(L, META_NAME);
    luaL_register (L, NULL,functions);
    lua_pushvalue(L, -1);
    lua_setfield(L, -1, "__index");
    lua_pop(L, 1);

    assert(top == lua_gettop(L));
}


void ColliderUserdata::Destroy(lua_State *L){
    collider->setUserData(NULL);
    collider = NULL;
    luaL_unref(L, LUA_REGISTRYINDEX, user_data_ref);
    user_data_ref = LUA_REFNIL;
    BaseUserData::Destroy(L);
}

void ColliderPush(lua_State *L, Collider* collider){
    if(collider->getUserData()!=NULL){
        ColliderUserdata* userdata =(ColliderUserdata*) collider->getUserData();
         userdata->Push(L);
    }else{
        ColliderUserdata* userdata = new ColliderUserdata(collider);
        userdata->Push(L);
    }
}

}