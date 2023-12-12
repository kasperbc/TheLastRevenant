extends MapItem

@export var expansion_type : GameMan.ExpansionType
@export var expansion_id : int
@export var collected_sprite : CompressedTexture2D

func _process(delta):
	super(delta)
	if GameMan.has_collected_expansion(expansion_type, expansion_id):
		texture = collected_sprite
