extends Sprite2D
class_name MapItem

var pos : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	var pos_room = position / 8.0
	pos = Vector2i(pos_room.floor())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_set_visible()

func try_set_visible():
	visible = GameMan.map_positions_unlocked.has(pos)
