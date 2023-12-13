extends EnemyAIState
class_name OrbitFly

@export var min_anglular_vel : float
@export var max_anglular_vel : float

var ang_vel

func _ready():
	ang_vel = randf_range(min_anglular_vel, max_anglular_vel)

func ai_state_process(delta):
	body.rotate(deg_to_rad(ang_vel) * delta)
