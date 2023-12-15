extends Area2D

@export var music : String
@export var volume : float
@export var boss : Node
signal activated

var activate_done = false

func _on_body_entered(body):
	if not body is PlayerMovement:
		return
	if activate_done:
		return
	
	activate_done = true
	
	if not music == "":
		GameMan.get_audioman().play_music(music, volume)
	
	if is_instance_valid(boss):
		boss.process_mode = PROCESS_MODE_INHERIT
		activated.emit()
