extends Node2D

func _ready() -> void:
	var TheWizard = Caster.constructor()
	
	var token1 = Token.constructor("1")
	var token2 = Token.constructor("2")
	var token3 = Token.constructor("3")
	var token4 = Token.constructor("4")
	var card
	
	TheWizard.lexicon.add_token(token1)
	token1.token_name = "3"
	TheWizard.lexicon.add_token(token1)
	
	TheWizard.draw_and_play()
	TheWizard.draw_and_play()
	TheWizard.draw_and_play()
	TheWizard.draw_and_play()
	TheWizard.draw_and_play()
	TheWizard.draw_and_play()
