extends Node2D
class_name RotateTowardsPlayer

func _process(delta):
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(global_position.direction_to(get_global_mouse_position())))
