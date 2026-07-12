extends CenterContainer

class_name Card

const scene = "res://scenes/card.tscn"

var statement_node:Statement

@onready var texture_container:TextureRect = $Card/MarginContainer/VBoxContainer/TextureRect
@onready var title_label:Label = $Card/MarginContainer/VBoxContainer/Label
@onready var body_label:Label = $Card/MarginContainer/VBoxContainer/RichTextLabel

static func constructor(statement:Statement) -> Card:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.statement_node = statement
	return obj

func _ready() -> void:
	var texture = statement_node.data.artwork
	if texture: # and if not it remains the placeholder texture
		self.texture_container.texture = texture
	self.title_label.text = self.statement_node.data.title
	self.body_label.text = self.statement_node.data.text
