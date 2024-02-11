extends Area2D

@export var music : String
@export var volume : float
@export var boss : Node
@export var show_bossbar : bool = true
signal activated

var activate_done = false

func _on_body_entered(body):
	if not body is PlayerMovement:
		return
	if activate_done:
		return
	
	activate_done = true
	
	if not music == "":
		GameMan.get_audioman().stop_music()
		GameMan.get_audioman().play_music(music, volume)
	
	if is_instance_valid(boss):
		boss.process_mode = PROCESS_MODE_INHERIT
		activated.emit()
		if show_bossbar:
			get_tree().root.get_node("Main/UI/Control/BossHealthBar").show_bosshealth(boss)
