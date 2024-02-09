extends Label
class_name ItemCompletePercentage

const EXPANSION_COUNT = 12
const CORE_COUNT = 5

@export var prefix = ""
@export var hide_unpaused = true

func _process(delta):
	visible = GameMan.game_paused or not hide_unpaused
	
	var expansions_collected = SaveMan.get_value("speed_expansions", [-1]).size() - 1
	expansions_collected += SaveMan.get_value("health_expansions", [-1]).size() - 1
	expansions_collected += SaveMan.get_value("range_expansions", [-1]).size() - 1
	expansions_collected = clamp(expansions_collected, 0, EXPANSION_COUNT)
	var expansion_collected_01 = float(expansions_collected) / EXPANSION_COUNT
	
	var upgrades_collected = SaveMan.get_value("upgrades_collected", [])
	var core_upgrades_collected = upgrades_collected.size()
	core_upgrades_collected = clamp(core_upgrades_collected, 0, CORE_COUNT)
	var core_upgrades_collected_01 = float(core_upgrades_collected) / CORE_COUNT
	
	var upgrades_collected_01 = expansion_collected_01 / 2 + core_upgrades_collected_01 / 2
	
	text = prefix + str(round(upgrades_collected_01 * 100)) + "%"
