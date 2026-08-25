extends ColorRect

class_name StatementBlockReceiver

var type:ENUMS.ST_TYPES

static func constructor(desired_type:ENUMS.ST_TYPES) -> StatementBlockReceiver:
	var obj = StatementBlockReceiver.new()
	obj.type = desired_type
	return obj

func _ready() -> void:
	self.custom_minimum_size = Vector2(40,40)
	color = COLORS.ST_COLORS[type]
	
