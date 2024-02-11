extends TextureProgressBar

var current_boss : Enemy
# @onready var tween = get_tree().create_tween()

const DAMAGE_TWEEN_DURATION = 1.0

func _ready():
	self_modulate.a = 0

func set_value_to_boss_health():
	var tween = get_tree().create_tween()
	tween.bind_node(self)
	tween.stop()
	
	var initial_value = value
	var target_value = current_boss.health / current_boss.base_health
	var start_time = Time.get_unix_time_from_system()
	while true:
		var time_elapsed = Time.get_unix_time_from_system() - start_time
		
		var inp_value = tween.interpolate_value(initial_value, target_value - initial_value, time_elapsed, DAMAGE_TWEEN_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		value = inp_value
		await get_tree().process_frame
		if time_elapsed > DAMAGE_TWEEN_DURATION:
			break
	

func show_bosshealth(boss : Enemy):
	var t = get_tree().create_tween().set_trans(Tween.TRANS_QUART)
	t.tween_property(self, "self_modulate", Color.WHITE, 0.5)
	
	value = 0
	current_boss = boss
	current_boss.died.connect(hide_bosshealth)
	current_boss.damaged.connect(set_value_to_boss_health)
	
	await get_tree().create_timer(1).timeout
	
	set_value_to_boss_health()

func hide_bosshealth():
	
	var t = get_tree().create_tween().set_trans(Tween.TRANS_QUART)
	t.tween_property(self, "self_modulate", Color(0,0,0,0), 0.5)
	
	current_boss = null
