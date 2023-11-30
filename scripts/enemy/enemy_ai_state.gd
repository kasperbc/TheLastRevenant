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
var path_on_cooldown = false

@export var pathfind_to_player : bool = false
@export var path_update_rate : float = 0.1

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

func move_towards_player(speed : float):
	if not nav_agent or path_on_cooldown:
		return

	move_towards_point(nav_agent.get_next_path_position(), speed)

func update_path():
	if not pathfind_to_player:
		return
	
	nav_agent.target_position = GameMan.get_player().global_position
	
	await get_tree().create_timer(path_update_rate).timeout
	
	update_path()

func get_metadata(value : String):
	var data = body.get_meta(value)
	
	if not data:
		print("Metadata %s not found!" % value)
	
	return data
