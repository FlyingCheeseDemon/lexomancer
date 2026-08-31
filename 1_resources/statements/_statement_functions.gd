class_name StatementFunctions

static func execute_root(gamestate:Game,self_statement:Statement) -> void:
	var modifying:Statement = self_statement.substatement_pointers[0]
	modifying.execute(gamestate)

static func execute_and(gamestate:Game,self_statement:Statement): # return value depends on situation
	var substatement_1:Statement = self_statement.substatement_pointers[0]
	var substatement_2:Statement = self_statement.substatement_pointers[1]
	
	assert(self_statement.type != 3) # conjuction type will always be overwritten on use
	# {MODIFYING, TARGET, EFFECT, CONJUNCTION, ENTITY}
	match self_statement.type:
		0: # modifying. these are full spells, just cast both
			substatement_1.execute(gamestate)
			substatement_2.execute(gamestate)
		1: # target. these are arrays of coordinates, concatenate them and return
			var vec1 = substatement_1.execute(gamestate)
			var vec2 = substatement_2.execute(gamestate)
			return vec1 + vec2
		2: # effect. these return callables. construct a new callable which does both
			# the arguments of the callables are the battlefield and the target positions
			var func1 = substatement_1.execute(gamestate)
			var func2 = substatement_2.execute(gamestate)
			
			var combined_function = func (battlefield,target_arrays):
				func1.call(battlefield,target_arrays)
				func2.call(battlefield,target_arrays)
			
			return combined_function
		4: 
			# not implemented
			pass

static func execute_spell1(gamestate:Game,self_statement:Statement) -> void:
	var effect:Statement = self_statement.substatement_pointers[0]
	var target:Statement = self_statement.substatement_pointers[1]
	
	var target_spaces:Array[Vector2i] = target.execute(gamestate)
	var effect_function:Callable = effect.execute(gamestate)
	
	for target_position:Vector2i in target_spaces:
		effect_function.call(gamestate.battlefield,target_position)

static func execute_spell2(gamestate:Game,self_statement:Statement) -> void:
	var effect:Statement = self_statement.substatement_pointers[0]
	var target:Statement = self_statement.substatement_pointers[1]
	
	var target_spaces:Array[Vector2i] = target.execute(gamestate)
	var effect_function:Callable = effect.execute(gamestate)
	
	for target_position:Vector2i in target_spaces:
		effect_function.call(gamestate.battlefield,target_position)
	for target_position:Vector2i in target_spaces:
		effect_function.call(gamestate.battlefield,target_position)

static func execute_fireball(_gamestate:Game,_self_statement:Statement) -> Callable:
	var fireball = func (battlefield:Battlefield,target:Vector2i):
		var entity:Entity = battlefield.get_entity_from_position(target)
		if entity:
			entity.change_health(-5)
	return fireball

static func execute_column_2(_gamestate:Game,_self_statement:Statement) -> Array[Vector2i]:
	var column_2:Array[Vector2i] = [
		Vector2i(2,0),
		Vector2i(2,1),
		Vector2i(2,2),
		Vector2i(2,3),
		Vector2i(2,4)
	]
	return column_2
	
static func execute_everything(gamestate:Game,_self_statement:Statement) -> Array[Vector2i]:
	var field:Battlefield = gamestate.battlefield
	var everywhere:Array[Vector2i] = []
	for i in range(field.width):
		for j in range(field.height):
			everywhere.append(Vector2i(i,j))
	return everywhere
