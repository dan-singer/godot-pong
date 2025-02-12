shader_type canvas_item;

uniform vec4 color: source_color;

float sdBox( in vec2 p, in vec2 b ) {
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void fragment() {
	vec2 centered_uvs = UV - vec2(0.5);
	centered_uvs.y *= 10.0;
	centered_uvs.y = fract(centered_uvs.y);
	float sdf = sdBox(centered_uvs, vec2(0.004, .4));
	COLOR = mix(vec4(0.0), color, 1.0-step(0.0, sdf));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
