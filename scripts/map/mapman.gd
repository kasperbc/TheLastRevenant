extends Control
class_name MapManager

const MINIMAP_MAPSCREEN_OFFSET : Vector2i = Vector2i(3, 2)
const MINIMAP_MAPSCREEN_OFFSET_PAUSED : Vector2i = Vector2i(12, 12)

const MAPMASK_PAUSED_SIZE = Vector2(1200,580)
const MAPMASK_PAUSED_POSITION = Vector2(32,16)
const MAPMASK_UNPAUSED_SIZE = Vector2(210,150)
const MAPMASK_UNPAUSED_POSITION = Vector2(1030,32)

@export var debug : bool = false

func _ready():
	generate_tilemap()
	get_map_scr_ref().self_modulate.a = 0

func generate_tilemap():
	var scr_ref : TileMap = get_map_scr_ref()
	var scr : TileMap = get_map_scr()
	
	for cell in GameMan.map_positions_unlocked:
		var sid = scr_ref.get_cell_source_id(0, cell)
		var atl = scr_ref.get_cell_atlas_coords(0, cell)
		scr.set_cell(0, cell, sid, atl, 0)

func _process(_delta):
	var player_pos = get_player_pos()
	
	try_unlock_map_pos(player_pos)
	
	move_mapscreen_to_player_pos()
	update_partially_unlocked_tiles()
	
	if debug:
		$DebugPos.text = str(player_pos)
	
	if GameMan.game_paused:
		size = MAPMASK_PAUSED_SIZE
		position = MAPMASK_PAUSED_POSITION
		self_modulate.a = 1
	else:
		size = MAPMASK_UNPAUSED_SIZE
		position = MAPMASK_UNPAUSED_POSITION
		self_modulate.a = 0.8

func try_unlock_map_pos(pos : Vector2i):
	if GameMan.map_positions_unlocked.has(pos):
		return
	
	GameMan.map_positions_unlocked.append(pos)
	reveal_tile(pos)

func update_partially_unlocked_tiles():
	for s_id in GameMan.map_sources_partial_unlocked:
		for cell in get_map_scr_ref().get_used_cells(0):
			if not get_map_scr_ref().get_cell_source_id(0, cell) == s_id:
				continue
			var ac = get_map_scr_ref().get_cell_atlas_coords(0, cell)
			get_map_scr_part().set_cell(0, cell, s_id, ac)

func move_mapscreen_to_player_pos():
	var target_pos = -get_player_pos() + MINIMAP_MAPSCREEN_OFFSET
	if GameMan.game_paused:
		target_pos = MINIMAP_MAPSCREEN_OFFSET_PAUSED
	
	get_map_scr_ref().position = target_pos * 30.0
	$MapScreen/PlayerPos.position = get_player_pos() * 8.0 + Vector2(4,4)

func get_player_pos() -> Vector2i:
	var player_pos_units = GameMan.get_player().global_position / 8
	var player_pos_rooms = player_pos_units / 48
	var player_pos_v2i = Vector2i(floor(player_pos_rooms))
	return player_pos_v2i

func reveal_tile(pos):
	var source_id = get_map_scr_ref().get_cell_source_id(0, pos)
	var atlas_coords = get_map_scr_ref().get_cell_atlas_coords(0, pos)
	
	get_map_scr().set_cell(0, pos, source_id, atlas_coords)

func get_map_scr_ref() -> TileMap:
	return $MapScreen

func get_map_scr() -> TileMap:
	return $MapScreen/MapScreenShown

func get_map_scr_part() -> TileMap:
	return $MapScreen/MapScreenPartialShown
