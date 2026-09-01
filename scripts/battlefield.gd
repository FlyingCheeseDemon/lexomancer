extends Node2D

class_name Battlefield

@export var width:int = 5
@export var height:int = 5

@onready var battlefield_grid_node := $Battlefield
@onready var row_col_label_parent := $RowAndColLabels
var label_offset := Vector2(0,-10)
@onready var entities := $Entities
var battlefield_grid: Array[Array]

signal cell_clicked
signal player_attacked

func _ready() -> void:
	battlefield_grid = []
	for i:int in range(height):
		battlefield_grid.append([])
		for _j:int in range(width):
			battlefield_grid[i].append(null)
	for i in range(height):
		var lab = RowColLabel.constructor(str(i+1))
		lab.position = battlefield_grid_node.map_to_local(Vector2i(-1,i))+label_offset
		row_col_label_parent.add_child(lab)
	for i in range(width):
		var lab = RowColLabel.constructor(char(i+1+64))
		lab.position = battlefield_grid_node.map_to_local(Vector2i(i,-1))+label_offset
		row_col_label_parent.add_child(lab)

func add_entity(new_entity:Entity,coordinate:Vector2i) -> bool: # returns success
	if not coordinate_in_bounds(coordinate):
		return false
	if coordinate_occupied(coordinate):
		return false
	
	place_entity(new_entity,coordinate)
	entities.add_child(new_entity)
	return true

func place_entity(entity:Entity,coordinate:Vector2i):
	battlefield_grid[coordinate[0]][coordinate[1]] = entity
	entity.battle_position = coordinate
	entity.position = battlefield_grid_node.map_to_local(coordinate)

func coordinate_in_bounds(coordinate:Vector2i) -> bool:
	if battlefield_grid_node.get_cell_tile_data(coordinate) == null:
		return false
	return true

func coordinate_occupied(coordinate:Vector2i) -> bool:
	if battlefield_grid[coordinate[0]][coordinate[1]]:
		return true
	return false

func get_entity_from_position(coordinate:Vector2i) -> Entity:
	if not self.coordinate_in_bounds(coordinate):
		return null
	var entity = battlefield_grid[coordinate[0]][coordinate[1]]
	if not is_instance_valid(entity):
		battlefield_grid[coordinate[0]][coordinate[1]] = null
	return battlefield_grid[coordinate[0]][coordinate[1]]

func end_of_turn_enitity_management() -> void:
	# enemies act from bottom to top and from left to right
	# they first move and then attack
	# might make them smarter at some point
	var enemies: Array[Entity] = get_enemies_in_action_order()
	for enemy in enemies:
		if enemy.battle_position[1] != self.height-1:
			if not coordinate_occupied(enemy.battle_position + Vector2i(0,1)):
				var coordinate = enemy.battle_position
				battlefield_grid[coordinate[0]][coordinate[1]] = null
				self.place_entity(enemy,enemy.battle_position + Vector2i(0,1))
			else:
				# it's gonna depend tbd
				pass
		else:
			player_attacked.emit(enemy.data.attack_strength)

func get_enemies_in_action_order() -> Array[Entity]:
	var enemies:Array[Entity] = []
	for row_inx in range(self.height-1,-1,-1):
		for col_inx in range(self.width):
			var pos:Vector2i = Vector2i(col_inx,row_inx)
			var entity = self.get_entity_from_position(pos)
			if entity:
				enemies.append(entity)
	return enemies

func _on_battlefield_cell_clicked(event:InputEvent,pos_clicked:Vector2i) -> void:
	cell_clicked.emit(event,pos_clicked)
