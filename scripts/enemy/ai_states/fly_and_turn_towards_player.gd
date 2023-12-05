extends FlyStraightTowardsPlayer
class_name FlyAndTurnTowardsPlayer

@export var turn_speed = 5.0

var target_point = Vector2.ZERO

func _on_state_activate():
	super()
	target_point = GameMan.get_player().global_position

func ai_state_process(delta):
	super(delta)
	
	move_target_point(delta)
	rotate_towards_target_point()

func move_target_point(delta):
	target_point.move_toward(GameMan.get_player().global_position, delta * turn_speed)

func rotate_towards_target_point():
	var angle = rad_to_deg(Vector2.RIGHT.angle_to(body.global_position.direction_to(target_point)))
	body.rotation_degrees = angle
