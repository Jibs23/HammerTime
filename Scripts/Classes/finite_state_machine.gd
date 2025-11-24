@icon("res://Assets/Editor Icons/icon_lever.png")
class_name StateMachine extends Node

@export var show_debug: bool = true

@export var initial_state: State

@export var actor: Character2D

signal state_entered(new_state: State)
signal state_exited(old_state: State)

var debug_label: Label

var current_state: State:
	set(new_state):
		if current_state:
			current_state.pre_exit()
			current_state.reset_inputs()
			state_exited.emit(current_state)
		current_state = new_state
		new_state.pre_enter()
		state_entered.emit(new_state)
		if debug_label:
			debug_label.text = "State: %s" % current_state.name

func _ready() -> void:
	if initial_state:
		current_state = initial_state
	if show_debug:
		debug_label = Label.new()
		debug_label.name = "StateDebugLabel"
		get_parent().call_deferred("add_child", debug_label)
		debug_label.position = Vector2(0, 0)

func _on_actor_input_action_1(input: bool) -> void:
	if actor.is_in_group("player"):
		return
	var state = current_state as State
	state.input_action_1 = input

func _on_actor_input_action_2(input: bool) -> void:
	if actor.is_in_group("player"):
		return
	var state = current_state as State
	state.input_action_2 = input

func _on_actor_input_dir(direction: Vector2) -> void:
	current_state.input_dir = direction

func _process(delta: float) -> void:
	if current_state: current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state: current_state.physics_update(delta)
	
## Handles state transitions.
## from_state: The active desired to transition from. Leave blank if unspecified.
## to_state: The name of the desired state to transition to. As a string.
func _on_state_transition(to_state: State, from_state: State = null) -> void:
	if from_state == null:
		from_state = current_state
	if from_state != current_state:
		push_warning("State '%s' tried to transition but is not the current from_state in FSM '%s'" % [from_state.name, name])
		return
	if !to_state:
		push_error("State '%s' not found in FSM '%s'" % [to_state, name])
		return
	if to_state.state_ready == false:
		push_warning("State '%s' is not ready to be entered in FSM '%s'" % [to_state, name])
		return
	if to_state.cooldown_timer:
		#push_warning("State '%s' is on cooldown in FSM '%s'" % [to_state, name])
		return
	if to_state == current_state:
		push_warning("WARNING: %s is the same as %s" % [to_state, from_state])
		return
	current_state = to_state

## Received from that animationTree. Note: does not work for looping animations.
func _on_animation_finished(anim_name: StringName) -> void:
		current_state._on_animation_finished(anim_name)
