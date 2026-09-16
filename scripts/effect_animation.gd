extends AnimatedSprite2D

class_name EffectAnimation

const scene = "res://scenes/effectAnimation.tscn"

var statement:Statement

static func constructor(effect_statement:Statement) -> EffectAnimation:
	var self_scene = load(scene)
	var obj = self_scene.instantiate()
	obj.sprite_frames = effect_statement.data.animation
	obj.hide()
	return obj

func start() -> void:
	animation = "hit"
	self.show()
	self.play()

func _on_animation_finished() -> void:
	self.queue_free()
