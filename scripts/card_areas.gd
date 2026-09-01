extends CanvasLayer

@onready var hand:Hand = $Hand
@onready var deck:CardPile = $DrawPile
@onready var discard:CardPile = $DiscardPile
@onready var used:CardPile = $UsedCards
@onready var spell_book:SpellBook = $SpellBook
@onready var drag_drop:Control = $DragAndDropHandle
@onready var reset_button:Button = $ResetSpellBookButton

@onready var statement_manager:StatementManager = $StatementManager

func _ready() -> void:
	hand.connect("mouse_entered",_on_hand_mouse_enter.bind(hand))
	hand.connect("mouse_exited",_on_hand_mouse_exit.bind(hand))
	var statement:Statement
	var new_card:Card
	for i in range(7):
		statement = statement_manager.get_statement_by_name("spell1")
		new_card = Card.from_statement(statement)
		deck.add_top_deck(new_card)
		
	for i in range(5):
		statement = statement_manager.get_statement_by_name("fireball")
		new_card = Card.from_statement(statement)
		deck.add_top_deck(new_card)
		
	for i in range(5):
		statement = statement_manager.get_statement_by_name("magic_dart")
		new_card = Card.from_statement(statement)
		deck.add_top_deck(new_card)
		
	for i in range(1):
		statement = statement_manager.get_statement_by_name("everything")
		new_card = Card.from_statement(statement)
		deck.add_top_deck(new_card)
		
	for i in range(3):
		statement = statement_manager.get_statement_by_name("and")
		new_card = Card.from_statement(statement)
		deck.add_top_deck(new_card)
	
	deck.shuffle()
	
	for i in range(5):
		var drawn_card = deck.draw()
		hand.add_card(drawn_card)
		
	self.set_root_spell()
	
func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed() and  drag_drop.dragged_card:
			var card = drag_drop.dragged_card
			drag_drop.dragged_card = null
			if card.card.ephemeral:
				card.queue_free()
			else:
				hand.add_card(card.card)
				hand.hover_card_stop()

func set_root_spell() -> void:
	var root = statement_manager.get_statement_by_name("root")
	spell_book.root = root
	root.connect("statement_receiver_clicked",_on_statement_receiver_clicked)
	spell_book.update_visuals()

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
	if drag_drop.dragged_card and not drag_drop.dragged_card.card.ephemeral:
		hovered_hand.hover_card_start()
	
func _on_hand_mouse_exit(hovered_hand:Hand) -> void:
	hovered_hand.hover_card_stop()

func end_turn_card_management() -> void:
	# discard remaining hand
	for card_ctrl in hand.get_children():
		hand.remove_card(card_ctrl)
		discard.add_top_deck(card_ctrl.card)
		card_ctrl.queue_free()
	
	# put card from used pile to discard
	while used.get_length():
		discard.add_top_deck(used.draw())
		
	# redraw to ... idk 7?
	for i in range(7):
		if deck.get_length() == 0:
			deck.card_list = discard.card_list
			discard.card_list = []
			deck.update_counter()
			discard.update_counter()
			deck.shuffle()
		
		var card:Card = deck.draw()
		hand.add_card(card)

func add_statement_to_spellbook(target:Statement,index:int, stat:Statement) -> void:
	spell_book.add_statement(target,index, stat)
	stat.connect("statement_receiver_clicked",_on_statement_receiver_clicked)

func _on_statement_receiver_clicked(parent_statement:Statement,clicked_container:StatementBlockReceiver) -> void:
	if not drag_drop.dragged_card:
		return
	
	if drag_drop.dragged_card.card.statement.type != ENUMS.ST_TYPES.CONJUNCTION and drag_drop.dragged_card.card.statement.type != clicked_container.type:
		print("Cannot put card of type " + str(drag_drop.dragged_card.card.statement.type) + " into slot of type " + str(clicked_container.type))
		return
	
	self.add_statement_to_spellbook(parent_statement,clicked_container.index,drag_drop.dragged_card.card.statement)
	if not drag_drop.dragged_card.card.ephemeral:
		used.add_top_deck(Card.from_statement(Statement.constructor(drag_drop.dragged_card.card.statement.data)))
	drag_drop.dragged_card = null
	
func get_root_spell() -> Statement:
	return spell_book.root
	
func reset_spell_blook() -> void:
	spell_book.clear()
	self.set_root_spell()

func _on_reset_spell_book_button_button_up() -> void:
	spell_book.clear()
	self.set_root_spell()
	while used.get_length():
		hand.add_card(used.draw())
		
func generate_ephemeral_position_card(pos_clicked:Vector2i) -> void:
	var statement_data:StatementData = statement_manager.get_statement_data_by_name("a_position")
	statement_data.title = format_coordinate(pos_clicked)
	statement_data.text = format_coordinate(pos_clicked)
	var statement_object := Statement.constructor(statement_data,{"position": pos_clicked})
	var card:Card = Card.from_statement(statement_object)
	card.ephemeral = true
	var card_ctrl:CardCtrl = CardCtrl.constructor(card)
	drag_drop.dragged_card = card_ctrl

func format_coordinate(coordinate:Vector2i) -> String:
	return char(coordinate.x + 65) + str(coordinate.y+1)
