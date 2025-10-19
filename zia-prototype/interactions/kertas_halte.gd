extends AnimatedSprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $"."
var journal_ui

func _ready():
	sprite.play("kertas_halte")
	journal_ui = get_parent().get_node("JournalUI")
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	if journal_ui:
		journal_ui.show_journal("Kalau aku disuruh memilih satu momen favorit bersama Jia sejauh ini, aku akan memilih momen kehujanan di halte bus.\n\nKetika kami menuju braga, tiba-tiba hujan deras sehingga aku menyuruhnya untuk turun duluan buat meneduh, sementara aku parkir motor.\n\nLalu ketika aku kembali, ternyata ia datang menghampiriku sembari membawa payung, saat itu di tengah hujan, kami berdua saling menatap satu sama lain.\n\nSepertinya disini lah momen aku jatuh hati.")
