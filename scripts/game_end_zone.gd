extends Area2D



func _on_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	await get_tree().create_timer(1).timeout
	
	get_tree().root.get_node("Main/UI/Control/FadeScreen").fade_to_black(2)
	
	await get_tree().create_timer(2).timeout
	
	SaveMan.write_game_end_meta()
	GameMan.load_end_screen()
