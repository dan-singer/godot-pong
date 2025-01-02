shader_type canvas_item;

uniform float radius = 0.5;
uniform float smoothness = 0.05;
uniform vec4 inner_color: source_color;
uniform vec4 border_color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 centered_uvs = UV - vec2(0.5);
	float d = length(centered_uvs);
	d -= radius;
	float circle = 1.0 - smoothstep(0.0, smoothness, d);
	vec4 bordered_circle = mix(inner_color, border_color, smoothstep(-smoothness, 0.0, d));
	COLOR = circle * bordered_circle;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
