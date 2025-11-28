extends IdleState

@export var player_too_close_distance: float = 150.0

func physics_update(_delta: float) -> void:
	if actor.manager.player_position().distance_to(actor.global_position) < player_too_close_distance:
		move_state.target_pos = actor.pick_camping_position()
		transition.emit(move_state, self)
