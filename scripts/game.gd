extends CanvasLayer

class_name Game

@onready var battlefield = $Battlefield
@onready var hand:Hand = $CardAreas.hand
@onready var statement_manager:StatementManager = $StatementManager
@onready var entity_manager:EntityManager = $EntityManager
@onready var card_manager:CanvasLayer = $CardAreas
@onready var player_health_label:Label = $PlayerHealthLabel
@onready var player:Player = $Player
@onready var round_turn_label:Label = $RoundTurnLabel

const scene = "res://scenes/game.tscn"

var round_number:int = 0
var turn_number:int = 0
var remaining_enemies:Array[String] = []
var spawn_rate = 3

signal game_over

static func constructor() -> Game:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	return obj

func _ready() -> void:
	start_round()
	update_player_health_label()

func start_turn() -> void:
	turn_number += 1
	_update_round_turn_label()
	if len(remaining_enemies) != 0:
		var enemies_to_spawn:int = min(spawn_rate,len(remaining_enemies))
		var columns_to_spawn:Array[int] = [0,1,2,3,4]
		columns_to_spawn.shuffle()
		for i in range(enemies_to_spawn):
			var position = Vector2i(columns_to_spawn[i],0)
			var enemy_name = remaining_enemies.pop_front()
			var enemy = entity_manager.get_entity_by_name(enemy_name)
			battlefield.add_entity(enemy,position)
	card_manager.start_turn_card_management()

func end_turn() -> void:
	var root_spell:Statement = card_manager.get_root_spell()
	if root_spell.check_executable_recursively():
		root_spell.execute(self)
	
	card_manager.reset_spell_blook()
	card_manager.end_turn_card_management()
	#why do dead entities still bite me?? also the round doesn't end until one turn too late
	battlefield.end_of_turn_enitity_management()
	if battlefield.is_empty():
		end_round()
	else:
		start_turn()

func start_round() -> void:
	round_number += 1
	turn_number = 0
	_update_round_turn_label()
	var budget:int = generate_round_budget()
	remaining_enemies = generate_enemy_set(budget)
	start_turn()

func end_round() -> void:
	_reset_board()
	
	# award cards here, any events
	start_round() # for now

func _reset_board() -> void:
	battlefield.clear_field()
	card_manager.reset_deck()
	card_manager.reset_spell_blook()

func generate_round_budget() -> int:
	return 1
	return floor(0.2*round_number*round_number + 0.5*round_number+4)

func generate_enemy_set(budget:int) -> Array[String]:
	var enemy_name_list:Array = entity_manager.get_sorted_entity_name_list_descending_danger_value()
	var enemy_to_generate_list:Array[String] = []
	var index = 0
	while budget > 0:
		if budget >= entity_manager.get_enemies_danger_value_by_name(enemy_name_list[index]):
			enemy_to_generate_list.append(enemy_name_list[index])
			budget -= entity_manager.get_enemies_danger_value_by_name(enemy_name_list[index])
		else:
			index += 1
	enemy_to_generate_list.reverse() # the easy enemies come first
	return enemy_to_generate_list

func _on_end_turn_button_button_up() -> void:
	end_turn()
	
func _on_battlefield_cell_clicked(event:InputEvent,pos_clicked:Vector2i) -> void:
	card_manager.generate_ephemeral_position_card(pos_clicked)

func update_player_health_label() -> void:
	var max_health:int = player.max_health
	var health:int = player.health
	player_health_label.text = str(health) + "/" + str(max_health)

func _on_player_health_changed() -> void:
	update_player_health_label()

func _on_player_i_died() -> void:
	game_over.emit()

func _on_battlefield_player_attacked(attack_damage:int) -> void:
	player.reduce_health(attack_damage)

func _update_round_turn_label() -> void:
	var text:String = "Round: " + str(round_number) + "\nTurn: " + str(turn_number)
	round_turn_label.text = text
