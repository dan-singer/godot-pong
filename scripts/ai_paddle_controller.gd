class_name AIPaddleController extends Node

var paddle: Paddle
var ball: Ball

var desired_velocity = 0.0
var current_velocity = 0.0
var predicted_ball_position: Vector2
var max_speed := 0.5
var slowing_distance := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paddle = get_child(0)
	ball = get_parent().find_child("Ball")
	ball.ball_bounced.connect(adjust_ball_prediction)

func adjust_ball_prediction():
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var x_dist := paddle.global_position.x - ball.position.x
	var time_of_impact = x_dist / ball.vel.x
	predicted_ball_position = ball.position + ball.vel * time_of_impact
	predicted_ball_position.y = clamp(predicted_ball_position.y, 0, height)
	
	
func _process(delta: float) -> void:
	var ball_to_paddle = paddle.global_position - ball.position
	if ball.vel.x == 0 or sign(ball_to_paddle.x) != sign(ball.vel.x):
		current_velocity = 0
		paddle.move(current_velocity)
		return
	var paddle_center = paddle.global_position + paddle.get_size() / 2
	
	var offset = predicted_ball_position.y - paddle_center.y
	var dist = abs(offset)
	var ramped_speed = max_speed * (dist / slowing_distance)
	var clipped_speed = min(ramped_speed, max_speed)
	desired_velocity = (clipped_speed / dist) * offset
	var steering = desired_velocity - current_velocity
	
	var acceleration = steering 
	current_velocity += acceleration
	if abs(current_velocity) > 1:
		current_velocity = sign(current_velocity)
	paddle.move(current_velocity)
