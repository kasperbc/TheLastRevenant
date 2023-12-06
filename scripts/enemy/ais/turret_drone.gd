extends EnemyAI
class_name TurretDrone

@export var idle_check_angle : float = 30
@export var idle_check_distance : float = 300

@export var blind_pursue_time : float = 3.0

func change_state():
	if state == "idle":
		idle_state_check()
		body.get_node("Turret").active = false
	elif state == "pursue":
		pursue_state_check()
		body.get_node("Turret").active = true

func idle_state_check():
	if can_see_player_in_dir(Vector2.DOWN, idle_check_angle, idle_check_distance):
		state = "pursue"

func pursue_state_check():
	if not can_see_player(200):
		$pursue.speed_multiplier = clamp(1 - (time_since_last_saw_player / blind_pursue_time) * 1.5, 0, 1)
		
		body.get_node("Turret").rotate = false
		
		if time_since_last_saw_player > blind_pursue_time:
			state = "idle"
	else:
		$pursue.speed_multiplier = 1
		body.get_node("Turret").rotate = true
