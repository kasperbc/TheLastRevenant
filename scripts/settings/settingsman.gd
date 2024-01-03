extends Panel
class_name SettingsMan

@export var setting_parent : Node

var setting_categories : Array[SettingCategory]

const SETTING_FILE_PATH = "user://settings.cfg"
const KEYBINDS_FILE_PATH = "res://default_controls.json"
const SETTING_META_SECTION = "Meta"
const SETTING_USER_SECTION = "User"
const SETTING_KEYBIND_SECTION = "Keybinds"

func _ready():
	create_settings()
	create_settings_file()
	create_settings_ui()
	GameMan.update_input_map()

func create_settings():
	var audio = SettingCategory.new("Audio")
	audio.settings.append(SliderSetting.new("Music Volume", "music_volume", 1.0, 0.0, 1.0, 0.01, true))
	audio.settings.append(SliderSetting.new("Sound Volume", "sound_volume", 1.0, 0.0, 1.0, 0.01, true))
	
	var controls = SettingCategory.new("Controls")
	controls.settings.append(DropdownSetting.new("Control Method", "control_method", 
		["Keyboard + Mouse", "Nintendo Switch Pro Controller", "PlayStation Controller (Untested)", "Xbox Controller (Untested)", "Generic Gamepad"],
		["keyboard_mouse", "gamepad_nspro", "gamepad_playstation", "gamepad_xbox", "gamepad_generic"]))
	controls.settings.append(KeybindSetting.new("Move Left", "move_left", "move_left"))
	controls.settings.append(KeybindSetting.new("Move Right", "move_right", "move_right"))
	controls.settings.append(KeybindSetting.new("Jump", "jump", "jump"))
	controls.settings.append(KeybindSetting.new("Interact", "interact", "interact"))
	controls.settings.append(KeybindSetting.new("Pause Game", "pause_game", "pause_game"))
	controls.settings.append(KeybindSetting.new("Use Hookshot", "fire_hook", "fire_hook"))
	controls.settings.append(KeybindSetting.new("Hookshot Counter/Artillery Toggle", "hook_attack", "hook_attack"))
	
	setting_categories.append(audio)
	setting_categories.append(controls)

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
			
			var container = Container.new()
			container.custom_minimum_size = Vector2(400, 30)
			hbox.add_child(container)
			
			container.add_child(setting_name_label)
			setting_name_label.set_anchors_preset(PRESET_CENTER_LEFT, true)
			
			if setting_ui_setter:
				var container2 = Container.new()
				container2.custom_minimum_size = Vector2(400, 50)
				hbox.add_child(container2)
				container2.add_child(setting_ui_setter)
				setting_ui_setter.set_anchors_preset(PRESET_CENTER_RIGHT, true)
				setting_ui_setter.position.x -= clamp(setting_ui_setter.size.x - 100, 0, 10000)

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
			
			var section = SETTING_KEYBIND_SECTION if s.get_setting_type() == "Keybind" else SETTING_USER_SECTION
			if not settings_file.has_section_key(section, s.internal_name):
				settings_file.set_value(section, s.internal_name, s.default_value)
	
	settings_file.save(SETTING_FILE_PATH)

func reset_settings():
	var result = DirAccess.remove_absolute(SETTING_FILE_PATH)
	
	if not result == OK:
		return
	
	for c in $SettingBackground/ScrollContainer/VBoxContainer.get_children():
		$SettingBackground/ScrollContainer/VBoxContainer.remove_child(c)
		c.queue_free()
	
	setting_categories.clear()
	
	create_settings()
	create_settings_file()
	GameMan.on_setting_change()
	create_settings_ui()
	GameMan.update_input_map()

func refresh_settings_ui():
	for c in $SettingBackground/ScrollContainer/VBoxContainer.get_children():
		$SettingBackground/ScrollContainer/VBoxContainer.remove_child(c)
		c.queue_free()
	
	create_settings_ui()

func hide_settings():
	visible = false

func show_settings():
	visible = true
