extends Node2D
class_name RotateToPlayer

@export var rotation_speed = 50.0

func _process(delta):
	rotation = rotate_toward(rotation, Vector2.RIGHT.angle_to(global_position.direction_to(GameMan.get_player().global_position)), delta * rotation_speed)
