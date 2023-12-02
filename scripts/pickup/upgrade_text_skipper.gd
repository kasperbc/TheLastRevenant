extends Node

func _input(event):
	if Input.is_action_just_pressed("jump"):
		try_skip_upgrade_text()

func try_skip_upgrade_text():
	if not get_parent().in_upgrade_text:
		return
	
	get_parent().hide_upgrade_text()
	get_parent().destroy_self()
