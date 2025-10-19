extends Node2D
class_name Tugu
signal interaction_finished

@onready var zia = get_tree().get_first_node_in_group("Player")
@onready var interaction_area: InteractionArea = $InteractionArea 
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D # Node tunggal
@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager") 
@onready var attack_hint_node = $"../HintUI/AttackHint"

const NAME_INPUT_UI = preload("res://interactions/name_input_ui.tscn")

func _ready():
	interaction_area.interact = Callable(self, "_on_interact_tugu")
	 
func _cleanup_ui_and_enable_input(instance):
	if is_instance_valid(instance):
		instance.queue_free()
	zia.enable_input()
	emit_signal("interaction_finished")
	
func _on_interact_tugu():
	print("Tipe Node 'zia' di Tugu.gd: ", zia.get_class())
	print("Apakah 'zia' dalam grup Player? ", zia.is_in_group("Player"))
	
	const UI_SCENE: PackedScene = preload("res://interactions/name_input_ui.tscn")
	if zia.has_darkmoon_greatsword:
		interaction_area.action_name = "examine"
		return
	
	zia.disable_input()
	var name_input_instance: CanvasLayer = UI_SCENE.instantiate()
	
	name_input_instance.name_submitted.connect(_on_name_submitted.bind(name_input_instance))
	name_input_instance.ui_cancelled.connect(_on_ui_cancelled.bind(name_input_instance))
	
	get_tree().root.add_child(name_input_instance)
	
	await interaction_finished
	
func _on_name_submitted(_entered_name, ui_instance):
	print("Nama Terkonfirmasi. Memulai Transformasi.")
	zia.disable_input()
	interaction_area.monitoring = false
	if is_instance_valid(ui_instance):
		ui_instance.queue_free()
	emit_signal("interaction_finished")
	
	
	await transform_cutscene()
	zia.enable_input()
	interaction_area.monitoring = true
	
	interaction_area.action_name = "take sword"
	interaction_area.interact = Callable(self, "take_sword_from_tugu")
	
	animated_sprite.play("Tugu_pedang")
	print("Transformasi Selesai. Tugu siap untuk interaksi kedua.")
	
func _on_ui_cancelled(ui_instance):
	print("Interaksi dibatalkan (UI Quit).")
	_cleanup_ui_and_enable_input(ui_instance)
	
func transform_cutscene():
	animation_player.play("Tugu_Transformasi_Cutscene") 
	await get_tree().create_timer(4.5).timeout
	animated_sprite.play("Tugu_pedang")
	
func take_sword_from_tugu():
	zia.equip_darkmoon_greatsword()
	zia.has_darkmoon_greatsword = true
	
	if attack_hint_node and is_instance_valid(attack_hint_node):
		attack_hint_node.show_attack_hint()
		
	animated_sprite.play("Tugu_Empty")
	interaction_area.queue_free()
