extends Control

func load_title():
	GameMan.load_title_screen()


func _on_return_to_title_pressed():
	load_title()
