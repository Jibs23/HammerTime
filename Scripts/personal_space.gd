extends Area2D

enum behavior {
	IGNORE,
	PUSH_AWAY,
	PULL_CLOSER,
}

@export var valid_groups: Dictionary[String, behavior] = {
	"player": behavior.IGNORE,
	"enemy": behavior.IGNORE,
	"enemy_runner": behavior.IGNORE,
	"enemy_flanker": behavior.IGNORE,
	"enemy_shield": behavior.IGNORE,
	"enemy_shooter": behavior.IGNORE,
}

@onready var actor: Node2D = get_parent()
@export_range(1, 20.0, 0.1) var push_force: float = 5.0

func _physics_process(_delta: float) -> void:
	push(last_body.global_position - actor.global_position,)

func push(dir: Vector2) -> void:
	match valid_groups[last_body_group]:
		behavior.PUSH_AWAY:
			actor.linear_velocity -= dir.normalized() * push_force
		behavior.PULL_CLOSER:
			actor.linear_velocity += dir.normalized() * push_force
		
var last_body: Node2D = null
var last_body_group: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body == actor:
		return
	var body_groups = body.get_groups()
	for group in body_groups:
		if valid_groups.has(group) and valid_groups[group]:
			last_body = body
			last_body_group = group
			set_physics_process(true)
			return

func _on_body_exited(body: Node2D) -> void:
	if body != last_body: return
	set_physics_process(false)
	last_body = null
	last_body_group = ""

func _ready() -> void:
	set_physics_process(false)