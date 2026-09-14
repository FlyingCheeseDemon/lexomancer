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
	
func sort_entity_data_by_danger_value_descending(a:String,b:String) -> bool:
	var entity_data_a:EntityData = entity_dictionary[a]
	var entity_data_b:EntityData = entity_dictionary[b]
	if entity_data_a.danger_value > entity_data_b.danger_value:
		return true
	return false
	
func get_sorted_entity_name_list_descending_danger_value() -> Array[String]:
	if len(entity_dictionary.keys()) == 0:
		initialize_entity_dict();
	var entity_list:Array = entity_dictionary.keys().duplicate()
	entity_list.sort_custom(sort_entity_data_by_danger_value_descending)
	return entity_list

func get_enemies_danger_value_by_name(name:String) -> int:
	if len(entity_dictionary.keys()) == 0:
		initialize_entity_dict();
	var entity_data:EntityData = entity_dictionary[name]
	return entity_data.danger_value
