extends Node

@onready var main_menu := $MainMenu
@onready var pause_menu := $PauseMenu
@onready var game_over_menu := $GameOver
@onready var game_container := $GameContainer

func _ready() -> void:
	pass

func _on_main_menu_game_start() -> void:
	var new_game := Game.constructor()
	game_container.add_child(new_game)
	new_game.connect("game_over",on_game_over)
	main_menu.hide()
	pause_menu.hide()
	game_over_menu.hide()

func on_game_over() -> void:
	for game in game_container.get_children():
		game.queue_free()
	pause_menu.hide()
	game_over_menu.show()

func close_game() -> void:
	get_tree().quit()

func _on_pause_menu_to_title() -> void:
	main_menu.show()
	pause_menu.hide()
	for game in game_container.get_children():
		game.queue_free()

func _on_pause_menu_resume() -> void:
	pause_menu.hide()

func _on_game_over_to_title_menu() -> void:
	main_menu.show()
	game_over_menu.hide()
	for game in game_container.get_children():
		game.queue_free()
