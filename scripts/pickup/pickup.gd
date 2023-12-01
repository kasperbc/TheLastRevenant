extends Area2D
class_name Pickup

func _on_player_contact(body : Node2D):
	if body.is_in_group("Players"):
		pick_up()

func pick_up():
	destroy_self()

func destroy_self():
	queue_free()
