extends Node

class_name GameManager

@onready var player : Node = get_tree().get_first_node_in_group("Players")

func get_player():
	return player
