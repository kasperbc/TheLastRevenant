extends PursuePlayerFly
class_name PursuePlayerFlyRotate

var last_pos : Vector2

func ai_state_process(delta):
	last_pos = body.global_position
	
	super(delta)
	
	var move_dir = last_pos.direction_to(body.global_position)
	var dir_angle = Vector2.RIGHT.angle_to(move_dir)
	body.rotation = dir_angle
