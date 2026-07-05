extends Node
class_name Caster

# this is mostly temporary. later the scenes are suppsosed to be defined from child classes
const self_scene = preload("res://scenes/caster.tscn")

var lexicon
var hand

static func constructor() -> Caster:
	var obj = self_scene.instantiate()
	obj.lexicon = []
	obj.hand = []
	return obj

func add_card_bottom_deck(token: Token):
	lexicon.push_front(token)
	
func add_card_top_deck(token: Token):
	lexicon.push_back(token)

func draw(n: int) -> void:
	for i in n:
		if lexicon.size() != 0:
			hand.push_front(lexicon.pop_back())
		else:
			print("deck empty, cannot draw :(")
