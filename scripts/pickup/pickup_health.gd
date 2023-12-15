extends Pickup
class_name PickupHealth

@onready var spawn_time = Time.get_unix_time_from_system()

func pick_up():
	if Time.get_unix_time_from_system() - spawn_time < 0.5:
		return
	
	GameMan.get_audioman().play_fx("heal", -5, randf_range(0.95, 1.05))
	
	GameMan.get_player_health().heal()
	super()
