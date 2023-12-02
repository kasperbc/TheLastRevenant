extends Node

class_name GameManager

@onready var player : Node = get_tree().get_first_node_in_group("Players")
@onready var player_health : Node = player.find_child("HealthMan")

enum Upgrades {
	DEFAULT = 0,
	HOOKSHOT = 1,
	VISUALIZER = 2,
	VELOCITY_MODULE = 3,
	GALVANIC_MODULE = 4,
	THERMAL_MODULE = 5
}

enum UpgradeStatus {
	LOCKED = 0, # not unlocked
	ENABLED = 1, # unlocked & enabled
	DISABLED = 2 # unlocked & not enabled
}

var upgrades_collected : Array[Upgrade]
var health_expansions_collected : Array[int]
var speed_expansions_collected : Array[int]
var range_expansions_collected : Array[int]

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

func get_upgrade_status(value : Upgrades) -> UpgradeStatus:
	for u in upgrades_collected:
		if u.id == value:
			return UpgradeStatus.ENABLED
	
	return UpgradeStatus.LOCKED

func unlock_upgrade(value : Upgrade):
	if not upgrades_collected.has(value):
		upgrades_collected.append(value)
