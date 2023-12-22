extends Panel
class_name SettingsMan

@export var setting_parent : Node

var setting_categories : Array[SettingCategory]

const SETTING_FILE_PATH = "user://settings.cfg"
const SETTING_META_SECTION = "Meta"
const SETTING_USER_SECTION = "User"


func _ready():
	var audio = SettingCategory.new("Audio")
	audio.settings.append(SliderSetting.new("Music Volume", "music_volume", 1.0, 0.0, 1.0, 0.01, true))
	audio.settings.append(SliderSetting.new("Sound Volume", "sound_volume", 1.0, 0.0, 1.0, 0.01, true))
	
	var controls = SettingCategory.new("Controls")
	controls.settings.append(DropdownSetting.new("Control Method", "control_method", 
		["Keyboard + Mouse", "Gamepad (PlayStation)", "Gamepad (Xbox)", "Gamepad (Nintendo Switch Pro Controller)", "Gamepad (Generic)"],
		["keyboard_mouse", "gamepad_playstation", "gamepad_xbox", "gamepad_nspro", "gamepad_generic"]))
	controls.settings.append(ToggleSetting.new("Flip X", "flip_x", false))
	
	setting_categories.append(audio)
	setting_categories.append(controls)
	
	create_settings_file()
	create_settings_ui()

func create_settings_ui():
	for category in setting_categories:
		var category_label = Label.new()
		category_label.text = category.name
		category_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var category_label_settings = LabelSettings.new()
		category_label_settings.font_color = Color(1,1,1,0.5)
		category_label_settings.font_size = 20
		category_label.label_settings = category_label_settings
		
		setting_parent.add_child(category_label)
		
		for setting in category.settings:
			var hbox = HBoxContainer.new()
			setting_parent.add_child(hbox)
			
			var setting_name_label = Label.new()
			setting_name_label.text = setting.name
			
			var setting_ui_setter = setting.create_ui_setter()
			
			hbox.add_child(setting_name_label)
			
			if setting_ui_setter:
				hbox.add_child(setting_ui_setter)

func create_settings_file():
	var settings_file = ConfigFile.new()
	
	if not FileAccess.file_exists(SETTING_FILE_PATH):
		settings_file.save(SETTING_FILE_PATH)
	
	var res = settings_file.load(SETTING_FILE_PATH)
	
	if not res == OK:
		return
	
	if not settings_file.has_section_key(SETTING_META_SECTION, "format"):
		settings_file.set_value(SETTING_META_SECTION, "format", 1)
	
	for c in setting_categories:
		for s in c.settings:
			
			if not settings_file.has_section_key(SETTING_USER_SECTION, s.internal_name):
				settings_file.set_value(SETTING_USER_SECTION, s.internal_name, s.default_value)
	
	settings_file.save(SETTING_FILE_PATH)

func reset_settings():
	var result = DirAccess.remove_absolute(SETTING_FILE_PATH)
	
	if not result == OK:
		return
	
	for c in $SettingBackground/ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	
	create_settings_file()
	create_settings_ui()

func hide_settings():
	visible = false


func show_settings():
	visible = true
