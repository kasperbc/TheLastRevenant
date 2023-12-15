extends Area2D

@export var gravity_set = 0.25

func _on_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	GameMan.get_player().gravity_multiplier = gravity_set
