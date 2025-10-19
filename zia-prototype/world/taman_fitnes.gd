extends Node2D
@onready var glitchs = $glitchs

# Called when the node enters the scene tree for the first time.
func _ready():
	glitchs.play("default")
	
