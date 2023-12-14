extends EnemyAIState
class_name RotateAtPlayerShoot

@export var rotate_speed : float = 90.0
@export var wait_time : float = 1.0

var time_since_last_projectile = 0.0

func ai_state_process(delta):
	var player_dir = body.global_position.direction_to(GameMan.get_player().global_position)
	var player_angle = Vector2.RIGHT.angle_to(player_dir)
	
	body.rotation = rotate_toward(body.rotation, player_angle, rotate_speed * speed_multiplier * delta)
	
	time_since_last_projectile += delta
	if time_since_last_projectile > wait_time:
		shoot_projectile(Vector2.RIGHT.rotated(body.rotation) * 20.0)

func shoot_projectile(offset):
	super(offset)
	
	time_since_last_projectile = 0.0
	
	if last_projectile:
		if last_projectile.get_node("AI/fly_towards_point"):
			last_projectile.get_node("AI/fly_towards_point").set_dir(Vector2.RIGHT.rotated(body.rotation))
			last_projectile.damage_while_hooked = true
