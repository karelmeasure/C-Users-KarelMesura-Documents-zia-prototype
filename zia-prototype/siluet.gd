extends Area2D

@onready var video_popup = $VideoPopup
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

var can_interact = false

func _ready():
	sprite.play("default")
	
	video_popup.popup_closed.connect(_on_video_popup_closed)
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		can_interact = true
		print("Player dapat berinteraksi dengan Siluet.")
		
func _on_body_exited(body):
	if body.is_in_group("Player"):
		can_interact = false
		print("Player keluar area dengan Siluet.")
		
func _input(event):
	if can_interact and event.is_action_pressed("Interact"):
		if not video_popup.visible:
			start_video_popup()
			get_viewport().set_input_as_handled()
			can_interact = false
			
func start_video_popup():
	video_popup.play_video()
	
func _on_video_popup_closed():
	can_interact = true
	pass
	
	
