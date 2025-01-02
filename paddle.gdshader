shader_type canvas_item;

struct ImpactData {
	vec4 color;
	vec2 impact;
	vec2 direction;
};

uniform sampler2D impact_buffer : filter_nearest;
uniform int impact_row = 0;
uniform float aspect = 0.3333;
uniform float border_thickness = 0.1;
uniform vec4 border_color : source_color;
uniform vec4 negative_color : source_color;
uniform bool use_test_data = false;
uniform sampler2D tex;
const int MAX_IMPACTS = 64;
uniform float progress;
uniform float trace_width = 0.12;
void vertex() {
	// Called for every vertex the material is visible on.
}

//float plot(float )

vec4 get_impact_color(int row, float row_progress, vec2 impact_uv) {


	vec2 impact, direction;
	vec4 base_color;
	if (use_test_data)
	{
		vec2 test_impacts[3] = { vec2(1.0, 0.0), vec2(1.0, 0.5), vec2(1.0, 0.75)};
		vec2 test_directions[3] = { vec2(-1.0, 1.0), vec2(-1.0, 0.0), vec2(-1.0, -1.0)};
		vec4 test_colors[3] = {vec4(1.0), vec4(1,0,0,1), vec4(0,1,0,1)};
		impact = test_impacts[row];
		direction = test_directions[row];
		base_color = test_colors[row];
	}
	else
	{
		base_color = texture(impact_buffer, vec2(0.0, float(row) / 64.0));
		impact = texture(impact_buffer, vec2(1.0/3.0, float(row) / 64.0)).xy;
		vec2 direction_normalized = texture(impact_buffer, vec2(2.0/3.0, float(row) / 64.0)).xy;
		direction = mix(vec2(-1,-1), vec2(1.0,1.0), direction_normalized);
	}

	// Impacts go from [0,1] but our UV space won't cover the rectangle necessarily based on aspct
	// We need to map [0,1] to [0,aspect] so it looks better
	impact.x *= aspect;

	// y - y1 = m(x - x1)
	// y - impact.y = m(x - impact.x)
	// y = m(x - impact.x) + impact.y
	float m = direction.y / direction.x;
	float trace = m * (impact_uv.x - impact.x) + impact.y;
	float trace_sdf = abs(impact_uv.y - trace);

	vec4 trace_color =  mix(vec4(0,0,0,1), base_color, 1.0-step(trace_width, trace_sdf));
	vec2 unscaled_uvs = impact_uv / aspect;
	float x_progress = impact.x <= 0.1 ? 1.0 - unscaled_uvs.x : unscaled_uvs.x;
	return mix(vec4(0,0,0,1), trace_color, step(1.0-row_progress, x_progress));
}

void fragment() {
	float height_scale_factor = 1.0 / aspect;
	vec2 scaled_uvs = UV * vec2(1, height_scale_factor);
	float border = scaled_uvs.x < border_thickness || scaled_uvs.x > 1.0 - border_thickness ||
	 scaled_uvs.y < border_thickness  || scaled_uvs.y > height_scale_factor - border_thickness ? 1.0 : 0.0;

	vec2 stretched_uvs = vec2((UV.x * aspect), UV.y);
	vec4 impacts = vec4(0,0,0,1);
	for (int i = 0; i < MAX_IMPACTS; ++i)
	{
		float impact_progress = i < impact_row ? 1.0 : (i == impact_row ? progress : 0.0);
		vec4 color = get_impact_color(i, impact_progress, stretched_uvs);
		impacts = mix(impacts, color, step(0.2, length(color.xyz)));
	}
	COLOR = mix(impacts, border_color, border);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
