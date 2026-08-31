extends Node

class_name Player

@export var max_health:int
var health:int

signal i_died
signal health_changed

func _ready() -> void:
	self.health = self.max_health
	
func reduce_health(amount:int) -> void:
	self.health -= amount
	health_changed.emit()
	if self.health <= 0:
		i_died.emit()

func increase_health(amount:int) -> void:
	self.health += amount
	self.health = min(self.health,self.max_health)
	health_changed.emit()
