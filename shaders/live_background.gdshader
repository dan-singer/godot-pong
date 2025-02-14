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

vec4 gaussianBlur(vec2 uv) {
	vec4 gaussian_blur = vec4(0.0);
	for (int i = 0; i < angular_quality; ++i)
	{
		float theta = float(i) / (2.0 * PI);
		for (int j = 0; j < quality; ++j)
		{
			float len = (float(j) / float(quality)) * radius;
			gaussian_blur += texture(tex, uv + vec2(cos(theta), sin(theta)) * len);
		}
	}
	gaussian_blur /= float(quality * angular_quality);
	return gaussian_blur;
}

void fragment() {
	COLOR = gaussianBlur(UV) * tint;
}

