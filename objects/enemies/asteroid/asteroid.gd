extends Enemy
class_name Asteroid

func _process(delta):
	super(delta)

func _on_player_near():
	GameMan.get_player().hook_released_early.emit()

func _on_player_attached():
	GameMan.get_player().hook_released_early.emit()
