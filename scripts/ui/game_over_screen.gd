extends Control
class_name GameOverScreen

func play_anim():
	print("Playing death animation")
	
	var blood_front_fade = get_tree().create_tween().bind_node(self)
	
	GameMan.get_audioman().play_fx("thud")
	GameMan.get_audioman().stop_music()
	
	blood_front_fade.tween_property($BloodFront, "self_modulate", Color(1,1,1,1), 0.2)
	await get_tree().create_timer(0.1).timeout
	
	var blood_front_scale = get_tree().create_tween().bind_node(self)
	blood_front_scale.set_trans(Tween.TRANS_BOUNCE)
	blood_front_scale.tween_property($BloodFront, "scale", Vector2.ONE * 1.25, 0.1)
	blood_front_scale.tween_property($BloodFront, "scale", Vector2.ONE * 1.2, 0.1)
	
	await get_tree().create_timer(1).timeout
	var blood_front_move = get_tree().create_tween().bind_node(self)
	blood_front_move.set_trans(Tween.TRANS_CUBIC)
	blood_front_move.tween_property($BloodFront, "position", Vector2(0, 60), 5)
	
	await get_tree().create_timer(0.5).timeout
	var blood_back_fade = get_tree().create_tween().bind_node(self)
	blood_back_fade.tween_property($BloodBack, "self_modulate", Color(1,1,1,1), 2)
	
	GameMan.get_audioman().play_music("boss_prelude", -22.0)
	
	await get_tree().create_timer(1).timeout
	var ui_fade = get_tree().create_tween().bind_node(self)
	ui_fade.tween_property($UI, "modulate", Color(1,1,1,1), 2)

func on_continue():
	get_tree().paused = false
	GameMan.load_main()

func on_title():
	SaveMan.reload_save()
	GameMan.load_title_screen()
