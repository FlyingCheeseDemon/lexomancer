extends CanvasLayer

@onready var hand:Hand = $Hand
@onready var deck:CardPile = $Deck
@onready var discard:CardPile = $Discard

@onready var statement_manager:StatementManager = $StatementManager

func _ready() -> void:
	var fireball:Statement
	var new_card:Card
	for i in range(7):
		fireball = statement_manager.get_statement_by_name("spell1")
		new_card = Card.constructor(fireball)
		deck.add_top_deck(new_card)
	
	for i in range(5):
		var drawn_card = deck.draw()
		hand.add_card(drawn_card)
