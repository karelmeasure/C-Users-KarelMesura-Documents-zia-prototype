extends Area2D
class_name SealedDoor

@onready var zia = get_tree().get_first_node_in_group("Player")
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var hitbox_area: Area2D = $hitbox
@onready var segel: AnimatedSprite2D = $segel
@onready var camera: Camera2D = get_viewport().get_camera_2d() as GameCamera
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager") 
@onready var hitflashanimantionplayer = $hitflashanimationplayer
@onready var animated_sprite = $AnimatedSprite2D

var is_sealed = true
var seal_health = 8
const HIT_FLASH_DURATION = 0.5 # Durasi efek putih
var interact = Callable(self, "_on_interact_door")
var action_name = "Periksa Pintu"
var is_flashing = false
const NEXT_SCENE_PATH = "res://world/HalteBus.tscn"
const SEALED_NOTIFICATION_SCENE = preload("res://ui/SealedNotification.tscn")

func _ready():
	animated_sprite.hide()
	interaction_area.interact = Callable(self, "_on_interact_door")
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)
	hitbox_area.area_entered.connect(_on_hitbox_area_entered)
	segel.play("segel") 

func take_hit():
	if not is_sealed:
		return
		
	seal_health -= 1
	if not is_flashing:
		hitflashanimantionplayer.play("hit_flash")
		animate_hit_effects()
		
#Partikel
	if is_instance_valid(camera):
		camera.shake(4.0, 0.05, 1)
		
	if seal_health <= 0:
		break_seal()
		
	

func animate_hit_effects():
	if is_flashing:
		return
		
	is_flashing = true
	
	var original_modulate = segel.modulate
	var flash_color = Color.WHITE
	
	segel.modulate = flash_color # Langsung buat putih
	
	await get_tree().create_timer(HIT_FLASH_DURATION).timeout
	
	if is_instance_valid(segel):
		segel.modulate = original_modulate
	is_flashing = false
	
func _on_interact_door():
	if is_sealed:
		var notification_instance = SEALED_NOTIFICATION_SCENE.instantiate()
		add_child(notification_instance) 
		notification_instance.position = Vector2(0, -18) 
		interaction_area.monitoring = false
		await get_tree().create_timer(2.0).timeout
		interaction_area.monitoring = true
		return 
		

		
	else:
		open_door()
		
func _on_hitbox_area_entered(area: Area2D):
	if area.is_in_group("SwordAttack") and is_sealed:
		if zia.has_darkmoon_greatsword: # Ganti dengan variabel/fungsi cek pedang yang sesuai
			take_hit()
		
			
			
func break_seal():
	if not is_sealed:
		return
	
	is_sealed = false
	
	if is_instance_valid(segel):
		segel.hide() # Hancurkan sprite segel
	animated_sprite.show()
	animated_sprite.play("segel_break")
	await get_tree().create_timer(1.5).timeout
	animated_sprite.play("pintu_open")
	action_name = "Masuk"
	
	_enable_door_interaction()
	print("Pintu terbuka, interaksi pindah scene aktif.")

func _enable_door_interaction():
	interaction_area.interact = Callable(self, "_go_to_next_scene") 

func _go_to_next_scene():
	print("Berpindah ke scene berikutnya...")
	Transitioner.change_scene(NEXT_SCENE_PATH)




func open_door():
	print("Pintu terbuka!")
	pass
	
func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		if interaction_manager:
			interaction_manager.register_area(self)
		 
		
		
func _on_interaction_area_body_exited(body):
	if body.is_in_group("Player"):
		if interaction_manager:
			interaction_manager.unregister_area(self)
	

			
