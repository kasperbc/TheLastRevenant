extends Control

signal on_play(name : String, track : AudioStream, texture : CompressedTexture2D)

@export var track_name : String
@export var track_author : String
@export var texture : CompressedTexture2D
@export var track : AudioStream

func _ready():
	$MusicName.text = track_name
	$MusicAuthor.text = track_author
	
	on_play.connect(get_parent().get_parent().get_parent().get_parent().get_node("CurrentMusic").on_play)

func _on_play_pressed():
	on_play.emit(track_name, track, texture)
