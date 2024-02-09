extends Node
class_name SaveManager

const SAVE_FILE_PATH = "user://save.thelastrevenant"
const TMP_SAVE_FILE_PATH = "user://tmp_save.thelastrevenant"

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
	reload_save()

func write_game_end_meta():
	var _save = save
	_save.set_value("Meta", "game_beat", true)
	
	if _save.has_section_key("Meta", "best_time"):
		_save.set_value("Meta", "best_time", min(get_value("playtime", 0), _save.get_value("Meta", "best_time")))
	else:
		_save.set_value("Meta", "best_time", get_value("playtime", 0))
	
	_save.save(SAVE_FILE_PATH)
	reload_save()

func import_save(path):
	var import_file = FileAccess.open(path, FileAccess.READ)
	var temp_save = FileAccess.open(TMP_SAVE_FILE_PATH, FileAccess.WRITE)
	temp_save.store_string(import_file.get_as_text())
	
	var save_validity_checker = ConfigFile.new()
	var err = save_validity_checker.load(TMP_SAVE_FILE_PATH)
	
	if err == OK:
		var _save = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		_save.store_string(import_file.get_as_text())
	
	DirAccess.remove_absolute(TMP_SAVE_FILE_PATH)
	
	reload_save()

func export_save(path):
	var export_file = FileAccess.open(path, FileAccess.WRITE)
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	export_file.store_string(save_file.get_as_text())
