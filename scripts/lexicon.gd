extends Node
class_name Lexicon

const self_scene = preload("res://scenes/lexicon.tscn")

var token_list

static func constructor() -> Lexicon:
	var obj = self_scene.instantiate()
	obj.token_list = []
	return obj

func draw():
	return token_list.pop_back()
	
func add_token(token: Token):
	token_list.push_front(token)
