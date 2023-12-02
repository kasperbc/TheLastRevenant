extends Node
class_name EnemyAI

@export var default_state : String = "idle"
@export var no_ai_on_stun : bool = true

@onready var state = default_state
@onready var body = get_parent()
@onready var last_player_sighting_timestamp : float = Time.get_unix_time_from_system()

var active : bool = true
var time_since_last_saw_player
var state_prev_frame = ""

func _process(delta):
	process_active_state(delta)
	change_state()

func process_active_state(delta):
	if not active:
		return
	
	if body.stunned and no_ai_on_stun:
		return
	
	var children = get_children()
	
	for child in children:
		if not child is EnemyAIState:
			continue
		
		if child.name == state:
			child.ai_state_process(delta)
			
			if state_prev_frame != state:
				child._on_state_activate()
				
				if get_node_or_null(state_prev_frame):
					get_node(state_prev_frame)._on_state_deactivate()
			
			state_prev_frame = state
			return
	
	print("Cannot find state %s!" % state)

func change_state():
	pass

func distance_to_player() -> float:
	return get_parent().global_position.distance_to(GameMan.get_player().global_position)

func raycast_to_player():
	var space_state = body.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(body.global_position, GameMan.get_player().global_position)
	var result = space_state.intersect_ray(query)
	
	return result

func raycast_result_is_player(result) -> bool:
	var is_player = false
	
	if result and result.collider.is_in_group("Players"):
		is_player = true
	
	update_player_sighting_timestamp(is_player)
	return is_player

func can_see_player(max_distance = -1) -> bool:
	var result = raycast_to_player()
	
	if not raycast_result_is_player(result):
		return false
	
	if max_distance != -1 and body.global_position.distance_to(result.position) > max_distance:
		return false
	return true

func can_see_player_in_dir(dir : Vector2, max_angle = 90, max_distance = -1) -> bool:
	var result = raycast_to_player()
	
	if not raycast_result_is_player(result):
		return false
	
	if max_distance != -1 and body.global_position.distance_to(result.position) > max_distance:
		return false
	
	var player_dir = body.global_position.direction_to(result.position)
	var player_dir_normalized = player_dir * 100
	player_dir_normalized.x = clamp(player_dir_normalized.x, -1, 1)
	player_dir_normalized.y = clamp(player_dir_normalized.y, -1, 1)
	
	if dir.x != 0 and dir.x != player_dir_normalized.x:
		return false
	
	if dir.y != 0 and dir.y != player_dir_normalized.y:
		return false
	
	var angle_to_player = abs(rad_to_deg(dir.angle_to(player_dir)))
	
	if angle_to_player > max_angle:
		return false
	
	return true

func update_player_sighting_timestamp(saw_player : bool):
	if saw_player:
		last_player_sighting_timestamp = Time.get_unix_time_from_system()
		time_since_last_saw_player = 0
		return
	time_since_last_saw_player = Time.get_unix_time_from_system() - last_player_sighting_timestamp
