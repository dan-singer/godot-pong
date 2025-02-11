class_name ImpactVisualizer extends ColorRect

var impactdata_impacts: Array[Vector2]
var impactdata_colors: Array[Color]
var impactdata_directions: Array[Vector2]

var current_impact_row := 0
const MAX_IMPACTS := 64

@onready var animation: AnimationPlayer = $AnimationPlayer;




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	impactdata_colors.resize(MAX_IMPACTS)
	impactdata_directions.resize(MAX_IMPACTS)
	impactdata_impacts.resize(MAX_IMPACTS)
	material.set_shader_parameter("use_test_data", false)


func animate_impact(impact_pos: Vector2, impact_vel: Vector2, color: Color):
	var to_impact = (impact_pos - global_position) / size
	var direction := impact_vel.normalized();
	
	impactdata_colors[current_impact_row] = color
	impactdata_directions[current_impact_row] = direction
	impactdata_impacts[current_impact_row] = to_impact
	#direction = (direction / 2) + Vector2(0.5,0.5);
	#impact_buffer_img.set_pixel(0, current_impact_row, color);
	#impact_buffer_img.set_pixel(1, current_impact_row, Color(to_impact.x, to_impact.y, 0, 1))
	#impact_buffer_img.set_pixel(2 ,current_impact_row, Color(direction.x, direction.y, 0, 1.0));
	#impact_buffer_tex.update(impact_buffer_img);
	#$Sprite2D.texture = impact_buffer_tex
	material.set_shader_parameter("impactdata_colors", impactdata_colors)
	material.set_shader_parameter("impactdata_impacts", impactdata_impacts)
	material.set_shader_parameter("impactdata_directions", impactdata_directions)
	material.set_shader_parameter("impact_row", current_impact_row)
	#material.set_shader_parameter("progress", 1)
	animation.play("impact")
	current_impact_row += 1
	current_impact_row %= MAX_IMPACTS
