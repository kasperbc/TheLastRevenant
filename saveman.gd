extends Node
class_name SaveManager

const SAVE_FILE_PATH = "user://save.thelastrevenant"
var save : ConfigFile

func _ready():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		create_save_file()

func reload_save():
	save = ConfigFile.new()
	save.load(SAVE_FILE_PATH)

func create_save_file():
	var save = ConfigFile.new()
	
	save.set_value("Meta", "version", 0)
	save.set_value("Meta", "game_beat", false)
	save.set_value("Meta", "save_created", Time.get_datetime_dict_from_system())
	
	save.save(SAVE_FILE_PATH)
	
	print("created")

func save_value(key : String, value):
	# var save = ConfigFile.new()
	# save.load(SAVE_FILE_PATH)
	
	if not save: reload_save()
	
	save.set_value("Save", key, value)
	# save.save(SAVE_FILE_PATH)

func get_value(key : String, default_value):
	# var save = ConfigFile.new()
	# save.load(SAVE_FILE_PATH)
	
	if not save: reload_save()
	
	if not save.has_section_key("Save", key):
		save_value(key, default_value)
	
	# save.load(SAVE_FILE_PATH)
	return save.get_value("Save", key)

func write_save():
	save.save(SAVE_FILE_PATH)
	reload_save()

func reset_save():
	if not save: reload_save()
	
	for key in save.get_section_keys("Save"):
		save.erase_section_key("Save", key)
	
	write_save()

func remove_save():
	DirAccess.remove_absolute(SAVE_FILE_PATH)
	create_save_file()

func write_game_end_meta():
	var _save = save
	_save.set_value("Meta", "game_beat", true)
	
	if _save.has_section_key("Meta", "best_time"):
		_save.set_value("Meta", "best_time", min(get_value("playtime", 0), _save.get_value("Meta", "best_time")))
	else:
		_save.set_value("Meta", "best_time", get_value("playtime", 0))
	
	_save.save(SAVE_FILE_PATH)
	reload_save()
