extends Label

var showing = false

func show_area_text(area : LevelArea):
	if showing:
		return
	showing = true
	
	modulate.a = 0
	text = area.name
	
	var fadein_tween = get_tree().create_tween()
	fadein_tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	
	await get_tree().create_timer(2).timeout
	
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
	
	showing = false
