extends Enemy2D

@onready var shield: StaticBody2D = $Shield

func pick_shield_orientation() -> void:
	var angles: Array = [0, 90, -90, 180]
	var angle_deg: int = angles[randi() % angles.size()]
	shield.rotation = deg_to_rad(angle_deg)


func _ready() -> void:
	super()
	pick_shield_orientation()