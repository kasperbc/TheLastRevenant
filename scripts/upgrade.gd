extends Resource
class_name Upgrade

@export var id : GameManager.Upgrades
@export var name : String
@export_multiline var description : String

func _init(p_id = GameManager.Upgrades.DEFAULT, p_name = "Upgrade", p_description = "Description"):
	id = p_id
	name = p_name
	description = p_description
