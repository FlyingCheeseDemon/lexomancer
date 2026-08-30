extends Container

class_name StatementBlockReceiver

@onready var background = $ColorRect
const scene = "res://scenes/statement_block_receiver.tscn"

var type:ENUMS.ST_TYPES
var index:int # the index within the statement

signal receiver_clicked

static func constructor(desired_type:ENUMS.ST_TYPES) -> StatementBlockReceiver:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.type = desired_type
	return obj

func _ready() -> void:
	self.custom_minimum_size = Vector2(40,40)
	background.color = COLORS.ST_COLORS[type]
	self.connect("gui_input",_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			receiver_clicked.emit(self)
