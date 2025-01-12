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

--Represent a polygon face of the polyhedron.
---@class Rp3dPolygonFace
local Rp3dPolygonFace = {
	--Number of vertices in the polygon face.
	nbVertices = 4;
	--Index of the first vertex of the polygon face inside the array with all vertex indices.
	indexBase = 0;
}



--The ray goes from point1 to point1 + maxFraction * (point2 - point1).
--The points are specified in world-space coordinates.
---@class Rp3dRay
local Rp3dRay = {
	point1 = vmath.vector3(),
	point2 = vmath.vector3(),
	maxFraction = 0 --[0-1] if nil use 1.
}

---@class Rp3dEventListener
local Rp3dEventListener = {
	---@param contacts Rp3dContactPair[]
	onContact = function(contacts)

	end,
	---@param triggers Rp3dOverlapPair[]
	onTrigger = function(triggers)

	end
}

---@class Rp3dRaycastCallback
---@param info Rp3dRaycastInfo
local Rp3dRaycastCallback = function(info)
	return info.hitFraction
end

---@class Rp3dRaycastInfo
---@field worldPoint vector3 Hit point in world-space coordinates.
---@field worldNormal vector3 Surface normal at hit point in world-space coordinates.
---@field hitFraction number Fraction distance of the hit point between point1 and point2 of the ray The hit point "p" is such that p = point1 + hitFraction * (point2 - point1)
---@field meshSubpart number Mesh subpart index that has been hit (only used for triangles mesh and -1 otherwise)
---@field triangleIndex number Hit triangle index (only used for triangles mesh and -1 otherwise)
---@field body Rp3dCollisionBody
---@field collider Rp3dCollider
local Rp3dRaycastInfo = {}

---@class Rp3dOverlapPair
---@field collider1 Rp3dCollider
---@field collider2 Rp3dCollider
---@field body1 Rp3dCollisionBody
---@field body2 Rp3dCollisionBody
---@field eventType string OverlapPair.EventType
local Rp3dOverlapPair = {}

---@class Rp3dContactPair
---@field collider1 Rp3dCollider
---@field collider2 Rp3dCollider
---@field body1 Rp3dCollisionBody
---@field body2 Rp3dCollisionBody
---@field eventType string ContactPair.EventType
---@field contacts Rp3dContactPairContact[]
local Rp3dContactPair = {}

---@class Rp3dContactPairContact
---@field penetrationDepth  number
---@field worldNormal vector3
---@field localPointOnCollider1 vector3
---@field localPointOnCollider2 vector3
local Rp3dContactPairContact = {}

---@class Rp3dHalfEdgeStructureFace
---@field edgeIndex number
---@field faceVertices number[]
local Rp3dHalfEdgeStructureFace = {}

---@class Rp3dHalfEdgeStructureVertex
---@field edgeIndex number
---@field vertexPointIndex number
local Rp3dHalfEdgeStructureVertex = {}

---@class Rp3dHalfEdgeStructureEdge
---@field vertexIndex number
---@field twinEdgeIndex number
---@field faceIndex number
---@field nextEdgeIndex number
local Rp3dHalfEdgeStructureEdge = {}

---@class Rp3dTransform
local Rp3dTransform = {
	position = vmath.vector3(),
	quat = vmath.quat(),
}

---@class Rp3dMaterial
local Rp3dMaterial = {
	bounciness = 0,
	frictionCoefficient = 0,
	massDensity = 0,
}

---@class Rp3dJointInfo
---@field body1 Rp3dRigidBody
---@field body2 Rp3dRigidBody
---@field type string rp3d.JointInfoType
---@field positionCorrectionTechnique string rp3d.JointsPositionCorrectionTechnique
---@field isCollisionEnabled bool True if the two bodies of the joint are allowed to collide with each other.
local Rp3dJointInfo = {}

---@class Rp3dBallAndSocketJointInfo:Rp3dJointInfo
---@field isUsingLocalSpaceAnchors bool rue if this object has been constructed using local-space anchors.
---@field anchorPointWorldSpace vector3 Anchor point (in world-space coordinates)
---@field anchorPointBody1LocalSpace vector3 Anchor point on body 1 (in local-space coordinates)
---@field anchorPointBody2LocalSpace vector3 Anchor point on body 2 (in local-space coordinates)
local Rp3dBallAndSocketJointInfo = {}

---@class Rp3dHingeJointInfo:Rp3dJointInfo
---@field isUsingLocalSpaceAnchors bool rue if this object has been constructed using local-space anchors.
---@field anchorPointWorldSpace vector3 Anchor point (in world-space coordinates)
---@field anchorPointBody1LocalSpace vector3 Anchor point on body 1 (in local-space coordinates)
---@field anchorPointBody2LocalSpace vector3 Anchor point on body 2 (in local-space coordinates)
---@field rotationAxisWorld vector3 Hinge rotation axis (in world-space coordinates)s)
---@field rotationAxisBody1Local vector3  Hinge rotation axis of body 1 (in local-space coordinates)
---@field rotationAxisBody2Local vector3  Hinge rotation axis of body 2 (in local-space coordinates)
---@field isLimitEnabled bool True if the hinge joint limits are enabled.
---@field isMotorEnabled bool True if the hinge joint motor is enabled.
---@field minAngleLimit number Minimum allowed rotation angle (in radian) if limits are enabled.
---@field maxAngleLimit number Maximum allowed rotation angle (in radian) if limits are enabled.
---@field motorSpeed number Motor speed (in radian/second)
---@field maxMotorTorque number Maximum motor torque (in Newtons * meters) that can be applied to reach to desired motor speed.
local Rp3dHingeJointInfo = {}

---@class Rp3dSliderJointInfo:Rp3dJointInfo
---@field isUsingLocalSpaceAnchors bool rue if this object has been constructed using local-space anchors.
---@field anchorPointWorldSpace vector3 Anchor point (in world-space coordinates)
---@field anchorPointBody1LocalSpace vector3 Anchor point on body 1 (in local-space coordinates)
---@field anchorPointBody2LocalSpace vector3 Anchor point on body 2 (in local-space coordinates)
---@field sliderAxisWorldSpace vector3 Slider axis (in world-space coordinates)
---@field sliderAxisBody1Local vector3 Hinge slider axis of body 1 (in local-space coordinates)
---@field isLimitEnabled bool True if the slider limits are enabled.
---@field isMotorEnabled bool True if the slider motor is enabled.
---@field minTranslationLimit number Mininum allowed translation if limits are enabled.
---@field maxTranslationLimit number MMaximum allowed translation if limits are enabled.
---@field motorSpeed number Motor speed.
---@field maxMotorForce number Maximum motor force (in Newtons) that can be applied to reach to desired motor speed.
local Rp3dSliderJointInfo = {}

---@class Rp3dFixedJointInfo:Rp3dJointInfo
---@field isUsingLocalSpaceAnchors bool rue if this object has been constructed using local-space anchors.
---@field anchorPointWorldSpace vector3 Anchor point (in world-space coordinates)
---@field anchorPointBody1LocalSpace vector3 Anchor point on body 1 (in local-space coordinates)
---@field anchorPointBody2LocalSpace vector3 Anchor point on body 2 (in local-space coordinates)
local Rp3dFixedJointInfo = {}


---@class Rp3dJoint
local Rp3dJoint = {}

---@return Rp3dRigidBody
function Rp3dJoint:getBody1() end

---@return Rp3dRigidBody
function Rp3dJoint:getBody2() end

---@return string rp3d.JointType
function Rp3dJoint:getType() end

--Return the force (in Newtons) on body 2 required to satisfy the joint constraint.
---@param timeStep number
---@return vector3
function Rp3dJoint:getReactionForce(timeStep) end

--Return the torque (in Newtons * meters) on body 2 required to satisfy the joint constraint.
---@param timeStep number
---@return vector3
function Rp3dJoint:getReactionTorque(timeStep) end

---@return bool
function Rp3dJoint:isCollisionEnabled() end

--Return the entity id of the joint.
---@return number
function Rp3dJoint:getEntityId() end

---@class Rp3dBallAndSocketJoint:Rp3dJoint
local Rp3dBallAndSocketJoint = {}

---@param isLimitEnabled bool
function Rp3dBallAndSocketJoint:enableConeLimit(isLimitEnabled) end

---@return bool
function Rp3dBallAndSocketJoint:isConeLimitEnabled() end

---@param coneHalfAngle number  The angle of the cone limit (in radian) from [0; PI]
function Rp3dBallAndSocketJoint:setConeLimitHalfAngle(coneHalfAngle) end

---@return number
function Rp3dBallAndSocketJoint:getConeLimitHalfAngle() end

---@return number
function Rp3dBallAndSocketJoint:getConeHalfAngle() end

---@class Rp3dHingeJoint:Rp3dJoint
local Rp3dHingeJoint = {}

---@return bool
function Rp3dHingeJoint:isLimitEnabled() end

---@return bool
function Rp3dHingeJoint:isMotorEnabled() end

---@param isLimitEnabled bool
function Rp3dHingeJoint:enableLimit(isLimitEnabled) end

---@param isMotorEnabled bool
function Rp3dHingeJoint:enableMotor(isMotorEnabled) end

---@return number
function Rp3dHingeJoint:getMinAngleLimit() end

---@param lowerLimit number
function Rp3dHingeJoint:setMinAngleLimit(lowerLimit) end

---@return number
function Rp3dHingeJoint:getMaxAngleLimit() end

---@param upperLimit number
function Rp3dHingeJoint:setMaxAngleLimit(upperLimit) end

---@return number
function Rp3dHingeJoint:getMotorSpeed() end

---@param motorSpeed number
function Rp3dHingeJoint:setMotorSpeed(motorSpeed) end

---@return number
function Rp3dHingeJoint:getMaxMotorTorque() end

---@param maxMotorTorque number
function Rp3dHingeJoint:setMaxMotorTorque(maxMotorTorque) end

---@param timeStep number
---@return number
function Rp3dHingeJoint:getMotorTorque(timeStep) end

--Return the current hinge angle (in radians)
---@return number
function Rp3dHingeJoint:getAngle() end

---@class Rp3dSliderJoint:Rp3dJoint
local Rp3dSliderJoint = {}

---@return bool
function Rp3dSliderJoint:isLimitEnabled() end

---@return bool
function Rp3dSliderJoint:isMotorEnabled() end

---@param isLimitEnabled bool
function Rp3dSliderJoint:enableLimit(isLimitEnabled) end

---@param isMotorEnabled bool
function Rp3dSliderJoint:enableMotor(isMotorEnabled) end

---@return number
function Rp3dSliderJoint:getTranslation() end

---@return number
function Rp3dSliderJoint:getMinTranslationLimit() end

---@param lowerLimit number
function Rp3dSliderJoint:setMinTranslationLimit(lowerLimit) end

---@return number
function Rp3dSliderJoint:getMaxTranslationLimit() end

---@param upperLimit number
function Rp3dSliderJoint:setMaxTranslationLimit(upperLimit) end

---@return number
function Rp3dSliderJoint:getMotorSpeed() end

---@param motorSpeed number
function Rp3dSliderJoint:setMotorSpeed(motorSpeed) end

---@return number
function Rp3dSliderJoint:getMaxMotorForce() end

---@param maxMotorForce number
function Rp3dSliderJoint:setMaxMotorForce(maxMotorForce) end

---@param timeStep number
---@return number
function Rp3dSliderJoint:getMotorForce(timeStep) end

---@param timeStep number
---@return vector3
function Rp3dSliderJoint:getReactionForce(timeStep) end

---@param timeStep number
---@return vector3
function Rp3dSliderJoint:getReactionTorque(timeStep) end

---@class Rp3dFixedJoint:Rp3dJoint
local Rp3dFixedJoint = {}



---@class Rp3dPolyhedronMesh
local Rp3dPolyhedronMesh = {}

--Return the number of vertices.
---@return number
function Rp3dPolyhedronMesh:getNbVertices() end

--Return a vertex
---@param index number
---@return vector3
function Rp3dPolyhedronMesh:getVertex(index) end

--Return the number of faces.
---@return number
function Rp3dPolyhedronMesh:getNbFaces() end

--Return a face normal.
---@param faceIndex number
---@return vector3
function Rp3dPolyhedronMesh:getFaceNormal(faceIndex) end

--Return the centroid of the polyhedron
---@return vector3
function Rp3dPolyhedronMesh:getCentroid() end

--Compute and return the volume of the polyhedron.
---@return number
function Rp3dPolyhedronMesh:getVolume() end

---@class Rp3dCollider
local Collider = {}

---@return number
function Collider:getEntityId() end

---@return Rp3dCollisionShape
function Collider:getCollisionShape() end

---@return Rp3dCollisionBody
function Collider:getBody() end

---@return table|nil
function Collider:getUserData() end

---@param userdata table|nil
function Collider:setUserData(userdata) end

--Return the local to parent body transform.
---@return Rp3dTransform
function Collider:getLocalToBodyTransform() end

--Set the local to parent body transform.
---@param transform Rp3dTransform
function Collider:setLocalToBodyTransform(transform) end

--Return the local to world transform.
---@return Rp3dTransform
function Collider:getLocalToWorldTransform() end

--Return the AABB of the collider in world-space.
---@return Rp3dAABB
function Collider:getWorldAABB() end

--return true if a point is inside the collision shape.
---@return boolean
---@param worldPoint vector3
function Collider:testPointInside(worldPoint) end

--Test if the collider overlaps with a given AABB.
---@return boolean
---@param worldAABB Rp3dAABB
function Collider:testAABBOverlap(worldAABB) end

---@param ray Rp3dRay
---@return Rp3dRaycastInfo|nil nil if no hit point
function Collider:raycast(ray) end

--Return the broad-phase id.
---@return number
function Collider:getBroadPhaseId() end

function Collider:getCollideWithMaskBits() end

--	Set the collision bits mask.
---@param collideWithMaskBits number
function Collider:setCollideWithMaskBits(collideWithMaskBits) end

--Return the collision category bits.
---@return number
function Collider:getCollisionCategoryBits() end

--Set the collision category bits.
---@param collisionCategoryBits number
function Collider:setCollisionCategoryBits(collisionCategoryBits) end

--Return true if the collider is a trigger.
---@return boolean
function Collider:getIsTrigger() end

--Set whether the collider is a trigger.
---@param isTrigger boolean
function Collider:setIsTrigger(isTrigger) end

--	Return material properties of the collider.
---@return Rp3dMaterial
function Collider:getMaterial() end

--Set a new material for this collider.
---@param material Rp3dMaterial
function Collider:setMaterial(material) end

---@return number
function Collider:getMaterialBounciness() end

---@param bounciness number
function Collider:setMaterialBounciness(bounciness) end

---@return number
function Collider:getMaterialFrictionCoefficient() end

---@param frictionCoefficient number
function Collider:setMaterialFrictionCoefficient(frictionCoefficient) end

---@return number
function Collider:getMaterialMassDensity() end

---@param massDensity number
function Collider:setMaterialMassDensity(massDensity) end

---@class Rp3dCollisionBody
local CollisionBody = {}

---@return number
function CollisionBody:getEntityId() end

---@return boolean
function CollisionBody:isRigidBody() end


--Return true if the body is active.
---@return boolean
function CollisionBody:isActive() end


--Return a table or nil user data attached to this body.
---@return table|nil
function CollisionBody:getUserData() end

--Attach user data to this body.
---@param userdata table|nil
function CollisionBody:setUserData(userdata) end

--Return the current position and orientation.
---@return Rp3dTransform
function CollisionBody:getTransform() end

--Set the current position and orientation.
---@param transform Rp3dTransform
function CollisionBody:setTransform(transform) end

--Return the current position.
---@return vector3
function CollisionBody:getTransformPosition() end

---@param position vector3
function CollisionBody:setTransformPosition(position) end

--Return the current rotation.
---@return quaternion
function CollisionBody:getTransformQuat() end

---@param quat quaternion
function CollisionBody:setTransformQuat(quat) end

--Create a new collider and add it to the body.
--A collider is an object with a collision shape that is attached to a body.
--It is possible to attach multiple colliders to a given body.
--You can use the returned collider to get and set information about the corresponding collision shape for that body.
---@param collisionShape Rp3dCollisionShape
---@param transform Rp3dTransform
---@return Rp3dCollider
function CollisionBody:addCollider(collisionShape, transform) end

---@return Rp3dCollider
---@param index number [0,size)
function CollisionBody:getCollider(index) end

--Return the number of colliders associated with this body.
---@return number
function CollisionBody:getNbColliders() end

---@param collider Rp3dCollider
function CollisionBody:removeCollider(collider) end

--Return true if a point is inside the collision body.
---@param worldPoint vector3 The point to test (in world-space coordinates)
---@return boolean
function CollisionBody:testPointInside(worldPoint) end


--Raycast method with feedback information.
--The method returns the closest hit among all the collision shapes of the body.
---@param ray Rp3dRay
---@return Rp3dRaycastInfo|nil nil if no hit point
function CollisionBody:raycast(ray) end

--Test if the collision body overlaps with a given AABB
---@param aabb Rp3dAABB
---@return boolean
function CollisionBody:testAABBOverlap(aabb) end

--Compute and return the AABB of the body by merging all colliders AABBs.
---@return Rp3dAABB
function CollisionBody:getAABB() end

--Return the world-space coordinates of a point given the local-space coordinates of the body.
---@param localPoint vector3
---@return vector3
function CollisionBody:getWorldPoint(localPoint) end

--Return the world-space vector of a vector given in local-space coordinates of the body.
---@param localVector vector3
---@return vector3
function CollisionBody:getWorldVector(localVector) end

--Return the body local-space coordinates of a point given in the world-space coordinates.
---@param worldPoint vector3
---@return vector3
function CollisionBody:getLocalPoint(worldPoint) end

--Return the body local-space coordinates of a vector given in the world-space coordinates.
---@param worldVector vector3
---@return vector3
function CollisionBody:getLocalVector(worldVector) end

--	Set whether or not the body is active.
---@param isActive boolean
function CollisionBody:setIsActive(isActive) end

--Return true if the body is active.
---@return boolean
function CollisionBody:isActive() end

---@class Rp3dRigidBody:Rp3dCollisionBody
local RigidBody = {}

--Compute and set the local-space center of mass of the body using its colliders.
function RigidBody:updateLocalCenterOfMassFromColliders() end

--Compute and set the local-space inertia tensor of the body using its colliders.
function RigidBody:updateLocalInertiaTensorFromColliders() end

--Compute and set the mass of the body using its colliders.
function RigidBody:updateMassFromColliders() end

--Compute and set the center of mass, the mass and the local-space inertia tensor of the body using its colliders.
function RigidBody:updateMassPropertiesFromColliders() end

---@param type string rp3d.BodyType
function RigidBody:setType(type) end

---@return string
function RigidBody:getType() end

--Return the mass of the body.
---@return number
function RigidBody:getMass() end

--Set the mass of the rigid body.
---@param mass number
function RigidBody:setMass(mass) end

--Return the linear velocity.
---@return vector3
function RigidBody:getLinearVelocity() end

--Set the linear velocity of the body.
---@param linearVelocity vector3
function RigidBody:setLinearVelocity(linearVelocity) end

--Return the angular velocity.
---@return vector3
function RigidBody:getAngularVelocity() end

--Set the angular velocity.
---@param angularVelocity vector3
function RigidBody:setAngularVelocity(angularVelocity) end

--Return the local inertia tensor of the body (in body coordinates)
---@return vector3
function RigidBody:getLocalInertiaTensor() end

--	Set the local inertia tensor of the body (in body coordinates)
---@param inertiaTensorLocal vector3
function RigidBody:setLocalInertiaTensor(inertiaTensorLocal) end

--Return the center of mass of the body (in local-space coordinates)
---@return vector3
function RigidBody:getLocalCenterOfMass() end

--Set the center of mass of the body (in local-space coordinates)
---@param centerOfMass vector3
function RigidBody:setLocalCenterOfMass(centerOfMass) end

--Return true if the gravity needs to be applied to this rigid body.
---@return boolean
function RigidBody:isGravityEnabled() end

--Set the variable to know if the gravity is applied to this rigid body.
---@param isEnabled boolean
function RigidBody:enableGravity(isEnabled) end

--Set the variable to know whether or not the body is sleeping.
---@param isSleeping boolean
function RigidBody:setIsSleeping(isSleeping) end

--Return whether or not the body is sleeping.
---@return boolean
function RigidBody:isSleeping() end

--Return the linear velocity damping factor.
---@return number
function RigidBody:getLinearDamping() end

--Set the linear damping factor.
---@param linearDamping number
function RigidBody:setLinearDamping(linearDamping) end

--Return the angular velocity damping factor.
---@return number
function RigidBody:getAngularDamping() end

--Set the angular damping factor.
---@param angularDamping number
function RigidBody:setAngularDamping(angularDamping) end



--Return the lock translation factor.
---@return vector3
function RigidBody:getLinearLockAxisFactor() end

--Set the linear lock factor.
---@param linearLockAxisFactor vector3
function RigidBody:setLinearLockAxisFactor(linearLockAxisFactor) end

--Return the lock rotation factor.
---@return vector3
function RigidBody:getAngularLockAxisFactor() end

--Set the lock rotation factor.
---@param angularLockAxisFactor vector3
function RigidBody:setAngularLockAxisFactor(angularLockAxisFactor) end


--Manually apply an external force (in local-space) to the body at its center of mass.
---@param force vector3
function RigidBody:applyLocalForceAtCenterOfMass(force) end

--Manually apply an external force (in world-space) to the body at its center of mass.
---@param force vector3
function RigidBody:applyWorldForceAtCenterOfMass(force) end


--Manually apply an external force (in local-space) to the body at a given point (in local-space).
---@param force vector3
---@param point vector3
function RigidBody:applyLocalForceAtLocalPosition(force, point) end

--Manually apply an external force (in world-space) to the body at a given point (in local-space).
---@param force vector3
---@param point vector3
function RigidBody:applyWorldForceAtLocalPosition(force, point) end

--Manually apply an external force (in local-space) to the body at a given point (in world-space).
---@param force vector3
---@param point vector3
function RigidBody:applyLocalForceAtWorldPosition(force, point) end

--Manually apply an external force (in world-space) to the body at a given point (in world-space).
---@param force vector3
---@param point vector3
function RigidBody:applyWorldForceAtWorldPosition(force, point) end

--Manually apply an external torque to the body (in local-space).
---@param torque vector3
function RigidBody:applyLocalTorque(torque) end

--Manually apply an external torque to the body (in world-space).
---@param torque vector3
function RigidBody:applyWorldTorque(torque) end

--Reset the manually applied force to zero.
function RigidBody:resetForce() end

--Reset the manually applied torque to zero.
function RigidBody:resetTorque() end

--Return the total manually applied force on the body (in world-space)
---@return vector3
function RigidBody:getForce() end

--	Return the total manually applied torque on the body (in world-space)
---@return vector3
function RigidBody:getTorque() end

--Return whether or not the body is allowed to sleep.
---@return boolean
function RigidBody:isAllowedToSleep() end

--Set whether or not the body is allowed to go to sleep.
---@param isAllowedToSleep boolean
function RigidBody:setIsAllowedToSleep(isAllowedToSleep) end

---@class Rp3dDebugRenderer
local DebugRenderer = {}

---@param item string rp3d.DebugRenderer.DebugItem
---@return boolean
function DebugRenderer:getIsDebugItemDisplayed(item) end

---@param item string rp3d.DebugRenderer.DebugItem
---@param isDisplayed boolean
function DebugRenderer:setIsDebugItemDisplayed(item, isDisplayed) end

---@return number
function DebugRenderer:getContactPointSphereRadius() end

---@param radius number
function DebugRenderer:setContactPointSphereRadius(radius) end

---@return number
function DebugRenderer:getContactNormalLength() end

---@param length number
function DebugRenderer:setContactNormalLength(length) end

---post draw_line messages to render
function DebugRenderer:draw() end

function DebugRenderer:reset() end

---@class Rp3dPhysicsWorld
local PhysicsWorld = {}

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

--Enable/Disable the sleeping technique.
---@param isSleepingEnabled bool
function PhysicsWorld:enableSleeping(isSleepingEnabled) end

--Return true if the sleeping technique is enabled.
---@return bool
function PhysicsWorld:isSleepingEnabled() end

--Return the time a body is required to stay still before sleeping.
---@return number
function PhysicsWorld:getTimeBeforeSleep() end

--Set the time a body is required to stay still before sleeping.
---@param timeBeforeSleep number
function PhysicsWorld:setTimeBeforeSleep(timeBeforeSleep) end

-- Return the current sleep linear velocity.
---@return number
function PhysicsWorld:getSleepLinearVelocity() end

-- 	Set the sleep linear velocity.
---@param sleepLinearVelocity number
function PhysicsWorld:setSleepLinearVelocity(sleepLinearVelocity) end

--Return the current sleep angular velocity.
---@return number
function PhysicsWorld:getSleepAngularVelocity() end

--Set the sleep angular velocity.
---@param sleepAngularVelocity number
function PhysicsWorld:setSleepAngularVelocity(sleepAngularVelocity) end

--Update the physics simulation.
---@param timeStep number
function PhysicsWorld:update(timeStep) end

--Set the number of iterations for the velocity constraint solver.
---@param nbIterations number
function PhysicsWorld:setNbIterationsVelocitySolver(nbIterations) end

--Set the number of iterations for the position constraint solver.
---@param nbIterations number
function PhysicsWorld:setNbIterationsPositionSolver(nbIterations) end

--the position correction technique used for contacts.
---@param technique number rp3d.ContactsPositionCorrectionTechnique
function PhysicsWorld:setContactsPositionCorrectionTechnique(technique) end


--Disable the joints for pair of sleeping bodies.
function PhysicsWorld:enableDisableJoints() end

--Set the gravity vector of the world.
---@param gravity vector3
function PhysicsWorld:setGravity(gravity) end

--Return if the gravity is on.
---@return  bool
function PhysicsWorld:isGravityEnabled() end

--Enable/Disable the gravity.
---@param isGravityEnabled bool
function PhysicsWorld:setIsGravityEnabled(isGravityEnabled) end

--Return the number of CollisionBody in the physics world.
---@return number
function PhysicsWorld:getNbCollisionBodies() end

--Return the number of RigidBody in the physics world.
---@return number
function PhysicsWorld:getNbRigidBodies() end

--Return true if the debug rendering is enabled.
---@return bool
function PhysicsWorld:getIsDebugRenderingEnabled() end

--Set to true if debug rendering is enabled.
---@param isEnabled bool
function PhysicsWorld:setIsDebugRenderingEnabled(isEnabled) end

--Create a collision body.
---@param transform Rp3dTransform
---@return Rp3dCollisionBody
function PhysicsWorld:createCollisionBody(transform) end

---Destroy a collision body.
---@param body Rp3dCollisionBody
function PhysicsWorld:destroyCollisionBody(body) end

--Create a rigid body into the physics world.
---@param transform Rp3dTransform
---@return Rp3dRigidBody
function PhysicsWorld:createRigidBody(transform) end

---Destroy a rigid body and all the joints which it belongs.
---@param body Rp3dRigidBody
function PhysicsWorld:destroyRigidBody(body) end

---@return Rp3dDebugRenderer
function PhysicsWorld:getDebugRenderer() end


--Return true if two bodies overlap (collide)
---@param body1 Rp3dCollisionBody
---@param body2 Rp3dCollisionBody
---@return boolean
function PhysicsWorld:testOverlap2Bodies(body1, body2) end

--Return all the bodies that overlap (collide) with the body in parameter.
--Use this method if you are not interested in contacts but if you simply want to know which bodies overlap with the body in parameter.
--If you want to get the contacts, you need to use the testCollisionBodyList() method instead.
---@param body Rp3dCollisionBody
---@return Rp3dOverlapPair[]
function PhysicsWorld:testOverlapBodyList(body) end

--Return all the bodies that overlap (collide) in the world.
--Use this method if you are not interested in contacts but if you simply want to know which bodies overlap.
--If you want to get the contacts, you need to use the testCollision() method instead.
---@return Rp3dOverlapPair[]
function PhysicsWorld:testOverlapList() end


--Use this method if you only want to get all the contacts between two bodies.
--If you are not interested in the contacts but you only want to know if the bodies collide,
--you can use the testOverlap() method instead.
---@param body1 Rp3dCollisionBody
---@return Rp3dContactPair|nil
function PhysicsWorld:testCollision2Bodies(body1, body2) end


--Test collision and report all the contacts involving the body in parameter.
--Use this method if you only want to get all the contacts involving a given body.
--If you are not interested in the contacts but you only want to know if the bodies collide,
--you can use the testOverlap() method instead.
---@param body1 Rp3dCollisionBody
---@return Rp3dContactPair[]
function PhysicsWorld:testCollisionBodyList(body1) end

--Test collision and report contacts between each colliding bodies in the world.
--Use this method if you want to get all the contacts between colliding bodies in the world.
--If you are not interested in the contacts but you only want to know if the bodies collide,
--you can use the testOverlap() method instead.
---@return Rp3dContactPair[]
function PhysicsWorld:testCollisionList() end

--Return a CollisionBody of the world
---@param index number
---@return Rp3dCollisionBody
function PhysicsWorld:getCollisionBody(index) end

--Return a RigidBody of the world
---@param index number
---@return Rp3dRigidBody
function PhysicsWorld:getRigidBody(index) end

---@param ray Rp3dRay
---@param cb Rp3dRaycastCallback
---@param categoryMaskBits number|nil
function PhysicsWorld:raycast(ray, cb, categoryMaskBits) end

---@param eventListener Rp3dEventListener|nil
function PhysicsWorld:setEventListener(eventListener) end

---@param collider Rp3dCollider
function PhysicsWorld:getWorldAABB(collider) end

--Create a joint between two bodies in the world and return a new joint.
---@param jointInfo Rp3dJointInfo
---@return Rp3dJoint
function PhysicsWorld:createJoint(jointInfo) end

--Destroy a joint.
---@param joint Rp3dJoint
function PhysicsWorld:destroyJoint(joint) end

---@class Rp3dCollisionShape
local CollisionShape = {}

---@return string rp3d.CollisionShapeType. The type of the collision shape.
---SPHERE, CAPSULE, CONVEX_POLYHEDRON, CONCAVE_SHAPE
function CollisionShape:getType() end

---@return string rp3d.CollisionShapeName. The name of the collision shape.
---TRIANGLE, SPHERE, CAPSULE, BOX, CONVEX_MESH, TRIANGLE_MESH, HEIGHTFIELD
function CollisionShape:getName() end

---@return bool true if the collision shape is a polyhedron.
function CollisionShape:isPolyhedron() end

---@return bool true if the collision shape is convex, false if it is concave.
function CollisionShape:isConvex() end

--Return the local bounds of the shape in x, y and z directions.
---@return vector3 min
---@return vector3 max
function CollisionShape:getLocalBounds() end

--Return the id of the shape.
---@return number
function CollisionShape:getId() end

--Return the local inertia tensor of the collision shapes.
---@param mass number
---@return vector3
function CollisionShape:getLocalInertiaTensor(mass) end

--Compute and return the volume of the collision shape.
---@return number
function CollisionShape:getVolume() end

--Compute the world-space AABB of the collision shape given a transform.
---@param transform Rp3dTransform
---@return Rp3dAABB
function CollisionShape:computeAABB(transform) end

---@class Rp3dConvexShape:Rp3dCollisionShape
local ConvexShape = {}

--Return the current object margin.
---@return number
function ConvexShape:getMargin() end

---@class Rp3dConvexPolyhedronShape:Rp3dConvexShape
local ConvexPolyhedronShape = {}

--Return the number of faces of the polyhedron.
---@return number
function ConvexPolyhedronShape:getNbFaces() end

--Return a given face of the polyhedron.
---@param faceIndex number
---@return Rp3dHalfEdgeStructureFace
function ConvexPolyhedronShape:getFace(faceIndex) end

--Return the number of vertices of the polyhedron.
---@return number
function ConvexPolyhedronShape:getNbVertices() end

--Return a given vertex of the polyhedron.
---@param vertexIndex number
---@return Rp3dHalfEdgeStructureVertex
function ConvexPolyhedronShape:getVertex(vertexIndex) end

--Return the position of a given vertex.
---@param vertexIndex number
---@return vector3
function ConvexPolyhedronShape:getVertexPosition(vertexIndex) end

--Return the normal vector of a given face of the polyhedron.
---@param faceIndex number
---@return vector3
function ConvexPolyhedronShape:getFaceNormal(faceIndex) end

function ConvexPolyhedronShape:getNbHalfEdges() end

--Return a given half-edge of the polyhedron.
---@param edgeIndex number
---@return Rp3dHalfEdgeStructureEdge
function ConvexPolyhedronShape:getHalfEdge(edgeIndex) end

--Return the centroid of the polyhedron.
---@return vector3
function ConvexPolyhedronShape:getCentroid() end

--Find and return the index of the polyhedron face with the most anti-parallel face normal given a direction vector.
---@param direction vector3
---@return number
function ConvexPolyhedronShape:findMostAntiParallelFace(direction) end

---@class Rp3dBoxShape:Rp3dConvexPolyhedronShape
local BoxShape = {}

--Return the half-extents of the box.
---@return vector3
function BoxShape:getHalfExtents() end

--Set the half-extents of the box.
--Note that you might want to recompute the inertia tensor and center of mass of the body after changing the size of the collision shape.
---@param halfExtents vector3
function BoxShape:setHalfExtents(halfExtents) end

---@class Rp3dSphereShape:Rp3dConvexShape
local SphereShape = {}

--Set the radius of the sphere.
--Note that you might want to recompute the inertia tensor and center of mass of the body after changing the radius of the collision shape.
---@param radius number
function SphereShape:setRadius(radius) end

--Return the radius of the sphere.
---@return number
function SphereShape:getRadius() end

---@class Rp3dCapsuleShape:Rp3dConvexShape
local CapsuleShape = {}

--Set the radius of the capsule.
--Note that you might want to recompute the inertia tensor and center of mass of the body after changing the radius of the collision shape.
---@param radius number
function CapsuleShape:setRadius(radius) end

--Return the radius of the capsule.
---@return number
function CapsuleShape:getRadius() end

--Set the height of the capsule.
--Note that you might want to recompute the inertia tensor and center of mass of the body after changing the radius of the collision shape.
---@param height number
function CapsuleShape:setHeight(height) end

--Return the height of the capsule.
---@return number
function CapsuleShape:getHeight() end

---@class Rp3dConvexMeshShape:Rp3dConvexPolyhedronShape
local ConvexMeshShape = {}

---@return vector3
function ConvexMeshShape:getScale() end

---@param scale vector3
function ConvexMeshShape:setScale(scale) end

---@class Rp3dConcaveShape:Rp3dCollisionShape
local ConcaveShape = {}

--Return the raycast test type (FRONT, BACK, FRONT_AND_BACK)
---@return string
function ConcaveShape:getRaycastTestType() end

--Set the raycast test type (FRONT, BACK, FRONT_AND_BACK)
---@param testType string
function ConcaveShape:setRaycastTestType(testType) end

--Return the scale.
---@return vector3
function ConcaveShape:getScale() end

--Set the scale.
--Note that you might want to recompute the inertia tensor and center of mass of the body after changing the scale of a collision shape.
---@param scale vector3
function ConcaveShape:setScale(scale) end

---@class Rp3dConcaveMeshShape:Rp3dConcaveShape
local ConcaveMeshShape = {}

--Return the number of sub parts contained in this mesh.
---@return number
function ConcaveMeshShape:getNbSubparts() end

--Return the number of triangles in a sub part of the mesh.
---@param subPart number
---@return number
function ConcaveMeshShape:getNbTriangles(subPart) end

--Return the indices of the three vertices of a given triangle in the array.
---@param subPart number
---@param triangleIndex number
---@return vector3[]
function ConcaveMeshShape:getTriangleVerticesIndices(subPart, triangleIndex) end

---@class Rp3dHeightFieldShape:Rp3dConcaveShape
local HeightFieldShape = {}

--Return the number of rows in the height field.
---@return number
function HeightFieldShape:getNbRows() end

--Return the number of columns in the height field.
---@return number
function HeightFieldShape:getNbColumns() end

--Return the vertex (local-coordinates) of the height field at a given (x,y) position.
---@param x number
---@param y number
---@return vector3
function HeightFieldShape:getVertexAt(x, y) end

--Return the height of a given (x,y) point in the height field.
---@param x number
---@param y number
---@return number
function HeightFieldShape:getHeightAt(x, y) end

---@return string rp3d.getHeightDataType.The type of height value in the height field.
---HEIGHT_FLOAT_TYPE, HEIGHT_DOUBLE_TYPE, HEIGHT_INT_TYPE
function HeightFieldShape:getHeightDataType() end

---@class Rp3dAABB
local Rp3dAABB = {}

--Return the center point.
---@return vector3
function Rp3dAABB:getCenter() end

--Return the minimum coordinates of the AABB.
---@return vector3
function Rp3dAABB:getMin() end

--Set the minimum coordinates of the AABB.
---@param vector3 number
function Rp3dAABB:setMin(min) end

--Return the maximum coordinates of the AABB.
---@return vector3
function Rp3dAABB:getMax() end

--Set the maximum coordinates of the AABB.
---@param max vector3
function Rp3dAABB:setMax(max) end

--Return the size of the AABB in the three dimension x, y and z.
---@return vector3
function Rp3dAABB:getExtent() end

--Inflate each side of the AABB by a given size.
---@param x number
---@param y number
---@param z number
function Rp3dAABB:inflate(x, y, z) end


--Return true if the current AABB is overlapping with the AABB in argument.
--Two AABBs overlap if they overlap in the three x, y and z axis at the same time.
---@param aabb Rp3dAABB
---@return bool
function Rp3dAABB:testCollision(aabb) end

--Return the volume of the AABB.
---@return number
function Rp3dAABB:getVolume() end

--Merge the AABB in parameter with the current one.
---@param aabb Rp3dAABB
function Rp3dAABB:mergeWithAABB(aabb) end

--Replace the current AABB with a new AABB that is the union of two AABBs in parameters.
---@param aabb1 Rp3dAABB
---@param aabb2 Rp3dAABB
function Rp3dAABB:mergeTwoAABBs(aabb1, aabb2) end

--Return true if the current AABB contains the AABB given in parameter.
---@param aabb Rp3dAABB
---@return bool
function Rp3dAABB:contains(aabb) end

--Return true if a point is inside the AABB.
---@param point vector3
---@return bool
function Rp3dAABB:containsPoint(point) end

--Return true if the AABB of a triangle intersects the AABB.
---@param p1 vector3
---@param p2 vector3
---@param p3 vector3
---@return bool
function Rp3dAABB:testCollisionTriangleAABB(p1, p2, p3) end


--Return true if the ray intersects the AABB.
---@param rayOrigin vector3
---@param rayDirectionInv vector3 inverse 1 / rayDirection.x, 1 / rayDirection.y, 1 / rayDirection.z);
---@param rayMaxFraction number
---@return bool
function Rp3dAABB:testRayIntersect(rayOrigin, rayDirectionInv, rayMaxFraction) end

--Compute the intersection of a ray and the AABB.
---@param ray Rp3dRay infinity ray. Ignore maxFraction. Ignore distance of ray
---@return nil|vector3
function Rp3dAABB:raycast(ray) end


--Apply a scale factor to the AABB.
---@param scale vector3
function Rp3dAABB:applyScale(scale) end

---@class Rp3dTriangleMesh
local Rp3dTriangleMesh = {}

--Add a subpart of the mesh.
---@param triangleVertexArray Rp3dTriangleVertexArray
function Rp3dTriangleMesh:addSubpart(triangleVertexArray) end


--Return a subpart (triangle vertex array) of the mesh.
---@param indexSubpart number
---@return Rp3dTriangleVertexArray
function Rp3dTriangleMesh:getSubpart(indexSubpart) end

--Return the number of subparts of the mesh.
---@return number
function Rp3dTriangleMesh:getNbSubparts() end

---@class Rp3dTriangleVertexArray
local Rp3dTriangleVertexArray = {}

--Return the number of vertices.
---@return number
function Rp3dTriangleVertexArray:getNbVertices() end

--Return the number of triangles.
---@return number
function Rp3dTriangleVertexArray:getNbTriangles() end

--Return the vertices coordinates of a triangle.
---@param triangleIndex number
---@return vector3[]
function Rp3dTriangleVertexArray:getTriangleVertices(triangleIndex) end

--Return the three vertices normals of a triangle.
---@param triangleIndex number
---@return vector3[]
function Rp3dTriangleVertexArray:getTriangleVerticesNormals(triangleIndex) end


--Return the vertices coordinates of a triangle.
---@param triangleIndex number
---@return number[]
function Rp3dTriangleVertexArray:getTriangleVerticesIndices(triangleIndex) end

--Return a vertex of the array.
---@param vertexIndex number
---@return vector3
function Rp3dTriangleVertexArray:getVertex(vertexIndex) end

--Return a vertex normal of the array.
---@param vertexIndex number
---@return vector3
function Rp3dTriangleVertexArray:getNormal(vertexIndex) end



--Create and return an instance of PhysicsWorld.
---@param settings Rp3dWorldSettings
---@return Rp3dPhysicsWorld
function rp3d.createPhysicsWorld(settings) end

---@param world Rp3dPhysicsWorld
function rp3d.destroyPhysicsWorld(world) end


--Create and return a box collision shape.
---@param halfExtents vector3
---@return Rp3dBoxShape
function rp3d.createBoxShape(halfExtents) end

--Destroy a box collision shape.
---@param boxShape Rp3dBoxShape
function rp3d.destroyBoxShape(boxShape) end

--Create and return a sphere collision shape.
---@param radius number
---@return Rp3dSphereShape
function rp3d.createSphereShape(radius) end

--Destroy a sphere collision shape.
---@param sphereShape Rp3dSphereShape
function rp3d.destroySphereShape(sphereShape) end

--Create and return a capsule collision shape.
---@param radius number
---@param height number
---@return Rp3dCapsuleShape
function rp3d.createCapsuleShape(radius, height) end

--Destroy a capsule collision shape.
---@param capsuleShape Rp3dCapsuleShape
function rp3d.destroyCapsuleShape(capsuleShape) end

--Create a polyhedron mesh.
---@param vertices number[]
---@param indices number[]
---@param indices Rp3dPolygonFace[]
---@return Rp3dPolyhedronMesh
function rp3d.createPolyhedronMesh(vertices, indices, polygonFaces) end

--Create a polyhedron mesh, from mesh vertices
---@param buffer buffer
---@return Rp3dPolyhedronMesh
function rp3d.createPolyhedronMeshFromMeshVerticesCopy(buffer) end

--Destroy a polyhedron mesh.
---@param polyhedronMesh Rp3dPolyhedronMesh
function rp3d.destroyPolyhedronMesh(polyhedronMesh) end


--Create and return a convex mesh collision shape.
---@param mesh Rp3dPolyhedronMesh
---@return Rp3dConvexMeshShape
function rp3d.createConvexMeshShape(mesh) end

--Destroy a capsule collision shape.
---@param convexMeshShape Rp3dConvexMeshShape
function rp3d.destroyConvexMeshShape(convexMeshShape) end

---@param triangleMesh Rp3dTriangleMesh
---@param scaling vector3|nil
---@return Rp3dConvexMeshShape
function rp3d.createConcaveMeshShape(triangleMesh, scaling) end

---@param concaveMeshShape Rp3dConcaveMeshShape
function rp3d.destroyConcaveMeshShape(concaveMeshShape) end

---@param vertices number[]
---@param indices number[]
---@return Rp3dTriangleVertexArray
function rp3d.createTriangleVertexArray(vertices, indices) end

---@param buffer buffer
function rp3d.createTriangleVertexArrayFromMeshVerticesCopy(buffer) end

---@param triangleArray Rp3dTriangleVertexArray
function rp3d.destroyTriangleVertexArray(triangleArray) end

---@return Rp3dTriangleMesh
function rp3d.createTriangleMesh() end

---@param triangleMesh Rp3dTriangleMesh
function rp3d.destroyTriangleMesh(triangleMesh) end

---@param nbGridColumns number
---@param nbGridRows number
---@param minHeight number
---@param maxHeight number
---@param heightFieldData number[]
---@param dataType string rp3d.HeightDataType
---@param upAxis number [0,2] optional
---@param integerHeightScale number optional
---@param scaling vector3 optional
---@return Rp3dHeightFieldShape
function rp3d.createHeightFieldShape(nbGridColumns, nbGridRows, minHeight, maxHeight, heightFieldData, dataType, upAxis, integerHeightScale, scaling) end

function rp3d.destroyHeightFieldShape(heightFieldShape) end

--Create AABB
---@param minCoordinates vector3
---@param maxCoordinates vector3
---@return Rp3dAABB
function rp3d.createAABB(minCoordinates, maxCoordinates) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param anchorPointBody1LocalSpace vector3
---@param anchorPointBody2LocalSpace vector3
---@return Rp3dBallAndSocketJointInfo
function rp3d.createBallAndSocketJointInfoLocalSpace(body1, body2, anchorPointBody1LocalSpace, anchorPointBody2LocalSpace) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param initAnchorPointWorldSpace vector3
---@return Rp3dBallAndSocketJointInfo
function rp3d.createBallAndSocketJointInfoWorldSpace(body1, body2, initAnchorPointWorldSpace) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param anchorPointBody1Local vector3
---@param anchorPointBody2Local vector3
---@param rotationBody1AxisLocal vector3
---@param rotationBody2AxisLocal vector3
---@return Rp3dHingeJointInfo
function rp3d.createHingeJointInfoLocalSpace(body1, body2, anchorPointBody1Local, anchorPointBody2Local,
											 rotationBody1AxisLocal, rotationBody2AxisLocal) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param initAnchorPointWorldSpace vector3
---@param initRotationAxisWorld vector3
---@return Rp3dHingeJointInfo
function rp3d.createHingeJointInfoWorldSpace(body1, body2, initAnchorPointWorldSpace, initRotationAxisWorld) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param anchorPointBody1Local vector3
---@param anchorPointBody2Local vector3
---@param sliderAxisBody1Local vector3
---@return Rp3dSliderJointInfo
function rp3d.createSliderJointInfoLocalSpace(body1, body2, anchorPointBody1Local, anchorPointBody2Local,
											  sliderAxisBody1Local) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param initAnchorPointWorldSpace vector3
---@param initSliderAxisWorldSpace vector3
---@return Rp3dSliderJointInfo
function rp3d.createSliderJointInfoWorldSpace(body1, body2, initAnchorPointWorldSpace, initSliderAxisWorldSpace) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param anchorPointBody1Local vector3
---@param anchorPointBody2Local vector3
---@return Rp3dFixedJointInfo
function rp3d.createFixedJointInfoLocalSpace(body1, body2, anchorPointBody1Local, anchorPointBody2Local) end

---@param body1 Rp3dRigidBody
---@param body2 Rp3dRigidBody
---@param initAnchorPointWorldSpace vector3
---@return Rp3dFixedJointInfo
function rp3d.createFixedJointInfoWorldSpace(body1, body2, initAnchorPointWorldSpace) end


rp3d.ContactsPositionCorrectionTechnique = {
	BAUMGARTE_CONTACTS = "BAUMGARTE_CONTACTS",
	SPLIT_IMPULSES = "SPLIT_IMPULSES",
}

rp3d.CollisionShapeName = {
	TRIANGLE = "TRIANGLE",
	SPHERE = "SPHERE",
	CAPSULE = "CAPSULE",
	BOX = "BOX",
	CONVEX_MESH = "CONVEX_MESH",
	RIANGLE_MESH = "TRIANGLE_MESH",
	HEIGHTFIELD = "HEIGHTFIELD"
}

rp3d.CollisionShapeType = {
	SPHERE = "SPHERE",
	CAPSULE = "CAPSULE",
	CONVEX_POLYHEDRON = "CONVEX_POLYHEDRON",
	CONCAVE_SHAPE = "CONCAVE_SHAPE"
}
--Enumeration for the type of a body
-- STATIC : A static body has infinite mass, zero velocity but the position can be
--          changed manually. A static body does not collide with other static or kinematic bodies.
-- KINEMATIC : A kinematic body has infinite mass, the velocity can be changed manually and its
--             position is computed by the physics engine. A kinematic body does not collide with
--             other static or kinematic bodies.
-- DYNAMIC : A dynamic body has non-zero mass, non-zero velocity determined by forces and its
--           position is determined by the physics engine. A dynamic body can collide with other
--           dynamic, static or kinematic bodies.
rp3d.BodyType = {
	STATIC = "STATIC",
	KINEMATIC = "KINEMATIC",
	DYNAMIC = "DYNAMIC"
}

rp3d.DebugRenderer = {
	DebugItem = {
		COLLIDER_AABB = "COLLIDER_AABB",
		COLLIDER_BROADPHASE_AABB = "COLLIDER_BROADPHASE_AABB",
		COLLISION_SHAPE = "COLLISION_SHAPE",
		CONTACT_POINT = "CONTACT_POINT",
		CONTACT_NORMAL = "CONTACT_NORMAL",
	},
}

rp3d.OverlapPair = {
	EventType = {
		OverlapStart = "OverlapStart",
		OverlapStay = "OverlapStay",
		OverlapExit = "OverlapExit",
	},
}

rp3d.ContactPair = {
	EventType = {
		ContactStart = "ContactStart",
		ContactStay = "ContactStay",
		ContactExit = "ContactExit",
	},
}

rp3d.TriangleRaycastSide = {
	FRONT = "FRONT",
	BACK = "BACK",
	FRONT_AND_BACK = "FRONT_AND_BACK"
}

rp3d.HeightDataType = {
	HEIGHT_FLOAT_TYPE = "HEIGHT_FLOAT_TYPE",
	HEIGHT_DOUBLE_TYPE = "HEIGHT_DOUBLE_TYPE",
	HEIGHT_INT_TYPE = "HEIGHT_INT_TYPE"
}

rp3d.JointType = {
	BALLSOCKETJOINT = "BALLSOCKETJOINT",
	SLIDERJOINT = "SLIDERJOINT",
	HINGEJOINT = "HINGEJOINT",
	FIXEDJOINT = "FIXEDJOINT"
}

rp3d.JointsPositionCorrectionTechnique = {
	BAUMGARTE_JOINTS = "BAUMGARTE_JOINTS",
	NON_LINEAR_GAUSS_SEIDEL = "NON_LINEAR_GAUSS_SEIDEL",
}



