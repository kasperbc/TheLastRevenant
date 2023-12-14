extends Area2D
class_name BackgroundChangeArea

@export var background : CompressedTexture2D

func _on_body_entered(body):
	if not body.is_in_group("Players"):
		return
	
	if not background:
		return
	
	get_tree().root.get_node("Main/Background").change_background(background)
