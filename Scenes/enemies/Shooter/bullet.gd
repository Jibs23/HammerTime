extends RigidBody2D

@export var damage: int = 1
@export var speed: float = 2.0
var direction: Vector2 = Vector2.DOWN

func _physics_process(_delta) -> void:
	apply_central_force(direction * speed)

func _on_body_entered(body: Node) -> void:
	if body.has_signal("hit"):
		body.hit.emit(damage, self)
	_die()

func _die() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	_die()
