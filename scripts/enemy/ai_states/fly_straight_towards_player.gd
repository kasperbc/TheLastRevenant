extends FlyStraightTowardsDirection
class_name FlyStraightTowardsPlayer

func _on_state_activate():
	super()
	var target_dir = body.global_position.direction_to(GameMan.get_player().global_position)
	set_dir(target_dir)
