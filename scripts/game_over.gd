extends CanvasLayer

signal quit_game
signal to_title_menu

func _on_title_menu_button_button_up() -> void:
	to_title_menu.emit()


func _on_quit_button_button_up() -> void:
	quit_game.emit()
