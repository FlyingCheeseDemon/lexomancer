extends Control

var dragged_card: CardCtrl = null:
	set = set_dragged_card
	
func set_dragged_card(card: CardCtrl) -> void:
	dragged_card = card
	if not dragged_card:
		for child in self.get_children():
			self.remove_child(child)
	else:
		self.add_child(dragged_card)
		dragged_card.rotation = 0
		dragged_card.position = dragged_card.size/-2
		dragged_card.hover_to_peak = false
		dragged_card.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta: float) -> void:
	if not dragged_card:
		return
	self.position = round(get_global_mouse_position())
