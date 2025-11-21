extends State

@export var move_state: State

## Used in _physics_process, to be called every physics frame.
func physics_update(_delta: float) -> void:
    if input_dir != Vector2.ZERO:
        transition.emit(move_state)