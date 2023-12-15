extends Node2D


# Called when the node enters the scene tree for the first time.
func activate():
	$SmallWoodBox.process_mode = Node.PROCESS_MODE_INHERIT
	$SmallWoodBox.visible = true


func _on_pickup_velocity_module_body_entered(body):
	activate()
