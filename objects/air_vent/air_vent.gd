extends HookableObject

func _process(delta):
	super(delta)

func _on_player_near():
	GameMan.get_player().hook_released_early.emit()
	open_vent()

func _on_player_attached():
	GameMan.get_player().hook_released_early.emit()
	open_vent()

func open_vent():
	$CollisionShape2D.disabled = true
	
	$UpperVent.rotation_degrees = 90
	$LowerVent.rotation_degrees = -90
	
	GameMan.get_audioman().play_fx("thud2", -9, randf_range(0.95, 1.05))
	
	await get_tree().create_timer(3).timeout
	
	close_vent()

func close_vent():
	$UpperVent.rotation_degrees = 0
	$LowerVent.rotation_degrees = 0
	
	GameMan.get_audioman().play_fx("thud2", -9, randf_range(0.85, 0.95))
	
	if global_position.distance_to(GameMan.get_player().global_position) < 32.0:
		await get_tree().create_timer(3).timeout
	
	$CollisionShape2D.disabled = false
