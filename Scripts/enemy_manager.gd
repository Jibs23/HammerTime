extends Node2D

var game:Node
var player: Character2D
var spawn_timer: Timer
@export var enemies_over_time: Curve = Curve.new()
#@export var spawn_interval: Curve = Curve.new()
@export var projectiles: Node2D

func _on_tree_entered() -> void:
	game = get_tree().get_root().get_node("Game")
	player = game.player
	spawn_timer = $SpawnTimer
	game.enemy_manager = self

var last_player_position: Vector2 = Vector2.ZERO
func player_position() -> Vector2:
	if player:
		return player.global_position
	return Vector2.ZERO

var enemies: Dictionary = {
	"Runner": preload("res://Scenes/enemies/Runner/enemy_runner.tscn"),
	#"Flanker": preload("res://Scenes/enemies/Flanker/enemy_flanker.tscn"),
	"Shield": preload("res://Scenes/enemies/Shield/enemy_shield.tscn"),
	"Shooter": preload("res://Scenes/enemies/Shooter/enemy_shooter.tscn"),
}

@export var spawn_points_node: Node
var spawn_points: Array[Marker2D]:
	get:
		var points: Array[Marker2D] = []
		for child in spawn_points_node.get_children():
			if child is Marker2D and child.is_in_group("enemy_spawn_point"):
				points.append(child)
		return points

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

@export var timer: Timer

func _on_timer_timeout() -> void:
	print(enemies_over_time.sample(timer.time_left))
	if enemy_count >= enemies_over_time.sample(timer.time_left): return
	var enemy: PackedScene = enemies.values()[randi() % enemies.size()]
	var spawn_point: Marker2D = spawn_points[randi() % spawn_points.size()]
	var new_enemy = add_enemy(enemy, spawn_point.global_position)
	#print("Spawned " + str(new_enemy.name) + " at %s" % str(spawn_point.global_position))
