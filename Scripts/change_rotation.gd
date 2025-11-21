## Changes the rotation of the node it is attached to, when given a direction vector.
class_name ChangeRotation extends Component

## The targeted node to sync the rotation to.
@export var rotation_sync: Node

func _on_facing_direction_changed(dir: Vector2) -> void:
	get_parent().rotation = Vector2(dir).normalized().angle()

func _ready() -> void:
	if rotation_sync:
		rotation_sync.connect("facing_direction_changed", Callable(self, "_on_facing_direction_changed"))
		get_parent().rotation = Vector2(rotation_sync.facing_direction).normalized().angle()
	else:
		push_warning("No rotation_sync node assigned in ChangeRotation script on %s" % name)
	
