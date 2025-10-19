extends "res://Script/state/basemovementstate.gd"

func enter_state(_player):
	anim_idle = "idle_pedang"
	anim_walk = "walk_pedang"
	# panggil enter_state parent
	super.enter_state(_player)
