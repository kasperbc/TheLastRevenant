class_name HookableObject
extends PhysicsBody2D

@export_group("Player near detection")
@export var detect_player_near : bool = false
@export var player_near_range : float = 0.0
@export_group("")
@export var static_object : bool = false

var hook_attached
var player_near_triggered = false

func _process(delta):
	if hook_attached:
		check_player_near()

func check_player_near():
	if player_near_range == 0 or player_near_triggered or not detect_player_near:
		return
	
	var distance_to_player = global_position.distance_to(GameMan.get_player().global_position)
	if distance_to_player > player_near_range:
		return
	
	_on_player_near()
	player_near_triggered = true

func _on_hook_attached():
	print("Hooked!")
	hook_attached = true

func _on_hook_detached():
	print("Detached!")
	hook_attached = false
	player_near_triggered = false

func _on_player_attached():
	print("Player attached!")

func _on_player_detached():
	print("Player detached!")
	hook_attached = false
	player_near_triggered = false

func _on_player_near():
	print("Player near!")

func _on_player_attacked():
	print("Player attacked!")
