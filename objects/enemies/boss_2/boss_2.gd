extends Enemy
class_name Boss2Enemy

func _on_hook_attached():
	GameMan.get_player().hook_released_early.emit()
