extends CharacterBody2D
class_name HookMovement

const MOVE_SPEED = 500.0
const RETURN_SPEED_MULTIPLIER = 2.1
const MAX_DISTANCE = 180.0
const RANGE_EXPANSION_DISTANCE_INCREASE = 22.5

enum HookMoveState {DISABLED, STILL, MOVING, RETURNING}

var current_state : HookMoveState
var move_dir
var hooked_obj

signal spawned
signal collided(collision : KinematicCollision2D)
signal max_distance_reached

func _ready():
	current_state = HookMoveState.RETURNING

func _on_spawned():
	move_dir = global_position.direction_to(get_global_mouse_position())
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(move_dir))
	current_state = HookMoveState.MOVING
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true)
	hooked_obj = null
	$Hook.visible = true

func _on_collided(collision):
	current_state = HookMoveState.STILL
	
	var dir = global_position.direction_to(collision.get_position())
	
	if abs(dir.x) > abs(dir.y):
		dir.x = clamp(dir.x * 100, -1, 1)
		dir.y = 0
	else:
		dir.y = clamp(dir.y * 100, -1, 1)
		dir.x = 0
	
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(dir))
	
	if hooked_obj:
		if not hooked_obj.static_object:
			$Hook.visible = false

func _on_hook_released():
	visible = false

func _on_max_distance_reached():
	current_state = HookMoveState.RETURNING
	set_collision_mask_value(1, false)
	set_collision_mask_value(4, false)

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
		move_speed *= PlayerMovement.HOOK_UPGRADE_SPEED_MULTIPLIER + (PlayerMovement.HOOK_SPEED_EXPANSION_MULTIPLIER_INCREASE * GameMan.get_expansion_count(GameMan.ExpansionType.SPEED))
		max_distance *= PlayerMovement.HOOK_UPGRADE_SPEED_MULTIPLIER
	else:
		move_speed *= 1 + PlayerMovement.HOOK_SPEED_EXPANSION_MULTIPLIER_INCREASE * GameMan.get_expansion_count(GameMan.ExpansionType.SPEED)
	max_distance += RANGE_EXPANSION_DISTANCE_INCREASE * GameMan.get_expansion_count(GameMan.ExpansionType.RANGE)
	
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
	
	var move_speed = MOVE_SPEED
	
	velocity = direction * MOVE_SPEED * RETURN_SPEED_MULTIPLIER
	move_and_slide()
	
	var distance = position.distance_to(GameMan.get_player().position)
	if distance < 20:
		visible = false

func process_still():
	if is_instance_valid(hooked_obj):
		if not hooked_obj.static_object:
			global_position = hooked_obj.global_position
