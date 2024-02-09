extends Label

func _process(delta):
	if not SaveMan.save.has_section_key("Meta", "best_time"):
		text = "Best time: ---"
		return
	
	var time_dict = Time.get_datetime_dict_from_unix_time(int(SaveMan.save.get_value("Meta", "best_time")))
	var second = str(time_dict.second)
	if time_dict.second < 10:
		second = "0" + second
	
	var minute = str(time_dict.minute)
	if time_dict.minute < 10:
		minute = "0" + minute
	
	var hour = str(time_dict.hour)
	if time_dict.hour < 10:
		hour = "0" + hour

	text = "Best time: %s:%s:%s" % [hour, minute, second]
