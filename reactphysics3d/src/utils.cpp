#include <string>
#include <queue>

#include "utils.h"

namespace rp3dDefold {
	void check_arg_count(lua_State *L, int count_exact) {
		int count = lua_gettop(L);
		if (count != count_exact) {
			luaL_error(L, "This function requires %d arguments. Got %d.", count_exact, count);
		}
	}

	void check_arg_count(lua_State *L, int count_from, int count_to) {
		int count = lua_gettop(L);
		if (count < count_from || count > count_to) {
			luaL_error(L, "This function requires from %d to %d arguments. Got %d.", count_from, count_to, count);
		}
	}

	void push_std_string(lua_State *L, std::string str){
        lua_pushlstring(L, str.c_str(), str.length());
	}
}