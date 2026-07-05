extends Sprite2D
class_name Entity

# for now this is only 2 for the player, 1 for the enemy, 0 for neutral units
@export var allegience: int = 0 

@export_category("Combat")
@export var max_health: int
var current_health: int
@export var attack_value: int = 0

var dies:Signal

static var scene_dict:Dictionary = {
	"pink_slime": "res://scenes/entities/pink_slime.tscn"
}

static func constructor(entity_name:String) -> Entity:
	var self_scene = load(scene_dict[entity_name])
	var obj = self_scene.instantiate()
	return obj

var battle_position: Vector2i

func _ready() -> void:
	self.current_health = max_health
	print("spawned!")
	print(self.battle_position)

func attack(target:Entity) -> void:
	pass

func change_health(difference:int) -> void:
	self.current_health += difference
	if self.current_health <= 0:
		self.die()
	else:
		self.current_health = min(self.current_health,self.max_health)
	print("ouch!")

func die() -> void:
	print("I died!")
	self.dies.emit()
	self.queue_free()
