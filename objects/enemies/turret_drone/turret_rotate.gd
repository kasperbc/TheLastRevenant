extends RotateToPlayer

var active = false
var rotate = true
@export var idle_direction = Vector2.DOWN

func _process(delta):
	if active and rotate:
		super(delta)
	elif not active:
		rotation = rotate_toward(rotation, Vector2.RIGHT.angle_to(idle_direction), delta * 2.5)
