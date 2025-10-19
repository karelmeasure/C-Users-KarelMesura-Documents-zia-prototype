extends Node2D

@onready var kertas = $KertasHalte
func _ready():
	kertas.play("kertas_halte")
