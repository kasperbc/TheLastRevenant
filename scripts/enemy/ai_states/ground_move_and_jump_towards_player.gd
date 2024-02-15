extends GroundMoveTowardsPlayer
class_name GroundMoveAndJumpTowardsPlayer

@onready var last_jump_time : float = Time.get_unix_time_from_system()
@onready var sprite : AnimatedSprite2D = body.get_node("Sprite2D")

@export var min_jump_cooldown : float = 3.0
@export var max_jump_cooldown : float = 5.0

var jump_cooldown : float = 3.0
var jumping = false

@onready var last_random_jump_attempt = floor(Time.get_unix_time_from_system())

func _on_state_activate():
	current_speed = 0.0
	body.velocity = Vector2.ZERO

func ai_state_process(delta):
	if jumping:
		return
	
	super(delta)
	
	var activate_rand_jump = false
	if floor(Time.get_unix_time_from_system()) > last_random_jump_attempt:
		last_random_jump_attempt = floor(Time.get_unix_time_from_system())
		if randf() < 0.1:
			activate_rand_jump = true
	
	var player_up_angle = abs(rad_to_deg(Vector2.UP.angle_to(get_player_dir())))
	var player_height_diff = GameMan.get_player().global_position.y - body.global_position.y
	
	var player_is_above_enemy = player_up_angle < 60.0 and body.is_on_floor() and clamp(current_speed, -1, 1) == get_player_dir_x() and player_height_diff < -16.0
	if player_is_above_enemy or activate_rand_jump:
		jump()
	
	sprite.flip_h = get_player_dir_x() == 1
	
	if not jumping:
		if body.is_on_floor():
			sprite.play("walk")
		else:
			sprite.play("jump")

func move_to_direction(delta):
	var going_opposite_of_velocity = clamp(body.velocity.x * 100, -1, 1) != dir
	var _acc = acceleration
	
	if going_opposite_of_velocity:
		acceleration *= 1.25
	
	super(delta)
	
	acceleration = _acc

func jump():
	if last_jump_time + jump_cooldown > Time.get_unix_time_from_system():
		return
	
	jumping = true
	
	sprite.stop()
	sprite.animation = "crouch"
	
	await get_tree().create_timer(0.25).timeout
	
	jumping = false
	
	GameMan.get_audioman().play_fx("thud2", -4, randf_range(1.35, 1.55))
	
	last_jump_time = Time.get_unix_time_from_system()
	jump_cooldown = randf_range(min_jump_cooldown, max_jump_cooldown)
	
	super()
