extends Label

@export var debug_mode: bool = true

@export_category("Debug Target")
@export var referenced_variable: String = ""
@export var target_node: Node = null
@export_category("Debug Format")
@export var use_deg_to_rad: bool = false
@export var use_rad_to_deg: bool = false
@export var use_snapping: bool = false
@export var decimals: int = 2
@export var vector_length_conversion: bool = false
@export var absolute_value: bool = true
@export var period_separator: bool = false

var label_text: String = text

func _process(_delta: float) -> void:
	if debug_mode and target_node and referenced_variable != "":
		if referenced_variable in target_node:
			var variable = target_node.get(referenced_variable)
			if use_deg_to_rad and typeof(variable) == TYPE_FLOAT:
				variable = deg_to_rad(variable)
			elif use_rad_to_deg and typeof(variable) == TYPE_FLOAT:
				variable = rad_to_deg(variable)
			if vector_length_conversion and typeof(variable) == TYPE_VECTOR2:
				variable = variable.length()
			if absolute_value and typeof(variable) == TYPE_FLOAT:
				variable = abs(variable)
			if use_snapping and typeof(variable) == TYPE_FLOAT:
				variable = snapped(variable, pow(10, -decimals))
			if period_separator and typeof(variable) == TYPE_INT:
				pass #! NOT IMPLEMENTED
			if text != "":
				text = str(label_text," ", str(variable))
			else:
				text = str(variable)

		else:
			text = "Variable not found"
	else:
		text = label_text
