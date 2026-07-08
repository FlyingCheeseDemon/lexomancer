extends Node2D

@onready var health_bar_texture_rect:TextureRect = $CenterContainer/ColorRect2
@onready var health_bar_shader_material = health_bar_texture_rect

func set_health(fraction:float):
	health_bar_shader_material.set("instance_shader_parameters/health_percent",fraction*100)
