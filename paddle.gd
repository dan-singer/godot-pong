@tool
class_name Paddle extends CharacterBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var color_rect = $ColorRect
@onready var animation: AnimationPlayer = $AnimationPlayer;
var normalized_velocity: float
var speed = 300

var current_impact_row := 0
var impact_buffer_img: Image;
var impact_buffer_tex: ImageTexture;
const MAX_IMPACTS := 64
@export var impact_colors: Array[Color]

#@export var colors : [Color]

@export var paddle_size := Vector2(30, 300):
	set(size):
		paddle_size = size
		if Engine.is_editor_hint():
			$CollisionShape2D.shape.size = paddle_size
			$CollisionShape2D.position.x = paddle_size.x / 2
			$CollisionShape2D.position.y = paddle_size.y / 2
			$ColorRect.size = paddle_size

func get_size() -> Vector2:
	return collision.get_shape().get_rect().size
	
	
func _ready():
	add_to_group("hittable")
	impact_buffer_img = Image.create(3, MAX_IMPACTS, true, Image.FORMAT_RGBA8)
	#impact_buffer_img.fill(Color.GREEN)
	impact_buffer_tex = ImageTexture.create_from_image(impact_buffer_img);
	$Sprite2D.texture = impact_buffer_tex;
	color_rect.material.set_shader_parameter("impact_buffer", impact_buffer_tex);

func move(in_normalized_velocity : float):
	normalized_velocity = in_normalized_velocity
	
func handle_ball_collision(position: Vector2, normal: Vector2, velocity: Vector2, ball_color: Color) -> Vector2:
	animate_impact(position, velocity, ball_color)
	return get_ball_normal(position, normal)

	
func get_ball_normal(impact_pos : Vector2, normal : Vector2) -> Vector2:
	if abs(normal.dot(Vector2(1,0))) < 0.9:
		return normal
	var height := get_size().y
	var normalized_impact = inverse_lerp(position.y, position.y + height, impact_pos.y)
	var angle_mult = sign(normal.x)
	var normal_mod_angle = lerp(-PI/8 * angle_mult, PI/8 * angle_mult, normalized_impact)
	var rotated_normal = normal.rotated(normal_mod_angle)
	$DebugLine.global_position = impact_pos
	$DebugLine.rotation = normal_mod_angle
	return rotated_normal
	
func animate_impact(impact_pos: Vector2, impact_vel: Vector2, color: Color):
	var to_impact = impact_pos - position
	to_impact /= collision.shape.size
	
	var direction := impact_vel.normalized();
	direction = (direction / 2) + Vector2(0.5,0.5);
	impact_buffer_img.set_pixel(0, current_impact_row, color);
	impact_buffer_img.set_pixel(1, current_impact_row, Color(to_impact.x, to_impact.y, 0, 1))
	impact_buffer_img.set_pixel(2 ,current_impact_row, Color(direction.x, direction.y, 0, 1.0));
	impact_buffer_tex.update(impact_buffer_img);
	$Sprite2D.texture = impact_buffer_tex
	color_rect.material.set_shader_parameter("impact_buffer", impact_buffer_tex)
	color_rect.material.set_shader_parameter("impact", to_impact)
	color_rect.material.set_shader_parameter("direction", impact_vel.normalized())
	color_rect.material.set_shader_parameter("impact_row", current_impact_row)
	animation.play("impact")
	
	current_impact_row += 1
	current_impact_row %= MAX_IMPACTS

func _physics_process(delta):
	velocity = Vector2(0, normalized_velocity * speed)
	move_and_collide(velocity * delta)
