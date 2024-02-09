extends Station

@export var map_unlock_source_id : Array[int]

func on_station_activate():
	var map_sources_partial_unlocked = SaveMan.get_value("map_sources_partial_unlocked", [-1])
	map_sources_partial_unlocked.append_array(map_unlock_source_id)
	SaveMan.save_value("map_sources_partial_unlocked", map_sources_partial_unlocked)
	
	GameMan.get_audioman().play_fx("download", 0.0, 1.0)
	
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").text = "Map data downloaded"
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").visible = true
	
	await get_tree().create_timer(2).timeout
	
	get_tree().get_root().get_node("/root/Main/UI/Control/StationText").visible = false
