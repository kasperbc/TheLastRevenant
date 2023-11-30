extends Node
class_name EnemyAIState

var global_position : Vector2

var _body : Enemy
var body : Enemy :
	get:
		if not _body:
			_body = get_parent().get_parent()
		return _body
	set(value):
		_body = value

@onready var nav_agent : NavigationAgent2D = body.get_node("NavigationAgent2D")

@export var pathfind : bool = false
@export var path_update_rate : float = 0.1
var path_target : Vector2

func _ready():
	update_path()

func _process(delta):
	global_position = body.global_position

func ai_state_process(delta):
	pass

func move_towards_point(target : Vector2, speed : float):
	var dir = body.global_position.direction_to(target)
	
	body.velocity = dir * speed
	body.move_and_slide()

func pathfind_towards_point(target : Vector2, speed : float):
	path_target = target
	if not nav_agent:
		return
	
	move_towards_point(nav_agent.get_next_path_position(), speed)

func move_towards_player(speed : float):
	pathfind_towards_point(GameMan.get_player().global_position, speed)

func update_path():
	if pathfind and path_target:
		nav_agent.target_position = path_target
	
	await get_tree().create_timer(path_update_rate).timeout
	
	update_path()

func get_metadata(value : String):
	var data = body.get_meta(value)
	
	if not data:
		print("Metadata %s not found!" % value)
	
	return data
