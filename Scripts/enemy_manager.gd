extends Node2D

var game:Node
var player: Character2D
var spawn_timer: Timer

func _on_tree_entered() -> void:
	game = get_tree().get_root().get_node("Game")
	player = game.player
	spawn_timer = $SpawnTimer

var last_player_position: Vector2 = Vector2.ZERO
func player_position() -> Vector2:
	if player:
		return player.global_position
	return Vector2.ZERO

var enemies: Dictionary = {
	"Runner": preload("res://Scenes/enemies/Runner/enemy_runner.tscn"),
	#"Flanker": preload("res://Scenes/enemies/Flanker/enemy_flanker.tscn"),
	"Shield": preload("res://Scenes/enemies/Shield/enemy_shield.tscn"),
	#"Shooter": preload("res://Scenes/enemies/Shooter/enemy_shooter.tscn"),
}

var spawn_points: Array[Marker2D]:
	get:
		var points: Array[Marker2D] = []
		for child in get_children():
			if child is Marker2D and child.is_in_group("enemy_spawn_point"):
				points.append(child)
		return points

@export var max_enemies: int = 5
@export var spawn_interval: float = 3.0
var enemy_count: int:
	get:
		var count: int = 0
		for child in get_children():
			if child.is_in_group("enemy"):
				count += 1
		return count

func add_enemy(enemy: PackedScene, spawn_position: Vector2) -> Enemy2D:
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	enemy_instance.global_position = spawn_position
	enemy_instance.name = enemy_instance.name + "_" + str(enemy_count)
	return enemy_instance

func _on_timer_timeout() -> void:
	if enemy_count >= max_enemies: return
	var enemy: PackedScene = enemies.values()[randi() % enemies.size()]
	var spawn_point: Marker2D = spawn_points[randi() % spawn_points.size()]
	var new_enemy = add_enemy(enemy, spawn_point.global_position)
	print("Spawned " + str(new_enemy.name) + " at %s" % str(spawn_point.global_position))
