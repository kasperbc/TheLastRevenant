extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos = GameMan.get_player().global_position
	var hook_pos = get_parent().global_position
	var distance = hook_pos.distance_to(player_pos)
	
	# size
	region_rect.size.x = distance

	# position
	global_position = hook_pos + hook_pos.direction_to(player_pos) * distance / 2

	# rotation
	rotation = hook_pos.angle_to_point(player_pos)
