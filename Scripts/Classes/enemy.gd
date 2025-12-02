@icon("res://Assets/Editor Icons/icon_character2d_enemy.png")
extends Character2D
class_name Enemy2D

var manager: Node2D
@export var bounce_force: float = 400.0
signal touched_player(enemy:Enemy2D)

func _on_body_entered(body: Node) -> void:
	super._on_body_entered(body)
	if body.is_in_group("player"):
		body.hit.emit(1, self)
		var dir:Vector2 = (self.global_position - body.global_position).normalized()
		apply_central_impulse(dir * bounce_force)
		touched_player.emit(self)
		print("Dealt 1 damage to player.")

func _on_tree_entered() -> void:
	super()
	manager = get_parent()
	connect("character_died", Callable(manager, "_on_enemy_dead"))

