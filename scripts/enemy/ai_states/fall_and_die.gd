extends EnemyAIState

var x_dir : float
@export var x_speed = 75.0

var gravity = 100.0

func _on_state_activate():
	x_dir = clampf(Vector2.RIGHT.rotated(body.rotation).x * 100, -1, 1)

func _on_state_deactivate():
	pass

func ai_state_process(delta):
	body.velocity.x = x_dir * x_speed
	
	apply_gravity(delta)
	
	body.move_and_slide()
	if body.is_on_wall():
		body.die()

func apply_gravity(delta):
	body.velocity.y += gravity * delta
