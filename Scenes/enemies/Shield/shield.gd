extends StaticBody2D

signal hit(damage: int, source: Node)


func _on_hit(damage: int, source: Node) -> void:
	print("Shield enemy hit for %d damage from %s" % [damage, source.name])
