@tool
extends StaticBody2D

@export var top: bool:
	set(in_top):
		top = in_top
		resize()
@onready var collision = $CollisionShape2D
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

var target_color: Color;
func resize():
	if !Engine.is_editor_hint():
		return
	var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var scene_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var wall_base_width = collision.get_shape().get_rect().size.x
	var multiplier = scene_width / wall_base_width
	scale = Vector2(multiplier, 1.0)
	
	if (!top):
		position.y = scene_height - wall_base_width
	else:
		position.y = 0
		
func animate_to_color(color: Color):
	target_color = color;
	animation_player.play("transition");

func apply_target_color():
	var previous_inner_color = color_rect.material.get_shader_parameter("inner_color");
	color_rect.material.set_shader_parameter("outer_color", previous_inner_color);
	color_rect.material.set_shader_parameter("inner_color", target_color);
	
func handle_ball_collision(position: Vector2, normal: Vector2, velocity: Vector2, ball_color: Color) -> Vector2:
	animate_to_color(ball_color)
	return normal;

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		return
	add_to_group("hittable")
	color_rect.material.set_shader_parameter("radius", 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
