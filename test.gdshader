shader_type canvas_item;

uniform sampler2D tex;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 edited_uvs = vec2(UV.x, UV.y);
	vec4 t = texture(tex, edited_uvs);
	COLOR = t;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
