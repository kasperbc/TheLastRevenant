extends CharacterBody2D

const SPEED = 200.0

const JUMP_HEIGHT = 100.0
const JUMP_TIME_TO_PEAK = 0.5
const JUMP_TIME_TO_DESCENT = 0.4

@onready var jump_velocity : float = ((-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
@onready var jump_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
@onready var fall_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_velocity

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		apply_gravity(delta)

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		jump()

	horizontal_move()

	move_and_slide()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func apply_gravity(delta):
	velocity.y += get_gravity() * delta

func jump():
	if not is_on_floor():
		return
	
	print(jump_velocity)
	velocity.y = -jump_velocity

func horizontal_move():
	var direction = Input.get_axis("move_left", "move_right")
	
	
	
#	if direction:
#		velocity.x = direction * SPEED
#	else:
	velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
