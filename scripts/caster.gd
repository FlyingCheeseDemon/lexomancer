extends Node
class_name Caster

# this is mostly temporary. later the scenes are suppsosed to be defined from child classes
const self_scene = preload("res://scenes/caster.tscn")

var lexicon

static func constructor() -> Caster:
	var obj = self_scene.instantiate()
	obj.lexicon = Lexicon.constructor()
	return obj

func draw_and_play() -> void:
	# for debug purposes only
	var card = lexicon.draw()
	if card != null:
		card.play()
	else:
		print(":(")
