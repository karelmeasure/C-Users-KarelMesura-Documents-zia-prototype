extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var chain_timer = $ChainTimer
@onready var hit_window_timer = $HitWindowTimer
@onready var AttackAnimator = $AttackAnimator
@onready var shadow = $Sprite2D

const SPEED = 100.0
const GRAVITY = 800
const JUMP_VELOCITY = -400
const HIT_WINDOW_DURATION = 0.5 # Hitbox aktif selama 0.1 detik (sesuaikan)
# Variabel Status
var has_darkmoon_greatsword = false 
var is_attacking = false
var attack_chain_index = 1 # 0 = Idle, 1, 2, atau 3
var can_take_attack_input = true
var has_buffered_input = false
var is_playing_attack = false
var input_enabled = true
const ATTACK_OFFSET_X = 20.0
const ATTACK_DELAY = 0.3
const MAX_CHAIN_INDEX = 3 # Pastikan ini disetel, sesuai jumlah attack (1, 2, 3)

const SWORD_ATTACK_SCENE = preload("res://SwordAttack.tscn")
var current_sword_attack_instance: Area2D = null 
# Variabel Timer untuk Chain Attack
const ATTACK_CHAIN_DURATION = 0.8 # Waktu maksimal antar tombol F ditekan
var chain_reset_timer: Timer


func _ready():
	
	hit_window_timer.timeout.connect(_on_hit_window_timer_timeout)

func _on_hit_window_timer_timeout():
	_remove_sword_attack()
	
func _physics_process(delta):
	if not input_enabled:
		velocity = Vector2.ZERO
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	if velocity.x > 0:
		animated_sprite.flip_h = false
		shadow.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
		shadow.flip_h = true
		
	var direction = Input.get_axis("move_left", "move_right")
	if is_attacking:
		direction = 0
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if not is_attacking:
		_update_movement_animation(direction)
	

func _update_movement_animation(direction):
	var base_anim = ""
	if has_darkmoon_greatsword:
		base_anim = "_" + "pedang" # Menghasilkan "_pedang"
	if direction != 0:
		animated_sprite.play("walk" + base_anim) # Contoh: "walk" atau "walk_pedang"
	else:
		animated_sprite.play("idle" + base_anim) # Contoh: "idle" atau "idle_pedang"
		
func _spawn_sword_attack():
	if is_instance_valid(current_sword_attack_instance):
		current_sword_attack_instance.queue_free()
	current_sword_attack_instance = SWORD_ATTACK_SCENE.instantiate()
	add_child(current_sword_attack_instance)
	
	var last_direction = Input.get_axis("move_left", "move_right")
	var base_offset_x = ATTACK_OFFSET_X # Nilai 1 piksel
	var base_offset_y = 0.0 # Nilai 0 piksel
	var final_offset_x = base_offset_x
	if animated_sprite.flip_h or last_direction < 0: # Jika Zia menghadap kiri
		final_offset_x *= -2 # Balik offset menjadi -1 (kiri)
	current_sword_attack_instance.position = Vector2(final_offset_x, base_offset_y)
	
	hit_window_timer.start(HIT_WINDOW_DURATION)
	
	
	

func _remove_sword_attack():
	if is_instance_valid(current_sword_attack_instance):
		current_sword_attack_instance.queue_free()
		current_sword_attack_instance = null
		

func _process(_delta):
	if not input_enabled:
		return
	
	if has_darkmoon_greatsword and Input.is_action_just_pressed("attack"):
		if is_attacking and not can_take_attack_input:
			has_buffered_input = true
		else:
			handle_attack_input()

func _on_chain_timer_timeout():
	reset_attack_state()
	if is_instance_valid(current_sword_attack_instance):
		_remove_sword_attack()

func handle_attack_input():
	if Input.is_action_just_pressed("attack"):
		if is_attacking and attack_chain_index < MAX_CHAIN_INDEX:
			attack_chain_index += 1
			_play_attack_animation()
		elif not is_attacking:
			is_attacking = true
			attack_chain_index = 1
			_play_attack_animation()
		

		
func start_attack_chain():
	is_attacking = true
	attack_chain_index = 1
	_play_attack_animation()
	
func continue_attack_chain():
	attack_chain_index += 1
	if attack_chain_index > 3:
		attack_chain_index = 1 # Melingkar 1, 2, 3, 1, 2...
	is_playing_attack = true
	
	_play_attack_animation()

func _spawn_hitbox_from_animation():
	_spawn_sword_attack()

func _remove_hitbox_from_animation():
	_remove_sword_attack()


func _play_attack_animation():
	var _callable_finished = Callable(self, "_on_attack_animation_finished")
	var anim_name = "attack" + str(attack_chain_index)
	var sync_anim_name = "sync_" + anim_name
	
	animated_sprite.play(anim_name)
	AttackAnimator.play(sync_anim_name)
	
	chain_timer.start(ATTACK_CHAIN_DURATION)
	
	

func _on_attack_animation_finished():
	is_playing_attack = false
	can_take_attack_input = true
	
	if has_buffered_input:
		has_buffered_input = false 
		continue_attack_chain()
	elif chain_timer.is_stopped():
		reset_attack_state()
	
func reset_attack_state():
	is_attacking = false
	attack_chain_index = 1
	can_take_attack_input = true
	is_playing_attack = false
	_update_movement_animation(Input.get_axis("move_left", "move_right"))
	
func equip_darkmoon_greatsword():
	has_darkmoon_greatsword = true
	animated_sprite.play("idle_pedang") 

func disable_input():
	input_enabled = false
	
func enable_input():
	input_enabled = true
