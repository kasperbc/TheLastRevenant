extends Label
class_name SliderSettingPercentageLabel

func _on_slider_change(value):
	text = "%s" % round(value * 100) + "%"
