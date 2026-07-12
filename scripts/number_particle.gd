extends Node2D

class_name NumberParticle

const scene = "res://scenes/number_particle.tscn"
var value:int
var lifetime:float = 2

@onready var number_label:Label = $Path2D/NumberLabelContainer/NumberLabel
@onready var path_follower:PathFollow2D = $Path2D/NumberLabelContainer

static func constructor(val:int) -> NumberParticle:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.value = val
	return obj
	
func _ready() -> void:
	number_label.text = str(self.value)
	
func _process(delta: float) -> void:
	path_follower.progress_ratio += delta*0.5
	lifetime -= delta
	if lifetime < 0:
		self.queue_free()
