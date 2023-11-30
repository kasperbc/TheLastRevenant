@tool
extends Node2D

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_circle(position, get_parent().reveal_range, Color(1,1,1,0.1))
