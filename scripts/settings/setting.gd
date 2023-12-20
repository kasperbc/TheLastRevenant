extends RefCounted
class_name Setting

var name : String
var internal_name : String
var default_value

func _init(setting_name : String, setting_internal_name : String, setting_default_value):
	name = setting_name
	internal_name = setting_internal_name
	default_value = setting_default_value

func get_setting_type():
	return "Setting"

func create_ui_setter():
	return null
