extends Node

var player: Node = null

func enter_state():
	player = get_parent().get_parent()  # StateMachine parentnya Player
	pass

func exit_state():
	pass

func physics_process(_delta):
	pass

func handle_input():
	pass
