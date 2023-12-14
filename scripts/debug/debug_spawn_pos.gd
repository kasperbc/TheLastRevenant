extends Node2D

@export var enabled : bool

func _ready():
	if not enabled:
		return
	
	GameMan.get_player().global_position = global_position
	GameMan.get_player().get_node("Hook").global_position = global_position
