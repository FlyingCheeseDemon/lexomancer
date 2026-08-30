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
	
	
func _on_end_turn_button_button_up() -> void:
	var root_spell:Statement = card_manager.get_root_spell()
	if root_spell.check_executable_recursively():
		root_spell.execute(self)
	card_manager.reset_spell_blook()
	card_manager.end_turn_card_management()
	
