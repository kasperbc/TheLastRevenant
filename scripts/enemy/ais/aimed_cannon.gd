extends EnemyAI

@export var player_see_range : float = 180.0

func change_state():
	if can_see_player(player_see_range):
		state = "rotate_at_player_shoot"
	elif time_since_last_not_saw_player > 5.0 or distance_to_player() > player_see_range:
		state = "rotate_to_idle"
