extends Node

const BASE_MAX_HEALTH = 4

var _current_health
var current_health : 
	get:
		return _current_health
	set(value):
		_current_health = value
		get_tree().root.get_node("/root/Main/UI/Control/HealthSprite").frame = 4 - (current_health % 5)

var health_upgrades = 0
var invincible = false


func _ready():
	current_health = get_max_health()

func damage():
	if invincible:
		return
	
	current_health -= 1
	
	if current_health <= 0:
		die()
		return
	
	invincible = true
	await get_tree().create_timer(1).timeout
	invincible = false

func die():
	GameMan.reload_scene()

func heal():
	current_health += 1
	
	if current_health > get_max_health():
		current_health = get_max_health()

func heal_full():
	current_health = get_max_health()

func get_max_health() -> int:
	return BASE_MAX_HEALTH
