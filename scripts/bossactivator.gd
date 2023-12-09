extends Area2D

@export var boss : Node
signal activated

func _on_body_entered(body):
	if body is PlayerMovement:
		activated.emit()
	
	boss.process_mode = PROCESS_MODE_INHERIT
