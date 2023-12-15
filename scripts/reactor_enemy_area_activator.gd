extends Node

@export var enemy_parent : Node2D


func _on_pickup_thermal_module_body_entered(body):
	enemy_parent.process_mode = Node.PROCESS_MODE_INHERIT
	enemy_parent.visible = true
