extends Node2D

var spawn_timer: Timer
@export var enemies_over_time: Curve = Curve.new()
#@export var spawn_interval: Curve = Curve.new()
@export var projectiles: Node2D
@export var enemies: Array[ResourceEnemy]
@export var spawn_points_node: Node

func _on_tree_entered() -> void:
	Logic.enemy_manager = self
	spawn_timer = $SpawnTimer
	spawn_timer.set_paused(true)
	timer.set_paused(true)

var last_player_position: Vector2 = Vector2.ZERO
func player_position() -> Vector2:
	if Logic.player:
		return Logic.player.global_position
	return Vector2.ZERO

var spawn_points: Array[Marker2D]:
	get:
		var points: Array[Marker2D] = []
		for child in spawn_points_node.get_children():
			if child is Marker2D and child.is_in_group("enemy_spawn_point"):
				points.append(child)
		return points

var total_enemy_count: int:
	get:
		var count: int = 0
		for child in get_children():
			if child.is_in_group("enemy"):
				count += 1
		return count

## Adds an enemy to the scene at a given position. If position is Vector2.ZERO, spawns randomly between two spawn points.
func add_enemy(enemy: ResourceEnemy, spawn_position: Vector2) -> Enemy2D:
	var x: float
	var y: float

	if spawn_position == Vector2.ZERO:
		var point_1_index = randi() % spawn_points.size()
		var point_1 = spawn_points[point_1_index]
		var point_2_index = (point_1_index + (1 if randi() % 2 == 0 else -1)) % spawn_points.size()
		var point_2 = spawn_points[point_2_index]
		
		x = randf_range(point_1.global_position.x, point_2.global_position.x)
		y = randf_range(point_1.global_position.y, point_2.global_position.y)
	else:
		x = spawn_position.x
		y = spawn_position.y

	var indicator = _spawn_indicator_at_position(Vector2(x, y))
	await indicator.spawn_indicator_finished
	var enemy_instance = enemy.scene.instantiate()
	add_child(enemy_instance)
	enemy_instance.manager = self
	enemy_instance.global_position = Vector2(x, y)
	enemy_instance.name = enemy_instance.name + "_" + str(total_enemy_count)
	enemy.enemy_count += 1
	return enemy_instance

@export var timer: Timer

func _calculate_spawn_weight(enemy: ResourceEnemy) -> float:
	var weight: float = enemy.spawn_weight
	var total_weight: float = weight
	var time:float = timer.time_left
	var count: int = enemy.enemy_count
	var enemy_limit: float = enemy.max_count
	if enemy_limit > 0:
		## Scale weight based on how close we are to the max count
		var limit_factor: float = clamp(1.0 - (float(count) / enemy_limit), 0.0, 1.0)
		total_weight *= limit_factor
	
	return total_weight

func decide_enemy_to_spawn() -> ResourceEnemy:
	var sorted_by_weight: Array[ResourceEnemy] = enemies.duplicate()
	var output: ResourceEnemy
	for enemy in enemies:
		if _calculate_spawn_weight(enemy) > _calculate_spawn_weight(enemies[0]):
			sorted_by_weight.insert(0, enemy)
		else:
			sorted_by_weight.append(enemy)
	
	output = sorted_by_weight[0]
	var pick_second: bool = randf() < 0.15
	if pick_second and sorted_by_weight.size() > 1:
		output = sorted_by_weight[1]

	return output

func _on_timer_timeout() -> void:
	if total_enemy_count >= enemies_over_time.sample(timer.time_left): return
	var enemy: ResourceEnemy = decide_enemy_to_spawn()
	var spawn_point: Marker2D = spawn_points[randi() % spawn_points.size()]
	add_enemy(enemy, Vector2.ZERO)

func _on_enemy_dead(enemy: Enemy2D) -> void:
	for resource_enemy in enemies:
		if enemy.is_in_group(resource_enemy.enemy_group):
			resource_enemy.enemy_count -= 1
			Logic.add_score(resource_enemy.score_value, enemy.global_position)
			enemy_death_effect(enemy, enemy.hit_angle)
			break

func _spawn_indicator_at_position(pos: Vector2) -> Node2D:
	var indicator_scene: PackedScene = preload("res://Scenes/effects/spawn_indicator/spawn_indicator.tscn")
	var indicator_instance: Node2D = indicator_scene.instantiate()
	add_child(indicator_instance)
	indicator_instance.global_position = pos
	return indicator_instance

func toggle_enemy_spawn(enable: bool) -> void:
	timer.set_paused(not enable)
	spawn_timer.set_paused(not enable)

func enemy_death_effect(enemy:Enemy2D, hit_angle:float) -> void:
	var death_effect:CPUParticles2D = enemy.death_effect_scene.instantiate()
	var color: Color = enemy.death_effect_color
	death_effect.global_position = enemy.global_position
	death_effect.actor_color = color
	death_effect.set_rotation(hit_angle) #radians
	print("Death effect rotation (radians): ", hit_angle, " | degrees: ", rad_to_deg(hit_angle))
	add_child(death_effect)