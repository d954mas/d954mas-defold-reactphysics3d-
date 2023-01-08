rp3d = {}

---@class Rp3dWorldSettings
local WorldSettings = {
	--Name of the world
	worldName = "",
	--Gravity force vector of the world (in Newtons)
	gravity = vmath.vector3(0, -9.81, 0),
	--Distance threshold for two contact points for a valid persistent contact (in meters)
	persistentContactDistanceThreshold = 0.03,
	--Default friction coefficient for a rigid body
	defaultFrictionCoefficient = 0.3,
	--Default bounciness factor for a rigid body
	defaultBounciness = 0.5,
	--Velocity threshold for contact velocity restitution
	restitutionVelocityThreshold = 0.5,
	--True if the sleeping technique is enabled
	isSleepingEnabled = true;
	--Number of iterations when solving the velocity constraints of the Sequential Impulse technique
	defaultVelocitySolverNbIterations = 6,
	--Number of iterations when solving the position constraints of the Sequential Impulse technique
	defaultPositionSolverNbIterations = 3,
	--Time (in seconds) that a body must stay still to be considered sleeping
	defaultTimeBeforeSleep = 1.0,
	--A body with a linear velocity smaller than the sleep linear velocity (in m/s) might enter sleeping mode.
	defaultSleepLinearVelocity = 0.02,
	--A body with angular velocity smaller than the sleep angular velocity (in rad/s) might enter sleeping mode
	defaultSleepAngularVelocity = 3.0 * (math.pi / 180.0),
	-- This is used to test if two contact manifold are similar (same contact normal) in order to
	-- merge them. If the cosine of the angle between the normals of the two manifold are larger
	-- than the value bellow, the manifold are considered to be similar.
	cosAngleSimilarContactManifold = 0.95,
}

---@class Rp3dPhysicsWorld
local PhysicsWorld = {}

--[[
CollisionBody * 	createCollisionBody (const Transform &transform)
 	Create a collision body.
 
void 	destroyCollisionBody (CollisionBody *collisionBody)
 	Destroy a collision body.
 
CollisionDispatch & 	getCollisionDispatch ()
 	Get the collision dispatch configuration.
 
void 	raycast (const Ray &ray, RaycastCallback *raycastCallback, unsigned short raycastWithCategoryMaskBits=0xFFFF) const
 	Ray cast method.
 
bool 	testOverlap (CollisionBody *body1, CollisionBody *body2)
 	Return true if two bodies overlap (collide)
 
void 	testOverlap (CollisionBody *body, OverlapCallback &overlapCallback)
 	Report all the bodies that overlap (collide) with the body in parameter.
 
void 	testOverlap (OverlapCallback &overlapCallback)
 	Report all the bodies that overlap (collide) in the world.
 
void 	testCollision (CollisionBody *body1, CollisionBody *body2, CollisionCallback &callback)
 	Test collision and report contacts between two bodies.
 
void 	testCollision (CollisionBody *body, CollisionCallback &callback)
 	Test collision and report all the contacts involving the body in parameter.
 
void 	testCollision (CollisionCallback &callback)
 	Test collision and report contacts between each colliding bodies in the world.
 
MemoryManager & 	getMemoryManager ()
 	Return a reference to the memory manager of the world.
 
AABB 	getWorldAABB (const Collider *collider) const
 	Return the current world-space AABB of given collider.

void 	setNbIterationsVelocitySolver (uint16 nbIterations)
 	Set the number of iterations for the velocity constraint solver.

void 	setNbIterationsPositionSolver (uint32 nbIterations)
 	Set the number of iterations for the position constraint solver.
 
void 	setContactsPositionCorrectionTechnique (ContactsPositionCorrectionTechnique technique)
 	Set the position correction technique used for contacts.
 
RigidBody * 	createRigidBody (const Transform &transform)
 	Create a rigid body into the physics world.
 
void 	enableDisableJoints ()
 	Disable the joints for pair of sleeping bodies.
 
void 	destroyRigidBody (RigidBody *rigidBody)
 	Destroy a rigid body and all the joints which it belongs.
 
Joint * 	createJoint (const JointInfo &jointInfo)
 	Create a joint between two bodies in the world and return a pointer to the new joint.
 
void 	destroyJoint (Joint *joint)
 	Destroy a joint.


 
void 	setGravity (const Vector3 &gravity)
 	Set the gravity vector of the world.
 
bool 	isGravityEnabled () const
 	Return if the gravity is on.
 
void 	setIsGravityEnabled (bool isGravityEnabled)
 	Enable/Disable the gravity.

void 	enableSleeping (bool isSleepingEnabled)
 	Enable/Disable the sleeping technique.

 
void 	setSleepLinearVelocity (decimal sleepLinearVelocity)
 	Set the sleep linear velocity.

 
void 	setSleepAngularVelocity (decimal sleepAngularVelocity)
 	Set the sleep angular velocity.


 
void 	setTimeBeforeSleep (decimal timeBeforeSleep)
 	Set the time a body is required to stay still before sleeping.
 
void 	setEventListener (EventListener *eventListener)
 	Set an event listener object to receive events callbacks.
 
uint32 	getNbCollisionBodies () const
 	Return the number of CollisionBody in the physics world.
 
const CollisionBody * 	getCollisionBody (uint32 index) const
 	Return a constant pointer to a given CollisionBody of the world.
 
CollisionBody * 	getCollisionBody (uint32 index)
 	Return a pointer to a given CollisionBody of the world.
 
uint32 	getNbRigidBodies () const
 	Return the number of RigidBody in the physics world.
 
const RigidBody * 	getRigidBody (uint32 index) const
 	Return a constant pointer to a given RigidBody of the world.
 
RigidBody * 	getRigidBody (uint32 index)
 	Return a pointer to a given RigidBody of the world.
 
bool 	getIsDebugRenderingEnabled () const
 	Return true if the debug rendering is enabled.
 
void 	setIsDebugRenderingEnabled (bool isEnabled)
 	Set to true if debug rendering is enabled.
 
DebugRenderer & 	getDebugRenderer ()
 	Return a reference to the Debug Renderer of the world. 
--]]

--Return the name of the world.
function PhysicsWorld:getName() end

--Return the gravity vector of the world.
---@return vector3
function PhysicsWorld:getGravity() end

--Get the number of iterations for the velocity constraint solver.
---@return number
function PhysicsWorld:getNbIterationsVelocitySolver() end

--Get the number of iterations for the position constraint solver.
---@return number
function PhysicsWorld:getNbIterationsPositionSolver() end

--Return true if the sleeping technique is enabled.
---@return bool
function PhysicsWorld:isSleepingEnabled() end

--Return the time a body is required to stay still before sleeping.
---@return number
function PhysicsWorld:getTimeBeforeSleep() end

-- Return the current sleep linear velocity.
---@return number
function PhysicsWorld:getSleepLinearVelocity() end

--Return the current sleep angular velocity.
---@return number
function PhysicsWorld:getSleepAngularVelocity() end

--Update the physics simulation.
---@param timeStep number
function PhysicsWorld:update(timeStep) end

--Set the number of iterations for the velocity constraint solver.
---@param nbIterations number
function PhysicsWorld:setNbIterationsVelocitySolver(nbIterations) end

--Set the number of iterations for the position constraint solver.
---@param nbIterations number
function PhysicsWorld:setNbIterationsPositionSolver(nbIterations) end




--Create and return an instance of PhysicsWorld.
---@param settings Rp3dWorldSettings
---@return Rp3dPhysicsWorld
function rp3d.createPhysicsWorld(settings) end

---@param world Rp3dPhysicsWorld
function rp3d.destroyPhysicsWorld(world) end


