@icon("res://Assets/Editor Icons/icon_file.png")
## A node that represents an action that can be performed by a character.
@abstract class_name Action extends Node


signal action_completed(action: Action, method: String)
signal action_failed(action: Action, method: String)
signal action_started(action: Action, method: String)
signal action_interrupted(action: Action, method: String)
signal action_running(action: Action, method: String)


var actor: Node

func _init() -> void:
	name = self.get_script().get_global_name()
	
func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	var state: State = get_parent() as State
	connect("action_completed", Callable(state, "_on_action_completed"))
	connect("action_failed", Callable(state, "_on_action_failed"))
	connect("action_started", Callable(state, "_on_action_started"))
	connect("action_interrupted", Callable(state, "_on_action_interrupted"))
	connect("action_running", Callable(state, "_on_action_running"))

func start_cooldown(time:float) -> Timer:
	var timer = Timer.new()
	var parent = get_parent()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	timer.connect("timeout", Callable(timer, "queue_free"))
	add_child(timer)
	parent.cooldown_timer = timer
	return timer

func _on_cooldown_timeout() -> void:
	pass
