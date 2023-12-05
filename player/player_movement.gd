extends CharacterBody2D
class_name PlayerMovement

const SPEED = 150.0
const SPEED_EXPANSION_INCREASE = 12.5
const ACCELERATION = 600.0
const FRICTION = 600.0
const AIR_FRICTION = 200.0
const SNAP_VELOCITY = 50.0
const MIN_VELOCITY_FRICTION_EFFECTS = 175.0

const JUMP_HEIGHT = 50.0
const JUMP_TIME_TO_PEAK = 0.45
const JUMP_TIME_TO_DESCENT = 0.4
const SPEED_EXPANSION_GRAVITY_DECREASE = 50

const HOOK_BASE_FLY_SPEED = 275.0
const HOOK_MAX_FLY_SPEED = 550.0
const HOOK_ACCELERATION = 125.0
const HOOK_UPGRADE_SPEED_MULTIPLIER = 1.2
const HOOK_SPEED_EXPANSION_MULTIPLIER_INCREASE = 0.105
const HOOK_JUMP_BASE_STRENGTH = 1
const HOOK_JUMP_MIN_STRENGTH = 0.75
const HOOK_JUMPS_BEFORE_MIN_STRENGTH = 4
const HOOK_WALL_JUMP_STRENGTH = 150.0

const HOOK_ATTACK_DISTANCE = 150.0
const BOMB_COOLDOWN = 3.0

enum MoveState {NORMAL, HOOKED_FLYING, HOOKED, DEBUG}
var current_state : MoveState

signal hook_fired
signal hook_released
signal hook_released_early

@onready var jump_velocity : float = ((-2.0 * JUMP_HEIGHT) / JUMP_TIME_TO_PEAK) * -1.0
@onready var jump_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK)) * -1.0
@onready var fall_gravity : float = ((-2.0 * JUMP_HEIGHT) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)) * -1.0
@onready var hook_jump_deplete_rate : float = (HOOK_JUMP_BASE_STRENGTH - HOOK_JUMP_MIN_STRENGTH) / HOOK_JUMPS_BEFORE_MIN_STRENGTH

@onready var hook_obj = $Hook
@onready var explosion = preload("res://objects/particles/big_explosion.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_velocity

var hook_position : Vector2
var hook_speed : float
var hook_jump_strength : float
var last_distance : float
var bomb_active : bool
var bomb_last_use_timestamp = 0.0

var _hooked_obj
var hooked_obj : 
	get: 
		return get_hooked_obj() 
	set(value): 
		set_hooked_obj(value)

func _ready():
	GameMan.move_player_to_latest_recharge_station()

func _physics_process(delta):
	if current_state == MoveState.NORMAL:
		process_normal_movement(delta)
	elif current_state == MoveState.HOOKED_FLYING:
		process_hook_flying(delta)
	elif current_state == MoveState.HOOKED:
		process_hooked()
	elif current_state == MoveState.DEBUG:
		process_debug()
	
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
		if $Hook.visible:
			return
		hook_fired.emit()
	
	if Input.is_action_just_pressed("hook_attack") and GameMan.get_upgrade_status(GameMan.Upgrades.THERMAL_MODULE) == GameMan.UpgradeStatus.ENABLED:
		if $Hook.visible or get_bomb_on_cooldown():
			return
		bomb_active = !bomb_active
	
		
	if Input.is_action_just_pressed("toggle_debug"):
		toggle_debug(true)
		return
	
	var hookshot_hand_frame = 0
	if bomb_active:
		hookshot_hand_frame = 1
	
	$Sprite2D/HookshotHand.frame = hookshot_hand_frame
	
	if not $Hook.visible and GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
		$Sprite2D/HookshotHand.visible = true
	
	if GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
		flip_sprite(get_global_mouse_position().x < global_position.x)


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func apply_gravity(delta):
	velocity.y += get_gravity() * delta
	var gravity_decrease = GameMan.get_expansion_count(GameMan.ExpansionType.SPEED) * SPEED_EXPANSION_GRAVITY_DECREASE
	velocity.y = clamp(velocity.y, -999999, 850 - gravity_decrease)

func jump():
	if not is_on_floor():
		return
	
	velocity.y = -jump_velocity

func horizontal_move(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	$FrictionParticles.emitting = false
	
	var speed = SPEED + (GameMan.get_expansion_count(GameMan.ExpansionType.SPEED) * SPEED_EXPANSION_INCREASE)
	
	if direction:
		var direction_opposite_to_velocity = clamp(direction * 100, -1, 1) + clamp(velocity.x, -1, 1) == 0
		
		if not GameMan.get_upgrade_status(GameMan.Upgrades.HOOKSHOT) == GameMan.UpgradeStatus.ENABLED:
			flip_sprite(velocity.x < 0)
		
		if (abs(velocity.x) < SNAP_VELOCITY or direction_opposite_to_velocity) and is_on_floor() and abs(velocity.x) < speed * 1.5:
			velocity.x = SNAP_VELOCITY * direction
		
		if abs(velocity.x) > speed and not direction_opposite_to_velocity:
			apply_friction(delta)
			return
		
		velocity.x = move_toward(velocity.x, direction * speed, ACCELERATION * delta)
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
	hook_obj.visible = true
	$Sprite2D/HookshotHand.visible = false
	hook_obj.global_position = global_position
	hook_obj.spawned.emit()

func get_hooks_fired_amount() -> int:
	return get_tree().get_nodes_in_group("Hooks").size()

func _on_hook_collided(collision : KinematicCollision2D):
	var _hooked_obj = collision.get_collider()
	if _hooked_obj is HookableObject:
		hooked_obj = _hooked_obj
	
	if not bomb_active:
		current_state = MoveState.HOOKED_FLYING
		hook_position = collision.get_position()
		hook_speed = HOOK_BASE_FLY_SPEED

		if GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
			hook_speed *= HOOK_UPGRADE_SPEED_MULTIPLIER + (HOOK_SPEED_EXPANSION_MULTIPLIER_INCREASE * (GameMan.get_expansion_count(GameMan.ExpansionType.SPEED)))
		
		if hooked_obj:
			hooked_obj._on_hook_attached()
	else:
		if hooked_obj:
			hooked_obj._on_player_attacked()
		
		bomb_last_use_timestamp = Time.get_unix_time_from_system()
		hook_released_early.emit()
		bomb_active = false
		var explosion_effect = explosion.instantiate()
		get_parent().add_child(explosion_effect)
		explosion_effect.global_position = hook_obj.global_position
	
	

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
	
	
	if Input.is_action_just_pressed("jump"):
		hook_released_early.emit()
		return
	
	# Hook counter
	if Input.is_action_just_pressed("hook_attack"):
		hook_attack()
		return
	
	if abs(last_distance - distance) < 1:
		current_state = MoveState.HOOKED
		
		if hooked_obj:
			hooked_obj._on_player_attached()
		return
		
	last_distance = distance
	
	flip_sprite(hook_position.x < global_position.x)

func hook_attack():
	if not GameMan.get_upgrade_status(GameMan.Upgrades.VELOCITY_MODULE) == GameMan.UpgradeStatus.ENABLED:
		return
	
	if not hooked_obj:
		return
	
	if not global_position.distance_to(hook_position) < HOOK_ATTACK_DISTANCE:
		return
	
	$Attack.rotation = Vector2.RIGHT.angle_to(global_position.direction_to(hooked_obj.global_position)) + 90
	$Attack/AnimationPlayer.current_animation = "attack"
	
	$AttackFlare.global_position = hooked_obj.global_position
	$AttackFlare/AnimationPlayer.current_animation = "flare"
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

func toggle_debug(value):
	set_collision_layer_value(2, !value)
	set_collision_mask_value(1, !value)
	
	get_tree().root.get_node("/root/Main/UI/Control/DebugText").visible = value
	
	if value:
		current_state = MoveState.DEBUG
		get_viewport().get_camera_2d().position_smoothing_enabled = false
		get_viewport().get_camera_2d().zoom = Vector2.ONE
	else:
		current_state = MoveState.NORMAL
		get_viewport().get_camera_2d().position_smoothing_enabled = true
		get_viewport().get_camera_2d().zoom = Vector2.ONE * 2.75

func process_debug():
	var hookshot = Upgrade.new(GameMan.Upgrades.HOOKSHOT)
	var velocity_module = Upgrade.new(GameMan.Upgrades.VELOCITY_MODULE)
	var thermal_module = Upgrade.new(GameMan.Upgrades.THERMAL_MODULE)
	var galvanic_module = Upgrade.new(GameMan.Upgrades.GALVANIC_MODULE)
	var visualizer = Upgrade.new(GameMan.Upgrades.VISUALIZER)
	
	var shift_held = Input.is_key_pressed(KEY_SHIFT)
	
	if Input.is_action_just_pressed("debug_unlock_all_upgrades"):
		GameMan.unlock_upgrade(hookshot)
		GameMan.unlock_upgrade(velocity_module)
		GameMan.unlock_upgrade(thermal_module)
		GameMan.unlock_upgrade(galvanic_module)
		GameMan.unlock_upgrade(visualizer)
	
	if Input.is_action_just_pressed("debug_unlock_hookshot"):
		GameMan.unlock_upgrade(hookshot)
	if Input.is_action_just_pressed("debug_unlock_velocity_module"):
		GameMan.unlock_upgrade(velocity_module)
	if Input.is_action_just_pressed("debug_unlock_galvanic_module"):
		GameMan.unlock_upgrade(galvanic_module)
	if Input.is_action_just_pressed("debug_unlock_artillery_module"):
		GameMan.unlock_upgrade(thermal_module)
	if Input.is_action_just_pressed("debug_unlock_visualizer"):
		GameMan.unlock_upgrade(visualizer)
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var move_amount = 1000.0
	if shift_held:
		move_amount *= 2
	
	velocity = direction * move_amount
	
	var teleport_dir = Vector2.ZERO
	
	if Input.is_action_just_pressed("debug_teleport_down"):
		teleport_dir.y = 1
	if Input.is_action_just_pressed("debug_teleport_up"):
		teleport_dir.y = -1
	if Input.is_action_just_pressed("debug_teleport_left"):
		teleport_dir.x = -1
	if Input.is_action_just_pressed("debug_teleport_right"):
		teleport_dir.x = 1
	
	global_position += teleport_dir * (move_amount / 2.5)
	
	if Input.is_action_just_pressed("debug_damage"):
		if shift_held:
			GameMan.get_player_health().die()
		else:
			GameMan.get_player_health().damage()
	
	if Input.is_action_just_pressed("debug_heal"):
		if shift_held:
			GameMan.get_player_health().heal_full()
		else:
			GameMan.get_player_health().heal()
	
	if Input.is_action_just_pressed("toggle_debug"):
		toggle_debug(false)

func flip_sprite(inverse : bool):
	$Sprite2D.flip_h = inverse
	
	var hookhand_pos = Vector2(4,5)
	if inverse:
		hookhand_pos.x *= -1
	
	$Sprite2D/HookshotHand.position = hookhand_pos

func get_bomb_on_cooldown() -> bool:
	return Time.get_unix_time_from_system() < bomb_last_use_timestamp + BOMB_COOLDOWN
