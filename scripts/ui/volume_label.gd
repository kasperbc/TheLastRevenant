extends Label

func _on_volume_slider_value_changed(value):
	text = "Volume %s" % str(value * 100) + "%"
	AudioServer.set_bus_volume_db(0, (1 - value) * -20)
	if value:
		AudioServer.set_bus_volume_db(0, -60)
