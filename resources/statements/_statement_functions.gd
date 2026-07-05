class_name StatementFunctions

static func execute_fireball(_gamestate:Game,self_statement:Statement) -> Callable:
	return fireball
	
static func fireball(battlefield:Battlefield,target:Vector2i) -> void:
	var entity:Entity = battlefield.get_entity_from_position(target)
	if entity:
		entity.change_health(-5)

static func execute_spell(gamestate:Game,self_statement:Statement) -> void:
	var effect:Statement = self_statement.substatement_pointers[0]
	var target:Statement = self_statement.substatement_pointers[1]
	
	var target_spaces:Array[Vector2i] = target.execute(gamestate)
	var effect_function:Callable = effect.execute(gamestate)
	
	for target_position:Vector2i in target_spaces:
		effect_function.call(gamestate.battlefield,target_position)
	
static func execute_column_2(_gamestate:Game,_self_statement:Statement) -> Array[Vector2i]:
	var column_2:Array[Vector2i] = [
		Vector2i(2,0),
		Vector2i(2,1),
		Vector2i(2,2),
		Vector2i(2,3),
		Vector2i(2,4)
	]
	return column_2
	
static func execute_everywhere(gamestate:Game,_self_statement:Statement) -> Array[Vector2i]:
	var field:Battlefield = gamestate.battlefield
	var everywhere:Array[Vector2i] = []
	for i in range(field.width):
		for j in range(field.height):
			everywhere.append(Vector2i(i,j))
	return everywhere
