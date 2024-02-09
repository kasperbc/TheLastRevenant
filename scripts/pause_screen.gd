extends ColorRect

func _process(delta):
	var gamepad_enabled_not_connected = GameMan.get_user_setting("control_method") != "keyboard_mouse" and Input.get_connected_joypads().size() == 0
	
	if not GameMan.game_paused and gamepad_enabled_not_connected:
		GameMan.pause_game()
	
	$NoGamepadWarn.visible = gamepad_enabled_not_connected
	
	visible = GameMan.game_paused and (not GameMan.map_open)

func _on_title_button_pressed():
	SaveMan.write_save()
	GameMan.load_title_screen()

func _on_restart_button_pressed():
	GameMan.unpause_game()
	GameMan.get_player_health().die()

func _on_resume_button_pressed():
	GameMan.unpause_game()
