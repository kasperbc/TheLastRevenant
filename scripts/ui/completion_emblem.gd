extends TextureRect

enum CompletionRequirement {
	BEAT_GAME = 0,
	FULL_COMPLETION = 1,
	FAST_COMPLETION = 2
}

@export var requirement : CompletionRequirement

const FAST_COMPLETION_TRESHHOLD_MIN = 45

func _process(delta):
	var show = SaveMan.save.get_value("Meta", "game_beat", false)
	if requirement == CompletionRequirement.FULL_COMPLETION:
		show = SaveMan.save.get_value("Meta", "best_item_percentage", 0) == 1
	elif requirement == CompletionRequirement.FAST_COMPLETION:
		show = SaveMan.save.get_value("Meta", "best_time", 100000) <= FAST_COMPLETION_TRESHHOLD_MIN * 60
	
	visible = show
