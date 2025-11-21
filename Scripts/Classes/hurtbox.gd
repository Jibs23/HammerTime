@tool
@icon("res://Assets/Editor Icons/icon_square_hurtbox.png")
class_name HurtBox2D extends Area2D
@export var damage: int = 1
@export var auto_hit: bool = true

func _on_area_entered(_area: Area2D) -> void:
	if auto_hit: try_hit()
	
func try_hit() -> bool:
	if !get_overlapping_areas():
		return false #MISS
	for area in get_overlapping_areas():
		if area and area is HitBox2D:
			area.hit.emit(damage, self)
			return true #HIT
	return false #MISS

func _init() -> void:
	if Engine.is_editor_hint():
		set_collision_layer(2) # Layer 2: HurtBoxes
		set_collision_mask(1) # Masks Layer 1: HitBoxes