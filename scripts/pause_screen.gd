extends ColorRect

func _process(delta):
	visible = GameMan.game_paused

func _on_title_button_pressed():
	GameMan.load_title_screen()


func _on_restart_button_pressed():
	GameMan.unpause_game()
	GameMan.get_player_health().die()
