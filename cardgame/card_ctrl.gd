extends TextureRect

class_name CardCtrl

const scene = "res://cardgame/card_ctrl.tscn"

var card:Card

var hover_to_peak:bool = true
var hover_scaling:float = 1.4

signal card_drag_start
signal card_drag_stop

@onready var texture_container:TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var title_label:Label = $MarginContainer/VBoxContainer/Label
@onready var body_label:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel

@onready var alternate_texture_ephemeral:Texture2D = load("res://0_assets/textures/card_front_ephemeral.png")

static func constructor(card_to_load:Card) -> CardCtrl:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.card = card_to_load
	return obj

func _ready() -> void:
	if card.ephemeral:
		self.texture = self.alternate_texture_ephemeral
	var card_texture = card.image
	if card_texture: # and if not it remains the placeholder texture
		self.texture_container.texture = card_texture
	self.title_label.text = card.title
	self.body_label.text = card.description
	
func _on_mouse_entered() -> void:
	if hover_to_peak:
		self.scale = Vector2(hover_scaling,hover_scaling)
		self.z_index = 1

func _on_mouse_exited() -> void:
	self.scale = Vector2(1,1)
	self.z_index = 0
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			card_drag_start.emit(self)
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			card_drag_stop.emit(self)
