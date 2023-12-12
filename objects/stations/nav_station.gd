extends Station

@export var map_unlock_source_id : Array[int]

func on_station_activate():
	GameMan.map_sources_partial_unlocked.append_array(map_unlock_source_id)
