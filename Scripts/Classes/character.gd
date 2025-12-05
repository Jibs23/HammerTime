@icon("res://Assets/Editor Icons/icon_character2d.png")
## Used for 2D characters.
class_name Character2D extends RigidBody2D
@export var death_effect_scene: PackedScene = preload("res://Scenes/effects/effect_splash.tscn")
@export var death_effect_scale: float = 1.0
@export var health_component: HealthComponent 
@export var state_machine: StateMachine
@export var death_sound: AudioStream
var screen_check: VisibleOnScreenNotifier2D
## The last emitted direction, to account for Vector2.ZERO deadzone.
var last_dir: Vector2 = Vector2.ZERO

signal character_died(character: Character2D, hit_angle: float)
signal input_dir(direction: Vector2)
signal action_1(input: bool)
signal action_2(input: bool)
signal hit(damage: int, from: Node)

## The currently active state instance.
var current_state: State:
	get:
		if state_machine:
			return state_machine.current_state
		return null

var hit_angle: float = 0.0
@export var death_effect_color: Color
func die() -> void:
	character_died.emit(self, hit_angle)
	Audio.play_sound(death_sound,self)
	queue_free()

## Signals the direction input, and accounts for Vector2.ZERO deadzone.
func signal_dir(dir: Vector2) -> void:
	if last_dir == dir and dir == Vector2.ZERO:
		return
	last_dir = dir
	input_dir.emit(dir)

func _ready() -> void:
	screen_check = preload("res://Scenes/screencheck.tscn").instantiate()
	add_child(screen_check)
	screen_check.connect("screen_exited", Callable(self, "_on_screen_exited"))

func _on_screen_exited() -> void:
	push_warning("%s has exited the screen and will be removed." % name)
	die()

func _on_tree_entered() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is Node2D:
		hit_angle = body.get_rotation()
