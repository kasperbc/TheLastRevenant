extends Panel
class_name SettingsMan

@export var setting_parent : Node

var setting_categories : Array[SettingCategory]

func _ready():
	var audio = SettingCategory.new("Audio")
	audio.settings.append(SliderSetting.new("Music Volume", "music_volume", 1.0, 0.0, 1.0, 0.01, true))
	audio.settings.append(SliderSetting.new("Sound Volume", "sound_volume", 1.0, 0.0, 1.0, 0.01, true))
	
	var controls = SettingCategory.new("Controls")
	controls.settings.append(DropdownSetting.new("Control Method", "control_method", 
		["Keyboard + Mouse", "Gamepad (PlayStation)", "Gamepad (Xbox)", "Gamepad (Nintendo Switch Pro Controller)", "Gamepad (Generic)"]))
	
	setting_categories.append(audio)
	setting_categories.append(controls)
	
	update_settings_ui()

func update_settings_ui():
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
