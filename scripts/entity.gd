extends Sprite2D
class_name Entity

# for now this is only 2 for the player, 1 for the enemy, 0 for neutral units
@export var allegience: int = 0 

var current_health: int

var data:EntityData

var dies:Signal
const scene = "res://scenes/entity.tscn"
@onready var health_bar:Node2D = $HealthBar

static func constructor(entity_data:EntityData) -> Entity:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.data = entity_data
	obj.texture = obj.data.texture
	return obj

var battle_position: Vector2i

func _ready() -> void:
	self.current_health = data.max_health
	health_bar.set_health(1.)
	print("spawned!")
	print(self.battle_position)

func change_health(difference:int) -> void:
	self.current_health += difference
	if self.current_health <= 0:
		self.die()
	else:
		self.current_health = min(self.current_health,self.data.max_health)
	health_bar.set_health(float(self.current_health)/float(self.data.max_health))
	var number_particle = NumberParticle.constructor(difference)
	self.add_child(number_particle)

func die() -> void:
	print("I died!")
	self.dies.emit()
	self.queue_free()
