extends EnemyAI
class_name FatMissileAI

@export var player_distance_treshhold = 24.0

func change_state():
	if distance_to_player() <= player_distance_treshhold and not $pursue_player_rotate.going_towards_damager:
		state = "fall_and_die"
