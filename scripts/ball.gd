class_name Ball extends CharacterBody2D

var speed = 750
var vel := Vector2.ZERO

@export var colors : Array[Color];
var current_color : Color;

@onready var color_rect = $ColorRect
signal ball_bounced()

func _ready():
	update_color()
	
func update_color():
	current_color = colors.pick_random()
	color_rect.material.set_shader_parameter("inner_color", current_color);
	
func stop_ball():
	vel = Vector2.ZERO
	
func launch_at_random_angle():
	var angle := randf_range(-PI/4, PI/4)
	if randi() % 2 == 1:
		angle += PI
	var dir := Vector2.from_angle(angle)
	vel = dir * speed
	ball_bounced.emit()
	
func clamp_vector_by_angle(v: Vector2, angle: float) -> Vector2:
	var absolute_vector := v.abs()
	if absolute_vector.angle() > angle:
		var constrained = v.length() * Vector2(cos(angle), sin(angle))
		if v.x < 0:
			constrained.x *= -1
		if v.y < 0:
			constrained.y *= -1
		return constrained
	return v
	
func _physics_process(delta):
	var collision := move_and_collide(vel * delta);
	if collision:
		var normal := Vector2.ZERO
		var collider = collision.get_collider()
		if (collider.is_in_group("hittable")):
			normal = collider.handle_ball_collision(collision.get_position(), collision.get_normal(), vel, current_color)
			update_color()
		vel = -vel.reflect(normal)
		vel = clamp_vector_by_angle(vel, PI/4)
		ball_bounced.emit()
