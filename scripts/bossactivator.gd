extends Area2D

@export var boss : Node
signal activated

func _on_body_entered(body):
	if not body is PlayerMovement:
		return
	
	if is_instance_valid(boss):
		boss.process_mode = PROCESS_MODE_INHERIT
		activated.emit()
