shader_type canvas_item;

uniform float l_progress = 0.0;
uniform vec4 l_color: source_color;
uniform float r_progress = 0.0;
uniform vec4 r_color: source_color;
uniform vec4 bg_color: source_color;

void fragment() {
	vec4 left = mix(l_color, bg_color, step(l_progress, UV.x*2.0));
	vec4 right = mix(r_color, bg_color, step(r_progress, 2.0 - UV.x*2.0));
	COLOR = max(left, right);
}
