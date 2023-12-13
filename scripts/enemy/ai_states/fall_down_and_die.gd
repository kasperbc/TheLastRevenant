extends FlyStraightTowardsDirection
class_name FallAndDie

func _on_state_activate():
	super()
	set_dir(Vector2.DOWN)
