extends ColorRect

class_name SpellBook

@onready var statement_container:Container = $MarginContainer

var root:Statement = null
var root_node:StatementBlock

func add_statement(target:StatementBlockReceiver, stat:Statement) -> StatementBlock:
	var block = StatementBlock.constructor(stat)
	target.add_child(block)
	var parent_statement:Statement = target.get_parent().statement_node
	var target_index_in_parent = target.index
	parent_statement.set_substatement(stat,target_index_in_parent)
	return block

func clear() -> void:
	self.root_node.queue_free()
	self.root = null
