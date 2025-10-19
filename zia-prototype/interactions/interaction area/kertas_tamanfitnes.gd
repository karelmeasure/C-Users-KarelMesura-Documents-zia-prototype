extends AnimatedSprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $"."
var journal_ui

func _ready():
	sprite.play("kertas_tamanfitnes")
	journal_ui = get_parent().get_node("JournalUI")
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	if journal_ui:
		journal_ui.show_journal("Sebagai orang yang memang rutin olahraga, tempat ini terasa seperti gimmick aja karena tidak benar-benar menyediakan fasilitas yang benar.\n\ntapi sekarang tempat ini punya kenangan yang berbeda, disini adalah tempat Jia bercerita soal banyak hal, soal ayahnya yang begitu strict atau ibunya yang eksploratif.\n\natau bagaimana dia bisa menirukan suara Stich yang konyol.\n\nmendengarnya bercerita terasa begitu tulus, aku tidak ingin momen ini berakhir.")
	
	
