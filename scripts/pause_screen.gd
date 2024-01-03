extends ColorRect

func _process(delta):
	var gamepad_enabled_not_connected = GameMan.get_user_setting("control_method") != "keyboard_mouse" and Input.get_connected_joypads().size() == 0
	
	if GameMan.game_paused != true and gamepad_enabled_not_connected:
		GameMan.pause_game()
	
	$NoGamepadWarn.visible = gamepad_enabled_not_connected
	
	visible = GameMan.game_paused

func _on_title_button_pressed():
	GameMan.load_title_screen()


func _on_restart_button_pressed():
	GameMan.unpause_game()
	GameMan.get_player_health().die()
