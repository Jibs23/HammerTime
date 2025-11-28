extends MoveState

var target_pos: Vector2 = Vector2.ZERO
@export var target_player: bool = false
@export var idle_on_target_reached: bool = false
@export var target_reached_distance: float = 10.0


signal target_reached

func physics_update(_delta: float) -> void:
	if target_player:
		target_pos = actor.manager.player_position()
	var dir: Vector2 = (target_pos - actor.global_position).normalized()
	if actor.global_position.distance_to(target_pos) < target_reached_distance:
		emit_signal("target_reached")
		if idle_on_target_reached: transition.emit(state_idle, self)
		return
	move(dir)