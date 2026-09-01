extends CanvasLayer

class_name Game

@onready var battlefield = $Battlefield
@onready var hand:Hand = $CardAreas.hand
@onready var statement_manager:StatementManager = $StatementManager
@onready var entity_manager:EntityManager = $EntityManager
@onready var card_manager:CanvasLayer = $CardAreas
@onready var player_health_label:Label = $PlayerHealthLabel
@onready var player:Player = $Player

func _ready() -> void:
	var enemy:Entity
	var positions = [
		Vector2i(0,0),
		Vector2i(4,0),
		Vector2i(1,1),
		Vector2i(3,1),
	]
	for position in positions:
		enemy = entity_manager.get_entity_by_name("pink_slime")
		battlefield.add_entity(enemy,position)
	update_player_health_label()
	
func _on_end_turn_button_button_up() -> void:
	var root_spell:Statement = card_manager.get_root_spell()
	if root_spell.check_executable_recursively():
		root_spell.execute(self)
	card_manager.reset_spell_blook()
	card_manager.end_turn_card_management()
	battlefield.end_of_turn_enitity_management()
	
func _on_battlefield_cell_clicked(event:InputEvent,pos_clicked:Vector2i) -> void:
	card_manager.generate_ephemeral_position_card(pos_clicked)

func update_player_health_label() -> void:
	var max_health:int = player.max_health
	var health:int = player.health
	player_health_label.text = str(health) + "/" + str(max_health)

func _on_player_health_changed() -> void:
	update_player_health_label()

func _on_player_i_died() -> void:
	pass # TODO: GAME OVER 

func _on_battlefield_player_attacked(attack_damage:int) -> void:
	player.reduce_health(attack_damage)
