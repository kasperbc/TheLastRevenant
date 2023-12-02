extends Node2D

func _process(delta):
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(global_position.direction_to(GameMan.get_player().global_position)))
