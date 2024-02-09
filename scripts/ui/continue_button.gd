extends Button

func _process(delta):
	disabled = SaveMan.get_value("playtime", 0) == 0
