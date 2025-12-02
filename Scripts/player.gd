extends Character2D

var weapon: PhysicsWeapon
var can_rotate_weapon: bool = true
var input_order: Array = []
var dash_cooldown_timer: Timer

@export var debug_invincible: bool = false
@export var dash_power: float = 2000
@export var dash_cooldown_duration: float = 2

signal wpn_rotate(dir:bool)
signal player_dead
signal player_active

func die():
	print("Player has died.")
	player_dead.emit()
	super()

func _ready() -> void:
	super()
	if debug_invincible:
		health_component.max_health = 9999
		health_component.current_health = 9999

func dash() -> void:
	if dash_cooldown_timer: return
	var dir:Vector2 = get_ui_direction()
	apply_central_impulse(dir * dash_power)
	dash_cooldown_timer = _start_dash_cooldown(dash_cooldown_duration)

func _physics_process(_delta: float) -> void:
	signal_dir(get_ui_direction())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		dash()

func get_ui_direction() -> Vector2:
	# Update input order array
	for action in ["move_up", "move_down", "move_left", "move_right"]:
		if Input.is_action_just_pressed(action):
			# Remove if already in array, then add to front
			if action in input_order:
				input_order.erase(action)
			input_order.push_front(action)
		elif Input.is_action_just_released(action):
			# Remove from array when released
			input_order.erase(action)

	var ui_direction: Vector2 = Vector2.ZERO

	# Use the first (most recent) action in the order array that's currently pressed
	for action in input_order:
		if Input.is_action_pressed(action):
			match action:
				"move_up":
					if ui_direction.y + Vector2.UP.y == Vector2.ZERO.y:
						continue					
					ui_direction += Vector2.UP
				"move_down":
					if ui_direction.y + Vector2.DOWN.y == Vector2.ZERO.y:
						continue					
					ui_direction += Vector2.DOWN
				"move_left":
					if ui_direction.x + Vector2.LEFT.x == Vector2.ZERO.x:
						continue
					ui_direction += Vector2.LEFT
				"move_right":
					if ui_direction.x + Vector2.RIGHT.x == Vector2.ZERO.x:
						continue
					ui_direction += Vector2.RIGHT
	if ui_direction != Vector2.ZERO and Logic.game_state == Logic.GameState.READY:
		awake.emit()
	return ui_direction.normalized()

signal awake

func _on_tree_entered() -> void:
	Logic.player = self
	connect("awake", Callable(Logic, "_on_player_wake"))

func wpn_actions():
	if Input.is_action_pressed("action_1"):
		action_1.emit(true)
	elif Input.is_action_just_released("action_1"):
		action_1.emit(false)
	
	if Input.is_action_pressed("action_2"):
		action_2.emit(true)
	elif Input.is_action_just_released("action_2"):
		action_2.emit(false)

	if Input.is_action_pressed("rotate_item_cw"):
		wpn_rotate.emit(false)
	elif Input.is_action_pressed("rotate_item_ccw"):
		wpn_rotate.emit(true)

func _start_dash_cooldown(time:float) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_dash_cooldown_timeout"))
	timer.connect("timeout", Callable(timer, "queue_free"))
	add_child(timer)
	return timer

func _init() -> void:
	Logic.connect("game_state_changed", Callable(self, "_on_game_state_changed"))

func _on_game_state_changed(new_state: Logic.GameState) -> void:
	match new_state:
		Logic.GameState.GAMEOVER:
			die()
