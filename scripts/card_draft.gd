extends CanvasLayer

class_name CardDraft

const scene = "res://scenes/card_draft.tscn"

@onready var card_container := $CenterContainer/ColorRect/CenterContainer/HBoxContainer

signal card_selected

static func constructor() -> CardDraft:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	return obj
	
func add_card(card:Card) -> void:
	var card_ctrl = CardCtrl.constructor(card)
	self.card_container.add_child(card_ctrl)
	card_ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	card_ctrl.connect("card_drag_start",_on_card_clicked)
	
func _on_card_clicked(card:CardCtrl) -> void:
	card_selected.emit(card.card)
	self.queue_free()
