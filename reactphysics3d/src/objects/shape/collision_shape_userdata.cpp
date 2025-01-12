#include "objects/base_userdata.h"
#include "static_hash.h"

#include "objects/shape/box_shape_userdata.h"
#include "objects/shape/sphere_shape_userdata.h"
#include "objects/shape/capsule_shape_userdata.h"
#include "objects/shape/collision_shape_userdata.h"
#include "objects/shape/convex_mesh_shape_userdata.h"
#include "objects/shape/concave_mesh_shape_userdata.h"
#include "objects/shape/height_field_shape_userdata.h"
#include "reactphysics3d/reactphysics3d.h"
#include "utils.h"
#include "objects/aabb.h"

#define META_NAME "rp3d::CollisionShape"
#define USERDATA_TYPE "rp3d::CollisionShape"





using namespace reactphysics3d;

namespace rp3dDefold {

CollisionShapeUserdata::CollisionShapeUserdata(CollisionShape* shape):BaseUserData(USERDATA_TYPE){
    this->metatable_name = META_NAME;
    this->shape = shape;
    this->obj = shape;
    shape->setUserData(this);

     switch(this->shape->getName()){
        case CollisionShapeName::TRIANGLE:
           // user cannot instanciate an object of this class. This class is for internal use only.
           //Instances of this class are created when the user creates an HeightFieldShape and a ConcaveMeshShape
           assert(false);
        case CollisionShapeName::SPHERE:
            this->metatable_name = META_NAME_SPHERE_SHAPE;
            break;
        case CollisionShapeName::CAPSULE:
            this->metatable_name = META_NAME_CAPSULE_SHAPE;
            break;
        case CollisionShapeName::BOX:
            this->metatable_name = META_NAME_BOX_SHAPE;
            break;
        case CollisionShapeName::CONVEX_MESH:
            this->metatable_name = META_NAME_CONVEX_MESH_SHAPE;
            break;
        case CollisionShapeName::TRIANGLE_MESH: //ConcaveMeshShape
            this->metatable_name = META_NAME_CONCAVE_MESH_SHAPE;
            break;
        case CollisionShapeName::HEIGHTFIELD:
            this->metatable_name = META_NAME_HEIGHTFIELD_SHAPE;
            break;
        default:{
            assert(false);
        }
    }
}

CollisionShapeUserdata::~CollisionShapeUserdata() {

}

CollisionShapeUserdata* CollisionShapeCheck(lua_State* L, int index){
    CollisionShapeUserdata *userdata = (CollisionShapeUserdata*) BaseUserData_get_userdata(L, index, USERDATA_TYPE);
    return userdata;
}

static const char * CollisionShapeNameEnumToString(CollisionShapeName name){
    switch(name){
        case CollisionShapeName::TRIANGLE:
            return "TRIANGLE";
        case CollisionShapeName::SPHERE:
            return "SPHERE";
        case CollisionShapeName::CAPSULE:
            return "CAPSULE";
        case CollisionShapeName::BOX:
            return "BOX";
        case CollisionShapeName::CONVEX_MESH:
            return "CONVEX_MESH";
        case CollisionShapeName::TRIANGLE_MESH:
            return "TRIANGLE_MESH";
        case CollisionShapeName::HEIGHTFIELD:
            return "HEIGHTFIELD";
        default:
            assert(false);
    }
}

static const char * CollisionShapeTypeEnumToString(CollisionShapeType type){
    switch(type){
        case CollisionShapeType::SPHERE:
            return "SPHERE";
        case CollisionShapeType::CAPSULE:
            return "CAPSULE";
        case CollisionShapeType::CONVEX_POLYHEDRON:
            return "CONVEX_POLYHEDRON";
        case CollisionShapeType::CONCAVE_SHAPE:
            return "CONCAVE_SHAPE";
        default:
            assert(false);
    }
}

int CollisionShape_GetName(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    lua_pushstring(L,CollisionShapeNameEnumToString(shape->shape->getName()));
    return 1;
}

int CollisionShape_GetType(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    lua_pushstring(L,CollisionShapeTypeEnumToString(shape->shape->getType()));
    return 1;
}

int CollisionShape_IsConvex(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    lua_pushboolean(L,shape->shape->isConvex());
    return 1;
}

int CollisionShape_IsPolyhedron(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    lua_pushboolean(L,shape->shape->isPolyhedron());
    return 1;
}
int CollisionShape_GetLocalBounds(lua_State *L){
    DM_LUA_STACK_CHECK(L, 2);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    Vector3 min;
    Vector3 max;
    shape->shape->getLocalBounds(min,max);
    dmVMath::Vector3 dmVMin(min.x,min.y,min.z);
    dmVMath::Vector3 dmVMax(max.x,max.y,max.z);
    dmScript::PushVector3(L, dmVMin);
    dmScript::PushVector3(L, dmVMax);
    return 2;
}

int CollisionShape_GetId(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    lua_pushnumber(L,shape->shape->getId());
    return 1;
}

int CollisionShape_GetVolume(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    lua_pushnumber(L,shape->shape->getVolume());
    return 1;
}

int CollisionShape_GetLocalInertiaTensor(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 2);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    Vector3 result = shape->shape->getLocalInertiaTensor(luaL_checknumber(L,2));
    dmVMath::Vector3 dmResult(result.x,result.y,result.z);
    dmScript::PushVector3(L, dmResult);
    return 1;
}

int CollisionShape_ComputeAABB(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 2);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);

    Transform transform = checkRp3dTransform(L,2);
    AABB aabb;
    shape->shape->computeAABB(aabb,transform);


    AABBPush(L,aabb);
    return 1;
}

int CollisionShape_ToString(lua_State *L){
    DM_LUA_STACK_CHECK(L, 1);
    check_arg_count(L, 1);
    CollisionShapeUserdata* shape = CollisionShapeCheck(L,1);
    push_std_string(L,shape->shape->to_string());
    return 1;
}

void CollisionShapeUserdataInitMetaTable(lua_State *L){
    BoxShapeUserdataInitMetaTable(L);
    SphereShapeUserdataInitMetaTable(L);
    CapsuleShapeUserdataInitMetaTable(L);
    ConvexMeshShapeUserdataInitMetaTable(L);
    ConcaveMeshShapeUserdataInitMetaTable(L);
    HeightFieldShapeUserdataInitMetaTable(L);
}





CollisionShapeUserdata* CollisionShapePush(lua_State *L, CollisionShape* shape){
    if(shape->getUserData()!=NULL){
         CollisionShapeUserdata* userdata =(CollisionShapeUserdata*) shape->getUserData();
         userdata->Push(L);
         return userdata;
    }else{
        CollisionShapeUserdata* userdata = new CollisionShapeUserdata(shape);
        userdata->Push(L);
        return userdata;
    }
}

void CollisionShapeUserdata::Destroy(lua_State *L){
    shape->setUserData(NULL);
    shape = NULL;
    delete[] heightData;
    heightData = NULL;
    BaseUserData::Destroy(L);
}

}