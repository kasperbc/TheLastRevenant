extends AudioStreamPlayer2D

func _ready():
	var date = Time.get_datetime_dict_from_system()
	
	if date.month == 9 and date.month == 6 and (date.hour < 9 or date.hour > 11):
		play()
	else:
		$TitleMusic.play()
