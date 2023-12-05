extends ColorRect

enum FadeMode {
	FADE_TO_TRANSPARENT = 0,
	FADE_TO_BLACK = 1
}
var current_fade_mode : FadeMode
var fade_time : float
var time_fade_started : float
var fading = false

func _ready():
	visible = true
	fade_to_transparent(1, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not fading:
		return
	
	var curr_time = Time.get_unix_time_from_system()
	var value = (curr_time - time_fade_started) / fade_time
	
	var alpha = value
	if current_fade_mode == FadeMode.FADE_TO_TRANSPARENT:
		alpha = 1 - alpha
	
	modulate = Color(0,0,0,alpha)
	
	if value >= 1:
		fading = false

func fade_to_black(time : float, extra_time = 0.0):
	current_fade_mode = FadeMode.FADE_TO_BLACK
	fade_time = time
	time_fade_started = Time.get_unix_time_from_system() + extra_time
	fading = true

func fade_to_transparent(time : float, extra_time = 0.0):
	current_fade_mode = FadeMode.FADE_TO_TRANSPARENT
	fade_time = time
	time_fade_started = Time.get_unix_time_from_system() + extra_time
	fading = true
