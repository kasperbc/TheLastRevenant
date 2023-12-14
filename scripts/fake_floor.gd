extends TileMap

func _on_player_detection_body_entered(body):
	if not body is PlayerMovement:
		return
	
	for x in get_used_cells(0):
		set_cell(0, x)
	
	$BreakParticles.emitting = true
