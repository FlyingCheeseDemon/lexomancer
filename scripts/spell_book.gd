extends ColorRect

class_name SpellBook

@onready var statement_container:Container = $MarginContainer/HFlowContainer

var root:Statement = null

func add_statement(parent_statement:Statement,index:int, stat:Statement) -> void:
	parent_statement.set_substatement(stat,index)
	update_visuals() 

func update_visuals() -> void:
	for child in statement_container.get_children():
		child.queue_free()
	if root:
		var label_array = root.generate_text_recursively()
		for element:Control in label_array:
			statement_container.add_child(element)

func clear() -> void:
	self.root = null
	update_visuals() 
