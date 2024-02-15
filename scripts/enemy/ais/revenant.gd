extends EnemyAI
class_name RevenantAI

func change_state():
	if not can_see_player() and state == "move_towards_player":
		state = "idle"
		$idle.current_speed = $move_towards_player.current_speed
	elif time_since_last_not_saw_player > 0.75 and state == "idle":
		GameMan.get_audioman().play_fx("notice", -4, randf_range(0.65, 0.85))
		state = "move_towards_player"
