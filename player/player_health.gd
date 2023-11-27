extends Node

var health_upgrades = 0
@onready var current_health = BASE_MAX_HEALTH

const BASE_MAX_HEALTH = 4

signal on_health_change

func damage():
	current_health -= 1
	print("Player took damage: current health: %s" % current_health)
	
	if current_health <= 0:
		GameMan.reload_scene()
