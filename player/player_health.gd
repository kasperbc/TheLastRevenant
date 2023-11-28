extends Node

const BASE_MAX_HEALTH = 4

var _current_health
var current_health : 
	get:
		return _current_health
	set(value):
		_current_health = value
		get_tree().root.get_node("/root/Main/UI/Control/HealthLabel").text = "Health %s" % current_health

var health_upgrades = 0
var invincible = false


func _ready():
	current_health = BASE_MAX_HEALTH

func damage():
	if invincible:
		return
	
	current_health -= 1
	print("Player took damage: current health: %s" % current_health)
	
	if current_health <= 0:
		GameMan.reload_scene()
	
	invincible = true
	$InvincibilityTimer.start()


func _on_invincibility_timer_timeout():
	invincible = false
