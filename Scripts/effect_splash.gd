extends CPUParticles2D

var actor_color: Color
@export var explosion: CPUParticles2D

func _on_tree_entered() -> void:
	color = actor_color
	explosion.color = actor_color
	emitting = true
	explosion.emitting = true

func _on_finished() -> void:
	queue_free()
	print("Splash effect finished and removed.")