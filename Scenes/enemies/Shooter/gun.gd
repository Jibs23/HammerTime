extends Marker2D

@export var bullet: PackedScene
@export var aim_at_player: bool = true
@export var actor: Node2D

func _physics_process(_delta: float) -> void:
	if aim_at_player and actor.manager.player_position() != Vector2.ZERO:
		var player_pos: Vector2 = get_tree().get_root().get_node("Game").player.global_position
		look_at(player_pos)

func shoot() -> void:
	print("Shooting bullet from ", self.name)
	var bullet_instance = bullet.instantiate()
	actor.manager.projectiles.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.direction = Vector2(cos(global_rotation), sin(global_rotation))
	if aim_at_player and actor.manager.player_position() != Vector2.ZERO:
		var player_pos: Vector2 = get_tree().get_root().get_node("Game").player.global_position
		bullet_instance.rotation = (player_pos - global_position).angle()
	else:
		bullet_instance.rotation = global_rotation

func _on_timer_timeout() -> void:
	if actor.manager.player_position() == Vector2.ZERO: return
	if !_on_screen: 
		print("Not on screen, not shooting")
		return
	shoot()

var _on_screen: bool = false

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	_on_screen = true

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	_on_screen = false
