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

signal statement_receiver_clicked

static func constructor(statement_data: StatementData, callable_generation_args:Dictionary = {}) -> Statement:
	var obj := self_scene.instantiate()
	obj.data = statement_data.duplicate()
	obj.type = obj.data.type
	if len(callable_generation_args.keys()) == 0:
		# a static statement
		obj.execute_fnc = Callable(StatementFunctions, "execute_" + obj.data.name)
	else:
		# a dynamic statement which is probably dependent on some user input
		obj.execute_fnc = Callable(StatementFunctions, "generate_" + obj.data.name).call(callable_generation_args)
	obj.substatement_types = obj.data.substatement_types.duplicate()
	obj.substatement_pointers.resize(len(obj.data.substatement_types))
	obj.substatement_pointers.fill(null)
	return obj

func set_substatement(statement:Statement,position:int) -> void:
	assert(not self.substatement_pointers[position],\
		"STATEMENT ERROR: Statement " + str(position) + " in " + self.data.title + " already set.")
	
	if statement.type == ENUMS.ST_TYPES.CONJUNCTION: # adjust the conjunction to this type
		statement.type = self.substatement_types[position]
		for i in range(len(statement.substatement_types)):
			statement.substatement_types[i] = self.substatement_types[position]
	
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

func clear_all_substatements() -> void:
	for i in range(len(substatement_pointers)):
		self.clear_substatement(i)

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

func generate_text_recursively() -> Array[Control]:
	var substrings:PackedStringArray = self.data.text.split(" ")
	var node_array:Array[Control] = []
	var new_node:Control
	for substring:String in substrings:
		if substring[0] == "%":
			var index = int(substring[1])
			if substatement_pointers[index]:
				var subarray = substatement_pointers[index].generate_text_recursively()
				node_array = node_array + subarray
			else:
				# the subnode is a container where we can drop in another one.
				# to do: make a scene which has all the necessary plumbing
				new_node = StatementBlockReceiver.constructor(self.substatement_types[index])
				new_node.index = index
				new_node.connect("receiver_clicked",_on_receiver_clicked)
				node_array.append(new_node)
		else:
			new_node = Label.new()
			new_node.text = substring
			node_array.append(new_node)
	return node_array
	
func _on_receiver_clicked(receiverNode:StatementBlockReceiver) -> void:
	statement_receiver_clicked.emit(self,receiverNode)
