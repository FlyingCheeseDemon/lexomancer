class_name Card

var title:String 
var image:Texture2D
var description:String

var statement:Statement #struct that contains other important data that will be handed around with the card

static func from_statement(statement:Statement) -> Card:
	var obj = Card.new()
	obj.statement = statement
	obj.image = obj.statement.data.artwork
	obj.title = obj.statement.data.title
	obj.description = format_card_text(obj.statement.data.text,obj.statement.substatement_types)

	return obj

static func format_card_text(oringial_text:String,substate_types:Array[ENUMS.ST_TYPES]) -> String:
	var substrings:PackedStringArray = oringial_text.split(" ")
	var new_text:String = ""
	var text:String
	for substring:String in substrings:
		if substring[0] == "%":
			var index = int(substring[1])
			var color = COLORS.ST_COLORS[substate_types[index]]
			var type_name = ENUMS.ST_TYPES.keys()[substate_types[index]]
			if type_name == "CONJUNCTION":
				type_name = "???"
			text = "[color=" + color + "]"+ type_name +"[/color]"
		else:
			text = substring
		new_text += text + " "
	return new_text
