extends CharacterBody2D
class_name HookMovement

const MOVE_SPEED = 500.0
const RETURN_SPEED_MULTIPLIER = 1.2
const MAX_DISTANCE = 180.0

enum HookMoveState {DISABLED, STILL, MOVING, RETURNING}

var current_state : HookMoveState
var move_dir
var hooked_obj

signal spawned
signal collided(collision : KinematicCollision2D)
signal max_distance_reached

func _on_spawned():
	move_dir = global_position.direction_to(get_global_mouse_position())
	current_state = HookMoveState.MOVING
	set_collision_mask_value(1, true)
	hooked_obj = null

func _on_collided(collision):
	current_state = HookMoveState.STILL
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position.direction_to(collision.get_collider().global_position)))

func _on_hook_released():
	visible = false

func _on_max_distance_reached():
	current_state = HookMoveState.RETURNING
	set_collision_mask_value(1, false)

# HOOK MOVEMENT

func _physics_process(delta):
	if current_state == HookMoveState.MOVING:
		process_moving(delta)
	elif current_state == HookMoveState.RETURNING:
		process_returning()
	elif current_state == HookMoveState.STILL:
		process_still()

func process_moving(delta):
	var distance_traveled = position.distance_to(GameMan.get_player().global_position)
	
	var move_speed = MOVE_SPEED
	var max_distance = MAX_DISTANCE
	if GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		move_speed *= PlayerMovement.HOOK_UPGRADE_SPEED_MULTIPLIER
		max_distance *= PlayerMovement.HOOK_UPGRADE_SPEED_MULTIPLIER
	
	var collision = move_and_collide(move_dir * move_speed * delta)
	
	if distance_traveled >= max_distance:
		max_distance_reached.emit()
		return
	
	if not collision:
		return
	
	var collider = collision.get_collider()
	if collider is HookableObject:
		hooked_obj = collider
	
	collided.emit(collision)

func process_returning():
	var direction = position.direction_to(GameMan.get_player().position)
	
	velocity = direction * MOVE_SPEED * RETURN_SPEED_MULTIPLIER
	move_and_slide()
	
	var distance = position.distance_to(GameMan.get_player().position)
	if distance < 20:
		visible = false

func process_still():
	if hooked_obj:
		global_position = hooked_obj.global_position
