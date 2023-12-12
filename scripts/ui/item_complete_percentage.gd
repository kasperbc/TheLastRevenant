extends Label
class_name ItemCompletePercentage

const EXPANSION_COUNT = 12
const CORE_COUNT = 5

@export var hide_unpaused = true

func _process(delta):
	visible = GameMan.game_paused or not hide_unpaused
	
	var expansions_collected = GameMan.range_expansions_collected.size()
	expansions_collected += GameMan.health_expansions_collected.size()
	expansions_collected += GameMan.speed_expansions_collected.size()
	expansions_collected = clamp(expansions_collected, 0, EXPANSION_COUNT)
	var expansion_collected_01 = float(expansions_collected) / EXPANSION_COUNT
	
	var core_upgrades_collected = GameMan.upgrades_collected.size()
	core_upgrades_collected = clamp(core_upgrades_collected, 0, CORE_COUNT)
	var core_upgrades_collected_01 = float(core_upgrades_collected) / CORE_COUNT
	
	var upgrades_collected_01 = expansion_collected_01 / 2 + core_upgrades_collected_01 / 2
	
	text = str(round(upgrades_collected_01 * 100)) + "%"
