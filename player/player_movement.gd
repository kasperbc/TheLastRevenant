extends CharacterBody2D
class_name PlayerMovement

const SPEED = 150.0
const ACCELERATION = 600.0
const FRICTION = 450.0
const AIR_FRICTION = 200.0
const SNAP_VELOCITY = 50.0
const MIN_VELOCITY_FRICTION_EFFECTS = 175.0

const JUMP_HEIGHT = 50.0
const JUMP_TIME_TO_PEAK = 0.45
const JUMP_TIME_TO_DESCENT = 0.4

const HOOK_BASE_FLY_SPEED = 275.0
const HOOK_MAX_FLY_SPEED = 550.0
const HOOK_ACCELERATION = 125.0
const HOOK_UPGRADE_SPEED_MULTIPLIER = 1.2
const HOOK_JUMP_BASE_STRENGTH = 1
const HOOK_JUMP_MIN_STRENGTH = 0.75
const HOOK_JUMPS_BEFORE_MIN_STRENGTH = 4
const HOOK_WALL_JUMP_STRENGTH = 150.0
const MAX_HOOKS = 1

const HOOK_ATTACK_DISTANCE = 150.0

enum MoveState {NORMAL, HOOKED_FLYING, HOOKED}
var current_state : MoveState

signal hook_fired
signal hook_released
signal hook_released_early

@onready var jump_velocity : float = ((-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
@onready var jump_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
@onready var fall_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0
@onready var hook_jump_deplete_rate : float = (HOOK_JUMP_BASE_STRENGTH - HOOK_JUMP_MIN_STRENGTH) / HOOK_JUMPS_BEFORE_MIN_STRENGTH

@onready var hook_obj = preload("res://objects/hook/hook.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_velocity

var hook_position : Vector2
var hook_speed : float
var hook_jump_strength : float
var last_distance : float

var _hooked_obj
var hooked_obj : 
	get: 
		return get_hooked_obj() 
	set(value): 
		set_hooked_obj(value)

func _physics_process(delta):
	
	if current_state == MoveState.NORMAL:
		process_normal_movement(delta)
	elif current_state == MoveState.HOOKED_FLYING:
		process_hook_flying(delta)
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
		# $jumpboom.play()
	horizontal_move(delta)
	
	if Input.is_action_just_pressed("fire_hook") and GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
		hook_fired.emit()


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func apply_gravity(delta):
	velocity.y += get_gravity() * delta

func jump():
	if not is_on_floor():
		return
	
	velocity.y = -jump_velocity

func horizontal_move(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	$FrictionParticles.emitting = false
	
	if direction:
		var direction_opposite_to_velocity = clamp(direction * 100, -1, 1) + clamp(velocity.x, -1, 1) == 0
		if (abs(velocity.x) < SNAP_VELOCITY or direction_opposite_to_velocity) and is_on_floor() and abs(velocity.x) < SPEED * 1.5:
			velocity.x = SNAP_VELOCITY * direction
		
		if abs(velocity.x) > SPEED and not direction_opposite_to_velocity:
			apply_friction(delta)
			return
		
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		apply_friction(delta)
	
	

func apply_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		if abs(velocity.x) > MIN_VELOCITY_FRICTION_EFFECTS:
			$FrictionParticles.emitting = true
	else:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)

func _on_hook_fired():
	if get_hooks_fired_amount() >= MAX_HOOKS:
		return
	
	var hook_instance = hook_obj.instantiate()
	get_parent().add_child(hook_instance)
	hook_instance.position = position
	hook_instance.spawned.emit()
	
	hook_instance.collided.connect(_on_hook_collided)
	hook_released.connect(hook_instance._on_hook_released)
	hook_released_early.connect(hook_instance._on_max_distance_reached)

func get_hooks_fired_amount() -> int:
	return get_tree().get_nodes_in_group("Hooks").size()

func _on_hook_collided(collision : KinematicCollision2D):
	current_state = MoveState.HOOKED_FLYING
	hook_position = collision.get_position()
	hook_speed = HOOK_BASE_FLY_SPEED
	
	if GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		hook_speed *= HOOK_UPGRADE_SPEED_MULTIPLIER
	
	var _hooked_obj = collision.get_collider()
	if _hooked_obj is HookableObject:
		hooked_obj = _hooked_obj
		hooked_obj._on_hook_attached()

# HOOK MOVEMENT

func process_hook_flying(delta):
	if hooked_obj:
		hook_position = hooked_obj.global_position
	
	# Fly towards hook position
	var direction = position.direction_to(hook_position)
	
	var max_speed = HOOK_MAX_FLY_SPEED
	var acceleration_speed = HOOK_ACCELERATION
	if GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		max_speed *= HOOK_UPGRADE_SPEED_MULTIPLIER
		acceleration_speed *= HOOK_UPGRADE_SPEED_MULTIPLIER
	
	hook_speed = move_toward(hook_speed, max_speed, acceleration_speed * delta)
	velocity = direction * hook_speed
	
	# Check if close enough to hook
	var distance = position.distance_to(hook_position)
	
	if abs(last_distance - distance) < 1:
		current_state = MoveState.HOOKED
		
		if hooked_obj:
			hooked_obj._on_player_attached()
		return
		
	last_distance = distance
	
	if Input.is_action_just_pressed("jump"):
		hook_released_early.emit()
		return
	
	# Hook counter
	if Input.is_action_just_pressed("hook_attack"):
		hook_attack()
		return

func hook_attack():
	if not GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		return
	
	if not hooked_obj:
		return
	
	if not global_position.distance_to(hook_position) < HOOK_ATTACK_DISTANCE:
		return
	
	hooked_obj._on_player_attacked()

func process_hooked():
	if hooked_obj:
		hook_position = hooked_obj.global_position
	
	if global_position.distance_to(hook_position) > 10.0:
		current_state = MoveState.HOOKED_FLYING
	
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("jump"):
		hook_released.emit()
		hook_jump()
		# $jumpboom.play()
	if Input.is_action_just_pressed("fire_hook"):
		hook_released.emit()


func _on_hook_released():
	current_state = MoveState.NORMAL
	
	if hooked_obj:
		hooked_obj._on_player_detached()
	
	hooked_obj = null

func hook_jump():
	hook_jump_strength -= hook_jump_deplete_rate
	hook_jump_strength = clamp(hook_jump_strength, HOOK_JUMP_MIN_STRENGTH, 1.0)
	
	velocity.y = -jump_velocity * hook_jump_strength
	velocity.x = -position.direction_to(hook_position).x * HOOK_WALL_JUMP_STRENGTH * hook_jump_strength

func _on_hook_released_early():
	current_state = MoveState.NORMAL
	
	if hooked_obj:
		hooked_obj._on_hook_detached()
	
	hooked_obj = null

func set_hooked_obj(value):
	_hooked_obj = value

func get_hooked_obj():
	if is_instance_valid(_hooked_obj):
		return _hooked_obj
	else:
		hooked_obj = null
		return null
