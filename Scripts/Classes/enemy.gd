extends Character2D
class_name Enemy2D

var manager: Node2D

func die():
	print("Enemy has died.")
	queue_free()

func _on_body_entered(body: Node) -> void:
	var entity = body
	if entity.is_in_group("player"):
		entity.hit.emit(1, self)
		print("Dealt 1 damage to player.")

func _on_tree_entered() -> void:
	manager = get_parent()
