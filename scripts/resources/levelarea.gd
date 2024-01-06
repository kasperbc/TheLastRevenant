extends Resource
class_name LevelArea

@export var id : GameManager.LevelAreas
@export var name : String
@export_multiline var description : String
@export var icon : CompressedTexture2D

func _init(p_id = GameManager.LevelAreas.DEFAULT, p_name = "Area", p_description = "Description"):
	id = p_id
	name = p_name
	description = p_description
