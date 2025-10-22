extends AnimatedSprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $"."
var journal_ui

func _ready():
	sprite.play("default")
	journal_ui = get_parent().get_node("JournalUI")
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	if journal_ui:
		journal_ui.show_journal("Ketika bersamanya, aku merasa nyaman untuk membuka diri, aku ingin dia mengenalku lebih jauh, kalau hatiku adalah sebuah bioskop, maka aku akan membiarkan dia masuk untuk menonton ceritaku tanpa perlu membeli tiket.\n\nTapi kenapa ya? meskipun aku baru mengenalnya sebentar, tapi menurutku dia spesial.\n\nAku jadi bertanya-tanya apakah dia juga akan melakukan hal yang sama untukku?")
