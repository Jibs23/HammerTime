extends Character2D

func _unhandled_input(_event:InputEvent)->void:
	if Input.is_action_pressed("action_1"):
		input_action_1.emit(true)
	elif Input.is_action_just_released("action_1"):
		input_action_1.emit(false)
	
	if Input.is_action_pressed("action_2"):
		input_action_2.emit(true)
	elif Input.is_action_just_released("action_2"):
		input_action_2.emit(false)
	
func _process(_delta: float) -> void:
	signal_dir(get_ui_direction())

func get_ui_direction() -> Vector2:
	var ui_direction: Vector2
	if Input.is_action_pressed("ui_up"):
		ui_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		ui_direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left"):
		ui_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		ui_direction = Vector2.RIGHT
	else:
		return Vector2.ZERO
	return ui_direction
