extends ColorRect
class_name MapScreen

func _process(delta):
	visible = GameMan.game_paused and GameMan.map_open
	
	$TabContainer.set_tab_disabled(1, GameMan.upgrades_collected.size() == 0)
