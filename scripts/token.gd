extends Node
class_name Token

const self_scene = preload("res://scenes/token.tscn")

var token_name = ""

static func constructor(name: String) -> Token:
	var obj = self_scene.instantiate()
	obj.token_name = name
	return obj

func played():
	print(token_name)
