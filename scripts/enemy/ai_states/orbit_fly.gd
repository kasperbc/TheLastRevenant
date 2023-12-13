extends EnemyAIState
class_name OrbitFly

@export var speed : float
@export var min_anglular_vel : float
@export var max_anglular_vel : float
@export var lifetime : float

var x_dir = 0.0
@onready var y_dir : float = randf_range(-0.2, 0.2)
var ang_vel

func _ready():
	ang_vel = randf_range(min_anglular_vel, max_anglular_vel)

func ai_state_process(delta):
	body.velocity = Vector2(x_dir, y_dir) * speed
	
	body.rotate(deg_to_rad(ang_vel) * delta)
	
	body.move_and_slide()
