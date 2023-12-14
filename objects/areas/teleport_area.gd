extends Area2D

@export var teleport_pos : Vector2

@export var fade_in_time : float = 0.5
@export var fade_out_time : float = 1
@export var wait_time : float = 1.5

func _on_body_entered(body):
	if not body is PlayerMovement:
		return
	
	get_tree().root.get_node("Main/UI/Control/FadeScreen").fade_to_black(fade_in_time)
	
	await get_tree().create_timer(wait_time).timeout
	
	get_tree().root.get_node("Main/UI/Control/FadeScreen").fade_to_transparent(fade_out_time)
	
	GameMan.get_player().global_position = teleport_pos
