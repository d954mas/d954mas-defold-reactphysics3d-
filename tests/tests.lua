local DEFTEST = require "deftest.deftest"
local TELESCOPE = require "deftest.telescope"

local TEST_WORLD = require "tests.test_world"
local TEST_WORLD_SETTINGS = require "tests.test_world_settings"
local M = {}

function M.run()
    TELESCOPE.make_assertion(
            "equals_v3",
            function(_, a,b) return string.format(TELESCOPE.assertion_message_prefix .. "'%s' to be equal to '%s'",a,b) end,
            function(a, b)
                if(type(a) ~= "userdata" or type(b)~= "userdata") then assert("not v3") end
                return a.x == b.x and a.y == b.y and a.z == b.z
            end
    )
    TELESCOPE.make_assertion(
            "equal_v3",
            function(_, a,b) return string.format(TELESCOPE.assertion_message_prefix .. "'%s' to be equal to '%s'",tostring(a),tostring(b)) end,
            function(a, b)
                if(type(a) ~= "userdata" or type(b)~= "userdata") then assert("not v3") end
                local dx = math.abs(a.x-b.x)
                local dy = math.abs(a.y-b.y)
                local dz = math.abs(a.z-b.z)
                return dx <= 0.0000001 and dy <= 0.0000001 and dz <= 0.0000001
            end
    )
    TELESCOPE.make_assertion(
            "equal_float",
            function(_, a,b) return string.format(TELESCOPE.assertion_message_prefix .. "'%s' to be equal to '%s'",a,b) end,
            function(a, b)
                if(type(a) ~= "number" or type(b)~= "number") then assert("not v3") end
                local d = math.abs(a-b)
                return d >=0 and d <= 0.0000001
            end
    )
    DEFTEST.add(TEST_WORLD)
    DEFTEST.add(TEST_WORLD_SETTINGS)
    DEFTEST.run()
end

return M