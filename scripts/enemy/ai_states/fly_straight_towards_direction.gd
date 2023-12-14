extends EnemyAIState
class_name FlyStraightTowardsDirection

@export var max_speed = 100.0
@export var accleration = 100.0
@export var dir_variation = 10.0

var speed = 0.0

var dir : Vector2

func _on_state_activate():
	speed = 0.0

func set_dir(direction):
	var _dir = direction
	var _dir_angle = Vector2.RIGHT.angle_to(_dir)
	_dir_angle = rad_to_deg(_dir_angle) + randf_range(-dir_variation, dir_variation)
	_dir = Vector2.RIGHT.rotated(deg_to_rad(_dir_angle))
	
	dir = _dir
	
	rotate_towards_dir()

func rotate_towards_dir():
	var angle = rad_to_deg(body.global_position.angle_to_point(body.global_position + dir * 10))
	body.rotation_degrees = angle

func ai_state_process(delta):
	if not dir:
		return
	
	accelerate(delta)
	go_towards_dir()

func go_towards_dir():
	move_towards_point(body.global_position + dir * 10, speed)
	
	die_if_on_wall()

func die_if_on_wall():
	if body.is_on_wall():
		var collider = body.get_slide_collision(0).get_collider()
		if collider.is_in_group("Boxes"):
			collider.die()
		
		dir = Vector2.ZERO
		await get_tree().create_timer(0.1).timeout
		
		body.die()

func accelerate(delta):
	speed += accleration * delta
	speed = clamp(speed, 0, max_speed)
