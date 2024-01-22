extends Resource
class_name Upgrade

@export var id : GameManager.Upgrades
@export var name : String
@export_multiline var description : String
@export var texture : CompressedTexture2D
@export var texture_wireframe : CompressedTexture2D

func _init(p_id = GameManager.Upgrades.DEFAULT, p_name = "Upgrade", p_description = "Description", p_texture = null):
	id = p_id
	name = p_name
	description = p_description
	texture = p_texture
