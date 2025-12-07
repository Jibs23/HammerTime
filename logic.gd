extends Node

var game:Node
var player: Character2D
var enemy_manager: Node2D
var ui: Node
var audio_manager: Node
var time_limit_timer: Timer

# GAME STATE MANAGEMENT
enum GameState {
	PLAYING,
	GAMEOVER,
	READY
}

func _ready() -> void:
	game_state_changed.emit(game_state)
	highscore_file.load()

signal game_state_changed(new_state: GameState)
var game_state: GameState = GameState.READY

func set_game_state(new_state: GameState) -> void:
	match new_state:
		GameState.PLAYING:
			start_game()
		GameState.GAMEOVER:
			game_over()
		GameState.READY:
			restart_game()

func restart_game() -> void:
	game_state = GameState.READY
	game_state_changed.emit(game_state)
	get_tree().reload_current_scene()

func start_game() -> void:
	game_state = GameState.PLAYING
	reset_score()
	enemy_manager._reset_enemy_counts()
	enemy_manager.toggle_enemy_spawn(true)
	game_state_changed.emit(game_state)
	Audio.play_music(Audio.music["song1"])

func game_over() -> void:
	if time_limit_timer.time_left > 1:
		Audio.stop_music()
	game_state = GameState.GAMEOVER
	enemy_manager.toggle_enemy_spawn(false)
	add_high_score(score)
	if player: player.die()
	game_state_changed.emit(game_state)

func _on_player_wake() -> void:
	if player.sleeping == false:
		set_game_state(GameState.PLAYING)
		print("Player woke up, resuming game.")

# SCORE TRACKING
var score: int = 0
var highscore_file: = preload("res://Assets/resource_scores.tres")

const SCORE_POP: PackedScene = preload("res://Scenes/effects/score_pop.tscn")
func add_score(points: int,popup:Vector2=Vector2.ZERO) -> void:
	score += points
	if popup != Vector2.ZERO:
		var popup_instance: Label = SCORE_POP.instantiate()
		ui.add_child(popup_instance)
		popup_instance.global_position = popup
		popup_instance.text = str(points)

func reset_score() -> void:
	score = 0

signal new_high_score(new_score: int,index: int,label: Label)
func add_high_score(new_score: int) -> void:
	var list:Array[int] = highscore_file.highscore_list
	var score_labels = ui.high_scores_ui.get_child(0).get_child(1).get_children() as Array[Label]
	list.append(new_score)
	list.sort()
	list.reverse()
	if list.size() > score_labels.size():
		list.resize(score_labels.size())
	for slot:Label in score_labels:
		var index = slot.get_index()
		slot.text = str(list[index])
		if list[index] == new_score:
			new_high_score.emit(new_score, index, slot)
	highscore_file.highscore_list = list
	highscore_file.save()

# INPUT
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		set_game_state(GameState.READY)
