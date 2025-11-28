extends Character2D

var weapon: PhysicsWeapon
var can_rotate_weapon: bool = true

signal wpn_rotate(dir:bool)
	
func _physics_process(_delta: float) -> void:
	signal_dir(get_ui_direction())
	wpn_actions()

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


var input_order: Array = []
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

	return ui_direction.normalized()


func _on_tree_entered() -> void:
	var game:Node = get_tree().get_root().get_node("Game")
	game.player = self

@onready var camera: Camera2D = $Camera2D

func die() -> void:
	get_tree().reload_current_scene()
	camera.reparent(get_parent())
	super()
	print("Player has died. Reloading scene.")
	
