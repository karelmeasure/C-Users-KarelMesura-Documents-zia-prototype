extends "res://Script/state/basemovementstate.gd"

func enter_state(_player):
	anim_idle = "idle"
	anim_walk = "walk"
	# panggil enter_state parent
	super.enter_state(_player)
