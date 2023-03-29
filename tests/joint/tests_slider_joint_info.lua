local UTILS = require "tests.test_utils"
local TEST_JOINT_INFO = require "tests.joint.tests_joint_info"

---@type Rp3dPhysicsWorld
local w
---@type Rp3dRigidBody
local body1
---@type Rp3dRigidBody
local body2

return function()
	describe("SliderJointInfo", function()
		before(function()
			UTILS.set_env(getfenv(1))
			TEST_JOINT_INFO.set_env(getfenv(1))

			w = rp3d.createPhysicsWorld()
			body1 = w:createRigidBody({ position = vmath.vector3(-10, 0, 0), quat = vmath.quat() })
			body2 = w:createRigidBody({ position = vmath.vector3(10, 0, 0), quat = vmath.quat() })
		end)
		after(function()
			w:destroyRigidBody(body1)
			w:destroyRigidBody(body2)
			rp3d.destroyPhysicsWorld(w)
		end)

		test("create world position", function()
			local info = rp3d.createSliderJointInfoWorldSpace(body1, body2, vmath.vector3(0, 1, 0), vmath.vector3(0, 0, 1))
			assert_not_nil(info)
			TEST_JOINT_INFO.test_joint_info(info, { body1 = body1, body2 = body2, type = rp3d.JointType.SLIDERJOINT })
			assert_false(info.isUsingLocalSpaceAnchors)
			assert_equal_v3(info.anchorPointBody1LocalSpace, vmath.vector3(0))
			assert_equal_v3(info.anchorPointBody2LocalSpace, vmath.vector3(0))
			assert_equal_v3(info.anchorPointWorldSpace, vmath.vector3(0, 1, 0))
			assert_equal_v3(info.sliderAxisWorldSpace, vmath.vector3(0, 0, 1))
			assert_equal_v3(info.sliderAxisBody1Local, vmath.vector3(0, 0, 0))
			assert_equal(info.isLimitEnabled, false)
			assert_equal(info.isMotorEnabled, false)
			assert_equal(info.minTranslationLimit, -1)
			assert_equal(info.maxTranslationLimit, 1)
			assert_equal(info.motorSpeed, 0)
			assert_equal(info.maxMotorForce, 0)
		end)

		test("create local position", function()
			local info = rp3d.createSliderJointInfoLocalSpace(body1, body2, vmath.vector3(0, 1, 0), vmath.vector3(0, 2, 0),
					vmath.vector3(1, 0, 0)
			)
			assert_not_nil(info)
			TEST_JOINT_INFO.test_joint_info(info, { body1 = body1, body2 = body2, type = rp3d.JointType.SLIDERJOINT })
			assert_true(info.isUsingLocalSpaceAnchors)
			assert_equal_v3(info.anchorPointBody1LocalSpace, vmath.vector3(0, 1, 0))
			assert_equal_v3(info.anchorPointBody2LocalSpace, vmath.vector3(0, 2, 0))
			assert_equal_v3(info.anchorPointWorldSpace, vmath.vector3(0, 0, 0))
			assert_equal_v3(info.sliderAxisWorldSpace, vmath.vector3(0, 0, 0))
			assert_equal_v3(info.sliderAxisBody1Local, vmath.vector3(1, 0, 0))
			assert_equal(info.isLimitEnabled, false)
			assert_equal(info.isMotorEnabled, false)
			assert_equal(info.minTranslationLimit, -1)
			assert_equal(info.maxTranslationLimit, 1)
			assert_equal(info.motorSpeed, 0)
			assert_equal(info.maxMotorForce, 0)
		end)


	end)
end
