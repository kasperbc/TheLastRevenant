extends RefCounted
class_name Setting

var name : String
var internal_name : String
var default_value

var ui_setter

func _init(setting_name : String, setting_internal_name : String, setting_default_value):
	name = setting_name
	internal_name = setting_internal_name
	default_value = setting_default_value

func get_setting_type():
	return "Setting"

func create_ui_setter():
	return null

func get_setting_value():
	var s_file = ConfigFile.new()
	s_file.load(SettingsMan.SETTING_FILE_PATH)
	
	if s_file.has_section_key(SettingsMan.SETTING_USER_SECTION, internal_name):
		return s_file.get_value(SettingsMan.SETTING_USER_SECTION, internal_name)
	else:
		print("Setting %s not found!" % internal_name)
		return null

func save_setting_value(value):
	var s_file = ConfigFile.new()
	
	var result = s_file.load(SettingsMan.SETTING_FILE_PATH)
	print("Result: %s, Value %s" % [result, value])
	if not result == OK:
		return
	
	s_file.set_value(SettingsMan.SETTING_USER_SECTION, internal_name, value)
	s_file.save(SettingsMan.SETTING_FILE_PATH)
