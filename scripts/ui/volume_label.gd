extends Label

func _on_volume_slider_value_changed(value):
	text = "Volume %s" % str(value * 100) + "%"
