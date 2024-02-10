extends Control

func _ready():
	play_anim()

func play_anim():
	var space_t = get_tree().create_tween().set_parallel(true)
	
	space_t.set_trans(Tween.TRANS_EXPO)
	
	space_t.tween_property($Space, "speed", 1300, 5)
	space_t.tween_property($Space2, "speed", 1000, 5)
	
	await get_tree().create_timer(4).timeout
	get_tree().create_tween().tween_property($TheEndText, "self_modulate", Color(1,1,1,1), 3)
	
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property($TheEndSubText, "self_modulate", Color(1,1,1,1), 3)
	
	await get_tree().create_timer(1).timeout
	
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property($CompletionPercentage, "self_modulate", Color(1,1,1,1), 2)
	
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property($Time, "self_modulate", Color(1,1,1,1), 2)
	
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property($ReturnToTitle, "self_modulate", Color(1,1,1,1), 2)

func load_title():
	GameMan.load_title_screen()

func _on_return_to_title_pressed():
	load_title()
