extends Label

func _ready():
	var game_time = Time.get_unix_time_from_system() - GameMan.game_start_timestamp
	
	var time_dict = Time.get_datetime_dict_from_unix_time(game_time)
	
	var second = str(time_dict.second) + "s"
	if time_dict.second < 10:
		second = "0" + second
	
	var minute = str(time_dict.minute) + "m "
	if time_dict.minute < 10:
		minute = "0" + minute
	
	var hour = str(time_dict.hour) + "h "
	if time_dict.hour == 0:
		hour = ""
	
	text = hour + minute + second
