extends HookableObject
class_name LatchLauncher

func _on_player_near():
	GameMan.get_player().hook_released_early.emit()
	GameMan.get_player().velocity *= 1.1
