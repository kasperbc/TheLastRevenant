extends Node
class_name EnemyAI

@export var default_state : String = "idle"
@onready var state = default_state

var active : bool = true

func _process(delta):
	process_active_state(delta)
	change_state()

func process_active_state(delta):
	if not active:
		return
	
	var children = get_children()
	
	for child in children:
		if not child is EnemyAIState:
			continue
		
		if child.name == state:
			child.ai_state_process(delta)
			return
	
	print("Cannot find state %s!" % state)

func change_state():
	pass
