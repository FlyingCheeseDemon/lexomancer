extends Node
class_name CardPile

var card_list:Array[Card]
var card_count:int

func add_bottom_deck(card: Card):
	card_list.push_front(card)
	update_counter()
	
func add_top_deck(card: Card):
	card_list.push_back(card)
	update_counter()
	
func get_length() -> int:
	return card_list.size()

func shuffle() -> void:
	self.card_list.shuffle()

func draw() -> Card:
	var card_to_draw:Card = self.card_list.pop_back()
	update_counter()
	return card_to_draw

func update_counter() -> void:
	card_count = self.get_length()
