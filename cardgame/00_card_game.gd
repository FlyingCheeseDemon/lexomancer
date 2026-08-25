extends CanvasLayer

@onready var draw_pile = $CardPile
@onready var hand = $Hand
@onready var drag_drop = $DragAndDropHandle
@onready var card_placement_area = $CardArea

func _ready() -> void:
	# these are connected in the ready function instead of the signal tab purely for visibility
	# so that anyone making derivative versions of this script know which signals are to be connected here
	draw_pile.connect("pile_left_clicked",_on_pile_left_clicked)
	hand.connect("mouse_entered",_on_hand_mouse_enter.bind(hand))
	hand.connect("mouse_exited",_on_hand_mouse_exit.bind(hand))
	hand.connect("card_dragged_in_hand",_on_hand_card_dragged_in_hand)
	hand.connect("dummy_card_clicked_in_hand",_on_dummy_clicked_in_hand)
	card_placement_area.connect("area_clicked",_on_area_clicked)
	
	
	var descriptions = ["This is a card","This is also a card","This is even another card"]
	
	var card
	for i in range(10):
		card = Card.new()
		card.title = "Card" + str(i)
		card.description = descriptions[i%3]
		draw_pile.add_top_deck(card)
	
	draw_pile.shuffle()

func _on_pile_left_clicked(clicked_pile:CardPile) -> void:
	if clicked_pile.card_count > 0 and not hand.full:
		hand.add_card(clicked_pile.draw())

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

func _on_area_clicked(clicked_area:CardArea) -> void:
	if drag_drop.dragged_card:
		var card:CardCtrl = drag_drop.dragged_card
		drag_drop.dragged_card = null
		clicked_area.card_placed_function(card)
		
