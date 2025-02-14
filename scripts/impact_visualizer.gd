class_name ImpactVisualizer extends ColorRect

var impacts: Array[Vector2]
var colors: Array[Color]
var directions: Array[Vector2]

var current_impact_row := 0
const MAX_IMPACTS := 64

@onready var animation: AnimationPlayer = $AnimationPlayer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colors.resize(MAX_IMPACTS)
	directions.resize(MAX_IMPACTS)
	impacts.resize(MAX_IMPACTS)
	material.set_shader_parameter("use_test_data", false)


func animate_impact(impact_pos: Vector2, impact_vel: Vector2, color: Color):
	var to_impact = (impact_pos - global_position) / size
	var direction := impact_vel.normalized();
	
	colors[current_impact_row] = color
	directions[current_impact_row] = direction
	impacts[current_impact_row] = to_impact
	
	material.set_shader_parameter("impactdata_colors", colors)
	material.set_shader_parameter("impactdata_impacts", impacts)
	material.set_shader_parameter("impactdata_directions", directions)
	material.set_shader_parameter("impact_row", current_impact_row)
	
	animation.play("impact")
	current_impact_row += 1
	current_impact_row %= MAX_IMPACTS
