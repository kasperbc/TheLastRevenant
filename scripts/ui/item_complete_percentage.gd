extends Label
class_name ItemCompletePercentage

@export var prefix = ""
@export var hide_unpaused = true

func _process(delta):
	visible = GameMan.game_paused or not hide_unpaused
	
	var upgrades_collected_01 = GameMan.get_item_completion_percentage()
	
	text = prefix + str(round(upgrades_collected_01 * 100)) + "%"
