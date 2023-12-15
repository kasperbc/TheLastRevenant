extends Pickup
class_name PickupExpansion

@export var expansion_id : int
@export var expansion_type : GameMan.ExpansionType
@export_multiline var expansion_text : String
var in_freeze = false

func _ready():
	if GameMan.has_collected_expansion(expansion_type, expansion_id):
		destroy_self()

func pick_up():
	GameMan.collect_expansion(expansion_type, expansion_id)
	GameMan.get_player_health().heal_full()
	
	GameMan.get_audioman().pause_music()
	GameMan.get_audioman().play_fx("expansion_collect", 0.0, 1.0)
	
	show_expansion_text()
	await get_tree().create_timer(0.5).timeout
	hide_expansion_text()
	GameMan.get_audioman().fade_unpause_music(2)

func show_expansion_text():
	in_freeze = true
	get_tree().paused = true
	get_tree().get_root().get_node("/root/Main/UI/Control/ExpansionText").text = expansion_text
	get_tree().get_root().get_node("/root/Main/UI/Control/ExpansionText").visible = true
	
func hide_expansion_text():
	if not in_freeze:
		return
	
	in_freeze = false
	get_tree().paused = false
	visible = false
	set_collision_mask_value(2, false)
	await get_tree().create_timer(3).timeout
	get_tree().get_root().get_node("/root/Main/UI/Control/ExpansionText").visible = false
	destroy_self()
