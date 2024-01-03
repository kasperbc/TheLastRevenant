extends HookableObject
class_name LatchLauncher

func _on_player_near():
	GameMan.get_player().hook_released_early.emit()
	GameMan.get_player().velocity *= 1.25
	GameMan.get_audioman().play_fx("launch", -4, randf_range(0.95, 1.05))
	GameMan.get_audioman().play_fx("thud2", -6, randf_range(0.95, 1.05))
