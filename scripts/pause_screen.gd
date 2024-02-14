extends ColorRect

var visible_last_frame : bool = false

var gradient_pos = 0

func _process(delta):
	var gamepad_enabled_not_connected = GameMan.get_user_setting("control_method") != "keyboard_mouse" and Input.get_connected_joypads().size() == 0
	
	if not GameMan.game_paused and gamepad_enabled_not_connected:
		GameMan.pause_game()
	
	$NoGamepadWarn.visible = gamepad_enabled_not_connected
	
	visible = GameMan.game_paused and (not GameMan.map_open)
	
	if visible != visible_last_frame:
		on_visibility_change()
	
	visible_last_frame = visible
	get_parent().get_node("Gradient").global_position.y = 720 - gradient_pos

func on_visibility_change():
	var t = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.bind_node(self)
	
	var target_value = 720
	if not visible:
		target_value = 0
	
	t.tween_property(self, "gradient_pos", target_value, 1)

func _on_title_button_pressed():
	SaveMan.write_save()
	GameMan.load_title_screen()

func _on_restart_button_pressed():
	GameMan.unpause_game()
	GameMan.get_player_health().die()

func _on_resume_button_pressed():
	GameMan.unpause_game()
