shader_type canvas_item;

uniform float white_to_black : hint_range(0.0, 1.0) = 1.0;
uniform int intensity : hint_range(0, 1) = 0;

void fragment() {
	if (intensity == 1) {
	vec4 original_color = texture(TEXTURE, UV);
	COLOR = vec4(white_to_black,white_to_black,white_to_black, original_color.a);
	}
}
