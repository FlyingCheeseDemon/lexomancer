extends ColorRect

class_name DummyCard

const scene = "res://cardgame/dummy_card.tscn"

signal dummy_clicked

static func constructor() -> DummyCard:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	return obj

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dummy_clicked.emit(self)
