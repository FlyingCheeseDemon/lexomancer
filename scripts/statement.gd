extends Node

class_name Statement

const self_scene = preload("res://scenes/statement.tscn")

var parent:Statement = null
var parent_index:int = -1

var data:StatementData
var type:ENUMS.ST_TYPES
var execute_fnc:Callable

var substatement_pointers:Array[Statement] = []
var substatement_types:Array[ENUMS.ST_TYPES] = []

func set_substatement(statement:Statement,position:int) -> void:
	assert(not self.substatement_pointers[position],\
		"STATEMENT ERROR: Statement " + str(position) + " in " + self.data.title + " already set.")
	assert(statement.type == self.substatement_types[position],\
		"STATEMENT TYPE ERROR: statement " + str(position) + " in " + self.data.title + " needs to be of type " +\
		ENUMS.ST_TYPES.keys()[self.substatement_types[position]] + " and not " \
		+ ENUMS.ST_TYPES.keys()[statement.type])
		
	self.substatement_pointers[position] = statement

func clear_substatement(position:int) -> Statement:
	if not self.substatement_pointers[position]:
		return null
	else:
		var temp:Statement = self.substatement_pointers[position]
		self.substatement_pointers[position] = null
		return temp

func execute(game:Game): # the return type for this depends on the type
	for i in range(len(self.substatement_pointers)):
		assert(self.substatement_pointers[i],\
			"STATEMENT ERROR: Missing statement " + str(i) + " in " + self.data.title)
		assert(self.substatement_pointers[i].type == self.substatement_types[i],\
			"STATEMENT TYPE ERROR: statement " + str(i) + " in " + self.data.title + " needs to be of type " +\
			ENUMS.ST_TYPES.keys()[self.substatement_types[i]] + " and not " \
			+ ENUMS.ST_TYPES.keys()[self.substatement_pointers[i].type])
	
	return self.execute_fnc.call(game,self)

func check_executable_recursively() -> bool:
	for substatement in substatement_pointers:
		if not substatement: # if it doesn't exist
			return false
		if not substatement.check_executable_recursively(): # or is not filled
			return false
	return true

static func constructor(statement_data: StatementData) -> Statement:
	var obj := self_scene.instantiate()
	obj.data = statement_data.duplicate()
	obj.type = obj.data.type
	obj.execute_fnc = Callable(StatementFunctions, "execute_" + obj.data.name)
	obj.substatement_types = obj.data.substatement_types.duplicate()
	obj.substatement_pointers.resize(len(obj.data.substatement_types))
	obj.substatement_pointers.fill(null)
	return obj
