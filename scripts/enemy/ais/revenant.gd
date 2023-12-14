extends EnemyAI
class_name RevenantAI

func change_state():
	if not can_see_player():
		state = "idle"
	elif time_since_last_not_saw_player > 0.75:
		state = "move_towards_player"
