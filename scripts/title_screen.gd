extends Control

func _on_play_pressed():
	GameMan.load_main()


func _on_new_game_button_pressed():
	SaveMan.reset_save()
	GameMan.load_main()
