extends Node
class_name AudioManager

@export var num_sfx_players := 5 #more players means more sounds can play at once
@export var fading_music_starting_db = -20.0 # what db the song starts at when fading into it
@export var music : Array[Resource]
@export var effects : Array[Resource]

@onready var effects_container = $Effects
@onready var audio_stream_player = $Music/AudioStreamPlayer
@onready var audio_stream_player_2 = $Music/AudioStreamPlayer2

var paused_position : float = 0.0 #the position music has been paused at
var current_song : String = ""
var current_volume : float

var fading_music : bool = false
var fade_time : float = 0.0
var current_fade_time : float = 0.0
var current_as2_vol_offset : float = 0.0
var current_as1_vol_offset : float = 0.0

func _ready() -> void:
	for i in num_sfx_players:
		var stream = AudioStreamPlayer.new()
		stream.bus = "SFX"
		effects_container.add_child(stream)

func _process(delta):
	if fading_music:
		_fade_music(delta)
	
	var music_vol = GameMan.get_user_setting("music_volume")
	var sound_vol = GameMan.get_user_setting("sound_volume")
	if not music_vol == null:
		AudioServer.set_bus_volume_db(2, linear_to_db(GameMan.get_user_setting("music_volume")))
		AudioServer.set_bus_mute(2, music_vol == 0)
	if not sound_vol == null:
		AudioServer.set_bus_volume_db(1, linear_to_db(GameMan.get_user_setting("sound_volume")))
		AudioServer.set_bus_mute(1, sound_vol == 0)

func play_fx(play_sfx_name : String, volume = 0.0, pitch = 1.0) -> void:
	var sound = _get_sound(play_sfx_name, false)
	if not sound: 
		print("Sound %s not found!" % play_sfx_name)
		return
	
	var player = effects_container.get_child(0)
	player.stream = sound
	player.volume_db = volume
	player.pitch_scale = pitch
	player.play()
	effects_container.move_child(player, num_sfx_players - 1)

func play_music(play_song_name : String, volume = 0.0) -> void:
	var song = _get_sound(play_song_name, true)
	if not song: return
	
	if audio_stream_player.stream != song or paused_position > 0.0 or !audio_stream_player.playing:
		audio_stream_player.stream = song
		audio_stream_player.play(paused_position)
		audio_stream_player.volume_db = volume
		current_volume = volume
		current_song = play_song_name
		paused_position = 0.0

func stop_music() -> void:
	paused_position = 0.0
	audio_stream_player.stop()
	audio_stream_player_2.stop()
	current_song = ""
	fading_music = false

func pause_music() -> void:
	paused_position = audio_stream_player.get_playback_position()
	audio_stream_player.stop()

func fade_unpause_music(duration : float) -> void:
	audio_stream_player.play(paused_position)
	audio_stream_player.volume_db = fading_music_starting_db
	var tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", current_volume, duration)

func fade_to_music(song_name, time, volume = 0.0) -> void:
	var song = _get_sound(song_name, true)
	if not song: return
	
	audio_stream_player_2.stream = song
	audio_stream_player_2.volume_db = fading_music_starting_db
	audio_stream_player_2.play()
	current_as2_vol_offset = volume
	current_as1_vol_offset = audio_stream_player.volume_db
	
	current_song = song_name
	
	fade_time = time
	fading_music = true
	current_fade_time = 0.0

func _fade_music(delta):
	current_fade_time += delta
	var time_10 = 1 - (current_fade_time / fade_time)
	var time_01 = current_fade_time / fade_time
	
	audio_stream_player_2.volume_db = time_10 * fading_music_starting_db + current_as2_vol_offset
	audio_stream_player.volume_db = time_01 * fading_music_starting_db + current_volume

	if time_10 <= 0:
		fading_music = false
		audio_stream_player.stop()
		audio_stream_player.stream = audio_stream_player_2.stream
		audio_stream_player.volume_db = current_as2_vol_offset
		current_volume = audio_stream_player.volume_db
		audio_stream_player.play(audio_stream_player_2.get_playback_position())
		audio_stream_player_2.stop()

func _get_sound(sound_name, is_music : bool) -> Resource:
	var result = null
	
	var array = music if is_music else effects
	
	for i in array.size():
		var sound = array[i]
		if sound:
			if sound.resource_path.get_file().get_basename() == sound_name:
				result = sound
	
	return result
