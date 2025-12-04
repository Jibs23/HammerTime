@icon("res://Assets/Editor Icons/icon_bullet.png")
extends Area2D
class_name Projectile

@export var damage: int = 1
@export var speed: float = 10.0
@export var collision_whitelist: Array[String] = ["player","projectile_deflect"]
var deflected: bool = false
var direction: Vector2 = Vector2.DOWN
@export var deflected_speed_multiplier: float = 1.5
@export var deflected_color: Color
@onready var body_color: Color = $bullet_body.color
@export var impact: CPUParticles2D
@export var collision_shape: CollisionShape2D
@export var bullet_body: Polygon2D

func _physics_process(_delta) -> void:
	_move()

func _on_body_entered(body: Node) -> void:
	var body_groups:Array = body.get_groups()
	for group in collision_whitelist:
		if group in body_groups:
			if body.is_in_group("projectile_deflect") and !deflected:
				_deflect()
				return
			if body.has_signal("hit"):
				body.hit.emit(damage, self)
			_die()
			return

func _die() -> void:
	impact.color = body_color
	impact.emitting = true
	bullet_body.visible = false
	collision_whitelist.clear()
	particles.emitting = false

	await impact.finished
	call_deferred("queue_free")

func _on_timer_timeout() -> void:
	_die()

@export var particles: CPUParticles2D

func _deflect() -> void:
	Audio.play_sound(Audio.sfx["deflect"],self)
	collision_whitelist.append("enemy")
	direction = -direction
	rotation += PI
	deflected = true
	impact.color = Color.WHITE
	particles.color = deflected_color
	bullet_body.color = deflected_color
	impact.emitting = true
	speed *= deflected_speed_multiplier
	damage *= 2
	Logic.add_score(1250, global_position)

func _move() -> void:
	global_position += direction * speed
