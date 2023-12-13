extends GroundMoveTowardsPlayer
class_name GroundMoveAndJumpTowardsPlayer

@onready var last_jump_time : float = Time.get_unix_time_from_system()

@export var min_jump_cooldown : float = 3.0
@export var max_jump_cooldown : float = 5.0

var jump_cooldown : float = 3.0

func ai_state_process(delta):
	super(delta)
	
	var player_up_angle = abs(rad_to_deg(Vector2.UP.angle_to(get_player_dir())))
	var player_height_diff = GameMan.get_player().global_position.y - body.global_position.y
	
	var player_is_above_enemy = player_up_angle < 60.0 and body.is_on_floor() and clamp(current_speed, -1, 1) == get_player_dir_x() and player_height_diff < -16.0
	if player_is_above_enemy:
		jump()

func jump():
	if last_jump_time + jump_cooldown > Time.get_unix_time_from_system():
		return
	
	last_jump_time = Time.get_unix_time_from_system()
	jump_cooldown = randf_range(min_jump_cooldown, max_jump_cooldown)
	
	super()
