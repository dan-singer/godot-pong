@tool
class_name Paddle extends CharacterBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var impact_visualizer: ImpactVisualizer = $ImpactVisualizer
var normalized_velocity: float
var speed = 500

@export var impact_colors: Array[Color]
@export var paddle_size := Vector2(30, 300):
	set(size):
		paddle_size = size
		if Engine.is_editor_hint():
			$CollisionShape2D.shape.size = paddle_size
			$CollisionShape2D.position.x = paddle_size.x / 2
			$CollisionShape2D.position.y = paddle_size.y / 2
			$ImpactVisualizer.size = paddle_size

func get_size() -> Vector2:
	return collision.get_shape().get_rect().size
	
	
func _ready():
	add_to_group("hittable")

	#impact_buffer_img = Image.create(3, MAX_IMPACTS, true, Image.FORMAT_RGBA8)
	#impact_buffer_img.fill(Color.GREEN)
	#impact_buffer_tex = ImageTexture.create_from_image(impact_buffer_img);
	#$Sprite2D.texture = impact_buffer_tex;
	#color_rect.material.set_shader_parameter("impact_buffer", impact_buffer_tex);

func move(in_normalized_velocity : float):
	normalized_velocity = in_normalized_velocity
	
func handle_ball_collision(position: Vector2, normal: Vector2, velocity: Vector2, ball_color: Color) -> Vector2:
	impact_visualizer.animate_impact(position, velocity, ball_color)
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
	

func _physics_process(delta):
	velocity = Vector2(0, normalized_velocity * speed)
	move_and_collide(velocity * delta)
