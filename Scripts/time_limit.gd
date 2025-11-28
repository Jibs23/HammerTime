extends Timer

@export var repeat: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and is_stopped():
		start()
		if repeat:
			autostart = true