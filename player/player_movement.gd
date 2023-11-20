extends CharacterBody2D

const SPEED = 150.0

const JUMP_HEIGHT = 100.0
const JUMP_TIME_TO_PEAK = 0.45
const JUMP_TIME_TO_DESCENT = 0.4
const HOOK_FLY_SPEED = 500.0
const HOOK_JUMP_BASE_STRENGTH = 0.75
const HOOK_JUMP_MIN_STRENGTH = 0.5
const HOOK_JUMPS_BEFORE_MIN_STRENGTH = 4
const MAX_HOOKS = 1

enum MoveState {NORMAL, HOOKED_FLYING, HOOKED}
var current_state : MoveState

signal hook_released

@onready var jump_velocity : float = ((-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
@onready var jump_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
@onready var fall_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0
@onready var hook_jump_deplete_rate : float = (HOOK_JUMP_BASE_STRENGTH - HOOK_JUMP_MIN_STRENGTH) / HOOK_JUMPS_BEFORE_MIN_STRENGTH

@onready var hook_obj = preload("res://objects/hook.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_velocity
var hook_position : Vector2
var hook_jump_strength : float
var last_distance : float

func _physics_process(delta):
	
	if current_state == MoveState.NORMAL:
		process_normal_movement(delta)
	elif current_state == MoveState.HOOKED_FLYING:
		process_hook_flying()
	elif current_state == MoveState.HOOKED:
		process_hooked()
	
	move_and_slide()

# NORMAL MOVEMENT

func process_normal_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		apply_gravity(delta)
	else:
		hook_jump_strength = HOOK_JUMP_BASE_STRENGTH

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		jump()

	horizontal_move()
	
	if Input.is_action_just_pressed("fire_hook"):
		fire_hook()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func apply_gravity(delta):
	velocity.y += get_gravity() * delta

func jump():
	if not is_on_floor():
		return
	
	velocity.y = -jump_velocity

func hook_jump():
	hook_jump_strength -= hook_jump_deplete_rate
	hook_jump_strength = clamp(hook_jump_strength, HOOK_JUMP_MIN_STRENGTH, 1.0)
	
	velocity.y = -jump_velocity * hook_jump_strength

func horizontal_move():
	var direction = Input.get_axis("move_left", "move_right")

	velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)

func fire_hook():
	var hooks_fired = get_tree().get_nodes_in_group("Hooks").size()
	
	if hooks_fired >= MAX_HOOKS:
		return
	
	var hook_instance = hook_obj.instantiate()
	get_parent().add_child(hook_instance)
	hook_instance.position = position
	hook_instance.spawned.emit()
	
	hook_instance.collided.connect(_on_hook_collided)
	hook_released.connect(hook_instance._on_hook_released)

func _on_hook_collided(collision_pos):
	current_state = MoveState.HOOKED_FLYING
	hook_position = collision_pos

# HOOK MOVEMENT

func process_hook_flying():
	# Fly towards hook position
	var direction = position.direction_to(hook_position)
	velocity = direction * HOOK_FLY_SPEED
	
	# Check if close enough to hook
	var distance = position.distance_to(hook_position)
	
	if abs(last_distance - distance) < 1:
		current_state = MoveState.HOOKED
		
	last_distance = distance

func process_hooked():
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("jump"):
		hook_released.emit()
		hook_jump()
	
	if Input.is_action_just_pressed("fire_hook"):
		hook_released.emit()


func _on_hook_released():
	current_state = MoveState.NORMAL
