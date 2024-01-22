extends Label

var showing = false

func show_area_text(area : LevelArea):
	if showing:
		return
	showing = true
	
	modulate.a = 0
	text = "New area discovered: %s" % area.name
	$NewAreaInfo.text = "View info on your prompter (Press %s to open)" % GameMan.get_input_action_key_str("open_map")
	
	var fadein_tween = get_tree().create_tween()
	fadein_tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	
	await get_tree().create_timer(6).timeout
	
	var fadeout_tween = get_tree().create_tween()
	fadeout_tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
	
	showing = false
