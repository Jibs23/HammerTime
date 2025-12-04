extends Marker2D

@export var bullet: PackedScene
@export var aim_at_player: bool = true
@export var actor: Node2D

func _physics_process(_delta: float) -> void:
	if aim_at_player and actor.manager.player_position() != Vector2.ZERO:
		var player_pos: Vector2 = actor.manager.player_position()
		look_at(player_pos)

func shoot() -> void:
	Audio.play_sound(Audio.sfx["shoot"],self)
	var bullet_instance = bullet.instantiate()
	actor.manager.projectiles.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.direction = Vector2(cos(global_rotation), sin(global_rotation))
	if aim_at_player and actor.manager.player_position() != Vector2.ZERO:
		var player_pos: Vector2 = actor.manager.player_position()
		bullet_instance.set_rotation((player_pos - global_position).angle() - deg_to_rad(90))
	else:
		bullet_instance.set_rotation(global_rotation)

func _on_timer_timeout() -> void:
	if actor.manager.player_position() == Vector2.ZERO: return
	shoot()

