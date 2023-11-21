extends CharacterBody2D

const MOVE_SPEED = 600.0
const MAX_DISTANCE = 350.0

enum HookMoveState {NONE, MOVING, RETURNING}

var current_state : HookMoveState
var shoot_position : Vector2
var move_dir

signal spawned
signal collided(collision_pos)
signal max_distance_reached

func _on_spawned():
	move_dir = position.direction_to(get_global_mouse_position())
	shoot_position = position
	current_state = HookMoveState.MOVING

func _on_collided(_collision_pos):
	current_state = HookMoveState.NONE

func _on_hook_released():
	queue_free()

func _on_max_distance_reached():
	current_state = HookMoveState.RETURNING
	set_collision_mask_value(1, false)

# HOOK MOVEMENT

func _physics_process(delta):
	if current_state == HookMoveState.MOVING:
		process_moving(delta)
	elif current_state == HookMoveState.RETURNING:
		process_returning()

func process_moving(delta):
	var distance_traveled = position.distance_to(shoot_position)
	
	var collision = move_and_collide(move_dir * MOVE_SPEED * delta)
	
	if distance_traveled >= MAX_DISTANCE:
		max_distance_reached.emit()
		return
	
	if not collision:
		return
	
	collided.emit(collision.get_position())

func process_returning():
	var direction = position.direction_to(GameMan.get_player().position)
	
	velocity = direction * MOVE_SPEED
	move_and_slide()
	
	var distance = position.distance_to(GameMan.get_player().position)
	if distance < 20:
		queue_free()
