extends Node

@onready var game:Node2D = $"GameField/Game"
@onready var battlefield = game.battlefield
@onready var statement_manager:StatementManager = $StatementManager

func text_attac(target:Entity) -> void:
	target.change_health(-5)

func _ready() -> void:
	var enemy:Entity
	
	for i in range(4):
		enemy = Entity.constructor("pink_slime")
		battlefield.add_entity(enemy,Vector2i(i,0))
	
	var fireball:Statement = statement_manager.get_statement_by_name("fireball")
	var columnC:Statement = statement_manager.get_statement_by_name("column_2")
	var spell:Statement = statement_manager.get_statement_by_name("spell")
	spell.set_substatement(fireball,0)
	spell.set_substatement(columnC,1)
	spell.execute(game)
	spell.execute(game)
	#
	#battlefield.attack_column(0,text_attac)
	#battlefield.attack_column(1,text_attac)
	#battlefield.attack_column(1,text_attac)
	#battlefield.attack_column(2,text_attac)
	##var TheWizard = Caster.constructor()
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
