extends Pickup
class_name Logbook

@export var res : LogbookRes

func pick_up():
	GameMan.get_audioman().play_fx("expansion_collect", 0.0, 1.0)
	
	get_tree().paused = true
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	
	GameMan.collect_logbook(res)
	
	super()
