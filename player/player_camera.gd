extends Camera2D

@onready var player = GameMan.get_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position
