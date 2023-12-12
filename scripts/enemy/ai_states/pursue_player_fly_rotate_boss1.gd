extends PursuePlayerFlyRotate
class_name PursuePlayerFlyRotateBoss1Variant

var target : Node2D
var going_towards_damager : bool

@export var damager_target_treshhold = 160.0
@export var player_distance_treshhold = 24.0

@export var neutral_sf : SpriteFrames
@export var good_sf : SpriteFrames

func _on_state_activate():
	going_towards_damager = false
	target = null
	body.velocity = Vector2.ZERO

func ai_state_process(delta):
	last_pos = body.global_position
	
	if is_instance_valid(target):
		pathfind_towards_point(target.global_position, speed)
	else:
		target = GameMan.get_player()
	
	move_and_rotate_toward_player()
	
	if target == GameMan.get_player():
		body.get_node("Sprite2D").sprite_frames = neutral_sf
	else:
		body.get_node("Sprite2D").sprite_frames = good_sf
	
	if going_towards_damager:
		return
	
	var closest_damager : Node2D
	for damager in get_tree().get_nodes_in_group("Boss1Damagers"):
		if not damager is Boss1Damager:
			continue
		if damager.falling:
			continue
		
		var dist = body.global_position.distance_to(damager.global_position)
		if dist <= damager_target_treshhold:
			closest_damager = damager
			break
	
	if closest_damager:
		target = closest_damager
		going_towards_damager = true
