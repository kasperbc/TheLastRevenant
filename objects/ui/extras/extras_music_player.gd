extends Control

@export var default_texture : CompressedTexture2D
var playing = false

func on_play(track_name, track, texture):
	get_tree().root.get_node("TitleScreen/SecretSong/TitleMusic").stop()
	
	$TrackName.text = track_name
	$MusicCircle.texture = texture
	$AudioStreamPlayer2D.stream = track
	$AudioStreamPlayer2D.play()
	playing = true

func on_stop():
	$TrackName.text = ""
	$AudioStreamPlayer2D.stop()
	$MusicCircle.rotation = 0
	$MusicCircle.texture = default_texture
	playing = false

func _process(delta):
	if playing:
		$MusicCircle.rotation += delta
