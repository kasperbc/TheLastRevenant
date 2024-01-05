extends Setting
class_name ToggleSetting

func _init(setting_name : String, setting_internal_name : String, setting_default_value : bool):
	super(setting_name, setting_internal_name, setting_default_value)
	refresh_ui_on_change = true

func get_setting_type():
	return "Toggle"

func create_ui_setter():
	var toggle = CheckButton.new()
	toggle.custom_minimum_size = Vector2(100,50)
	
	var value = get_setting_value()
	
	if not value == null:
		toggle.button_pressed = value
		toggle.toggled.connect(save_setting_value)
	else:
		toggle.queue_free()
		return null
	
	ui_setter = toggle
	return toggle
