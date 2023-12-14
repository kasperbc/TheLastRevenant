extends RevenantAI
class_name TrashRevenantAI

@export var trash_range : float = 100.0

func change_state():
	if state == "in_trash":
		if not can_see_player() or distance_to_player() > trash_range:
			return
		else:
			state = "move_towards_player"
			$move_towards_player.jump()
	super()
