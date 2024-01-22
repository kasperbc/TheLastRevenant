extends ColorRect
class_name MapScreen

func _process(delta):
	visible = GameMan.game_paused and GameMan.map_open
