extends Station
class_name RechargeStation

@export var station_id = 0

func on_station_activate():
	GameMan.get_player_health().heal_full()
	GameMan.set_latest_recharge_point(station_id)
