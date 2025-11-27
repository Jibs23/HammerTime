extends State
class_name MoveState
@export_range(0, 1000) var move_speed: float = 400
var speed: float:
	get:
		return clamp(actor.linear_velocity.length(), 0, move_speed)

func move(dir:Vector2) -> void:
	actor.apply_central_force(Vector2(dir * move_speed))
	#if actor.is_in_group("player"):
		#print("Moving with velocity: %s" % str(speed))
