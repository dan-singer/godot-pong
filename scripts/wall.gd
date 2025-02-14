@tool
extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var impact_visualizer: ImpactVisualizer = $ImpactVisualizer

var target_color: Color;
		
func animate_to_color(color: Color):
	target_color = color;
	
func handle_ball_collision(position: Vector2, normal: Vector2, velocity: Vector2, ball_color: Color) -> Vector2:
	impact_visualizer.animate_impact(position, velocity, ball_color)
	return normal;

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		return
	add_to_group("hittable")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
