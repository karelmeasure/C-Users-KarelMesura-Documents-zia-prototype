extends Node
class_name BaseMovementState


var player = null
var anim_idle = ""
var anim_walk = ""

func enter_state(_player):
	player = _player
	if anim_idle != "":
		player.anim.play(anim_idle)

func exit_state():
	pass

func physics_process(_delta):
	# logika movement
	if player.direction.length() == 0:
		if anim_idle != "":
			player.anim.play(anim_idle)
	else:
		if anim_walk != "":
			player.anim.play(anim_walk)
