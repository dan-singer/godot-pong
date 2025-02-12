class_name AIPaddleController extends Node

var paddle: Paddle
var ball: Ball

var desired_velocity = 0.0
var predicted_ball_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paddle = get_child(0)
	ball = get_parent().find_child("Ball")
	ball.ball_bounced.connect(adjust_ball_prediction)

func adjust_ball_prediction():
	await get_tree().create_timer(randf_range(0.1, 0.3)).timeout;
	var x_dist := paddle.global_position.x - ball.position.x
	var time_of_impact = x_dist / ball.vel.x
	predicted_ball_position = ball.position + ball.vel * time_of_impact
	
func _process(delta: float) -> void:
	if ball.vel.x == 0 or ball.vel.dot(paddle.global_position - ball.position) <= 0.0:
		paddle.move(0)
		return
	var paddle_center = paddle.global_position + paddle.get_size() / 2
	if abs(paddle_center.y - predicted_ball_position.y) < 10:
		desired_velocity = 0
	elif paddle_center.y < predicted_ball_position.y:
		desired_velocity = 1
	else:
		desired_velocity = -1
	paddle.move(desired_velocity)
