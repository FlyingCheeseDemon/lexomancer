extends Resource
class_name StatementData

@export var name:String

@export_category("Card visuals")
@export var title:String
@export var artwork:Texture2D
@export_multiline var card_text:String

@export_category("Function")
@export var type:ENUMS.ST_TYPES
@export_multiline var text:String
@export var substatement_types:Array[ENUMS.ST_TYPES] = []
