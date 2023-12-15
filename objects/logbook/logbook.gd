extends Sprite2D

@export_multiline var text : String
@export var range = 64.0

func _process(delta):
	var distance = global_position.distance_to(GameMan.get_player().global_position)
	var in_range = distance <= range
	if in_range:
		get_tree().root.get_node("Main/UI/Control/LogbookBG").visible = true
		get_tree().root.get_node("Main/UI/Control/LogbookBG/LogbookText").text = text
	elif distance < range * 2:
		get_tree().root.get_node("Main/UI/Control/LogbookBG").visible = false
