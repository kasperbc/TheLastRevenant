extends Area2D

@export var boss : Node

signal activated

func _on_body_entered(body):
	if not body is PlayerMovement:
		return
	
	activated.emit()
	
	await get_tree().create_timer(3).timeout
	
	boss.process_mode = Node.PROCESS_MODE_INHERIT
