extends FlyStraightTowardsPlayer
class_name FlyAndTurnTowardsPlayer

@export var turn_speed = 5.0

func ai_state_process(delta):
	super(delta)
	
	move_target_point(delta)

func move_target_point(delta):
	var target_angle = rad_to_deg(Vector2.RIGHT.angle_to(body.global_position.direction_to(GameMan.get_player().global_position)))
	body.rotation_degrees = rotate_toward(body.rotation_degrees, target_angle, turn_speed * delta)
	dir_towards_rotate()

func dir_towards_rotate():
	dir = Vector2.from_angle(deg_to_rad(body.rotation_degrees))
