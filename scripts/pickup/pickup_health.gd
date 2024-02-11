extends Pickup
class_name PickupHealth

enum HealType {
	HEAL = 0,
	FULL_HEAL = 1
}

@onready var spawn_time = Time.get_unix_time_from_system()

@export var type : HealType

func pick_up():
	if Time.get_unix_time_from_system() - spawn_time < 0.5:
		return
	
	GameMan.get_audioman().play_fx("heal", -5, randf_range(0.95, 1.05))
	
	if type == HealType.HEAL:
		GameMan.get_player_health().heal()
	else:
		GameMan.get_player_health().heal_full()
	
	super()
