extends EnemyAIState
class_name GroundMove

@export var move_speed : float = 100.0
@export var acceleration : float = 50.0
@export var jump_force : float = 200.0
@export var gravity : float = 500.0
@export var wall_stops_velocity : bool = false

var current_speed : float
var dir : float

func ai_state_process(delta):
	move_to_direction(delta)
	apply_gravity(delta)
	body.move_and_slide()

func move_to_direction(delta):
	current_speed = move_toward(current_speed, move_speed * dir, acceleration * delta)
	
	if wall_stops_velocity and not current_speed == 0:
		if clamp(current_speed * 100, -1,1) == get_wall_dir():
			current_speed = 0
	
	body.velocity.x = current_speed

func apply_gravity(delta):
	body.velocity.y += gravity * delta

func jump():
	body.velocity.y = -jump_force

func flip_dir():
	dir *= -1

func change_dir(value):
	dir = clamp(value, -1, 1)

func is_on_edge() -> bool:
	if not body.is_on_floor():
		return false
	
	var collider_rect = body.get_node("CollisionShape2D").shape.get_rect()
	
	var space = body.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.collision_mask = 1
	query.from = body.global_position + Vector2(abs(collider_rect.position.x), 0)
	query.to = query.from + Vector2(0, (abs(collider_rect.position.y) * 2))
	query.collide_with_areas = false
	var result_right = space.intersect_ray(query)
	
	query.from = body.global_position - Vector2(abs(collider_rect.position.x), 0)
	query.to = query.from + Vector2(0, (abs(collider_rect.position.y) * 2))
	var result_left = space.intersect_ray(query)
	
	return not (result_left and result_right)

func get_wall_dir() -> int:
	var collider_rect = body.get_node("CollisionShape2D").shape.get_rect()
	
	var space = body.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.collision_mask = 1
	query.from = body.global_position + Vector2(abs(collider_rect.position.x), 0)
	query.to = query.from + Vector2(5, 0)
	query.collide_with_areas = false
	var result_right = space.intersect_ray(query)
	
	query.from = body.global_position - Vector2(abs(collider_rect.position.x), 0)
	query.to = query.from + Vector2(-5, 0)
	var result_left = space.intersect_ray(query)
	
	if result_left and not result_right:
		return -1
	elif result_right and not result_left:
		return 1
	else:
		return 0
