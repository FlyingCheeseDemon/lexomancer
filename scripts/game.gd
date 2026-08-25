extends CanvasLayer

class_name Game

@onready var battlefield = $Battlefield
@onready var hand:Hand = $CardAreas.hand
@onready var statement_manager:StatementManager = $StatementManager
@onready var entity_manager:EntityManager = $EntityManager
@onready var card_manager:CanvasLayer = $CardAreas

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
	spell.execute(self)
	spell.clear_substatement(1)
	spell.set_substatement(every,1)
	spell.execute(self)
	
func _on_end_turn_button_button_up() -> void:
	card_manager._end_turn_card_management()
	
