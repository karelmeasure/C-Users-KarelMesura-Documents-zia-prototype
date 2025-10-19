extends Label

const POPUP_DURATION = 0.5    # Durasi tampilan penuh
const FADE_DURATION = 0.5     # Durasi fade out
const FADE_DELAY = 1.0
var current_tween: Tween = null

func _ready():
	modulate.a = 0.0
	hide()
	
func show_attack_hint():
	if current_tween and current_tween.is_valid() and current_tween.is_running():
		current_tween.kill()
	
	show()
	modulate.a = 1.0
	var tween = create_tween()
	
	tween.tween_interval(POPUP_DURATION)
	tween.tween_interval(FADE_DELAY)
	
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	tween.tween_callback(hide)
