extends Control

signal on_play(name : String, track : AudioStream)

@export var track_name : String
@export var track_author : String
@export var track : AudioStream

func _ready():
	$MusicName.text = track_name
	$MusicAuthor.text = track_author

func _on_play_pressed():
	on_play.emit(track_name, track)
