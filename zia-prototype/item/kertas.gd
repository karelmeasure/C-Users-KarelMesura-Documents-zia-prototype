extends Sprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $"."
var journal_ui

func _ready():
	journal_ui = get_parent().get_node("JournalUI")
	interaction_area.interact = Callable(self, "_on_interact")



func _on_interact():
	if journal_ui:
		journal_ui.show_journal("Kalo kamu bisa membaca ini\n\nmaka berarti karel telah berhasil\nmembuat sistem jurnal gg gaming anjay")
	
	
