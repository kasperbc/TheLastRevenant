extends EnemyAIState
class_name FlyStraightTowardsPlayer

@export var max_speed = 100.0
@export var accleration = 100.0
@export var target_pos_variation = 16.0

var speed = 0.0

var dir : Vector2

func _on_state_activate():
	set_dir()
	rotate_towards_dir()

func set_dir():
	var target_pos = GameMan.get_player().global_position
	target_pos.x += randf_range(-target_pos_variation, target_pos_variation)
	target_pos.y += randf_range(-target_pos_variation, target_pos_variation)
	
	dir = body.global_position.direction_to(target_pos)

func rotate_towards_dir():
	var angle = rad_to_deg(body.global_position.angle_to_point(body.global_position + dir * 10))
	body.rotation_degrees = angle

func _on_state_deactivate():
	pass

func ai_state_process(delta):
	if not dir:
		return
	
	accelerate(delta)
	go_towards_player()

func go_towards_player():
	move_towards_point(body.global_position + dir * 10, speed)
	
	die_if_on_wall()

func die_if_on_wall():
	if body.is_on_wall():
		dir = Vector2.ZERO
		await get_tree().create_timer(0.1).timeout
		
		body.die()

func accelerate(delta):
	speed += accleration * delta
	speed = clamp(speed, 0, max_speed)
