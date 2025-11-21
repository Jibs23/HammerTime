@tool
@icon("res://Assets/Editor Icons/icon_square_hitbox.png")
class_name HitBox2D extends Area2D

signal hit(damage: int, from: Node)

func _init() -> void:
	if Engine.is_editor_hint():
		set_collision_layer(1) # Layer 1: HitBoxes
		set_collision_mask(2) # Masks Layer 2: HurtBoxes