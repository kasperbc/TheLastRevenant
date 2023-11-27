extends Node

class_name GameManager

@onready var player : Node = get_tree().get_first_node_in_group("Players")
@onready var player_health : Node = player.find_child("HealthMan")

func get_player() -> Node:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Players")
	
	return player

func get_player_health() -> Node:
	if not is_instance_valid(player_health):
		player_health = get_player().find_child("HealthMan")
	
	return player_health

func reload_scene():
	get_tree().reload_current_scene()
