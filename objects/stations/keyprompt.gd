extends Label

func _process(delta):
	var key_text = GameMan.get_input_action_key_str("interact")
	text = key_text
