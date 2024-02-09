extends ColorRect
class_name MapScreen

func _process(delta):
	visible = GameMan.game_paused and GameMan.map_open
	
	var areas_discovered = SaveMan.get_value("areas_discovered", [-1])
	var upgrades_collected = SaveMan.get_value("upgrades_collected", [-1])
	var logbooks_collected = SaveMan.get_value("logbooks_collected", [])
	
	$TabContainer.set_tab_disabled(1, areas_discovered.size() <= 1)
	$TabContainer.set_tab_disabled(2, upgrades_collected.size() <= 1)
	$TabContainer.set_tab_disabled(3, logbooks_collected.size() == 0)
