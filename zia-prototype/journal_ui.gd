extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label
@onready var exit = $Panel/exit

var base_position: Vector2
const DEFAULT_OFFSET_Y := 50.0
const DEFAULT_SHOW_DURATION := 0.35
const DEFAULT_HIDE_DURATION := 0.20

func _ready():
	base_position = panel.position
	panel.modulate.a = 0.0
	exit.modulate.a = 0.0
	panel.position = base_position
	hide()
	
func show_journal(text: String, offset_y: float = DEFAULT_OFFSET_Y, duration: float = DEFAULT_SHOW_DURATION) -> void:
	label.text = text
	panel.modulate.a = 0.0
	exit.modulate.a = 0.0
	panel.position = base_position + Vector2(0, offset_y)
	show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel, "position", base_position, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(exit, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	

	

func hide_journal(offset_y: float = DEFAULT_OFFSET_Y, duration: float = DEFAULT_HIDE_DURATION) -> void:
	# tween balik: fade out + geser turun sedikit
	var tween = get_tree().create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(panel, "position", base_position + Vector2(0, offset_y), duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(exit, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished

	# reset posisi & sembunyikan
	panel.position = base_position
	hide()
	


func _input(event):
	if visible and event.is_action_pressed("cancel"):
		hide_journal()
