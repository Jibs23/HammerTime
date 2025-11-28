extends Enemy2D

signal shoot(target_pos: Vector2)

@export var move_state: State
@export var distance_from_target: float = 300.0

func _ready() -> void:
	move_state.target_pos = pick_camping_position()

func pick_camping_position() -> Vector2:
	var location: Vector2 = Vector2.ZERO

	var player_location: Vector2 = manager.player_position()
	var direction_to_player: Vector2 = (player_location - global_position).normalized()
	var deviation_angle: float = randf_range(30,-30)
	direction_to_player = direction_to_player.rotated(deg_to_rad(deviation_angle))
	location = player_location - (direction_to_player * distance_from_target)
	
	print("Picked camping position at %s" % str(location))
	return location


func _on_player_too_close() -> void:
	move_state.target_pos = pick_camping_position()

