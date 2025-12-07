@icon("res://Assets/Editor Icons/icon_heart.png")
class_name HealthComponent extends Component

@export_range(1, 10) var max_health:int = 2:
	set(value):
		max_health_set.emit(value)
		max_health = value

@onready var current_health: int = max_health:
	set(new_health):
		new_health = clamp(new_health, 0, max_health)
		if new_health < current_health:
			damaged.emit(current_health - new_health)
		elif new_health > current_health:
			healed.emit(new_health - current_health)
		if new_health == max_health:
			health_full.emit()
		elif new_health == 0:
			health_empty.emit()
		if new_health != current_health:
			health_changed.emit(current_health)
		current_health = new_health


signal health_changed(new_health: int)
signal max_health_set(new_max_health: int)
signal health_full()
signal health_empty()
signal healed(amount: int)
signal damaged(amount: int)
signal health_reset()

func reset_health() -> void:
	current_health = max_health
	health_reset.emit()

func heal(amount: int) -> void:
	current_health += amount

func hurt(amount: int) -> void:
	current_health -= amount

func set_max_health(new_max_health: int, heal_current_health: bool = false) -> void:
	max_health = new_max_health
	if heal_current_health:
		current_health = max_health

func is_alive() -> bool:
	return current_health > 0

func _on_value_received(damage:int, from:Node) -> void:
	flash_shape(shape_to_flash)
	hurt(damage)
	
@export var shape_to_flash: Node2D
func flash_shape(shape:Node2D):
	if not shape.material: 
		return
	shape.material.set("shader_param/intensity", 1)
	shape.material.set("shader_param/white_to_black", 1)
	await get_tree().create_timer(0.1).timeout
	shape.material.set("shader_param/intensity", 0)
