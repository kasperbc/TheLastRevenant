extends Station
class_name RechargeStation

@export var station_id = 0

func on_station_activate():
	GameMan.get_player_health().heal_full()
	GameMan.set_latest_recharge_point(station_id)
	GameMan.get_audioman().play_fx("recharge", 0.0, 1.0)
	
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").text = "Checkpoint reached"
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").visible = true
	
	await get_tree().create_timer(2).timeout
	
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").visible = false
