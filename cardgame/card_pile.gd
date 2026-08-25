extends Node
class_name CardPile

@export var amount_cards_shown:bool = true

@onready var card_counter:Label = $CenterContainer/Label

var card_list:Array[Card]
var card_count:int

signal pile_left_clicked
signal pile_right_clicked

func _ready() -> void:
	if not amount_cards_shown:
		card_counter.hide()
	update_counter()

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
	if amount_cards_shown:
		card_counter.text = str(card_count)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pile_left_clicked.emit(self)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			pile_right_clicked.emit(self)
