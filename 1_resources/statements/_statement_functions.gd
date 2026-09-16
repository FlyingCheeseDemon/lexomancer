class_name StatementFunctions

static func execute_root(gamestate:Game,self_statement:Statement) -> void:
	var modifying:Statement = self_statement.substatement_pointers[0]
	await modifying.execute(gamestate)

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
			var vec1 = await substatement_1.execute(gamestate)
			var vec2 = await substatement_2.execute(gamestate)
			return vec1 + vec2
		2: # effect. these return callables. construct a new callable which does both
			# the arguments of the callables are the battlefield and the target positions
			#var func1 = await substatement_1.execute(gamestate)
			#var func2 = await substatement_2.execute(gamestate)
			#
			##var combined_function = func (battlefield,target_arrays):
				##func1.call(battlefield,target_arrays)
				##func2.call(battlefield,target_arrays)
			#
			#return func1 + func2
			pass # handled through leaf effects
		4: 
			# not implemented
			pass

static func execute_spell1(gamestate:Game,self_statement:Statement) -> void:
	var effects:Array[Statement] = self_statement.substatement_pointers[0].get_leaf_effects()
	var target:Statement = self_statement.substatement_pointers[1]
	
	var target_spaces:Array[Vector2i] = await target.execute(gamestate)
	var effect_functions:Array[Callable] = []
	for effect in effects:
		effect_functions.append(await effect.execute(gamestate))
	
	
	for i in len(effects):
		var effect = effects[i]
		var effect_function = effect_functions[i]
		for target_position:Vector2i in target_spaces:
			gamestate.battlefield.play_effect_animation_at_position(effect,target_position)
			effect_function.call(gamestate.battlefield,target_position)
			await gamestate.get_tree().create_timer(1./len(target_spaces)/len(effects)).timeout

static func execute_spell2(gamestate:Game,self_statement:Statement) -> void:
	var effect:Statement = self_statement.substatement_pointers[0]
	var target:Statement = self_statement.substatement_pointers[1]
	
	var target_spaces:Array[Vector2i] = await target.execute(gamestate)
	var effect_function:Callable = await effect.execute(gamestate)
	
	for target_position:Vector2i in target_spaces:
		effect_function.call(gamestate.battlefield,target_position)
	for target_position:Vector2i in target_spaces:
		effect_function.call(gamestate.battlefield,target_position)

static func execute_fireball(_gamestate:Game,_self_statement:Statement) -> Callable:
	var fireball = func (battlefield:Battlefield,target:Vector2i):
		var entity:Entity = battlefield.get_entity_from_position(target)
		if entity:
			entity.change_health(-3)
		var splash:Array[Vector2i] = [
			target + Vector2i(1,0),
			target + Vector2i(-1,0),
			target + Vector2i(0,1),
			target + Vector2i(0,-1)
		]
		for t:Vector2i in splash:
			entity = battlefield.get_entity_from_position(t)
			if entity:
				entity.change_health(-2)
	return fireball

static func execute_magic_dart(_gamestate:Game,_self_statement:Statement) -> Callable:
	var magic_dart = func (battlefield:Battlefield,target:Vector2i):
		var entity:Entity = battlefield.get_entity_from_position(target)
		if entity:
			entity.change_health(-5)
	return magic_dart

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

static func generate_a_position(kwargs:Dictionary) -> Callable:
	var position:Vector2i = kwargs["position"]
	var execute_eph_a_position = func (_gamestate:Game,_self_statement:Statement):
		var output:Array[Vector2i] = [position]
		return output
	return execute_eph_a_position
