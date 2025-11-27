extends Label

@export var debug_mode: bool = true

@export_category("Debug Target")
@export var referenced_variable: String = ""
@export var target_node: Node = null
@export_category("Debug Format")
@export var deg_to_rad: bool = false
@export var rad_to_deg: bool = false

var label_text: String = text

func _process(delta: float) -> void:
	if debug_mode and target_node and referenced_variable != "":
		if referenced_variable in target_node:
			var variable = target_node.get(referenced_variable)
			if deg_to_rad and typeof(variable) == TYPE_FLOAT:
				variable = deg_to_rad(variable)
			elif rad_to_deg and typeof(variable) == TYPE_FLOAT:
				variable = rad_to_deg(variable)
			text = str(label_text," ", str(variable))
		else:
			text = "Variable not found"
	else:
		text = label_text
