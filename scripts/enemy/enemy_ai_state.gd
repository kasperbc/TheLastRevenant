extends Node
class_name EnemyAIState

var global_position : Vector2
var position : Vector2

var _body : Enemy
var body : Enemy :
	get:
		if not _body:
			_body = get_parent().get_parent()
		return _body
	set(value):
		_body = value

var _ai_controller : EnemyAI
var ai_controller : EnemyAI :
	get:
		if not _ai_controller:
			_ai_controller = get_parent()
		return _ai_controller
	set(value):
		_ai_controller = value

@onready var nav_agent : NavigationAgent2D = body.get_node("NavigationAgent2D")

@export_group("Pathfinding")
@export var pathfind : bool = false
@export var path_update_rate : float = 0.1
@export_group("Projectile")
@export var projectile_identifier : String = "missile"
@export var play_fx : bool = true
@export var fx_name = "missile_fire"
@export var fx_maxdistance = 300.0

var path_target : Vector2
var last_projectile

var speed_multiplier : float = 1.0

func _ready():
	update_path()

func _process(delta):
	global_position = body.global_position
	position = body.position

func ai_state_process(delta):
	pass

func _on_state_activate():
	pass

func _on_state_deactivate():
	pass

func move_towards_point(target : Vector2, speed : float):
	var dir = body.global_position.direction_to(target)
	
	body.velocity = dir * (speed * speed_multiplier)
	body.move_and_slide()

func pathfind_towards_point(target : Vector2, speed : float):
	path_target = target
	if not nav_agent:
		return
	
	move_towards_point(nav_agent.get_next_path_position(), speed)

func move_towards_player(speed : float, offset = Vector2.ZERO, max_distance = 0):
	var target_pos = GameMan.get_player().global_position + offset
	target_pos += GameMan.get_player().global_position.direction_to(body.global_position) * max_distance
	
	pathfind_towards_point(target_pos + offset, speed)

func update_path():
	if pathfind and path_target and is_active():
		nav_agent.target_position = path_target
	
	if not get_tree():
		return
	await get_tree().create_timer(path_update_rate).timeout

	update_path()

func get_metadata(value : String):
	var data = body.get_meta(value)
	
	if not data:
		print("Metadata %s not found!" % value)
	
	return data

func is_active():
	return get_parent().state == name

func shoot_projectile(offset : Vector2):
	if projectile_identifier == "":
		return
	
	var new_projectile = PoolMan.borrow_from_pool(self, projectile_identifier)
	if not new_projectile:
		return
	
	if play_fx and global_position.distance_to(GameMan.get_player().global_position) < fx_maxdistance:
		GameMan.get_audioman().play_fx(fx_name, -5, randf_range(0.95, 1.05))
	
	if new_projectile is Node2D:
		new_projectile.set_deferred("global_position", global_position + offset)
	
	await get_tree()
	
	last_projectile = new_projectile

func shoot_projectile_towards_player(offset : Vector2, distance : float):
	shoot_projectile((body.global_position.direction_to(GameMan.get_player().global_position) * distance) + offset)
