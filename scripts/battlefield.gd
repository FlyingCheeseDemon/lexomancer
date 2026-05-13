extends Node2D

@export var width:int = 5
@export var height:int = 5

@onready var battlefield_grid_node := $Battlefield
@onready var entities := $Entities
var battlefield_grid: Array[Array]

func _ready() -> void:
	battlefield_grid = []
	for i:int in range(height):
		battlefield_grid.append([])
		for _j:int in range(width):
			battlefield_grid[i].append(null)

func add_entity(new_entity:Entity,position:Vector2i) -> bool: # returns success
	if battlefield_grid[position[0]][position[1]]:
		return false
	else:
		battlefield_grid[position[0]][position[1]] = new_entity
		new_entity.battle_position = position
		new_entity.position = battlefield_grid_node.map_to_local(position)
		entities.add_child(new_entity)
		return true
		
func attack_fields(positions:Array[Vector2i],attack_function:Callable) -> void:
	for position in positions:
		if battlefield_grid[position[0]][position[1]]:
			var entity:Entity = battlefield_grid[position[0]][position[1]]
			attack_function.call(entity)
	
func attack_column(index:int,attack_function:Callable) -> void:
	var positions: Array[Vector2i] = []
	for i:int in range(self.width):
		positions.append(Vector2i(index,i))
	attack_fields(positions,attack_function)
	
func attack_row(index:int,attack_function:Callable) -> void:
	var positions: Array[Vector2i] = []
	for i:int in range(self.height):
		positions.append(Vector2i(i,index))
	attack_fields(positions,attack_function)
