class_name HookableObject
extends PhysicsBody2D

@export_group("Player near detection")
@export var detect_player_near : bool = false
@export var player_near_range : float = 0.0

func _on_hook_attached():
	print("Hooked!")

func _on_hook_detached():
	print("Detached!")

func _on_player_attached():
	print("Player attached!")

func _on_player_detached():
	print("Player detached!")

func _on_player_near():
	print("Player near!")
