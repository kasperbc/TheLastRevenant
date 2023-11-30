extends Node2D

func _process(delta):
	position = get_viewport().get_camera_2d().get_screen_center_position()
