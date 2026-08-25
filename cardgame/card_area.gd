extends ColorRect

class_name CardArea

signal area_clicked

func card_placed_function(card_ctrl:CardCtrl) -> void:
	print(card_ctrl.card.title)
	card_ctrl.queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			area_clicked.emit(self)
