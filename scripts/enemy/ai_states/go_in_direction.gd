extends GroundMove
class_name GoInDirection

@export var direction : float

func _on_state_activate():
	dir = direction
