extends CardPile

@onready var card_counter:Label = $MarginContainer/Label

func _ready() -> void:
	update_counter()
	
func update_counter() -> void:
	card_count = self.get_length()
	card_counter.text = str(card_count)
