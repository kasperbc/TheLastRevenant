extends Camera2D

@onready var player = GameMan.get_player()

func _process(delta):
	position = player.position
