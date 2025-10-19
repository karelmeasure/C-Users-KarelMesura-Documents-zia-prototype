extends Control

@onready var animation_player = $AnimationPlayer
@onready var duration_timer = $DurationTimer

func _ready():
	duration_timer.timeout.connect(_on_duration_timer_timeout)
	_start_notification_flow()
	
func _start_notification_flow():
	animation_player.play("show")
	await animation_player.animation_finished
	duration_timer.start()
	
func _on_duration_timer_timeout():
	animation_player.play("hide")
	await animation_player.animation_finished
	queue_free()
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hide":
		queue_free()
