extends StaticBody2D

@export var open_at_start : bool = true

func _ready():
	if open_at_start:
		open_door()

func close_door():
	set_collision_layer_value(1, true)

func open_door():
	set_collision_layer_value(1, false)
