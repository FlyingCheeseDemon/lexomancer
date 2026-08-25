extends CanvasLayer

@onready var hand:Hand = $Hand
@onready var deck:CardPile = $DrawPile
@onready var discard:CardPile = $DiscardPile
@onready var spell_book:SpellBook = $SpellBook
@onready var drag_drop:Control = $DragAndDropHandle

@onready var statement_manager:StatementManager = $StatementManager

func _ready() -> void:
	hand.connect("mouse_entered",_on_hand_mouse_enter.bind(hand))
	hand.connect("mouse_exited",_on_hand_mouse_exit.bind(hand))
	var fireball:Statement
	var new_card:Card
	for i in range(7):
		fireball = statement_manager.get_statement_by_name("spell1")
		new_card = Card.from_statement(fireball)
		deck.add_top_deck(new_card)
	
	for i in range(5):
		var drawn_card = deck.draw()
		hand.add_card(drawn_card)

	var root = statement_manager.get_statement_by_name("root")
	spell_book.add_statement(spell_book.statement_container,root)

func _on_hand_card_dragged_in_hand(card:CardCtrl,source_hand:Hand) -> void:
	if not drag_drop.dragged_card:
		source_hand.drag_card_out(card)
		drag_drop.dragged_card = card
	
func _on_dummy_clicked_in_hand(dummy:DummyCard,source_hand:Hand) -> void:
	assert(drag_drop.dragged_card,"Why is there a dummy card without a dragged card")
	var card:CardCtrl = drag_drop.dragged_card
	drag_drop.dragged_card = null
	source_hand.replace_dummy_with_card_ctrl(dummy,card)
	
func _on_hand_mouse_enter(hovered_hand:Hand) -> void:
	if drag_drop.dragged_card:
		hovered_hand.hover_card_start()
	
func _on_hand_mouse_exit(hovered_hand:Hand) -> void:
	hovered_hand.hover_card_stop()
	
func _end_turn_card_management() -> void:
	# discard remaining hand
	for card_ctrl in hand.get_children():
		hand.remove_card(card_ctrl)
		discard.add_top_deck(card_ctrl.card)
		card_ctrl.queue_free()
	
	for i in range(3):
		if deck.get_length() == 0:
			deck.card_list = discard.card_list
			discard.card_list = []
			deck.update_counter()
			discard.update_counter()
			deck.shuffle()
		
		var card:Card = deck.draw()
		hand.add_card(card)
	# redraw to ... idk 7?
