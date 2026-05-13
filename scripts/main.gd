extends Node

@onready var battlefield = $"GameField/Battlefield"

func text_attac(target:Entity) -> void:
	target.change_health(-5)

func _ready() -> void:
	var pink_slime = Entity.constructor("pink_slime")
	battlefield.add_entity(pink_slime,Vector2i(1,0))
	pink_slime = Entity.constructor("pink_slime")
	battlefield.add_entity(pink_slime,Vector2i(2,0))
	pink_slime = Entity.constructor("pink_slime")
	battlefield.add_entity(pink_slime,Vector2i(3,0))
	
	battlefield.attack_column(0,text_attac)
	battlefield.attack_column(1,text_attac)
	battlefield.attack_column(1,text_attac)
	battlefield.attack_column(2,text_attac)
	#var TheWizard = Caster.constructor()
	#
	#var token1 = Token.constructor("1")
	#var token2 = Token.constructor("2")
	#var token3 = Token.constructor("3")
	#var token4 = Token.constructor("4")
	#var card
	#
	#TheWizard.add_card_top_deck(token1)
	#token1.token_name = "3"
	#TheWizard.add_card_top_deck(token1)
	#
	#TheWizard.draw(5)
	#print(TheWizard.hand)
