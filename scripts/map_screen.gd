extends ColorRect
class_name MapScreen

func _process(delta):
	visible = GameMan.game_paused and GameMan.map_open
	
	var areas_discovered = SaveMan.get_value("areas_discovered", [-1])
	var upgrades_collected = SaveMan.get_value("upgrades_collected", [-1])
	
	$TabContainer.set_tab_disabled(1, areas_discovered.size() == 0)
	$TabContainer.set_tab_disabled(2, upgrades_collected.size() == 0)
