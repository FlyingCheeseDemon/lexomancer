extends Label

class_name RowColLabel

const scene = "res://scenes/row_col_marker.tscn"

static func constructor(text:String) -> RowColLabel:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.text = text
	return obj
