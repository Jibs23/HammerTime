@icon("res://Assets/Editor Icons/icon_sword.png")
extends RigidBody2D
class_name PhysicsWeapon

@export var swing_cooldown: float = 2
@export var swing_distance:float = 90
@export var rotation_speed: float = 2
var max_speed:float = 2
var swing_cooldown_timer: Timer

func add_rotation(dir:bool,amount:float):
	if dir:
		angular_velocity += amount
	else:
		angular_velocity -= amount

## gradually rotate the weapon. if dir = true it will rotate clockwise, else counter-clockwise.
func rotate_weapon(dir:bool):
	var intended = rotation_speed if dir else -rotation_speed
	# if we're already at/above max speed and the intended change is in the same direction, block
	if abs(angular_velocity) >= abs(max_speed) and angular_velocity * intended > 0:
		return
	add_rotation(dir, rotation_speed)

## swiftly rotate the weapon, and start a cooldown. if dir = true it will rotate clockwise, else counter-clockwise.
func swing_weapon(dir:bool):
	if swing_cooldown_timer: return
	if dir:
		angular_velocity += swing_distance
		print("swinging weapon1")
	else:
		angular_velocity -= swing_distance
		print("swinging weapon2")
	swing_cooldown_timer = start_cooldown(swing_cooldown)

func wpn_action_1(held:bool):
	if !held: return
	swing_weapon(false)
	print("swung1")

func wpn_action_2(held:bool):
	if !held: return
	swing_weapon(true)
	print("swung2")

	
func start_cooldown(time:float) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	timer.connect("timeout", Callable(timer, "queue_free"))
	add_child(timer)
	return timer


func _on_character_2d_action_2(input: bool) -> void:
	pass # Replace with function body.

func _on_character_2d_action_1(input: bool) -> void:
	pass # Replace with function body.

var player:Character2D

func _enter_tree() -> void:
	if !get_parent().is_in_group("player"): 
		push_error(self.name + " assigned wrong parent")
		return
	player = get_parent() 
	player.weapon = self
	print(self.name," set as player weapon.")
	player.connect("action_1", Callable(self,"wpn_action_1"))
	player.connect("action_2", Callable(self,"wpn_action_2"))
	player.connect("wpn_rotate",Callable(self,"rotate_weapon"))