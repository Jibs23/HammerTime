@icon("res://Assets/Editor Icons/icon_sword.png")
extends RigidBody2D
class_name PhysicsWeapon

var player:Character2D
var last_angular_velocity: float

@export_category("Weapon Damage")
var swing_power: float = 0
@export_range(1, 10, 1) var weapon_dmg: int = 1
@export_range(1, 1000, 1) var min_dmg_speed: float = 500
@export_range(1, 1500, 1) var max_dmg_speed: float = 700
@export var dmg_threshold: Curve = Curve.new()

@export_category("Bounce Settings")
var bounce_timer: Timer
@export var intertia_bounce: float = 300
@onready var inertia_default = inertia

func _physics_process(_delta: float) -> void:
	last_angular_velocity = get_angular_velocity()
	swing_power = abs(rad_to_deg(last_angular_velocity)) + abs(player.linear_velocity.length()*0.5)

func _on_player_move(dir:Vector2) -> void:
	if dir == Vector2.ZERO:
		return
	else:
		pass

func wpn_action_1(held:bool):
	pass

func wpn_action_2(held:bool):
	pass

func start_cooldown(time:float) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	timer.connect("timeout", Callable(timer, "queue_free"))
	add_child(timer)
	return timer

func _enter_tree() -> void:
	if !get_parent().is_in_group("player"): 
		push_error(self.name + " assigned wrong parent")
		return
	player = get_parent() 
	player.weapon = self
	player.connect("action_1", Callable(self,"wpn_action_1"))
	player.connect("action_2", Callable(self,"wpn_action_2"))

func calc_dammage() -> int:
	var output: int = 0
	if swing_power < min_dmg_speed:
		output = 0
	elif swing_power >= max_dmg_speed:
		output = int(dmg_threshold.sample(1.0) * weapon_dmg)
		print("CRITICAL HIT!")
	else:
		var dmg_mult: float = swing_power / max_dmg_speed # get percentage of max_dmg_speed
		var dmg_sample: float = dmg_threshold.sample(dmg_mult) # sample curve at that percentage
		output = int(roundf(dmg_sample) * weapon_dmg) # scale by weapon damage

	return output

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("solid"):
		_bounce_off(0.8, 10)
		return
	var calc_dmg: int = calc_dammage()
	if calc_dmg <= 0: return
	if body.hit_angle != null:
		body.hit_angle = float(get_rotation())
	if body.has_signal("hit"):
		body.hit.emit(calc_dmg, self)
	else:
		print(body.name, " has no 'hit' signal to deal damage to.")

## Reverse angular velocity on bounce with some lost speed
func _bounce_off(lost_speed: float, force:float) -> void:
	if bounce_timer: return
	inertia = intertia_bounce
	set_angular_velocity(0)
	apply_torque_impulse(-rad_to_deg(last_angular_velocity) * force * lost_speed)
	bounce_timer = _start_bounce_timer(0.2)
	
func _start_bounce_timer(time: float) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_bounce_timeout"))
	timer.connect("timeout", Callable(timer, "queue_free"))
	add_child(timer)
	return timer

func _on_bounce_timeout() -> void:
	inertia = inertia_default
	bounce_timer = null