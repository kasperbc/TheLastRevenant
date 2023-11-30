extends Node2D

var light
var light_energy
var revealed = false

@export var reveal_range = 100.0
@export var turn_off_after_exit = false

func _ready():
	if not get_parent() is PointLight2D:
		print("Parent is not point light!")
		queue_free()
		return
	
	light = get_parent()
	light_energy = light.energy
	light.enabled = false


func _process(delta):
	var distance_to_player = global_position.distance_to(GameMan.get_player().global_position)
	
	if distance_to_player <= reveal_range and not revealed:
		light.enabled = true
		revealed = true
		light.energy = 0
	
	if revealed:
		light.energy = lerp(light.energy, light_energy, 0.005)
