extends Area2D
class_name Station

func _process(delta):
	if Input.is_action_just_pressed("interact") and is_player_in_area():
		on_station_activate()
	
	set_key_prompt(is_player_in_area())

func on_station_activate():
	pass

func set_key_prompt(value):
	if get_node_or_null("KeyPrompt"):
		$KeyPrompt.visible = value

func is_player_in_area() -> bool:
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("Players"):
			return true
	
	return false
