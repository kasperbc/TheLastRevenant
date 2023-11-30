extends Camera2D

@onready var player = GameMan.get_player()

const NORMAL_SMOOTH_SPEED = 10

# free cam
const FLOOR_Y_OFFSET = -60.0
const FLOOR_SMOOTH_SPEED = 5

const MIN_DISTANCE_FOR_DYNAMIC_CAM = 300.0

func _process(delta):
	position = player.position
	
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.collision_mask = 4
	query.position = player.position
	query.collide_with_areas = true
	var result = space.intersect_point(query)
	
	if not result:
		free_camera()
		return
	
	# limit camera to camera restrictor bounds
	var cam_restrictor = result[0].collider.get_node("CameraRestrictorShape")
	var cam_restrictor_shape = cam_restrictor.shape
	
	if not cam_restrictor_shape is RectangleShape2D:
		return
	
	var vp_rect = get_viewport_rect().size / zoom
	
	limit_left = cam_restrictor.global_position.x - cam_restrictor_shape.size.x / 2
	limit_right = cam_restrictor.global_position.x + cam_restrictor_shape.size.x / 2
	if vp_rect.x > cam_restrictor_shape.size.x:
		position.x = cam_restrictor.global_position.x
	
	limit_top = cam_restrictor.global_position.y - cam_restrictor_shape.size.y / 2
	limit_bottom = cam_restrictor.global_position.y + cam_restrictor_shape.size.y / 2
	if vp_rect.y > cam_restrictor_shape.size.y:
		position.y = cam_restrictor.global_position.y

func free_camera():
	limit_left = -100000
	limit_right = 100000
	limit_top = -100000
	limit_bottom = 1000000
	
	var offset = Vector2.ZERO
	
	if player.is_on_floor():
		offset.y += FLOOR_Y_OFFSET
		position_smoothing_speed = FLOOR_SMOOTH_SPEED
	else:
		var floor_ceil_dist_norm = player_floor_ceil_dist_normalized()
		offset.y = -FLOOR_Y_OFFSET * (floor_ceil_dist_norm - 0.5) * 2
	
	position = player.position + offset

# return how close the player is to nearest floor/ceiling
# 0 = on floor
# 1 = on ceiling
func player_floor_ceil_dist_normalized() -> float:
	var ceil_dist = get_nearest_point_distance(Vector2.UP)
	var floor_dist = get_nearest_point_distance(Vector2.DOWN)
	
	if ceil_dist == -1 or floor_dist == -1:
		return 0.5
	
	var total_dist = ceil_dist + floor_dist
	
	if total_dist < MIN_DISTANCE_FOR_DYNAMIC_CAM:
		return 0
	
	
	return floor_dist / total_dist

func get_nearest_point_distance(dir : Vector2):
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.position, player.position + dir * 1000.0, 1)
	var result = space.intersect_ray(query)
	
	if not result:
		return -1
	
	return player.position.distance_to(result.position)
