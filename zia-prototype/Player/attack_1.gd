extends "res://Script/state/basestate.gd"

var queued_attack = false

func enter_state():
	player.sprite.play("attack1")
	queued_attack = false
	player.sprite.animation_finished.connect(_on_attack_finished)

func exit_state():
	player.sprite.animation_finished.disconnect(_on_attack_finished)

func handle_input():
	if Input.is_action_just_pressed("attack"):
		queued_attack = true

func _on_attack_finished(anim_name):
	if anim_name != "attack1":
		return
	# lanjut ke Attack2 kalau player nge-spam F
	if queued_attack:
		player.get_node("StateMachine").switch_state("attack2")
	else:
		player.get_node("StateMachine").switch_state("Idle_pedang")
