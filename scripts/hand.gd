extends HBoxContainer

class_name Hand

var max_hand_size = 5

func add_card(card:Card) -> bool:
	if self.get_child_count() < max_hand_size:
		self.add_child(card)
		return true
	else:
		return false
