extends HFlowContainer

class_name StatementBlock

const scene = "res://scenes/statement_block.tscn"

var statement_node:Statement

static func constructor(statement:Statement) -> StatementBlock:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.statement_node = statement
	return obj

func _ready() -> void:
	# generate sub-controls from statment.text
	var sub_nodes:Array[Control] = generate_subnodes()
	for sub_node:Control in sub_nodes:
		self.add_child(sub_node)

func generate_subnodes() -> Array[Control]:
	var substrings:Array[String] = self.statement_node.data.text.split(" ")
	var node_array:Array[Control] = []
	var new_node:Control
	for substring:String in substrings:
		if substring[0] == "%":
			# the subnode is a container where we can drop in another one.
			# to do: make a scene which has all the necessary plumbing
			new_node = TextureRect.new()
		else:
			new_node = Label.new()
			new_node.text = substring
		node_array.append(new_node)
	return node_array
