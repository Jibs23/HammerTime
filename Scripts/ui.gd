extends CanvasLayer

signal time_limit_timeout
@export var timer: Timer
@export var score_label: Label
@export_category("UI Layers")
@export var game_ui: CanvasLayer
@export var game_over_ui: CanvasLayer
@export var high_scores_ui: CanvasLayer
@export var tutorial_ui: CanvasLayer

func _init() -> void:
	Logic.ui = self
	Logic.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
	Logic.connect("new_high_score", Callable(self, "_on_new_high_score"))
	
	
func _ready() -> void:
	score_label.target_node = Logic
	Logic.add_high_score(0)

func _on_time_limit_timeout() -> void:
	time_limit_timeout.emit()
	Logic.set_game_state(Logic.GameState.GAMEOVER)

func pause_timer() -> void:
	timer.pause()

func _on_game_state_changed(new_state: Logic.GameState) -> void:
	match new_state:
		Logic.GameState.PLAYING:
			timer.start()
			toggle_ui(UI.HIGH_SCORES, false)
			toggle_ui(UI.GAME, true)
			toggle_ui(UI.GAME_OVER, false)
			toggle_ui(UI.TUTORIAL, false)
		Logic.GameState.GAMEOVER:
			timer.stop()
			toggle_ui(UI.HIGH_SCORES, true)
			toggle_ui(UI.GAME, false)
			toggle_ui(UI.GAME_OVER, true)
		Logic.GameState.READY:
			timer.stop()
			toggle_ui(UI.GAME_OVER, false)
			toggle_ui(UI.GAME, false)
			toggle_ui(UI.HIGH_SCORES, true)
			toggle_ui(UI.TUTORIAL, true)

enum UI{
	GAME,
	GAME_OVER,
	HIGH_SCORES,
	TUTORIAL
}

func toggle_ui(ui:UI, on:bool) -> void:
	var ui_instance: CanvasLayer
	match ui:
		UI.GAME:
			ui_instance = game_ui
		UI.GAME_OVER:
			ui_instance = game_over_ui
		UI.HIGH_SCORES:
			ui_instance = high_scores_ui
		UI.TUTORIAL:
			ui_instance = tutorial_ui
	ui_instance.visible = on

signal new_top_high_score
func _on_new_high_score(new_score: int, index: int, label: Label) -> void:
	if new_score == 0: return
	if index == 0: 
		new_top_high_score.emit()
		Audio.play_sound(Audio.sfx["new_highscore"], null, false)
	flash_label(label,5,0.2,Color.YELLOW)

func flash_label(label:Label,count:int,speed:float,color:Color) -> void:
	var original_color:Color = label.modulate
	for i in count:
		label.modulate = color
		await get_tree().create_timer(speed).timeout
		label.modulate = original_color
