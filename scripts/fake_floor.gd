extends TileMap

@export var stop_music : bool = true

func _on_player_detection_body_entered(body):
	if not body is PlayerMovement:
		return
	
	for x in get_used_cells(0):
		set_cell(0, x)
	
	$BreakParticles.emitting = true
	GameMan.get_audioman().play_fx("boom", 0.0, randf_range(0.95, 1.05))
	if stop_music:
		GameMan.get_audioman().stop_music()
