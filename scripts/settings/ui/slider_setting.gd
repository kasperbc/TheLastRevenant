extends Setting
class_name SliderSetting

var slider_min_value : float
var slider_max_value : float
var slider_step : float
var percentage : bool

func _init(setting_name : String, setting_internal_name : String, setting_default_value : float, min_value, max_value, step, value_percentage):
	super(setting_name, setting_internal_name, setting_default_value)
	
	slider_min_value = min_value
	slider_max_value = max_value
	slider_step = step
	percentage = value_percentage

func get_setting_type():
	return "Slider"

func create_ui_setter():
	var slider = HSlider.new()
	slider.custom_minimum_size = Vector2(100,50)
	slider.min_value = slider_min_value
	slider.max_value = slider_max_value
	slider.step = slider_step
	
	var value = get_setting_value()
	if not value == null:
		slider.value = value
	else:
		slider.queue_free()
		return null
	
	if percentage:
		var perc_label = SliderSettingPercentageLabel.new()
		perc_label.text = "%s" % round(value * 100) + "%"
		slider.value_changed.connect(perc_label._on_slider_change)
		slider.value_changed.connect(save_setting_value)
		slider.add_child(perc_label)
	
	ui_setter = slider
	
	return slider
