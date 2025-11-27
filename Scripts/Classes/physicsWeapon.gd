@icon("res://Assets/Editor Icons/icon_sword.png")
extends RigidBody2D
class_name PhysicsWeapon
@export var swing_cooldown: float = 2
@export_range(10, 1000, 1, "radians_as_degrees") var swing_distance: float = 300
## Rotation speed in radians per second.
@export_range(0.1, 200, 0.1,"radians_as_degrees") var rotation_speed: float = 3.14:
	get:
		return (rotation_speed*2)

## Max rotations speed in radians per second.
@export_range(0.1, 600, 0.1,"radians_as_degrees") var max_speed: float = 6.28

@export var dmg_threshold: Curve = Curve.new()
@export_range(0.1, 600, 0.1,"radians_as_degrees") var min_dmg_speed: float = 6.28

var swing_cooldown_timer: Timer

func add_rotation(amount:float,impulse:bool):
		if impulse:
			apply_torque_impulse(amount)
		else:
			apply_torque(amount*center_of_mass.x*mass)

## gradually rotate the weapon. if dir = true it will rotate clockwise, else counter-clockwise.
func rotate_weapon(dir:bool):
	var intended:float = rotation_speed if dir else -rotation_speed
	# if we're already at/above max speed and the intended change is in the same direction, block
	if abs(angular_velocity) >= abs(max_speed) and angular_velocity * intended > 0:
		return
	add_rotation(intended,false)

## swiftly rotate the weapon, and start a cooldown. if dir = true it will rotate clockwise, else counter-clockwise.
func swing_weapon(dir:bool):
	if swing_cooldown_timer: return
	if dir:
		add_rotation(swing_distance,true)
	else:
		add_rotation(-swing_distance,true)
	swing_cooldown_timer = start_cooldown(swing_cooldown)

func wpn_action_1(held:bool):
	if !held: return
	swing_weapon(false)

func wpn_action_2(held:bool):
	if !held: return
	swing_weapon(true)

	
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
	player.connect("action_1", Callable(self,"wpn_action_1"))
	player.connect("action_2", Callable(self,"wpn_action_2"))
	player.connect("wpn_rotate",Callable(self,"rotate_weapon"))
	print(self.name," set as player weapon.")

func calc_dammage() -> int:
	var speed_ratio: float = (abs(angular_velocity) / max_speed)
	var output: int = int(roundf(dmg_threshold.sample(speed_ratio)))
	print("Calculated Dammage: ", output, " (Speed Ratio: ", speed_ratio, ")")
	return output

func _on_body_entered(body: Node2D) -> void:
	if body.has_signal("hit"):
		var calc_dmg: int = calc_dammage()
		if calc_dmg <= 0:
			return
		body.emit_signal("hit", calc_dmg, self)
	else:
		print(body.name, " has no 'hit' signal to deal damage to.")
	

