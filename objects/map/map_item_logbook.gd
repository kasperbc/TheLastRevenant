extends MapItem

@export var logbook_res : LogbookRes
@export var collected_sprite : CompressedTexture2D

func _process(delta):
	super(delta)
	if GameMan.has_logbook(logbook_res):
		texture = collected_sprite
