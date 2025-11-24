extends State

@export var move_speed: float = 300


## Used in _physics_process, to be called every physics frame.
func physics_update(_delta: float) -> void:
	if input_dir == Vector2.ZERO:
		transition.emit(state_idle)
	move(input_dir)

func move(dir:Vector2) -> void:
	if actor.facing_direction and actor.facing_direction != dir:
		actor.facing_direction = dir
	actor.velocity = dir * move_speed
	actor.move_and_slide()