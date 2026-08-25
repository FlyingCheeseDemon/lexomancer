extends ColorRect

class_name SpellBook

@onready var statement_container:Container = $MarginContainer

var root:Statement = null

func add_statement(target:Container, stat:Statement) -> void:
	var block = StatementBlock.constructor(stat)
	target.add_child(block)
