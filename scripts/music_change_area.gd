extends Area2D

@export var music_name : String
@export var volume : float

func _on_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	GameMan.get_audioman().fade_to_music(music_name, 1, volume)
