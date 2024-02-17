extends EnemyAIState
class_name LaserShoot

@onready var idle_time = get_metadata("idle_time")
@onready var shoot_time = get_metadata("shoot_time")
@onready var time_offset = get_metadata("time_offset")

@onready var laser : Sprite2D = body.get_node("Laser")
@onready var laser_end : Node2D = body.get_node("LaserEnd")
@onready var collider_shape : CollisionShape2D = body.get_node("ContactDetection").get_node("CollisionShape2D")

var shooting : bool
var time_since_toggle : float

var floor_pos : Vector2
var floor_dist : float

func on_state_activate():
	shooting = false
	laser.self_modulate.a = 0
	laser_end.modulate.a = 0
	toggle_shooting_idle()

func _ready():
	time_since_toggle -= time_offset
	super()

func _process(delta):
	time_since_toggle += delta
	
	var time_treshhold = idle_time if not shooting else shoot_time
	
	if time_since_toggle > time_treshhold:
		toggle_shooting_idle()
	
	super(delta)

func ai_state_process(delta):
	if shooting:
		get_floor_pos()
		var floor_center_point = ((floor_pos - global_position) / 2 + global_position)
		
		laser.global_position = floor_center_point
		laser.region_rect.size = Vector2(floor_dist, 6)
		laser_end.global_position = floor_pos
		
		collider_shape.global_position = floor_center_point
		collider_shape.scale = Vector2(floor_dist, 1)

func get_floor_pos():
	var space_state = body.get_world_2d().direct_space_state
	
	var dir = Vector2.RIGHT.rotated(body.global_rotation)
	
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.new()
	query.from = body.global_position
	query.to = body.global_position + (dir * 10000)
	query.collision_mask = 1
	
	var result = space_state.intersect_ray(query)
	
	if result:
		floor_pos = result.position
	else:
		floor_pos = global_position
	
	floor_dist = floor_pos.distance_to(body.global_position)

func toggle_shooting_idle():
	shooting = !shooting
	time_since_toggle = 0
	
	if not is_active():
		return
	
	collider_shape.disabled = not shooting
	
	if shooting:
		body.get_node("Sprite2D").animation = "shoot"
		laser.self_modulate.a = 1
		laser_end.modulate.a = 1
	else:
		body.get_node("Sprite2D").animation = "idle"
		var t = get_tree().create_tween().set_parallel(true)
		t.set_trans(Tween.TRANS_CIRC)
		t.tween_property(laser, "self_modulate", Color(1,1,1,0), idle_time / 2)
		t.tween_property(laser_end, "modulate", Color(1,1,1,0), idle_time / 2)
