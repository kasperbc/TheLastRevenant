extends Label

func _process(delta):
	var td = SaveMan.save.get_value("Meta", "save_created", Time.get_datetime_dict_from_system())
	
	text = "Save created: %s-%s-%s %s:%s:%s" % [td.day, td.month, td.year, td.hour, td.minute, td.second]
