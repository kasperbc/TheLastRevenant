extends EnemyAIState
class_name RotateShoot

@export var rotate_points : PackedFloat64Array
@export var rotate_speed : float
@export var wait_time : float

var current_point
var target_rotation
var rotation_reached

func _on_state_activate():
	current_point = 0
	rotate_points = get_metadata("rotate_points")
	target_rotation = rotate_points[current_point]

func ai_state_process(delta):
	if rotate_points.size() == 0:
		return
	
	var target_rad = deg_to_rad(target_rotation)
	
	body.rotation = rotate_toward(body.rotation, target_rad, rotate_speed * speed_multiplier * delta)
	
	if abs(body.rotation - target_rad) < 0.1 and not rotation_reached:
		on_rotation_reach()

func on_rotation_reach():
	rotation_reached = true
	
	shoot_projectile(Vector2.RIGHT.rotated(body.rotation) * 20.0)
	await get_tree().create_timer(wait_time / speed_multiplier).timeout
	change_point()
	
	rotation_reached = false

func change_point():
	current_point += 1
	if current_point >= rotate_points.size():
		current_point = 0
	
	target_rotation = rotate_points[current_point]

func shoot_projectile(offset):
	super(offset)
	
	if last_projectile:
		if last_projectile.get_node("AI/fly_towards_point"):
			last_projectile.get_node("AI/fly_towards_point").set_dir(Vector2.RIGHT.rotated(body.rotation))
