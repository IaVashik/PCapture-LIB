// Collides with everything.
const COLLISION_GROUP_NONE = 0

// Small objects, doesn't interfere with gameplay.
const COLLISION_GROUP_DEBRIS = 1

// Like DEBRIS, but ignores PUSHAWAY.
const COLLISION_GROUP_DEBRIS_TRIGGER = 2 

// Like DEBRIS, but doesn't collide with same group.
const COLLISION_GROUP_INTERACTIVE_DEBRIS = 3

// Interactive entities, ignores debris.
const COLLISION_GROUP_INTERACTIVE = 4

// Used by players, ignores PASSABLE_DOOR.
const COLLISION_GROUP_PLAYER = 5

// Breakable glass, ignores same group and NPC line-of-sight.
const COLLISION_GROUP_BREAKABLE_GLASS = 6

// Driveable vehicles, always collides with VEHICLE_CLIP.
const COLLISION_GROUP_VEHICLE = 7

// Player movement collision.
const COLLISION_GROUP_PLAYER_MOVEMENT = 8

// Used by NPCs, always collides with DOOR_BLOCKER.
const COLLISION_GROUP_NPC = 9

// Entities inside vehicles, no collisions. 
const COLLISION_GROUP_IN_VEHICLE = 10 

// Weapons, including dropped ones. 
const COLLISION_GROUP_WEAPON = 11 

// Only collides with VEHICLE.
const COLLISION_GROUP_VEHICLE_CLIP = 12

// Projectiles, ignore other projectiles.
const COLLISION_GROUP_PROJECTILE = 13

// Blocks NPCs, may collide with some projectiles.
const COLLISION_GROUP_DOOR_BLOCKER = 14

// Passable doors, allows players through.
const COLLISION_GROUP_PASSABLE_DOOR = 15 

// Dissolved entities, only collide with NONE.
const COLLISION_GROUP_DISSOLVING = 16

// Pushes props away from the player.
const COLLISION_GROUP_PUSHAWAY = 17

// NPCs potentially stuck in a player.
const COLLISION_GROUP_NPC_ACTOR = 18

// NPCs in scripted sequences with collisions disabled. 
const COLLISION_GROUP_NPC_SCRIPTED = 19



// No collision at all.
const SOLID_NONE = 0 

// Uses Quake Physics engine.
const SOLID_BSP = 1 

// Uses an axis-aligned bounding box (AABB).
const SOLID_VPHYSICS = 2

// Uses an oriented bounding box (OBB).
const SOLID_OBB = 3 

// Uses an OBB constrained to yaw rotation.
const SOLID_OBB_YAW = 4 

// Custom/test solid type.
const SOLID_CUSTOM = 5 

// Uses VPhysics engine for realistic physics. 
const SOLID_VPHYSICS = 6 