extends Node

@onready var game:Node2D = $"GameField/Game"
@onready var battlefield = game.battlefield
@onready var statement_manager:StatementManager = $StatementManager
@onready var entity_manager:EntityManager = $EntityManager
@onready var hand:Hand = $CardAreas.hand

func _ready() -> void:
	var enemy:Entity
	
	for i in range(4):
		enemy = entity_manager.get_entity_by_name("pink_slime")
		battlefield.add_entity(enemy,Vector2i(i,0))
	
	var fireball:Statement = statement_manager.get_statement_by_name("fireball")
	var columnC:Statement = statement_manager.get_statement_by_name("column_2")
	var every:Statement = statement_manager.get_statement_by_name("everywhere")
	var spell:Statement = statement_manager.get_statement_by_name("spell1")
	spell.set_substatement(fireball,0)
	spell.set_substatement(columnC,1)
	spell.execute(game)
	spell.clear_substatement(1)
	spell.set_substatement(every,1)
	spell.execute(game)
	
	##var TheWizard = Caster.constructor()
