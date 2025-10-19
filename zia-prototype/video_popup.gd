extends CanvasLayer

@onready var video_player = $VideoStreamPlayer

signal popup_closed

func _ready():
	video_player.finished.connect(close_popup)
	visible = false
	
func play_video():
	visible = true
	video_player.play()
	video_player.set_paused(true)
	await get_tree().create_timer(0.1).timeout
	video_player.set_paused(false)
	set_process_input(true)
	
func _input(event):
	if visible and event.is_action_pressed("cancel"):
		close_popup()
		get_viewport().set_input_as_handled()
		
func close_popup():
	if video_player.is_playing():
		video_player.stop()
	visible = false
	set_process_input(false)
	popup_closed.emit()

	
