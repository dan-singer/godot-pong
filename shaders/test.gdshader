shader_type canvas_item;

uniform sampler2D tex;
uniform int quality = 16;
uniform int angular_quality = 16;
uniform float radius = 8;
uniform vec2 sprSize;
uniform vec4 tint: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 radialBlur(vec2 uv) {
	vec4 blur = vec4(0,0,0,0);
	for (int i = 0; i < quality; ++i) {
		float pct = float(i) / float(quality);
		float scale = 0.9 + pct;
		vec2 radial_uv = uv * scale + vec2(0.5 - (0.5*scale));
		blur += texture(tex, radial_uv);
	}
	blur /= float(quality);
	return blur;
}

void fragment() {
	vec4 gaussian_blur = vec4(0.0);
	for (int i = 0; i < angular_quality; ++i)
	{
		float theta = float(i) / (2.0 * PI);
		for (int j = 0; j < quality; ++j)
		{
			float len = (float(j) / float(quality)) * radius;
			gaussian_blur += texture(tex, UV + vec2(cos(theta), sin(theta)) * len);
		}
	}
	gaussian_blur /= float(quality * angular_quality);
	vec2 edited_uvs = UV * 0.25 + vec2(0.5-0.125);
	COLOR = gaussian_blur * tint;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
