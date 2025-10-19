extends CanvasLayer

signal name_submitted(text: String)
signal ui_cancelled 

var last_entered_name: String = "Unknown Traveler"
@onready var line_edit: LineEdit = $CenterContainer/LineEdit
@onready var enter_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/enter 
@onready var quit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/quit
@onready var zia = get_tree().get_first_node_in_group("Player")
@onready var focus_timer = $FocusTimer
@onready var camera: Camera2D = get_viewport().get_camera_2d() as GameCamera

const CORRECT_NAMES: Array[String] = ["JIA", "SHAZIA QUAMILA", "SHAZIA", "ZIA"]

func _ready():
	
	_focus_line_edit_safely()
	enter_button.pressed.connect(_on_confirm_pressed)
	line_edit.text_submitted.connect(_on_confirm_pressed)
	quit_button.pressed.connect(quit_ui)
	line_edit.grab_focus() 
	self.show() 
	self.visible = true
	
	set_process_unhandled_input(true)

func _focus_line_edit_safely():
	line_edit.text = "" 
	await get_tree().process_frame
	line_edit.grab_focus()

func _on_confirm_pressed():
	var entered_text = line_edit.text.strip_edges()
	var uppercase_text = entered_text.to_upper()
	
	if CORRECT_NAMES.has(uppercase_text):
		
		emit_signal("name_submitted", entered_text)
		
	else:
		if is_instance_valid(camera):
			camera.shake(4.0, 0.05, 1)
		print("Nama Salah! Coba lagi.")
		line_edit.clear()
		line_edit.grab_focus()

func quit_ui():
	emit_signal("ui_cancelled")
	print("UI Input Nama ditutup.")
	
func _unhandled_input(event):
	if event is InputEventAction:
		if event.is_action_just_pressed("cancel"):
			get_viewport().set_input_as_handled()
			quit_ui()
		elif event is InputEventKey:
			get_viewport().set_input_as_handled()
	
