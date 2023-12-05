@tool
extends Node2D

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if not Engine.is_editor_hint():
		return
	
	if not get_parent().has_meta("move_points"):
		return
	
	var path : PackedVector2Array = get_parent().get_meta("move_points")
	
	if path.size() < 2:
		return
	
	var i = 0
	while i < path.size() - 1:
		draw_line(path[i], path[i + 1], Color(1,0,0,0.5), 1.5, false)
		i += 1
