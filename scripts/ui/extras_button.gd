extends Button

func _process(delta):
	disabled = !SaveMan.save.get_value("Meta", "game_beat", false)
