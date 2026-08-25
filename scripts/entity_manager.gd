extends Node

class_name EntityManager

var entity_dictionary:Dictionary = {}

func initialize_entity_dict() -> void:
	var dir := DirAccess.open("res://1_resources/entities")
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
		entity_dictionary[resource.name] = resource

func get_entity_by_name(key:String) -> Entity:
	if len(entity_dictionary.keys()) == 0:
		initialize_entity_dict();
		
	var entity:EntityData = entity_dictionary[key]
	var entity_object := Entity.constructor(entity)
	return entity_object
