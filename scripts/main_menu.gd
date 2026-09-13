extends CanvasLayer

@onready var start_button := $TextureRect/CenterContainer/VBoxContainer/StartButton
@onready var close_button := $TextureRect/CenterContainer/VBoxContainer/Close

signal game_start
signal game_close

func _on_start_button_button_up() -> void:
	game_start.emit()

func _on_close_button_button_up() -> void:
	game_close.emit()
