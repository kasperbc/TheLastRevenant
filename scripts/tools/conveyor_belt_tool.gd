@tool
extends Node2D

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if not Engine.is_editor_hint():
		return
	
	if not get_parent().get_parent().has_meta("size"):
		return
	
	var size = get_parent().get_parent().get_meta("size") * 16
	
	draw_line(position + Vector2(size, 0), position - Vector2(size, 0), Color.RED, 1.5, false)
