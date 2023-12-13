extends Area2D

func _on_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	GameMan.get_player().gravity_multiplier = 0.25
