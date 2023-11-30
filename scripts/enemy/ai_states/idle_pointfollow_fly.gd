extends EnemyAIState
class_name IdlePointFollowFlyState

@onready var points = get_metadata("move_points")

@export var speed : float = 20.0
@export var wait_time : float = 1.0
@export var slowdown_distance : float = 100.0
@export var speedup_distance : float = 100.0

var target_point = 0
var moving = true

func ai_state_process(delta):
	move_towards_target_point()

func move_towards_target_point():
	if points.size() == 0 or not moving:
		return
	
	var target_pos = points[target_point]
	var distance_to_pos = global_position.distance_to(target_pos)
	var distance_to_prev_pos = global_position.distance_to(get_previous_target())
	
	var spd = speed * clamp(distance_to_pos / slowdown_distance, 0, 1) * clamp(distance_to_prev_pos / speedup_distance, 0, 1)
	
	
	pathfind_towards_point(target_pos, spd)
	
	if distance_to_pos < 10:
		on_reach_target()

func on_reach_target():
	target_point += 1
	if target_point >= points.size():
		target_point = 0
	
	moving = false
	await get_tree().create_timer(wait_time).timeout
	moving = true

func get_previous_target() -> Vector2:
	var prev_point = target_point - 1
	
	if prev_point < 0:
		prev_point = points.size() - 1
	
	return points[prev_point]
