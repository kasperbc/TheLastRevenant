extends Area2D

var activated : bool

func _on_body_entered(body):
	if activated:
		return
	activated = true
	
	GameMan.get_audioman().stop_music()
	
	$SmallBossDoor.close_door()
	$idle.visible = false
	$takeoff.play("takeoff")
	$takeoff.visible = true
	GameMan.get_audioman().play_fx("download", -8.0, 1.0)
	
	await get_tree().create_timer(1.3).timeout
	$helmet.visible = true
	GameMan.get_audioman().play_fx("thud2", -4.0, 1.0)
	
	await get_tree().create_timer(0.2).timeout
	
	var opacity_tween = create_tween()
	opacity_tween.tween_property($takeoff, "modulate", Color(1,1,1,0), 0.5)
	
	await get_tree().create_timer(0.5).timeout
	
	GameMan.get_audioman().play_fx("unsexylaugh", 0.0, 1.0)
	
	await get_tree().create_timer(1).timeout
	
	var final_boss_move_tween = create_tween()
	final_boss_move_tween.set_trans(Tween.TRANS_EXPO)
	final_boss_move_tween.tween_property($FinalBoss, "position", Vector2(384, -160), 3)
	
	await get_tree().create_timer(3).timeout
	
	$FinalBoss.process_mode = Node.PROCESS_MODE_INHERIT
	$SpaceBlocker.process_mode = Node.PROCESS_MODE_DISABLED
	GameMan.get_audioman().play_music("finalboss", -24.0)
