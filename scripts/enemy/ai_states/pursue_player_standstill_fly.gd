extends PursuePlayerFly
class_name PursuePlayerStandstillFly

@export var max_distance_from_home : float = 15.0
var home_pos : Vector2

func _on_state_activate():
	home_pos = body.global_position

func ai_state_process(delta):
	var dist_from_home = home_pos.distance_to(body.global_position)
	var dist_from_home_normalized = clamp(1 - (dist_from_home / max_distance_from_home), 0, 1)
	move_towards_player(speed * dist_from_home_normalized, offset, max_distance)
