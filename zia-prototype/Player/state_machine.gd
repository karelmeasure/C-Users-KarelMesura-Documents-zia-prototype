extends Node

@export var default_state_name: String = "Idle_pedang"
var current_state: Node = null

func _ready():
	switch_state(default_state_name)

func switch_state(state_name: String):
	if current_state != null:
		current_state.exit_state()
	current_state = get_node(state_name)
	current_state.enter_state(get_parent())  # kirim player node
