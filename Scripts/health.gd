@icon("res://Assets/Editor Icons/icon_heart.png")
class_name HealthComponent extends Component

@export var max_health: int = 3:
	set(value):
		max_health_set.emit(value)
		return value

var current_health: int = max_health:
	set(new_health):
		new_health = clamp(new_health, 0, max_health)
		if new_health < current_health:
			damaged.emit(current_health - new_health)
			print("Ouch! Health is now %d/%d" % [new_health, max_health])
		elif new_health > current_health:
			healed.emit(new_health - current_health)
			print("Yay! Health is now %d/%d" % [new_health, max_health])
		
		if new_health == max_health:
			health_full.emit()
			print("Health is full at %d/%d" % [new_health, max_health])
		elif new_health == 0:
			health_empty.emit()
			print("Health is empty at %d/%d" % [new_health, max_health])
		
		if new_health != current_health:
			health_changed.emit(current_health)
			print("Health changed to %d/%d" % [new_health, max_health])
		
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
	print("Taking %d damage from %s" % [damage, str(from)])
	hurt(damage)
	
