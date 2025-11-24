@icon("res://Assets/Editor Icons/icon_scene.png")
class_name State extends Node

## Whether the state is ready to be entered.
var state_ready: bool = true
var state_machine: StateMachine
var actor: Node
var input_dir: Vector2 = Vector2.ZERO
var input_action_1: bool = false
var input_action_2: bool = false

## Used by the stateMachine to talk to the AnimationPlayer and swap animations.
@export var animation_id: String = ""

## The path to the idle state node, for transitions. Becomes a string when called.
@export var state_idle: State

## Timer made by actions to indicate cooldown. kills itself when done. If true then cooldown.
var cooldown_timer: Timer = null

## Emitted to transition to another state.
signal transition(to_state: String, from_state: State)

## Used by other scripts to request a state transition.
func request_transition(to_state: State) -> void:
	if !to_state: return
	transition.emit(to_state, self)
	print("state transitioned. from %s to %s" % [self.name, to_state])
	print("no logic set up in ", self.name, " to handle this transition.")

## Reset the input variables to their default states.
func reset_inputs() -> void:
	input_dir = Vector2.ZERO
	input_action_1 = false
	input_action_2 = false

func pre_enter() -> void:
	enter()

## Called after entering the state.
func enter() -> void:
	pass

func pre_exit() -> void:
	exit()

## Called before exiting the state.
func exit() -> void:
	pass

## Used in _process, to be called every frame.
func update(_delta: float) -> void:
	pass

## Used in _physics_process, to be called every physics frame.
func physics_update(_delta: float) -> void:
	pass

func _ready() -> void:
	state_machine = get_parent()
	if !state_machine:
		push_warning("State '%s' has no StateMachine parent!" % self.get_path())
	actor = state_machine.actor
	for act in get_children():
		if act is Action:
			(act as Action).actor = actor
	transition.connect(Callable(state_machine, "_on_state_transition"))
	
func _on_action_completed(_action: Action, _action_name: String) -> void:
	pass

func _on_action_failed(_action: Action, _action_name: String) -> void:
	pass

func _on_action_started(_action: Action, _action_name: String) -> void:
	pass

func _on_action_interrupted(_action: Action, _action_name: String) -> void:
	pass	

func _on_action_running(_action: Action, _action_name: String) -> void:
	pass

func _on_animation_finished(_anim_name: StringName) -> void:
	pass
	
