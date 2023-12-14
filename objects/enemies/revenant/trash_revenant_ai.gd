extends RevenantAI
class_name TrashRevenantAI

@export var trash_range : float = 100.0

func _ready():
	get_parent().get_node("Sprite2D").flip_h = randf() > 0.5
	

func change_state():
	if state == "in_trash":
		if not can_see_player() or distance_to_player() > trash_range:
			return
		else:
			state = "move_towards_player"
			get_parent().get_node("Sprite2D").flip_h = false
			get_parent().get_node("TrashParticles").emitting = true
			$move_towards_player.jump()
	super()
