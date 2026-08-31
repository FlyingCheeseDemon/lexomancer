extends Node

class_name StatementManager

var statement_dictionary:Dictionary = {}

func initialize_statement_dict() -> void:
	var dir := DirAccess.open("res://1_resources/statements")
	if dir == null:
		printerr("Could not open folder")
		return
	dir.list_dir_begin()
	for file:String in dir.get_files():
		if file[0] == "_":
			continue
		var resource := load(dir.get_current_dir() + "/" + file)
		if resource == null:
			print("Failed to load " + file)
			continue
		statement_dictionary[resource.name] = resource

func get_statement_data_by_name(key:String) -> StatementData:
	if len(statement_dictionary.keys()) == 0:
		initialize_statement_dict();
	var statement:StatementData = statement_dictionary[key].duplicate()
	return statement
	
func get_statement_by_name(key:String) -> Statement:
	var statement = get_statement_data_by_name(key)
	var statement_object := Statement.constructor(statement)
	return statement_object
