extends Enemy
class_name Boss1Enemy

# shimmy shimmy yay shimmy yay shimmy ya (drank) swalla-la-la (drank) swalla-la-la

func _process(delta):
	super(delta)
	
	for cannon in get_tree().get_nodes_in_group("Boss1Cannon"):
		cannon.get_node("AI/rotate_shoot").speed_multiplier = 1 + (1 - (health / base_health))
