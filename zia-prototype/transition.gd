extends CanvasLayer

@onready var black_screen = $BlackScreen

const FADE_TIME = 0.8 # Durasi satu kali fad

func change_scene(target_path: String):
	await fade_out()
	get_tree().call_deferred("change_scene_to_file", target_path)
	await get_tree().process_frame
	await fade_in()
	
func fade_out():
	black_screen.modulate.a = 0.0 # Mulai transparan
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 1.0, FADE_TIME)
	await tween.finished
	
func fade_in():
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	
func _ready():
	fade_in()
