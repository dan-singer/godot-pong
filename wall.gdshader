shader_type canvas_item;

uniform float radius = 0.2f;
uniform vec4 inner_color: source_color = vec4(1.0);
uniform vec4 outer_color: source_color = vec4(0,0,0,1);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 centered_uvs = UV - vec2(0.5f);
	float sdf = length(centered_uvs) - radius;
	COLOR = mix(inner_color, outer_color, smoothstep(0.0, 0.1, sdf));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
