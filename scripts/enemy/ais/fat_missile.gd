extends EnemyAI
class_name FatMissileAI

@export var player_distance_treshhold = 24.0

func change_state():
	if distance_to_player() <= player_distance_treshhold and not $pursue_player_rotate.going_towards_damager and state == "pursue_player_rotate":
		state = "fall_and_die"
		GameMan.get_audioman().play_fx("shock", -12, randf_range(1.55, 1.65))
