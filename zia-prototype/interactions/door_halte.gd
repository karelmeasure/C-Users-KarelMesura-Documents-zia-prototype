extends Area2D

@onready var zia = get_tree().get_first_node_in_group("Player")
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var door_sprite: AnimatedSprite2D = $AnimatedSprite2D
const NEXT_SCENE_PATH = "res://world/TamanFitnes.tscn"
enum DoorState {CLOSED, ANIMATING, OPEN} # Tambahkan status ANIMATING
var current_state = DoorState.CLOSED
var can_interact = false

func _ready():
	door_sprite.play("door_closed")
	door_sprite.animation_finished.connect(_on_door_animation_finished)
	
	interaction_area.interact = Callable(self, "handle_door_interaction")
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

func _input(event):
	if can_interact and current_state != DoorState.ANIMATING and event.is_action_pressed("interact"):
		handle_door_interaction()

func handle_door_interaction():
	match current_state:
		DoorState.CLOSED:
			start_open_animation()
		DoorState.OPEN:
			go_through_door()
			
func start_open_animation():
	current_state = DoorState.ANIMATING # Kunci interaksi
	door_sprite.play("open_door")
	print("Pintu mulai terbuka...")
	
func _on_door_animation_finished():
	if door_sprite.animation == "open_door":
		door_sprite.play("door_opened") # Ganti ke sprite tetap terbuka
		current_state = DoorState.OPEN
		print("Pintu terbuka penuh. Tekan [F] lagi untuk masuk.")

func go_through_door():
	if current_state == DoorState.OPEN:
		print("Masuk melalui pintu. Transisi Scene...")
		Transitioner.change_scene(NEXT_SCENE_PATH)
		can_interact = false
	
func _on_body_entered(body):
	if body.name == "Player":
		can_interact = true
	
func _on_body_exited(body):
	if body.name == "Player":
		can_interact = false
	
