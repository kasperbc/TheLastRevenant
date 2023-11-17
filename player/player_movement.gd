extends CharacterBody2D

const SPEED = 150.0

const JUMP_HEIGHT = 100.0
const JUMP_TIME_TO_PEAK = 0.45
const JUMP_TIME_TO_DESCENT = 0.4

const HOOK_FLY_SPEED = 300.0

enum MoveState {NORMAL, HOOKED_FLYING, HOOKED}
var current_state : MoveState

@onready var jump_velocity : float = ((-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
@onready var jump_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
@onready var fall_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_velocity

var hook_position : Vector2

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

func horizontal_move():
	var direction = Input.get_axis("move_left", "move_right")

	velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)

func fire_hook():
	current_state = MoveState.HOOKED_FLYING

# HOOK MOVEMENT

func process_hook_flying():
	# Fly towards hook position
	var direction = position.direction_to(hook_position)
	velocity = direction * HOOK_FLY_SPEED
	
	# Check if close enough to hook
	var distance = position.distance_to(hook_position)
	if distance < 1:
		current_state = MoveState.HOOKED

func process_hooked():
	velocity = Vector2.ZERO
