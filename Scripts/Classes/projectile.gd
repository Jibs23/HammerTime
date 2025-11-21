@icon("res://Assets/Editor Icons/icon_bullet.png")
class_name Projectile extends Node2D

var speed: float = 100.0
var move_dir: Vector2 = Vector2.UP

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += move_dir * speed * delta

func die() -> void:
	queue_free()

## Called when the projectile impacts a target, or wall.
func _on_impact(_target: Variant = null) -> void:
	die()