extends Control

func _on_play_pressed():
	GameMan.load_main()


func _on_new_game_button_pressed():
	SaveMan.reset_save()
	GameMan.load_main()


func _on_credits_button_pressed():
	$Background/CreditsDialog.popup()


func _on_quit_button_pressed():
	get_tree().quit()



func _on_extras_close_button_pressed():
	$Background/ExtrasPanel.visible = false


func _on_extras_button_pressed():
	$Background/ExtrasPanel.visible = true
