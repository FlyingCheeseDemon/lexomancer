extends CanvasLayer

signal resume
signal to_title
signal quit

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.show()

func _on_close_button_button_up() -> void:
	quit.emit()

func _on_title_menu_button_button_up() -> void:
	to_title.emit()

func _on_resume_button_button_up() -> void:
	resume.emit()
