extends Area2D
class_name Pickup

@export_group("Hover")
@export var hover = false
@export var hover_speed = 1.0
@export var hover_intensity = 5.0

@onready var random_hover_offset = randf_range(0, hover_speed)

@onready var base_pos = global_position

func _on_player_contact(body : Node2D):
	if body.is_in_group("Players"):
		pick_up()

func _process(delta):
	if hover:
		process_hover_anim()

func process_hover_anim():
	global_position.y = base_pos.y + sin((Time.get_unix_time_from_system() * hover_speed) + random_hover_offset) * hover_intensity

func pick_up():
	destroy_self()

func destroy_self():
	queue_free()
